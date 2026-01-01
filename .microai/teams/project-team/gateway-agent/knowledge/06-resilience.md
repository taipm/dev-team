# Resilience Patterns

## Circuit Breaker

```go
type CircuitState int

const (
    StateClosed   CircuitState = iota // Normal operation
    StateOpen                         // Failing, reject requests
    StateHalfOpen                     // Testing if recovered
)

type CircuitBreaker struct {
    mu            sync.Mutex
    state         CircuitState
    failures      int
    successes     int
    lastFailure   time.Time
    threshold     int           // Failures to open
    timeout       time.Duration // Time in open state
    halfOpenLimit int           // Successes to close
}

func NewCircuitBreaker(threshold int, timeout time.Duration) *CircuitBreaker {
    return &CircuitBreaker{
        state:         StateClosed,
        threshold:     threshold,
        timeout:       timeout,
        halfOpenLimit: 3,
    }
}

func (cb *CircuitBreaker) Execute(fn func() error) error {
    if !cb.Allow() {
        return ErrCircuitOpen
    }

    err := fn()

    if err != nil {
        cb.RecordFailure()
        return err
    }

    cb.RecordSuccess()
    return nil
}

func (cb *CircuitBreaker) Allow() bool {
    cb.mu.Lock()
    defer cb.mu.Unlock()

    switch cb.state {
    case StateClosed:
        return true

    case StateOpen:
        if time.Since(cb.lastFailure) > cb.timeout {
            cb.state = StateHalfOpen
            cb.successes = 0
            return true
        }
        return false

    case StateHalfOpen:
        return cb.successes < cb.halfOpenLimit
    }

    return false
}

func (cb *CircuitBreaker) RecordSuccess() {
    cb.mu.Lock()
    defer cb.mu.Unlock()

    cb.failures = 0

    if cb.state == StateHalfOpen {
        cb.successes++
        if cb.successes >= cb.halfOpenLimit {
            cb.state = StateClosed
        }
    }
}

func (cb *CircuitBreaker) RecordFailure() {
    cb.mu.Lock()
    defer cb.mu.Unlock()

    cb.failures++
    cb.lastFailure = time.Now()

    if cb.state == StateClosed && cb.failures >= cb.threshold {
        cb.state = StateOpen
    }

    if cb.state == StateHalfOpen {
        cb.state = StateOpen
    }
}

func (cb *CircuitBreaker) State() CircuitState {
    cb.mu.Lock()
    defer cb.mu.Unlock()
    return cb.state
}
```

## Retry with Exponential Backoff

```go
type RetryConfig struct {
    MaxRetries  int
    InitialWait time.Duration
    MaxWait     time.Duration
    Multiplier  float64
    Jitter      float64
}

var DefaultRetryConfig = RetryConfig{
    MaxRetries:  3,
    InitialWait: 100 * time.Millisecond,
    MaxWait:     10 * time.Second,
    Multiplier:  2.0,
    Jitter:      0.1,
}

func Retry(ctx context.Context, cfg RetryConfig, fn func() error) error {
    var lastErr error
    wait := cfg.InitialWait

    for attempt := 0; attempt <= cfg.MaxRetries; attempt++ {
        err := fn()
        if err == nil {
            return nil
        }

        lastErr = err

        // Don't retry on context cancellation
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
        }

        // Don't retry on client errors (4xx)
        if isClientError(err) {
            return err
        }

        // Don't retry on last attempt
        if attempt == cfg.MaxRetries {
            break
        }

        // Calculate jitter
        jitter := wait * time.Duration(cfg.Jitter*rand.Float64())

        // Sleep with context
        select {
        case <-ctx.Done():
            return ctx.Err()
        case <-time.After(wait + jitter):
        }

        // Exponential backoff
        wait = time.Duration(float64(wait) * cfg.Multiplier)
        if wait > cfg.MaxWait {
            wait = cfg.MaxWait
        }
    }

    return fmt.Errorf("max retries exceeded: %w", lastErr)
}

func isClientError(err error) bool {
    var httpErr *HTTPError
    if errors.As(err, &httpErr) {
        return httpErr.StatusCode >= 400 && httpErr.StatusCode < 500
    }
    return false
}
```

## Timeout Patterns

