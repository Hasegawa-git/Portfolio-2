terraform {
  backend "s3" {
    bucket         = "hasegawa-terraform-state"
    key            = "portfolio-2/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.0"
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source            = "./modules/ecs"
  vpc_id            = module.vpc.vpc_id
  alb_sg_id         = module.alb.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  listener_arn      = module.alb.listener_arn
}

module "rds" {
  source            = "./modules/rds"
  vpc_id            = module.vpc.vpc_id
  ecs_sg_id         = module.ecs.ecs_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "iam" {
  source = "./modules/iam"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
}

module "sns" {
  source = "./modules/sns"
}
