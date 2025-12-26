# Troubleshooting Guide

Common issues and solutions for E-Commerce Microservices.

---

## 🔴 Port Conflicts

### MySQL Port Already in Use

**Error:**
```
Error response from daemon: ports are not available: 
exposing port TCP 0.0.0.0:3306 -> 127.0.0.1:0: 
listen tcp 0.0.0.0:3306: bind: address already in use
```

**Cause:** MySQL is already running on your machine using port 3306.

**Solutions:**

**Option 1: Use Different Ports (Already Configured)**
```bash
# Our MySQL containers use these ports to avoid conflicts:
# - User MySQL: 3316
# - Product MySQL: 3317
# - Order MySQL: 3318

# Just run normally
docker compose up --build
```

**Option 2: Stop Local MySQL**
```bash
# macOS
brew services stop mysql

# Linux
sudo systemctl stop mysql

# Then start Docker services
docker compose up --build
```

**Option 3: Check What's Using the Port**
```bash
# Find process using port 3306
lsof -i :3306

# Kill the process (replace PID)
kill -9 <PID>
```

---

### Application Port Already in Use

**Error:**
```
bind: address already in use (port 8080, 8081, 8082, or 8083)
```

**Solution:**
```bash
# Check what's using the ports
lsof -i :8080,8081,8082,8083

# Stop the process or change ports in docker-compose.yml
# For example, change API Gateway from 8080 to 9090:
ports:
  - "9090:8080"  # host:container
```

---

## 🐳 Docker Issues

### Services Won't Start

**Symptom:** Containers exit immediately after starting

**Solutions:**

1. **Check logs:**
```bash
docker compose logs -f user-service
docker compose logs -f product-service
docker compose logs -f order-service
```

2. **Wait for MySQL:**
```bash
# MySQL takes 30-60 seconds to initialize
# Check if MySQL is healthy
docker ps

# Should show "healthy" status
```

3. **Clean restart:**
```bash
docker compose down -v
docker compose up --build
```

---

### Build Failures

**Error:** Maven build fails or dependencies not downloading

**Solutions:**

1. **Check internet connection** (Maven needs to download dependencies)

2. **Clear Maven cache and rebuild:**
```bash
docker compose down
docker compose build --no-cache user-service
docker compose up
```

3. **Check Dockerfile syntax:**
```bash
# Verify Dockerfile in each service
cat user-service/Dockerfile
```

---

### Image Platform Issues (Apple Silicon)

**Error:**
```
no match for platform in manifest: not found
```

**Solution:** Already fixed! We use multi-platform images.

If you see this error, ensure Dockerfiles use:
```dockerfile
FROM eclipse-temurin:17-jre
# NOT: eclipse-temurin:17-jre-alpine
```

---

## 🗄️ Database Issues

### Database Connection Refused

**Symptom:** Services can't connect to MySQL

**Solutions:**

1. **Wait longer:**
```bash
# MySQL needs time to initialize
# Wait 2-3 minutes on first start
docker compose logs user-mysql
```

2. **Check MySQL health:**
```bash
docker ps
# Look for "healthy" status
```

3. **Verify credentials:**
```bash
# Check docker-compose.yml environment variables
# Default: ecom_user / ecom_pass
```

4. **Test connection manually:**
```bash
docker exec -it user-mysql mysql -u ecom_user -pecom_pass user_db
```

---

### Database Initialization Failed

**Symptom:** Tables not created, sample data missing

**Solutions:**

1. **Check init scripts:**
```bash
ls shared/database-schemas/
# Should have: user-db-init.sql, product-db-init.sql, order-db-init.sql
```

2. **Force re-initialization:**
```bash
# Remove volumes and restart
docker compose down -v
docker compose up --build
```

3. **Manually run init scripts:**
```bash
docker exec -i user-mysql mysql -u ecom_user -pecom_pass user_db < shared/database-schemas/user-db-init.sql
```

---

## 🌐 Service Communication Issues

### Order Service Can't Reach Product Service

**Symptom:** Order creation fails with connection errors

**Solutions:**

1. **Check if Product Service is running:**
```bash
docker ps | grep product-service
curl http://localhost:8082/api/products/health
```

2. **Verify service URLs in docker-compose.yml:**
```yaml
order-service:
  environment:
    PRODUCT_SERVICE_URL: http://product-service:8082
```

