# Code Testability Review - Knowledge Base

## Testability Checklist

### Architecture Level
- [ ] Clear separation of concerns
- [ ] Dependency injection used
- [ ] Interfaces for external dependencies
- [ ] No hidden dependencies (globals, singletons)
- [ ] Modular design, small components

### Function/Method Level
- [ ] Pure functions where possible
- [ ] Single responsibility
- [ ] Explicit inputs and outputs
- [ ] No side effects in business logic
- [ ] Reasonable cyclomatic complexity (<10)

### Error Handling
- [ ] Explicit error types
- [ ] Errors propagated, not swallowed
- [ ] Meaningful error messages
- [ ] Error states are testable
- [ ] Retry logic is configurable

### External Dependencies
- [ ] Database calls abstracted
- [ ] HTTP clients injectable
- [ ] File system operations isolated
- [ ] Time/random sources injectable
- [ ] Configuration externalized

---

## Dependency Injection Patterns

### Constructor Injection (Preferred)

```go
// Good - Easy to test with mock
type UserService struct {
    repo UserRepository
    cache Cache
}

func NewUserService(repo UserRepository, cache Cache) *UserService {
    return &UserService{repo: repo, cache: cache}
}

// Test
func TestUserService(t *testing.T) {
    mockRepo := &MockUserRepository{}
    mockCache := &MockCache{}
    service := NewUserService(mockRepo, mockCache)
    // test service...
}
```

### Bad - Hard to test

```go
// Bad - Global dependencies
type UserService struct{}

func (s *UserService) GetUser(id string) (*User, error) {
    return globalDB.FindUser(id) // Can't mock!
}
```

---

## Interface Design for Testability

### Define Interfaces at Consumer

```go
// Define interface where it's used, not where it's implemented
// This allows easy mocking

// In user_service.go
type UserRepository interface {
    FindByID(id string) (*User, error)
    Save(user *User) error
}

type UserService struct {
    repo UserRepository // Interface, not concrete type
}

// In user_service_test.go
type mockUserRepo struct {
    users map[string]*User
    err   error
}

func (m *mockUserRepo) FindByID(id string) (*User, error) {
    if m.err != nil {
        return nil, m.err
    }
    return m.users[id], nil
}
```

---

## Error Handling Review

### Good Error Handling

```go
// Good - Explicit, testable errors
var (
    ErrUserNotFound = errors.New("user not found")
    ErrInvalidEmail = errors.New("invalid email format")
)

func (s *UserService) GetUser(id string) (*User, error) {
    user, err := s.repo.FindByID(id)
    if err != nil {
        return nil, fmt.Errorf("get user %s: %w", id, err)
    }
    if user == nil {
        return nil, ErrUserNotFound
    }
    return user, nil
}

// Test can check specific errors
func TestGetUser_NotFound(t *testing.T) {
    service := setupTestService()
    _, err := service.GetUser("nonexistent")
    assert.ErrorIs(t, err, ErrUserNotFound)
}
```

### Bad Error Handling

```go
// Bad - Swallowed errors, not testable
func (s *UserService) GetUser(id string) *User {
    user, err := s.repo.FindByID(id)
    if err != nil {
        log.Println(err) // Error swallowed!
        return nil
    }
    return user
}
```

---

## Logging Sufficiency Check

### Log Levels

| Level | Use Case | Example |
|-------|----------|---------|
| ERROR | Unexpected failures | Database connection failed |
| WARN | Recoverable issues | Retry attempt, degraded mode |
| INFO | Key operations | User logged in, order placed |
| DEBUG | Development details | Request payload, query params |

### What to Log

- [ ] Request ID for tracing
- [ ] User/session context
- [ ] Operation being performed
- [ ] Input parameters (sanitized)
- [ ] Duration for slow operations
- [ ] Error details with stack trace

### What NOT to Log

- [ ] Passwords, tokens, secrets
- [ ] PII (personal identifiable info)
- [ ] Credit card numbers
- [ ] Full request bodies (if sensitive)

---

## API Contract Validation

### Request Validation

