# father-agent - Tạo Agent Mới

Meta-agent có khả năng tạo, clone, và review agents.

## Tổng Quan

**father-agent** là một meta-agent đặc biệt có thể:
- Tạo agents mới từ mô tả
- Clone và modify agents có sẵn
- Review và cải thiện agents
- Tạo commands và knowledge files

## Kích Hoạt

```
/microai:father
```

## Capabilities

### 1. Tạo Agent Mới

```
Tạo một agent cho việc review security code
```

father-agent sẽ:
1. Hỏi về use cases
2. Xác định tools cần thiết
3. Tạo agent.md
4. Tạo knowledge files nếu cần
5. Tạo command để kích hoạt

### 2. Clone Agent

```
Clone go-refactor-portable và customize cho Rust
```

### 3. Review Agent

```
Review agent npm-agent và đề xuất cải thiện
```

## Ví Dụ Session

```
You: /microai:father

Father: 🧬 Father Agent sẵn sàng!
Tôi có thể giúp bạn tạo, clone, hoặc review agents.
Bạn muốn làm gì?

You: Tạo agent cho việc viết API documentation

Father: Tuyệt! Để tạo API Doc Agent, tôi cần biết:

1. API style nào? (REST, GraphQL, gRPC)
2. Format output? (Markdown, OpenAPI, Postman)
3. Có cần generate examples không?

You: REST, OpenAPI format, có examples

Father: Đang tạo agent...
✅ Đã tạo: .microai/agents/api-doc-agent/
   - agent.md
   - knowledge/openapi-spec.md
   - knowledge/rest-conventions.md
✅ Đã tạo command: /microai:api-doc
```

## Output Structure

```
.microai/agents/new-agent/
├── agent.md           # Agent definition
├── knowledge/
│   ├── knowledge-index.yaml
│   └── 01-domain.md
└── memory/
    └── context.md

.claude/commands/microai/
└── new-agent.md       # Slash command
```

## Tips

- Cung cấp context cụ thể về use case
- father-agent học từ agents có sẵn
- Review output trước khi dùng

## Xem Thêm

- [Tạo Agent Cơ Bản](../../developer-guide/creating-agents/basic-agent.md)
- [Agent Gallery](./gallery.md)
