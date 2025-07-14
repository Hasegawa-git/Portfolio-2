# 10_env/10_dev/20_variables.tf

# ----------------------------------------------------------------------------------------------------------------------
# 1. Project and Environment Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "project_name" {
  description = "The name of the project. Used for naming resources and tags."
  type        = string
  default     = "Portfolio-2" # プロジェクトのデフォルト名
}

variable "environment" {
  description = "The environment name (e.g., dev, prod, stg). This will be passed to modules."
  type        = string
  default     = "dev" # 開発環境なので"dev"
}

variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "ap-northeast-1" # 東京リージョン
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. VPC Configuration Variables (VPCモジュールに渡す変数)
#    - ここで定義された値が、VPCモジュール (20_modules/10_vpc) に渡される。
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones to deploy resources into."
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "subnet_newbits" {
  description = "The number of additional bits to use for subnet CIDR blocks from the VPC CIDR."
  type        = number
  default     = 8 # /16 VPC -> /24 サブネット
}

variable "public_subnet_offset" {
  description = "The starting offset for public subnet CIDR blocks within the VPC."
  type        = number
  default     = 0
}

variable "private_subnet_offset" {
  description = "The starting offset for private subnet CIDR blocks within the VPC."
  type        = number
  default     = 2 # AZが2つの場合
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. ECS Fargate Configuration Variables (ECS Fargateモジュールに渡す変数)
# ----------------------------------------------------------------------------------------------------------------------

variable "app_container_name" {
  description = "The name of the application container within the task definition."
  type        = string
  default     = "web-api" # Python APIのコンテナ名に合わせて変更
}

variable "app_image_url" {
  description = "The Docker image URL for the application container (e.g., ECR URI)."
  type        = string
  default     = "public.ecr.aws/nginx/nginx:latest" # ECRリポジトリURIに置き換える
}

variable "app_container_port" {
  description = "The port on which the application container listens."
  type        = number
  default     = 8000 # Python Webフレームワークのデフォルトポート 
}

variable "fargate_cpu" {
  description = "The amount of CPU (in CPU units) to reserve for the Fargate task."
  type        = number
  default     = 256 # 開発環境なので最小値
}

variable "fargate_memory" {
  description = "The amount of memory (in MiB) to reserve for the Fargate task."
  type        = number
  default     = 512 # 開発環境なので最小値
}

variable "app_container_cpu" {
  description = "The number of CPU units to reserve for the application container. Should be less than or equal to fargate_cpu."
  type        = number
  default     = 256
}

variable "app_container_memory" {
  description = "The amount of memory (in MiB) to reserve for the application container. Should be less than or equal to fargate_memory."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "The number of instances of the task definition that should be running in the service."
  type        = number
  default     = 1 # 開発環境では1
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. RDS Configuration Variables (RDSモジュールに渡す変数)
# ----------------------------------------------------------------------------------------------------------------------

variable "db_engine" {
  description = "The database engine to use (e.g., mysql, postgres, aurora, aurora-mysql)."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine."
  type        = string
  default     = "8.0.35"
}

variable "db_instance_class" {
  description = "The DB instance class (e.g., db.t3.micro, db.m5.large)."
  type        = string
  default     = "db.t3.micro" # 開発用インスタンスタイプ
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 20 #開発環境なので小さめ
}

variable "db_storage_type" {
  description = "The storage type (e.g., gp2, gp3, io1, standard)."
  type        = string
  default     = "gp2"
}

variable "db_multi_az" {
  description = "Specifies if the DB instance is a Multi-AZ deployment. Set to true for high availability."
  type        = bool
  default     = false
}

variable "db_username" {
  description = "The master username for the DB instance."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the DB instance. WARNING: Not recommended for production. Use AWS Secrets Manager."
  type        = string
  sensitive   = true # コンソール出力などで隠蔽する (完全な保護ではない)
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
  default     = "portfolio-2_db" # データベース名
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = number
  default     = 3306 # MySQLのデフォルトポート
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with the DB instance."
  type        = string
  default     = "default.mysql8.0"
}

variable "db_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "Set to true to enable deletion protection on the DB instance."
  type        = bool
  default     = false #開発環境は"false"
}

variable "db_backup_retention_period" {
  description = "The daily backup retention period in days. Must be a value from 0 to 35."
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created. (e.g., '03:00-04:00')."
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur. (e.g., 'Mon:04:00-Mon:05:00')."
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. IAM Configuration Variables (IAMモジュールに渡す変数)
# ----------------------------------------------------------------------------------------------------------------------

variable "iam_roles_config" {
  description = "Configuration for IAM roles to be created by the IAM module."
  type = list(object({
    name                 = string
    assume_role_policy_json = string
    description          = optional(string)
    max_session_duration = optional(number)
    attach_managed_policy_arns = optional(list(string), [])
    inline_policies = optional(list(object({
      name        = string
      policy_json = string
    })), [])
  }))
  default = [
    # ECSタスク実行ロールのデフォルト設定
    {
      name                 = "ecs-task-execution-role"
      assume_role_policy_json = jsonencode({
        Version   = "2012-10-17"
        Statement = [
          {
            Action    = "sts:AssumeRole"
            Effect    = "Allow"
            Principal = {
              Service = "ecs-tasks.amazonaws.com"
            }
          },
        ]
      })
      description = "Allows ECS tasks to pull images and publish logs."
      attach_managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
      ]
    },
    # ECSタスクロールのデフォルト設定
    {
      name                 = "ecs-task-role"
      assume_role_policy_json = jsonencode({
        Version   = "2012-10-17"
        Statement = [
          {
            Action    = "sts:AssumeRole"
            Effect    = "Allow"
            Principal = {
              Service = "ecs-tasks.amazonaws.com"
            }
          },
        ]
      })
      description = "Allows ECS tasks to access application-specific AWS resources."
      inline_policies = [
        {
          name        = "secrets-manager-read-access"
          policy_json = jsonencode({
            Version   = "2012-10-17"
            Statement = [
              {
                Effect   = "Allow"
                Action   = [
                  "secretsmanager:GetSecretValue",
                  "secretsmanager:DescribeSecret"
                ]
                Resource = "*" # 特定のシークレットARNに限定することを推奨
              },
            ]
          })
        },
      ]
    },
  ]
}

variable "iam_policies_config" {
  description = "Configuration for IAM managed policies to be created by the IAM module."
  type = list(object({
    name        = string
    policy_json = string
    description = optional(string)
  }))
  default = []
}

# ----------------------------------------------------------------------------------------------------------------------
# 6. SNS Configuration Variables (SNSモジュールに渡す変数)
# ----------------------------------------------------------------------------------------------------------------------

variable "sns_topic_alarms_suffix" {
  description = "Suffix for the SNS topic name dedicated to alarms."
  type        = string
  default     = "alarms"
}

variable "sns_alarm_subscriptions" {
  description = "A list of SNS topic subscriptions for alarm notifications."
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = [
    # デフォルトではメール通知を設定しないが、必要に応じてここにメールアドレスを追加
    # {
    #   protocol = "email"
    #   endpoint = "your-alert-email@example.com"
    # },
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# 7. CloudWatch Configuration Variables (CloudWatchモジュールに渡す変数)
# ----------------------------------------------------------------------------------------------------------------------

variable "ecs_log_group_suffix" {
  description = "Suffix for the CloudWatch Log Group name for ECS application logs."
  type        = string
  default     = "ecs-app"
}

variable "ecs_log_retention_days" {
  description = "The number of days to retain log events for ECS application logs."
  type        = number
  default     = 30 #開発環境は短め
}

variable "ecs_alarms_config" {
  description = "A list of CloudWatch alarms specific to ECS Fargate services."
  type = list(object({
    alarm_name          = string
    metric_name         = string
    namespace           = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    threshold           = number
    comparison_operator = string
    alarm_description   = optional(string)
    dimensions          = optional(map(string))
    treat_missing_data  = optional(string)
    actions_enabled     = optional(bool, true)
  }))
  default = [
    {
      alarm_name          = "ecs-cpu-utilization-high"
      metric_name         = "CPUUtilization"
      namespace           = "AWS/ECS"
      statistic           = "Average"
      period              = 300
      evaluation_periods  = 1
      threshold           = 80
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Average CPU utilization for ECS service is too high."
    },
    {
      alarm_name          = "ecs-memory-utilization-high"
      metric_name         = "MemoryUtilization"
      namespace           = "AWS/ECS"
      statistic           = "Average"
      period              = 300
      evaluation_periods  = 1
      threshold           = 80
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Average Memory utilization for ECS service is too high."
    },
  ]
}