# DevOps Challenge - Production Ready Application Deployment

## Author
Victor Samuel

## Architecture Overview
GitHub Repository
|
| (git push)
▼
GitHub Actions (CI/CD Pipeline)
|
|-- Build Docker Image
|-- Run Tests
|-- Deploy to EC2
▼
AWS EC2 (t3.micro)
|
|-- Docker Container (Flask App)
|-- Port 5000 exposed
|-- CloudWatch Agent (Monitoring)
▼
AWS CloudWatch
|
|-- Application Logs
|-- Memory Metrics
|-- Disk Metrics

## Tech Stack

| Tool | Purpose |
|------|---------|
| Python Flask | Application |
| Docker | Containerization |
| Terraform | Infrastructure as Code |
| GitHub Actions | CI/CD Pipeline |
| AWS EC2 | Cloud Deployment |
| AWS CloudWatch | Monitoring & Logging |

## Prerequisites

- AWS CLI configured
- Terraform installed
- Docker installed
- Git installed

## Deployment Steps

### 1. Clone the repository
```bash
git clone https://github.com/Bobleeswagger09/-devops-challenge.git
cd -devops-challenge
```

### 2. Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Configure GitHub Secrets
Add these secrets to your GitHub repository:
- `EC2_HOST` - Your EC2 public IP
- `EC2_SSH_KEY` - Your private SSH key

### 4. Push to GitHub to trigger deployment
```bash
git push origin main
```

### 5. Access the application
http://<EC2_PUBLIC_IP>:5000
http://<EC2_PUBLIC_IP>:5000/health

## CI/CD Pipeline

The GitHub Actions pipeline triggers on every push to main:

1. **Build** - Builds Docker image
2. **Test** - Runs health check tests
3. **Deploy** - SSHs into EC2 and redeploys container

## Infrastructure as Code

Terraform provisions:
- EC2 t3.micro instance (Free Tier)
- Security Group (ports 22, 5000)
- SSH Key Pair

## Monitoring & Logging

CloudWatch Agent collects:
- Docker container logs → Log Group: `devops-challenge-app`
- Memory usage metrics
- Disk usage metrics

View logs at:
AWS Console → CloudWatch → Log Groups → devops-challenge-app

## Design Decisions

- **EC2 over ECS/EKS** - Cost effective, free tier eligible
- **Flask over Node.js** - Lightweight, minimal dependencies
- **GitHub Actions over Jenkins** - No extra server needed, simpler setup
- **Docker Hub not used** - Image built directly on EC2 to avoid registry costs

## Assumptions

- AWS Free Tier account
- us-east-1 region
- Amazon Linux 2 AMI

## Limitations & Improvements

- No load balancer (cost saving decision)
- Single EC2 instance (no high availability)
- Could add: ECS Fargate, ALB, RDS, Redis
- Could add: Kubernetes with EKS for scaling
- Could add: Terraform remote state with S3
- Could add: Multi-environment (dev/staging/prod)

