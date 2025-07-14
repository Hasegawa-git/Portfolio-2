# AWS ALB Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. ALB Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "alb_arn" {
  description = "The ARN of the Application Load Balancer."
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The Route 53 Hosted Zone ID of the Application Load Balancer."
  value       = aws_lb.main.zone_id
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. Security Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "alb_security_group_id" {
  description = "The ID of the security group attached to the ALB."
  value       = aws_security_group.alb.id
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. Target Group Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "http_target_group_arn" {
  description = "The ARN of the HTTP target group."
  value       = aws_lb_target_group.http.arn
}

output "http_target_group_name" {
  description = "The Name of the HTTP target group."
  value       = aws_lb_target_group.http.name
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. HTTPS Target Group Output (Conditional)
# ----------------------------------------------------------------------------------------------------------------------

output "https_target_group_arn" {
  description = "The ARN of the HTTPS target group (if enabled)."
  value       = try(aws_lb_target_group.https[0].arn, null) # HTTPSが有効な場合のみ出力
}

output "https_target_group_name" {
  description = "The Name of the HTTPS target group (if enabled)."
  value       = try(aws_lb_target_group.https[0].name, null)
}