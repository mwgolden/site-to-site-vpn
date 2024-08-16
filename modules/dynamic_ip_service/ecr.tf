resource "aws_ecr_repository" "terraform_runner" {
    name = "com.wgolden.terraform-runner"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "null_resource" "docker_push" {
    depends_on = [ aws_ecr_repository.terraform_runner ]
    provisioner "local-exec" {
      command = <<EOT
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws ecr describe-repositories --repository-names com.wgolden.terraform-runner --region us-east-1 --query 'repositories[0].repositoryUri' --output text)
        docker build -t terraform-runner ./docker
        docker tag terraform-runner:latest $(aws ecr describe-repositories --repository-names com.wgolden.terraform-runner --region us-east-1 --query 'repositories[0].repositoryUri' --output text):latest
        docker push $(aws ecr describe-repositories --repository-names com.wgolden.terraform-runner --region us-east-1 --query 'repositories[0].repositoryUri' --output text):latest
      EOT
    }
}