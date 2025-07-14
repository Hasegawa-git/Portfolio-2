# AWS CloudWatch Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. CloudWatch Log Group
#    - アプリケーションやサービスのログを保存するためのロググループ
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "main" {
  name              = "/${var.project_name}/${var.environment}/${var.log_group_name_suffix}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.log_group_name_suffix}"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. CloudWatch Metric Alarms (Optional)
#    - 変数で定義されたアラームを作成
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "custom_alarms" {
  for_each = { for alarm in var.alarms : alarm.alarm_name => alarm }

  alarm_name          = each.value.alarm_name
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  statistic           = each.value.statistic
  period              = each.value.period
  evaluation_periods  = each.value.evaluation_periods
  threshold           = each.value.threshold
  comparison_operator = each.value.comparison_operator

  alarm_description = lookup(each.value, "alarm_description", null)
  dimensions        = lookup(each.value, "dimensions", null)
  treat_missing_data = lookup(each.value, "treat_missing_data", "missing") # デフォルトはmissing
  actions_enabled   = lookup(each.value, "actions_enabled", true)

  # アラームアクション
  alarm_actions           = lookup(each.value, "alarm_actions", [])
  ok_actions              = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.value.alarm_name}"
    Environment = var.environment
  }
}