# Agentic Agent Learnings

> Patterns discovered from working with agentic module.

---

## Budget Management

### Pattern: SSOT for Pricing

**Observation**: All pricing must come from pricing.go

**Solution**: Always use `GetModelPricing()` and `CalculateCost()`

**Example**:
```go
// Good pattern
cost := agentic.CalculateCost(inputTokens, outputTokens, model)
```

**Anti-pattern**:
```go
// ❌ Never hardcode prices
cost := float64(tokens) * 0.15 / 1_000_000
```

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| SSOT Pricing | Budget | Always for cost calculations |

---
