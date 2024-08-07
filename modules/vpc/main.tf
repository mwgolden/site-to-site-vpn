resource "aws_vpc" "vpc" {
  provider             = aws
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name      = "VPC site to site VPN Lab"
    Terraform = "true"
  }
}

resource "aws_subnet" "private_subnets" {
  provider          = aws
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value + 1)
  availability_zone = var.availability_zones[each.value]
  tags = {
    Name      = "private_subnet_${each.value}"
    Terraform = "true"
  }
}

resource "aws_subnet" "public_subnets" {
  provider          = aws
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value + 2)
  availability_zone = var.availability_zones[each.value]
  tags = {
    Name      = "public_subnet_${each.value}"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name      = "Internet Gateway"
    Terraform = "true"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}