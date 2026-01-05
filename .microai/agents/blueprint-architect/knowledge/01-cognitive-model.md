# Cognitive Model: 4-Layer Thinking

> Blueprint Architect operates at Level-2 (Function Level)

---

## The Four Layers

```
┌─────────────────────────────────────────────────────────────────────────┐
│  LEVEL 4: INTENT                                                        │
│  ─────────────────                                                      │
│  "Build user authentication with social login"                          │
│  "Make the API handle file uploads"                                     │
│                                                                          │
│  WHO: Human (Product Owner, Developer)                                  │
│  WHAT: Goals, requirements, user stories                                │
│  OUTPUT: Natural language requirements                                  │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LEVEL 3: ARCHITECTURE                                                  │
│  ─────────────────────                                                  │
│  Components: AuthService, TokenManager, UserRepository                  │
│  Patterns: Repository, Factory, Strategy, Observer                      │
│  Decisions: Microservices vs Monolith, REST vs GraphQL                 │
│                                                                          │
│  WHO: Architect Agent, Senior Developer                                 │
│  WHAT: System structure, component relationships                        │
│  OUTPUT: Architecture diagrams, component definitions                   │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LEVEL 2: FUNCTION  ◄═══════════════════════════════ BLUEPRINT ARCHITECT│
│  ────────────────                                                       │
│  login(credentials) → Result<Session, AuthError>                        │
│  validateToken(token) → bool                                            │
│  refreshSession(session) → Session                                      │
│                                                                          │
│  Contracts:                                                              │
│    Pre: credentials.email is valid format                               │
│    Post: session.expiry > now OR error returned                         │
│    Invariant: password never logged                                     │
│                                                                          │
│  WHO: Blueprint Architect                                               │
│  WHAT: Function signatures, contracts, dependencies                     │
│  OUTPUT: Blueprints for coding agents                                   │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LEVEL 1: SYNTAX                                                        │
│  ──────────────                                                         │
│  func login(creds Credentials) (*Session, error) {                      │
│      user, err := repo.FindByEmail(creds.Email)                         │
│      if err != nil { return nil, ErrUserNotFound }                      │
│      if !verifyPassword(creds.Password, user.PasswordHash) {            │
│          return nil, ErrInvalidPassword                                 │
│      }                                                                   │
│      return createSession(user), nil                                    │
│  }                                                                       │
│                                                                          │
│  WHO: Coding Agents (go-dev, python-dev, etc.)                          │
│  WHAT: Actual code implementation                                       │
│  OUTPUT: Production code                                                │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Level-2 Boundaries

### When to Go UP to Level-3?

Ask user to involve Architect agent when:
- Multiple components need coordination
- Pattern selection required (which design pattern?)
- System-wide decisions (database choice, API style)
- Cross-cutting concerns (logging, monitoring)

### When to Go DOWN to Level-1?

Hand off to coding agent when:
- Function specs are complete with contracts
- Dependencies are clear
- Open questions are listed
- Target language is known

### Stay at Level-2 When:

- Defining what functions are needed
- Specifying contracts (pre/post conditions)
- Mapping dependencies between functions
- Identifying abstraction leaks
- Creating handoff packages

---

## The Physics Analogy

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  BLUEPRINT ARCHITECT = Theoretical Physicist                            │
│  ─────────────────────────────────────────                              │
│  - Defines equations (function signatures)                              │
│  - Predicts outcomes (contracts)                                        │
│  - Identifies constraints (invariants)                                  │
│  - Creates testable hypotheses (specs)                                  │
│                                                                          │
│  CODING AGENT = Experimental Physicist                                  │
│  ────────────────────────────────────                                   │
│  - Runs the experiment (implements code)                                │
│  - Validates predictions (runs tests)                                   │
│  - Reports discrepancies (feedback)                                     │
│                                                                          │
│  CONTRACT = Hypothesis                                                  │
│  ─────────────────────                                                  │
│  - Testable: Can be verified                                            │
│  - Falsifiable: Can be proven wrong                                     │
│  - Specific: Clear success/failure criteria                             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Chunking Theory

Experienced developers think in CHUNKS, not tokens:

```
TOKEN LEVEL (how LLMs see code):
  for i := 0; i < len(arr); i++ { ... }
  = 15+ tokens

CHUNK LEVEL (how experts think):
  "iterate array" = 1 chunk

BLUEPRINT ARCHITECT thinks in chunks:
  - "authenticate user" = 1 function chunk
  - "validate input" = 1 operation chunk
  - "handle error" = 1 pattern chunk
```

### Common Chunk Patterns

| Chunk | Meaning | Typical Implementation |
|-------|---------|----------------------|
| iterate | Process each item | for loop, map, forEach |
| filter | Select matching items | filter, Where, grep |
| transform | Change data shape | map, Select, transform |
| aggregate | Combine into one | reduce, fold, aggregate |
| validate | Check conditions | if/guard, validator |
| persist | Save to storage | INSERT, save, write |
| fetch | Retrieve from source | SELECT, read, get |

---

## Quick Reference

| Level | Artifact | Owner | Example |
|-------|----------|-------|---------|
| 4 | Requirements | Human | "Need user login" |
| 3 | Architecture | Architect | "AuthService component" |
| **2** | **Blueprint** | **This Agent** | **login() → Session** |
| 1 | Code | Coding Agent | func login(...) {...} |
