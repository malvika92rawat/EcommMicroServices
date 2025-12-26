# AWS Free Tier Deployment Guide

Complete guide to deploy E-Commerce Microservices on AWS Free Tier with minimal to zero cost.

---

## ✅ Free Tier Evaluation

### AWS Free Tier Offerings (12 months for new accounts)

| Service | Free Tier Limit | Our Needs | Status |
|---------|----------------|-----------|--------|
| **EC2** | 750 hrs/month t2.micro | 1 instance | ✅ FREE |
| **RDS** | 750 hrs/month db.t2.micro | 1 instance | ✅ FREE |
| **EBS** | 30 GB storage | ~20 GB | ✅ FREE |
| **Data Transfer** | 15 GB/month OUT | Low usage | ✅ FREE |
| **ECR** | 500 MB storage | Not needed | ✅ FREE |
| **S3** | 5 GB storage | Not needed | ✅ FREE |
| **CloudWatch** | 10 custom metrics | Basic monitoring | ✅ FREE |

### ❌ What's NOT Free (Avoid These)

| Service | Cost | Why Avoid |
|---------|------|-----------|
| **Application Load Balancer** | ~$16-20/month | Use EC2 public IP instead |
| **NAT Gateway** | ~$32/month | Use public subnets |
| **Elastic IP (idle)** | $0.005/hour | Keep it attached to EC2 |
| **ECS Fargate** | Per vCPU/GB-hour | Limited free tier |
| **Multiple RDS instances** | Uses up free tier fast | Use single RDS with 3 databases |

---

## 🎯 Recommended Architecture for Free Tier

### Option 1: All-in-One EC2 (100% FREE) ⭐ **RECOMMENDED**

```
┌─────────────────────────────────────────────────┐
│         AWS Free Tier                           │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  EC2 t2.micro (750 hrs/month FREE)      │  │
│  │                                          │  │
│  │  Docker Compose:                         │  │
│  │  ├─ API Gateway (Port 8080)              │  │
│  │  ├─ User Service (Port 8081)             │  │
│  │  ├─ Product Service (Port 8082)          │  │
│  │  ├─ Order Service (Port 8083)            │  │
│  │  ├─ User MySQL (Port 3316)               │  │
│  │  ├─ Product MySQL (Port 3317)            │  │
│  │  └─ Order MySQL (Port 3318)              │  │
│  │                                          │  │
│  │  Public IP: 54.xxx.xxx.xxx               │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Cost: $0/month** (within Free Tier limits)

**Pros:**
- ✅ Completely FREE for 12 months
- ✅ Simple setup (one command)
- ✅ Easy to manage
- ✅ Perfect for learning

**Cons:**
- ⚠️ Single point of failure
- ⚠️ Limited resources (1 GB RAM)
- ⚠️ Not production-grade

---

### Option 2: EC2 + RDS (Still FREE but more complex)

```
┌──────────────────────────────┐
│  EC2 t2.micro (FREE)         │
│  ├─ API Gateway              │
│  ├─ User Service             │
│  ├─ Product Service          │
│  └─ Order Service            │
└──────────┬───────────────────┘
           │
┌──────────▼───────────────────┐
│  RDS db.t2.micro (FREE)      │
│  ├─ user_db                  │
│  ├─ product_db               │
│  └─ order_db                 │
└──────────────────────────────┘
```

**Cost: $0/month** (within Free Tier)

**Pros:**
- ✅ Still FREE
- ✅ Managed database (RDS)
- ✅ Better separation

**Cons:**
- ⚠️ More complex setup
- ⚠️ Still single EC2 instance

---

## 📋 Prerequisites

### 1. AWS Account Setup

- [ ] Create AWS Free Tier account
- [ ] Verify email
- [ ] Add payment method (won't be charged if staying in Free Tier)
- [ ] Enable MFA (recommended)

### 2. Local Tools

- [ ] AWS CLI installed
- [ ] SSH key pair
- [ ] Terminal/Command prompt

---

## 🚀 Deployment Steps (Option 1: All-in-One EC2)

### Step 1: Create EC2 Instance

**1.1 Log into AWS Console**
- Go to https://console.aws.amazon.com
- Navigate to **EC2** service

**1.2 Launch Instance**

Click **"Launch Instance"** and configure:

**Basic Details:**
```
Name: ecommerce-microservices
Application and OS Images: Ubuntu Server 22.04 LTS (FREE TIER ELIGIBLE)
Architecture: 64-bit (x86)
```

**Instance Type:**
```
Instance Type: t2.micro (FREE TIER ELIGIBLE)
- 1 vCPU
- 1 GB RAM
```

**Key Pair:**
```
Create new key pair:
  Name: ecommerce-key
  Type: RSA
  Format: .pem (for Mac/Linux) or .ppk (for Windows)
  
