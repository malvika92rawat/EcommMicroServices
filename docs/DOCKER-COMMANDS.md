# Docker Commands Reference

Quick reference for both newer and older Docker versions.

---

## 🔍 Check Your Docker Version

```bash
# Check Docker version
docker --version

# Check if you have docker compose (newer)
docker compose version

# Check if you have docker-compose (older)
docker-compose --version
```

**If `docker compose version` works → Use commands WITHOUT hyphen**  
**If only `docker-compose --version` works → Use commands WITH hyphen**

---

## 🚀 Basic Commands

### Start Services

```bash
# Newer Docker (recommended)
docker compose up --build

# Older Docker
docker-compose up --build
```

### Start in Background

```bash
# Newer Docker
docker compose up -d

# Older Docker
docker-compose up -d
```

### Stop Services

```bash
# Newer Docker
docker compose down

# Older Docker
docker-compose down
```

### Stop and Remove All Data

```bash
# Newer Docker
docker compose down -v

# Older Docker
docker-compose down -v
```

---

## 📊 View Logs

### All Services

```bash
# Newer Docker
docker compose logs -f

# Older Docker
docker-compose logs -f
```

### Specific Service

```bash
# Newer Docker
docker compose logs -f user-service

# Older Docker
docker-compose logs -f user-service
```

---

## 🔄 Restart Services

### Restart All

```bash
# Newer Docker
docker compose restart

# Older Docker
docker-compose restart
```

### Restart Specific Service

```bash
# Newer Docker
docker compose restart user-service

# Older Docker
docker-compose restart user-service
```

---

## 🧹 Cleanup Commands

### Remove Stopped Containers

```bash
docker container prune
```

### Remove Unused Images

```bash
docker image prune -a
```

### Full Cleanup (Use with Caution!)

```bash
docker system prune -a --volumes
```

---

## 📋 List Commands

### List Running Containers

```bash
docker ps
```

### List All Containers (including stopped)

```bash
docker ps -a
```

### List Images

```bash
docker images
```

### List Networks

```bash
docker network ls
```

### List Volumes

```bash
docker volume ls
```

---

## 🔍 Inspect Commands

### View Container Details

```bash
docker inspect <container-name>
```

### View Container Logs (without compose)

```bash
docker logs -f <container-name>
```

### Execute Command in Running Container

```bash
docker exec -it <container-name> sh
```

### Example: Access MySQL Database

```bash
docker exec -it user-mysql mysql -u ecom_user -pecom_pass user_db
```

---

## 🛠️ Build Commands

### Build Without Cache

```bash
# Newer Docker
docker compose build --no-cache

# Older Docker
docker-compose build --no-cache
```

### Build Specific Service

```bash
# Newer Docker
docker compose build user-service

# Older Docker
docker-compose build user-service
```

---

## ⚡ Quick Troubleshooting

### Fresh Start (Complete Reset)

```bash
# Newer Docker
docker compose down -v
docker compose up --build

# Older Docker
docker-compose down -v
docker-compose up --build
```

### Check If Services Are Healthy

```bash
docker ps

# Look for "healthy" in STATUS column
```

### View Resource Usage

```bash
docker stats
```

### Check Disk Usage

```bash
docker system df
```

---

## 📝 Common Scenarios

### Scenario 1: First Time Setup

```bash
cd EcommerceMicroService
docker compose up --build
```

Wait 2-3 minutes for all services to start.

---

### Scenario 2: Code Changed, Need to Rebuild

```bash
docker compose down
docker compose up --build
```

---

### Scenario 3: Database Issue, Need Clean Start

```bash
docker compose down -v
docker compose up --build
```

**Warning:** This deletes all data!

---

### Scenario 4: Check Why Service Failed

```bash
# View all logs
docker compose logs -f

# View specific service logs
docker compose logs -f user-service

# Check container status
docker ps -a
```

---

### Scenario 5: Port Already in Use

```bash
# Find what's using the port
lsof -i :8080

# Stop services
docker compose down

# Kill the process using the port (if needed)
kill -9 <PID>

# Start again
docker compose up
```

---

## 🎯 Pro Tips

1. **Use `-d` for background mode** when you don't need to watch logs
   ```bash
   docker compose up -d
   ```

2. **Follow logs after background start**
   ```bash
   docker compose up -d
   docker compose logs -f
   ```

3. **Rebuild single service** to save time
   ```bash
   docker compose up --build user-service
   ```

4. **Check health before testing**
   ```bash
   docker ps
   # All services should show "Up" or "healthy"
   ```

5. **Clean shutdown** before closing terminal
   ```bash
   docker compose down
   ```

---

## 🔄 Migration: docker-compose → docker compose

If you have older scripts using `docker-compose`, just replace:

```bash
# Old syntax
docker-compose up --build

# New syntax
docker compose up --build
```

The commands are identical, just without the hyphen!

---

## ✅ Checklist for Troubleshooting

- [ ] Docker is running (`docker --version`)
- [ ] No port conflicts (`lsof -i :8080,8081,8082,8083,3306,3307,3308`)
- [ ] All containers are up (`docker ps`)
- [ ] Services are healthy (`docker ps` shows "healthy")
- [ ] No errors in logs (`docker compose logs`)
- [ ] Can access API Gateway (http://localhost:8080)

---

**Need Help?** Check the main `../README.md` or `docs/GETTING-STARTED.md` for detailed guides.

---

**Quick Reference:**
- Start: `docker compose up --build`
- Stop: `docker compose down`
- Clean restart: `docker compose down -v && docker compose up --build`
- Logs: `docker compose logs -f`

