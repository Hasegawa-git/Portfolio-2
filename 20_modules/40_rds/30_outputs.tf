# AWS RDS Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. RDS Instance Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "db_instance_address" {
  description = "The DNS address of the RDS instance."
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "The port of the RDS instance."
  value       = aws_db_instance.main.port
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.main.arn
}

output "db_instance_id" {
  description = "The ID of the RDS instance."
  value       = aws_db_instance.main.id
}

output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance."
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "The name of the database created."
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "The master username for the DB instance."
  value       = aws_db_instance.main.username
}

# NOTE: For security reasons, the password is NOT outputted here.
#       Use AWS Secrets Manager to retrieve secrets in a secure way.

# ----------------------------------------------------------------------------------------------------------------------
# 2. Security Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "rds_security_group_id" {
  description = "The ID of the security group attached to the RDS instance."
  value       = aws_security_group.rds_db.id
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. DB Subnet Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "db_subnet_group_name" {
  description = "The name of the DB Subnet Group."
  value       = aws_db_subnet_group.main.name
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB Subnet Group."
  value       = aws_db_subnet_group.main.arn
}