# AWS Deployment Guide

Complete guide for deploying the E-Commerce Microservices to AWS.

---

## 🎯 AWS Deployment Options

This project can be deployed to AWS using:

1. **AWS ECS (Elastic Container Service)** - Recommended for beginners
2. **AWS EKS (Elastic Kubernetes Service)** - For advanced orchestration
3. **AWS App Runner** - Simplest, fully managed option
4. **AWS Fargate** - Serverless containers (with ECS/EKS)

---

## 🏗️ Architecture Overview for AWS

```
┌─────────────────────────────────────────────────────┐
│              Application Load Balancer               │
│                  (Port 80/443)                       │
└───────────────────┬─────────────────────────────────┘
                    │
        ┌───────────┼───────────┬────────────┐
        │           │           │            │
┌───────▼──────┐ ┌─▼──────┐ ┌─▼──────┐ ┌──▼─────┐
│ User Service │ │ Product│ │ Order  │ │Gateway │
│   ECS Task   │ │Service │ │Service │ │ Task   │
│              │ │  Task  │ │  Task  │ │        │
└──────┬───────┘ └────┬───┘ └───┬────┘ └───┬────┘
       │              │         │           │
┌──────▼──────┐ ┌────▼───┐ ┌───▼────┐     │
│  RDS MySQL  │ │  RDS   │ │  RDS   │     │
│  (user_db)  │ │(product│ │(order  │     │
│             │ │  _db)  │ │  _db)  │     │
└─────────────┘ └────────┘ └────────┘     │
```

---

## ✅ Current Project AWS Readiness

### ✓ Already Configured:
- ✅ Multi-platform Docker images (AMD64 + ARM64)
- ✅ Environment variable configuration
- ✅ Health check endpoints (`/health`)
- ✅ Separate databases per service
- ✅ Stateless services (no local file storage)
- ✅ Cross-origin support (CORS)
- ✅ Docker multi-stage builds (optimized)
- ✅ .dockerignore for faster builds

### ✓ Service Ports:
- API Gateway: 8080
- User Service: 8081
- Product Service: 8082
- Order Service: 8083

---

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **Docker** installed locally
4. **ECR (Elastic Container Registry)** repositories created
5. **RDS MySQL** instances (3 separate databases)
6. **VPC** with public and private subnets

---

## 🚀 Option 1: Deploy to AWS ECS (Recommended)

### Step 1: Create ECR Repositories

```bash
# Set your AWS region
export AWS_REGION=us-east-1

# Create ECR repositories for each service
aws ecr create-repository --repository-name ecommerce/user-service --region $AWS_REGION
aws ecr create-repository --repository-name ecommerce/product-service --region $AWS_REGION
aws ecr create-repository --repository-name ecommerce/order-service --region $AWS_REGION
aws ecr create-repository --repository-name ecommerce/api-gateway --region $AWS_REGION
```

### Step 2: Build and Push Images to ECR

```bash
# Get ECR login credentials
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.$AWS_REGION.amazonaws.com

# Set your AWS account ID
export AWS_ACCOUNT_ID=<your-account-id>
export ECR_REGISTRY=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build and push User Service
cd user-service
docker build -t ecommerce/user-service:latest .
docker tag ecommerce/user-service:latest $ECR_REGISTRY/ecommerce/user-service:latest
docker push $ECR_REGISTRY/ecommerce/user-service:latest

# Build and push Product Service
cd ../product-service
docker build -t ecommerce/product-service:latest .
docker tag ecommerce/product-service:latest $ECR_REGISTRY/ecommerce/product-service:latest
docker push $ECR_REGISTRY/ecommerce/product-service:latest

# Build and push Order Service
cd ../order-service
docker build -t ecommerce/order-service:latest .
docker tag ecommerce/order-service:latest $ECR_REGISTRY/ecommerce/order-service:latest
docker push $ECR_REGISTRY/ecommerce/order-service:latest

# Build and push API Gateway
cd ../api-gateway
docker build -t ecommerce/api-gateway:latest .
docker tag ecommerce/api-gateway:latest $ECR_REGISTRY/ecommerce/api-gateway:latest
docker push $ECR_REGISTRY/ecommerce/api-gateway:latest
```

### Step 3: Create RDS MySQL Instances

