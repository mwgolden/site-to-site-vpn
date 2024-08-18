data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:List*"
    ]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "events:PutEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role" {
  
  statement {
    effect = "Allow"
    actions = [
      "ecr:*",
      "logs:*",
      "iam:*",
      "ec2:*",
      "ecs:*",
      "events:*",
      "s3:*",
      "lambda:*",
      "apigateway:*",
      "elasticfilesystem:*"
    ]
    resources = [ "*" ]
  }

  statement {
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [ "arn:aws:ec2:*:*:vpc/*" ]
  }
}

data "aws_iam_policy_document" "eventbridge_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "event_bridge_ecs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "iam:PassRole"
    ]
    resources = [ "*" ]
  }
}