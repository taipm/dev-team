---
id: X-3
name: Advanced Cache Design
category: Concurrency
difficulty: 9
points: 7
keywords:
  - RWMutex
  - singleflight
  - LRU
  - TTL
  - thundering herd
  - eviction
  - concurrent
reasoning_required: true
---

# Advanced Cache Design

## Prompt

<prompt>
Design a cache that:
1. Allows concurrent reads
2. Exclusive writes (readers blocked during write)
3. Prevents thundering herd on cache miss
4. Has bounded memory with LRU eviction
5. Supports TTL expiration

Outline the synchronization strategy and potential pitfalls.
</prompt>

## Expected Behavior

A strong answer should address:
1. **RWMutex** for concurrent reads, exclusive writes
2. **singleflight** or similar for thundering herd
3. **LRU** implementation (container/list + map)
4. **TTL** checking strategy (lazy vs active)
5. **Pitfalls** - lock contention, memory leaks, etc.

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Complete design addressing all 5 requirements with pitfall analysis |
| 5-6 pts | Addresses most requirements |
| 3-4 pts | Basic cache design, misses advanced requirements |
| 1-2 pts | Simple mutex-based cache only |
| 0 pts | Doesn't understand concurrency requirements |

## Good Answer Example

```
ADVANCED CONCURRENT CACHE DESIGN

## Data Structures

```go
type Cache struct {
    mu       sync.RWMutex
    items    map[string]*cacheItem
    lruList  *list.List              // For LRU eviction
    lruMap   map[string]*list.Element // Fast LRU lookup
    maxSize  int
    flight   singleflight.Group      // Prevent thundering herd

    // For TTL cleanup
    cleanupInterval time.Duration
    stopCleanup     chan struct{}
}

type cacheItem struct {
    value      interface{}
    expiration time.Time
    size       int
}
```

## Core Operations

### Get (Concurrent Reads)
```go
func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.RLock()
    item, exists := c.items[key]
    c.mu.RUnlock()

    if !exists {
        return nil, false
    }

    // Check TTL (lazy expiration)
    if time.Now().After(item.expiration) {
        c.Delete(key) // Async delete expired
        return nil, false
    }

    // Update LRU position (requires write lock)
    c.mu.Lock()
    c.updateLRU(key)
    c.mu.Unlock()

    return item.value, true
}
```

### GetOrLoad (Thundering Herd Prevention)
```go
func (c *Cache) GetOrLoad(key string, loader func() (interface{}, error)) (interface{}, error) {
    // First check cache
    if val, ok := c.Get(key); ok {
        return val, nil
    }

    // Use singleflight to prevent thundering herd
    // Only ONE goroutine will call loader, others wait
    val, err, _ := c.flight.Do(key, func() (interface{}, error) {
        // Double-check after acquiring flight
        if val, ok := c.Get(key); ok {
            return val, nil
        }

        // Load from source
        val, err := loader()
        if err != nil {
            return nil, err
        }

        // Store in cache
        c.Set(key, val, time.Hour)
        return val, nil
    })

    return val, err
}
```

### Set (Exclusive Write with LRU Eviction)
```go
func (c *Cache) Set(key string, value interface{}, ttl time.Duration) {
    c.mu.Lock()
    defer c.mu.Unlock()

    // Evict if necessary
    for len(c.items) >= c.maxSize {
        c.evictOldest()
    }

    item := &cacheItem{
        value:      value,
        expiration: time.Now().Add(ttl),
    }

    c.items[key] = item
    c.addToLRU(key)
}
```

### LRU Eviction
```go
func (c *Cache) evictOldest() {
    // Get oldest (back of list)
    elem := c.lruList.Back()
    if elem == nil {
        return
    }

    key := elem.Value.(string)
    c.lruList.Remove(elem)
    delete(c.lruMap, key)
    delete(c.items, key)
}

func (c *Cache) updateLRU(key string) {
    if elem, ok := c.lruMap[key]; ok {
        c.lruList.MoveToFront(elem)
    }
}
```

### TTL Cleanup (Background Goroutine)
```go
func (c *Cache) startCleanup() {
    ticker := time.NewTicker(c.cleanupInterval)
    go func() {
        for {
            select {
            case <-ticker.C:
                c.deleteExpired()
            case <-c.stopCleanup:
                ticker.Stop()
                return
            }
        }
    }()
}

func (c *Cache) deleteExpired() {
    c.mu.Lock()
    defer c.mu.Unlock()

    now := time.Now()
    for key, item := range c.items {
        if now.After(item.expiration) {
            c.removeItem(key)
        }
    }
}
```

## Synchronization Summary

| Operation | Lock Type | Reason |
|-----------|-----------|--------|
| Get (cache hit) | RLock | Multiple concurrent reads |
| Get (update LRU) | Lock | Modify LRU list |
| Set | Lock | Modify map + LRU |
| Delete | Lock | Modify map + LRU |
| Cleanup | Lock | Batch modifications |
| singleflight.Do | Internal | Coordinates loaders |

## Potential Pitfalls

1. **LRU Lock Contention**
   Problem: Every Get() needs Lock for LRU update
   Solution: Sample-based LRU (update 1 in N gets) or per-shard LRU

2. **Memory Leaks**
   Problem: TTL cleanup runs infrequently, items accumulate
   Solution: Size-based eviction + active TTL cleanup

3. **Singleflight Key Explosion**
   Problem: flight.Do stores keys indefinitely
   Solution: singleflight auto-cleans after call completes

4. **Lock Inversion**
   Problem: Calling external loader while holding lock
   Solution: singleflight runs loader WITHOUT cache lock

5. **Stale Reads**
   Problem: RLock allows reading during cleanup
   Solution: Check TTL in Get(), accept occasional stale read

## Requirements Checklist

| Requirement | Solution |
|-------------|----------|
| Concurrent reads | sync.RWMutex.RLock() |
| Exclusive writes | sync.RWMutex.Lock() |
| Thundering herd | singleflight.Group |
| Bounded memory | LRU eviction on Set() |
| TTL expiration | Lazy check + background cleanup |
```

## Why This Test

- Requires deep concurrency knowledge
- Multiple Go primitives working together
- Trade-off analysis essential
- Pitfalls show real-world experience
- Separates theoretical from practical knowledge