```go
// Request-level timeout
func WithTimeout(ctx context.Context, timeout time.Duration, fn func(context.Context) error) error {
    ctx, cancel := context.WithTimeout(ctx, timeout)
    defer cancel()

    done := make(chan error, 1)
    go func() {
        done <- fn(ctx)
    }()

    select {
    case err := <-done:
        return err
    case <-ctx.Done():
        return ctx.Err()
    }
}

// Tiered timeouts
const (
    TimeoutFast   = 5 * time.Second   // Health checks, auth
    TimeoutNormal = 30 * time.Second  // Regular API calls
    TimeoutSlow   = 120 * time.Second // File uploads, reports
)

func TimeoutMiddleware(timeout time.Duration) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            ctx, cancel := context.WithTimeout(r.Context(), timeout)
            defer cancel()

            // Use a channel to detect when handler completes
            done := make(chan struct{})
            go func() {
                next.ServeHTTP(w, r.WithContext(ctx))
                close(done)
            }()

            select {
            case <-done:
                // Handler completed normally
            case <-ctx.Done():
                // Timeout - but response might already be written
                // Best effort: set header if not written yet
            }
        })
    }
}
```

## Bulkhead (Concurrency Limiter)

```go
type Bulkhead struct {
    sem chan struct{}
}

func NewBulkhead(maxConcurrent int) *Bulkhead {
    return &Bulkhead{
        sem: make(chan struct{}, maxConcurrent),
    }
}

func (b *Bulkhead) Execute(ctx context.Context, fn func() error) error {
    select {
    case b.sem <- struct{}{}:
        defer func() { <-b.sem }()
        return fn()
    case <-ctx.Done():
        return ctx.Err()
    default:
        return ErrBulkheadFull
    }
}

// With wait
func (b *Bulkhead) ExecuteWithWait(ctx context.Context, fn func() error) error {
    select {
    case b.sem <- struct{}{}:
        defer func() { <-b.sem }()
        return fn()
    case <-ctx.Done():
        return ctx.Err()
    }
}

var ErrBulkheadFull = errors.New("bulkhead: maximum concurrent requests reached")
```

## Fallback Pattern

```go
type Fallback[T any] struct {
    primary  func(context.Context) (T, error)
    fallback func(context.Context, error) (T, error)
}

func NewFallback[T any](primary, fallback func(context.Context) (T, error)) *Fallback[T] {
    return &Fallback[T]{
        primary: primary,
        fallback: func(ctx context.Context, _ error) (T, error) {
            return fallback(ctx)
        },
    }
}

func (f *Fallback[T]) Execute(ctx context.Context) (T, error) {
    result, err := f.primary(ctx)
    if err != nil {
        return f.fallback(ctx, err)
    }
    return result, nil
}

// Usage
fallback := NewFallback(
    func(ctx context.Context) (User, error) {
        return userService.Get(ctx, userID)
    },
    func(ctx context.Context) (User, error) {
        return cache.GetUser(ctx, userID) // Stale cache as fallback
    },
)
```

## Deadline Propagation

```go
func PropagateDeadline(r *http.Request) *http.Request {
    // Check for incoming deadline header
    if deadline := r.Header.Get("X-Deadline"); deadline != "" {
        ts, err := strconv.ParseInt(deadline, 10, 64)
        if err == nil {
            t := time.Unix(0, ts)
            ctx, _ := context.WithDeadline(r.Context(), t)
            return r.WithContext(ctx)
        }
    }
    return r
}

func ForwardDeadline(r *http.Request, upstream *http.Request) {
    if deadline, ok := r.Context().Deadline(); ok {
        upstream.Header.Set("X-Deadline", strconv.FormatInt(deadline.UnixNano(), 10))
    }
}
```

## Combined Pattern

```go
type ResilientClient struct {
    client  *http.Client
    circuit *CircuitBreaker
    bulkhead *Bulkhead
    retry   RetryConfig
}

func (c *ResilientClient) Do(ctx context.Context, req *http.Request) (*http.Response, error) {
    var resp *http.Response

    err := c.bulkhead.ExecuteWithWait(ctx, func() error {
        return c.circuit.Execute(func() error {
            return Retry(ctx, c.retry, func() error {
                var err error
                resp, err = c.client.Do(req)
                if err != nil {
                    return err
                }
                if resp.StatusCode >= 500 {
                    resp.Body.Close()
                    return &HTTPError{StatusCode: resp.StatusCode}
                }
                return nil
            })
        })
    })

    return resp, err
}
```

## Monitoring Resilience

```go
var (
    circuitStateGauge = prometheus.NewGaugeVec(
        prometheus.GaugeOpts{
            Name: "circuit_breaker_state",
            Help: "Current state of circuit breaker (0=closed, 1=open, 2=half-open)",
        },
        []string{"name"},
    )

    retryCounter = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "retry_attempts_total",
            Help: "Total retry attempts",
        },
        []string{"name", "success"},
    )

    bulkheadRejections = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "bulkhead_rejections_total",
            Help: "Requests rejected by bulkhead",
        },
        []string{"name"},
    )
)
```
