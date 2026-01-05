# Component Patterns

Patterns để identify và extract components từ codebase.

---

## Common Component Types

### 1. Services

**Purpose**: Business logic encapsulation

**Naming Patterns**:
- `*Service`, `*Svc`
- `*Manager`
- `*Handler` (sometimes)

**Detection Commands**:
```bash
# Go
grep -r "type.*Service struct\|type.*Svc struct" --include="*.go"

# Python
grep -r "class.*Service\|class.*Manager" --include="*.py"

# TypeScript
grep -r "class.*Service\|export.*Service" --include="*.ts"
```

### 2. Handlers/Controllers

**Purpose**: HTTP request handling

**Naming Patterns**:
- `*Handler`, `*Controller`
- `*Endpoint`
- `*API`

**Detection Commands**:
```bash
# Go
grep -r "type.*Handler struct\|func.*Handler" --include="*.go"

# Express
grep -r "router\.\|app\.\(get\|post\|put\|delete\)" --include="*.js" --include="*.ts"

# Python FastAPI
grep -r "@app\.\|@router\." --include="*.py"
```

### 3. Models/Entities

**Purpose**: Domain objects

**Naming Patterns**:
- `*Model`, `*Entity`
- Plain domain names: `User`, `Order`, `Product`

**Detection Commands**:
```bash
# Go GORM
grep -r "gorm.Model\|TableName()" --include="*.go"

# Python SQLAlchemy
grep -r "class.*Model\|Column(" --include="*.py"

# TypeORM
grep -r "@Entity\|@Column" --include="*.ts"
```

### 4. Repositories

**Purpose**: Data access layer

**Naming Patterns**:
- `*Repository`, `*Repo`
- `*DAO`
- `*Store`

**Detection Commands**:
```bash
# Go
grep -r "type.*Repository\|type.*Repo\|type.*Store" --include="*.go"

# Python
grep -r "class.*Repository\|class.*Repo" --include="*.py"

# TypeScript
grep -r "Repository\|@Repository" --include="*.ts"
```

### 5. Middleware

**Purpose**: Request/response interceptors

**Naming Patterns**:
- `*Middleware`, `*MW`
- `*Interceptor`
- `*Filter`

**Detection Commands**:
```bash
# Go
grep -r "func.*Middleware\|type.*Middleware" --include="*.go"

# Express
grep -r "app.use(\|router.use(" --include="*.js" --include="*.ts"

# Python
grep -r "@middleware\|Middleware" --include="*.py"
```

---

## Architecture Patterns

### Clean Architecture (Go)

```
project/
├── cmd/
│   └── main.go              # Entry point
├── internal/
│   ├── domain/              # Entities
│   ├── usecase/             # Business logic
│   ├── repository/          # Data access
│   └── delivery/            # Handlers
├── pkg/                     # Shared utilities
└── configs/                 # Configuration
```

### MVC (Node.js)

```
project/
├── src/
│   ├── models/              # Data models
│   ├── views/               # Templates
│   ├── controllers/         # Request handlers
│   ├── routes/              # Route definitions
│   └── middleware/          # Middleware
└── public/                  # Static files
```

### Django Pattern

```
project/
├── app/
│   ├── models.py            # Database models
│   ├── views.py             # View functions
│   ├── urls.py              # URL routing
│   ├── serializers.py       # API serialization
│   └── admin.py             # Admin config
└── project/
    └── settings.py          # Configuration
```

---

## Relationship Detection

### Import Analysis

```bash
# Find all imports from a file
grep -E "^import|^from" {file}

# Find who imports a module
grep -r "import.*{module}" --include="*.go" --include="*.py" --include="*.ts"
```

### Dependency Injection

```bash
# Go constructor pattern
grep -r "func New.*(" --include="*.go" | grep -v "_test.go"

# Python __init__
grep -r "def __init__\(self," --include="*.py"

# TypeScript constructor
grep -r "constructor(" --include="*.ts"
```

### Interface Implementation

```bash
# Go
grep -r "var _ {Interface} = " --include="*.go"

# TypeScript
grep -r "implements {Interface}" --include="*.ts"
```

---

## Entry Point Detection

### Main Files

```bash
# Go
find . -name "main.go"

# Python
find . -name "main.py" -o -name "app.py" -o -name "manage.py"

# Node.js - check package.json
cat package.json | jq '.main, .scripts.start'
```

### Router/Route Files

```bash
# Express routes
find . -path "*/routes/*" -name "*.js" -o -path "*/routes/*" -name "*.ts"

# Go routers
grep -r "SetupRoutes\|RegisterRoutes\|Routes()" --include="*.go"

# FastAPI routers
grep -r "@router\|include_router" --include="*.py"
```

---

## Output Format

```yaml
components:
  services:
    - name: UserService
      path: internal/service/user.go
      methods:
        - Create
        - GetByID
        - Update
        - Delete

  handlers:
    - name: UserHandler
      path: internal/handler/user.go
      endpoints:
        - POST /users
        - GET /users/:id

  models:
    - name: User
      path: internal/model/user.go
      fields:
        - ID: uuid
        - Name: string
        - Email: string

  repositories:
    - name: UserRepository
      path: internal/repository/user.go
      operations:
        - Save
        - FindByID
        - Update
        - Delete
```
