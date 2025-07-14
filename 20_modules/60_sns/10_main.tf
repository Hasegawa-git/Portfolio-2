# AWS SNS Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. SNS Topic
#    - メッセージを公開するためのトピック。CloudWatchアラームやLambdaなどからの通知先となる
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_sns_topic" "main" {
  name                          = "${var.project_name}-${var.environment}-${var.topic_name_suffix}"
  display_name                  = "${var.project_name} ${var.environment} ${var.topic_name_suffix}"
  fifo_topic                    = var.fifo_topic
  content_based_deduplication   = var.fifo_topic && var.content_based_deduplication

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.topic_name_suffix}"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. SNS Topic Policy (Optional)
#    - CloudWatchなど、他のサービスからのメッセージ発行を許可するためのポリシー
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_sns_topic_policy" "main" {
  count  = var.attach_policy ? 1 : 0
  arn    = aws_sns_topic.main.arn
  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = var.attach_policy ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"] # CloudWatchからのPublishを許可
    }
    resources = [aws_sns_topic.main.arn]
  }

  statement {
    effect  = "Allow"
    actions = ["SNS:Subscribe", "SNS:Receive"]
    principals {
      type        = "AWS"
      identifiers = ["*"] # 特定のAWSアカウントからのSubscribe/Receiveを許可する場合は限定する
    }
    resources = [aws_sns_topic.main.arn]
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. SNS Topic Subscriptions
#    - SNSトピックにメッセージを受信するエンドポイント（メール、Lambdaなど）
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_sns_topic_subscription" "subscriptions" {
  for_each = { for sub in var.subscriptions : "${sub.protocol}-${sub.endpoint}" => sub }

  topic_arn = aws_sns_topic.main.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
  # raw_message_delivery = true # オプション: メッセージを生のJSON形式で送信するかどうか
}