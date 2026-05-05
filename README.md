# DevOps Challenge - Production Ready Application Deployment

## Author
Victor Samuel

## Live Application
- Home: http://54.81.112.218:5000
- Health Check: http://54.81.112.218:5000/health
- API Status: http://54.81.112.218:5000/api/v1/status

## Architecture Overview

![Architecture Diagram](architecture.png)

Developer (Local Machine)
|
| git push to main
▼
GitHub Repository
|
| triggers
▼
GitHub Actions (CI/CD Pipeline)
|
|── Stage 1: Build Docker Image
|── Stage 2: Test (Flask test client)
|── Stage 3: Deploy to EC2 via SSH
▼
AWS EC2 t3.micro (us-east-1)
|
|── Docker Container (Python Flask)
|   |── GET /              → Welcome Page
|   |── GET /health        → {"status": "healthy"}
|   |── GET /api/v1/status → API version & status
|
|── CloudWatch Agent
|── Container Logs → Log Group: devops-challenge-app
|── Memory Metrics
|── Disk Metrics

## Tech Stack

| Tool | Purpose |
|------|---------|
| Python Flask | Web application |
| Docker (multi-stage) | Containerisation |
| Terraform (modular) | Infrastructure as Code |
| GitHub Actions | CI/CD Pipeline |
| AWS EC2 t3.micro | Cloud deployment |
| AWS CloudWatch | Monitoring & logging |

## Project Structure
devops-challenge/
├── app/
│   ├── app.py                  # Flask application
│   ├── Dockerfile              # Multi-stage Docker build
│   └── requirements.txt        # Python dependencies
├── terraform/
│   ├── main.tf                 # Root module (calls child modules)
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   └── modules/
│       ├── ec2/                # EC2 instance + key pair
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── networking/         # Security group
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions pipeline
├── .env.example                # Environment variable template
├── .gitignore                  # Excludes secrets and binaries
├── architecture.md             # ASCII architecture diagram
└── README.md                   # This file

## Prerequisites

- AWS CLI configured
- Terraform v1.7.0+
- Git installed
- SSH key pair at ~/.ssh/devops-challenge

## Deployment Steps

### 1. Clone the repository
```bash
git clone https://github.com/Bobleeswagger09/-devops-challenge.git
cd -devops-challenge
```

### 2. Provision infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Configure GitHub Secrets
| Secret | Value |
|--------|-------|
| EC2_HOST | Your EC2 public IP |
| EC2_SSH_KEY | Contents of ~/.ssh/devops-challenge |

### 4. Trigger deployment
```bash
git push origin main
```

### 5. Access the application
http://<EC2_PUBLIC_IP>:5000
http://<EC2_PUBLIC_IP>:5000/health
http://<EC2_PUBLIC_IP>:5000/api/v1/status

## CI/CD Pipeline

The GitHub Actions pipeline triggers on every push to main:

| Stage | Description |
|-------|-------------|
| Build | Builds Docker image from source |
| Test | Runs health check via Flask test client |
| Deploy | SSHs into EC2, pulls latest code, restarts container |

## Terraform Module Structure

The infrastructure is split into reusable modules:

- **networking module** — provisions Security Group with configurable ports
- **ec2 module** — provisions EC2 instance and SSH Key Pair

This makes the infrastructure reusable across environments (dev/staging/prod).

## Monitoring & Logging

CloudWatch Agent collects:
- Docker container logs → Log Group: `devops-challenge-app`
- Memory usage % (custom metric)
- Disk usage % (custom metric)

View logs: AWS Console → CloudWatch → Log Groups → devops-challenge-app

## Design Decisions

| Decision | Reasoning |
|----------|-----------|
| EC2 over ECS/EKS | Cost effective, free tier eligible, meets requirements |
| GitHub Actions over Jenkins | No extra server needed, simpler setup |
| Multi-stage Dockerfile | Smaller image size, faster builds, production best practice |
| Modular Terraform | Reusable, clean separation of concerns |
| No Docker registry | Image built on EC2 directly, zero registry cost |
| Flask over Node.js | Lightweight, minimal dependencies |

## Assumptions

- AWS Free Tier account in us-east-1
- Amazon Linux 2 AMI
- Single instance deployment (no HA requirement for assessment)

## Limitations & Future Improvements

| Limitation | Improvement |
|------------|-------------|
| No HTTPS | Add ACM + ALB for TLS termination |
| Single EC2 | Add Auto Scaling Group for HA |
| No load balancer | Add ALB for traffic distribution |
| Local Terraform state | Migrate to S3 + DynamoDB remote state |
| No multi-environment | Add Terraform workspaces for dev/staging/prod |
| Basic monitoring | Add CloudWatch Alarms + SNS notifications |
| No container registry | Push to AWS ECR for versioned images |
