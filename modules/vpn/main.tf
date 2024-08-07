resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name = "Customer Gateway"
  }
}

resource "aws_vpn_gateway" "vpn_gateway" {
  tags = {
    Name = "vpn gateway"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = var.vpc_id
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
}

resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id      = aws_customer_gateway.customer_gateway.id
  vpn_gateway_id           = aws_vpn_gateway.vpn_gateway.id
  type                     = "ipsec.1"
  local_ipv4_network_cidr  = var.local_network
  remote_ipv4_network_cidr = var.remote_network
  static_routes_only       = true
}

resource "aws_vpn_connection_route" "office" {
  destination_cidr_block = var.local_network
  vpn_connection_id      = aws_vpn_connection.vpn_connection.id
}

resource "aws_vpn_gateway_route_propagation" "route_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = var.public_route_table_id
}

data "aws_security_group" "default" {
  vpc_id = var.vpc_id
  filter {
    name = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group_rule" "allow_nfs" {
  security_group_id = data.aws_security_group.default.id
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_blocks = [var.local_network]
}