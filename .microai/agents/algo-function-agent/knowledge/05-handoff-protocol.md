# Handoff Protocol

> Format và quy trình chuyển giao từ algo-function-agent sang coding agents

---

## 1. Handoff Package Structure

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║  HANDOFF PACKAGE                                                               ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                                ║
║  1. METADATA                                                                   ║
║     - Project name                                                             ║
║     - Target language/framework                                                ║
║     - Complexity assessment                                                    ║
║     - Estimated implementation effort                                          ║
║                                                                                ║
║  2. FUNCTION SPECIFICATIONS (ordered by dependency)                            ║
║     - Signature                                                                ║
║     - Contract (pre/post/invariants)                                           ║
║     - Complexity annotations                                                   ║
║     - Implementation hints                                                     ║
║                                                                                ║
║  3. DEPENDENCY GRAPH                                                           ║
║     - Visual representation                                                    ║
║     - Implementation order recommendation                                      ║
║                                                                                ║
║  4. FRAMEWORK MAPPINGS                                                         ║
║     - Suggested libraries                                                      ║
║     - Known implementations                                                    ║
║     - Custom implementation notes                                              ║
║                                                                                ║
║  5. OPEN QUESTIONS                                                             ║
║     - Decisions for implementer                                                ║
║     - Configuration options                                                    ║
║                                                                                ║
║  6. DESIGN DECISIONS                                                           ║
║     - Rationale for choices made                                               ║
║     - Trade-offs considered                                                    ║
║                                                                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## 2. Handoff Template

```markdown
# Handoff: [Project Name]

**From:** algo-function-agent
**To:** [target-agent] (e.g., go-dev-agent, python-dev-agent)
**Date:** [YYYY-MM-DD]

## Metadata

| Field | Value |
|-------|-------|
| Project | [name] |
| Domain | [auth/data/file/communication] |
| Language | [Go/Python/TypeScript/etc.] |
| Framework | [if applicable] |
| Functions | [count] |
| Complexity | [Low/Medium/High] |

---

## Function Specifications

### 1. [functionName]

**Signature:**
```
functionName(param1: Type1, param2: Type2) → Result<Output, Error>
```

**Contract:**
- **Pre:** [precondition 1]
- **Pre:** [precondition 2]
- **Post(success):** [what's guaranteed]
- **Post(failure):** error ∈ {[Error1], [Error2]}
- **Invariant:** [if any]

**Complexity:**
- Time: O([complexity])
- Space: O([complexity])
- I/O: [database/network calls]

**Implementation Notes:**
- [hint 1]
- [hint 2]

**Suggested Library:** [library name if applicable]

---

### 2. [nextFunctionName]
...

---

## Dependency Graph

```
[mainFunction]
    │
    ├──► [dependency1] ──► [external]
    │
    ├──► [dependency2]
    │
    └──► [dependency3] ──► [dependency4]
```

**Implementation Order:**
1. [leaf functions first]
2. [intermediate functions]
3. [main orchestrator last]

---

## Framework Mappings

| Abstract Function | Library/Implementation |
|-------------------|----------------------|
| hashPassword | golang.org/x/crypto/bcrypt |
| generateToken | crypto/rand |
| validateEmail | net/mail or regex |

---

## Open Questions

- [ ] [Question 1 for implementer]
- [ ] [Question 2 for implementer]

---

## Design Decisions

1. **[Decision 1]**
   - Rationale: [why]
   - Trade-off: [what was sacrificed]

2. **[Decision 2]**
   - Rationale: [why]
```

---

## 3. Language-Specific Mappings

### Go Mappings

| Abstract Pattern | Go Implementation |
|-----------------|-------------------|
| `Result<T, E>` | `(T, error)` |
| `Optional<T>` | `*T` or `T, bool` |
| `List<T>` | `[]T` |
| `Map<K, V>` | `map[K]V` |
| `async operation` | `go func()` + channel |
| `try-catch` | `if err != nil` |

**Common Libraries:**
```
Password hashing: golang.org/x/crypto/bcrypt
JWT:              github.com/golang-jwt/jwt/v5
UUID:             github.com/google/uuid
HTTP Router:      github.com/go-chi/chi or gin-gonic/gin
Database:         database/sql + github.com/lib/pq
ORM:              gorm.io/gorm
Validation:       github.com/go-playground/validator
Config:           github.com/spf13/viper
Logging:          go.uber.org/zap
```

