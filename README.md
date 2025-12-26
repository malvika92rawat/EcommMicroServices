# E-Commerce Microservices Architecture

A complete microservices-based e-commerce application built with Java Spring Boot, demonstrating modern cloud-native architecture patterns.

## 🏗️ Architecture Overview

This project demonstrates the transformation from a monolithic application to a microservices architecture:

```
┌─────────────────────────────────────────────────────┐
│                   API Gateway                        │
│                  (Port: 8080)                        │
└───────────────────┬─────────────────────────────────┘
                    │
        ┌───────────┼───────────┬────────────┐
        │           │           │            │
┌───────▼──────┐ ┌─▼──────┐ ┌─▼──────┐    │
│ User Service │ │ Product │ │ Order  │    │
│  (Port 8081) │ │ Service │ │Service │    │
│              │ │(Port    │ │(Port   │    │
│  - Auth      │ │ 8082)   │ │ 8083)  │    │
│  - JWT       │ │         │ │        │    │
└──────┬───────┘ └────┬────┘ └───┬────┘    │
       │              │          │         │
┌──────▼──────┐ ┌────▼────┐ ┌───▼────┐    │
│  user_db    │ │product  │ │order_db│    │
│ (Port 3306) │ │  _db    │ │(Port   │    │
│             │ │(Port    │ │ 3308)  │    │
│             │ │ 3307)   │ │        │    │
└─────────────┘ └─────────┘ └────────┘    │
```

## 🎯 Learning Objectives (Phase 2)

This project is designed for students learning:
- Microservices architecture patterns
- Domain-driven design
- Database per service pattern
- Inter-service communication
- API Gateway pattern
- Spring Boot and Spring Cloud
- Docker containerization
- Java 17 features

## 📦 Microservices

### 1. User Service (Port 8081)
- **Responsibility**: User authentication and management
- **Technology**: Spring Boot 3.1.5, Spring Security, JWT
- **Database**: MySQL (user_db)
- **Features**:
  - User registration and login
  - JWT token generation and validation
  - Role-based access control (USER, ADMIN)
  - BCrypt password encryption

### 2. Product Service (Port 8082)
- **Responsibility**: Product catalog and inventory management
- **Technology**: Spring Boot 3.1.5, Spring Data JPA
- **Database**: MySQL (product_db)
- **Features**:
  - CRUD operations for products
  - Category-based filtering
  - Search functionality
  - Stock management
  - Inventory checking

### 3. Order Service (Port 8083)
- **Responsibility**: Order processing and management
- **Technology**: Spring Boot 3.1.5, Spring WebFlux (WebClient)
- **Database**: MySQL (order_db)
- **Features**:
  - Order creation with stock validation
  - Order status tracking (PENDING → CONFIRMED → SHIPPED → DELIVERED)
  - Integration with Product Service
  - Order cancellation with stock restoration
  - Payment method handling

### 4. API Gateway (Port 8080)
- **Responsibility**: Request routing and centralized entry point
- **Technology**: Spring Cloud Gateway
- **Features**:
  - Route management
  - CORS configuration
  - Request logging
  - Fallback handling
  - Service health monitoring

## 🗄️ Database Strategy

**Database per Service Pattern**: Each microservice has its own dedicated MySQL database:

| Service | Database | Port | Purpose |
|---------|----------|------|---------|
| User Service | user_db | 3306 | User data, authentication |
| Product Service | product_db | 3307 | Product catalog, inventory |
| Order Service | order_db | 3308 | Orders, transactions |

### Benefits:
- ✅ Loose coupling between services
- ✅ Independent scaling
- ✅ Technology diversity
- ✅ Fault isolation
- ✅ Schema evolution independence

## 🚀 Getting Started

### Prerequisites
- Docker and Docker Compose
- Java 17 (for local development)
- Maven 3.9+ (for local development)

### Quick Start with Docker

1. **Clone the repository**
```bash
cd /Users/rakuma/Documents/AIML/EcommerceMicroService
```

2. **Build and start all services**
```bash
docker-compose up --build
```

3. **Verify services are running**
- API Gateway: http://localhost:8080
- User Service: http://localhost:8081/api/users/health
- Product Service: http://localhost:8082/api/products/health
- Order Service: http://localhost:8083/api/orders/health

### Local Development

**Run individual services:**

```bash
# User Service
cd user-service
mvn spring-boot:run

# Product Service
cd product-service
mvn spring-boot:run

# Order Service
cd order-service
mvn spring-boot:run

# API Gateway
cd api-gateway
mvn spring-boot:run
```

## 📡 API Endpoints

