output "alb_dns_name" {
  value = aws_lb.public_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.ecs_tg.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}