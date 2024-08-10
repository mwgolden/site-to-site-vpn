resource "aws_cloudwatch_event_rule" "ip_address_update_event" {
  name        = "dynamic-ip-update"
  description = "Capture event from dynamic ip service lambda"
  event_pattern = jsonencode({
    "source" : ["dynamic.ip.service"]
  })
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.ip_address_update_event.name
  target_id = "dynamic-ip-service"
  arn       = aws_cloudwatch_log_group.log.arn
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/events/dynamic-ip-service"
  retention_in_days = 1
}