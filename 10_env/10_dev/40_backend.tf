terraform {
  backend "s3" {
    bucket         = "portfolio-2-terraform-state-hasegawa-git-dev" # S3バケット名
    key            = "dev/terraform.tfstate" # ステートファイルのパス
    region         = "ap-northeast-1"
    encrypt        = true # S3バケットのデフォルト暗号化を使用
    dynamodb_table = "portfolio-2-terraform-lock-dev" # DynamoDBテーブル名
  }
}