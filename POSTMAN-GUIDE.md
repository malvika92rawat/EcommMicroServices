# Postman Collection Guide

Complete guide to using the Postman collection for E-Commerce Microservices API.

## 📥 Import Instructions (Single File!)

### Step 1: Import the Collection

1. **Open Postman**
2. Click **"Import"** button (top left)
3. **Drag & Drop** or **Browse** to select:
   ```
   ECommerce-Microservices.postman_collection.json
   ```
4. Click **"Import"**
5. ✅ **Done!** No environment file needed!

**Note:** All variables are included in the collection - no separate environment required!

---

## 🚀 Quick Start

### 1. Start Your Services

```bash
cd /Users/rakuma/Documents/AIML/EcommerceMicroService
docker-compose up --build
```

Wait 2-3 minutes for all services to start.

### 2. Run Test Sequence in Postman

**Order matters! Follow this sequence:**

#### A. Authentication Flow

1. **Register User**
   - Folder: `1. Authentication`
   - Request: `Register User`
   - Click **"Send"**
   - ✅ You should see: `{"message": "User registered successfully!"}`

2. **Login**
   - Request: `Login`
   - Click **"Send"**
   - ✅ JWT token is **automatically saved** to environment
   - Check: Environment tab → `jwt_token` should have a value

#### B. Test Product APIs

3. **Get All Products**
   - Folder: `3. Products`
   - Request: `Get All Products`
   - Click **"Send"**
   - ✅ See list of 10 products

4. **Get Product by ID**
   - Request: `Get Product by ID`
   - Click **"Send"**
   - ✅ See product details

5. **Search Products**
   - Request: `Search Products`
   - Click **"Send"**
   - ✅ Search results for "MacBook"

#### C. Test Order APIs

6. **Create Order**
   - Folder: `4. Orders`
   - Request: `Create Order`
   - Click **"Send"**
   - ✅ Order created with `CONFIRMED` status
   - ✅ `order_id` automatically saved

7. **Get All Orders**
   - Request: `Get All Orders`
   - Click **"Send"**
   - ✅ See your created order

8. **Update Order Status**
   - Request: `Update Order Status`
   - Click **"Send"**
   - ✅ Order status changed to `SHIPPED`

---

## 📚 Collection Structure

```
E-Commerce Microservices API
├── 1. Authentication
│   ├── Register User
│   └── Login (auto-saves JWT token)
├── 2. User Management
│   ├── Get All Users (Admin)
│   ├── Get User by ID
│   └── Health Check
├── 3. Products
│   ├── Get All Products
│   ├── Get Product by ID
│   ├── Get Products by Category
│   ├── Search Products
│   ├── Create Product
│   ├── Update Product
│   ├── Update Stock
│   ├── Check Stock Availability
│   ├── Delete Product
│   └── Health Check
├── 4. Orders
│   ├── Create Order (auto-saves order_id)
│   ├── Get All Orders
│   ├── Get Order by ID
│   ├── Get Orders by User
│   ├── Get Orders by Status
│   ├── Update Order Status
│   ├── Cancel Order
│   └── Health Check
└── 5. System Health
    ├── API Gateway Health
    └── API Gateway Home
```

---

## 🔧 Collection Variables

The collection uses these variables (automatically managed):

| Variable | Purpose | Auto-Saved? |
|----------|---------|-------------|
| `baseUrl` | API Gateway URL | No (default: localhost:8080) |
| `jwt_token` | JWT authentication token | ✅ Yes (on login) |
| `user_id` | Logged-in user ID | ✅ Yes (on login) |
| `product_id` | Sample product ID | ✅ Yes (from product list) |
| `order_id` | Created order ID | ✅ Yes (on order creation) |

### View/Edit Variables

1. Click **collection name** in sidebar
2. Click **"Variables"** tab
3. See current values and edit if needed

---

## 🎯 Smart Features

### 1. Auto-Save JWT Token

When you login, the JWT token is **automatically saved** to collection variables:

```javascript
// Happens automatically in Login request
var jsonData = pm.response.json();
pm.collectionVariables.set("jwt_token", jsonData.token);
pm.collectionVariables.set("user_id", jsonData.id);
```

No need to copy/paste tokens!

### 2. Auto-Authentication

Requests requiring authentication automatically use the saved token:

```
Authorization: Bearer {{jwt_token}}
```

Just click Send - token is applied automatically!

### 3. Auto-Save IDs

- Login saves `user_id`
- Get Products saves first `product_id`
- Create Order saves `order_id`

Use these in subsequent requests!

### 4. Test Scripts

Each request includes test scripts that:
- ✅ Verify response status
- ✅ Check response structure
- ✅ Auto-save important values
- ✅ Log helpful information

Check the **"Tests" tab** in each request to see what it does.

---

## 📝 Example Workflows

### Workflow 1: Complete Order Flow

1. **Login** (saves token)
2. **Get All Products** (saves product_id)
3. **Create Order** (uses product_id, saves order_id)
4. **Get Order by ID** (uses order_id)
5. **Update Order Status** (mark as SHIPPED)
6. **Get Orders by Status** (verify status changed)

### Workflow 2: Product Management

1. **Get All Products**
2. **Create Product** (add new item)
3. **Update Product** (modify details)
4. **Update Stock** (reduce quantity)
5. **Check Stock Availability** (verify stock)
6. **Delete Product** (remove item)

### Workflow 3: Admin Operations

1. **Login** (as admin user)
2. **Get All Users** (admin only)
3. **Create Product** (add products)
4. **Get All Orders** (view all orders)
5. **Update Order Status** (process orders)

---

