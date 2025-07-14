# AWS ECS Fargate Module - variables.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. General Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "project_name" {
  description = "The name of the project. Used for naming resources and tags."
  type        = string
  default     = "Portfolio-2"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod, stg). Used for naming resources and tags."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are deployed."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. Network Integration Variables (VPC/ALBモジュールからの入力)
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC where ECS Fargate tasks will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where ECS Fargate tasks will be deployed."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the ALB's security group. Used to allow inbound traffic from ALB to ECS tasks."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the ALB target group to register ECS tasks with."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ECS Task Definition Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "app_container_name" {
  description = "The name of the application container within the task definition."
  type        = string
  default     = "nginx" 
}

variable "app_image_url" {
  description = "The Docker image URL for the application container (e.g., ECR URI)."
  type        = string
  default     = "nginx:latest" 
}

variable "app_container_port" {
  description = "The port on which the application container listens."
  type        = number
  default     = 80 # デフォルトはHTTPの80番ポート
}

variable "fargate_cpu" {
  description = "The amount of CPU (in CPU units) to reserve for the task."
  type        = number
  default     = 256 
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.fargate_cpu)
    error_message = "fargate_cpu must be one of 256, 512, 1024, 2048, or 4096."
  }
}

variable "fargate_memory" {
  description = "The amount of memory (in MiB) to reserve for the task."
  type        = number
  default     = 512 
  validation {
    condition     = var.fargate_memory >= 512 && var.fargate_memory <= 30720
    error_message = "fargate_memory must be between 512 MiB and 30720 MiB."
  }
}

variable "app_container_cpu" {
  description = "The number of CPU units to reserve for the application container. Should be less than or equal to fargate_cpu."
  type        = number
  default     = 256
}

variable "app_container_memory" {
  description = "The amount of memory (in MiB) to reserve for the application container. Should be less than or equal to fargate_memory."
  type        = number
  default     = 512
}

variable "container_environment_variables" {
  description = "A list of key-value pairs to set as environment variables inside the container."
  type        = list(object({
    name  = string
    value = string
  }))
  default     = [] # 例: [{"name" = "DATABASE_HOST", "value" = "my-rds.xxxx.rds.amazonaws.com"}]
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. ECS Service Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "desired_count" {
  description = "The number of instances of the task definition that should be running in the service."
  type        = number
  default     = 1 
}

variable "log_retention_days" {
  description = "The number of days to retain CloudWatch Logs for ECS tasks."
  type        = number
  default     = 30 # 30日間ログを保持
}