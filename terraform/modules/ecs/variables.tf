variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "Public subnets for ECS"
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
}

variable "container_image" {
  type        = string
  description = "Docker container image"
}

variable "container_port" {
  type        = number
  description = "Container port"
}

variable "alb_target_group_arn" {
  type        = string
  description = "Target group ARN for ALB"
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}