# OWASP Top 10 Reference Guide

## Overview
OWASP Top 10 là danh sách 10 rủi ro bảo mật web application phổ biến nhất. Reference guide cho dev-security sessions.

---

## A01:2021 - Broken Access Control

### Description
Access control thực thi policies để users không thể hành động ngoài quyền hạn của họ. Failures thường dẫn đến unauthorized information disclosure, modification, hoặc destruction of data.

### Examples
```
- IDOR (Insecure Direct Object References)
  /api/users/123/profile → Có thể access /api/users/456/profile

- Missing function level access control
  /admin/users → Accessible bởi non-admin users

- Privilege escalation
  Thay đổi role trong request body: {"role": "admin"}
```

### Prevention
```python
# Bad
@app.route('/api/users/<user_id>/profile')
def get_profile(user_id):
    return User.query.get(user_id).to_dict()

# Good
@app.route('/api/users/<user_id>/profile')
@login_required
def get_profile(user_id):
    if current_user.id != user_id and not current_user.is_admin:
        abort(403)
    return User.query.get(user_id).to_dict()
```

### Checklist
- [ ] Deny by default
- [ ] Implement access control mechanisms once, reuse
- [ ] Log access control failures
- [ ] Rate limit API access
- [ ] Invalidate sessions on logout

---

## A02:2021 - Cryptographic Failures

### Description
Failures related to cryptography leading to exposure of sensitive data.

### Examples
```
- Storing passwords as plaintext or weak hashes (MD5, SHA1)
- Transmitting data over HTTP instead of HTTPS
- Using deprecated crypto algorithms
- Hardcoded encryption keys
```

### Prevention
```python
# Bad - MD5 for passwords
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()

# Good - bcrypt
import bcrypt
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt(12))

# Good - argon2
from argon2 import PasswordHasher
ph = PasswordHasher()
password_hash = ph.hash(password)
```

### Checklist
- [ ] Classify data by sensitivity
- [ ] Don't store sensitive data unnecessarily
- [ ] Encrypt all data in transit (TLS 1.2+)
- [ ] Encrypt sensitive data at rest
- [ ] Use strong algorithms (AES-256, RSA-2048+)
- [ ] Use proper key management

---

## A03:2021 - Injection

### Description
Hostile data sent to an interpreter as part of a command or query.

### Types
- SQL Injection
- NoSQL Injection
- Command Injection
- LDAP Injection
- XPath Injection

### Prevention
```python
# SQL Injection - Bad
query = f"SELECT * FROM users WHERE username = '{username}'"
cursor.execute(query)

# SQL Injection - Good (parameterized)
query = "SELECT * FROM users WHERE username = %s"
cursor.execute(query, (username,))

# Command Injection - Bad
import os
os.system(f"ping {user_input}")

# Command Injection - Good
import subprocess
subprocess.run(["ping", "-c", "4", user_input], check=True)
```

### Checklist
- [ ] Use parameterized queries/prepared statements
- [ ] Use ORM frameworks properly
- [ ] Validate and sanitize all input
- [ ] Escape special characters
- [ ] Use allowlist input validation

---

## A04:2021 - Insecure Design

### Description
Missing or ineffective security controls by design.

### Examples
```
- No rate limiting on password reset
- Security questions for recovery
- Unlimited failed login attempts
- No CAPTCHA on public forms
```

### Prevention
- Threat modeling during design
- Secure design patterns
- Reference architecture
- Security requirements in stories

### Checklist
- [ ] Use threat modeling
- [ ] Integrate security in SDLC
- [ ] Use secure design patterns
- [ ] Write security user stories
- [ ] Plausibility checks for business logic

---

## A05:2021 - Security Misconfiguration

### Description
Missing or incorrect security hardening.

### Examples
```
- Default credentials
- Unnecessary features enabled
- Verbose error messages
- Missing security headers
- Outdated software
```

### Prevention
```nginx
# Security headers
add_header X-Frame-Options "DENY";
add_header X-Content-Type-Options "nosniff";
add_header X-XSS-Protection "1; mode=block";
add_header Content-Security-Policy "default-src 'self'";
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
```

### Checklist
- [ ] Minimal platform installation
- [ ] Review and update configurations regularly
- [ ] Implement proper security headers
- [ ] Disable debug mode in production
- [ ] Remove default accounts

---

