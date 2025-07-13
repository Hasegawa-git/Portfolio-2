output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ssm_role_arn" {
  description = "ARN of the SSM Session Manager Role"
  value       = aws_iam_role.ssm_role.arn
}
