# Secure Code Review Checklist

## Overview
Checklist cho security-focused code review trong dev-security sessions.

---

## 1. Authentication

### Password Handling
- [ ] Passwords hashed with bcrypt/argon2 (not MD5/SHA1)
- [ ] Salt is unique per password (auto with bcrypt/argon2)
- [ ] Cost factor is sufficient (bcrypt >= 12)
- [ ] Passwords not logged or exposed in errors

```python
# Good
from argon2 import PasswordHasher
ph = PasswordHasher()
hash = ph.hash(password)

# Bad
import hashlib
hash = hashlib.md5(password.encode()).hexdigest()
```

### Session Management
- [ ] Session IDs are cryptographically random
- [ ] Sessions expire after inactivity
- [ ] Sessions invalidated on logout
- [ ] Session cookies have Secure, HttpOnly, SameSite flags

```python
# Flask session configuration
app.config.update(
    SESSION_COOKIE_SECURE=True,
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
    PERMANENT_SESSION_LIFETIME=timedelta(hours=1)
)
```

### Multi-Factor Authentication
- [ ] MFA supported for sensitive operations
- [ ] TOTP secrets stored securely
- [ ] Recovery codes handled properly
- [ ] MFA bypass not possible

---

## 2. Authorization

### Access Control
- [ ] Deny by default policy
- [ ] Role checks on every request
- [ ] Resource ownership verified
- [ ] Admin functions protected

```python
# Good - explicit authorization check
@app.route('/api/documents/<doc_id>')
@login_required
def get_document(doc_id):
    doc = Document.query.get_or_404(doc_id)
    if doc.owner_id != current_user.id and not current_user.is_admin:
        abort(403)
    return doc.to_dict()

# Bad - no authorization check
@app.route('/api/documents/<doc_id>')
def get_document(doc_id):
    return Document.query.get_or_404(doc_id).to_dict()
```

### IDOR Prevention
- [ ] Direct object references are authorized
- [ ] UUIDs used instead of sequential IDs where appropriate
- [ ] Access to related objects also checked

---

## 3. Input Validation

### General Validation
- [ ] All input validated server-side
- [ ] Whitelist validation preferred
- [ ] Input length limits enforced
- [ ] Data types validated

```python
# Good - explicit validation
from pydantic import BaseModel, validator, constr

class UserInput(BaseModel):
    username: constr(min_length=3, max_length=50, regex=r'^[a-zA-Z0-9_]+$')
    email: EmailStr
    age: int

    @validator('age')
    def age_must_be_positive(cls, v):
        if v < 0 or v > 150:
            raise ValueError('Invalid age')
        return v
```

### SQL Injection Prevention
- [ ] Parameterized queries used
- [ ] ORM methods used correctly
- [ ] No string concatenation in queries
- [ ] Stored procedures use parameters

```python
# Good
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

# Bad
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")
```

### XSS Prevention
- [ ] Output encoding applied
- [ ] Template auto-escaping enabled
- [ ] Content-Security-Policy header set
- [ ] User input not used in eval/innerHTML

```javascript
// Good - using textContent
element.textContent = userInput;

// Bad - using innerHTML
element.innerHTML = userInput;
```

### Command Injection Prevention
- [ ] Shell commands avoided when possible
- [ ] Parameterized execution used
- [ ] Input validated against whitelist

```python
# Good
import subprocess
subprocess.run(['ping', '-c', '4', validated_host], check=True)

# Bad
import os
os.system(f'ping -c 4 {user_input}')
```

---

## 4. Data Protection

### Encryption at Rest
- [ ] Sensitive data encrypted in database
- [ ] Encryption keys properly managed
- [ ] Key rotation supported

### Encryption in Transit
- [ ] TLS 1.2+ enforced
- [ ] Certificate validation enabled
- [ ] HSTS header configured

### Sensitive Data Handling
- [ ] PII identified and protected
- [ ] Sensitive data not logged
- [ ] Data masked in non-production
- [ ] Secure deletion implemented

```python
# Good - mask sensitive data in logs
logger.info(f"Processing order for user: {user_id[:4]}****")

# Bad - log full sensitive data
logger.info(f"Processing order for user: {user_id}, card: {card_number}")
```

