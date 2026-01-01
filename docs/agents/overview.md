# Tổng quan Agent Ecosystem

Kiến trúc và cách hoạt động của agents trong @microai.club/dev-team.

---

## Agent Ecosystem

```
┌─────────────────────────────────────────────────────────┐
│                    Claude Code                          │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Agents    │  │   Skills    │  │  Commands   │     │
│  │ (.claude/)  │  │ (.claude/)  │  │ (.claude/)  │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │           MicroAI Agent System                   │   │
│  │              (.microai/agents/)                  │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐         │   │
│  │  │ Father  │  │ Go-Dev  │  │  NPM    │  ...    │   │
│  │  │  Agent  │  │  Agent  │  │  Agent  │         │   │
│  │  └─────────┘  └─────────┘  └─────────┘         │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Hai loại Agents

### 1. Claude Agents (`.claude/agents/`)

- **Định nghĩa**: Markdown files với YAML frontmatter
- **Sử dụng**: Trigger tự động hoặc qua Task tool
- **Scope**: Per-project

```yaml
---
name: code-reviewer
description: "Review code for quality"
tools: Read, Grep
---

# Code Reviewer
...
```

### 2. MicroAI Agents (`.microai/agents/`)

- **Định nghĩa**: Complex agents với knowledge base
- **Sử dụng**: Qua slash commands (`/microai:agent-name`)
- **Scope**: Shared across projects

```
.microai/agents/
└── go-dev-agent/
    ├── agent.md           # Agent definition
    └── knowledge/         # Knowledge base
        ├── patterns.md
        └── anti-patterns.md
```

---

## Agent Components

### 1. Agent Definition (agent.md)

```yaml
---
name: my-agent
description: "Trigger description"
tools: Read, Write, Edit, Bash
model: sonnet
---

# Agent Name

## Role
Agent's primary responsibility.

## Guidelines
- How the agent should behave
- What to prioritize

## Output Format
Expected output structure.
```

### 2. Knowledge Base (knowledge/)

Thư mục chứa domain knowledge:

```
knowledge/
├── 01-patterns.md       # Best practices
├── 02-anti-patterns.md  # Things to avoid
├── 03-examples.md       # Code examples
└── learning/            # Continuous learning
    └── sessions/
```

### 3. Commands (commands/)

Slash commands để trigger agent:

```
commands/
└── microai/
    └── agent-name.md    # /microai:agent-name
```

---

## Agent Lifecycle

```
1. Trigger → 2. Load → 3. Execute → 4. Learn

1. Trigger:
   - User mentions keywords (auto)
   - User calls /command
   - User requests via Task tool

2. Load:
   - Read agent.md
   - Load knowledge base
   - Apply tools restrictions

3. Execute:
   - Follow guidelines
   - Use allowed tools
   - Produce output

4. Learn (optional):
   - Save patterns discovered
   - Update knowledge base
```

---

## Agent Types

| Type | Ví dụ | Use Case |
|------|-------|----------|
| **Code Review** | code-reviewer | Quality assurance |
| **Development** | go-dev, python-dev | Write code |
| **Refactoring** | go-refactor | Improve code |
| **Documentation** | doc-writer | Write docs |
| **Testing** | test-generator | Write tests |
| **Meta** | father-agent | Create other agents |
| **Analysis** | first-thinking | Problem analysis |

---

## Agent Discovery

### Tự động

Claude phát hiện agents dựa trên:
- Description keywords
- Context của conversation
- User intent

### Manual

```
Use the code-reviewer agent to review this file.
```

Hoặc slash command:

```
/microai:go-dev
```

---

## Agent Communication

### Chuyển tiếp (Handoff)

Một agent có thể suggest handoff:

```
This task would be better handled by the go-refactor agent.
Shall I hand off to it?
```

### Shared Context

Agents trong cùng session share:
- Conversation history
- File reads
- Decisions made

---

## Best Practices

### Agent Design

- Một agent = một nhiệm vụ cụ thể
- Description rõ ràng với keywords
- Tools tối thiểu cần thiết
- Knowledge base có tổ chức

### Knowledge Organization

```
knowledge/
├── 00-overview.md           # Quick reference
├── 01-patterns.md           # Numbered for order
├── 02-anti-patterns.md
├── examples/                # Grouped examples
│   ├── basic.md
│   └── advanced.md
└── learning/                # Continuous learning
```

### Naming Conventions

- Agent names: `kebab-case` (code-reviewer)
- Files: `kebab-case.md`
- Folders: `kebab-case/`

---

## Tiếp theo

- [Agents có sẵn](./built-in-agents.md) - Danh sách agents đi kèm
- [Agent Gallery](./agent-gallery.md) - Showcase agents hay
- [Tạo Agent](../guides/creating-agents.md) - Hướng dẫn tạo agent
