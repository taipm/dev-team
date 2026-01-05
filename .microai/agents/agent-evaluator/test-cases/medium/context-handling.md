---
id: M-2
name: Context Cancellation Bug
category: Concurrency
difficulty: 3
points: 5
keywords:
  - ctx.Done
  - select
  - cancellation
  - check
  - ignore
  - context
---

# Context Cancellation Bug

## Prompt

<prompt>
```go
func process(ctx context.Context) error {
    for i := 0; i < 1000; i++ {
        time.Sleep(10 * time.Millisecond)
    }
    return nil
}
```

What's wrong with this function's context handling?
</prompt>

## Expected Behavior

The answer should:
1. Identify that context is passed but never checked
2. Explain the function won't respond to cancellation
3. Provide corrected code with select/ctx.Done()

## Rubric

| Score | Criteria |
|-------|----------|
| 5 pts | Identifies issue with corrected code using select |
| 4 pts | Identifies issue with explanation of consequences |
| 3 pts | Mentions context not being checked |
| 2 pts | Vague mention of context issues |
| 1 pt  | Notices something wrong but can't articulate |
| 0 pts | Says code is fine |

## Good Answer Example

```
Problem: The function accepts a context but never checks it for cancellation.
If the context is cancelled, the function will continue running all 1000
iterations instead of stopping early.

Fixed version:

func process(ctx context.Context) error {
    for i := 0; i < 1000; i++ {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            time.Sleep(10 * time.Millisecond)
        }
    }
    return nil
}

Now the function checks ctx.Done() on each iteration and returns early
if cancelled.
```

## Why This Test

- Common bug in Go code
- Tests understanding of context pattern
- Requires both identification and solution
- Local models often miss the pattern
