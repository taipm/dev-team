# Agent Specification

Đặc tả kỹ thuật cho Claude Code agents.

---

## File Format

Agents được định nghĩa bằng Markdown file với YAML frontmatter.

```markdown
---
# YAML frontmatter (required)
name: agent-name
description: "When to use this agent"
---

# Agent body (markdown)
```

---

## YAML Frontmatter Fields

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Unique identifier (kebab-case) |
| `description` | string | Trigger description |

### Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tools` | string | All | Comma-separated list of allowed tools |
| `model` | string | sonnet | Model to use (sonnet, opus, haiku) |
| `permissionMode` | string | default | Permission handling mode |
| `skills` | string | - | Skills to auto-load |

---

## Field Details

### name

Unique identifier cho agent. Phải là kebab-case.

```yaml
name: code-reviewer      # Good
name: CodeReviewer       # Bad
name: code reviewer      # Bad
```

### description

Mô tả khi nào agent được trigger. Dùng keywords rõ ràng.

```yaml
# Good - clear trigger keywords
description: "PROACTIVELY use for code review, security analysis"
description: "Use when writing documentation"

# Bad - too vague
description: "General helper"
description: "Does stuff"
```

#### Trigger Modes

| Prefix | Behavior |
|--------|----------|
| `PROACTIVELY` | Claude tự động gọi khi phát hiện context phù hợp |
| `Use when` | User phải yêu cầu rõ ràng |

### tools

Danh sách tools được phép, phân cách bằng dấu phẩy.

```yaml
tools: Read, Grep, Glob           # Read-only
tools: Read, Write, Edit          # File operations
tools: Read, Write, Edit, Bash    # Full development
```

#### Available Tools

| Tool | Description | Risk Level |
|------|-------------|------------|
| `Read` | Read files | Low |
| `Write` | Create files | Medium |
| `Edit` | Modify files | Medium |
| `Grep` | Search content | Low |
| `Glob` | Find files | Low |
| `Bash` | Run commands | High |
| `WebFetch` | Fetch URLs | Medium |
| `WebSearch` | Search web | Low |
| `LSP` | Language server | Low |

### model

Model sử dụng cho agent.

| Value | Use Case |
|-------|----------|
| `haiku` | Simple tasks, fast responses |
| `sonnet` | Standard tasks (default) |
| `opus` | Complex reasoning, meta tasks |

### permissionMode

Cách xử lý permissions.

| Value | Behavior |
|-------|----------|
| `default` | Ask for permission as usual |
| `acceptEdits` | Auto-accept edit suggestions |
| `bypassPermissions` | Skip permission checks (use carefully) |

### skills

Skills được tự động load khi agent chạy.

```yaml
skills: api-designer, db-design
```

---

## Body Content

### Recommended Structure

```markdown
# Agent Name

## Role
One paragraph describing the agent's primary responsibility.

## Expertise Areas
1. Area 1
2. Area 2
3. Area 3

## Guidelines
- Guideline 1
- Guideline 2
- Guideline 3

## Workflow
1. Step 1
2. Step 2
3. Step 3

## Output Format
Describe expected output structure.
```

### Sections

| Section | Purpose | Required |
|---------|---------|----------|
| Role | Primary responsibility | Recommended |
| Expertise | What agent knows | Optional |
| Guidelines | How to behave | Recommended |
| Workflow | Steps to follow | Optional |
| Output Format | Expected output | Recommended |

---

## File Location

### Claude Agents

```
.claude/agents/
├── agent-name.md
├── another-agent.md
└── nested/
    └── agent.md        # Accessed as nested:agent
```

### MicroAI Agents

```
.microai/agents/
└── agent-name/
    ├── agent.md
    └── knowledge/
        └── *.md
```

---

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| File name | kebab-case | `code-reviewer.md` |
| Agent name | kebab-case | `code-reviewer` |
| Folder name | kebab-case | `my-agent/` |

---

## Examples

### Minimal Agent

```yaml
---
name: helper
description: "General development helper"
---

# Helper

## Role
Help with development tasks.
```

### Code Reviewer

```yaml
---
name: code-reviewer
description: "PROACTIVELY use for code review, security analysis"
tools: Read, Grep, Glob
model: sonnet
---

# Code Reviewer

## Role
Senior code reviewer focused on quality and security.

## Checklist
1. Code correctness
2. Security vulnerabilities
3. Performance issues
4. Code style

## Output
- **Issues** (Critical/Warning/Info)
- **Fixes** suggested
- **Good practices** observed
```

### Documentation Writer

```yaml
---
name: doc-writer
description: "Use when writing or updating documentation"
tools: Read, Write, Glob
model: haiku
---

# Documentation Writer

## Role
Write clear, concise documentation.

## Guidelines
- Use simple language
- Include code examples
- Keep paragraphs short

## Output
Markdown formatted documentation.
```

---

## Validation

Agent file được validate khi Claude Code load:

| Check | Error if |
|-------|----------|
| Frontmatter | Missing `---` delimiters |
| name | Missing or invalid format |
| description | Missing |
| tools | Invalid tool name |
| model | Invalid model name |

---

## Tiếp theo

- [Skill Specification](./skill-spec.md)
- [Hooks API](./hooks-api.md)
- [Tạo Agent](../guides/creating-agents.md)
