variable "public_subnets" {
  default = {
    "public_subnet" = 0
  }
}

variable "private_subnets" {
  default = {
    "private_subnet" = 0
  }
}

variable "availability_zones" {
  type = list(string)
}

variable "cidr_block" {
    description = "The cidr block for the vpc"
    type = string
}
