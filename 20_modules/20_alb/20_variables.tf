# AWS ALB Module - variables.tf
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

# ----------------------------------------------------------------------------------------------------------------------
# 2. Network Integration Variables (VPCモジュールからの入力)
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs where the ALB will be deployed."
  type        = list(string)
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ALB Specific Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "alb_name_prefix" {
  description = "Prefix for the ALB name. Default will be project_name-environment-alb."
  type        = string
  default     = "" # デフォルトは空。main.tfで完全な名前を生成
}

variable "enable_https" {
  description = "Set to true to enable HTTPS listener for the ALB. Requires 'acm_certificate_arn'."
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate to use for the HTTPS listener. Required if enable_https is true."
  type        = string
  default     = null # HTTPSを有効にする場合は必須
}

variable "target_group_port" {
  description = "The port on which the targets in the target group listen."
  type        = number
  default     = 80 
}

variable "target_group_protocol" {
  description = "The protocol for the target group (HTTP or HTTPS)."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The destination for the health check request."
  type        = string
  default     = "/"
}