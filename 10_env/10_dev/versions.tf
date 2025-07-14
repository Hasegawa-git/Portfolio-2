# 10_env/10_dev/versions.tf

terraform {
  required_version = ">= 1.0.0" # Terraformのバージョン

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # AWSプロバイダのバージョン 
    }
  }
}

provider "aws" {
  region = "ap-northeast-1" # 東京リージョン
}