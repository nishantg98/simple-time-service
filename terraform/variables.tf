variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "ecs-cluster"
}

variable "container_port" {
  description = "Port on which the container runs"
  type        = number
  default     = 5000
}

variable "dockerhub_username" {
  description = "Docker Hub Username"
  type        = string
  default     = "nishantg98"
}

variable "dockerhub_repo" {
  description = "Docker Hub Repository Name"
  type        = string
  default     = "simple-time-service"
}
