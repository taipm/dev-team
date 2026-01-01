# Agent Gallery

Tổng hợp tất cả agents có sẵn.

## Agents Theo Nhóm

### Meta Agents

| Agent | Mô tả | Command |
|-------|-------|---------|
| father-agent | Tạo, clone, review agents | `/microai:father` |

### Development Agents

| Agent | Mô tả | Command |
|-------|-------|---------|
| npm-agent | npm ecosystem | `/microai:npm` |
| go-dev-portable | Go development | `/microai:go:go-dev` |
| go-refactor-portable | Go refactoring | `/microai:go:go-refactor` |

### Thinking Agents

| Agent | Mô tả | Command |
|-------|-------|---------|
| deep-question-agent | 7 phương pháp tư duy | `/microai:deep-question` |

## Agent Stats

```
┌────────────────────────┬───────────┬─────────────┐
│ Agent                  │ Model     │ Tools       │
├────────────────────────┼───────────┼─────────────┤
│ father-agent           │ opus      │ Full        │
│ npm-agent              │ sonnet    │ Full        │
│ go-dev-portable        │ sonnet    │ Full        │
│ go-refactor-portable   │ sonnet    │ Full        │
│ deep-question-agent    │ sonnet    │ Read/Search │
└────────────────────────┴───────────┴─────────────┘
```

## Tìm Agent Phù Hợp

### Theo Task Type

| Task Type | Agent(s) |
|-----------|----------|
| Tạo agent mới | father-agent |
| npm/Node.js | npm-agent |
| Go development | go-dev-portable |
| Go refactoring | go-refactor-portable |
| Brainstorming | deep-question-agent |

### Theo Language

| Language | Agent(s) |
|----------|----------|
| Go | go-dev, go-refactor |
| JavaScript/Node | npm-agent |
| Any | father-agent, deep-question |

## Tạo Agent Mới

Nếu không tìm thấy agent phù hợp:

1. Dùng `/microai:father` để tạo
2. Hoặc xem [Tạo Agent Cơ Bản](../../developer-guide/creating-agents/basic-agent.md)

## Xem Thêm

- [Cách Gọi Agent](./invoking-agents.md)
- [Agents Có Sẵn](./built-in-agents.md)
