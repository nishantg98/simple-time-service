terraform {
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  container_port = var.container_port
}


module "ecs" {
  source                     = "./modules/ecs"
  vpc_id                     = module.vpc.vpc_id
  private_subnets            = module.vpc.private_subnets
  cluster_name               = var.ecs_cluster_name
  container_image            = "docker.io/${var.dockerhub_username}/${var.dockerhub_repo}:latest"
  container_port             = var.container_port
  alb_target_group_arn       = module.alb.target_group_arn
  alb_listener_arn           = module.alb.alb_listener_arn
  alb_security_group_id      = module.alb.alb_security_group_id
}
