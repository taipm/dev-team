# Cách Gọi Agent

Hướng dẫn các cách kích hoạt agent.

## Cách 1: Slash Command (Khuyến nghị)

```
/microai:agent-name
```

Ví dụ:
```
/microai:npm
/microai:deep-question
/microai:go:go-dev
```

## Cách 2: Tự Động Qua Task Tool

Khi bạn yêu cầu một tác vụ, Claude Code có thể tự động chọn agent phù hợp thông qua Task tool.

Ví dụ:
```
Refactor file handler.go theo best practices
```

Claude Code có thể tự động kích hoạt `go-refactor-portable` agent.

## Cách 3: Manual Activation

Yêu cầu Claude đọc và thực thi agent:

```
Đọc và thực thi agent tại @.microai/agents/npm-agent/agent.md
```

## Quy Tắc Đặt Tên Command

| Pattern | Ví dụ | Mô tả |
|---------|-------|-------|
| `/microai:name` | `/microai:npm` | Agent đơn |
| `/microai:group:name` | `/microai:go:go-dev` | Agent trong nhóm |

## Xác Nhận Agent Đã Kích Hoạt

Khi agent kích hoạt thành công:

1. Bạn sẽ thấy lời chào từ agent
2. Agent tự giới thiệu vai trò
3. Agent hỏi về nhu cầu của bạn

Ví dụ output:

```
🎯 Deep Question Agent đã sẵn sàng!

Tôi sử dụng 7 phương pháp tư duy để đặt câu hỏi sâu.
Bạn muốn khám phá vấn đề gì hôm nay?
```

## Tips

### Chọn đúng Agent

- Đọc description trong command list
- Test với vấn đề nhỏ trước
- Nếu không chắc, dùng `/help`

### Cung cấp Context

```
Tôi đang làm dự án microservices bằng Go.
Cần refactor hàm processOrder để xử lý concurrent.
```

## Xem Thêm

- [Agents Có Sẵn](./built-in-agents.md)
- [Agent Gallery](./gallery.md)
