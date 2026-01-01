# go-dev-portable - Phát Triển Go

Agent chuyên gia phát triển Go.

## Tổng Quan

**go-dev-portable** giúp:
- Implement Go code theo best practices
- Debug và fix bugs
- Integrate với Go ecosystem
- Optimize performance

## Kích Hoạt

Tự động kích hoạt khi làm việc với Go code, hoặc:

```
/microai:go:go-dev
```

## Capabilities

### 1. Code Implementation

```
Implement HTTP handler cho user registration
```

### 2. Debugging

```
Debug panic trong processOrder function
```

### 3. Best Practices

```
Review code này theo Go conventions
```

### 4. Performance

```
Optimize database queries trong repository
```

## Ví Dụ Session

```
You: Implement context handling cho API middleware

go-dev: 🐹 Go Dev Agent sẵn sàng!

Để implement context handling, tôi đề xuất:

1. **Request ID middleware**:
```go
func RequestIDMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        ctx := r.Context()
        requestID := uuid.New().String()
        ctx = context.WithValue(ctx, "requestID", requestID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
```

2. **Timeout middleware**:
```go
func TimeoutMiddleware(timeout time.Duration) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.TimeoutHandler(next, timeout, "Request timeout")
    }
}
```

Bạn muốn tôi implement full middleware chain không?
```

## Go Best Practices Covered

- Error handling với wrapped errors
- Context propagation
- Goroutine lifecycle management
- Interface-based design
- Testing patterns

## Xem Thêm

- [go-refactor-portable](./go-refactor-agent.md)
- [go-team](../teams/specialized/go-team.md)
