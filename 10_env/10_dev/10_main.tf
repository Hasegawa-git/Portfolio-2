# 10_env/10_dev/10_main.tf

# ----------------------------------------------------------------------------------------------------------------------
# 1. Module Call: VPC
#    - Calls the VPC module to provision the network infrastructure.
# ----------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source = "../../20_modules/10_vpc" # VPCモジュールへの相対パスを指定

  # VPCモジュールに渡す変数
  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr_block        = var.vpc_cidr_block
  azs                   = var.azs
  subnet_newbits        = var.subnet_newbits
  public_subnet_offset  = var.public_subnet_offset
  private_subnet_offset = var.private_subnet_offset
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. Module Call: ALB
#    - Calls the ALB module to provision the Application Load Balancer.
# ----------------------------------------------------------------------------------------------------------------------
module "alb" {
  source = "../../20_modules/20_alb" # ALBモジュールへの相対パスを指定

  # ALBモジュールに渡す変数
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id            # VPCモジュールの出力からVPC IDを取得
  public_subnet_ids = module.vpc.public_subnet_ids # VPCモジュールの出力からパブリックサブネットIDを取得

  # オプション: HTTPSを有効にする場合
  # enable_https      = true
  # acm_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # ACM証明書のARNに置き換える
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. Module Call: IAM
#    - Calls the IAM module to provision necessary IAM roles and policies.
# ----------------------------------------------------------------------------------------------------------------------
module "iam" {
  source = "../../20_modules/70_iam" # IAMモジュールへの相対パスを指定

  project_name = var.project_name
  environment  = var.environment

  iam_roles    = var.iam_roles_config
  iam_policies = var.iam_policies_config
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. Module Call: SNS
#    - Calls the SNS module to provision notification topics.
# ----------------------------------------------------------------------------------------------------------------------
module "sns_alarms" {
  source = "../../20_modules/60_sns" # SNSモジュールへの相対パスを指定

  project_name      = var.project_name
  environment       = var.environment
  topic_name_suffix = var.sns_topic_alarms_suffix

  subscriptions = var.sns_alarm_subscriptions
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. Module Call: CloudWatch
#    - Calls the CloudWatch module to provision log groups and alarms.
# ----------------------------------------------------------------------------------------------------------------------
module "cloudwatch_ecs_logs" {
  source = "../../20_modules/50_cloudwatch" # CloudWatchモジュールへの相対パスを指定

  project_name        = var.project_name
  environment         = var.environment
  log_group_name_suffix = var.ecs_log_group_suffix
  log_retention_days  = var.ecs_log_retention_days

  alarms = [
    for alarm_config in var.ecs_alarms_config :
    merge(
      alarm_config, # 30_variables.tfで定義されたアラームの基本設定
      {
        dimensions = { # 動的に取得するディメンション
          ClusterName = module.ecs_fargate.ecs_cluster_name
          ServiceName = module.ecs_fargate.ecs_service_name
        }
        alarm_actions = [module.sns_alarms.sns_topic_arn] # SNSトピックのARNを動的に追加
      }
    )
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# 6. Module Call: ECS Fargate
#    - Calls the ECS Fargate module to provision the ECS cluster, task definition, and service.
# ----------------------------------------------------------------------------------------------------------------------
module "ecs_fargate" {
  source = "../../20_modules/30_ecs_fargate" # ECS Fargateモジュールへの相対パスを指定

  # ECS Fargateモジュールに渡す変数
  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region

  vpc_id                = module.vpc.vpc_id             # VPCモジュールの出力からVPC IDを取得
  private_subnet_ids    = module.vpc.private_subnet_ids # VPCモジュールの出力からプライベートサブネットIDを取得
  alb_security_group_id = module.alb.alb_security_group_id # ALBモジュールの出力からALBセキュリティグループIDを取得
  target_group_arn      = module.alb.http_target_group_arn   # ALBモジュールの出力からHTTPターゲットグループARNを取得 (HTTPSの場合は module.alb.https_target_group_arn)

  # アプリケーションコンテナの設定
  app_container_name    = var.app_container_name
  app_image_url         = var.app_image_url
  app_container_port    = var.app_container_port

  fargate_cpu           = var.fargate_cpu
  fargate_memory        = var.fargate_memory
  app_container_cpu     = var.app_container_cpu
  app_container_memory  = var.app_container_memory
  container_environment_variables = [
    # ここでデータベース接続情報を環境変数としてECSタスクに渡す
    { name = "DATABASE_HOST", value = module.rds.db_instance_address },
    { name = "DATABASE_PORT", value = tostring(module.rds.db_instance_port) }, # 数値を文字列に変換
    { name = "DATABASE_NAME", value = module.rds.db_name },
    { name = "DATABASE_USERNAME", value = module.rds.db_username },
    # { name = "DATABASE_PASSWORD", value = var.db_password }, # 非推奨: Secrets Managerから取得を推奨
  ]

  desired_count         = var.desired_count

  ecs_log_group_name    = module.cloudwatch_ecs_logs.log_group_name
  #          もしECS Fargateモジュール内でロググループを作成するなら必要だが、現在はCloudWatchモジュールが担当
  # log_retention_days    = var.log_retention_days 

  # ECSタスク実行ロールとタスクロールをIAMモジュールから取得
  ecs_task_execution_role_arn = module.iam.iam_role_arns["ecs-task-execution-role"]
  ecs_task_role_arn           = module.iam.iam_role_arns["ecs-task-role"]
}

# ----------------------------------------------------------------------------------------------------------------------
# 7. Module Call: RDS
#    - Calls the RDS module to provision the Relational Database Service instance.
# ----------------------------------------------------------------------------------------------------------------------
module "rds" {
  source = "../../20_modules/40_rds" # RDSモジュールへの相対パスを指定

  # RDSモジュールに渡す変数
  project_name          = var.project_name
  environment           = var.environment

  vpc_id                = module.vpc.vpc_id             # VPCモジュールの出力からVPC IDを取得
  private_subnet_ids    = module.vpc.private_subnet_ids # VPCモジュールの出力からプライベートサブネットIDを取得
  ecs_security_group_id = module.ecs_fargate.ecs_task_security_group_id # ECS Fargateモジュールの出力からECSセキュリティグループIDを取得

  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  db_storage_type       = var.db_storage_type
  db_multi_az           = var.db_multi_az
  db_username           = var.db_username
  db_password           = var.db_password # ここでdb_passwordを直接渡すが、本番ではSecrets Manager
  db_name               = var.db_name
  db_port               = var.db_port
  db_parameter_group_name = var.db_parameter_group_name
  db_skip_final_snapshot = var.db_skip_final_snapshot
  db_deletion_protection = var.db_deletion_protection
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window      = var.db_backup_window
  db_maintenance_window = var.db_maintenance_window
}