Download and save the key file!
```

**Network Settings:**
```
✅ Allow SSH traffic from: My IP
✅ Allow HTTP traffic from: Anywhere
✅ Allow HTTPS traffic from: Anywhere

Add Custom TCP rules:
- Port 8080 (API Gateway) - Source: 0.0.0.0/0
- Port 8081 (User Service) - Source: 0.0.0.0/0
- Port 8082 (Product Service) - Source: 0.0.0.0/0
- Port 8083 (Order Service) - Source: 0.0.0.0/0
```

**Storage:**
```
Root volume:
  Size: 20 GB (within free tier 30 GB limit)
  Type: gp3 (General Purpose SSD)
  
✅ Delete on termination
```

**Advanced Details:**
```
(Leave default)
```

Click **"Launch Instance"**

---

### Step 2: Connect to EC2 Instance

**2.1 Get Instance Details**
```bash
# From EC2 Dashboard, find your instance's Public IP
# Example: 54.123.45.67
```

**2.2 Set Key Permissions (Mac/Linux)**
```bash
chmod 400 ~/Downloads/ecommerce-key.pem
```

**2.3 Connect via SSH**
```bash
# Replace with your instance's public IP
ssh -i ~/Downloads/ecommerce-key.pem ubuntu@54.123.45.67
```

**For Windows:** Use PuTTY with the .ppk file

---

### Step 3: Install Docker & Docker Compose

**3.1 Update System**
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

**3.2 Install Docker**
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Logout and login again (or run this)
newgrp docker

# Verify installation
docker --version
```

**3.3 Install Docker Compose**
```bash
# Install Docker Compose
sudo apt-get install docker-compose-plugin -y

# Verify installation
docker compose version
```

---

### Step 4: Deploy Application

**4.1 Transfer Project Files**

**Option A: Using Git (Recommended)**
```bash
# On EC2 instance
cd ~
git clone https://github.com/YOUR_USERNAME/EcommerceMicroService.git
cd EcommerceMicroService
```

**Option B: Using SCP (from your local machine)**
```bash
# Compress project
cd /Users/rakuma/Documents/AIML
tar -czf EcommerceMicroService.tar.gz EcommerceMicroService/

# Copy to EC2
scp -i ~/Downloads/ecommerce-key.pem \
    EcommerceMicroService.tar.gz \
    ubuntu@54.123.45.67:~/

# On EC2, extract
tar -xzf EcommerceMicroService.tar.gz
cd EcommerceMicroService
```

**4.2 Start Services**
```bash
# Build and start all services
docker compose up --build -d

# This will take 5-10 minutes on first run
```

**4.3 Check Status**
```bash
# View running containers
docker ps

# Should see 7 containers running

# Check logs
docker compose logs -f
```

---

### Step 5: Configure Security Group

**5.1 Update Security Group Rules**

Go to EC2 → Security Groups → Your instance's security group

**Inbound Rules:**
```
Type            Protocol    Port Range    Source          Description
SSH             TCP         22            My IP           SSH access
Custom TCP      TCP         8080          0.0.0.0/0       API Gateway
Custom TCP      TCP         8081          0.0.0.0/0       User Service
Custom TCP      TCP         8082          0.0.0.0/0       Product Service
Custom TCP      TCP         8083          0.0.0.0/0       Order Service
```

**Note:** For better security, only expose port 8080 (API Gateway) publicly. Other services should only be accessible internally.

**Recommended Secure Configuration:**
```
SSH             TCP         22            My IP           SSH access
Custom TCP      TCP         8080          0.0.0.0/0       API Gateway (public)
```

Update `docker-compose.yml` to not expose other service ports publicly.

---

### Step 6: Test Deployment

