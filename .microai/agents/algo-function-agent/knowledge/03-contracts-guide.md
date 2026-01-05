# Contracts Guide

> Hướng dẫn viết contracts: Preconditions, Postconditions, Invariants

---

## 1. What is a Contract?

Contract là "hợp đồng" giữa function và caller:
- **Preconditions**: Điều kiện caller PHẢI đảm bảo trước khi gọi
- **Postconditions**: Điều kiện function đảm bảo sau khi thực thi
- **Invariants**: Điều kiện luôn đúng trong suốt quá trình

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CONTRACT STRUCTURE                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   CALLER                              FUNCTION                       │
│   ┌──────────────────┐               ┌──────────────────┐           │
│   │                  │    CALL       │                  │           │
│   │  Must satisfy    │ ─────────────►│  Assumes pre-    │           │
│   │  preconditions   │               │  conditions true │           │
│   │                  │               │                  │           │
│   │  Can rely on     │ ◄─────────────│  Guarantees post-│           │
│   │  postconditions  │    RETURN     │  conditions true │           │
│   │                  │               │                  │           │
│   └──────────────────┘               └──────────────────┘           │
│                                                                      │
│   BOTH: Invariants hold before and after call                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Preconditions

### What to Include
```
✓ Input validation (format, range, type)
✓ State requirements (object must be in certain state)
✓ Resource availability (connection open, file exists)
✓ Authorization (user has permission)
✓ Rate limits (not exceeded)
```

### Writing Style
```
// Good: Specific and verifiable
Pre: email matches RFC 5322 format
Pre: password.length >= 8
Pre: user.status == ACTIVE
Pre: currentTime < session.expiry

// Bad: Vague or unverifiable
Pre: email is valid          // What is "valid"?
Pre: password is strong      // How strong?
Pre: user is good            // Meaningless
```

### Examples by Domain

**Authentication:**
```
function login(credentials):
    Pre: credentials.email matches email format (RFC 5322)
    Pre: credentials.password.length >= 8
    Pre: credentials.password.length <= 128
    Pre: rateLimit(credentials.email) not exceeded
```

**Data Access:**
```
function update(id, changes):
    Pre: id is valid UUID format
    Pre: changes is non-empty object
    Pre: changes contains only allowed fields
    Pre: caller has WRITE permission on entity
```

**File Operations:**
```
function upload(file, destination):
    Pre: file.size <= MAX_FILE_SIZE
    Pre: file.type in ALLOWED_TYPES
    Pre: destination is valid path
    Pre: user has write permission to destination
```

---

## 3. Postconditions

### What to Include
```
✓ Success outcome (what's returned/created)
✓ Failure outcome (error types)
✓ Side effects (what changed)
✓ State transitions (new state after call)
✓ Resource cleanup (what's released)
```

### Writing Style
```
// Good: Specific success and failure cases
Post(success): session.userId == user.id AND session.expiry > now()
Post(failure): error IN {InvalidCredentials, UserNotFound, RateLimited}
Post: auditLog contains new entry for this attempt

// Bad: Vague
Post: user is logged in      // What does this mean concretely?
Post: returns something      // What something?
```

### Examples by Domain

**Authentication:**
```
function login(credentials):
    Post(success):
        - returned session.userId == found user's id
        - returned session.expiry > currentTime + MIN_SESSION_DURATION
        - returned session.token is cryptographically random
        - session persisted to storage

    Post(failure):
        - error.type IN {INVALID_CREDENTIALS, USER_NOT_FOUND, RATE_LIMITED, ACCOUNT_LOCKED}
        - no session created
        - failed attempt logged

    Post(always):
        - login attempt recorded in audit log
        - rate limit counter incremented
```

**Data Access:**
```
function create(entity):
    Post(success):
        - returned id is unique
        - entity persisted with id
        - entity.createdAt == currentTime
        - entity.version == 1

    Post(failure):
        - error.type IN {VALIDATION_ERROR, DUPLICATE_KEY, DB_ERROR}
        - no entity created
```

**File Operations:**
```
function upload(file, destination):
    Post(success):
        - returned URL is accessible
        - file exists at destination
        - file.size == original.size (integrity)
        - file metadata stored

    Post(failure):
        - error.type IN {SIZE_EXCEEDED, TYPE_NOT_ALLOWED, STORAGE_FULL, PERMISSION_DENIED}
        - no partial file left on storage
```

---

## 4. Invariants

### Types of Invariants

**Data Invariants:**
```
Invariant: user.email is unique across all users
Invariant: order.total == sum(order.items.price * quantity)
Invariant: account.balance >= 0
```

**Security Invariants:**
```
Invariant: password NEVER appears in logs
Invariant: PII encrypted at rest
Invariant: session token not predictable
```

**State Invariants:**
```
Invariant: if order.status == SHIPPED then order.trackingNumber exists
Invariant: if user.status == DELETED then user.data is anonymized
```

