# Security Headers & Hardening

## Essential Security Headers

```go
func SecurityHeadersMiddleware() Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            h := w.Header()

            // Prevent MIME sniffing
            h.Set("X-Content-Type-Options", "nosniff")

            // XSS protection (legacy browsers)
            h.Set("X-XSS-Protection", "1; mode=block")

            // Clickjacking protection
            h.Set("X-Frame-Options", "DENY")

            // HSTS (HTTPS only)
            if r.TLS != nil {
                h.Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload")
            }

            // Content Security Policy
            h.Set("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'")

            // Referrer Policy
            h.Set("Referrer-Policy", "strict-origin-when-cross-origin")

            // Permissions Policy (formerly Feature-Policy)
            h.Set("Permissions-Policy", "geolocation=(), camera=(), microphone=()")

            // Remove server identification
            h.Del("Server")
            h.Del("X-Powered-By")

            next.ServeHTTP(w, r)
        })
    }
}
```

## Header Reference

| Header | Value | Purpose |
|--------|-------|---------|
| `X-Content-Type-Options` | `nosniff` | Prevent MIME sniffing |
| `X-Frame-Options` | `DENY` | Prevent clickjacking |
| `X-XSS-Protection` | `1; mode=block` | XSS filter (legacy) |
| `Strict-Transport-Security` | `max-age=31536000` | Force HTTPS |
| `Content-Security-Policy` | `default-src 'self'` | Control resource loading |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Limit referrer info |
| `Permissions-Policy` | `geolocation=()` | Disable browser features |

## CORS Configuration

```go
type CORSConfig struct {
    AllowedOrigins   []string
    AllowedMethods   []string
    AllowedHeaders   []string
    ExposedHeaders   []string
    AllowCredentials bool
    MaxAge           int // seconds
}

var DefaultCORSConfig = CORSConfig{
    AllowedOrigins:   []string{}, // Must be configured!
    AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
    AllowedHeaders:   []string{"Authorization", "Content-Type", "X-Request-ID"},
    ExposedHeaders:   []string{"X-Request-ID", "X-RateLimit-Remaining"},
    AllowCredentials: true,
    MaxAge:           86400, // 24 hours
}

func CORSMiddleware(cfg CORSConfig) Middleware {
    origins := make(map[string]bool)
    for _, o := range cfg.AllowedOrigins {
        origins[o] = true
    }

    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            origin := r.Header.Get("Origin")

            // Check origin
            if origins[origin] || origins["*"] {
                w.Header().Set("Access-Control-Allow-Origin", origin)
                w.Header().Add("Vary", "Origin")
            } else if origin != "" {
                // Origin not allowed - don't set CORS headers
                // Browser will block the request
            }

            if cfg.AllowCredentials {
                w.Header().Set("Access-Control-Allow-Credentials", "true")
            }

            // Preflight request
            if r.Method == http.MethodOptions {
                w.Header().Set("Access-Control-Allow-Methods", strings.Join(cfg.AllowedMethods, ", "))
                w.Header().Set("Access-Control-Allow-Headers", strings.Join(cfg.AllowedHeaders, ", "))
                w.Header().Set("Access-Control-Max-Age", strconv.Itoa(cfg.MaxAge))
                w.WriteHeader(http.StatusNoContent)
                return
            }

            if len(cfg.ExposedHeaders) > 0 {
                w.Header().Set("Access-Control-Expose-Headers", strings.Join(cfg.ExposedHeaders, ", "))
            }

            next.ServeHTTP(w, r)
        })
    }
}
```

## Panic Recovery

```go
func PanicRecoveryMiddleware(logger *slog.Logger) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            defer func() {
                if err := recover(); err != nil {
                    // Capture stack trace
                    buf := make([]byte, 4096)
                    n := runtime.Stack(buf, false)

                    requestID := GetRequestID(r.Context())

                    logger.Error("panic_recovered",
                        slog.String("request_id", requestID),
                        slog.String("method", r.Method),
                        slog.String("path", r.URL.Path),
                        slog.Any("error", err),
                        slog.String("stack", string(buf[:n])),
                    )

                    // NEVER expose internal error details
                    w.Header().Set("Content-Type", "application/json")
                    w.WriteHeader(http.StatusInternalServerError)
                    w.Write([]byte(`{"error":{"code":"INTERNAL_ERROR","message":"Internal server error"}}`))
                }
            }()

            next.ServeHTTP(w, r)
        })
    }
}
```

## Request Body Limits

```go
const (
    MaxBodySize     = 1 << 20  // 1 MB
    MaxFileSize     = 10 << 20 // 10 MB
    MaxMultipartMem = 32 << 20 // 32 MB
)

func BodyLimitMiddleware(maxSize int64) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if r.ContentLength > maxSize {
                writeError(w, r, 413, "PAYLOAD_TOO_LARGE", "Request body too large")
                return
            }

            r.Body = http.MaxBytesReader(w, r.Body, maxSize)
            next.ServeHTTP(w, r)
        })
    }
}
```

## Input Sanitization

```go
// Sanitize path to prevent directory traversal
func sanitizePath(path string) string {
    // Remove any ../ or ..\
    cleaned := filepath.Clean(path)

    // Ensure no parent directory traversal
    if strings.Contains(cleaned, "..") {
        return ""
    }

    return cleaned
}

// Validate content type
func validateContentType(r *http.Request, allowed []string) bool {
    ct := r.Header.Get("Content-Type")
    if ct == "" {
        return false
    }

    mediaType, _, err := mime.ParseMediaType(ct)
    if err != nil {
        return false
    }

    for _, a := range allowed {
        if mediaType == a {
            return true
        }
    }
    return false
}
```

## Security Checklist

```
□ Security headers applied to ALL responses
□ CORS origins explicitly configured (no wildcards in production)
□ Request body size limits enforced
□ Panic recovery prevents stack trace leakage
□ Server version headers removed
□ HTTPS enforced via HSTS
□ Input sanitization at entry points
□ No sensitive data in error messages
□ Rate limiting on auth endpoints
□ Request timeout configured
```

## Common Vulnerabilities

| Vulnerability | Prevention |
|---------------|------------|
| XSS | CSP headers, output encoding |
| Clickjacking | X-Frame-Options: DENY |
| MIME sniffing | X-Content-Type-Options: nosniff |
| Man-in-the-middle | HSTS, TLS 1.2+ only |
| Directory traversal | Path sanitization |
| DoS via large payloads | Body size limits |
| Information disclosure | Generic error messages |
