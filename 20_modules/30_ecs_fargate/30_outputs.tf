# AWS ECS Fargate Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. ECS Cluster Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster."
  value       = aws_ecs_cluster.main.arn
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. ECS Task Definition Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = aws_ecs_task_definition.main.arn
}

output "ecs_task_definition_family" {
  description = "The family of the ECS task definition."
  value       = aws_ecs_task_definition.main.family
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ECS Service Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_service_id" {
  description = "The ID of the ECS service."
  value       = aws_ecs_service.main.id
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service."
  value       = aws_ecs_service.main.arn
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. Security Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_task_security_group_id" {
  description = "The ID of the security group attached to the ECS tasks."
  value       = aws_security_group.ecs_task.id
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. IAM Role Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS task role."
  value       = aws_iam_role.ecs_task_role.arn
}

# ----------------------------------------------------------------------------------------------------------------------
# 6. CloudWatch Log Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_log_group_name" {
  description = "The name of the CloudWatch Log Group for ECS tasks."
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "ecs_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for ECS tasks."
  value       = aws_cloudwatch_log_group.ecs_logs.arn
}