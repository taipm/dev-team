---
id: H-1
name: Deadlock Analysis
category: Concurrency
difficulty: 5
points: 7
keywords:
  - deadlock
  - lock order
  - consistent
  - circular
  - waiting
  - acquire
---

# Deadlock Analysis

## Prompt

<prompt>
```go
func transfer(from, to *Account, amount int) {
    from.mu.Lock()
    defer from.mu.Unlock()
    to.mu.Lock()
    defer to.mu.Unlock()

    from.balance -= amount
    to.balance += amount
}
```

Two goroutines run simultaneously:
- Goroutine 1: transfer(A, B, 100)
- Goroutine 2: transfer(B, A, 50)

Explain the potential problem and provide a solution.
</prompt>

## Expected Behavior

The answer should:
1. Identify this creates a deadlock
2. Explain the mechanism (circular wait)
3. Provide a working solution (consistent lock ordering)

## The Problem

```
Goroutine 1: Lock A → waiting for B
Goroutine 2: Lock B → waiting for A
→ Circular wait = Deadlock
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Identifies deadlock + explains mechanism + provides working solution code |
| 6 pts | Identifies deadlock + correct solution concept |
| 5 pts | Identifies deadlock + partial solution |
| 4 pts | Identifies deadlock only |
| 3 pts | Mentions locking issue without deadlock |
| 2 pts | Vague concern about concurrency |
| 0 pts | Says code is fine |

## Good Answer Example

```
Problem: DEADLOCK

Scenario:
1. Goroutine 1 locks A, tries to lock B
2. Goroutine 2 locks B, tries to lock A
3. Both wait forever → deadlock

The issue is inconsistent lock ordering. Each goroutine acquires locks
in different order based on the arguments.

Solution: Always acquire locks in consistent order (e.g., by account ID):

func transfer(from, to *Account, amount int) {
    // Ensure consistent lock order
    first, second := from, to
    if from.id > to.id {
        first, second = to, from
    }

    first.mu.Lock()
    defer first.mu.Unlock()
    second.mu.Lock()
    defer second.mu.Unlock()

    from.balance -= amount
    to.balance += amount
}

Alternative: Use a single global lock for all transfers (simpler but less concurrent)
Alternative: Try-lock with backoff (more complex)
```

## Why This Test

- Classic concurrency problem
- Requires understanding of deadlock conditions
- Tests ability to reason about interleaving
- Solution requires architectural thinking
