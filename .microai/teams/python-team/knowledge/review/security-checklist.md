# Security Checklist for Python

Knowledge cho Reviewer Agent về security best practices.

## OWASP Top 10 for Python

### 1. Injection (SQL, Command, LDAP)

```python
# BAD: SQL Injection
query = f"SELECT * FROM users WHERE id = {user_id}"
cursor.execute(query)

# GOOD: Parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

# SQLAlchemy - safe
session.query(User).filter(User.id == user_id).first()

# BAD: Command injection
os.system(f"ping {user_input}")

# GOOD: Use subprocess with list
subprocess.run(["ping", "-c", "1", validated_host], check=True)
```

### 2. Broken Authentication

```python
# Password hashing
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


# JWT best practices
from jose import jwt
from datetime import datetime, timedelta

def create_token(user_id: int) -> str:
    expire = datetime.utcnow() + timedelta(minutes=30)
    payload = {
        "sub": str(user_id),
        "exp": expire,
        "iat": datetime.utcnow(),
        "jti": str(uuid.uuid4()),  # Unique token ID
    }
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")
```

### 3. Sensitive Data Exposure

```python
# BAD: Logging sensitive data
logger.info(f"User login: {email}, password: {password}")

# GOOD: Mask sensitive data
logger.info(f"User login: {email}")


# BAD: Returning password in response
class UserResponse(BaseModel):
    email: str
    password: str  # Never!

# GOOD: Exclude sensitive fields
class UserResponse(BaseModel):
    email: str

    class Config:
        # Exclude from serialization
        exclude = {"password", "api_key"}


# Environment variables
from pydantic_settings import BaseSettings
from pydantic import SecretStr

class Settings(BaseSettings):
    database_url: str
    secret_key: SecretStr  # Won't be printed
    api_key: SecretStr
```

### 4. XML External Entities (XXE)

```python
# BAD: Default XML parser
import xml.etree.ElementTree as ET
tree = ET.parse(untrusted_xml)

# GOOD: Disable external entities
from defusedxml.ElementTree import parse
tree = parse(untrusted_xml)

# Or configure manually
import xml.etree.ElementTree as ET
parser = ET.XMLParser()
parser.entity = {}  # Disable entities
```

### 5. Broken Access Control

```python
# BAD: No authorization check
@router.get("/users/{user_id}")
async def get_user(user_id: int) -> User:
    return await user_repo.get(user_id)

# GOOD: Check authorization
@router.get("/users/{user_id}")
async def get_user(
    user_id: int,
    current_user: CurrentUser,
) -> User:
    if current_user.id != user_id and not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Forbidden")
    return await user_repo.get(user_id)


# IDOR Prevention
async def get_resource(resource_id: int, user: User) -> Resource:
    resource = await resource_repo.get(resource_id)
    if resource.owner_id != user.id:
        raise ForbiddenError()
    return resource
```

### 6. Security Misconfiguration

```python
# FastAPI security headers
from fastapi import FastAPI
from starlette.middleware.trustedhost import TrustedHostMiddleware

app = FastAPI()

# Only allow specific hosts
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["example.com", "*.example.com"],
)

# CORS configuration
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://frontend.example.com"],  # Specific, not "*"
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["Authorization"],
)


# Debug mode in production
# BAD
app = FastAPI(debug=True)  # Never in production!

# GOOD
app = FastAPI(debug=settings.DEBUG)  # From env
```

### 7. Cross-Site Scripting (XSS)

```python
# Template escaping (Jinja2 auto-escapes by default)
# BAD: Disable escaping
{{ user_input | safe }}

# GOOD: Let it escape
{{ user_input }}


# API responses - use proper content type
from fastapi.responses import JSONResponse

@router.get("/data")
async def get_data() -> JSONResponse:
    return JSONResponse(
        content={"data": user_content},
        headers={"Content-Type": "application/json"},
    )
```

### 8. Insecure Deserialization

```python
# BAD: pickle with untrusted data
import pickle
data = pickle.loads(untrusted_bytes)  # Dangerous!

# GOOD: Use JSON
import json
data = json.loads(untrusted_string)

# GOOD: If pickle needed, use signing
import itsdangerous
signer = itsdangerous.Signer(SECRET_KEY)
signed_data = signer.sign(pickle.dumps(data))
# Later
unsigned = signer.unsign(signed_data)
data = pickle.loads(unsigned)
```

### 9. Using Components with Known Vulnerabilities

```bash
# Check for vulnerabilities
pip install safety
safety check

# Or use pip-audit
pip install pip-audit
pip-audit

# Dependabot alerts in GitHub
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
```

### 10. Insufficient Logging & Monitoring

```python
import logging
from datetime import datetime

# Configure structured logging
logging.basicConfig(
    format='{"time": "%(asctime)s", "level": "%(levelname)s", '
           '"module": "%(module)s", "message": "%(message)s"}',
    level=logging.INFO,
)

logger = logging.getLogger(__name__)


# Log security events
async def login(email: str, password: str) -> Token:
    user = await user_repo.get_by_email(email)

    if not user or not verify_password(password, user.password_hash):
        logger.warning(
            f"Failed login attempt for email: {email}",
            extra={"event": "auth_failure", "email": email},
        )
        raise HTTPException(status_code=401)

    logger.info(
        f"Successful login for user: {user.id}",
        extra={"event": "auth_success", "user_id": user.id},
    )
    return create_token(user.id)
```

## Security Review Checklist

### Input Validation
- [ ] All user input is validated
- [ ] Input length limits are enforced
- [ ] Special characters are handled properly
- [ ] File uploads are validated (type, size)

### Authentication
- [ ] Passwords are hashed (bcrypt/argon2)
- [ ] Tokens have expiration
- [ ] Rate limiting on login attempts
- [ ] Session management is secure

### Authorization
- [ ] Access controls are checked
- [ ] IDOR vulnerabilities prevented
- [ ] Role-based access enforced
- [ ] Least privilege principle

### Data Protection
- [ ] Sensitive data is encrypted
- [ ] No secrets in code/logs
- [ ] HTTPS enforced
- [ ] Proper error messages (no info leak)

### Dependencies
- [ ] No known vulnerabilities
- [ ] Dependencies up to date
- [ ] Minimal dependency surface
