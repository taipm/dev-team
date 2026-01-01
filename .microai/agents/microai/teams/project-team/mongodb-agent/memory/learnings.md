# MongoDB Agent Learnings

> Patterns discovered from working with database module.

---

## Index Optimization

### Pattern: Compound Index Field Order

**Observation**: Field order in compound indexes matters for query performance.

**Solution**: Put equality fields first, range fields last.

**Example**:
```go
// Good: equality (user_id) first, range (created_at) last
{Key: "user_id", Value: 1},
{Key: "created_at", Value: -1},
```

**Anti-pattern**:
```go
// ❌ Range field first - won't use index efficiently
{Key: "created_at", Value: -1},
{Key: "user_id", Value: 1},
```

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| Compound Field Order | Index | Range queries with filters |

---