### Python Mappings

| Abstract Pattern | Python Implementation |
|-----------------|----------------------|
| `Result<T, E>` | `return value` or `raise Exception` |
| `Optional<T>` | `Optional[T]` or `T | None` |
| `List<T>` | `list[T]` |
| `Map<K, V>` | `dict[K, V]` |
| `async operation` | `async def` + `await` |
| `try-catch` | `try/except` |

**Common Libraries:**
```
Password hashing: bcrypt or passlib
JWT:              PyJWT
UUID:             uuid (stdlib)
HTTP Framework:   FastAPI or Flask
Database:         SQLAlchemy
Validation:       pydantic
Config:           python-dotenv
Logging:          logging (stdlib) + structlog
```

### TypeScript/Node Mappings

| Abstract Pattern | TypeScript Implementation |
|-----------------|---------------------------|
| `Result<T, E>` | `Promise<T>` with throw or Result type |
| `Optional<T>` | `T | null` or `T | undefined` |
| `List<T>` | `T[]` |
| `Map<K, V>` | `Map<K, V>` or `Record<K, V>` |
| `async operation` | `async/await` |
| `try-catch` | `try/catch` |

**Common Libraries:**
```
Password hashing: bcrypt
JWT:              jsonwebtoken
UUID:             uuid
HTTP Framework:   Express, Fastify, or NestJS
Database:         Prisma, TypeORM, or Drizzle
Validation:       zod or joi
Config:           dotenv
Logging:          winston or pino
```

---

## 4. Handoff Checklist

```
□ COMPLETENESS
  □ All functions have signatures?
  □ All functions have contracts?
  □ Dependency graph complete?
  □ Implementation order specified?

□ CLARITY
  □ No ambiguous terms?
  □ Error types enumerated?
  □ Edge cases noted?

□ ACTIONABILITY
  □ Libraries suggested?
  □ Implementation hints provided?
  □ Open questions listed?

□ CONTEXT
  □ Design decisions documented?
  □ Trade-offs explained?
  □ Security concerns noted?
```

---

## 5. Example: Complete Handoff

```markdown
# Handoff: User Authentication System

**From:** algo-function-agent
**To:** go-dev-agent
**Date:** 2024-01-15

## Metadata

| Field | Value |
|-------|-------|
| Project | Auth Service |
| Domain | Authentication |
| Language | Go |
| Framework | Chi router |
| Functions | 6 |
| Complexity | Medium |

---

## Function Specifications

### 1. AuthenticateUser

**Signature:**
```go
AuthenticateUser(ctx context.Context, creds Credentials) (*Session, error)
```

**Contract:**
- **Pre:** creds.Email matches email format
- **Pre:** creds.Password.length >= 8 && <= 128
- **Pre:** rate limit not exceeded for this email
- **Post(success):** session.UserID == user.ID && session.Expiry > time.Now()
- **Post(failure):** error ∈ {ErrInvalidCredentials, ErrRateLimited, ErrAccountLocked}
- **Invariant:** password never logged

**Complexity:**
- Time: O(1) with indexed email
- Space: O(1)
- I/O: 1 DB read + 1 DB write

**Implementation Notes:**
- Use bcrypt.CompareHashAndPassword for timing-safe comparison
- Single error type for invalid email/password (security)
- Rate limit check should be first

**Suggested Library:** golang.org/x/crypto/bcrypt

---

### 2. FindUserByEmail

**Signature:**
```go
FindUserByEmail(ctx context.Context, email string) (*User, error)
```

**Contract:**
- **Pre:** email is valid format
- **Post(found):** user.Email == email
- **Post(not found):** returns nil, nil (NOT error)
- **Post(error):** returns nil, error (DB error only)

**Complexity:**
- Time: O(1) with index on email
- I/O: 1 DB read

**Implementation Notes:**
- Index on email column required
- Return nil, nil for not found (not error)
- Only return error for actual DB failures

---

### 3. VerifyPassword

**Signature:**
```go
VerifyPassword(plaintext, hash string) bool
```

**Contract:**
- **Pre:** both non-empty strings
- **Post:** true if plaintext hashes to hash
- **Invariant:** constant-time comparison

**Implementation Notes:**
- MUST use bcrypt.CompareHashAndPassword
- Do NOT implement manually

**Suggested Library:** golang.org/x/crypto/bcrypt

---

### 4. CreateSession

**Signature:**
```go
CreateSession(ctx context.Context, user *User) (*Session, error)
```

**Contract:**
- **Pre:** user is valid, non-nil
- **Post(success):** session.Token is 32 bytes of crypto random
- **Post(success):** session.Expiry = time.Now().Add(24 * time.Hour)
- **Post(success):** session persisted to DB

**Complexity:**
- I/O: 1 DB write

**Implementation Notes:**
- Use crypto/rand for token generation
- Consider Redis for session storage at scale

---

### 5. LogAuthAttempt

**Signature:**
```go
LogAuthAttempt(ctx context.Context, email string, success bool, ip string)
```

**Contract:**
- **Post:** audit record created
- **Invariant:** fire-and-forget OK (async)

**Implementation Notes:**
- Can be async (goroutine)
- Include timestamp, email, success, IP
- Consider structured logging (JSON)

---

### 6. IsRateLimited

**Signature:**
```go
IsRateLimited(ctx context.Context, email, ip string) bool
```

**Contract:**
- **Post:** true if limits exceeded
- **Invariant:** must be fast (< 5ms)

**Implementation Notes:**
- Sliding window algorithm
- Redis recommended for distributed systems
- In-memory OK for single instance

**Suggested Library:** github.com/go-redis/redis_rate/v10

---

## Dependency Graph

```
AuthenticateUser
    │
    ├──► FindUserByEmail ──► [PostgreSQL]
    │
    ├──► VerifyPassword ──► [bcrypt]
    │
    ├──► CreateSession ──► [PostgreSQL/Redis]
    │
    ├──► LogAuthAttempt ──► [Audit Log]
    │
    └──► IsRateLimited ──► [Redis/Memory]
