output "ecs_security_group_id" {
  description = "ECS Security Group ID"
  value       = aws_security_group.ecs_sg.id
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.task.arn
}