```go
// Good - Explicit validation, testable
type CreateUserRequest struct {
    Email    string `json:"email" validate:"required,email"`
    Password string `json:"password" validate:"required,min=8"`
    Name     string `json:"name" validate:"required,max=100"`
}

func (r *CreateUserRequest) Validate() error {
    if r.Email == "" {
        return ErrEmailRequired
    }
    if !isValidEmail(r.Email) {
        return ErrInvalidEmailFormat
    }
    // ... more validations
    return nil
}

// Test validation
func TestCreateUserRequest_Validation(t *testing.T) {
    tests := []struct {
        name    string
        req     CreateUserRequest
        wantErr error
    }{
        {"empty email", CreateUserRequest{}, ErrEmailRequired},
        {"invalid email", CreateUserRequest{Email: "bad"}, ErrInvalidEmailFormat},
        {"valid", CreateUserRequest{Email: "test@example.com", ...}, nil},
    }
    // ... run tests
}
```

### Response Contract

```go
// Good - Consistent response structure
type APIResponse struct {
    Success bool        `json:"success"`
    Data    interface{} `json:"data,omitempty"`
    Error   *APIError   `json:"error,omitempty"`
}

type APIError struct {
    Code    string `json:"code"`
    Message string `json:"message"`
}
```

---

## Code Complexity Analysis

### Cyclomatic Complexity

```
Complexity | Rating | Action
-----------|--------|--------
1-5        | Good   | Easy to test
6-10       | OK     | Consider refactoring
11-20      | High   | Refactor recommended
21+        | Bad    | Must refactor
```

### Reducing Complexity

```go
// Bad - High complexity, hard to test all paths
func ProcessOrder(order *Order) error {
    if order.Status == "pending" {
        if order.Total > 1000 {
            if order.Customer.IsPremium {
                // ... deep nesting
            }
        }
    }
    // ...
}

// Good - Early returns, single responsibility
func ProcessOrder(order *Order) error {
    if err := validateOrder(order); err != nil {
        return err
    }
    if err := applyDiscounts(order); err != nil {
        return err
    }
    return finalizeOrder(order)
}

func validateOrder(order *Order) error {
    if order.Status != "pending" {
        return ErrOrderNotPending
    }
    // ... single validation concern
}
```

---

## Test Coverage Guidelines

### Coverage Targets

| Type | Target | Notes |
|------|--------|-------|
| Unit tests | 80%+ | Focus on business logic |
| Integration | 60%+ | Critical paths |
| E2E | Key flows | 5-10 critical scenarios |

### What to Cover

1. **Happy path** - Normal operation
2. **Error paths** - All error conditions
3. **Edge cases** - Boundaries, nulls, empty
4. **Security** - Auth, authorization
5. **Performance** - Under load (benchmark tests)

### What NOT to Cover

- Generated code
- Simple getters/setters
- Framework code
- Third-party libraries

---

## Testability Red Flags

### Hard to Mock

```go
// Red flag: Direct instantiation
func ProcessPayment(order *Order) {
    client := stripe.NewClient() // Can't mock!
    client.Charge(order.Total)
}

// Fix: Inject dependency
func ProcessPayment(order *Order, paymentClient PaymentClient) {
    paymentClient.Charge(order.Total)
}
```

### Time Dependencies

```go
// Red flag: Direct time usage
func IsExpired(token *Token) bool {
    return time.Now().After(token.ExpiresAt) // Can't control time!
}

// Fix: Inject time source
func IsExpired(token *Token, now time.Time) bool {
    return now.After(token.ExpiresAt)
}
```

### Random Dependencies

```go
// Red flag: Direct random
func GenerateCode() string {
    return fmt.Sprintf("%06d", rand.Intn(1000000)) // Non-deterministic!
}

// Fix: Inject random source
func GenerateCode(rng *rand.Rand) string {
    return fmt.Sprintf("%06d", rng.Intn(1000000))
}
```

---

## Review Questions for QA

1. **Can I mock all external dependencies?**
2. **Can I test error conditions?**
3. **Are there hidden side effects?**
4. **Can I verify the output deterministically?**
5. **Is the complexity manageable?**
6. **Are there clear boundaries between components?**
7. **Is logging sufficient for debugging?**
8. **Are validation rules explicit and testable?**
