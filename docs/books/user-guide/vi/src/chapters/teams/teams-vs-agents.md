# Team vs Agent Đơn Lẻ

So sánh chi tiết giữa Team và Agent đơn.

## Comparison Matrix

| Tiêu chí | Agent Đơn | Team |
|----------|-----------|------|
| Response time | Nhanh | Chậm hơn |
| Depth | Sâu 1 domain | Rộng nhiều domains |
| Coordination | Không | Có |
| Memory | Agent memory | Team memory + Agent memory |
| Use case | Specific tasks | Complex problems |

## Khi Nào Chọn Agent?

### ✅ Chọn Agent khi:

```
- Tác vụ đơn giản, rõ ràng
- Một domain chuyên môn
- Cần kết quả nhanh
- Không cần nhiều góc nhìn
```

### Ví dụ:

- Refactor một function
- Fix một bug cụ thể
- Viết unit tests
- Generate documentation

## Khi Nào Chọn Team?

### ✅ Chọn Team khi:

```
- Vấn đề phức tạp, nhiều khía cạnh
- Cần phân tích từ nhiều góc độ
- Quyết định quan trọng
- Cần output toàn diện
```

### Ví dụ:

- Design system architecture
- Review security toàn diện
- Giải quyết vấn đề khó
- Tạo technical specification

## Decision Flow

```
                    ┌─────────────────┐
                    │ Vấn đề của bạn  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Phức tạp?       │
                    │ Nhiều domains?  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
         │ Không   │    │ Có thể  │    │ Có      │
         │         │    │         │    │         │
         │ Agent   │    │ Agent + │    │ Team    │
         │ đơn     │    │ consult │    │         │
         └─────────┘    └─────────┘    └─────────┘
```

## Hybrid Approach

Đôi khi bạn có thể:

1. **Bắt đầu với Agent** → nếu phức tạp → **chuyển sang Team**
2. **Dùng Team** → khi có kết quả → **dùng Agent để implement**

## Ví Dụ Thực Tế

### Scenario 1: Fix Bug

```
Bug: API trả về 500

→ Dùng: go-dev-portable agent
→ Lý do: Một domain, cần fix nhanh
```

### Scenario 2: Design Authentication System

```
Task: Thiết kế hệ thống authentication

→ Dùng: dev-architect-session team
→ Lý do: Cần xem xét security, scalability, UX
```

## Xem Thêm

- [Team Là Gì?](./what-is-team.md)
- [Cách Gọi Team](./invoking-teams.md)