---

## 5. Error Handling

### Error Messages
- [ ] Stack traces not exposed to users
- [ ] Generic error messages for failures
- [ ] Detailed errors only in logs
- [ ] Different error handling for prod/dev

```python
# Good
@app.errorhandler(Exception)
def handle_exception(e):
    logger.exception("Unhandled exception")
    return jsonify({"error": "Internal server error"}), 500

# Bad
@app.errorhandler(Exception)
def handle_exception(e):
    return jsonify({"error": str(e), "trace": traceback.format_exc()}), 500
```

### Exception Handling
- [ ] Exceptions caught appropriately
- [ ] Resources released in finally blocks
- [ ] Fail secure (deny access on error)

---

## 6. Logging & Monitoring

### Security Logging
- [ ] Authentication events logged
- [ ] Authorization failures logged
- [ ] Input validation failures logged
- [ ] Admin actions logged

```python
# Security event logging
security_logger.info({
    'event': 'authentication_failure',
    'username': username,
    'ip': request.remote_addr,
    'timestamp': datetime.utcnow().isoformat(),
    'user_agent': request.headers.get('User-Agent')
})
```

### Log Protection
- [ ] Sensitive data not logged
- [ ] Logs protected from tampering
- [ ] Log injection prevented
- [ ] Logs retained appropriately

---

## 7. API Security

### Rate Limiting
- [ ] Rate limiting implemented
- [ ] Different limits for different endpoints
- [ ] Failed attempts tracked
- [ ] Lockout mechanism present

```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=get_remote_address)

@app.route('/api/login', methods=['POST'])
@limiter.limit("5 per minute")
def login():
    # ...
```

### CORS Configuration
- [ ] CORS origins are specific (not *)
- [ ] Allowed methods restricted
- [ ] Credentials handling correct

```python
# Good
CORS(app, origins=['https://trusted-domain.com'], supports_credentials=True)

# Bad
CORS(app, origins='*')
```

### Request Validation
- [ ] Content-Type validated
- [ ] Request size limits enforced
- [ ] File upload restrictions

---

## 8. Dependencies

### Dependency Management
- [ ] Dependencies pinned to versions
- [ ] No known vulnerabilities
- [ ] Automated vulnerability scanning
- [ ] Regular updates scheduled

```bash
# Check for vulnerabilities
pip-audit
npm audit
```

---

## 9. Configuration

### Secrets Management
- [ ] No hardcoded secrets
- [ ] Secrets in environment variables or vault
- [ ] Different secrets per environment
- [ ] Secret rotation supported

```python
# Good
import os
db_password = os.environ['DB_PASSWORD']

# Bad
db_password = 'super_secret_123'
```

### Security Headers
- [ ] X-Frame-Options set
- [ ] X-Content-Type-Options set
- [ ] Content-Security-Policy set
- [ ] Strict-Transport-Security set

---

## 10. Quick Reference

### Red Flags to Look For
```
🔴 String concatenation in SQL queries
🔴 eval() or exec() with user input
🔴 Hardcoded credentials
🔴 MD5/SHA1 for password hashing
🔴 Missing authorization checks
🔴 Sensitive data in logs
🔴 Disabled certificate validation
🔴 CORS with * origin
🔴 Missing input validation
🔴 Stack traces in responses
```

### Questions to Ask
```
1. What happens if this input is malicious?
2. Who is authorized to access this?
3. What data is being exposed?
4. Where are secrets stored?
5. What is logged and who can see it?
6. What happens when this fails?
```

---

## Review Output Template

```markdown
## Code Review: {file/feature}

### Summary
{Overall assessment}

### Findings

| # | Issue | Severity | Line | Fix |
|---|-------|----------|------|-----|
| 1 | {issue} | {H/M/L} | {line} | {fix} |

### Details

#### Finding 1: {title}
- **Location**: {file:line}
- **Issue**: {description}
- **Risk**: {what could happen}
- **Fix**: {how to fix}
- **Example**:
```code
// Before (vulnerable)
...
// After (fixed)
...
```

### Recommendations
1. {recommendation}
2. {recommendation}
```