```bash
# Create security group for RDS
aws rds create-db-instance \
  --db-instance-identifier ecommerce-user-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password YourPassword123! \
  --allocated-storage 20 \
  --db-name user_db \
  --region $AWS_REGION

# Repeat for product-db and order-db
aws rds create-db-instance \
  --db-instance-identifier ecommerce-product-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password YourPassword123! \
  --allocated-storage 20 \
  --db-name product_db \
  --region $AWS_REGION

aws rds create-db-instance \
  --db-instance-identifier ecommerce-order-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password YourPassword123! \
  --allocated-storage 20 \
  --db-name order_db \
  --region $AWS_REGION
```

### Step 4: Create ECS Cluster

```bash
aws ecs create-cluster --cluster-name ecommerce-cluster --region $AWS_REGION
```

### Step 5: Create Task Definitions

Create file: `user-service-task-definition.json`

```json
{
  "family": "user-service",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "containerDefinitions": [
    {
      "name": "user-service",
      "image": "<AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/ecommerce/user-service:latest",
      "portMappings": [
        {
          "containerPort": 8081,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "DB_HOST",
          "value": "<RDS_USER_DB_ENDPOINT>"
        },
        {
          "name": "DB_USER",
          "value": "admin"
        },
        {
          "name": "DB_PASSWORD",
          "value": "YourPassword123!"
        },
        {
          "name": "DB_NAME",
          "value": "user_db"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/user-service",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8081/api/users/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

Repeat similar task definitions for product-service, order-service, and api-gateway.

### Step 6: Create ECS Services

```bash
# Create User Service
aws ecs create-service \
  --cluster ecommerce-cluster \
  --service-name user-service \
  --task-definition user-service \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx],assignPublicIp=ENABLED}" \
  --region $AWS_REGION

# Repeat for other services
```

### Step 7: Create Application Load Balancer

```bash
# Create ALB
aws elbv2 create-load-balancer \
  --name ecommerce-alb \
  --subnets subnet-xxx subnet-yyy \
  --security-groups sg-xxx \
  --region $AWS_REGION

# Create target groups for each service
aws elbv2 create-target-group \
  --name user-service-tg \
  --protocol HTTP \
  --port 8081 \
  --vpc-id vpc-xxx \
  --target-type ip \
  --health-check-path /api/users/health \
  --region $AWS_REGION

# Create listener rules to route traffic
```

---

## 🚀 Option 2: Deploy to AWS EKS (Advanced)

### Prerequisites:
- `kubectl` installed
- `eksctl` installed

### Step 1: Create EKS Cluster

```bash
eksctl create cluster \
  --name ecommerce-cluster \
  --region $AWS_REGION \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```

### Step 2: Create Kubernetes Manifests

See `kubernetes/` directory (to be created separately)

### Step 3: Deploy Services

```bash
kubectl apply -f kubernetes/user-service-deployment.yaml
kubectl apply -f kubernetes/product-service-deployment.yaml
kubectl apply -f kubernetes/order-service-deployment.yaml
kubectl apply -f kubernetes/api-gateway-deployment.yaml
```

---

## 🚀 Option 3: AWS App Runner (Simplest)

### Deploy Each Service:

```bash
aws apprunner create-service \
  --service-name user-service \
  --source-configuration '{
    "ImageRepository": {
      "ImageIdentifier": "<ECR_REGISTRY>/ecommerce/user-service:latest",
      "ImageRepositoryType": "ECR",
      "ImageConfiguration": {
        "Port": "8081",
        "RuntimeEnvironmentVariables": {
          "DB_HOST": "<RDS_ENDPOINT>",
          "DB_USER": "admin",
          "DB_PASSWORD": "YourPassword123!",
          "DB_NAME": "user_db"
        }
      }
    },
    "AutoDeploymentsEnabled": true
  }' \
  --instance-configuration '{
    "Cpu": "1024",
    "Memory": "2048"
  }'
```

---

## 🔐 Security Best Practices

### 1. Use AWS Secrets Manager

Store sensitive data in Secrets Manager:

```bash
aws secretsmanager create-secret \
  --name ecommerce/db/user-service \
  --secret-string '{"username":"admin","password":"YourPassword123!"}' \
  --region $AWS_REGION
