module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = var.remote_network_cidr
  availability_zones = tolist(data.aws_availability_zones.east.names)
  providers = {
    aws = aws
  }
}

module "vpn" {
  depends_on            = [module.vpc]
  source                = "./modules/vpn"
  vpc_id                = module.vpc.vpc_id
  customer_gateway_ip   = var.vpn_customer_gateway
  local_network         = var.local_network_cidr
  remote_network        = var.remote_network_cidr
  public_route_table_id = module.vpc.route_tables.public
  providers = {
    aws = aws
  }
}

module "dynamic_ip_service" {
  source = "./modules/dynamic_ip_service"
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  providers = {
    aws = aws
  }
}

data "aws_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group_rule" "allow_nfs" {
  security_group_id = data.aws_security_group.default.id
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.local_network_cidr]
}

resource "aws_efs_file_system" "efs" {
  tags = {
    Name = "MyEFSDrive"
  }
}

locals {
  public_subnet_map = {
    for idx, subnet_id in module.vpc.public_subnets : idx => subnet_id
  }
}
resource "aws_efs_mount_target" "target" {
  for_each        = local.public_subnet_map
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = [data.aws_security_group.default.id]
}
