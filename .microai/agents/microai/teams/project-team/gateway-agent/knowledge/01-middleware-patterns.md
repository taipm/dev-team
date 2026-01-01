# Middleware Patterns for Go Gateway

## Middleware Chain Order

```
REQUEST FLOW (top to bottom):
┌─────────────────────────────────────────┐
│ 1. PanicRecovery   ← Outermost layer   │
│ 2. RequestID       ← Trace correlation │
│ 3. Logging         ← Request audit     │
│ 4. Metrics         ← Performance data  │
│ 5. Security        ← Headers & checks  │
│ 6. RateLimit       ← Traffic control   │
│ 7. Auth            ← Identity verify   │
│ 8. CORS            ← Browser security  │
│ 9. Compression     ← Response optimize │
│ 10. Handler        ← Business logic    │
└─────────────────────────────────────────┘
RESPONSE FLOW (bottom to top - reverse)
```

## Standard Middleware Signature

```go
type Middleware func(http.Handler) http.Handler

// Canonical implementation pattern
func ExampleMiddleware(opts Options) Middleware {
    // 1. Validate options at construction
    if opts.Timeout <= 0 {
        opts.Timeout = 30 * time.Second
    }

    // 2. Pre-compile patterns, create pools
    pool := sync.Pool{New: func() any { return new(bytes.Buffer) }}

    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // 3. Pre-processing
            ctx := r.Context()

            // 4. Call next
            next.ServeHTTP(w, r.WithContext(ctx))

            // 5. Post-processing (limited - response already sent)
        })
    }
}
```

## Chain Builder

```go
func BuildChain(final http.Handler, middlewares ...Middleware) http.Handler {
    for i := len(middlewares) - 1; i >= 0; i-- {
        final = middlewares[i](final)
    }
    return final
}

// Usage
handler := BuildChain(
    myHandler,
    PanicRecovery(logger),
    RequestID(),
    Logging(logger),
    Metrics(registry),
    RateLimit(limiter),
)
```

## Response Writer Wrapper

```go
type responseWriter struct {
    http.ResponseWriter
    status      int
    size        int
    wroteHeader bool
}

func wrapResponseWriter(w http.ResponseWriter) *responseWriter {
    return &responseWriter{ResponseWriter: w, status: 200}
}

func (rw *responseWriter) WriteHeader(code int) {
    if !rw.wroteHeader {
        rw.status = code
        rw.wroteHeader = true
        rw.ResponseWriter.WriteHeader(code)
    }
}

func (rw *responseWriter) Write(b []byte) (int, error) {
    if !rw.wroteHeader {
        rw.WriteHeader(http.StatusOK)
    }
    n, err := rw.ResponseWriter.Write(b)
    rw.size += n
    return n, err
}

// Support streaming
func (rw *responseWriter) Flush() {
    if f, ok := rw.ResponseWriter.(http.Flusher); ok {
        f.Flush()
    }
}

// Support hijacking (WebSocket)
func (rw *responseWriter) Hijack() (net.Conn, *bufio.ReadWriter, error) {
    if h, ok := rw.ResponseWriter.(http.Hijacker); ok {
        return h.Hijack()
    }
    return nil, nil, errors.New("hijack not supported")
}
```

## Context Value Patterns

```go
type contextKey string

// Define keys in package scope
const (
    requestIDKey contextKey = "request_id"
    userClaimsKey contextKey = "user_claims"
    startTimeKey contextKey = "start_time"
)

// Setter
func WithRequestID(ctx context.Context, id string) context.Context {
    return context.WithValue(ctx, requestIDKey, id)
}

// Getter with zero value fallback
func GetRequestID(ctx context.Context) string {
    if id, ok := ctx.Value(requestIDKey).(string); ok {
        return id
    }
    return ""
}
```

## Common Pitfalls

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Modifying response after WriteHeader | No effect | Check wroteHeader flag |
| Missing Flush support | SSE breaks | Implement http.Flusher |
| Missing Hijack support | WebSocket breaks | Implement http.Hijacker |
| Context value type collision | Wrong values | Use typed keys |
| Wrong middleware order | Security bypass | Follow standard order |