```

Update task definitions to reference secrets:

```json
"secrets": [
  {
    "name": "DB_PASSWORD",
    "valueFrom": "arn:aws:secretsmanager:region:account:secret:ecommerce/db/user-service"
  }
]
```

### 2. Use IAM Roles for Tasks

Create IAM role with appropriate permissions:
- CloudWatch Logs write access
- Secrets Manager read access
- ECR pull permissions

### 3. Use Private Subnets

Deploy services in private subnets with NAT Gateway for outbound traffic.

### 4. Enable VPC Flow Logs

Monitor network traffic for security.

---

## 📊 Monitoring & Logging

### CloudWatch Logs

All services are configured to send logs to CloudWatch:
- Log Group: `/ecs/user-service`
- Log Group: `/ecs/product-service`
- Log Group: `/ecs/order-service`
- Log Group: `/ecs/api-gateway`

### CloudWatch Metrics

Monitor:
- CPU utilization
- Memory utilization
- Request count
- Response time
- Error rate

### Health Checks

All services expose health endpoints:
- User Service: `http://<service>:8081/api/users/health`
- Product Service: `http://<service>:8082/api/products/health`
- Order Service: `http://<service>:8083/api/orders/health`
- API Gateway: `http://<service>:8080/health`

---

## 💰 Cost Optimization

### For Learning/Testing:
- Use **t3.micro** or **t4g.micro** instances
- Use **db.t3.micro** for RDS
- Use **Fargate Spot** for non-production
- Enable **Auto Scaling** with minimum instances

### Estimated Monthly Cost (us-east-1):
- ECS Fargate (4 services, 2 tasks each): ~$50-70
- RDS MySQL (3 × db.t3.micro): ~$45
- ALB: ~$20
- Data Transfer: ~$10
- **Total: ~$125-145/month**

### Cost Saving Tips:
1. Stop non-production environments during off-hours
2. Use Reserved Instances for production
3. Enable S3 logs compression
4. Use AWS Free Tier where applicable

---

## 🔄 CI/CD Pipeline

### GitHub Actions Example:

Create `.github/workflows/deploy-to-aws.yml`:

```yaml
name: Deploy to AWS ECS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Build and push User Service
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        run: |
          cd user-service
          docker build -t $ECR_REGISTRY/ecommerce/user-service:latest .
          docker push $ECR_REGISTRY/ecommerce/user-service:latest
      
      - name: Deploy to ECS
        run: |
          aws ecs update-service --cluster ecommerce-cluster --service user-service --force-new-deployment
```

---

## 🧪 Testing on AWS

### 1. Test Health Endpoints

```bash
# Get ALB DNS name
ALB_DNS=$(aws elbv2 describe-load-balancers --names ecommerce-alb --query 'LoadBalancers[0].DNSName' --output text)

# Test services
curl http://$ALB_DNS/api/users/health
curl http://$ALB_DNS/api/products/health
curl http://$ALB_DNS/api/orders/health
```

### 2. Load Testing

Use Apache Bench or Artillery:

```bash
ab -n 1000 -c 10 http://$ALB_DNS/api/products
```

---

## 📚 Additional Resources

### AWS Documentation:
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/)
- [RDS MySQL Setup](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html)
- [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)

### Tutorials:
- AWS ECS Workshop
- AWS Well-Architected Framework
- Microservices on AWS

---

## ✅ Deployment Checklist

Before deploying to AWS:

- [ ] ECR repositories created for all 4 services
- [ ] Docker images built and pushed to ECR
- [ ] RDS MySQL instances created (3 databases)
- [ ] Security groups configured
- [ ] VPC and subnets set up
- [ ] IAM roles and policies created
- [ ] Secrets Manager configured
- [ ] Task definitions created
- [ ] ECS cluster created
- [ ] Services deployed
- [ ] Load balancer configured
- [ ] Health checks passing
- [ ] CloudWatch logs configured
- [ ] Testing completed
- [ ] Domain name configured (optional)
- [ ] SSL certificate added (optional)

---

## 🆘 Troubleshooting on AWS

### Service Won't Start
```bash
# Check ECS service events
aws ecs describe-services --cluster ecommerce-cluster --services user-service

# Check CloudWatch logs
aws logs tail /ecs/user-service --follow
```

### Database Connection Issues
- Verify security group allows traffic from ECS tasks
- Check RDS endpoint and credentials
- Ensure RDS is in same VPC

### High Costs
- Review CloudWatch metrics
- Check for unused resources
- Enable cost allocation tags

---

**Ready to deploy to AWS! Follow the steps for your chosen deployment option.** 🚀

