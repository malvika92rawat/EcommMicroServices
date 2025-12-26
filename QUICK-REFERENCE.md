# Quick Reference Card

## 🚀 Start/Stop Commands

```bash
# Start all services
docker-compose up --build

# Start in background
docker-compose up -d

# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f user-service
```

## 🌐 Service URLs

| Service | URL | Health Check |
|---------|-----|--------------|
| **API Gateway** | http://localhost:8080 | http://localhost:8080/health |
| **User Service** | http://localhost:8081 | http://localhost:8081/api/users/health |
| **Product Service** | http://localhost:8082 | http://localhost:8082/api/products/health |
| **Order Service** | http://localhost:8083 | http://localhost:8083/api/orders/health |

## 🗄️ Database Access

```bash
# User Database (Port 3306)
docker exec -it user-mysql mysql -u ecom_user -pecom_pass user_db

# Product Database (Port 3307)
docker exec -it product-mysql mysql -u ecom_user -pecom_pass product_db

# Order Database (Port 3308)
docker exec -it order-mysql mysql -u ecom_user -pecom_pass order_db
```

## 📡 Common API Calls

### Register User
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@test.com","password":"test123"}'
```

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

### Get Products
```bash
curl http://localhost:8080/api/products
```

### Get Product by ID
```bash
curl http://localhost:8080/api/products/1
```

### Create Order
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "productId": 1,
    "quantity": 1,
    "paymentMethod": "CREDIT_CARD",
    "shippingAddress": "Test Address"
  }'
```

### Get Orders
```bash
curl http://localhost:8080/api/orders
```

### Get Orders by User
```bash
curl http://localhost:8080/api/orders/user/1
```

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Port in use | `docker-compose down`, check with `lsof -i :8080` |
| Services won't start | Wait 2-3 mins, check `docker-compose logs` |
| Database errors | `docker-compose down -v && docker-compose up --build` |
| Connection refused | Check service is healthy: `docker ps` |
| Order creation fails | Check product exists and has stock |

## 📊 Service Ports

| Service/DB | Port | Protocol |
|------------|------|----------|
| API Gateway | 8080 | HTTP |
| User Service | 8081 | HTTP |
| Product Service | 8082 | HTTP |
| Order Service | 8083 | HTTP |
| User MySQL | 3306 | MySQL |
| Product MySQL | 3307 | MySQL |
| Order MySQL | 3308 | MySQL |

## 🗂️ Project Structure

```
EcommerceMicroService/
├── api-gateway/              # API Gateway (Port 8080)
├── user-service/             # Authentication & Users (Port 8081)
├── product-service/          # Products & Inventory (Port 8082)
├── order-service/            # Order Processing (Port 8083)
├── shared/
│   └── database-schemas/     # SQL initialization scripts
├── docker-compose.yml        # Docker orchestration
├── README.md                 # Full documentation
├── PHASE2-SUMMARY.md         # Quick summary
├── API-REFERENCE.md          # Complete API docs
└── GETTING-STARTED.md        # Student guide
```

## 🔑 Key Concepts

| Concept | Description |
|---------|-------------|
| **Microservices** | Independent services, separately deployable |
| **Database per Service** | Each service owns its database |
| **API Gateway** | Single entry point, routes requests |
| **Inter-Service Comm** | Services call each other via REST |
| **JWT Auth** | Token-based authentication |
| **Docker Compose** | Multi-container orchestration |

## 📋 Order Status Flow

```
PENDING → CONFIRMED → PROCESSING → SHIPPED → DELIVERED
            ↓
        CANCELLED
```

## 🛠️ Technologies

- **Java 17** - Programming language
- **Spring Boot 3.1.5** - Application framework
- **Spring Cloud Gateway** - API Gateway
- **Spring Security + JWT** - Authentication
- **MySQL 8.0** - Database
- **Docker & Docker Compose** - Containerization
- **Maven** - Build tool

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Complete project overview |
| `PHASE2-SUMMARY.md` | Quick summary & comparison |
| `API-REFERENCE.md` | Detailed API documentation |
| `GETTING-STARTED.md` | Step-by-step student guide |
| `QUICK-REFERENCE.md` | This file - quick commands |

## 💡 Useful Docker Commands

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# View container logs
docker logs user-service

# Follow logs
docker logs -f user-service

# Execute command in container
docker exec -it user-service sh

# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune -a

# Check disk usage
docker system df

# Full cleanup
docker system prune -a --volumes
```

## 🔍 MySQL Quick Commands

```sql
-- Show all databases
SHOW DATABASES;

-- Use a database
USE product_db;

-- Show tables
SHOW TABLES;

-- View table structure
DESCRIBE products;

-- Query data
SELECT * FROM products;
SELECT * FROM products WHERE category = 'Electronics';

-- Count records
SELECT COUNT(*) FROM orders;

-- Exit MySQL
EXIT;
```

## 🎯 Sample Data

**Products:** 10 sample products (MacBook, iPhone, etc.)  
**Users:** 2 sample users (admin, user1)  
**Orders:** 3 sample orders

## 📞 Quick Help

**Services not starting?**
```bash
docker-compose down -v
docker-compose up --build
```

**Check service health:**
```bash
curl http://localhost:8080/health
curl http://localhost:8081/api/users/health
curl http://localhost:8082/api/products/health
curl http://localhost:8083/api/orders/health
```

**View all logs:**
```bash
docker-compose logs -f
```

**Restart single service:**
```bash
docker-compose restart user-service
```

---

## 🚀 One-Minute Test

```bash
# 1. Start services
docker-compose up -d

# 2. Wait 2 minutes, then test
curl http://localhost:8080/health

# 3. Get products
curl http://localhost:8080/api/products

# 4. Success! ✅
```

---

**Project Path:** `/Users/rakuma/Documents/AIML/EcommerceMicroService`

**Main Command:** `docker-compose up --build`

**Main URL:** http://localhost:8080

