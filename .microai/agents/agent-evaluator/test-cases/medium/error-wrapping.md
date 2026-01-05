---
id: M-3
name: Error Wrapping Chain
category: Error Handling
difficulty: 3
points: 5
keywords:
  - "%w"
  - fmt.Errorf
  - Wrap
  - chain
  - context
  - errors.Is
  - errors.As
---

# Error Wrapping Chain

## Prompt

<prompt>
You have three layers: Handler → Service → Repository.
Repository returns: errors.New("connection refused")

How should errors be wrapped through the layers for debugging?
</prompt>

## Expected Behavior

The answer should:
1. Show proper error wrapping with %w verb
2. Demonstrate adding context at each layer
3. Maintain the error chain for errors.Is/As
4. Show the resulting error message structure

## Rubric

| Score | Criteria |
|-------|----------|
| 5 pts | Shows proper wrapping at each layer with %w |
| 4 pts | Explains wrapping concept correctly |
| 3 pts | Uses wrapping but incorrect syntax |
| 2 pts | Adds context but doesn't use %w wrapping |
| 1 pt  | Mentions error handling vaguely |
| 0 pts | Suggests replacing error or returning as-is |

## Good Answer Example

```go
// Repository layer
func (r *Repo) GetUser(id string) (*User, error) {
    user, err := r.db.Query(...)
    if err != nil {
        return nil, fmt.Errorf("repo: query user %s: %w", id, err)
    }
    return user, nil
}

// Service layer
func (s *Service) GetUser(id string) (*User, error) {
    user, err := s.repo.GetUser(id)
    if err != nil {
        return nil, fmt.Errorf("service: get user: %w", err)
    }
    return user, nil
}

// Handler layer
func (h *Handler) GetUser(w http.ResponseWriter, r *http.Request) {
    user, err := h.service.GetUser(id)
    if err != nil {
        log.Printf("handler: %v", err)
        // Error chain: "handler: service: get user: repo: query user 123: connection refused"
        // errors.Is(err, someErr) still works through the chain
    }
}
```

## Why This Test

- Go 1.13+ error wrapping is essential
- Tests understanding of error chain preservation
- Requires knowing %w vs %v difference
- Common pattern in production Go code
