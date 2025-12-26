# Getting Started Guide - For Students

Welcome to Phase 2 of the AWS DevOps Challenge! This guide will help you get started with the microservices architecture.

## 🎯 Prerequisites

Before you begin, ensure you have:

- ✅ **Docker Desktop** installed and running
- ✅ **Docker Compose** installed (comes with Docker Desktop)
- ✅ **Git** (to clone/manage the project)
- ✅ **Postman** or **cURL** (for testing APIs)
- ✅ **8GB RAM minimum** (recommended for running all services)

### Optional (for local development):
- ☐ Java 17 JDK
- ☐ Maven 3.9+
- ☐ IntelliJ IDEA or VS Code with Java extensions

---

## 🚀 Step 1: Start the Services

### Using Docker Compose (Recommended)

1. **Navigate to the project directory:**
```bash
cd /Users/rakuma/Documents/AIML/EcommerceMicroService
```

2. **Start all services:**
```bash
docker-compose up --build
```

This command will:
- Build all 4 microservices
- Start 3 MySQL databases
- Start the API Gateway
- Initialize databases with sample data

3. **Wait for all services to start** (2-3 minutes)

You'll see logs indicating services are ready:
```
user-service    | Started UserServiceApplication
product-service | Started ProductServiceApplication
order-service   | Started OrderServiceApplication
api-gateway     | Started ApiGatewayApplication
```

4. **Verify services are running:**

Open your browser and visit:
- API Gateway: http://localhost:8080
- User Service Health: http://localhost:8081/api/users/health
- Product Service Health: http://localhost:8082/api/products/health
- Order Service Health: http://localhost:8083/api/orders/health

---

## 🧪 Step 2: Test the APIs

### Method 1: Using cURL (Terminal)

**1. Register a new user:**
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student1",
    "email": "student1@test.com",
    "password": "password123",
    "role": "USER"
  }'
```

**Expected Response:**
```json
{"message": "User registered successfully!"}
```

**2. Login to get JWT token:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student1",
    "password": "password123"
  }'
```

**Expected Response:**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "student1",
  "email": "student1@test.com",
  "role": "USER"
}
```

**3. Get all products:**
```bash
curl http://localhost:8080/api/products
```

**4. Create an order:**
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "productId": 1,
    "quantity": 1,
    "paymentMethod": "CREDIT_CARD",
    "shippingAddress": "123 Student St, Mumbai, India"
  }'
```

### Method 2: Using Postman

1. **Download Postman** from https://www.postman.com/downloads/

2. **Import API Collection:**
   - Create a new collection called "E-Commerce Microservices"
   - Set base URL variable: `{{baseUrl}}` = `http://localhost:8080`

3. **Create requests:**
   - POST {{baseUrl}}/api/auth/signup
   - POST {{baseUrl}}/api/auth/login
   - GET {{baseUrl}}/api/products
   - POST {{baseUrl}}/api/orders

4. **Use Environment Variables:**
   - Save JWT token from login response
   - Use in Authorization header for protected endpoints

---

## 📊 Step 3: Explore the Architecture

### View Running Containers
```bash
docker ps
```

You should see 7 containers:
- api-gateway
- user-service
- product-service
- order-service
- user-mysql
- product-mysql
- order-mysql

### Check Service Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service
docker-compose logs -f product-service
docker-compose logs -f order-service
```

### Access MySQL Databases

**User Database:**
```bash
docker exec -it user-mysql mysql -u ecom_user -pecom_pass user_db
```

**Product Database:**
```bash
docker exec -it product-mysql mysql -u ecom_user -pecom_pass product_db
```

**Order Database:**
```bash
docker exec -it order-mysql mysql -u ecom_user -pecom_pass order_db
```

**Inside MySQL, try:**
```sql
SHOW TABLES;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM users;
```

---

## 🎓 Step 4: Learning Exercises

### Exercise 1: API Flow Understanding

**Task:** Track what happens when you create an order

1. Enable logging in docker-compose logs
2. Create an order using the API
3. Observe the logs:
   - API Gateway receives request
   - Order Service processes request
   - Order Service calls Product Service to check stock
   - Product Service validates and returns stock info
   - Order Service creates order
   - Product Service updates stock
   - Response sent back through Gateway

**Questions to answer:**
- How many services were involved?
- What HTTP methods were used?
- How is the product stock updated?

### Exercise 2: Database Isolation

**Task:** Verify each service has its own database

1. Connect to each MySQL container
2. List databases in each
3. Try to access tables from another service's database

**Questions to answer:**
- Why can't Order Service directly access products table?
- What are the benefits of this isolation?
- What are the challenges?

### Exercise 3: Service Communication

**Task:** Understand inter-service communication

1. Read the code in:
   - `order-service/src/main/java/.../service/ProductServiceClient.java`
   - `order-service/src/main/java/.../service/OrderService.java`

2. Answer:
   - How does Order Service communicate with Product Service?
   - What happens if Product Service is down?
   - How is the Product Service URL configured?

### Exercise 4: API Gateway Routing

**Task:** Understand how API Gateway routes requests

1. Open: `api-gateway/src/main/resources/application.yml`
2. Find the route definitions
3. Test routing:
   ```bash
   curl http://localhost:8080/api/products/1
   curl http://localhost:8082/api/products/1
   ```

**Questions:**
- What's the difference between the two URLs?
- Why use an API Gateway?
- What would happen without it?

---

## 🔧 Step 5: Modify and Experiment

### Add a New Product

**Via API:**
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Student Laptop",
    "description": "Perfect for learning",
    "price": 35000.00,
    "stock": 100,
    "category": "Electronics",
    "imageUrl": "http://example.com/laptop.jpg"
  }'
```

