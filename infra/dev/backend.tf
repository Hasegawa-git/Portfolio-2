terraform {
  backend "s3" {
    bucket         = "hasegawa-terraform-state"
    key            = "portfolio-2/dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
