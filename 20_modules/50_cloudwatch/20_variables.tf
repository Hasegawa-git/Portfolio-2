# AWS CloudWatch Module - variables.tf
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

# ----------------------------------------------------------------------------------------------------------------------
# 2. CloudWatch Log Group Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "log_group_name_suffix" {
  description = "A unique suffix for the CloudWatch Log Group name (e.g., 'ecs-app', 'alb-access')."
  type        = string
}

variable "log_retention_days" {
  description = "The number of days to retain log events. Valid values are 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 10953."
  type        = number
  default     = 30
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. CloudWatch Alarm Variables (Optional)
#    - モジュール内で複数のアラームを定義する場合に備えてリスト形式にする
# ----------------------------------------------------------------------------------------------------------------------

variable "alarms" {
  description = "A list of CloudWatch alarms to create."
  type = list(object({
    alarm_name          = string
    metric_name         = string
    namespace           = string
    statistic           = string # SampleCount, Average, Sum, Minimum, Maximum
    period              = number # in seconds
    evaluation_periods  = number
    threshold           = number
    comparison_operator = string # GreaterThanOrEqualToThreshold, LessThanOrEqualToThreshold, etc.
    alarm_description   = optional(string)
    dimensions          = optional(map(string)) 
    treat_missing_data  = optional(string) # notBreaching, breaching, ignore, missing
    actions_enabled     = optional(bool, true) 

    # アラームアクション用のSNSトピックARNs (SNSモジュールからの出力を使用)
    alarm_actions = optional(list(string))
    ok_actions    = optional(list(string))
    insufficient_data_actions = optional(list(string))
  }))
  default     = [] # デフォルトではアラームを作成しない
}