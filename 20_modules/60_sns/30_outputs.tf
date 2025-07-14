# AWS SNS Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. SNS Topic Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "sns_topic_arn" {
  description = "The ARN of the SNS topic."
  value       = aws_sns_topic.main.arn
}

output "sns_topic_name" {
  description = "The name of the SNS topic."
  value       = aws_sns_topic.main.name
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. SNS Subscription Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "sns_subscription_arns" {
  description = "A map of subscription endpoints to their ARNs."
  value       = { for k, v in aws_sns_topic_subscription.subscriptions : k => v.arn }
}