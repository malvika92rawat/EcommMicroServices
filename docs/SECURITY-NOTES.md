# Security Notes

Important security considerations for the E-Commerce Microservices project.

---

## ⚠️ IMPORTANT: For Learning Purposes Only

This project is designed for **educational purposes** to learn microservices architecture, Spring Boot, and AWS deployment.

**DO NOT use in production without proper security hardening!**

---

## 🔐 JWT Configuration

### Current Setup

The JWT secret key has been configured with a secure 512-bit key suitable for HS512 algorithm.

**Location:** `user-service/src/main/resources/application.yml`

```yaml
jwt:
  secret: 5367566B59703373367639792F423F4528482B4D6251655468576D5A71347437776A5A7234753778217A25432A462D4A614E645267556B58703273357638792F42
  expiration: 86400000 # 24 hours
```

### Why This Key?

- **512 bits (64 bytes)** - Meets HS512 algorithm requirements
- **Hexadecimal format** - Secure and compatible
- **Random generation** - Not a simple password

### Generate Your Own Key

For production or your own learning environment:

**Option 1: Using Java**
```java
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import javax.crypto.SecretKey;
import java.util.Base64;

SecretKey key = Keys.secretKeyFor(SignatureAlgorithm.HS512);
String base64Key = Base64.getEncoder().encodeToString(key.getEncoded());
System.out.println(base64Key);
```

**Option 2: Using OpenSSL**
```bash
openssl rand -hex 64
```

**Option 3: Using Node.js**
```javascript
require('crypto').randomBytes(64).toString('hex')
```

**Option 4: Using Python**
```python
import secrets
secrets.token_hex(64)
```

---

## 🔒 Security Best Practices

### For Learning (Current Setup)

✅ **Acceptable:**
- JWT secret hardcoded in config
- Simple password requirements
- Basic BCrypt encryption
- Default database credentials

### For Production (Required Changes)

❌ **NEVER do in production:**
- Hardcoded secrets in source code
- Weak passwords
- Default credentials
- No HTTPS/TLS
- No rate limiting
- No input sanitization beyond basic validation

✅ **Must implement:**
1. **Use Environment Variables** for secrets
2. **AWS Secrets Manager** or similar for production
3. **Strong password policies**
4. **HTTPS/TLS** encryption
5. **Rate limiting** on APIs
6. **API key authentication** for service-to-service
7. **SQL injection protection** (already using JPA/Hibernate)
8. **CORS restrictions** (currently allows all origins)
9. **Input validation** (enhance beyond basic @Valid)
10. **Monitoring and alerting**

---

## 🗝️ Database Credentials

### Current (Learning Environment)

```yaml
username: ecom_user
password: ecom_pass
```

### For Production

1. **Use AWS RDS** with IAM authentication
2. **Rotate credentials** regularly
3. **Use AWS Secrets Manager**
4. **Restrict network access** with security groups
5. **Enable encryption** at rest and in transit

---

## 🌐 CORS Configuration

### Current Setup

```yaml
allowedOrigins: "*"  # Allows all origins
```

**⚠️ Security Risk:** This allows any website to call your API.

### For Production

```yaml
allowedOrigins:
  - "https://yourdomain.com"
  - "https://app.yourdomain.com"
```

Only allow specific, trusted domains.

---

## 🔐 Password Security

### Current Implementation

- **BCrypt** with default strength (10 rounds)
- **Minimum 6 characters** (for learning)
- **No complexity requirements**

### For Production

```java
// Increase BCrypt rounds
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(12); // Stronger, but slower
}
```

**Password Policy:**
- Minimum 12 characters
- Require uppercase, lowercase, numbers, special chars
- Password history (prevent reuse)
- Account lockout after failed attempts
- Two-factor authentication (2FA)

---

## 🛡️ API Security Enhancements

### Current (Basic)

- JWT authentication
- Role-based access (USER, ADMIN)
- Token expiration (24 hours)

### Production Additions

1. **Rate Limiting**
```java
@RateLimit(key = "#username", limit = 5, period = 60)
public ResponseEntity<?> login(@RequestBody LoginRequest request)
```

2. **API Keys for Services**
```java
@PreAuthorize("hasRole('SERVICE') or hasRole('ADMIN')")
```

3. **Request Signing**
4. **IP Whitelisting**
5. **Token Refresh Mechanism**
6. **Blacklist for revoked tokens**

---

## 🔍 Security Checklist

### ✅ Implemented (Good for Learning)

