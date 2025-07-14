# AWS ALB Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. Application Load Balancer (ALB)
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false # インターネット向けALB
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id] # ALB用セキュリティグループを関連付け
  subnets            = var.public_subnet_ids # パブリックサブネットに配置

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. ALB用セキュリティグループ
#    - インターネットからのHTTP/HTTPSアクセスを許可
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  # インバウンドルール: HTTP (80)
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 全てのIPからのアクセスを許可
  }

  # インバウンドルール: HTTPS (443)
  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 全てのIPからのアクセスを許可
  }

  # アウトバウンドルール: 全て許可 (デフォルト)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 は全てのプロトコル
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ターゲットグループ (HTTP)
#    - ALBからのトラフィックを受け取るEC2インスタンスやECSタスクを登録するグループ
#    - デフォルトのHTTPリスナー用
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "http" {
  name        = "${var.project_name}-${var.environment}-tg-http"
  port        = 80 # ターゲットがリッスンするポート
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # ECS Fargateの場合、IPアドレスでターゲットを登録

  health_check {
    path                = "/" # ヘルスチェックパス (アプリケーションに合わせて変更)
    protocol            = "HTTP"
    port                = "traffic-port" # トラフィックが送られるポートと同じ
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = "200" # 200 OK を期待
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-tg-http"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. ALBリスナー (HTTP)
#    - ALBが受信するトラフィックのポートとプロトコルを定義
#    - HTTP (80) -> ターゲットグループ (HTTP) へ転送
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.http.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-listener-http"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. (オプション) ターゲットグループ (HTTPS) と ALBリスナー (HTTPS)
#    - HTTPSを使用する場合に設定。ACM証明書が必要。
# ----------------------------------------------------------------------------------------------------------------------
/*
# ターゲットグループ (HTTPS)
resource "aws_lb_target_group" "https" {
  count       = var.enable_https ? 1 : 0 # HTTPSを有効にする場合にのみ作成
  name        = "${var.project_name}-${var.environment}-tg-https"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-tg-https"
    Environment = var.environment
  }
}

# ALBリスナー (HTTPS)
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn # ACMで発行した証明書のARNを指定

  default_action {
    target_group_arn = aws_lb_target_group.https[0].arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-listener-https"
    Environment = var.environment
  }
}
*/