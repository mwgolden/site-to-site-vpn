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

resource "aws_efs_file_system" "efs" {
  tags = {
    Name = "MyEFSDrive"
  }
}

resource "aws_efs_mount_target" "target" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.remote_network_cidr
}