**Temporal Invariants:**
```
Invariant: createdAt <= updatedAt
Invariant: startDate < endDate
Invariant: version is monotonically increasing
```

### Writing Style
```
// Good: Can be verified
Invariant: balance = sum(credits) - sum(debits)
Invariant: password is bcrypt hashed with cost >= 12
Invariant: token entropy >= 256 bits

// Bad: Cannot be verified
Invariant: system is secure          // How to verify?
Invariant: data is consistent        // Consistent how?
```

---

## 5. Contract Templates

### Basic Function Template
```
function name(param1, param2):
    // ═══════════════════════════════════════════════════════════════
    // SIGNATURE
    // ═══════════════════════════════════════════════════════════════
    Input:  param1: Type, param2: Type
    Output: Result<SuccessType, ErrorType>

    // ═══════════════════════════════════════════════════════════════
    // PRECONDITIONS
    // ═══════════════════════════════════════════════════════════════
    Pre: param1 condition
    Pre: param2 condition
    Pre: state condition

    // ═══════════════════════════════════════════════════════════════
    // POSTCONDITIONS
    // ═══════════════════════════════════════════════════════════════
    Post(success): what's guaranteed on success
    Post(failure): what errors can occur
    Post(always): side effects that always happen

    // ═══════════════════════════════════════════════════════════════
    // INVARIANTS
    // ═══════════════════════════════════════════════════════════════
    Invariant: condition that holds before and after

    // ═══════════════════════════════════════════════════════════════
    // COMPLEXITY
    // ═══════════════════════════════════════════════════════════════
    Time:  O(?)
    Space: O(?)
    I/O:   ? database/network calls
```

### Query Function Template
```
function findX(criteria):
    Pre: criteria is valid filter object
    Pre: caller has READ permission

    Post(found): returned entity matches criteria
    Post(not found): returns null/empty (NOT error)

    Invariant: does not modify any state

    Time: O(log n) with index, O(n) without
    I/O: 1 database read
```

### Command Function Template
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
        - error IN {VALIDATION, DUPLICATE, PERMISSION}
        - no partial data created

    Time: O(1)
    I/O: 1 database write
```

---

## 6. Common Contract Patterns

### Idempotent Operations
```
function processOnce(key, data):
    Pre: key is unique identifier

    Post: if already processed with same key, return cached result
    Post: if new, process and cache result

    Invariant: calling N times with same key == calling once
```

### Atomic Operations
```
function transferMoney(from, to, amount):
    Pre: from.balance >= amount
    Pre: amount > 0

    Post(success):
        - from.balance decreased by amount
        - to.balance increased by amount
        - sum of all balances unchanged

    Post(failure):
        - no balance changed (rollback)

    Invariant: sum(all balances) is constant
```

### Retry-Safe Operations
```
function sendNotification(userId, message, idempotencyKey):
    Pre: idempotencyKey is unique per logical operation

    Post: notification sent exactly once for this idempotencyKey

    Invariant: safe to retry on network failure
```

---

## 7. Contract Verification Checklist

```
□ PRECONDITIONS
  □ All inputs validated?
  □ Required state documented?
  □ Permissions specified?
  □ Rate limits mentioned?

□ POSTCONDITIONS
  □ Success case fully described?
  □ All error types enumerated?
  □ Side effects documented?
  □ State transitions clear?

□ INVARIANTS
  □ Security properties stated?
  □ Data consistency rules defined?
  □ Temporal constraints noted?

□ ANNOTATIONS
  □ Complexity documented?
  □ I/O operations counted?
  □ Concurrency notes added?
```

---

## 8. Anti-Patterns

### Too Weak
```
// Bad: Tells nothing useful
function process(data):
    Pre: data exists
    Post: something happens
```

### Too Strong
```
// Bad: Impossible to satisfy
function search(query):
    Pre: query will return exactly 10 results  // Can't know before calling
    Post: returns in < 1ms                      // Can't guarantee
```

### Missing Error Cases
```
// Bad: Only describes happy path
function login(creds):
    Pre: creds valid
    Post: user logged in
    // What if creds invalid? User not found? Account locked?
```

### Unverifiable
```
// Bad: Cannot be tested
function secure(data):
    Post: data is completely secure  // How to verify?
```

---

## 9. Performance Contracts (v2.0)

### Time Complexity Specification
```
Performance:
    Time:
        Best:  O(1) - when X condition
        Avg:   O(log n) - typical case
        Worst: O(n) - when Y condition

    Space: O(n) - linear with input size

    I/O Profile:
        DB Reads:  N
        DB Writes: M
        Network:   K external calls
```

### Latency Budget
```
Performance:
    Latency:
        P50: < 50ms    (median response)
        P95: < 150ms   (tail latency)
        P99: < 300ms   (worst acceptable)
        Max: < 1000ms  (timeout)

    Throughput:
        Target: 1000 req/sec per instance
        Peak:   5000 req/sec (burst)
