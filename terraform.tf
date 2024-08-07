terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "com.wgolden.tfstate"
    key    = "site-to-site-vpn/tfstate"
    region = "us-east-1"
  }
}
