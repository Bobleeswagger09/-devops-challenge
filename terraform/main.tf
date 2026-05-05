terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source   = "./modules/networking"
  name     = "devops-challenge-sg"
  app_port = var.app_port
}

module "ec2" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = "devops-challenge-key"
  public_key_path   = var.public_key_path
  security_group_id = module.networking.security_group_id
  name              = "devops-challenge-server"
  environment       = "production"
}
