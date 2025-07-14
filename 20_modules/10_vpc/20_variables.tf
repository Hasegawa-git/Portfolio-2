# AWS VPC Module - variables.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. General Variables (プロジェクト全体で使用する情報)
# ----------------------------------------------------------------------------------------------------------------------

variable "project_name" {
  description = "The name of the project. Used for naming resources and tags."
  type        = string
  default     = "Portfolio-2"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod,). Used for naming resources and tags."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. VPC Configuration Variables (VPC設定に関する情報)
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16" # デフォルトのVPC CIDRブロック
}

variable "azs" {
  description = "A list of availability zones to deploy resources into."
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"] # 東京リージョンの一般的なAZ
}

variable "subnet_newbits" {
  description = "The number of additional bits to use for subnet CIDR blocks from the VPC CIDR."
  type        = number
  default     = 8 
}

variable "public_subnet_offset" {
  description = "The starting offset for public subnet CIDR blocks within the VPC."
  type        = number
  default     = 0 
}

variable "private_subnet_offset" {
  description = "The starting offset for private subnet CIDR blocks within the VPC."
  type        = number
  default     = 2 
}