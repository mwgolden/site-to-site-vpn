provider "aws" {
  region  = "us-east-1"
  profile = var.use_profile ? var.aws_profile : null
}
