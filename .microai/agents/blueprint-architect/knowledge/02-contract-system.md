# Contract System

> Contracts define the agreement between function and caller

---

## Core Contracts (Always Include)

### 1. Preconditions (Pre)

What the CALLER must ensure before calling.

```
Pre: email matches RFC 5322 format
Pre: password.length >= 8 && <= 128
Pre: user.status == ACTIVE
Pre: rateLimit not exceeded
```

**Good Preconditions:**
- Specific and verifiable
- Testable with unit tests
- Clear failure behavior

**Bad Preconditions:**
```
Pre: email is valid      ← What is "valid"?
Pre: password is strong  ← How strong?
Pre: data is correct     ← Meaningless
```

### 2. Postconditions (Post)

What the FUNCTION guarantees after execution.

```
Post(success): session.userId == user.id
Post(success): session.expiry > now + MIN_DURATION
Post(failure): error ∈ {InvalidCredentials, UserNotFound, RateLimited}
Post(always): audit log updated
```

**Structure:**
- `Post(success)`: What's true when function succeeds
- `Post(failure)`: What errors can occur
- `Post(always)`: Side effects that always happen

### 3. Invariants

Conditions that must ALWAYS be true.

```
Invariant: password NEVER appears in logs
Invariant: session.token has >= 256 bits entropy
Invariant: balance = sum(credits) - sum(debits)
Invariant: createdAt <= updatedAt
```

**Types:**
- Security invariants (never log secrets)
- Data invariants (referential integrity)
- Temporal invariants (ordering of events)

---

## Optional Contracts (On Request)

### 4. Performance Contract

```yaml
Performance:
  Time:
    Best:  O(1) - cache hit
    Avg:   O(log n) - indexed lookup
    Worst: O(n) - full scan (rare)

  Space: O(1) - constant memory

  I/O:
    DB Reads: 1
    DB Writes: 1
    Network: 0

  Latency:
    P50: < 50ms
    P95: < 150ms
    P99: < 300ms
    Max: < 1000ms (timeout)

  Resources:
    Memory: < 1KB per request
    CPU: < 100ms wall-clock
    Connections: 1 from pool
```

**When to Include:**
- High-traffic endpoints
- Real-time requirements
- Resource-constrained environments
- SLA-bound operations

### 5. Concurrency Contract

```yaml
Concurrency:
  Thread Safety: ✓ Safe | ⚠ Conditional | ✗ Not Safe

  Atomicity:
    - "check-then-act on resource R must be atomic"
    - "balance update must use transaction"

  Locking:
    Required: YES/NO
    Type: optimistic/pessimistic/none
    Scope: row-level/table-level/distributed

  Race Conditions:
    ⚠ Counter increment: use atomic INCR
    ⚠ Cache invalidation: use TTL

  Idempotency:
    Key: orderId
    Window: 24 hours
    Storage: Redis

  Scalability:
    Horizontal: ✓ Stateless, N instances OK
    Bottleneck: DB connections
```

**When to Include:**
- Multi-threaded access
- Distributed systems
- High-concurrency endpoints
- Financial transactions

---

## Contract Templates

### Query Function (Read-only)

```
function findX(criteria):
    Pre: criteria is valid filter object
    Pre: caller has READ permission

    Post(found): returned entity matches criteria
    Post(not found): returns null (NOT error)

    Invariant: does not modify any state

    Time: O(log n) with index
    I/O: 1 database read
```

### Command Function (Write)

```
function createX(data):
    Pre: data passes validation
    Pre: caller has CREATE permission
    Pre: no duplicate exists

    Post(success):
        - entity created with unique ID
        - entity.createdAt == now()
        - returns created entity

    Post(failure):
        - error ∈ {VALIDATION, DUPLICATE, PERMISSION}
        - no partial data created (rollback)

    Time: O(1)
    I/O: 1 database write
```

### Idempotent Operation

```
function processOnce(key, data):
    Pre: key is unique identifier

    Post: if already processed with same key, return cached result
    Post: if new, process and cache result

    Invariant: calling N times with same key == calling once

    Idempotency:
        Key: key parameter
        Window: 7 days
```

---

## Abstraction Leak Warnings

Include these when abstract contract hides real-world complexity:

| Type | Abstract | Reality | Mitigation |
|------|----------|---------|------------|
| Performance | O(1) lookup | O(n) without index | Ensure DB index exists |
| Error | "returns error" | Network timeout, retry needed | Specify retry policy |
| Concurrency | Thread-safe | Race on shared counter | Use atomic operations |
| I/O | "sends email" | External API can fail | Add retry + dead letter |

---

## Quality Checklist

```
□ PRECONDITIONS
  □ All inputs validated?
  □ Permissions specified?
  □ State requirements clear?

□ POSTCONDITIONS
  □ Success case complete?
  □ All error types listed?
  □ Side effects documented?

□ INVARIANTS
  □ Security properties stated?
  □ Data consistency rules?

□ OPTIONAL (if complex)
  □ Performance bounds?
  □ Concurrency concerns?
```