## A06:2021 - Vulnerable and Outdated Components

### Description
Using components with known vulnerabilities.

### Tools
```bash
# Python
pip-audit
safety check

# JavaScript
npm audit
snyk test

# Java
OWASP Dependency-Check
```

### Checklist
- [ ] Inventory of components and versions
- [ ] Remove unused dependencies
- [ ] Monitor for vulnerabilities
- [ ] Update components regularly
- [ ] Only obtain from official sources

---

## A07:2021 - Identification and Authentication Failures

### Description
Confirmation of user's identity and authentication failures.

### Examples
```
- Weak passwords allowed
- Credential stuffing
- Improper session management
- Missing MFA
```

### Prevention
```python
# Session management
from flask import session
import secrets

session.permanent = True
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'

# Generate secure session ID
session_id = secrets.token_urlsafe(32)
```

### Checklist
- [ ] Implement MFA where possible
- [ ] Use secure password policies
- [ ] Implement proper session management
- [ ] Invalidate sessions on logout
- [ ] Use secure "forgot password" flows

---

## A08:2021 - Software and Data Integrity Failures

### Description
Code and infrastructure that don't protect against integrity violations.

### Examples
```
- Insecure deserialization
- Unsigned updates
- Untrusted CI/CD pipelines
- Dependency confusion attacks
```

### Prevention
```python
# Deserialization - Bad
import pickle
data = pickle.loads(user_input)  # Dangerous!

# Deserialization - Good
import json
data = json.loads(user_input)  # Safe for simple data

# Always validate and sanitize
```

### Checklist
- [ ] Use digital signatures
- [ ] Verify component sources
- [ ] Review CI/CD pipeline security
- [ ] Avoid insecure deserialization

---

## A09:2021 - Security Logging and Monitoring Failures

### Description
Insufficient logging and monitoring to detect attacks.

### What to Log
```python
# Security-relevant events
- Authentication successes and failures
- Access control failures
- Input validation failures
- Application errors
- Suspicious activity
```

### Format
```json
{
    "timestamp": "2024-01-15T10:30:00Z",
    "level": "WARN",
    "event": "authentication_failure",
    "user_id": "unknown",
    "ip": "192.168.1.100",
    "details": "Invalid password for username: admin",
    "request_id": "abc-123"
}
```

### Checklist
- [ ] Log authentication events
- [ ] Log access control failures
- [ ] Log input validation failures
- [ ] Ensure logs don't contain sensitive data
- [ ] Monitor logs for suspicious activity

---

## A10:2021 - Server-Side Request Forgery (SSRF)

### Description
Web application fetches remote resource without validating user-supplied URL.

### Examples
```
# Attacker provides:
url=http://169.254.169.254/latest/meta-data/  # AWS metadata
url=http://localhost:8080/admin               # Internal services
url=file:///etc/passwd                        # Local files
```

### Prevention
```python
# Validate URL
from urllib.parse import urlparse
import ipaddress

def is_safe_url(url):
    parsed = urlparse(url)

    # Only allow HTTP/HTTPS
    if parsed.scheme not in ('http', 'https'):
        return False

    # Check for private IPs
    try:
        ip = ipaddress.ip_address(parsed.hostname)
        if ip.is_private or ip.is_loopback:
            return False
    except ValueError:
        pass  # It's a hostname, not an IP

    # Whitelist allowed domains
    allowed_domains = ['api.trusted.com', 'cdn.trusted.com']
    if parsed.hostname not in allowed_domains:
        return False

    return True
```

### Checklist
- [ ] Validate and sanitize all URLs
- [ ] Use allowlist for URLs/domains
- [ ] Disable unnecessary URL schemes
- [ ] Don't send raw responses to clients
- [ ] Use network segmentation

---

## Quick Reference Card

| Risk | One-liner Prevention |
|------|---------------------|
| A01 | Deny by default, check every request |
| A02 | Encrypt everything, use strong crypto |
| A03 | Use parameterized queries, validate input |
| A04 | Threat model, secure design patterns |
| A05 | Harden everything, security headers |
| A06 | Keep dependencies updated |
| A07 | Strong auth, MFA, secure sessions |
| A08 | Sign everything, verify integrity |
| A09 | Log security events, monitor actively |
| A10 | Validate URLs, allowlist destinations |

---

## References

- [OWASP Top 10:2021](https://owasp.org/Top10/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
