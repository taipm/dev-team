# Refactor Code

Workflow refactoring code an toàn.

## Agent: go-refactor-portable

Kích hoạt:
```
/microai:go:go-refactor
```

## Workflow

### Bước 1: Identify Target

```
Refactor package handlers/
Focus: Error handling consistency
```

### Bước 2: Risk Assessment

Agent sẽ analyze và trả về:

```markdown
## Risk Assessment

| File | Changes | Risk | Priority |
|------|---------|------|----------|
| user.go | 15 | Medium | 1 |
| order.go | 8 | Low | 2 |
| payment.go | 22 | High | 3 |

### Recommendation
Start with order.go (low risk)
```

### Bước 3: 5W2H Analysis

```markdown
## 5W2H Analysis

### What: Refactor error handling
### Why: Inconsistent patterns, poor debugging
### Where: handlers/ package
### When: Now - low traffic period
### Who: Affects all API consumers
### How: Wrap errors with context, standardize format
### How much: ~3 hours, medium complexity
```

### Bước 4: Execute Refactoring

Agent thực hiện theo batches:

```
Batch 1: order.go (Low risk)
- Wrap errors with fmt.Errorf
- Add context to error messages
- Standardize error responses

Batch 2: user.go (Medium risk)
- Same patterns
- Additional validation checks

Batch 3: payment.go (High risk)
- Careful review after each change
- Run tests between changes
```

### Bước 5: Generate Report

```markdown
# Refactoring Report

## Summary
- Files modified: 3
- Lines changed: 45
- Tests passing: ✅

## Changes

### order.go
- Wrapped 8 errors with context
- Added 2 validation checks

### user.go
- Wrapped 12 errors
- Fixed 1 potential nil pointer

### payment.go
- Wrapped 18 errors
- Extracted error messages to constants

## Before/After

### Before
```go
if err != nil {
    return err
}
```

### After
```go
if err != nil {
    return fmt.Errorf("process order %d: %w", orderID, err)
}
```

## Rollback Plan
git revert [commit-hash]
```

## Tips

### Start Small

```
Bắt đầu với 1 file thay vì cả package
```

### Test Between Changes

```
Sau mỗi file, chạy tests:
go test ./handlers/...
```

### Use Version Control

```
Commit sau mỗi batch để dễ rollback
```

### Document Decisions

```
Ghi lại lý do cho mỗi pattern change
```

## Common Refactoring Patterns

| Pattern | When to Use |
|---------|-------------|
| Extract Method | Logic lặp lại |
| Rename | Naming không rõ ràng |
| Inline | Abstraction không cần thiết |
| Move | Wrong package/file |

## Xem Thêm

- [go-refactor-portable](../agents/go-refactor-agent.md)
- [Best Practices](./best-practices.md)
