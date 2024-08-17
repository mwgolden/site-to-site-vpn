variable "aws_profile" {
  type    = string
  default = "default"
}

variable "vpn_customer_gateway" {
  description = "The ip address of the customer gateway"
  type        = string
}

variable "local_network_cidr" {
  description = "cidr block of the local network"
  type        = string
}

variable "remote_network_cidr" {
  description = "cidr block of the remote (aws) network"
  type        = string
}

data "aws_availability_zones" "east" {
  provider = aws
}

variable "use_profile" {
  type = bool
  default = false
}