---
id: M-1
name: Complex Dependency Chain
category: Reasoning
difficulty: 3
points: 5
keywords:
  - DB
  - Database
  - Cache
  - Auth
  - Product
  - Gateway
order_matters: true
---

# Complex Dependency Chain

## Prompt

<prompt>
Service dependencies:
- API Gateway → Auth Service → User DB
- API Gateway → Product Service → Product DB
- Product Service → Cache Service
- Auth Service → Cache Service

In what order should services start for a clean boot sequence?
</prompt>

## Expected Behavior

The answer should:
1. Identify leaf nodes (DBs) must start first
2. Recognize shared dependency (Cache)
3. Determine correct topological order
4. Optionally identify parallel opportunities

## Correct Order

```
1. User DB, Product DB (can be parallel - no dependencies)
2. Cache Service (needed by Auth and Product)
3. Auth Service, Product Service (can be parallel after their deps)
4. API Gateway (last - depends on Auth and Product)
```

## Rubric

| Score | Criteria |
|-------|----------|
| 5 pts | Correct order with parallel opportunities identified |
| 4 pts | Correct sequential order |
| 3 pts | Mostly correct with 1 error |
| 2 pts | Understands concept but wrong order |
| 1 pt  | Identifies some dependencies only |
| 0 pts | Completely wrong or doesn't attempt |

## Good Answer Example

```
Boot sequence (dependencies must start before dependents):

1. User DB, Product DB (parallel - leaf nodes)
2. Cache Service (needed by both Auth and Product)
3. Auth Service (needs User DB + Cache)
   Product Service (needs Product DB + Cache) [parallel with Auth]
4. API Gateway (last - needs Auth + Product)

Key insight: Cache must be up before Auth and Product since both depend on it.
```

## Why This Test

- Multi-step reasoning with graph traversal
- Tests ability to identify shared dependencies
- Requires understanding of topological sort concept
- Local models often miss the Cache dependency
