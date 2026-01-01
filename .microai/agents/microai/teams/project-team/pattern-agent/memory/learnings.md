# Pattern Agent Learnings

> Patterns discovered from working with pattern module.

---

## Hot Reload

### Pattern: Debounce File Changes

**Observation**: File saves can trigger multiple events.

**Solution**: Debounce reload to wait for file stabilization.

**Example**:
```go
// Good: Wait before reloading
time.Sleep(100 * time.Millisecond)
catalog.ReloadPattern(path)
```

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| Debounce Reload | Hot Reload | File change events |
