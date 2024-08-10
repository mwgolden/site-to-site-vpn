resource "aws_s3_bucket" "bucket" {
    bucket = "com.wgolden.dynamic-ip-cache"
    force_destroy = true
    tags = {
        Name = "Dynamic IP Cache"
        Terraform = "true"
    }
}