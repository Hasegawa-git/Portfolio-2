# AWS IAM Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. IAM Role Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "iam_role_arns" {
  description = "A map of created IAM role names to their ARNs."
  value       = { for name, role in aws_iam_role.roles : name => role.arn }
}

output "iam_role_names" {
  description = "A map of created IAM role names to their full names."
  value       = { for name, role in aws_iam_role.roles : name => role.name }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. IAM Managed Policy Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "iam_policy_arns" {
  description = "A map of created IAM managed policy names to their ARNs."
  value       = { for name, policy in aws_iam_policy.policies : name => policy.arn }
}

output "iam_policy_names" {
  description = "A map of created IAM managed policy names to their full names."
  value       = { for name, policy in aws_iam_policy.policies : name => policy.name }
}