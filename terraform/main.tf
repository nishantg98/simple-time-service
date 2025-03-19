provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "terraform/state.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = var.dynamodb_table_name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "simple-time-service-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway    = true
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.0.0"

  cluster_name = var.ecs_cluster_name
#   vpc_id       = module.vpc.vpc_id
#   subnets      = module.vpc.private_subnets
}

resource "aws_ecs_task_definition" "simple_time_service" {
  family                   = "simple-time-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "simple-time-service"
      image     = var.container_image
      essential = true
      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
      }]
    }
  ])
}

resource "aws_ecs_service" "simple_time_service" {
  name            = "simple-time-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.simple_time_service.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_service.id]
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "simple-time-service-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = "simple-time-service-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}