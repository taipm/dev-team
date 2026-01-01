# go-team

Team chuyên gia phát triển Go.

## Tổng Quan

go-team là specialized team cho Go development, bao gồm các experts về implementation, refactoring, và code review.

## Team Members

| Member | Role | Expertise |
|--------|------|-----------|
| go-dev-portable | Developer | Implementation, debugging |
| go-refactor-portable | Refactorer | Code refactoring |
| go-review-linus | Reviewer | Code review (Linus style) |

## Kích Hoạt

Team được kích hoạt tự động khi làm việc với Go code, hoặc qua individual agents:

```
/microai:go:go-dev
/microai:go:go-refactor
/microai:go:go-review-linus
```

## Workflow

```
     ┌──────────────┐
     │  go-dev      │ ← Implementation
     └──────┬───────┘
            │
     ┌──────▼───────┐
     │ go-refactor  │ ← Clean up
     └──────┬───────┘
            │
     ┌──────▼───────┐
     │ go-review    │ ← Quality check
     └──────────────┘
```

## Capabilities

### 1. Implementation (go-dev)

```
Implement HTTP handler với proper error handling
```

### 2. Refactoring (go-refactor)

```
Refactor package này theo Go best practices
```

### 3. Code Review (go-review-linus)

```
Review code này theo Linus Torvalds style
```

## Ví Dụ Session

```
You: Implement và review user registration handler

go-dev: 👨‍💻 Implementing registration handler...

```go
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
    var req RegisterRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request", http.StatusBadRequest)
        return
    }

    user, err := h.userService.Create(r.Context(), req)
    if err != nil {
        // Handle error
    }

    json.NewEncoder(w).Encode(user)
}
```

go-refactor: 🔧 Suggesting improvements:
- Extract validation logic
- Add proper error wrapping
- Use middleware for common patterns

go-review-linus: 👿 Code review:
1. ❌ Error message leaks implementation details
2. ⚠️ Missing input validation
3. ⚠️ No request size limit
4. ✅ Context properly propagated
```

## Go Best Practices Enforced

- Error handling patterns
- Context propagation
- Interface design
- Testing strategies
- Project structure

## Xem Thêm

- [go-dev-portable Agent](../../agents/go-dev-agent.md)
- [go-refactor-portable Agent](../../agents/go-refactor-agent.md)
