# Agent Là Gì?

Giải thích chi tiết về khái niệm Agent trong dev-team.

## Định Nghĩa

**Agent** là một AI assistant được cấu hình chuyên biệt để thực hiện các tác vụ cụ thể. Mỗi agent có:

- **Persona**: Vai trò và phong cách giao tiếp
- **Knowledge**: Kiến thức chuyên môn
- **Tools**: Công cụ được phép sử dụng
- **Memory**: Khả năng nhớ qua các session

## Cấu Trúc Agent

```
agent-name/
├── agent.md           # Định nghĩa agent
├── knowledge/         # Kiến thức chuyên môn
│   ├── 01-topic.md
│   └── knowledge-index.yaml
└── memory/            # Bộ nhớ
    ├── context.md
    ├── decisions.md
    └── learnings.md
```

## File agent.md

```yaml
---
name: my-agent
description: |
  Mô tả agent. Sử dụng khi:
  - Use case 1
  - Use case 2

model: opus
tools: [Read, Write, Edit, Bash, Glob, Grep]
language: vi
---

# Agent Content

Hướng dẫn cho agent...
```

## So Sánh Agent vs Plain Claude

| Khía Cạnh | Plain Claude | Agent |
|-----------|--------------|-------|
| Kiến thức | Tổng quát | Chuyên sâu domain |
| Context | Bắt đầu từ đầu | Có sẵn context |
| Workflow | Tổng quát | Quy trình cụ thể |
| Memory | Không | Có hệ thống memory |

## Khi Nào Dùng Agent?

### Nên dùng Agent khi:

- Cần chuyên gia trong một lĩnh vực
- Muốn quy trình nhất quán
- Có context phức tạp cần duy trì
- Công việc lặp lại thường xuyên

### Dùng Plain Claude khi:

- Câu hỏi đơn giản, nhanh
- Không cần chuyên môn đặc biệt
- Một lần, không lặp lại

## Xem Thêm

- [Cách Gọi Agent](./invoking-agents.md)
- [Agents Có Sẵn](./built-in-agents.md)