## 🎨 Customization

### Change Base URL

If services run on different ports:

1. Click **collection name** in sidebar
2. Go to **"Variables"** tab
3. Change `baseUrl` current value:
   - Production: `https://api.yourdomain.com`
   - Different port: `http://localhost:9090`
4. Click **"Save"**

### Add New Requests

1. Right-click on a folder
2. Select **"Add Request"**
3. Configure:
   - Method (GET, POST, etc.)
   - URL: `{{baseUrl}}/api/endpoint`
   - Body (if needed)
   - Tests (optional)

---

## 🧪 Testing Tips

### 1. Use Test Tab

Every request has a **Tests** tab showing what's validated:

```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```

### 2. Check Console

View detailed logs:
- Click **"Console"** button (bottom left)
- See all requests/responses
- Debug issues

### 3. Use Pre-request Scripts

Run code before requests:
- **Pre-request Script** tab
- Generate dynamic data
- Set variables

### 4. Collection Runner

Run multiple requests automatically:
1. Click **"Runner"** button
2. Select collection
3. Click **"Run"**
4. See all results

---

## 🔍 Common Use Cases

### Register Multiple Users

Edit the **Register User** request body:

```json
{
  "username": "student1",
  "email": "student1@test.com",
  "password": "password123",
  "role": "USER"
}
```

Change username/email for each test user.

### Test Different Products

Edit product ID in URL:

```
{{baseUrl}}/api/products/1    → First product
{{baseUrl}}/api/products/2    → Second product
```

### Create Multiple Orders

Change the **Create Order** request:

```json
{
  "userId": 1,
  "productId": 2,     ← Change this
  "quantity": 3,      ← Change this
  "paymentMethod": "UPI",
  "shippingAddress": "Different address"
}
```

### Test Order Status Flow

Use **Update Order Status** with different values:

```json
{"status": "CONFIRMED"}
{"status": "PROCESSING"}
{"status": "SHIPPED"}
{"status": "DELIVERED"}
```

---

## 🐛 Troubleshooting

### Problem: "Could not get response"

**Cause:** Services not running

**Solution:**
```bash
docker-compose up
```

Wait 2-3 minutes, then retry.

---

### Problem: "401 Unauthorized"

**Cause:** JWT token missing or expired

**Solution:**
1. Run **Login** request again
2. Check collection → Variables tab → `jwt_token` has value
3. Retry your request

---

### Problem: Token not auto-saving

**Solution:**
1. Check **Tests** tab in Login request
2. Verify script is present
3. Check **Console** for errors
4. Manually set: Collection → Variables → `jwt_token` → paste token

---

### Problem: "Product not found"

**Cause:** Wrong product ID

**Solution:**
1. Run **Get All Products**
2. Check `product_id` in collection variables
3. Use valid ID from product list

---

### Problem: "Insufficient stock"

**Cause:** Not enough items in inventory

**Solution:**
1. Check product stock: **Get Product by ID**
2. Reduce order quantity
3. Or use **Update Stock** to add more

---

## 📊 Response Examples

### Successful Login

```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "testuser",
  "email": "testuser@example.com",
  "role": "USER"
}
```

### Product List

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

### Order Creation

```json
{
  "id": 1,
  "userId": 1,
  "productId": 1,
  "quantity": 1,
  "totalPrice": 249900.00,
  "status": "CONFIRMED",
  "paymentMethod": "CREDIT_CARD",
  "shippingAddress": "123 Main Street, Mumbai, India",
  "createdAt": "2024-01-01T10:00:00",
  "updatedAt": "2024-01-01T10:00:00"
}
```

---

## 💡 Pro Tips

1. **Use Folders** - Organize related requests
2. **Save Examples** - Save responses as examples for documentation
3. **Use Variables** - Make requests reusable
4. **Write Tests** - Automate validation
5. **Use Console** - Debug issues easily
6. **Collection Runner** - Test entire flows
7. **Share Collections** - Export and share with team
8. **Generate Documentation** - Postman auto-generates API docs

---

## 📤 Export & Share

### Export Collection

1. Click **"..."** next to collection name
2. Select **"Export"**
3. Choose **Collection v2.1**
4. Save JSON file
5. Share with others

### Share Collection Variables

All variables are included in the collection export - no separate environment file needed!

---

## 🎓 Learning Exercises

### Exercise 1: Complete User Journey

1. Register new user
2. Login to get token
3. Browse products
4. Create an order
5. Track order status

### Exercise 2: Admin Workflow

1. Login as admin
2. Create new products
3. Update stock levels
4. View all orders
5. Process orders (update status)

### Exercise 3: Error Handling

1. Try creating order with invalid product
2. Try ordering more than available stock
3. Try cancelling delivered order
4. Observe error responses

---

## 📚 Additional Resources

- **Full API Documentation**: `API-REFERENCE.md`
- **Quick Reference**: `QUICK-REFERENCE.md`
- **Getting Started**: `GETTING-STARTED.md`
- **Project Overview**: `README.md`

---

## ✅ Checklist

- [ ] Imported collection into Postman (single file!)
- [ ] Started Docker services
- [ ] Successfully registered a user
- [ ] Successfully logged in (token saved to collection)
- [ ] Verified token in Variables tab
- [ ] Tested product endpoints
- [ ] Created an order
- [ ] Updated order status
- [ ] Explored all folders

---

**Postman Collection Location:**
```
/Users/rakuma/Documents/AIML/EcommerceMicroService/ECommerce-Microservices.postman_collection.json
```

**Note:** All variables included in collection - no separate environment file needed!

---

**Happy Testing! 🚀**

