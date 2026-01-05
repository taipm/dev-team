---
id: H-2
name: Multiple Code Bugs Detection
category: Code Review
difficulty: 5
points: 7
keywords:
  - loop variable
  - closure
  - capture
  - unbounded
  - goroutine
  - leak
  - semaphore
---

# Multiple Code Bugs Detection

## Prompt

<prompt>
```go
func processRequests(requests <-chan Request) {
    for req := range requests {
        go func() {
            result := process(req)
            _ = result
        }()
    }
}
```

What are ALL the problems with this code?
</prompt>

## Expected Behavior

The answer should identify ALL these issues:
1. **Loop variable capture bug** - closure captures `req` variable
2. **Unbounded goroutines** - no limit on concurrent goroutines
3. **Result ignored** - processed result is discarded
4. **No error handling** - process() errors not handled

## The Bugs

### Bug 1: Loop Variable Capture
```go
// All goroutines may see the same 'req' value (the last one)
// because they capture the variable, not the value
```

### Bug 2: Unbounded Goroutines
```go
// No limit on concurrent goroutines
// Could spawn millions if channel has many items
// OOM or resource exhaustion
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Identifies all issues (closure + unbounded + others) with fixes |
| 6 pts | Identifies closure bug + goroutine issue |
| 5 pts | Identifies two issues |
| 4 pts | Identifies closure bug with fix |
| 3 pts | Identifies one issue |
| 2 pts | Vague concern without specifics |
| 0 pts | Says code is fine |

## Good Answer Example

```
Problems found:

1. LOOP VARIABLE CAPTURE (Critical)
   The closure captures the loop variable `req` by reference.
   All goroutines may see the same (last) value of req.

   Fix: Pass as parameter
   go func(r Request) {
       result := process(r)
   }(req)

2. UNBOUNDED GOROUTINES (Critical)
   No limit on concurrent goroutines. If channel has 1M items,
   1M goroutines spawn simultaneously → OOM.

   Fix: Use worker pool or semaphore
   sem := make(chan struct{}, 100) // limit to 100 concurrent
   for req := range requests {
       sem <- struct{}{}
       go func(r Request) {
           defer func() { <-sem }()
           result := process(r)
       }(req)
   }

3. RESULT IGNORED
   `_ = result` means we're discarding the processed result.
   Either remove processing or use the result.

4. NO ERROR HANDLING
   If process() can fail, errors are silently ignored.
   Should log or report errors.

Fixed version:
func processRequests(requests <-chan Request, results chan<- Result) {
    sem := make(chan struct{}, 100)
    for req := range requests {
        sem <- struct{}{}
        go func(r Request) {
            defer func() { <-sem }()
            result, err := process(r)
            if err != nil {
                log.Printf("process error: %v", err)
                return
            }
            results <- result
        }(req)
    }
}
```

## Why This Test

- Tests comprehensive code review skills
- Multiple issues require thorough analysis
- Loop variable bug is Go-specific knowledge
- Unbounded goroutines is common production issue
