# Rate Limiting Patterns

## Token Bucket Algorithm

```go
import "golang.org/x/time/rate"

type RateLimiter struct {
    mu      sync.RWMutex
    buckets map[string]*rate.Limiter
    rate    rate.Limit  // tokens per second
    burst   int         // max burst size
    cleanup *time.Ticker
}

func NewRateLimiter(rps float64, burst int) *RateLimiter {
    rl := &RateLimiter{
        buckets: make(map[string]*rate.Limiter),
        rate:    rate.Limit(rps),
        burst:   burst,
        cleanup: time.NewTicker(5 * time.Minute),
    }

    // Periodic cleanup of old buckets
    go rl.cleanupLoop()

    return rl
}

func (rl *RateLimiter) Allow(key string) bool {
    rl.mu.Lock()
    limiter, ok := rl.buckets[key]
    if !ok {
        limiter = rate.NewLimiter(rl.rate, rl.burst)
        rl.buckets[key] = limiter
    }
    rl.mu.Unlock()

    return limiter.Allow()
}

func (rl *RateLimiter) cleanupLoop() {
    for range rl.cleanup.C {
        rl.mu.Lock()
        // Remove buckets that are full (idle clients)
        for key, limiter := range rl.buckets {
            if limiter.Tokens() >= float64(rl.burst) {
                delete(rl.buckets, key)
            }
        }
        rl.mu.Unlock()
    }
}
```

## Rate Limit Middleware

```go
func RateLimitMiddleware(limiter *RateLimiter, keyFunc KeyFunc) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            key := keyFunc(r)

            if !limiter.Allow(key) {
                // Set rate limit headers
                w.Header().Set("Retry-After", "1")
                w.Header().Set("X-RateLimit-Limit", strconv.Itoa(limiter.burst))
                w.Header().Set("X-RateLimit-Remaining", "0")

                writeError(w, r, 429, "RATE_LIMITED", "Too many requests")
                return
            }

            next.ServeHTTP(w, r)
        })
    }
}
```

## Key Extraction Functions

```go
type KeyFunc func(*http.Request) string

// By client IP
func KeyByIP(r *http.Request) string {
    return realIP(r)
}

// By authenticated user
func KeyByUser(r *http.Request) string {
    claims := GetUserClaims(r.Context())
    if claims != nil {
        return "user:" + claims.UserID
    }
    return "ip:" + realIP(r)
}

// By API key
func KeyByAPIKey(r *http.Request) string {
    key := r.Header.Get("X-API-Key")
    if key != "" {
        return "key:" + key
    }
    return "ip:" + realIP(r)
}

// Composite key
func KeyByEndpoint(r *http.Request) string {
    base := KeyByUser(r)
    return base + ":" + r.Method + ":" + r.URL.Path
}

func realIP(r *http.Request) string {
    // Check X-Forwarded-For first
    if xff := r.Header.Get("X-Forwarded-For"); xff != "" {
        parts := strings.Split(xff, ",")
        return strings.TrimSpace(parts[0])
    }

    // Check X-Real-IP
    if xri := r.Header.Get("X-Real-IP"); xri != "" {
        return xri
    }

    // Fallback to RemoteAddr
    host, _, err := net.SplitHostPort(r.RemoteAddr)
    if err != nil {
        return r.RemoteAddr
    }
    return host
}
```

## Tiered Rate Limits

```go
type TieredLimiter struct {
    tiers map[string]*RateLimiter
}

func NewTieredLimiter() *TieredLimiter {
    return &TieredLimiter{
        tiers: map[string]*RateLimiter{
            "free":       NewRateLimiter(10, 20),    // 10 rps
            "basic":      NewRateLimiter(50, 100),   // 50 rps
            "premium":    NewRateLimiter(200, 400),  // 200 rps
            "enterprise": NewRateLimiter(1000, 2000), // 1000 rps
        },
    }
}

func (tl *TieredLimiter) Allow(tier, key string) bool {
    limiter, ok := tl.tiers[tier]
    if !ok {
        limiter = tl.tiers["free"]
    }
    return limiter.Allow(key)
}

func TieredRateLimitMiddleware(tl *TieredLimiter) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            claims := GetUserClaims(r.Context())
            tier := "free"
            key := realIP(r)

            if claims != nil {
                tier = claims.Tier
                key = claims.UserID
            }

            if !tl.Allow(tier, key) {
                writeError(w, r, 429, "RATE_LIMITED", "Rate limit exceeded")
                return
            }

            next.ServeHTTP(w, r)
        })
    }
}
```

## Sliding Window (Redis-backed)

```go
type RedisRateLimiter struct {
    client *redis.Client
    window time.Duration
    limit  int
}

func (rl *RedisRateLimiter) Allow(ctx context.Context, key string) (bool, error) {
    now := time.Now().UnixMilli()
    windowStart := now - rl.window.Milliseconds()

    pipe := rl.client.Pipeline()

    // Remove old entries
    pipe.ZRemRangeByScore(ctx, key, "0", strconv.FormatInt(windowStart, 10))

    // Count current window
    count := pipe.ZCard(ctx, key)

    // Add current request
    pipe.ZAdd(ctx, key, redis.Z{Score: float64(now), Member: now})

    // Set expiry
    pipe.Expire(ctx, key, rl.window)

    _, err := pipe.Exec(ctx)
    if err != nil {
        return false, err
    }

    return count.Val() < int64(rl.limit), nil
}
```

## Rate Limit Headers

```
X-RateLimit-Limit: 100          # Max requests per window
X-RateLimit-Remaining: 45       # Requests remaining
X-RateLimit-Reset: 1640000000   # Unix timestamp when limit resets
Retry-After: 30                 # Seconds to wait (on 429)
```

## Configuration

```go
type RateLimitConfig struct {
    // Global limits
    GlobalRPS   float64 `yaml:"global_rps"`
    GlobalBurst int     `yaml:"global_burst"`

    // Per-client limits
    ClientRPS   float64 `yaml:"client_rps"`
    ClientBurst int     `yaml:"client_burst"`

    // Per-endpoint limits
    EndpointLimits map[string]struct {
        RPS   float64 `yaml:"rps"`
        Burst int     `yaml:"burst"`
    } `yaml:"endpoints"`

    // Whitelist (no limits)
    WhitelistedIPs []string `yaml:"whitelisted_ips"`
}
```

## Best Practices

| Practice | Description |
|----------|-------------|
| Fail open on errors | Allow request if rate limiter fails |
| Log rate limit events | Track abuse patterns |
| Use consistent keys | Same key format across services |
| Set appropriate burst | Burst = 2x RPS typical |
| Monitor limit hits | Alert on excessive 429s |
| Exempt health checks | Don't rate limit /health |
