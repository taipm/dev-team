# Tạo Agent

Hướng dẫn tạo custom agent cho Claude Code.

---

## Agent là gì?

Agent là một "chuyên gia" được định nghĩa bằng markdown file, có:
- **Role** - Vai trò chuyên biệt
- **Tools** - Các công cụ được phép sử dụng
- **Guidelines** - Hướng dẫn cách làm việc

---

## Cấu trúc file

Tạo file `.claude/agents/my-agent.md`:

```yaml
---
name: my-agent
description: "Use this agent when [trigger condition]"
tools: Read, Grep, Edit, Bash
model: sonnet
---

# My Agent

## Role
You are a specialized agent for [specific task].

## Guidelines
- Guideline 1
- Guideline 2

## Output Format
Describe expected output.
```

---

## YAML Frontmatter

| Field | Bắt buộc | Mô tả | Ví dụ |
|-------|----------|-------|-------|
| `name` | Yes | Tên agent (kebab-case) | `code-reviewer` |
| `description` | Yes | Khi nào dùng agent | `"Use for code review"` |
| `tools` | No | Tools được phép | `Read, Grep, Edit` |
| `model` | No | Model sử dụng | `sonnet`, `opus`, `haiku` |
| `permissionMode` | No | Chế độ permission | `default`, `acceptEdits` |

---

## Ví dụ: Code Reviewer

```yaml
---
name: code-reviewer
description: "PROACTIVELY use for code review, security analysis"
tools: Read, Grep, Glob
model: sonnet
---

# Code Reviewer

## Role
You are a senior code reviewer focused on quality and security.

## Review Checklist
1. Code correctness
2. Security vulnerabilities
3. Performance issues
4. Code style consistency
5. Test coverage

## Output Format
Provide structured feedback with:
- **Issues found** (Critical/Warning/Info)
- **Suggested fixes**
- **Good practices observed**
```

---

## Ví dụ: Documentation Writer

```yaml
---
name: doc-writer
description: "Use when writing or updating documentation"
tools: Read, Write, Glob
model: haiku
---

# Documentation Writer

## Role
You write clear, concise documentation.

## Guidelines
- Use simple language
- Include code examples
- Add diagrams when helpful
- Keep paragraphs short

## Output Format
Markdown formatted documentation.
```

---

## Ví dụ: Test Generator

```yaml
---
name: test-generator
description: "Generate unit tests for code"
tools: Read, Write, Bash
model: sonnet
---

# Test Generator

## Role
You generate comprehensive unit tests.

## Guidelines
- Cover happy path and edge cases
- Use descriptive test names
- Mock external dependencies
- Aim for high coverage

## Testing Framework
Use the project's existing testing framework (jest, pytest, etc.)
```

---

## Description Keywords

Description quyết định khi nào agent được trigger. Dùng keywords rõ ràng:

### Trigger tự động
```yaml
description: "PROACTIVELY use for code review"
```

### Trigger theo yêu cầu
```yaml
description: "Use when user asks for documentation"
```

### Keywords hay dùng
- `code review`, `security analysis`
- `write tests`, `generate tests`
- `documentation`, `docs`
- `refactor`, `optimize`
- `debug`, `troubleshoot`

---

## Tools Reference

| Tool | Mô tả |
|------|-------|
| `Read` | Đọc files |
| `Write` | Tạo files mới |
| `Edit` | Sửa files |
| `Grep` | Tìm kiếm trong code |
| `Glob` | Tìm files theo pattern |
| `Bash` | Chạy shell commands |
| `WebFetch` | Fetch URLs |
| `WebSearch` | Tìm kiếm web |

### Quy tắc chọn tools

- Chỉ cho phép tools cần thiết
- `Read, Grep, Glob` cho analysis tasks
- `Read, Write, Edit` cho creation tasks
- `Bash` chỉ khi cần chạy commands

---

## Best Practices

### Nên

- Một agent = một nhiệm vụ rõ ràng
- Dùng trigger keywords trong description
- Chỉ cho phép tools cần thiết
- Viết guidelines cụ thể
- Include output format

### Không nên

- Agent làm quá nhiều việc
- Description mơ hồ
- Cho phép tất cả tools
- Instructions không rõ ràng

---

## Sử dụng agent

### Cách 1: Trigger tự động

Claude tự động gọi agent khi nhận ra keywords trong description.

### Cách 2: Yêu cầu trực tiếp

```
Use the code-reviewer agent to review this file.
```

### Cách 3: Task tool

```
Launch the code-reviewer agent to analyze security issues.
```

---

## Troubleshooting

### Agent không được gọi?

1. Kiểm tra file có đuôi `.md`
2. YAML frontmatter đúng format (có `---` ở đầu và cuối)
3. Description có trigger keywords
4. Restart Claude Code session

### Agent không có quyền?

1. Kiểm tra `tools` trong frontmatter
2. Kiểm tra `settings.json` có deny tool đó không

---

## Tiếp theo

- [Agent Specification](../reference/agent-spec.md) - Đặc tả chi tiết
- [Agents có sẵn](../agents/built-in-agents.md) - Tham khảo agents mẫu
