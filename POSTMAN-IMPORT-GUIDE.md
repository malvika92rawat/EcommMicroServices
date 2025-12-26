# Postman Collection - Simple Import Guide

## 📥 Import Instructions (Single File Only!)

### Step 1: Import the Collection

1. **Open Postman**
2. Click **"Import"** button (top left)
3. **Drag & Drop** or **Browse** to select:
   ```
   ECommerce-Microservices.postman_collection.json
   ```
4. Click **"Import"**
5. ✅ **Done!** That's it - no environment file needed!

---

## 🎯 What's Included

Everything is in ONE file:
- ✅ All 45 API requests
- ✅ Collection variables (baseUrl, jwt_token, user_id, etc.)
- ✅ Auto-save scripts for tokens and IDs
- ✅ Request validation tests
- ✅ Complete documentation

**No separate environment file required!**

---

## 🚀 Quick Start (3 Steps)

### 1. Import Collection
```
Postman → Import → Select ECommerce-Microservices.postman_collection.json
```

### 2. Start Services
```bash
cd /Users/rakuma/Documents/AIML/EcommerceMicroService
docker-compose up --build
```

### 3. Test APIs
Open collection and run:
1. **Authentication → Login** (token auto-saves)
2. **Products → Get All Products**
3. **Orders → Create Order**

---

## 📊 Collection Variables (Built-in)

These are automatically managed:

| Variable | Initial Value | Auto-Updated? |
|----------|--------------|---------------|
| `baseUrl` | http://localhost:8080 | No |
| `jwt_token` | (empty) | ✅ Yes - on login |
| `user_id` | (empty) | ✅ Yes - on login |
| `product_id` | 1 | ✅ Yes - from product list |
| `order_id` | (empty) | ✅ Yes - on order creation |

### View Variables
1. Click on collection name
2. Select **"Variables"** tab
3. See all current values

---

## 🎯 Smart Features

### ✨ Auto-Save JWT Token
When you login, JWT token is **automatically saved** to collection variables:
```javascript
pm.collectionVariables.set("jwt_token", jsonData.token);
```

### ✨ Auto-Authentication
All protected endpoints automatically use saved token:
```
Authorization: Bearer {{jwt_token}}
```

### ✨ Auto-Save IDs
- Login saves `user_id` and `jwt_token`
- Get Products saves first `product_id`
- Create Order saves `order_id`

---

## 🧪 Test Sequence

Run these in order for best results:

```
1. Authentication/Register User     → Create account
2. Authentication/Login             → Get JWT token (auto-saved)
3. Products/Get All Products        → Browse catalog
4. Products/Get Product by ID       → View details
5. Orders/Create Order              → Place order (order_id auto-saved)
6. Orders/Get Order by ID           → View your order
7. Orders/Update Order Status       → Mark as shipped
```

---

## 📁 Collection Structure

```
E-Commerce Microservices API
├── 1. Authentication (2)
│   ├── Register User
│   └── Login ⭐ (auto-saves token)
├── 2. User Management (3)
├── 3. Products (10)
│   └── Get All Products ⭐ (auto-saves product_id)
├── 4. Orders (8)
│   └── Create Order ⭐ (auto-saves order_id)
└── 5. System Health (2)
```

---

## 🔧 Customize Base URL

If your services run on different port:

1. Click **collection name**
2. Go to **"Variables"** tab
3. Change `baseUrl` current value:
   - Local: `http://localhost:8080` (default)
   - Production: `https://api.yourdomain.com`
   - Custom port: `http://localhost:9090`
4. Click **"Save"**

---

## 🐛 Troubleshooting

### "Could not get response"
**Solution:** Start services
```bash
docker-compose up --build
```

### "401 Unauthorized"
**Solution:** Run Login request again to refresh token

### Variables not saving
**Solution:** 
1. Click collection name
2. Variables tab
3. Check if scripts are enabled (they should be by default)

### View saved token
**Solution:**
1. Click collection name
2. Variables tab
3. See `jwt_token` current value

---

## 💡 Pro Tips

1. **Check Console** - See all auto-save logs
   - View → Show Postman Console
   - See: "JWT Token saved...", "Order ID saved..."

2. **Use Variables** - All requests use `{{variable}}` syntax
   - `{{baseUrl}}` for base URL
   - `{{jwt_token}}` for authentication
   - `{{product_id}}` in requests

3. **Collection Runner** - Test multiple requests
   - Click collection → Run
   - Select requests → Run
   - See all results

4. **Share Collection** - Export and share
   - Collection → ... → Export
   - Share JSON file with team
   - No environment needed!

---

## ✅ Checklist

- [ ] Imported collection (single JSON file)
- [ ] Started Docker services
- [ ] Ran Register User
- [ ] Ran Login (token saved?)
- [ ] Checked Variables tab (token visible?)
- [ ] Tested Get All Products
- [ ] Created an order
- [ ] Verified variables are auto-saving

---

## 📞 Quick Help

**See Variables:**
```
Click Collection Name → Variables Tab
```

**View Console Logs:**
```
View → Show Postman Console (or Ctrl+Alt+C)
```

**Check Token:**
```
Collection → Variables → jwt_token → Current Value
```

---

## 📚 What's Different?

### ❌ Old Way (2 files)
- Import collection JSON
- Import environment JSON
- Select environment from dropdown
- Multiple steps

### ✅ New Way (1 file)
- Import collection JSON only
- Variables built-in
- Auto-saves to collection
- Single step!

---

## 🎓 Example Workflow

```bash
# 1. Start services
docker-compose up --build

# Wait 2-3 minutes
```

Then in Postman:
```
1. Import collection (drag & drop JSON)
2. Open: Authentication → Login
3. Click Send
4. Check Console: "JWT Token saved..."
5. Try any other request - auth works automatically!
```

---

## 📍 File Location

```
/Users/rakuma/Documents/AIML/EcommerceMicroService/ECommerce-Microservices.postman_collection.json
```

**Just import this ONE file!** 🎉

---

## 🚀 You're Ready!

1. ✅ Import single JSON file
2. ✅ Start services
3. ✅ Test APIs
4. ✅ Everything auto-saves

**No environment file needed!**

---

**Happy Testing! 🎉**

