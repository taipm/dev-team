# Go Review Linus Agent - Learnings

> Patterns and insights discovered during reviews.

---

## Common Issues Found

| Issue | Frequency | Typical Fix |
|-------|-----------|-------------|
| Missing error check | High | Add explicit error handling |
| Hardcoded credentials | Medium | Use environment variables |
| Data race on map | Medium | Use sync.RWMutex or sync.Map |
| Magic numbers | High | Extract to named constants |

---

## Anti-patterns Encountered

| Anti-pattern | Why Bad | Better Approach |
|--------------|---------|-----------------|
| `_ = someFunc()` | Swallows errors | Handle or log explicitly |
| `go func()` without sync | Goroutine leak | Use WaitGroup or context |
| String concat in loop | O(n²) memory | Use strings.Builder |

---

## Good Patterns Observed

| Pattern | Context | Note |
|---------|---------|------|
| Error wrapping | All error returns | `fmt.Errorf("context: %w", err)` |
| Context propagation | HTTP handlers | Pass ctx to all downstream calls |
| Defer for cleanup | Resource management | `defer f.Close()` |

---

## Review Insights

*Capture insights from code reviews here*

---

*Last updated: 2026-01-03*
