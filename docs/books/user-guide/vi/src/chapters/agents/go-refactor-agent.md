# go-refactor-portable - Refactor Go Code

Agent chuyên gia refactoring Go code.

## Tổng Quan

**go-refactor-portable** giúp:
- Refactor code an toàn với risk assessment
- Batch refactoring với 5W2H analysis
- Auto-generate refactoring reports
- Maintain backward compatibility

## Kích Hoạt

```
/microai:go:go-refactor
```

## Capabilities

### 1. Risk-Based Refactoring

```
Refactor UserService với phân tích rủi ro
```

Agent sẽ:
- Phân loại thay đổi theo risk level
- Đề xuất thứ tự refactor an toàn
- Tạo rollback plan

### 2. 5W2H Analysis

```
Phân tích 5W2H trước khi refactor module auth
```

- **What**: Refactor gì?
- **Why**: Tại sao cần refactor?
- **Where**: Ở đâu trong codebase?
- **When**: Khi nào nên làm?
- **Who**: Ai bị ảnh hưởng?
- **How**: Refactor như thế nào?
- **How much**: Chi phí/effort?

### 3. Batch Refactoring

```
Batch refactor tất cả handlers để dùng new error handling
```

### 4. Auto-Report

Agent tự động tạo report sau mỗi refactoring session.

## Ví Dụ Session

```
You: /microai:go:go-refactor

go-refactor: 🔧 Go Refactor Agent sẵn sàng!

Tôi sử dụng risk-based approach với 5W2H analysis.
Bạn muốn refactor gì?

You: Refactor error handling trong handlers/

go-refactor: 📊 **Risk Assessment**:

| File | Changes | Risk | Priority |
|------|---------|------|----------|
| user_handler.go | 12 | Medium | 1 |
| order_handler.go | 8 | Low | 2 |
| payment_handler.go | 15 | High | 3 |

**Đề xuất thứ tự**:
1. order_handler.go (Low risk, làm trước)
2. user_handler.go (Medium risk)
3. payment_handler.go (High risk, cần review)

Bắt đầu với order_handler.go?
```

## Refactoring Patterns

- Extract Method/Function
- Rename with scope awareness
- Dependency Injection
- Interface Segregation
- Error Wrapping

## Xem Thêm

- [go-dev-portable](./go-dev-agent.md)
- [Refactor Code Workflow](../workflows/refactoring.md)
