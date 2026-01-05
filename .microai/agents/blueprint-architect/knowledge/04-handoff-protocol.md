# Handoff Protocol

> How to package blueprints for coding agents

---

## Handoff Package Structure

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║  HANDOFF PACKAGE                                                               ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                                ║
║  1. METADATA                                                                   ║
║     - Project name                                                             ║
║     - Target language/framework                                                ║
║     - Complexity assessment                                                    ║
║     - Functions count                                                          ║
║                                                                                ║
║  2. FUNCTION SPECIFICATIONS (ordered by implementation)                        ║
║     - Signature with types                                                     ║
║     - Contract (pre/post/invariants)                                           ║
║     - Complexity annotations                                                   ║
║     - Implementation hints                                                     ║
║                                                                                ║
║  3. DEPENDENCY GRAPH                                                           ║
║     - Visual representation                                                    ║
║     - Implementation order                                                     ║
║                                                                                ║
║  4. FRAMEWORK MAPPINGS                                                         ║
║     - Suggested libraries                                                      ║
║     - Abstract → Concrete mappings                                             ║
║                                                                                ║
║  5. OPEN QUESTIONS                                                             ║
║     - Decisions for implementer                                                ║
║     - Configuration options                                                    ║
║                                                                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## Language-Specific Mappings

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
| `Optional<T>` | `Optional[T]` or `T \| None` |
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

### TypeScript Mappings

| Abstract Pattern | TypeScript Implementation |
|-----------------|---------------------------|
| `Result<T, E>` | `Promise<T>` with throw or Result type |
| `Optional<T>` | `T \| null` or `T \| undefined` |
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

## Implementation Order

Always implement in dependency order (leaves first):

```
DEPENDENCY GRAPH:
     orchestrator
          │
    ┌─────┼─────┐
    ▼     ▼     ▼
  funcA funcB funcC
          │
          ▼
        funcD (leaf)

IMPLEMENTATION ORDER:
1. funcD (no dependencies - leaf)
2. funcA (no dependencies - leaf)
3. funcB (depends on funcD)
4. funcC (no dependencies - leaf)
5. orchestrator (depends on A, B, C)
```

---

## Handoff Template

```markdown
# Handoff: {Project Name}

**From:** Blueprint Architect
**To:** {target-agent} (e.g., go-dev-agent)
**Date:** {YYYY-MM-DD}

## Metadata

| Field | Value |
|-------|-------|
| Project | {name} |
| Language | {Go/Python/TypeScript} |
| Functions | {count} |
| Complexity | {Low/Medium/High} |

---

## Function Specifications

### 1. {functionName}

**Signature:**
```
{signature with types}
```

**Contract:**
- Pre: {precondition}
- Post(success): {guarantee}
- Post(failure): error ∈ {ErrorTypes}

**Implementation Notes:**
- {hint}

**Suggested Library:** {library if applicable}

---

## Dependency Graph

```
{ASCII diagram}
```

**Implementation Order:**
1. {first function}
2. {second function}
...

---

## Framework Mappings

| Abstract | Concrete Implementation |
|----------|------------------------|
| {pattern} | {library/approach} |

---

## Open Questions

- [ ] {Question for implementer}
- [ ] {Configuration decision}
```

---

## Feedback Format

When coding agent needs clarification:

```yaml
feedback:
  from: go-dev-agent
  to: blueprint-architect
  type: spec_clarification | spec_amendment | deviation
  function: "functionName"
  issue: "Description of issue"
  proposal: "Suggested resolution"
  severity: minor | major | breaking
```

**Severity Handling:**
- `minor`: Document in notes, continue
- `major`: Update spec, notify
- `breaking`: Require redesign session

---

## Handoff Checklist

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
```
