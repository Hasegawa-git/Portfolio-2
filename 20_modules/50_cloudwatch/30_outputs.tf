# AWS CloudWatch Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. CloudWatch Log Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "log_group_name" {
  description = "The name of the created CloudWatch Log Group."
  value       = aws_cloudwatch_log_group.main.name
}

output "log_group_arn" {
  description = "The ARN of the created CloudWatch Log Group."
  value       = aws_cloudwatch_log_group.main.arn
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. CloudWatch Alarm Outputs (Optional)
# ----------------------------------------------------------------------------------------------------------------------

output "alarm_arns" {
  description = "A map of created CloudWatch alarm names to their ARNs."
  value       = { for name, alarm in aws_cloudwatch_metric_alarm.custom_alarms : name => alarm.arn }
  sensitive   = true # アラームARNは機密情報ではないが、念のため
}

output "alarm_names" {
  description = "A list of names of the created CloudWatch alarms."
  value       = [for alarm in aws_cloudwatch_metric_alarm.custom_alarms : alarm.alarm_name]
}