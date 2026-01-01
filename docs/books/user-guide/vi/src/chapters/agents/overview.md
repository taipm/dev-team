# Tổng Quan Agent

Giới thiệu về hệ thống Agent trong dev-team framework.

## Agent Là Gì?

**Agent** là một AI assistant chuyên biệt được cấu hình để thực hiện các nhiệm vụ cụ thể. Mỗi agent có:

- **Persona**: Vai trò và cách giao tiếp riêng
- **Knowledge**: Kiến thức chuyên môn về lĩnh vực
- **Tools**: Các công cụ được phép sử dụng
- **Memory**: Khả năng ghi nhớ qua các phiên làm việc

## Tại Sao Dùng Agent?

### So sánh với Claude thuần

| Khía cạnh | Claude thuần | Agent |
|-----------|--------------|-------|
| Kiến thức | Tổng quát | Chuyên sâu theo domain |
| Ngữ cảnh | Bắt đầu từ đầu | Có sẵn context |
| Cách làm việc | Tổng quát | Theo quy trình cụ thể |
| Ghi nhớ | Không | Có memory system |

### Lợi ích của Agent

1. **Chuyên môn hóa**: Agent hiểu sâu về domain cụ thể
2. **Nhất quán**: Cùng một agent luôn làm việc theo cách nhất quán
3. **Tiết kiệm thời gian**: Không cần giải thích context mỗi lần
4. **Có thể mở rộng**: Tạo agent mới cho nhu cầu mới

## Các Loại Agent

### 1. Specialist Agents

Agent chuyên gia trong một lĩnh vực:

- **npm-agent**: Quản lý npm packages
- **go-dev-portable**: Phát triển Go
- **go-refactor-portable**: Refactor Go code

### 2. Meta Agents

Agent có thể tạo ra agents khác:

- **father-agent**: Tạo agents, commands, knowledge mới

### 3. Thinking Agents

Agent hỗ trợ tư duy:

- **deep-question-agent**: Đặt câu hỏi sâu

## Cấu Trúc Agent

Mỗi agent được định nghĩa bằng file markdown với YAML frontmatter:

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

### File agent.md

```yaml
---
name: my-agent
description: |
  Mô tả agent. Dùng khi:
  - Use case 1
  - Use case 2

model: opus
tools: [Read, Write, Edit, Bash, Glob, Grep]
language: vi
---

# Agent Content

Nội dung hướng dẫn cho agent...
```

## Cách Gọi Agent

### Qua Slash Command

```
/microai:npm
```

### Qua Task Tool (trong Claude Code)

Agent có thể được gọi tự động qua Task tool khi phù hợp với nhiệm vụ.

### Kích hoạt thủ công

Trong một số trường hợp, bạn có thể yêu cầu Claude đọc và thực thi agent:

```
Đọc và thực hiện theo agent @.microai/agents/npm-agent/agent.md
```

## Agents Có Sẵn

| Agent | Mô tả | Command |
|-------|-------|---------|
| father-agent | Tạo agents mới | `/microai:father` |
| npm-agent | Quản lý npm | `/microai:npm` |
| go-dev-portable | Phát triển Go | Tự động |
| go-refactor-portable | Refactor Go | `/microai:go:go-refactor` |
| deep-question-agent | Đặt câu hỏi | `/microai:deep-question` |

## Best Practices

### 1. Chọn đúng agent

- Xem mô tả và use cases trong description
- Thử với vấn đề nhỏ trước

### 2. Cung cấp context rõ ràng

```
Tôi đang làm việc với dự án Go microservices.
Cần refactor hàm processOrder để xử lý concurrent requests.
```

### 3. Cho agent biết mục tiêu

```
Mục tiêu: Giảm response time xuống dưới 100ms
Ràng buộc: Không thay đổi API signature
```

### 4. Sử dụng memory

Agent sẽ ghi nhớ quyết định và học được. Nếu cần reset:

```
Hãy bỏ qua context trước đó và bắt đầu lại.
```

## Bước Tiếp Theo

- [Agent là gì? (chi tiết)](./what-is-agent.md)
- [Cách gọi Agent](./invoking-agents.md)
- [Agents có sẵn](./built-in-agents.md)
