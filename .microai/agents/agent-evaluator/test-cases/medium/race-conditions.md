---
id: M-5
name: Race Condition in Counter
category: Concurrency
difficulty: 3
points: 5
keywords:
  - not safe
  - unsafe
  - mutex
  - atomic
  - sync
  - race
  - lock
---

# Race Condition in Counter

## Prompt

<prompt>
```go
type Counter struct {
    count int
}

func (c *Counter) Increment() {
    c.count++
}

func (c *Counter) Get() int {
    return c.count
}
```

Multiple goroutines call Increment() and Get(). Is this safe?
</prompt>

## Expected Behavior

The answer should:
1. Clearly state it's NOT safe
2. Explain why (data race, non-atomic operations)
3. Provide a fix using mutex or atomic

## Rubric

| Score | Criteria |
|-------|----------|
| 5 pts | Identifies race with corrected code using sync.Mutex |
| 4 pts | Identifies race with solution idea (mutex/atomic) |
| 3 pts | Identifies it's unsafe |
| 2 pts | Vague mention of potential issues |
| 1 pt  | Uncertain answer |
| 0 pts | Says it's safe |

## Good Answer Example

```
No, this is NOT safe. There's a data race.

Problem: `c.count++` is not atomic. It's actually three operations:
1. Read count
2. Increment
3. Write count

Multiple goroutines can interleave these operations, causing lost updates.

Fix using sync.Mutex:

type Counter struct {
    mu    sync.Mutex
    count int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count++
}

func (c *Counter) Get() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.count
}

Alternative using atomic:

type Counter struct {
    count int64
}

func (c *Counter) Increment() {
    atomic.AddInt64(&c.count, 1)
}

func (c *Counter) Get() int64 {
    return atomic.LoadInt64(&c.count)
}
```

## Why This Test

- Classic concurrency bug pattern
- Tests understanding of Go's memory model
- Requires knowing ++ is not atomic
- Multiple valid solutions exist