- [x] JWT authentication
- [x] Password encryption (BCrypt)
- [x] Role-based access control
- [x] SQL injection protection (JPA)
- [x] Secure JWT secret key (512 bits)

### ⚠️ Missing (Required for Production)

- [ ] Secrets in environment variables/AWS Secrets Manager
- [ ] HTTPS/TLS encryption
- [ ] Rate limiting
- [ ] CORS restrictions
- [ ] Strong password policy
- [ ] Account lockout
- [ ] Two-factor authentication
- [ ] API key management
- [ ] Security headers (CSP, HSTS, etc.)
- [ ] Audit logging
- [ ] Vulnerability scanning
- [ ] Penetration testing

---

## 🚨 Common Security Mistakes to Avoid

### 1. Exposing Secrets in Git

❌ **NEVER commit:**
- `.env` files with real credentials
- `application.yml` with production secrets
- Private keys

✅ **Always use:**
- `.gitignore` for sensitive files
- Environment variables
- Secret management services

### 2. Using Weak Secrets

❌ **Weak:**
```
jwt.secret=mysecret
password=password123
```

✅ **Strong:**
```
jwt.secret=<64+ random characters>
password=<12+ chars with complexity>
```

### 3. Trusting Client Input

❌ **Never trust:**
- User input without validation
- Client-side generated IDs
- Unverified JWT claims

✅ **Always:**
- Validate all inputs
- Generate IDs server-side
- Verify JWT signatures

### 4. Insufficient Logging

❌ **Missing:**
- Failed login attempts
- Authorization failures
- Suspicious activity

✅ **Log:**
- All authentication events
- Authorization decisions
- API usage patterns
- Errors and exceptions

---

## 📚 Security Resources

### Learn More

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [Spring Security Docs](https://spring.io/projects/spring-security)
- [AWS Security Best Practices](https://aws.amazon.com/security/best-practices/)

### Tools

- **OWASP ZAP** - Security testing
- **SonarQube** - Code quality and security
- **Snyk** - Dependency scanning
- **AWS Security Hub** - Cloud security posture

---

## 🎓 For Students

### What You Should Learn

1. **Understand** why each security measure is important
2. **Practice** implementing proper authentication
3. **Recognize** common vulnerabilities
4. **Know** the difference between dev and prod security

### Exercises

1. Try to break the authentication
2. Test SQL injection (won't work with JPA!)
3. Attempt XSS attacks
4. Try brute force login
5. Analyze JWT tokens

### Questions to Explore

- How does JWT work?
- Why is BCrypt better than MD5/SHA?
- What is CORS and why does it matter?
- How do you store secrets securely?
- What is the principle of least privilege?

---

## ⚡ Quick Security Improvements

### For Your Learning Environment

1. **Change default passwords** (already using env vars in docker-compose)
2. **Use longer JWT expiration** for convenience (24h is fine for learning)
3. **Test with Postman** - learn how authentication works
4. **Read security docs** - understand what you're building

### Preparing for Production

1. **Move secrets to environment variables**
2. **Set up AWS Secrets Manager**
3. **Enable HTTPS** (use AWS Certificate Manager)
4. **Restrict CORS** to your domain
5. **Add rate limiting**
6. **Enable CloudWatch logging**
7. **Set up AWS WAF** (Web Application Firewall)

---

## 🔄 Rotating Secrets

### JWT Secret Rotation

**Why?** Limit damage if secret is compromised

**How:**
1. Generate new secret
2. Keep old secret temporarily
3. Gradually phase out old tokens
4. Remove old secret

### Database Password Rotation

**Why?** Regular rotation reduces risk

**How with AWS RDS:**
1. Use AWS Secrets Manager rotation
2. Automatic rotation every 30-90 days
3. Zero-downtime rotation
4. Audit trail

---

## 📝 Security Incident Response

### If You Suspect a Breach

1. **Immediately rotate** all secrets
2. **Revoke all JWT tokens** (implement token blacklist)
3. **Review logs** for suspicious activity
4. **Notify affected users**
5. **Document the incident**
6. **Fix the vulnerability**

---

## 🎯 Summary

### Current State (Learning)
✅ Secure enough for learning and local development  
✅ Demonstrates security concepts  
⚠️ NOT suitable for production  

### Production Requirements
🔒 Move all secrets to AWS Secrets Manager  
🔒 Enable HTTPS/TLS  
🔒 Implement comprehensive security measures  
🔒 Regular security audits  

---

**Remember: Security is a journey, not a destination!**

Always stay updated with the latest security best practices and vulnerabilities.

