# Tech Stack Detection

Patterns để detect tech stack từ codebase.

---

## Config File Detection

### JavaScript/Node.js

| File | Framework |
|------|-----------|
| `package.json` | Node.js |
| + `react` | React |
| + `vue` | Vue.js |
| + `express` | Express.js |
| + `next` | Next.js |
| + `nestjs` | NestJS |

### Go

| File | Framework |
|------|-----------|
| `go.mod` | Go |
| + `gin-gonic/gin` | Gin |
| + `labstack/echo` | Echo |
| + `gofiber/fiber` | Fiber |
| + `gorilla/mux` | Gorilla |

### Python

| File | Framework |
|------|-----------|
| `requirements.txt` | Python |
| `pyproject.toml` | Python |
| + `fastapi` | FastAPI |
| + `django` | Django |
| + `flask` | Flask |
| + `sqlalchemy` | SQLAlchemy |

### Rust

| File | Framework |
|------|-----------|
| `Cargo.toml` | Rust |
| + `actix-web` | Actix |
| + `rocket` | Rocket |
| + `axum` | Axum |

### Java

| File | Framework |
|------|-----------|
| `pom.xml` | Maven |
| `build.gradle` | Gradle |
| + `spring-boot` | Spring Boot |
| + `quarkus` | Quarkus |

---

## Detection Commands

### General

```bash
# Find all config files
find . -maxdepth 2 \( -name "package.json" -o -name "go.mod" -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "pom.xml" \) 2>/dev/null
```

### Node.js

```bash
# Check package.json for framework
cat package.json | jq '.dependencies | keys[]' 2>/dev/null
```

### Go

```bash
# Check go.mod for framework
grep -E "gin-gonic|echo|fiber|gorilla" go.mod 2>/dev/null
```

### Python

```bash
# Check requirements
grep -E "fastapi|django|flask|sqlalchemy" requirements.txt pyproject.toml 2>/dev/null
```

---

## Detection Algorithm

```python
def detect_tech_stack(project_path):
    stack = {
        "languages": [],
        "frameworks": [],
        "databases": [],
        "tools": []
    }

    # Check for Node.js
    if exists("package.json"):
        stack["languages"].append("JavaScript/TypeScript")
        deps = read_json("package.json")["dependencies"]
        if "react" in deps:
            stack["frameworks"].append("React")
        if "express" in deps:
            stack["frameworks"].append("Express")

    # Check for Go
    if exists("go.mod"):
        stack["languages"].append("Go")
        content = read("go.mod")
        if "gin-gonic" in content:
            stack["frameworks"].append("Gin")

    # Check for Python
    if exists("requirements.txt") or exists("pyproject.toml"):
        stack["languages"].append("Python")
        content = read("requirements.txt")
        if "fastapi" in content:
            stack["frameworks"].append("FastAPI")

    return stack
```

---

## Database Detection

### From Config

| Pattern | Database |
|---------|----------|
| `postgres://` | PostgreSQL |
| `mysql://` | MySQL |
| `mongodb://` | MongoDB |
| `redis://` | Redis |

### From Dependencies

| Package | Database |
|---------|----------|
| `pg` / `pq` | PostgreSQL |
| `mysql2` / `mysql` | MySQL |
| `mongodb` / `mongoose` | MongoDB |
| `ioredis` / `redis` | Redis |

---

## CI/CD Detection

| File | System |
|------|--------|
| `.github/workflows/` | GitHub Actions |
| `.gitlab-ci.yml` | GitLab CI |
| `Jenkinsfile` | Jenkins |
| `.circleci/` | CircleCI |

---

## Container Detection

| File | Technology |
|------|------------|
| `Dockerfile` | Docker |
| `docker-compose.yml` | Docker Compose |
| `kubernetes/` | Kubernetes |
| `k8s/` | Kubernetes |

---

## Output Format

```yaml
tech_stack:
  languages:
    - name: Go
      version: "1.21"
    - name: TypeScript
      version: "5.0"

  frameworks:
    - name: Gin
      type: web
    - name: React
      type: frontend

  databases:
    - name: PostgreSQL
      type: sql
    - name: Redis
      type: cache

  tools:
    - Docker
    - GitHub Actions

  architecture:
    pattern: microservices
    style: REST API
```