```

**Implementation Order:**
1. VerifyPassword (leaf, no deps)
2. FindUserByEmail (leaf, DB only)
3. CreateSession (leaf, DB only)
4. LogAuthAttempt (leaf, async)
5. IsRateLimited (leaf, cache)
6. AuthenticateUser (orchestrator)

---

## Framework Mappings

| Abstract Function | Go Implementation |
|-------------------|-------------------|
| hashPassword | golang.org/x/crypto/bcrypt |
| generateToken | crypto/rand |
| validateEmail | net/mail.ParseAddress |
| rateLimiter | go-redis/redis_rate/v10 |

---

## Open Questions

- [ ] Session storage: PostgreSQL or Redis?
- [ ] Rate limit thresholds: 5/min or 10/min?
- [ ] Session duration: 24h or configurable via env?
- [ ] Audit log: structured JSON or plain text?

---

## Design Decisions

1. **Single error for invalid credentials**
   - Rationale: Prevent user enumeration attacks
   - Trade-off: Less specific error messages for debugging

2. **Rate limit by email AND IP**
   - Rationale: Prevent both targeted and distributed attacks
   - Trade-off: Slightly more complex implementation

3. **Async audit logging**
   - Rationale: Don't block auth on logging
   - Trade-off: Possible log loss on crash (acceptable)

4. **bcrypt for password hashing**
   - Rationale: Industry standard, built-in cost factor
   - Alternative considered: Argon2 (newer but less tooling)
```

---

## 6. Feedback Loop

Sau khi coding agent implement, có thể feedback lại:

```
┌─────────────────────────────────────────────────────────────────────┐
│                       FEEDBACK TO ALGO-AGENT                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  IMPLEMENTATION ISSUES                                               │
│  - [Function]: [Issue encountered]                                   │
│  - [Function]: [Spec was unclear about X]                           │
│                                                                      │
│  SPEC GAPS                                                           │
│  - Missing error type: [NewErrorType]                               │
│  - Missing edge case: [Description]                                  │
│                                                                      │
│  SUGGESTIONS                                                         │
│  - [Function] should also handle [case]                             │
│  - Contract missing [condition]                                      │
│                                                                      │
│  QUESTIONS                                                           │
│  - [Question about design decision]                                  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

Feedback này giúp algo-function-agent cải thiện cho lần sau.
