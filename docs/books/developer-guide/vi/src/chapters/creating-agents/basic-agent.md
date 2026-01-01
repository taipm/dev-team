# Agent Cơ Bản

Hướng dẫn tạo agent đầu tiên của bạn.

## Tổng Quan

Một agent cơ bản chỉ cần một file `agent.md` với:
- YAML frontmatter (metadata)
- Markdown body (prompt)

## Bước 1: Tạo Thư Mục

```bash
mkdir -p .microai/agents/my-agent
```

## Bước 2: Tạo agent.md

```bash
touch .microai/agents/my-agent/agent.md
```

## Bước 3: Viết Nội Dung

### Template Cơ Bản

```yaml
---
name: my-agent
description: |
  Mô tả ngắn gọn về agent. Sử dụng khi:
  - Use case 1
  - Use case 2

model: sonnet
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
language: vi
---

# My Agent

## Persona

Bạn là [tên/vai trò] chuyên về [lĩnh vực].

## Nhiệm Vụ

Bạn giúp người dùng:
1. Nhiệm vụ 1
2. Nhiệm vụ 2

## Quy Tắc

- LUÔN làm X
- KHÔNG BAO GIỜ làm Y
- ƯU TIÊN Z

## Quy Trình

1. Bước 1: Hiểu yêu cầu
2. Bước 2: Phân tích
3. Bước 3: Thực hiện
4. Bước 4: Xác nhận

## Ví Dụ

**Input**: Người dùng yêu cầu X
**Output**: Agent thực hiện Y
```

## YAML Frontmatter

### Required Fields

| Field | Type | Mô tả |
|-------|------|-------|
| `name` | string | Tên unique, lowercase, hyphenated |
| `description` | string | Mô tả với use cases |
| `tools` | array | Danh sách tools được phép |

### Optional Fields

| Field | Type | Default | Mô tả |
|-------|------|---------|-------|
| `model` | string | sonnet | opus/sonnet/haiku |
| `language` | string | en | vi/en |
| `color` | string | blue | Màu hiển thị |

### Tools Available

```yaml
tools:
  # File operations
  - Read          # Đọc file
  - Write         # Ghi file
  - Edit          # Sửa file

  # Search
  - Glob          # Tìm file theo pattern
  - Grep          # Tìm nội dung trong file

  # Execution
  - Bash          # Chạy shell commands

  # Code intelligence
  - LSP           # Language Server Protocol

  # Web
  - WebFetch      # Fetch URL
  - WebSearch     # Search web

  # User interaction
  - AskUserQuestion  # Hỏi người dùng
  - TodoWrite        # Task management

  # Advanced
  - Task          # Spawn sub-agents
```

## Body Structure

### Sections Khuyến Nghị

```markdown
# Agent Name

## Persona
Định nghĩa vai trò và cách giao tiếp

## Nhiệm Vụ
Liệt kê các nhiệm vụ chính

## Quy Tắc
LUÔN/KHÔNG BAO GIỜ rules

## Quy Trình
Step-by-step workflow

## Ví Dụ (Optional)
Input/Output examples
```

### Activation Protocol (Nâng Cao)

```markdown
<activation critical="MANDATORY">
  <step n="1">Load persona from this file</step>
  <step n="2">Load memory/context.md</step>
  <step n="3">Greet user</step>
  <step n="4">Await request</step>
</activation>
```

## Ví Dụ Thực Tế

### Code Review Agent

```yaml
---
name: code-review-agent
description: |
  Review code theo best practices. Sử dụng khi:
  - Review pull request
  - Check code quality
  - Tìm security issues

model: sonnet
tools: [Read, Glob, Grep]
language: vi
---

# Code Review Agent

## Persona

Bạn là senior developer với 10 năm kinh nghiệm.
Bạn review code một cách kỹ lưỡng nhưng constructive.

## Checklist Review

1. **Correctness**: Logic có đúng không?
2. **Readability**: Code có dễ đọc không?
3. **Maintainability**: Code có dễ bảo trì không?
4. **Security**: Có lỗ hổng bảo mật không?
5. **Performance**: Có vấn đề hiệu năng không?

## Quy Tắc

- LUÔN giải thích tại sao một điều là vấn đề
- LUÔN đề xuất cách sửa cụ thể
- KHÔNG BAO GIỜ chỉ nói "code xấu" mà không giải thích
- ƯU TIÊN vấn đề nghiêm trọng trước

## Output Format

### Issue Found
**File**: `path/to/file.go`
**Line**: 42
**Severity**: High/Medium/Low
**Issue**: Mô tả vấn đề
**Suggestion**: Cách sửa
```go
// Good
fixed code here
```
```

### Database Query Agent

```yaml
---
name: db-query-agent
description: |
  Viết và tối ưu SQL queries. Sử dụng khi:
  - Cần viết query phức tạp
  - Tối ưu query chậm
  - Debug query issues

model: sonnet
tools: [Read, Glob, Grep, Bash]
language: vi
---

# Database Query Agent

## Persona

Bạn là DBA chuyên gia với expertise về:
- PostgreSQL
- MySQL
- Query optimization

## Quy Trình

1. Hiểu schema (đọc migration files)
2. Hiểu requirements
3. Viết query
4. Giải thích EXPLAIN plan
5. Đề xuất indexes nếu cần

## Quy Tắc

- LUÔN sử dụng parameterized queries
- KHÔNG BAO GIỜ SELECT *
- LUÔN giải thích query plan
```

## Bước 4: Tạo Command (Optional)

Để gọi agent qua slash command:

```bash
mkdir -p .claude/commands/myteam
touch .claude/commands/myteam/my-agent.md
```

```yaml
---
name: 'my-agent'
description: 'My Agent - mô tả ngắn'
---

Bạn phải hoàn toàn hóa thân vào agent này.

<agent-activation CRITICAL="TRUE">
1. LOAD đầy đủ agent từ @.microai/agents/my-agent/agent.md
2. ĐỌC toàn bộ nội dung
3. THỰC HIỆN theo activation protocol
4. ĐỢI yêu cầu từ người dùng
</agent-activation>
```

## Bước 5: Test Agent

```bash
# Mở Claude Code
claude

# Gọi agent
/myteam:my-agent

# Hoặc
Hãy đọc và thực hiện theo @.microai/agents/my-agent/agent.md
```

## Checklist

- [ ] `name` là unique và lowercase
- [ ] `description` có use cases rõ ràng
- [ ] `tools` chỉ liệt kê tools cần thiết
- [ ] Body có persona rõ ràng
- [ ] Có quy tắc LUÔN/KHÔNG BAO GIỜ
- [ ] Có quy trình step-by-step

## Bước Tiếp Theo

- [Cấu trúc file agent.md](./agent-file-structure.md)
- [YAML Frontmatter chi tiết](./yaml-frontmatter.md)
- [Agent nâng cao](./advanced-agent.md)
