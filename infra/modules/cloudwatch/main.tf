resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/portfolio"
  retention_in_days = 7
}
