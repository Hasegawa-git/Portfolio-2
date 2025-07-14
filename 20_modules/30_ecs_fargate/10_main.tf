# AWS ECS Fargate Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. ECS Cluster
#    - ECSタスクを実行するための論理的なグループ
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. IAM Role for ECS Task Execution
#    - FargateタスクがECSサービスと通信し、EFS、ECRなどのリソースにアクセスするための権限
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-task-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. IAM Role for ECS Task
#    - ECSタスクがアプリケーションレベルでAWSサービスにアクセスするための権限
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-task-role"
    Environment = var.environment
  }
}

# 現状は最小限のポリシー（CloudWatch Logsへの書き込みなど）
# resource "aws_iam_role_policy_attachment" "ecs_task_role_cloudwatch" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess" # より適切なポリシーを選択
# }


# ----------------------------------------------------------------------------------------------------------------------
# 4. ECS Task Definition
#    - アプリケーションコンテナの定義、CPU/メモリ、IAMロールなどを指定
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn # アプリケーションがAWSサービスにアクセスする場合

  # コンテナ定義 (JSON形式)
  container_definitions = jsonencode([
    {
      name        = var.app_container_name
      image       = var.app_image_url # ECRのリポジトリURI
      essential   = true
      cpu         = var.app_container_cpu # タスク定義全体のCPUから割り当て
      memory      = var.app_container_memory # タスク定義全体のメモリから割り当て
      portMappings = [
        {
          containerPort = var.app_container_port # アプリケーションがリッスンするポート
          hostPort      = var.app_container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = var.container_environment_variables # 環境変数
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-task-def"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. CloudWatch Log Group
#    - ECSタスクのログを保存
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}/${var.environment}/${var.app_container_name}"
  retention_in_days = var.log_retention_days 

  tags = {
    Name        = "${var.project_name}-${var.environment}-logs"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 6. ECS Service
#    - 指定された数（Desired Count）のタスクを実行し、ALBと連携
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids # プライベートサブネットに配置
    security_groups  = [aws_security_group.ecs_task.id] # ECSタスク用セキュリティグループを関連付け
    assign_public_ip = false # Fargateは通常、プライベートIPのみ割り当てる
  }

  load_balancer {
    target_group_arn = var.target_group_arn # ALBモジュールからのターゲットグループARN
    container_name   = var.app_container_name
    container_port   = var.app_container_port
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-service"
    Environment = var.environment
  }

  # depends_onは通常不要だが、ここでは明示的に依存関係を示す
  depends_on = [
    aws_lb_listener.http, # HTTPリスナーが作成された後にサービスをデプロイ
    # aws_lb_listener.https, # HTTPSリスナーを使用する場合
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# 7. ECS Task用セキュリティグループ
#    - ALBからのアクセス、RDSなどからのアクセス、外部へのアクセスを制御
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "ecs_task" {
  name        = "${var.project_name}-${var.environment}-ecs-task-sg"
  description = "Allow inbound traffic from ALB and outbound to internet/RDS"
  vpc_id      = var.vpc_id

  # インバウンドルール: ALBからのHTTP/HTTPSトラフィックを許可
  ingress {
    description     = "Allow traffic from ALB"
    from_port       = var.app_container_port
    to_port         = var.app_container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id] # ALBのセキュリティグループIDを指定
  }
  
  /*
  ingress {
    description     = "Allow traffic from ECS to RDS"
    from_port       = 3306 # MySQLの場合
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_task.id] # ECS自身からRDSへのアクセス
  }
  */

  # アウトバウンドルール: 全て許可 (インターネットへのアクセスなど)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-task-sg"
    Environment = var.environment
  }
}