**6.1 Get Public IP**
```bash
# From AWS Console or
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

**6.2 Test Endpoints**
```bash
# Replace with your EC2 public IP
export EC2_IP=54.123.45.67

# Test API Gateway
curl http://$EC2_IP:8080/health

# Test services
curl http://$EC2_IP:8080/api/products

# Register user
curl -X POST http://$EC2_IP:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student",
    "email": "student@example.com",
    "password": "password123"
  }'

# Login
curl -X POST http://$EC2_IP:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student",
    "password": "password123"
  }'
```

**6.3 Update Postman Collection**
```
Change baseUrl from:
  http://localhost:8080
To:
  http://54.123.45.67:8080
```

---

## 🔐 Security Hardening

### 1. Restrict SSH Access
```bash
# In Security Group, change SSH source from 0.0.0.0/0 to My IP
```

### 2. Create Elastic IP (to avoid IP changes)
```bash
# AWS Console → EC2 → Elastic IPs
# Allocate new address
# Associate with your EC2 instance

# ⚠️ Warning: Elastic IP is FREE only when attached to running instance
# If EC2 is stopped, you'll be charged $0.005/hour
```

### 3. Set Up SSL/HTTPS (Optional)

**Using Let's Encrypt (FREE):**
```bash
# Install Certbot
sudo apt-get install certbot -y

# Get certificate (requires domain name)
sudo certbot certonly --standalone -d yourdomain.com

# Update API Gateway to use HTTPS
```

### 4. Enable CloudWatch Monitoring

**Basic monitoring is FREE:**
- CPU utilization
- Network in/out
- Disk read/write

**Set up alarms:**
- CPU > 80%
- Disk > 80%
- Status check failures

---

## 💰 Cost Breakdown

### Monthly Cost (Free Tier)

| Service | Usage | Free Tier Limit | Cost |
|---------|-------|-----------------|------|
| EC2 t2.micro | 730 hrs | 750 hrs/month | **$0** ✅ |
| EBS 20 GB | 20 GB | 30 GB | **$0** ✅ |
| Data Transfer OUT | ~5 GB | 15 GB/month | **$0** ✅ |
| Elastic IP (attached) | 730 hrs | Always free when attached | **$0** ✅ |
| **TOTAL** | | | **$0/month** ✅ |

### After Free Tier Expires (12 months)

| Service | Monthly Cost |
|---------|-------------|
| EC2 t2.micro (730 hrs) | ~$8.50 |
| EBS 20 GB | ~$2.00 |
| Data Transfer | ~$0 (under 15 GB) |
| Elastic IP | $0 (attached) |
| **TOTAL** | **~$10.50/month** |

---

## 📊 Monitoring & Management

### Check Service Status
```bash
# SSH into EC2
ssh -i ecommerce-key.pem ubuntu@YOUR_EC2_IP

# Check services
docker ps

# View logs
docker compose logs -f

# Restart services
docker compose restart

# Stop services
docker compose down

# Start services
docker compose up -d
```

### CloudWatch Metrics

**View in AWS Console:**
- EC2 → Instances → Monitoring tab
- Metrics: CPU, Network, Disk

**Set up Alarms:**
1. CloudWatch → Alarms → Create Alarm
2. Select EC2 metric (CPU Utilization)
3. Set threshold (e.g., > 80%)
4. Configure SNS notification (email)

---

## 🔄 Updates & Maintenance

### Deploy New Changes

**Option 1: Git Pull (Recommended)**
```bash
# SSH into EC2
cd ~/EcommerceMicroService

# Pull latest changes
git pull

# Rebuild and restart
docker compose down
docker compose up --build -d
```

**Option 2: Manual Upload**
```bash
# From local machine
scp -i ecommerce-key.pem \
    -r user-service/src \
    ubuntu@EC2_IP:~/EcommerceMicroService/user-service/

# On EC2
docker compose up --build -d user-service
```

### Backup Database

```bash
# Backup all databases
docker exec user-mysql mysqldump -u ecom_user -pecom_pass user_db > backup_user_db.sql
docker exec product-mysql mysqldump -u ecom_user -pecom_pass product_db > backup_product_db.sql
docker exec order-mysql mysqldump -u ecom_user -pecom_pass order_db > backup_order_db.sql

