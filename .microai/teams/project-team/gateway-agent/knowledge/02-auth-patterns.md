# Authentication & Authorization Patterns

## Token Extraction

```go
func extractToken(r *http.Request) string {
    // 1. Authorization header (preferred)
    if auth := r.Header.Get("Authorization"); auth != "" {
        if strings.HasPrefix(auth, "Bearer ") {
            return strings.TrimPrefix(auth, "Bearer ")
        }
    }

    // 2. Cookie fallback (browser clients)
    if cookie, err := r.Cookie("access_token"); err == nil {
        return cookie.Value
    }

    // 3. Query param (OAuth callbacks only)
    if token := r.URL.Query().Get("access_token"); token != "" {
        // Delete from URL after extraction (security)
        q := r.URL.Query()
        q.Del("access_token")
        r.URL.RawQuery = q.Encode()
        return token
    }

    return ""
}
```

## JWT Validation Middleware

```go
func AuthMiddleware(validator TokenValidator) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // Skip auth for public paths
            if isPublicPath(r.URL.Path) {
                next.ServeHTTP(w, r)
                return
            }

            token := extractToken(r)
            if token == "" {
                writeError(w, r, 401, "UNAUTHORIZED", "Missing authentication")
                return
            }

            claims, err := validator.Validate(r.Context(), token)
            if err != nil {
                // Log actual error, return generic message
                slog.Warn("token validation failed",
                    slog.String("error", err.Error()),
                    slog.String("request_id", GetRequestID(r.Context())),
                )
                writeError(w, r, 401, "UNAUTHORIZED", "Invalid authentication")
                return
            }

            // Check token expiry
            if claims.ExpiresAt.Before(time.Now()) {
                writeError(w, r, 401, "TOKEN_EXPIRED", "Token has expired")
                return
            }

            ctx := context.WithValue(r.Context(), userClaimsKey, claims)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

## RBAC Authorization

```go
type Permission string

const (
    PermRead   Permission = "read"
    PermWrite  Permission = "write"
    PermDelete Permission = "delete"
    PermAdmin  Permission = "admin"
)

type UserClaims struct {
    UserID      string       `json:"sub"`
    Email       string       `json:"email"`
    Roles       []string     `json:"roles"`
    Permissions []Permission `json:"permissions"`
    ExpiresAt   time.Time    `json:"exp"`
}

func (c *UserClaims) HasPermission(perm Permission) bool {
    for _, p := range c.Permissions {
        if p == perm || p == PermAdmin {
            return true
        }
    }
    return false
}

func (c *UserClaims) HasRole(role string) bool {
    for _, r := range c.Roles {
        if r == role {
            return true
        }
    }
    return false
}

// Middleware factory
func RequirePermission(perm Permission) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            claims := GetUserClaims(r.Context())
            if claims == nil {
                writeError(w, r, 401, "UNAUTHORIZED", "Not authenticated")
                return
            }

            if !claims.HasPermission(perm) {
                writeError(w, r, 403, "FORBIDDEN", "Insufficient permissions")
                return
            }

            next.ServeHTTP(w, r)
        })
    }
}
```

## Resource-Based Authorization

```go
// For path-based resource access
type ResourceAuthorizer interface {
    CanAccess(ctx context.Context, userID, resourceID string, action Permission) bool
}

func ResourceAuthMiddleware(authz ResourceAuthorizer) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            claims := GetUserClaims(r.Context())
            resourceID := chi.URLParam(r, "id") // or mux.Vars(r)["id"]
            action := methodToPermission(r.Method)

            if !authz.CanAccess(r.Context(), claims.UserID, resourceID, action) {
                writeError(w, r, 403, "FORBIDDEN", "Access denied to resource")
                return
            }

            next.ServeHTTP(w, r)
        })
    }
}

func methodToPermission(method string) Permission {
    switch method {
    case http.MethodGet, http.MethodHead:
        return PermRead
    case http.MethodPost, http.MethodPut, http.MethodPatch:
        return PermWrite
    case http.MethodDelete:
        return PermDelete
    default:
        return PermRead
    }
}
```

## API Key Authentication

```go
func APIKeyMiddleware(keyStore KeyStore) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            apiKey := r.Header.Get("X-API-Key")
            if apiKey == "" {
                apiKey = r.URL.Query().Get("api_key")
            }

            if apiKey == "" {
                writeError(w, r, 401, "UNAUTHORIZED", "API key required")
                return
            }

            keyInfo, err := keyStore.Validate(r.Context(), apiKey)
            if err != nil {
                writeError(w, r, 401, "UNAUTHORIZED", "Invalid API key")
                return
            }

            if keyInfo.IsExpired() {
                writeError(w, r, 401, "KEY_EXPIRED", "API key has expired")
                return
            }

            // Rate limit by API key
            if keyInfo.RateLimitExceeded() {
                writeError(w, r, 429, "RATE_LIMITED", "API key rate limit exceeded")
                return
            }

            ctx := context.WithValue(r.Context(), apiKeyInfoKey, keyInfo)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

## Security Best Practices

| Practice | Description |
|----------|-------------|
| Never log tokens | Log request IDs instead |
| Generic error messages | "Invalid token" not "Token signature invalid" |
| Short token lifetime | 15min access, 7day refresh |
| Secure token storage | HttpOnly cookies for browsers |
| Token revocation | Maintain blocklist for logout |
| Rate limit auth endpoints | Prevent brute force |
