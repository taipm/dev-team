# Backend Lead Learnings

> Patterns discovered from orchestrating the team.

---

## Dispatch Patterns

### Pattern: Parallel Investigation

**Observation**: Khi investigate issues, nên dispatch parallel cho tốc độ.

**Example**:
```
// Good: Parallel investigation
Task(agentic-agent, "Check timeout settings", background)
Task(hpsm-agent, "Profile API latency", background)
Task(mongodb-agent, "Check query performance", background)
// Wait for all, then synthesize
```

**Anti-pattern**:
```
// Bad: Sequential investigation (slow)
result1 = Task(agentic-agent, ...)
result2 = Task(hpsm-agent, ...)
result3 = Task(mongodb-agent, ...)
```

---

## Synthesis Patterns

(To be added as patterns emerge)

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| Parallel Investigation | Dispatch | Multi-domain issues |

---