### Update Product Stock

```bash
curl -X PATCH http://localhost:8080/api/products/1/stock \
  -H "Content-Type: application/json" \
  -d '{"quantity": 10}'
```

### Check Order Status

```bash
# Get all orders
curl http://localhost:8080/api/orders

# Get orders for specific user
curl http://localhost:8080/api/orders/user/1

# Update order status
curl -X PATCH http://localhost:8080/api/orders/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "SHIPPED"}'
```

---

## 🛑 Step 6: Stop the Services

### Stop all services:
```bash
docker-compose down
```

### Stop and remove all data (fresh start):
```bash
docker-compose down -v
```

### Restart services:
```bash
docker-compose up
```

---

## 🐛 Troubleshooting

### Problem: Services won't start

**Solution:**
```bash
# Check Docker is running
docker --version

# Check ports are available
lsof -i :8080,8081,8082,8083,3306,3307,3308

# Clean restart
docker-compose down -v
docker-compose up --build
```

### Problem: "Port already in use"

**Solution:**
```bash
# Find what's using the port (example for 8080)
lsof -i :8080

# Kill the process
kill -9 <PID>
```

### Problem: Database connection errors

**Solution:**
- Wait 1-2 minutes for MySQL to fully initialize
- Check logs: `docker-compose logs user-mysql`
- Ensure health checks pass: `docker ps` (should show "healthy")

### Problem: Order creation fails

**Common causes:**
1. Product doesn't exist
2. Insufficient stock
3. Product Service is not reachable

**Solution:**
```bash
# Check Product Service
curl http://localhost:8082/api/products/health

# Check product exists
curl http://localhost:8082/api/products/1

# Check logs
docker-compose logs order-service
```

### Problem: Can't access services

**Verify containers are running:**
```bash
docker ps
```

**Should see 7 containers running. If not:**
```bash
docker-compose up
```

---

## 📚 Next Steps

1. **Read the Documentation:**
   - `README.md` - Complete project overview
   - `PHASE2-SUMMARY.md` - Quick reference
   - `API-REFERENCE.md` - Detailed API docs

2. **Understand the Code:**
   - Start with `user-service` to understand Spring Security
   - Move to `product-service` for basic CRUD
   - Study `order-service` for inter-service communication
   - Review `api-gateway` for routing patterns

3. **Experiment:**
   - Add new endpoints
   - Modify database schemas
   - Add validation rules
   - Implement new features

4. **Compare with Phase 1:**
   - Review the monolithic code in `EcommerceMonolithic`
   - Compare architecture decisions
   - Understand trade-offs

---

## 🎯 Learning Checklist

- [ ] Successfully started all services with Docker Compose
- [ ] Created a user account via API
- [ ] Retrieved product list
- [ ] Created an order successfully
- [ ] Observed inter-service communication in logs
- [ ] Connected to MySQL databases
- [ ] Understood API Gateway routing
- [ ] Explored the codebase structure
- [ ] Tested error scenarios (insufficient stock, etc.)
- [ ] Compared with Phase 1 monolithic architecture

---

## 💡 Tips for Success

1. **Use Docker Logs:** Always check logs when debugging
2. **Test Incrementally:** Test each service independently first
3. **Read Error Messages:** They usually point to the exact problem
4. **Check Health Endpoints:** Verify services are running before testing
5. **Use Postman Collections:** Save and organize your API tests
6. **Experiment Safely:** Docker makes it easy to reset everything

---

## 📞 Common Questions

**Q: How long does it take to start all services?**
A: 2-3 minutes on a modern machine with good internet.

**Q: Do I need to know Java to understand this?**
A: Basic Java knowledge helps, but the architecture concepts are language-agnostic.

**Q: Can I run services individually?**
A: Yes! Use Maven to run each service locally (requires Java 17).

**Q: What if I make a mistake?**
A: Just run `docker-compose down -v` and start fresh!

**Q: How do I add new features?**
A: Modify the Java code, rebuild with `docker-compose up --build`

---

## 🎓 Assessment Questions (For Self-Study)

1. What are the benefits of microservices over monolithic architecture?
2. Why does each service have its own database?
3. How does the Order Service communicate with the Product Service?
4. What is the role of the API Gateway?
5. How is authentication handled in this architecture?
6. What happens when you cancel an order?
7. How would you add a new microservice to this architecture?
8. What are the challenges of microservices?

---

**Happy Learning! 🚀**

**Need help?** Check the main `README.md` or review the code with comments.

---

**Project Location:** `/Users/rakuma/Documents/AIML/EcommerceMicroService`

**Quick Start:** `docker-compose up --build`

**Access:** http://localhost:8080

