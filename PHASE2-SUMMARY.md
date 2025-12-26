# Phase 2: Microservices Architecture - Quick Summary

## 🎯 What Was Built

Converted JavaScript monolithic e-commerce to **Java Spring Boot microservices** architecture with 4 independent services.

## 📦 Services Created

| Service | Port | Technology | Purpose |
|---------|------|------------|---------|
| **API Gateway** | 8080 | Spring Cloud Gateway | Entry point, routing |
| **User Service** | 8081 | Spring Boot + Security + JWT | Authentication, user management |
| **Product Service** | 8082 | Spring Boot + JPA | Product catalog, inventory |
| **Order Service** | 8083 | Spring Boot + WebClient | Order processing |

## 🗄️ Databases (Separate per Service)

| Database | Port | Service | Tables |
|----------|------|---------|--------|
| user_db | 3306 | User Service | users |
| product_db | 3307 | Product Service | products |
| order_db | 3308 | Order Service | orders |

## 🚀 Quick Start

```bash
# Navigate to project
cd /Users/rakuma/Documents/AIML/EcommerceMicroService

# Start all services with Docker
docker-compose up --build

# Access API Gateway
curl http://localhost:8080
```

## 📡 Key API Endpoints (via API Gateway)

### Authentication
- `POST /api/auth/signup` - Register user
- `POST /api/auth/login` - Login (get JWT token)

### Products
- `GET /api/products` - List all products
- `GET /api/products/{id}` - Get product details
- `POST /api/products` - Create product

### Orders
- `POST /api/orders` - Create order
- `GET /api/orders/user/{userId}` - Get user orders
- `PATCH /api/orders/{id}/status` - Update order status

## 🔑 Key Features Implemented

### 1. User Service
✅ JWT authentication  
✅ BCrypt password encryption  
✅ Role-based access (USER, ADMIN)  
✅ Spring Security configuration

### 2. Product Service
✅ CRUD operations  
✅ Stock management  
✅ Category filtering  
✅ Search functionality

### 3. Order Service
✅ Order creation with stock validation  
✅ Inter-service communication (calls Product Service)  
✅ Order status tracking  
✅ Stock restoration on cancellation

### 4. API Gateway
✅ Request routing  
✅ CORS configuration  
✅ Health monitoring  
✅ Centralized logging

## 🏗️ Architecture Patterns Used

1. **Database per Service** - Each microservice has own MySQL instance
2. **API Gateway** - Single entry point for all clients
3. **RESTful Communication** - Services communicate via HTTP REST APIs
4. **Service Isolation** - Independent deployment and scaling
5. **JWT Authentication** - Token-based security

## 📊 Project Structure

```
EcommerceMicroService/
├── api-gateway/           # Port 8080
│   ├── src/main/java/
│   ├── Dockerfile
│   └── pom.xml
├── user-service/          # Port 8081
│   ├── src/main/java/
│   ├── Dockerfile
│   └── pom.xml
├── product-service/       # Port 8082
│   ├── src/main/java/
│   ├── Dockerfile
│   └── pom.xml
├── order-service/         # Port 8083
│   ├── src/main/java/
│   ├── Dockerfile
│   └── pom.xml
├── shared/
│   └── database-schemas/  # SQL init scripts
├── docker-compose.yml     # Orchestrates all services
└── README.md             # Full documentation
```

## 🔄 Monolith vs Microservices Comparison

| Aspect | Phase 1 (Monolith) | Phase 2 (Microservices) |
|--------|-------------------|------------------------|
| **Language** | JavaScript/Node.js | Java 17/Spring Boot |
| **Services** | 1 backend service | 4 independent services |
| **Databases** | 1 MySQL (shared) | 3 MySQL (isolated) |
| **Ports** | 5000 | 8080-8083 |
| **Scaling** | Scale entire app | Scale services independently |
| **Deployment** | 1 container | 7 containers (4 services + 3 DBs) |

## 🛠️ Technologies Used

- **Java 17** - Programming language
- **Spring Boot 3.1.5** - Application framework
- **Spring Cloud Gateway** - API Gateway
- **Spring Security** - Authentication/Authorization
- **JWT (jsonwebtoken)** - Token-based auth
- **Spring Data JPA** - Database ORM
- **MySQL 8.0** - Relational database
- **Docker & Docker Compose** - Containerization
- **Maven** - Build tool
- **Lombok** - Code generation

## 📝 Sample Test Requests

### 1. Register User
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"student","email":"student@test.com","password":"test123"}'
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"student","password":"test123"}'
```

### 3. Get Products
```bash
curl http://localhost:8080/api/products
```

### 4. Create Order
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

## 🎓 Learning Outcomes

Students will understand:
1. ✅ **Service Decomposition** - Breaking monolith into bounded contexts
2. ✅ **Database per Service Pattern** - Data isolation
3. ✅ **Inter-Service Communication** - REST APIs, WebClient
4. ✅ **API Gateway Pattern** - Centralized routing
5. ✅ **Security in Microservices** - JWT, Spring Security
6. ✅ **Docker Orchestration** - Multi-container applications
7. ✅ **Java/Spring Boot** - Enterprise Java development

## 🐛 Troubleshooting

**Services won't start?**
```bash
# Check logs
docker-compose logs -f user-service

# Reset everything
docker-compose down -v
docker-compose up --build
```

**Port conflicts?**
- Stop any services running on ports 8080-8083, 3306-3308

**Database connection errors?**
- Wait for MySQL health checks to pass (can take 30-60 seconds)

## 📈 Next Phase Ideas (Phase 3)

- ☐ Add Service Discovery (Eureka)
- ☐ Implement Circuit Breakers (Resilience4j)
- ☐ Add Message Queue (RabbitMQ/Kafka)
- ☐ Centralized Configuration (Spring Cloud Config)
- ☐ Distributed Tracing (Zipkin/Jaeger)
- ☐ Deploy to AWS (ECS/EKS)
- ☐ Add Kubernetes manifests
- ☐ Implement API rate limiting
- ☐ Add comprehensive testing

## 📚 Key Files to Review

1. **Architecture**: `README.md`
2. **Database Schemas**: `shared/database-schemas/*.sql`
3. **Docker Setup**: `docker-compose.yml`
4. **User Auth**: `user-service/src/main/java/com/ecommerce/userservice/security/`
5. **API Gateway Config**: `api-gateway/src/main/resources/application.yml`
6. **Inter-Service Comm**: `order-service/.../service/ProductServiceClient.java`

## ✅ Deliverables Completed

✅ 4 independent microservices (User, Product, Order, Gateway)  
✅ Service-to-service communication (Order → Product)  
✅ Separate databases per service (3 MySQL instances)  
✅ API Gateway with routing and CORS  
✅ JWT authentication system  
✅ Docker containerization for all services  
✅ Database initialization with sample data  
✅ Health check endpoints  
✅ Comprehensive documentation

---

**Project Status**: ✅ Complete and Ready for Learning!

**Start Command**: `docker-compose up --build`

**Access Point**: http://localhost:8080

