# AWS SNS Module - variables.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. General Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "project_name" {
  description = "The name of the project. Used for naming resources."
  type        = string
  default     = "Portfolio-2"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod, stg). Used for naming resources."
  type        = string
}

variable "topic_name_suffix" {
  description = "A unique suffix for the SNS topic name (e.g., 'alarms', 'notifications')."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. SNS Topic Configuration Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "fifo_topic" {
  description = "Whether the topic is a FIFO topic. If true, `content_based_deduplication` can also be enabled."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics. Requires `fifo_topic` to be true."
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = "Set to true to attach a default policy allowing CloudWatch to publish."
  type        = bool
  default     = true # CloudWatchアラームで利用することを想定し、デフォルトでポリシーを付与
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. SNS Subscription Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "subscriptions" {
  description = "A list of SNS topic subscriptions."
  type = list(object({
    protocol = string # "email", "sms", "sqs", "lambda", "https" など
    endpoint = string # プロトコルに応じたエンドポイント 
  }))
  default     = [] # デフォルトでは購読者なし
  validation {
    condition     = alltrue([for s in var.subscriptions : contains(["email", "sms", "sqs", "lambda", "https"], s.protocol)])
    error_message = "Supported protocols are 'email', 'sms', 'sqs', 'lambda', 'https'."
  }
}