# Download backups to local
scp -i ecommerce-key.pem ubuntu@EC2_IP:~/backup_*.sql ./backups/
```

---

## ⚠️ Important Notes

### Free Tier Limits

**✅ Do's:**
- Run ONE t2.micro EC2 instance
- Stay under 750 hours/month (run 24/7 = 730 hours)
- Keep data transfer under 15 GB/month
- Use gp3 volumes under 30 GB

**❌ Don'ts:**
- Don't run multiple EC2 instances
- Don't use load balancers (not free)
- Don't use NAT Gateways (not free)
- Don't stop EC2 with Elastic IP attached (charges apply)
- Don't exceed 15 GB data transfer out

### Performance Considerations

**t2.micro specs:**
- 1 vCPU
- 1 GB RAM

**Expected performance:**
- **Good for:** Learning, development, low traffic
- **Not suitable for:** High load, many concurrent users
- **Typical capacity:** 10-50 concurrent requests

**If you need more:**
- Upgrade to t2.small (~$17/month)
- Use t2.micro burst credits wisely

---

## 🎓 For Students

### Learning Objectives

By deploying to AWS Free Tier, students learn:

1. ✅ **Cloud Deployment** - Real-world AWS experience
2. ✅ **Linux Server Management** - Ubuntu, Docker
3. ✅ **Security Groups** - Firewall configuration
4. ✅ **SSH Access** - Remote server management
5. ✅ **Cost Optimization** - Work within Free Tier limits
6. ✅ **Monitoring** - CloudWatch basics
7. ✅ **Troubleshooting** - Debug production issues

### Exercises

1. **Deploy the application** following this guide
2. **Set up monitoring** with CloudWatch alarms
3. **Create backups** of databases
4. **Update application** with new features
5. **Optimize costs** - track Free Tier usage
6. **Secure the application** - restrict access
7. **Test performance** - load testing

---

## 📚 Alternative: Option 2 (EC2 + RDS)

If you want to use managed RDS:

### Benefits:
- Automated backups
- Easy scaling
- Managed maintenance
- Better for production learning

### Steps:
1. Follow Steps 1-4 above for EC2
2. Create RDS db.t2.micro instance
3. Create 3 databases in single RDS instance
4. Update docker-compose.yml:
   ```yaml
   services:
     user-service:
       environment:
         DB_HOST: your-rds-endpoint.amazonaws.com
         DB_PORT: 3306
   ```
5. Remove MySQL containers from docker-compose.yml

**Cost:** Still $0 (within Free Tier)

---

## 🆘 Troubleshooting

### EC2 Instance Not Accessible

**Check:**
1. Security group allows port 8080
2. EC2 instance is running
3. Docker services are up: `docker ps`
4. Check logs: `docker compose logs`

### Out of Memory

**t2.micro has only 1 GB RAM**

**Solution:**
```bash
# Add swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Free Tier Exceeded

**Monitor usage:**
- AWS Billing Dashboard
- AWS Free Tier usage alerts
- Set up billing alarms ($1 threshold)

---

## ✅ Deployment Checklist

- [ ] AWS account created and verified
- [ ] EC2 t2.micro instance launched
- [ ] Security groups configured
- [ ] SSH key downloaded and secured
- [ ] Connected to EC2 via SSH
- [ ] Docker and Docker Compose installed
- [ ] Project files transferred
- [ ] Services built and started
- [ ] All containers running (7 containers)
- [ ] API endpoints accessible from internet
- [ ] Postman collection updated with EC2 IP
- [ ] CloudWatch monitoring enabled
- [ ] Billing alerts configured
- [ ] Documentation reviewed

---

## 🎯 Summary

### ✅ Feasibility: **YES, 100% Possible!**

Your microservices CAN run on AWS Free Tier with:
- **Cost: $0/month** (for 12 months)
- **Setup Time: 30-60 minutes**
- **Maintenance: Minimal**

### Recommended Approach:
1. Use single EC2 t2.micro instance
2. Run all services with Docker Compose
3. Use local MySQL containers (not RDS)
4. Access via EC2 public IP
5. No load balancer (save $16-20/month)

### Perfect For:
- ✅ Learning microservices
- ✅ AWS hands-on practice
- ✅ Portfolio projects
- ✅ Small demos

---

**Ready to deploy? Follow the step-by-step guide above!** 🚀

