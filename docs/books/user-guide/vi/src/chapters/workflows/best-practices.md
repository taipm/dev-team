# Best Practices

Các practices tốt nhất khi sử dụng dev-team.

## 1. Chọn Đúng Tool

| Situation | Use |
|-----------|-----|
| Simple task | Agent |
| Complex problem | Team |
| Dialogue needed | Session Team |
| Deep analysis | Deep Thinking |

## 2. Provide Good Context

### ❌ Bad

```
Fix bug
```

### ✅ Good

```
Bug: Login fails intermittently
- Occurs 5% of requests
- Started after yesterday's deploy
- Error: "session expired"
- Logs: [attach relevant logs]
```

## 3. Be Specific About Goals

### ❌ Vague

```
Improve performance
```

### ✅ Specific

```
Reduce API response time from 2s to <200ms
for /api/orders endpoint under 100 concurrent users
```

## 4. Engage in Dialogue

Agents và Teams làm việc tốt hơn khi bạn:
- Trả lời câu hỏi
- Provide additional context
- Clarify khi được hỏi
- Give feedback on suggestions

## 5. Use Observer Commands

Trong team sessions:

```
*status      # Know where you are
*focus X     # Get specific expertise
*summarize   # Get overview
```

## 6. Start Small, Then Scale

### Refactoring
```
Bắt đầu với 1 file → cả package
```

### Design
```
Bắt đầu với MVP → full system
```

### Testing
```
Bắt đầu với happy path → edge cases
```

## 7. Document Decisions

Khi dùng dev-architect-session:
- Request ADRs
- Save output to project docs
- Share với team

## 8. Iterate

Không cần perfect lần đầu:
1. First pass: rough draft
2. Second pass: refine
3. Third pass: polish

## 9. Combine Tools

Ví dụ workflow:
1. `/microai:deep-thinking` → understand problem
2. `/microai:dev-architect-session` → design solution
3. `/microai:go:go-dev` → implement
4. `/microai:dev-qa-session` → review

## 10. Learn From Output

Review output của agents:
- Patterns họ suggest
- Questions họ ask
- Trade-offs họ identify

Áp dụng cho lần sau.

## Anti-Patterns

### ❌ Tool Overuse

```
Dùng Deep Thinking Team cho simple bug
→ Overkill, dùng agent đơn
```

### ❌ No Context

```
Gọi agent mà không cho context
→ Output generic, không useful
```

### ❌ Ignore Questions

```
Agent hỏi nhưng bạn skip
→ Output thiếu accuracy
```

### ❌ No Follow-up

```
Nhận output nhưng không implement/iterate
→ Wasted effort
```

## Xem Thêm

- [Troubleshooting](./troubleshooting.md)
- [Use Cases](./use-cases.md)
