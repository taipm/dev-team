# Docker Patterns for Python

Knowledge cho DevOps Agent về Docker best practices.

## Multi-Stage Build

```dockerfile
# ═══════════════════════════════════════════════════════════════
# Stage 1: Builder
# ═══════════════════════════════════════════════════════════════
FROM python:3.12-slim as builder

WORKDIR /app

# Install Poetry
ENV POETRY_HOME="/opt/poetry" \
    POETRY_VERSION="1.7.1" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

RUN pip install --no-cache-dir poetry==${POETRY_VERSION}

# Copy dependency files only (for caching)
COPY pyproject.toml poetry.lock ./

# Export to requirements.txt
RUN poetry export -f requirements.txt --output requirements.txt \
    --without-hashes --without dev

# ═══════════════════════════════════════════════════════════════
# Stage 2: Production
# ═══════════════════════════════════════════════════════════════
FROM python:3.12-slim as production

WORKDIR /app

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Install dependencies
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/

# Set ownership and switch to non-root
RUN chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run application
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Development Dockerfile

```dockerfile
# Dockerfile.dev
FROM python:3.12-slim

WORKDIR /app

# Install Poetry
ENV POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

RUN pip install poetry==1.7.1

# Install dependencies (including dev)
COPY pyproject.toml poetry.lock ./
RUN poetry install --with dev

# Copy application
COPY . .

# Development server with hot reload
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

## Docker Compose

```yaml
# docker-compose.yml
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/app
      - REDIS_URL=redis://redis:6379/0
      - SECRET_KEY=${SECRET_KEY}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d app"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Worker for background tasks
  worker:
    build:
      context: .
      dockerfile: Dockerfile
    command: ["celery", "-A", "src.worker", "worker", "--loglevel=info"]
    environment:
      - DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/app
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

volumes:
  postgres_data:
  redis_data:
```

## Docker Compose for Development

```yaml
# docker-compose.dev.yml
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Exclude venv
    environment:
      - DEBUG=true
      - DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/app_dev
    depends_on:
      - db
    command: ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--reload"]

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: app_dev
    ports:
      - "5432:5432"
    volumes:
      - ./docker/init.sql:/docker-entrypoint-initdb.d/init.sql

  # pgAdmin for database management
  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - db
```

## .dockerignore

```
# Git
.git
.gitignore

# Python
__pycache__
*.py[cod]
*.egg-info
.eggs
*.egg
.venv
venv
.pytest_cache
.mypy_cache
.coverage
htmlcov

# IDE
.idea
.vscode
*.swp

# Docker
Dockerfile*
docker-compose*
.dockerignore

# Docs
docs
*.md
!README.md

# Tests (for production)
tests
conftest.py

# Local config
.env
.env.local
*.local.json
```

## Security Best Practices

### 1. Non-Root User
```dockerfile
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser
```

### 2. No Secrets in Image
```dockerfile
# BAD
ENV API_KEY=secret123

# GOOD: Use runtime env
# Pass via docker-compose or docker run -e
```

### 3. Minimal Base Image
```dockerfile
# Prefer slim variants
FROM python:3.12-slim  # ~150MB

# Or distroless for production
FROM gcr.io/distroless/python3-debian12
```

### 4. Pin Versions
```dockerfile
FROM python:3.12.1-slim
RUN pip install poetry==1.7.1
```

### 5. Scan for Vulnerabilities
```bash
# Trivy
trivy image myapp:latest

# Docker Scout
docker scout cves myapp:latest
```

## Layer Caching

```dockerfile
# Copy dependency files first (rarely change)
COPY pyproject.toml poetry.lock ./
RUN poetry install

# Copy source code last (frequently change)
COPY src/ ./src/
```

## Health Checks

```dockerfile
# HTTP health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Or with Python
HEALTHCHECK --interval=30s --timeout=10s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"
```

## Build Commands

```bash
# Build image
docker build -t myapp:latest .

# Build with specific target
docker build --target production -t myapp:prod .

# Build with build args
docker build --build-arg VERSION=1.0.0 -t myapp:1.0.0 .

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```
