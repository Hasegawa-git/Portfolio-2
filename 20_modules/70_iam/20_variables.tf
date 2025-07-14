# AWS IAM Module - variables.tf
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
# 2. IAM Role Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "iam_roles" {
  description = "A list of IAM roles to create."
  type = list(object({
    name                 = string # ロール名のサフィックス 
    assume_role_policy_json = string # ロールを引き受けるポリシー (JSON)
    description          = optional(string)
    max_session_duration = optional(number) 

    # アタッチする管理ポリシーのARN (例: "arn:aws:iam::aws:policy/AmazonECSTaskExecutionRolePolicy")
    attach_managed_policy_arns = optional(list(string), [])

    # インラインポリシーの定義
    inline_policies = optional(list(object({
      name        = string # インラインポリシー名
      policy_json = string # ポリシー内容 (JSON)
    })), [])
  }))
  default     = [] # デフォルトではロールを作成しない
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. IAM Managed Policy Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "iam_policies" {
  description = "A list of IAM managed policies to create."
  type = list(object({
    name        = string # ポリシー名のサフィックス
    policy_json = string # ポリシー内容 (JSON)
    description = optional(string)
  }))
  default     = [] # デフォルトではポリシーを作成しない
}