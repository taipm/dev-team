# Step 07: DevOps Configuration

## Trigger
Sau Step 06 approved

## Agent
🚀 DevOps Agent

## Actions

### 1. Create Dockerfile

```dockerfile
# Dockerfile
# Multi-stage build for Python application

# Build stage
FROM python:3.12-slim as builder

WORKDIR /app

# Install Poetry
ENV POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false
RUN pip install poetry==1.7.1

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Export requirements
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes --without dev

# Production stage
FROM python:3.12-slim as production

WORKDIR /app

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Install dependencies
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY src/ ./src/

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run application
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### 2. Create docker-compose.yml

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://postgres:postgres@db:5432/app
      - SECRET_KEY=${SECRET_KEY:-development-secret-key}
      - DEBUG=false
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  postgres_data:
```

### 3. Create GitHub Actions CI

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  PYTHON_VERSION: "3.12"

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: 1.7.1

      - name: Cache Poetry dependencies
        uses: actions/cache@v4
        with:
          path: ~/.cache/pypoetry
          key: poetry-${{ hashFiles('poetry.lock') }}

      - name: Install dependencies
        run: poetry install --no-interaction

      - name: Run ruff
        run: |
          poetry run ruff check src/ tests/
          poetry run ruff format --check src/ tests/

      - name: Run mypy
        run: poetry run mypy src/ --strict

  test:
    runs-on: ubuntu-latest
    needs: lint

    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: 1.7.1

      - name: Install dependencies
        run: poetry install --no-interaction

      - name: Run tests
        env:
          DATABASE_URL: postgresql+asyncpg://test:test@localhost:5432/test
        run: poetry run pytest --cov=src --cov-report=xml --cov-report=term-missing

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage.xml
          fail_ci_if_error: false

  build:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          tags: app:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### 4. Create Makefile

```makefile
# Makefile
.PHONY: help install dev test lint format type-check all-checks docker-build docker-run clean

help:
	@echo "Available commands:"
	@echo "  install      Install dependencies"
	@echo "  dev          Run development server"
	@echo "  test         Run tests with coverage"
	@echo "  lint         Run linter"
	@echo "  format       Format code"
	@echo "  type-check   Run type checker"
	@echo "  all-checks   Run all quality checks"
	@echo "  docker-build Build Docker image"
	@echo "  docker-run   Run with Docker Compose"
	@echo "  clean        Clean cache files"

install:
	poetry install

dev:
	poetry run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

test:
	poetry run pytest --cov=src --cov-report=term-missing --cov-report=html

lint:
	poetry run ruff check src/ tests/

format:
	poetry run ruff format src/ tests/
	poetry run ruff check --fix src/ tests/

type-check:
	poetry run mypy src/ --strict

all-checks: lint type-check test

docker-build:
	docker build -t app:latest .

docker-run:
	docker-compose up -d

docker-logs:
	docker-compose logs -f

docker-down:
	docker-compose down

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage
```

### 5. Create Pre-commit Config

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.14
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        args: [--strict]
        additional_dependencies:
          - pydantic
          - fastapi
          - sqlalchemy

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: detect-private-key
      - id: check-merge-conflict
```

### 6. Create .env.example

```bash
# .env.example
# Database
DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5432/app

# Security
SECRET_KEY=your-super-secret-key-change-in-production

# App
DEBUG=true
API_PREFIX=/api/v1
```

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🚀 DevOps Agent: Configuration Complete                    │
├─────────────────────────────────────────────────────────────┤
│ Files created:                                               │
│ ├── Dockerfile                                              │
│ ├── docker-compose.yml                                      │
│ ├── .github/workflows/ci.yml                                │
│ ├── Makefile                                                │
│ ├── .pre-commit-config.yaml                                 │
│ └── .env.example                                            │
│                                                              │
│ Quick start:                                                 │
│ • make install     - Install dependencies                   │
│ • make dev         - Run development server                 │
│ • make all-checks  - Run all quality checks                 │
│ • make docker-run  - Run with Docker                        │
└─────────────────────────────────────────────────────────────┘
```

## Next Step
→ Step 08: Synthesis
