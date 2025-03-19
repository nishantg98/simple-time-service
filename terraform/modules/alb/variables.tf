variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for the ALB"
}

variable "container_port" {
  type        = number
  description = "Container port"
}
