output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}
output "ecs_sg_id" {
  description = "The security group ID used by the ECS service"
  value       = aws_security_group.ecs_sg.id
}
