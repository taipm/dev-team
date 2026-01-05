---
id: H-4
name: Fan-In Concurrency Pattern
category: Concurrency
difficulty: 6
points: 7
keywords:
  - select
  - WaitGroup
  - ctx.Done
  - close
  - range
  - fan-in
  - merge
---

# Fan-In Concurrency Pattern

## Prompt

<prompt>
Implement a fan-in function that:
1. Merges multiple input channels into one output channel
2. Handles channel closure gracefully
3. Stops when context is cancelled
4. Does not leak goroutines

Provide an implementation sketch.
</prompt>

## Expected Behavior

The answer should:
1. Show proper use of WaitGroup for goroutine tracking
2. Use select with ctx.Done() for cancellation
3. Close output channel when all inputs are done
4. Handle channel closure without panic

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Complete, correct implementation with all requirements |
| 6 pts | Working implementation with minor issues |
| 5 pts | Core logic correct, missing some cleanup |
| 4 pts | Understands pattern, incomplete implementation |
| 3 pts | Partial understanding of fan-in |
| 2 pts | Basic channel knowledge shown |
| 0 pts | Wrong approach or doesn't understand |

## Good Answer Example

```go
func FanIn[T any](ctx context.Context, channels ...<-chan T) <-chan T {
    out := make(chan T)
    var wg sync.WaitGroup

    // Helper to forward from one input to output
    forward := func(ch <-chan T) {
        defer wg.Done()
        for {
            select {
            case <-ctx.Done():
                return // Stop on context cancellation
            case val, ok := <-ch:
                if !ok {
                    return // Input channel closed
                }
                select {
                case <-ctx.Done():
                    return
                case out <- val:
                    // Forwarded successfully
                }
            }
        }
    }

    // Start a goroutine for each input channel
    wg.Add(len(channels))
    for _, ch := range channels {
        go forward(ch)
    }

    // Close output when all inputs are done
    go func() {
        wg.Wait()
        close(out)
    }()

    return out
}

// Usage:
// ch1, ch2, ch3 := make(chan int), make(chan int), make(chan int)
// merged := FanIn(ctx, ch1, ch2, ch3)
// for val := range merged { ... }
```

Key points:
1. **WaitGroup** tracks when all input goroutines finish
2. **select with ctx.Done()** enables cancellation
3. **val, ok := <-ch** detects channel closure
4. **close(out)** in separate goroutine after wg.Wait()
5. **Nested select** prevents blocking on cancelled context

## Why This Test

- Tests advanced concurrency pattern knowledge
- Requires understanding of multiple Go primitives
- Common building block in concurrent systems
- Many ways to get it wrong (goroutine leaks, panics)
