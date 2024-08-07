
variable "customer_gateway_ip" {
  description = "The ip address of of the customer gateway"
  type        = string
}

variable "vpc_id" {
  description = "The VPC id used by the VPN"
  type = string
}

variable "public_route_table_id" {
  description = "id of the vpc public route table"
  type = string
}

variable "local_network" {
  description = "Local network CIDR"
  type = string
}

variable "remote_network" {
  description = "Remote network cidr"
  type = string
}