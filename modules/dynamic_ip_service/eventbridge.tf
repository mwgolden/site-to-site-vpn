resource "aws_cloudwatch_event_rule" "ip_address_update_event" {
  name        = "dynamic-ip-update"
  description = "Capture event from dynamic ip service lambda"
  event_pattern = jsonencode({
    "source" : ["dynamic.ip.service"]
  })
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.ip_address_update_event.name
  target_id = "dynamic-ip-cloudwatch-log"
  arn       = aws_cloudwatch_log_group.log.arn
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/events/dynamic-ip-service"
  retention_in_days = 1
}

resource "aws_iam_role" "ecs_eventbridge_role" {
    name = "ecs_eventbridge_task_execution_role"
    assume_role_policy = data.aws_iam_policy_document.eventbridge_assume_role.json
}

resource "aws_iam_policy" "eventbridge_policy" {
  name        = "aws_eventbridge_policy"
  description = "AWS IAM Policy for managing aws eventbridge ecs role"
  policy      = data.aws_iam_policy_document.event_bridge_ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_eventbridge_iam_policy_to_role" {
  role       = aws_iam_role.ecs_eventbridge_role.name
  policy_arn = aws_iam_policy.eventbridge_policy.arn
}

resource "aws_cloudwatch_event_target" "ecs_target" {
  rule      = aws_cloudwatch_event_rule.ip_address_update_event.name
  target_id = "dynamic-ip-ecs-task"
  arn       = aws_ecs_cluster.ecs_cluster.arn
  role_arn = aws_iam_role.ecs_eventbridge_role.arn
  ecs_target {
    task_definition_arn = aws_ecs_task_definition.terraform_runner.arn
    launch_type = "FARGATE"
    network_configuration {
      subnets = var.public_subnets
      assign_public_ip = true
    }
  }
  input_transformer {
    input_paths = {
      "ipaddress" = "$.detail.ipaddress"
      "local_cidr" = "$.detail.local_cidr"
      "network_cidr" = "$.detail.network_cidr"
    }
    input_template = <<EOF
        {
            "containerOverrides": [
                {
                    "name": "terraform-runner",
                    "environment": [
                        {
                            "name": "CUSTOMER_GATEWAY_ADDRESS",
                            "value": "<ipaddress>"
                        },
                        {
                            "name": "LOCAL_NETWORK_CIDR",
                            "value": "<local_cidr>"
                        },
                        {
                            "name": "REMOTE_NETWORK_CIDR",
                            "value": "<network_cidr>"
                        }
                    ]
                }
            ]
        }
    EOF
  }
}