3. **Check network:**
```bash
docker network ls
docker network inspect ecommercemicroservice_ecommerce-network
```

---

## 📡 API Issues

### 401 Unauthorized

**Cause:** JWT token expired or missing

**Solutions:**

1. **Login again to get fresh token:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}'
```

2. **Check token in Postman:**
   - Collection → Variables → jwt_token should have value

---

### 404 Not Found

**Cause:** Wrong endpoint or service not running

**Solutions:**

1. **Verify endpoint:**
```bash
# Correct endpoints:
http://localhost:8080/api/products      ✅
http://localhost:8080/products          ❌

http://localhost:8080/api/auth/login    ✅
http://localhost:8080/auth/login        ❌
```

2. **Check service health:**
```bash
curl http://localhost:8080/health
curl http://localhost:8081/api/users/health
curl http://localhost:8082/api/products/health
curl http://localhost:8083/api/orders/health
```

---

### 500 Internal Server Error

**Cause:** Service crashed or database issue

**Solutions:**

1. **Check service logs:**
```bash
docker compose logs -f <service-name>
```

2. **Look for Java exceptions** in logs

3. **Verify database connection**

---

## 🔨 Build & Compilation Issues

### Maven Dependencies Not Found

**Error:**
```
Could not resolve dependencies
```

**Solutions:**

1. **Check internet connection**

2. **Use VPN if behind firewall**

3. **Clean and rebuild:**
```bash
docker compose build --no-cache
```

---

### Java Version Mismatch

**Error:**
```
Unsupported class file version
```

**Solution:** Ensure Java 17 is used (already configured in Dockerfiles)

---

## 💾 Disk Space Issues

### No Space Left on Device

**Solutions:**

1. **Clean Docker resources:**
```bash
docker system prune -a
docker volume prune
```

2. **Check disk usage:**
```bash
docker system df
df -h
```

3. **Remove unused images:**
```bash
docker image prune -a
```

---

## 🔐 Permission Issues

### Permission Denied (Docker)

**Linux users:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and log back in
```

---

## 🧪 Testing Issues

### Postman: Could Not Get Response

**Solutions:**

1. **Verify services are running:**
```bash
docker ps
```

2. **Check baseUrl in Postman:**
   - Should be: `http://localhost:8080`

3. **Test with curl first:**
```bash
curl http://localhost:8080/health
```

---

### Order Creation Fails

**Error:**
```
Insufficient stock
```

**Solutions:**

1. **Check product stock:**
```bash
curl http://localhost:8080/api/products/1
```

2. **Reduce order quantity**

3. **Add more stock:**
```bash
curl -X PATCH http://localhost:8080/api/products/1/stock \
  -H "Content-Type: application/json" \
  -d '{"quantity": 100}'
```

---

## 🔄 Common Commands for Troubleshooting

### View All Logs
```bash
docker compose logs -f
```

### Restart Specific Service
```bash
docker compose restart user-service
```

### Check Service Status
```bash
docker ps
docker compose ps
```

### Access Container Shell
```bash
docker exec -it user-service sh
```

### Test Database Connection
```bash
docker exec -it user-mysql mysql -u ecom_user -pecom_pass user_db
```

### Check Network
```bash
docker network ls
docker network inspect ecommercemicroservice_ecommerce-network
```

### Complete Reset
```bash
# ⚠️ This deletes ALL data!
docker compose down -v
docker compose up --build
```

---

## 📋 Diagnostic Checklist

Before asking for help, verify:

- [ ] All ports are available (8080-8083, 3316-3318)
- [ ] Docker is running (`docker --version`)
- [ ] All containers are up (`docker ps`)
- [ ] MySQL containers show "healthy" status
- [ ] Can access health endpoints
- [ ] Checked logs for errors
- [ ] Internet connection working (for builds)
- [ ] Enough disk space

---

## 🆘 Still Having Issues?

1. **Check logs:**
```bash
docker compose logs -f > logs.txt
```

2. **Check versions:**
```bash
docker --version
docker compose version
java --version
```

3. **Try fresh start:**
```bash
docker compose down -v
docker system prune -a
docker compose up --build
```

---

## 📚 Related Documentation

- [Getting Started Guide](GETTING-STARTED.md)
- [Docker Commands](DOCKER-COMMANDS.md)
- [Quick Reference](QUICK-REFERENCE.md)

---

**Most issues are resolved by:** `docker compose down -v && docker compose up --build`

