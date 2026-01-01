# Reverse Proxy Patterns

## Basic Reverse Proxy

```go
func NewReverseProxy(target *url.URL) *httputil.ReverseProxy {
    proxy := httputil.NewSingleHostReverseProxy(target)

    // Custom director for request modification
    originalDirector := proxy.Director
    proxy.Director = func(r *http.Request) {
        originalDirector(r)

        // Forward original host (if needed)
        r.Host = target.Host

        // Propagate request ID
        if requestID := GetRequestID(r.Context()); requestID != "" {
            r.Header.Set("X-Request-ID", requestID)
        }

        // Forward client IP
        r.Header.Set("X-Forwarded-For", realIP(r))
        r.Header.Set("X-Real-IP", realIP(r))

        // Forward protocol
        if r.TLS != nil {
            r.Header.Set("X-Forwarded-Proto", "https")
        } else {
            r.Header.Set("X-Forwarded-Proto", "http")
        }
    }

    // Custom error handler
    proxy.ErrorHandler = func(w http.ResponseWriter, r *http.Request, err error) {
        slog.Error("proxy_error",
            slog.String("request_id", GetRequestID(r.Context())),
            slog.String("target", target.String()),
            slog.String("error", err.Error()),
        )
        writeError(w, r, 502, "BAD_GATEWAY", "Upstream service unavailable")
    }

    // Response modification
    proxy.ModifyResponse = func(resp *http.Response) error {
        // Remove upstream server headers
        resp.Header.Del("Server")

        // Add CORS if needed
        // ...

        return nil
    }

    return proxy
}
```

## Connection Pooling

```go
func NewProxyTransport(cfg TransportConfig) *http.Transport {
    return &http.Transport{
        // Connection pool
        MaxIdleConns:        cfg.MaxIdleConns,        // 100
        MaxIdleConnsPerHost: cfg.MaxIdleConnsPerHost, // 20
        MaxConnsPerHost:     cfg.MaxConnsPerHost,     // 0 = unlimited

        // Timeouts
        IdleConnTimeout:       90 * time.Second,
        TLSHandshakeTimeout:   10 * time.Second,
        ResponseHeaderTimeout: cfg.Timeout,
        ExpectContinueTimeout: 1 * time.Second,

        // Keep-alive
        DisableKeepAlives: false,

        // Compression
        DisableCompression: false,

        // TLS
        TLSClientConfig: &tls.Config{
            MinVersion: tls.VersionTLS12,
        },

        // Custom dialer with timeout
        DialContext: (&net.Dialer{
            Timeout:   30 * time.Second,
            KeepAlive: 30 * time.Second,
        }).DialContext,
    }
}
```

## Load Balancing

```go
type LoadBalancer struct {
    backends []*Backend
    mu       sync.RWMutex
    strategy Strategy
}

type Backend struct {
    URL     *url.URL
    Healthy bool
    Weight  int
    Proxy   *httputil.ReverseProxy
}

type Strategy interface {
    Next([]*Backend) *Backend
}

// Round-robin strategy
type RoundRobin struct {
    counter uint64
}

func (rr *RoundRobin) Next(backends []*Backend) *Backend {
    healthy := filterHealthy(backends)
    if len(healthy) == 0 {
        return nil
    }

    idx := atomic.AddUint64(&rr.counter, 1) % uint64(len(healthy))
    return healthy[idx]
}

// Weighted round-robin
type WeightedRoundRobin struct {
    mu      sync.Mutex
    weights []int
    current int
    gcd     int
    max     int
}

func (wrr *WeightedRoundRobin) Next(backends []*Backend) *Backend {
    wrr.mu.Lock()
    defer wrr.mu.Unlock()

    healthy := filterHealthy(backends)
    if len(healthy) == 0 {
        return nil
    }

    // Weighted selection algorithm
    for {
        wrr.current = (wrr.current + 1) % len(healthy)
        if wrr.current == 0 {
            wrr.weights[0] -= wrr.gcd
            if wrr.weights[0] <= 0 {
                wrr.weights[0] = wrr.max
            }
        }
        if healthy[wrr.current].Weight >= wrr.weights[wrr.current] {
            return healthy[wrr.current]
        }
    }
}

// Least connections
type LeastConnections struct{}

func (lc *LeastConnections) Next(backends []*Backend) *Backend {
    healthy := filterHealthy(backends)
    if len(healthy) == 0 {
        return nil
    }

    var min *Backend
    for _, b := range healthy {
        if min == nil || b.ActiveConns() < min.ActiveConns() {
            min = b
        }
    }
    return min
}
```

