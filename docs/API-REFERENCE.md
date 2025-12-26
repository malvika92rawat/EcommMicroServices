# API Reference Guide

Complete API documentation for all microservices.

## Base URL
```
API Gateway: http://localhost:8080
```

---

## 🔐 Authentication APIs (User Service)

### 1. Register New User
```http
POST /api/auth/signup
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "USER"
}
```

**Response (200 OK):**
```json
{
  "message": "User registered successfully!"
}
```

**Roles:** `USER`, `ADMIN`

---

### 2. Login
```http
POST /api/auth/login
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "john_doe",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "role": "USER"
}
```

---

### 3. Get All Users (Admin Only)
```http
GET /api/users
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "role": "USER",
    "createdAt": "2024-01-01T10:00:00",
    "updatedAt": "2024-01-01T10:00:00"
  }
]
```

---

## 📦 Product APIs (Product Service)

### 1. Get All Products
```http
GET /api/products
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "MacBook Pro 16\"",
    "description": "Apple MacBook Pro with M3 chip",
    "price": 249900.00,
    "stock": 50,
    "category": "Electronics",
    "imageUrl": "https://example.com/macbook.jpg",
    "createdAt": "2024-01-01T10:00:00",
    "updatedAt": "2024-01-01T10:00:00"
  }
]
```

---

### 2. Get Product by ID
```http
GET /api/products/{id}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "MacBook Pro 16\"",
  "description": "Apple MacBook Pro with M3 chip",
  "price": 249900.00,
  "stock": 50,
  "category": "Electronics",
  "imageUrl": "https://example.com/macbook.jpg"
}
```

**Response (404 Not Found):**
```json
{
  "error": "Product not found with id: 1"
}
```

---

### 3. Get Products by Category
```http
GET /api/products/category/{category}
```

**Example:** `/api/products/category/Electronics`

---

### 4. Search Products
```http
GET /api/products/search?query={searchTerm}
```

**Example:** `/api/products/search?query=MacBook`

---

### 5. Create Product
```http
POST /api/products
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "iPad Air",
  "description": "Apple iPad Air with M2 chip",
  "price": 74900.00,
  "stock": 60,
  "category": "Electronics",
  "imageUrl": "https://example.com/ipad.jpg"
}
```

**Response (201 Created):**
```json
{
  "id": 11,
  "name": "iPad Air",
  "description": "Apple iPad Air with M2 chip",
  "price": 74900.00,
  "stock": 60,
  "category": "Electronics",
  "imageUrl": "https://example.com/ipad.jpg"
}
```

---

### 6. Update Product
```http
PUT /api/products/{id}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "iPad Air Updated",
  "description": "Updated description",
  "price": 79900.00,
  "stock": 70,
  "category": "Electronics",
  "imageUrl": "https://example.com/ipad-new.jpg"
}
```

---

### 7. Update Stock
```http
PATCH /api/products/{id}/stock
Content-Type: application/json
```

**Request Body:**
```json
{
  "quantity": -5
}
```

**Note:** Use negative value to decrease stock, positive to increase.

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "MacBook Pro 16\"",
  "stock": 45,
  ...
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Insufficient stock. Available: 2"
}
```

---

### 8. Check Stock Availability
```http
GET /api/products/{id}/check-stock?quantity={qty}
```

**Example:** `/api/products/1/check-stock?quantity=5`

**Response (200 OK):**
```json
{
  "productId": 1,
  "requestedQuantity": 5,
  "available": true
}
```

---

### 9. Delete Product
```http
DELETE /api/products/{id}
```

**Response (200 OK):**
```json
{
  "message": "Product deleted successfully"
}
```

---

## 🛒 Order APIs (Order Service)

### 1. Create Order
```http
POST /api/orders
Content-Type: application/json
```

**Request Body:**
```json
{
  "userId": 1,
  "productId": 1,
  "quantity": 2,
  "paymentMethod": "CREDIT_CARD",
  "shippingAddress": "123 Main St, Mumbai, India"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "userId": 1,
  "productId": 1,
  "quantity": 2,
  "totalPrice": 499800.00,
  "status": "CONFIRMED",
  "paymentMethod": "CREDIT_CARD",
  "shippingAddress": "123 Main St, Mumbai, India",
  "createdAt": "2024-01-01T10:00:00",
  "updatedAt": "2024-01-01T10:00:00"
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Insufficient stock for product: MacBook Pro 16\""
}
```

---

### 2. Get All Orders
```http
GET /api/orders
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "userId": 1,
    "productId": 1,
    "quantity": 2,
    "totalPrice": 499800.00,
    "status": "CONFIRMED",
    "paymentMethod": "CREDIT_CARD",
    "shippingAddress": "123 Main St, Mumbai, India",
    "createdAt": "2024-01-01T10:00:00",
    "updatedAt": "2024-01-01T10:00:00"
  }
]
```

---

### 3. Get Order by ID
```http
GET /api/orders/{id}
```

---

### 4. Get Orders by User
```http
GET /api/orders/user/{userId}
```

**Example:** `/api/orders/user/1`

---

### 5. Get Orders by Status
```http
GET /api/orders/status/{status}
```

**Valid Status Values:**
- `PENDING`
- `CONFIRMED`
- `PROCESSING`
- `SHIPPED`
- `DELIVERED`
- `CANCELLED`

**Example:** `/api/orders/status/CONFIRMED`

---

### 6. Update Order Status
```http
PATCH /api/orders/{id}/status
Content-Type: application/json
```

**Request Body:**
```json
{
  "status": "SHIPPED"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "status": "SHIPPED",
  "updatedAt": "2024-01-01T11:00:00",
  ...
}
```

---

### 7. Cancel Order
```http
DELETE /api/orders/{id}
```

**Response (200 OK):**
```json
{
  "message": "Order cancelled successfully"
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Cannot cancel order that is already shipped or delivered"
}
```

**Note:** Canceling an order automatically restores the product stock.

---

## 🏥 Health Check APIs

### API Gateway
```http
GET /health
```

**Response:**
```json
{
  "status": "UP",
  "service": "api-gateway"
}
```

### User Service
```http
GET /api/users/health
```

### Product Service
```http
GET /api/products/health
```

### Order Service
```http
GET /api/orders/health
```

---

## 🔒 Authentication Usage

For protected endpoints, include JWT token in header:

```http
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...
```

**Example with cURL:**
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## ⚠️ Common Error Responses

### 400 Bad Request
```json
{
  "error": "Validation error message"
}
```

### 401 Unauthorized
```json
{
  "error": "Invalid credentials"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found with id: X"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error message"
}
```

---

## 🧪 Testing with cURL

### Complete Flow Example

**1. Register:**
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"test123"}'
```

**2. Login:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

**3. Get Products:**
```bash
curl http://localhost:8080/api/products
```

**4. Create Order:**
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

---

## 📊 Order Status Flow

```
PENDING → CONFIRMED → PROCESSING → SHIPPED → DELIVERED
                ↓
            CANCELLED
```

---

## 💡 Tips

1. **JWT Token Expiry:** Tokens expire after 24 hours (configurable)
2. **Stock Management:** Order creation automatically reduces stock
3. **Order Cancellation:** Only PENDING, CONFIRMED, and PROCESSING orders can be cancelled
4. **Inter-Service Communication:** Order Service automatically validates with Product Service

---

**For full examples, see:** `PHASE2-SUMMARY.md`

