# AWS IAM Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. IAM Roles
#    - 特定のAWSサービスやユーザーがAWSリソースにアクセスするための権限を定義
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "roles" {
  for_each = { for role in var.iam_roles : role.name => role }

  name               = "${var.project_name}-${var.environment}-${each.value.name}"
  assume_role_policy = each.value.assume_role_policy_json

  # Optional settings
  description        = lookup(each.value, "description", null)
  max_session_duration = lookup(each.value, "max_session_duration", null) # Session duration in seconds

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.value.name}"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. IAM Managed Policies
#    - 再利用可能なIAMポリシーを作成
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "policies" {
  for_each = { for policy in var.iam_policies : policy.name => policy }

  name        = "${var.project_name}-${var.environment}-${each.value.name}"
  description = lookup(each.value, "description", null)
  policy      = each.value.policy_json

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.value.name}"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. IAM Role Policy Attachments
#    - 作成したロールにポリシー（管理ポリシーまたはインラインポリシー）をアタッチ
# ----------------------------------------------------------------------------------------------------------------------

# 管理ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "managed_attachments" {
  for_each = {
    for attachment in flatten([
      for role in var.iam_roles : [
        for managed_policy_arn in lookup(role, "attach_managed_policy_arns", []) : {
          role_name          = "${var.project_name}-${var.environment}-${role.name}"
          policy_arn_or_name = managed_policy_arn
          attachment_key     = "${role.name}-${replace(managed_policy_arn, ":", "-")}" # 一意なキーを生成
        }
      ]
    ]) : attachment.attachment_key => attachment
  }

  role       = each.value.role_name
  policy_arn = each.value.policy_arn_or_name
}

# インラインポリシーのアタッチ
resource "aws_iam_role_policy" "inline_policies" {
  for_each = {
    for inline_policy in flatten([
      for role in var.iam_roles : [
        for policy in lookup(role, "inline_policies", []) : {
          role_name  = "${var.project_name}-${var.environment}-${role.name}"
          policy_name = policy.name
          policy_json = policy.policy_json
          attachment_key = "${role.name}-${policy.name}"
        }
      ]
    ]) : inline_key => inline_policy
  }

  name   = each.value.policy_name
  role   = each.value.role_name
  policy = each.value.policy_json
}