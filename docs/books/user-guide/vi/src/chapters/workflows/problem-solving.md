# Giải Quyết Vấn Đề Phức Tạp

Workflow giải quyết vấn đề với Deep Thinking Team.

## Khi Nào Sử Dụng

- Bug lặp lại, không rõ root cause
- Quyết định architecture quan trọng
- Vấn đề không có solution rõ ràng
- Cần nhiều perspectives

## Kích Hoạt

```
/microai:deep-thinking
```

## Workflow: 5-Phase Protocol

### Phase 1: UNDERSTAND (Socrates)

**Input của bạn**:
```
Hệ thống chậm khi có >100 concurrent users.
Đã thử optimize queries nhưng không đủ.
```

**Socrates hỏi**:
- Chậm ở component nào?
- Metrics cụ thể?
- Đã thử gì rồi?
- Constraints là gì?

### Phase 2: ANALYZE (Aristotle, Feynman)

**Aristotle phân tích**:
```
Possible causes:
├── Database
│   ├── Query optimization
│   ├── Connection pool
│   └── Lock contention
├── Application
│   ├── Memory leaks
│   ├── Blocking operations
│   └── N+1 queries
└── Infrastructure
    ├── Network latency
    ├── Resource limits
    └── Load balancing
```

**Feynman giải thích**:
```
Hãy tưởng tượng như nhà hàng:
- 100 khách = 100 concurrent users
- Bếp (DB) xử lý không kịp
- Hoặc bồi bàn (app server) bận
- Hoặc cửa vào (load balancer) bottleneck
```

### Phase 3: EXPLORE (Musk, Da Vinci)

**Musk challenge**:
```
Forget current architecture.
If rebuilding from scratch:
- Do we need a database at all?
- Can we cache 90% of requests?
- What if we went edge computing?
```

**Da Vinci connect**:
```
Patterns from other domains:
- CDN model for data distribution
- Circuit breaker from electrical
- Back-pressure from hydraulics
```

### Phase 4: SYNTHESIZE (Munger, Polya)

**Munger inversion**:
```
Làm sao để HỆ THỐNG CÒN CHẬM HƠN?
- Single thread processing
- No caching
- Synchronous everywhere

→ Ngược lại: Multi-thread, cache, async
```

**Polya systematic**:
```
Solution Plan:
1. Add Redis cache for hot data
2. Implement connection pooling
3. Add async processing for non-critical
4. Add circuit breaker for stability

Verification:
- Load test each change
- Monitor metrics
- Rollback plan ready
```

### Phase 5: VALIDATE (All Titans)

**Final Output**:
```markdown
# Solution: Performance Optimization

## Root Cause
Database connection exhaustion under load
+ Synchronous processing bottleneck

## Solution
1. Redis cache (reduce DB load 70%)
2. Connection pool tuning (10→50)
3. Async queue for notifications
4. Circuit breaker for external APIs

## Implementation Order
1. [Low risk] Connection pool
2. [Medium] Redis cache
3. [Medium] Async queue
4. [Low] Circuit breaker

## Expected Improvement
- Response time: 2s → 200ms
- Capacity: 100 → 1000 concurrent users

## Risks
- Redis single point of failure
  → Mitigation: Redis cluster

## Timeline
- Week 1: Pool + Cache
- Week 2: Async + Breaker
- Week 3: Load testing
```

## Tips

### Describe Problem Well

```
❌ "Hệ thống chậm"

✅ "Hệ thống chậm (2s response) khi >100 users.
    Metrics: CPU 30%, Memory 60%, DB connections maxed.
    Đã thử: Query optimization, increased memory."
```

### Engage With Questions

Trả lời câu hỏi của Titans để họ hiểu rõ hơn.

### Use Observer Commands

```
*focus Feynman   # Cần giải thích đơn giản
*focus Musk      # Cần challenge assumptions
*status          # Xem đang ở phase nào
```

## Xem Thêm

- [Deep Thinking Team](../teams/deep-thinking-team.md)
- [7 Titans](../teams/deep-thinking/titans.md)
