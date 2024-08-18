data "aws_caller_identity" "account" {}

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "dyn-ip-svc-cluster"
}

 resource "aws_ecs_task_definition" "terraform_runner" {
    family = "terraform-runner-task"
    requires_compatibilities = [ "FARGATE" ]
    network_mode = "awsvpc"
    cpu = 256
    memory = 512
    container_definitions = templatefile(
        "${path.module}/ecs-tf-runner.def.json", 
        { 
            account_number = data.aws_caller_identity.account.account_id 
        })
    execution_role_arn = aws_iam_role.ecs_role.arn
    task_role_arn = aws_iam_role.ecs_role.arn
 }

 resource "aws_iam_role" "ecs_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "aws_ecs_policy"
  description = "AWS IAM Policy for managing aws ecs role"
  policy      = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "attach_ecs_iam_policy_to_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}