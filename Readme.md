# SimpleTimeService

## Project Overview
SimpleTimeService is a minimalist web service that returns the current timestamp and the visitor's IP address in JSON format. It is containerized using Docker and deployed to AWS ECS (Fargate) via Terraform.

## Prerequisites
Ensure you have the following tools installed before proceeding:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **AWS CLI**: [Install AWS CLI](https://aws.amazon.com/cli/)
- **Terraform**: [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- **Git**: [Install Git](https://git-scm.com/downloads)

## Setup Instructions

### 1. Clone the Repository
```sh
git clone https://github.com/nishantg98/simple-time-service.git
cd simple-time-service
```

### 2. Build and Run the Docker Container Locally
```sh
# Build the Docker image
docker build -t simple-time-service .

# Run the container
docker run -p 5000:5000 simple-time-service
```
The service should now be accessible at http://localhost:5000.

### 3. Push Docker Image to Docker Hub
```sh
# Tag the image
docker tag simple-time-service nishantg98/simple-time-service:latest

# Push the image
docker push nishantg98/simple-time-service:latest
```

### 4. Deploy to AWS ECS using Terraform

#### Terraform Remote Backend Setup
To ensure Terraform state is stored remotely and securely, we use:

✅ S3 for centralized state storage
✅ DynamoDB for state locking to prevent conflicts

1️⃣ Terraform Backend Configuration
Terraform is configured to use the following remote backend:

```sh
terraform {
  backend "s3" {
    bucket         = "simple-time-service-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

2️⃣ Deploy Terraform Infrastructure

```sh
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```
This will create the required AWS infrastructure, including ECS Fargate, Load Balancer, and networking components.

### 5. CI/CD Pipeline (GitHub Actions)
✅ Automates:
✔ Docker Build & Push
✔ Terraform Apply

CI/CD Setup

Store AWS & Docker credentials in GitHub Secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
DOCKER_USERNAME
DOCKER_PASSWORD

### Trigger Deployment
Push changes to main to trigger the workflow:

```sh
git add .
git commit -m "Updated service & infra"
git push origin main
```

## Testing the Service

### 1. Using cURL
```sh
curl http://<LOAD_BALANCER_DNS>
```

### 2. Using a Web Browser
Open `http://<LOAD_BALANCER_DNS>` in any web browser. You should receive a JSON response similar to:
```json
{
  "timestamp": "2025-03-19T12:00:00Z",
  "ip": "203.0.113.10"
}
```

## Cleanup
To remove all deployed resources:
```sh
terraform destroy -auto-approve
```

