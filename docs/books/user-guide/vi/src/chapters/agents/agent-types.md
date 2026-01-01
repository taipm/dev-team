# Claude Agents vs MicroAI Agents

So sánh hai loại agent trong dev-team framework.

## Tổng Quan

| Đặc điểm | Claude Agents | MicroAI Agents |
|----------|---------------|----------------|
| Vị trí | `.claude/agents/` | `.microai/agents/` |
| Format | YAML frontmatter + MD | YAML frontmatter + MD |
| Memory | Không | Có |
| Knowledge | Không | Có |
| Teams | Không | Có |

## Claude Agents

### Vị trí

```
.claude/agents/
├── my-agent.md
└── other-agent.md
```

### Đặc điểm

- Đơn giản, một file
- Không có memory system
- Không có knowledge system
- Phù hợp cho agents đơn giản

### Ví dụ

```yaml
---
name: simple-agent
description: A simple agent
tools: [Read, Write]
---

# Simple Agent

Do simple things...
```

## MicroAI Agents

### Vị trí

```
.microai/agents/
├── my-agent/
│   ├── agent.md
│   ├── knowledge/
│   └── memory/
```

### Đặc điểm

- Có thư mục riêng
- Hỗ trợ knowledge system
- Hỗ trợ memory system
- Có thể tham gia teams
- Phù hợp cho agents phức tạp

### Ví dụ

```yaml
---
name: advanced-agent
description: An advanced agent
tools: [Read, Write, Edit, Bash]
---

# Advanced Agent

## Persona
Expert in domain X.

## Knowledge
Load từ knowledge-index.yaml

## Memory
Persist to memory/context.md
```

## Khi Nào Dùng Loại Nào?

### Dùng Claude Agents khi:

- Agent đơn giản, không cần memory
- Prototype nhanh
- Không cần kiến thức phức tạp

### Dùng MicroAI Agents khi:

- Cần memory qua sessions
- Cần knowledge base riêng
- Agent sẽ tham gia teams
- Agent phức tạp, nhiều capabilities

## Chuyển Đổi

### Claude → MicroAI

1. Tạo thư mục trong `.microai/agents/`
2. Di chuyển file thành `agent.md`
3. Thêm `knowledge/` và `memory/` nếu cần

### MicroAI → Claude

1. Copy `agent.md` sang `.claude/agents/`
2. Bỏ references đến knowledge/memory

## Xem Thêm

- [Tạo Agent Cơ Bản](../../developer-guide/creating-agents/basic-agent.md)
- [Knowledge System](../../developer-guide/knowledge-system/overview.md)
