# 10_env/10_dev/30_outputs.tf

# ----------------------------------------------------------------------------------------------------------------------
# 1. VPC Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "A list of public subnet IDs in the VPC."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "A list of private subnet IDs in the VPC."
  value       = module.vpc.private_subnet_ids
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. ALB Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer."
  value       = module.alb.alb_arn
}

output "alb_security_group_id" {
  description = "The ID of the security group attached to the ALB."
  value       = module.alb.alb_security_group_id
}

output "http_target_group_arn" {
  description = "The ARN of the HTTP target group."
  value       = module.alb.http_target_group_arn
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ECS Fargate Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster."
  value       = module.ecs_fargate.ecs_cluster_arn
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service."
  value       = module.ecs_fargate.ecs_service_arn
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = module.ecs_fargate.ecs_task_definition_arn
}

output "ecs_task_security_group_id" {
  description = "The ID of the security group attached to the ECS tasks."
  value       = module.ecs_fargate.ecs_task_security_group_id
}

output "ecs_log_group_name" {
  description = "The name of the CloudWatch Log Group for ECS tasks."
  value       = module.ecs_fargate.ecs_log_group_name
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. RDS Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "db_instance_address" {
  description = "The DNS address of the RDS instance."
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "The port of the RDS instance."
  value       = module.rds.db_instance_port
}

output "db_name" {
  description = "The name of the database created."
  value       = module.rds.db_name
}

output "db_username" {
  description = "The master username for the DB instance."
  value       = module.rds.db_username
}

output "rds_security_group_id" {
  description = "The ID of the security group attached to the RDS instance."
  value       = module.rds.rds_security_group_id
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. IAM Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "iam_role_arns" {
  description = "A map of created IAM role names to their ARNs."
  value       = module.iam.iam_role_arns
}

output "iam_role_names" {
  description = "A map of created IAM role names to their full names."
  value       = module.iam.iam_role_names
}

output "iam_policy_arns" {
  description = "A map of created IAM managed policy names to their ARNs."
  value       = module.iam.iam_policy_arns
}

# ----------------------------------------------------------------------------------------------------------------------
# 6. SNS Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "sns_alarm_topic_arn" {
  description = "The ARN of the SNS topic used for alarms."
  value       = module.sns_alarms.sns_topic_arn
}

output "sns_alarm_topic_name" {
  description = "The name of the SNS topic used for alarms."
  value       = module.sns_alarms.sns_topic_name
}

# ----------------------------------------------------------------------------------------------------------------------
# 7. CloudWatch Module Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "cloudwatch_ecs_log_group_name" {
  description = "The name of the CloudWatch Log Group for ECS application logs."
  value       = module.cloudwatch_ecs_logs.log_group_name
}

output "cloudwatch_ecs_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for ECS application logs."
  value       = module.cloudwatch_ecs_logs.log_group_arn
}

output "cloudwatch_ecs_alarm_arns" {
  description = "A map of created CloudWatch alarm names to their ARNs for ECS."
  value       = module.cloudwatch_ecs_logs.alarm_arns
}