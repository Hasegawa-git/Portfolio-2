# AWS RDS Module - variables.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. General Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "project_name" {
  description = "The name of the project. Used for naming resources and tags."
  type        = string
  default     = "Portfolio-2"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod, stg). Used for naming resources and tags."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. Network Integration Variables (VPC/ECSモジュールからの入力)
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the DB Subnet Group. Must be at least two subnets in different AZs."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the ECS task security group to allow inbound traffic from ECS to RDS."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. RDS Instance Configuration Variables
# ----------------------------------------------------------------------------------------------------------------------

variable "db_engine" {
  description = "The database engine to use (e.g., mysql, postgres, aurora, aurora-mysql)."
  type        = string
  default     = "mysql" # デフォルトはMySQL
}

variable "db_engine_version" {
  description = "The version of the database engine."
  type        = string
  default     = "8.0.35" 
}

variable "db_instance_class" {
  description = "The DB instance class (e.g., db.t3.micro, db.m5.large)."
  type        = string
  default     = "db.t3.micro" 
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 20 
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
  default     = "app_db" 
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = number
  default     = 3306 
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
  default     = false 
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