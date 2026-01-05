---
id: X-1
name: Distributed Rate Limiter Design
category: System Design
difficulty: 8
points: 10
keywords:
  - Redis
  - sliding window
  - token bucket
  - local cache
  - consistency
  - CAP
  - partition
  - latency
reasoning_required: true
---

# Distributed Rate Limiter Design

## Prompt

<prompt>
Design a distributed rate limiter that:
1. Works across multiple API gateway instances
2. Supports both per-user and global rate limits
3. Handles network partitions gracefully
4. Has sub-millisecond latency for most requests

Describe the architecture, data structures, and trade-offs.
</prompt>

## Expected Behavior

A strong answer should cover:
1. **Algorithm choice** - Token bucket, sliding window, etc.
2. **Distributed storage** - Redis, in-memory with sync
3. **Consistency model** - Eventual vs strong
4. **Partition handling** - What happens when Redis is unreachable
5. **Latency optimization** - Local caching strategy
6. **Trade-offs** - CAP theorem application

## Rubric

| Score | Criteria |
|-------|----------|
| 10 pts | Comprehensive design addressing ALL requirements with trade-off analysis |
| 8-9 pts | Solid design covering most requirements |
| 6-7 pts | Basic distributed design with gaps |
| 4-5 pts | Understands problem, incomplete solution |
| 2-3 pts | Single-node solution only |
| 0-1 pts | Doesn't understand requirements |

## Good Answer Example

```
DISTRIBUTED RATE LIMITER DESIGN

## Algorithm: Sliding Window Log with Local Cache

### Architecture:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ API Gateway │     │ API Gateway │     │ API Gateway │
│   + Local   │     │   + Local   │     │   + Local   │
│    Cache    │     │    Cache    │     │    Cache    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌──────┴──────┐
                    │ Redis Cluster│
                    │  (Primary)   │
                    └─────────────┘

### Data Structures:
1. Per-user: Redis Sorted Set
   Key: rate_limit:user:{user_id}
   Score: timestamp
   Member: request_id

2. Global: Redis String with atomic INCR
   Key: rate_limit:global:{window}

### Request Flow:
1. Check local cache first (sub-ms)
2. If not in cache or near limit, check Redis
3. Update Redis asynchronously when possible
4. Local cache TTL = rate_limit_window / 10

### Handling Requirements:

1. MULTIPLE INSTANCES
   - All instances share Redis
   - Local cache prevents Redis hot spots
   - Eventual consistency acceptable for rate limiting

2. PER-USER + GLOBAL
   - Per-user: ZADD + ZCOUNT in Redis
   - Global: INCR atomic counter
   - Check both, reject if either exceeded

3. NETWORK PARTITIONS (CAP Trade-off)
   Option A: Fail Open (Availability)
   - If Redis unreachable, allow requests
   - Risk: Exceed rate limit during partition
   - Better for non-critical rate limits

   Option B: Fail Closed (Consistency)
   - If Redis unreachable, reject requests
   - Risk: False rejections during partition
   - Better for security-critical limits

   Option C: Hybrid (Recommended)
   - Local limit = global_limit / instance_count * 1.5
   - During partition, use local-only limiting
   - Allows some requests, prevents total flood

4. SUB-MS LATENCY
   - Local cache serves 90%+ of requests
   - Redis used only near limit threshold
   - Async Redis writes don't block requests
   - Use Redis pipeline for batch operations

### Trade-offs:

| Aspect | Choice | Trade-off |
|--------|--------|-----------|
| Consistency | Eventual | May briefly exceed limit |
| Availability | High | Partition-tolerant |
| Accuracy | ~95% | Some over/under count |
| Latency | <1ms p99 | Local cache required |

### Lua Script for Atomic Check:
```lua
local key = KEYS[1]
local limit = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local now = tonumber(ARGV[3])

redis.call('ZREMRANGEBYSCORE', key, 0, now - window)
local count = redis.call('ZCARD', key)

if count < limit then
    redis.call('ZADD', key, now, now .. ':' .. math.random())
    redis.call('EXPIRE', key, window)
    return 1
end
return 0
```

This balances all requirements while accepting that perfect accuracy
is impossible in a distributed system.
```

## Why This Test

- Tests system design at scale
- Requires understanding CAP theorem
- Multiple valid approaches exist
- Trade-off analysis is essential
- Differentiates deep thinkers from surface-level answers
