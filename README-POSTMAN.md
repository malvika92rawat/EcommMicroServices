# 📮 Postman Collection - Quick Import

## ⚡ Super Simple Import (1 File Only!)

### Just 3 Steps:

1. **Open Postman**
2. **Drag & Drop** this file:
   ```
   ECommerce-Microservices.postman_collection.json
   ```
3. **Done!** ✅

**No environment file needed - everything is included!**

---

## 📦 What You Get

✅ **45 API requests** fully configured  
✅ **All variables** included (baseUrl, jwt_token, etc.)  
✅ **Auto-save scripts** for tokens and IDs  
✅ **Request validation** tests  
✅ **Complete documentation** for each endpoint  

**Single file import - no additional setup!**

---

## 🚀 Quick Test

After import:

```bash
# 1. Start services
docker-compose up --build

# 2. In Postman, run:
#    - Authentication → Login
#    - Products → Get All Products
#    - Orders → Create Order
```

---

## 📊 Collection Variables (Built-in)

| Variable | Auto-Saved? | When? |
|----------|-------------|-------|
| `baseUrl` | No | Default: localhost:8080 |
| `jwt_token` | ✅ Yes | On login |
| `user_id` | ✅ Yes | On login |
| `product_id` | ✅ Yes | Get products |
| `order_id` | ✅ Yes | Create order |

**View:** Click collection → Variables tab

---

## 🎯 How Auto-Save Works

### 1. Login Request
```javascript
// Automatically runs after login
pm.collectionVariables.set("jwt_token", jsonData.token);
pm.collectionVariables.set("user_id", jsonData.id);
```

### 2. Protected Requests
```
Authorization: Bearer {{jwt_token}}
```
Automatically uses saved token!

---

## 💡 Key Features

### ✨ No Copy/Paste
- Token saved automatically
- IDs saved automatically
- Just click Send!

### ✨ Smart Tests
- Validates responses
- Checks status codes
- Logs useful info

### ✨ Single File
- No environment needed
- No extra setup
- Import and go!

---

## 🔧 Change Base URL?

1. Click collection name
2. Variables tab
3. Change `baseUrl` value
4. Save

---

## 📁 File Location

```
/Users/rakuma/Documents/AIML/EcommerceMicroService/
└── ECommerce-Microservices.postman_collection.json  ← Import this!
```

---

## ✅ That's It!

**Just import the JSON file and you're ready to test!** 🎉

For detailed guide, see: `POSTMAN-IMPORT-GUIDE.md`

---

**Happy Testing! 🚀**

