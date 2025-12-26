# Project Structure

Clean and organized project structure for E-Commerce Microservices.

---

## 📁 Directory Layout

```
EcommerceMicroService/
│
├── README.md                               # Main project documentation
├── docker-compose.yml                      # Multi-container orchestration
├── .gitignore                             # Git ignore rules
├── .dockerignore                          # Docker ignore rules
├── env-template.txt                       # Environment variable template
├── ECommerce-Microservices.postman_collection.json  # API testing collection
│
├── docs/                                  # 📚 All Documentation
│   ├── README.md                          # Documentation index
│   ├── GETTING-STARTED.md                 # Beginner tutorial
│   ├── QUICK-REFERENCE.md                 # Command cheat sheet
│   ├── PHASE2-SUMMARY.md                  # Project summary
│   ├── API-REFERENCE.md                   # Complete API docs
│   ├── POSTMAN-GUIDE.md                   # Postman usage guide
│   ├── POSTMAN-IMPORT-GUIDE.md           # Postman import instructions
│   ├── README-POSTMAN.md                  # Quick Postman reference
│   ├── DOCKER-COMMANDS.md                 # Docker command reference
│   └── AWS-DEPLOYMENT.md                  # AWS deployment guide
│
├── user-service/                          # 🔐 User Service
│   ├── Dockerfile                         # Container definition
│   ├── .dockerignore                      # Build optimization
│   ├── pom.xml                            # Maven dependencies
│   └── src/
│       └── main/
│           ├── java/com/ecommerce/userservice/
│           │   ├── UserServiceApplication.java
│           │   ├── entity/
│           │   │   └── User.java
│           │   ├── repository/
│           │   │   └── UserRepository.java
│           │   ├── service/
│           │   │   └── AuthService.java
│           │   ├── controller/
│           │   │   ├── AuthController.java
│           │   │   └── UserController.java
│           │   ├── security/
│           │   │   ├── JwtUtils.java
│           │   │   ├── AuthTokenFilter.java
│           │   │   └── UserDetailsServiceImpl.java
│           │   ├── config/
│           │   │   └── SecurityConfig.java
│           │   └── dto/
│           │       ├── LoginRequest.java
│           │       ├── SignupRequest.java
│           │       ├── JwtResponse.java
│           │       └── MessageResponse.java
│           └── resources/
│               └── application.yml
│
├── product-service/                       # 📦 Product Service
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/ecommerce/productservice/
│           │   ├── ProductServiceApplication.java
│           │   ├── entity/
│           │   │   └── Product.java
│           │   ├── repository/
│           │   │   └── ProductRepository.java
│           │   ├── service/
│           │   │   └── ProductService.java
│           │   ├── controller/
│           │   │   └── ProductController.java
│           │   └── dto/
│           │       ├── ProductRequest.java
│           │       └── StockUpdateRequest.java
│           └── resources/
│               └── application.yml
│
├── order-service/                         # 🛒 Order Service
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/ecommerce/orderservice/
│           │   ├── OrderServiceApplication.java
│           │   ├── entity/
│           │   │   ├── Order.java
│           │   │   └── OrderStatus.java
│           │   ├── repository/
│           │   │   └── OrderRepository.java
│           │   ├── service/
│           │   │   ├── OrderService.java
│           │   │   └── ProductServiceClient.java
│           │   ├── controller/
│           │   │   └── OrderController.java
│           │   ├── config/
│           │   │   └── WebClientConfig.java
│           │   └── dto/
│           │       ├── OrderRequest.java
│           │       ├── OrderStatusUpdateRequest.java
│           │       └── ProductDTO.java
│           └── resources/
│               └── application.yml
│
├── api-gateway/                           # 🌐 API Gateway
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/ecommerce/apigateway/
│           │   ├── ApiGatewayApplication.java
│           │   ├── controller/
│           │   │   ├── GatewayController.java
│           │   │   └── FallbackController.java
│           │   └── filter/
│           │       └── LoggingFilter.java
│           └── resources/
│               └── application.yml
│
└── shared/                                # 🗄️ Shared Resources
    └── database-schemas/
        ├── README.md
        ├── user-db-init.sql
        ├── product-db-init.sql
        └── order-db-init.sql
```

---

## 📊 Service Breakdown

| Service | Port | Purpose | Database |
|---------|------|---------|----------|
| **API Gateway** | 8080 | Entry point, routing | - |
| **User Service** | 8081 | Authentication, users | user_db (port 3316) |
| **Product Service** | 8082 | Product catalog | product_db (port 3317) |
| **Order Service** | 8083 | Order processing | order_db (port 3318) |

---

## 📚 Documentation Organization

### Root Level
- `README.md` - Main entry point, project overview

### docs/ Folder
All detailed documentation organized by category:

**Getting Started:**
- GETTING-STARTED.md
- QUICK-REFERENCE.md
- PHASE2-SUMMARY.md

**API Documentation:**
- API-REFERENCE.md
- POSTMAN-GUIDE.md
- POSTMAN-IMPORT-GUIDE.md
- README-POSTMAN.md

**Deployment:**
- DOCKER-COMMANDS.md
- AWS-DEPLOYMENT.md

---

## 🐋 Docker Files

Each service has:
- `Dockerfile` - Multi-stage build configuration
- `.dockerignore` - Excludes unnecessary files from build

Root level:
- `docker-compose.yml` - Orchestrates all services
- `.dockerignore` - Project-level exclusions

---

## ☕ Java Structure

Each service follows standard Spring Boot structure:

```
service-name/
└── src/main/java/com/ecommerce/servicename/
    ├── ServiceNameApplication.java    # Main application
    ├── entity/                         # JPA entities
    ├── repository/                     # Data access layer
    ├── service/                        # Business logic
    ├── controller/                     # REST endpoints
    ├── dto/                           # Data transfer objects
    ├── config/                        # Configuration classes
    └── security/                      # Security (user-service only)
```

---

## 🗄️ Database Organization

**Database per Service Pattern:**

Each service has its own MySQL database:
- `user_db` - User authentication data
- `product_db` - Product catalog & inventory
- `order_db` - Orders & transactions

Initialization scripts in `shared/database-schemas/`

---

## 📦 Build Artifacts

Maven build creates `target/` in each service:
```
service-name/target/
└── service-name-1.0.0.jar    # Executable JAR
```

Excluded from git via `.gitignore`

---

## 🔐 Configuration Files

### Service Level
- `application.yml` - Service configuration
  - Server port
  - Database connection
  - Service-specific settings

### Root Level
- `docker-compose.yml` - All service orchestration
- `env-template.txt` - Environment variable template

---

## 🧪 Testing Resources

- `ECommerce-Microservices.postman_collection.json` - API testing
- Sample data in `shared/database-schemas/*.sql`

---

## 📝 Key Files

| File | Purpose |
|------|---------|
| `README.md` | Project overview |
| `docker-compose.yml` | Run all services |
| `docs/README.md` | Documentation index |
| `docs/GETTING-STARTED.md` | Tutorial |
| `docs/AWS-DEPLOYMENT.md` | Deploy to AWS |
| `ECommerce-Microservices.postman_collection.json` | API testing |

---

## 🎯 Clean Separation

### Code (Root Level)
```
user-service/
product-service/
order-service/
api-gateway/
shared/
```

### Documentation (docs/ Folder)
```
docs/
├── Getting Started guides
├── API documentation
└── Deployment guides
```

### Configuration (Root Level)
```
docker-compose.yml
env-template.txt
.gitignore
.dockerignore
```

---

**This structure keeps code, documentation, and configuration cleanly separated!**

