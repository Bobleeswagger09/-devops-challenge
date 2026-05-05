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

# Create a key pair for SSH access
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-challenge-key"
  public_key = file(var.public_key_path)
}

# Security group
resource "aws_security_group" "devops_sg" {
  name        = "devops-challenge-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "devops_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-challenge-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
  EOF
}
