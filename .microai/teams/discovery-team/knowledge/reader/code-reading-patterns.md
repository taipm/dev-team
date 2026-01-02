# Code Reading Patterns

> Patterns và strategies cho việc đọc code hiệu quả

## Reading Strategies

### 1. Top-Down Reading
Bắt đầu từ entry point, follow execution path.

```
Entry Point (main.go)
    │
    ├─► Initialization (config, deps)
    │
    ├─► Router/Handler setup
    │
    └─► Service/Business logic
            │
            └─► Data/Repository layer
```

**Use when:** Trả lời "Application làm gì khi startup?"

### 2. Bottom-Up Reading
Bắt đầu từ data layer, trace up.

```
Database/Storage
    │
    └─► Repository layer
            │
            └─► Service layer
                    │
                    └─► Handler/API layer
                            │
                            └─► Response
```

**Use when:** Trả lời "Data được persist như thế nào?"

### 3. Interface-First Reading
Bắt đầu từ interfaces, tìm implementations.

```
interface UserRepository {
    Find(id) User
    Save(user) error
}
    │
    ├─► PostgresUserRepository (implements)
    ├─► MongoUserRepository (implements)
    └─► MockUserRepository (implements)
```

**Use when:** Trả lời "Có những implementations nào?"

### 4. Dependency-Trace Reading
Follow imports và dependencies.

```
package main
    │
    ├─► import "internal/service"
    │       │
    │       └─► import "internal/repository"
    │               │
    │               └─► import "database/sql"
    │
    └─► import "github.com/gin-gonic/gin"
```

**Use when:** Trả lời "Module này depend vào gì?"

## Search Patterns

### Finding Entry Points
```yaml
glob_patterns:
  - "main.*"
  - "index.*"
  - "app.*"
  - "cmd/**/main.*"
  - "src/index.*"

grep_patterns:
  - "func main()"
  - "if __name__"
  - "export default"
```

### Finding Configuration
```yaml
glob_patterns:
  - "*.config.*"
  - "*.yaml"
  - "*.yml"
  - "*.env*"
  - "config/*"
  - "settings.*"

grep_patterns:
  - "os.Getenv"
  - "process.env"
  - "config.load"
```

### Finding Services/Business Logic
```yaml
glob_patterns:
  - "**/service*"
  - "**/usecase*"
  - "**/business*"
  - "internal/service/*"
  - "src/services/*"

grep_patterns:
  - "type.*Service"
  - "class.*Service"
  - "Service"
```

### Finding Data Access
```yaml
glob_patterns:
  - "**/repository*"
  - "**/dao*"
  - "**/store*"
  - "**/model*"

grep_patterns:
  - "type.*Repository"
  - "interface.*Repository"
  - "SELECT"
  - "INSERT"
  - "db.Query"
```

### Finding Tests
```yaml
glob_patterns:
  - "**/*_test.*"
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/test/**"
  - "**/__tests__/**"

grep_patterns:
  - "func Test"
  - "describe("
  - "it("
  - "@Test"
```

## Language-Specific Patterns

### Go
```yaml
structure:
  entry: "cmd/**/main.go"
  packages: "**/go.mod"
  internal: "internal/**"
  public: "pkg/**"

conventions:
  - Test files: "*_test.go"
  - Interface in same package as implementation
  - Constructor: "NewXxx()"
  - Error return: "xxx, error"
```

### TypeScript/JavaScript
```yaml
structure:
  entry: "src/index.ts", "index.js"
  packages: "package.json"
  source: "src/**"
  types: "**/*.d.ts", "types/**"

conventions:
  - Test files: "*.test.ts", "*.spec.ts"
  - Components: "*.tsx", "*.jsx"
  - Barrel exports: "index.ts"
```

### Python
```yaml
structure:
  entry: "__main__.py", "main.py", "app.py"
  packages: "requirements.txt", "pyproject.toml"
  source: "src/**", project_name/**

conventions:
  - Test files: "test_*.py", "*_test.py"
  - Classes: PascalCase
  - Functions: snake_case
```

## Reading Checklist

When reading a new file:

- [ ] Note the package/module name
- [ ] List imports (dependencies)
- [ ] Identify public exports
- [ ] Find main types/classes
- [ ] Trace method signatures
- [ ] Note error handling
- [ ] Check for tests

## Efficient Reading Tips

### 1. Read signatures first
```go
// Don't read implementation yet, just signatures
func (s *UserService) Create(ctx context.Context, user *User) error
func (s *UserService) Get(ctx context.Context, id string) (*User, error)
func (s *UserService) Update(ctx context.Context, user *User) error
func (s *UserService) Delete(ctx context.Context, id string) error
```

### 2. Use Grep before Read
```bash
# Find what files mention "auth"
grep -r "auth" --include="*.go" -l

# Then read only those files
```

### 3. Follow the happy path first
```go
// Read success case first
if result, err := doSomething(); err == nil {
    return result  // <-- read this path first
}
// Then error handling
return nil, err
```

### 4. Note but don't deep-dive
```go
// Note: This uses Redis (redis.Client)
// Don't deep-dive into redis package unless question asks
```

## Common Code Patterns to Recognize

### Constructor/Factory
```go
func NewUserService(repo Repository) *UserService {
    return &UserService{repo: repo}
}
```

### Dependency Injection
```go
type Service struct {
    repo Repository  // injected dependency
}
```

### Interface + Implementation
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type FileReader struct{}
func (f *FileReader) Read(p []byte) (n int, err error) {...}
```

### Middleware/Decorator
```go
func LoggingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Println("Request received")
        next.ServeHTTP(w, r)
    })
}
```

### Repository Pattern
```go
type UserRepository interface {
    Find(id string) (*User, error)
    Save(user *User) error
    Delete(id string) error
}
```
