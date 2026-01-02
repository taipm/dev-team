# Go Performance Patterns

> Optimization techniques and best practices for Go applications.

---

## Golden Rule

```
"Premature optimization is the root of all evil" — Donald Knuth

1. Make it work
2. Make it right
3. Make it fast (only if needed)
```

**Always measure before optimizing.**

---

## Memory Optimization

### Preallocate Slices

```go
// ❌ BAD: Multiple allocations
var result []int
for i := 0; i < 10000; i++ {
    result = append(result, i)
}

// ✅ GOOD: Single allocation
result := make([]int, 0, 10000)
for i := 0; i < 10000; i++ {
    result = append(result, i)
}
```

### Avoid Slice Memory Leaks

```go
// ❌ BAD: Keeps entire backing array in memory
func getFirst10(data []byte) []byte {
    return data[:10]
}

// ✅ GOOD: Copy to release original
func getFirst10(data []byte) []byte {
    result := make([]byte, 10)
    copy(result, data[:10])
    return result
}
```

### Use sync.Pool for Temporary Objects

```go
var bufferPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 0, 4096)
    },
}

func process(data []byte) []byte {
    buf := bufferPool.Get().([]byte)
    defer func() {
        buf = buf[:0]  // Reset length
        bufferPool.Put(buf)
    }()

    buf = append(buf, data...)
    return buf
}
```

### Avoid Interface Boxing for Hot Paths

```go
// ❌ BAD: Interface allocation
func process(v interface{}) { ... }

// ✅ GOOD: Concrete type
func process(v int) { ... }

// ✅ GOOD: Generics (Go 1.18+)
func process[T any](v T) { ... }
```

---

## String Optimization

### Use strings.Builder for Concatenation

```go
// ❌ BAD: Creates new string each time
var result string
for _, s := range items {
    result += s
}

// ✅ GOOD: Efficient building
var builder strings.Builder
builder.Grow(1000)  // Preallocate if size known
for _, s := range items {
    builder.WriteString(s)
}
result := builder.String()
```

### Avoid Unnecessary String Conversions

```go
// ❌ BAD: Converts to string just for logging
log.Printf("data: %s", string(data))

// ✅ GOOD: Use %q or pass bytes directly
log.Printf("data: %q", data)
```

---

## Goroutine Optimization

### Use Worker Pools

```go
// ❌ BAD: Unbounded goroutines
for _, item := range items {
    go process(item)  // 10,000 items = 10,000 goroutines
}

// ✅ GOOD: Bounded worker pool
jobs := make(chan Item, 100)
var wg sync.WaitGroup

// Fixed number of workers
for i := 0; i < runtime.NumCPU(); i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        for item := range jobs {
            process(item)
        }
    }()
}

for _, item := range items {
    jobs <- item
}
close(jobs)
wg.Wait()
```

### Use errgroup with Limit

```go
g, ctx := errgroup.WithContext(ctx)
g.SetLimit(10)  // Max 10 concurrent

for _, item := range items {
    item := item
    g.Go(func() error {
        return process(ctx, item)
    })
}

err := g.Wait()
```

---

## I/O Optimization

### Buffer Reads and Writes

```go
// ❌ BAD: Unbuffered
file, _ := os.Open("file.txt")
data, _ := io.ReadAll(file)

// ✅ GOOD: Buffered reader
file, _ := os.Open("file.txt")
reader := bufio.NewReader(file)
data, _ := io.ReadAll(reader)
```

### Reuse HTTP Clients

```go
// ❌ BAD: New client per request
func fetch(url string) {
    client := &http.Client{}
    client.Get(url)
}

// ✅ GOOD: Shared client
var client = &http.Client{
    Transport: &http.Transport{
        MaxIdleConns:        100,
        MaxIdleConnsPerHost: 10,
        IdleConnTimeout:     90 * time.Second,
    },
}

func fetch(url string) {
    client.Get(url)
}
```

---

## Profiling Tools

### CPU Profiling

```go
import "runtime/pprof"

f, _ := os.Create("cpu.prof")
pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()

// ... code to profile ...

// Analyze: go tool pprof cpu.prof
```

### Memory Profiling

```go
import "runtime/pprof"

// After the work
f, _ := os.Create("mem.prof")
pprof.WriteHeapProfile(f)
f.Close()

// Analyze: go tool pprof mem.prof
```

### Built-in HTTP Profiler

```go
import _ "net/http/pprof"

// Add to main:
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()

// Access:
// http://localhost:6060/debug/pprof/
```

---

## Benchmarking

### Write Benchmarks

```go
func BenchmarkProcess(b *testing.B) {
    data := makeTestData()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        process(data)
    }
}

func BenchmarkProcessParallel(b *testing.B) {
    data := makeTestData()
    b.ResetTimer()

    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            process(data)
        }
    })
}
```

### Run Benchmarks

```bash
# Basic benchmark
go test -bench=. -benchmem

# Compare before/after
go test -bench=. -benchmem -count=10 > old.txt
# (make changes)
go test -bench=. -benchmem -count=10 > new.txt
benchstat old.txt new.txt
```

---

## Common Bottlenecks

| Issue | Detection | Solution |
|-------|-----------|----------|
| GC pressure | heap profile | Reduce allocations, use pools |
| Lock contention | mutex profile | Reduce critical section, shard |
| Slow I/O | trace | Buffer, batch, async |
| CPU bound | CPU profile | Optimize hot paths |
| Memory leak | heap grows | Find and fix retain |

---

## Optimization Checklist

```
Before optimizing:
[ ] Have I measured the bottleneck?
[ ] Is this actually a problem?
[ ] Do I have benchmarks?

Memory:
[ ] Preallocate slices?
[ ] Use sync.Pool for temp objects?
[ ] Avoid slice memory leaks?
[ ] Reduce interface boxing?

Strings:
[ ] Use strings.Builder?
[ ] Avoid unnecessary conversions?

Goroutines:
[ ] Using worker pools?
[ ] Limited concurrency?

I/O:
[ ] Buffered reads/writes?
[ ] Reusing connections?
[ ] Batching operations?
```

---

## Quick Reference

```
Measure:     go tool pprof
Benchmark:   go test -bench=. -benchmem
Trace:       go test -trace trace.out
Compare:     benchstat old.txt new.txt

Memory:      sync.Pool, preallocate, copy slices
Strings:     strings.Builder, avoid conversions
Goroutines:  worker pool, errgroup.SetLimit
I/O:         bufio, connection pooling
```

---

*Knowledge Forge: Domains/Go Layer*
*Dependencies: go/fundamentals, go/concurrency*
