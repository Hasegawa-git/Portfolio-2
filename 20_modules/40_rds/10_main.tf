# AWS RDS Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. DB Subnet Group
#    - RDSインスタンスをVPC内の特定のサブネットに配置するためのグループ
#    - 少なくとも2つ以上の異なるAZにあるサブネットが必要
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids  = var.private_subnet_ids # RDSはプライベートサブネットに配置

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. RDS Instance
#    - データベースインスタンスの作成
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_db_instance" "main" {
  engine             = var.db_engine          # 例: mysql, postgres, auroraなど
  engine_version     = var.db_engine_version  # エンジンバージョン
  instance_class     = var.db_instance_class  # インスタンスタイプ (例: db.t3.micro)
  allocated_storage  = var.db_allocated_storage # ストレージ容量 (GB)
  storage_type       = var.db_storage_type    # gp2, gp3, io1, standard
  multi_az           = var.db_multi_az        # マルチAZデプロイ (高可用性)
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_db.id] # RDS用セキュリティグループを関連付け

  username = var.db_username
  password = var.db_password # 本番環境ではAWS Secrets Managerの使用を強く推奨

  db_name                  = var.db_name          # 初期データベース名
  port                     = var.db_port          # データベースポート (例: 3306 for MySQL, 5432 for PostgreSQL)
  parameter_group_name     = var.db_parameter_group_name # デフォルトまたはカスタムのパラメータグループ名
  publicly_accessible      = false                # インターネットからの直接アクセスを許可しない (プライベート)
  skip_final_snapshot      = var.db_skip_final_snapshot # 最終スナップショットのスキップ (開発用)
  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.project_name}-${var.environment}-final-snapshot"
  deletion_protection      = var.db_deletion_protection # 削除保護 (本番環境ではtrueを推奨)

  # バックアップ設定
  backup_retention_period = var.db_backup_retention_period # バックアップ保持期間 (日数)
  backup_window           = var.db_backup_window           # バックアップウィンドウ (例: "03:00-04:00")

  # メンテナンスウィンドウ
  maintenance_window = var.db_maintenance_window # メンテナンスウィンドウ (例: "Mon:04:00-Mon:05:00")

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
  }

  # DB InstanceがSecurity Groupに関連付けられることを保証
  depends_on = [aws_security_group.rds_db]
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. RDS用セキュリティグループ
#    - ECSタスクからのDBアクセスを許可
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "rds_db" {
  name        = "${var.project_name}-${var.environment}-rds-db-sg"
  description = "Allow inbound traffic from ECS tasks to RDS DB"
  vpc_id      = var.vpc_id

  # インバウンドルール: ECSタスクからのアクセスを許可
  ingress {
    description     = "Allow DB access from ECS tasks"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id] # ECSタスクのセキュリティグループIDを指定
  }

  # アウトバウンドルール: 全て許可 (または必要に応じて制限)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-db-sg"
    Environment = var.environment
  }
}