### Authentication (User Service)
```
POST   /api/auth/signup     - Register new user
POST   /api/auth/login      - Login and get JWT token
GET    /api/users           - Get all users (Admin only)
GET    /api/users/{id}      - Get user by ID
```

### Products (Product Service)
```
GET    /api/products              - Get all products
GET    /api/products/{id}         - Get product by ID
GET    /api/products/category/{category} - Get products by category
GET    /api/products/search?query={q}    - Search products
POST   /api/products              - Create product (Admin)
PUT    /api/products/{id}         - Update product
DELETE /api/products/{id}         - Delete product
PATCH  /api/products/{id}/stock   - Update stock
```

### Orders (Order Service)
```
GET    /api/orders              - Get all orders
GET    /api/orders/{id}         - Get order by ID
GET    /api/orders/user/{userId} - Get orders by user
POST   /api/orders              - Create new order
PATCH  /api/orders/{id}/status  - Update order status
DELETE /api/orders/{id}         - Cancel order
```

## 🧪 Testing with Postman

**Import ready-to-use Postman collection:**

```
File: ECommerce-Microservices.postman_collection.json
```

**Simple import:** Just drag & drop into Postman - no environment file needed!

All variables included:
- ✅ Auto-saves JWT token on login
- ✅ Auto-saves user/product/order IDs
- ✅ 45 pre-configured requests
- ✅ Built-in validation tests

See: `README-POSTMAN.md` for quick import guide

### Example Requests (cURL)

**1. Register a User**
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "USER"
  }'
```

**2. Login**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "password123"
  }'
```

**3. Get Products**
```bash
curl http://localhost:8080/api/products
```

**4. Create Order**
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "productId": 1,
    "quantity": 2,
    "paymentMethod": "CREDIT_CARD",
    "shippingAddress": "123 Main St, Mumbai, India"
  }'
```

## 🔧 Configuration

### Environment Variables
See `.env.example` for available configuration options.

### Service Ports
- API Gateway: 8080
- User Service: 8081
- Product Service: 8082
- Order Service: 8083
- User MySQL: 3306
- Product MySQL: 3307
- Order MySQL: 3308

## 📊 Monitoring & Health Checks

All services expose health check endpoints:
```bash
# Via API Gateway
curl http://localhost:8080/health

# Direct service access
curl http://localhost:8081/api/users/health
curl http://localhost:8082/api/products/health
curl http://localhost:8083/api/orders/health
```

## 🎓 Educational Notes

### Key Concepts Demonstrated

1. **Service Decomposition**
   - Breaking monolith into bounded contexts
   - Domain-driven design principles

2. **Inter-Service Communication**
   - REST APIs for synchronous communication
   - WebClient for non-blocking calls

3. **Data Management**
   - Database per service pattern
   - Eventual consistency
   - Distributed transactions handling

4. **API Gateway Pattern**
   - Single entry point
   - Request routing
   - Cross-cutting concerns (CORS, logging)

5. **Security**
   - JWT-based authentication
   - Role-based authorization
   - Password encryption

## 🔄 Comparison with Phase 1 (Monolith)

| Aspect | Phase 1 (Monolith) | Phase 2 (Microservices) |
|--------|-------------------|------------------------|
| Language | JavaScript/Node.js | Java/Spring Boot |
| Architecture | Single application | 4 independent services |
| Database | Single MySQL | 3 separate MySQL instances |
| Scaling | Scale entire app | Scale services independently |
| Deployment | Single container | Multiple containers |
| Development | Single codebase | Multiple codebases |

## 🐛 Troubleshooting

**Services not starting?**
- Check Docker logs: `docker-compose logs -f [service-name]`
- Verify ports are available
- Ensure MySQL containers are healthy

**Connection errors?**
- Verify network connectivity: `docker network inspect ecommercemicroservice_ecommerce-network`
- Check service URLs in environment variables

**Database issues?**
- Reset databases: `docker-compose down -v`
- Rebuild: `docker-compose up --build`

## 📚 Next Steps (Phase 3 - Future Enhancement)

- Add message queues (RabbitMQ/Kafka) for asynchronous communication
- Implement circuit breakers (Resilience4j)
- Add service discovery (Eureka)
- Implement centralized configuration (Spring Cloud Config)
- Add distributed tracing (Zipkin/Jaeger)
- Deploy to AWS (ECS/EKS)

## 👥 Contributing

This is an educational project. Students are encouraged to:
- Experiment with the code
- Add new features
- Improve error handling
- Add unit tests
- Enhance documentation

## 📝 License

This project is created for educational purposes.

---

**Happy Learning! 🚀**