## Health Checking

```go
type HealthChecker struct {
    interval time.Duration
    timeout  time.Duration
    path     string
    client   *http.Client
}

func (hc *HealthChecker) Start(ctx context.Context, backends []*Backend) {
    ticker := time.NewTicker(hc.interval)
    defer ticker.Stop()

    for {
        select {
        case <-ctx.Done():
            return
        case <-ticker.C:
            hc.checkAll(ctx, backends)
        }
    }
}

func (hc *HealthChecker) checkAll(ctx context.Context, backends []*Backend) {
    var wg sync.WaitGroup

    for _, b := range backends {
        wg.Add(1)
        go func(backend *Backend) {
            defer wg.Done()

            ctx, cancel := context.WithTimeout(ctx, hc.timeout)
            defer cancel()

            healthy := hc.check(ctx, backend)
            backend.SetHealthy(healthy)
        }(b)
    }

    wg.Wait()
}

func (hc *HealthChecker) check(ctx context.Context, backend *Backend) bool {
    url := backend.URL.ResolveReference(&url.URL{Path: hc.path})

    req, err := http.NewRequestWithContext(ctx, "GET", url.String(), nil)
    if err != nil {
        return false
    }

    resp, err := hc.client.Do(req)
    if err != nil {
        return false
    }
    defer resp.Body.Close()

    return resp.StatusCode >= 200 && resp.StatusCode < 300
}
```

## Path-Based Routing

```go
type Router struct {
    routes []Route
}

type Route struct {
    PathPrefix string
    Backend    *Backend
    StripPath  bool
}

func (r *Router) Match(path string) (*Backend, string) {
    for _, route := range r.routes {
        if strings.HasPrefix(path, route.PathPrefix) {
            targetPath := path
            if route.StripPath {
                targetPath = strings.TrimPrefix(path, route.PathPrefix)
                if targetPath == "" {
                    targetPath = "/"
                }
            }
            return route.Backend, targetPath
        }
    }
    return nil, ""
}

func (r *Router) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    backend, targetPath := r.Match(req.URL.Path)
    if backend == nil {
        writeError(w, req, 404, "NOT_FOUND", "No route matched")
        return
    }

    // Rewrite path
    req.URL.Path = targetPath

    backend.Proxy.ServeHTTP(w, req)
}
```

## Streaming Support

```go
func NewStreamingProxy(target *url.URL) *httputil.ReverseProxy {
    proxy := httputil.NewSingleHostReverseProxy(target)

    // Enable streaming (don't buffer response)
    proxy.FlushInterval = -1 // Flush immediately

    // Handle SSE
    proxy.ModifyResponse = func(resp *http.Response) error {
        if resp.Header.Get("Content-Type") == "text/event-stream" {
            // Remove content-length for SSE
            resp.Header.Del("Content-Length")
            resp.ContentLength = -1
        }
        return nil
    }

    return proxy
}
```

## Timeout Configuration

```go
const (
    ProxyDialTimeout    = 10 * time.Second
    ProxyRequestTimeout = 30 * time.Second
    ProxyIdleTimeout    = 90 * time.Second
)

// Ensure gateway timeout < client timeout
// Client (60s) > Gateway (30s) > Backend health check (5s)
```

## Best Practices

| Practice | Description |
|----------|-------------|
| Use connection pooling | Reuse TCP connections |
| Set all timeouts | Dial, request, idle |
| Propagate headers | X-Request-ID, X-Forwarded-* |
| Health check backends | Remove unhealthy automatically |
| Strip internal headers | Server, X-Powered-By |
| Buffer responses (optional) | Only for small responses |
| Enable streaming | For SSE/WebSocket |