```

### Resource Bounds
```
Performance:
    Resources:
        Memory: < 1KB per request
        CPU: < 100ms wall-clock
        Connections: 1 DB connection from pool
        File handles: 0
```

---

## 10. Concurrency Contracts (v2.0)

### Thread Safety
```
Concurrency:
    Thread Safety: ✓ Safe | ⚠ Conditional | ✗ Not Safe

    If conditional, specify:
        - Safe when: [conditions]
        - Requires: [external synchronization]
```

### Atomicity Requirements
```
Concurrency:
    Atomicity:
        - Operation A + B MUST be atomic
        - Use database transaction
        - Rollback on any failure

    Pattern: Use optimistic locking with version field
    Alternative: Distributed lock with Redis SETNX
```

### Race Condition Analysis
```
Concurrency:
    Race Conditions:
        ⚠ check-then-act on resource R:
            Risk: Another thread modifies R between check and act
            Mitigation: Use atomic compare-and-swap

        ⚠ shared counter:
            Risk: Lost updates
            Mitigation: Use atomic increment (INCR)

        ⚠ cache invalidation:
            Risk: Stale reads
            Mitigation: Use cache-aside with TTL
```

### Locking Strategy
```
Concurrency:
    Locking:
        Required: [YES/NO]
        Type: [optimistic/pessimistic/none]
        Scope: [row-level/table-level/distributed]
        Duration: [transaction/operation]

    Deadlock Prevention:
        - Always acquire locks in same order: A → B → C
        - Use timeout on lock acquisition
```

### Idempotency
```
Concurrency:
    Idempotency: [YES/NO/CONDITIONAL]

    If YES:
        Key: [what uniquely identifies same operation]
        Window: [how long to remember]
        Storage: [where to track - Redis/DB]

    If NO:
        Risk: Duplicate execution on retry
        Mitigation: [caller must handle]
```

### Scalability Properties
```
Concurrency:
    Scalability:
        Horizontal: ✓ Stateless, can run N instances
        Vertical: Limited by [resource]

        Bottlenecks:
            - Database connections (pooling helps)
            - External API rate limits

        Sharding:
            Strategy: [by user_id / by region / none]
```

---

## 11. Async/Concurrent Function Patterns (v2.0)

### Fan-Out Pattern
```
function processItems(items):
    Pre: items.length <= MAX_CONCURRENT

    Concurrency:
        Pattern: Fan-out / Fan-in
        Workers: min(items.length, MAX_WORKERS)
        Timeout: 30s per item, 5min total

    Post(success): all items processed
    Post(partial): some failed, return partial results + errors

    Error Handling:
        - Continue on individual failure
        - Collect all errors
        - Return aggregate result
```

### Producer-Consumer Pattern
```
function startWorker(queue, handler):
    Concurrency:
        Pattern: Producer-Consumer
        Buffer: bounded channel of size N
        Backpressure: block producer when full

    Invariant: no message lost
    Invariant: at-least-once delivery

    Graceful Shutdown:
        - Stop accepting new items
        - Drain existing items
        - Wait for in-flight to complete
```

### Saga Pattern (Distributed Transaction)
```
function executeOrderSaga(order):
    Concurrency:
        Pattern: Saga with compensating transactions

    Steps:
        1. reserveInventory() → on failure: STOP
        2. chargePayment() → on failure: releaseInventory()
        3. createOrder() → on failure: refundPayment(), releaseInventory()
        4. notifyUser() → on failure: log warning (non-critical)

    Invariant: Either all succeed OR all rolled back

    Implementation:
        - Use state machine for saga state
        - Persist state between steps
        - Support resume from any step
```

---

## Quick Reference

| Element | Purpose | Example |
|---------|---------|---------|
| Pre | What caller must ensure | `Pre: email is valid format` |
| Post(success) | What function guarantees on success | `Post: session.expiry > now` |
| Post(failure) | What errors can occur | `Post: error IN {A, B, C}` |
| Post(always) | Side effects | `Post: audit log updated` |
| Invariant | Always true | `Inv: password never logged` |
| @complexity | Performance | `O(n log n) time` |
| @security | Security note | `constant-time comparison` |
| @impl | Implementation hint | `use bcrypt` |

### v2.0 Contract Elements

| Element | Purpose | Example |
|---------|---------|---------|
| Performance.Time | Complexity bounds | `Best: O(1), Worst: O(n)` |
| Performance.Latency | Response time SLA | `P99: < 200ms` |
| Performance.Resources | Resource limits | `Memory: < 1KB` |
| Concurrency.ThreadSafe | Thread safety | `✓ Safe for concurrent calls` |
| Concurrency.Atomicity | Atomic operations | `A + B must be atomic` |
| Concurrency.RaceCondition | Race risks | `⚠ check-then-act on R` |
| Concurrency.Idempotency | Retry safety | `YES with key=orderId` |
| Concurrency.Scalability | Scaling properties | `Horizontal: ✓ Stateless` |
