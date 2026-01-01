# Skill là gì?

> Skills là các "kỹ năng" có thể tái sử dụng trong Claude Code, cung cấp kiến thức chuyên biệt cho các tác vụ cụ thể.

---

## Định nghĩa

**Skill** là một tập hợp kiến thức được tổ chức trong folder, bao gồm:
- **SKILL.md** - File định nghĩa chính
- **Reference files** - Tài liệu bổ sung (optional)
- **Examples** - Ví dụ minh họa (optional)

### Đặc điểm chính

| Đặc điểm | Mô tả |
|----------|-------|
| **Focused** | Tập trung vào một task/domain cụ thể |
| **Reusable** | Có thể dùng lại trong nhiều context |
| **Lightweight** | Không có persona, không có memory |
| **Fast** | Load nhanh, chạy xong là xong |

---

## Core Concepts

### 1. Knowledge-centric

Skills cung cấp **kiến thức**, không phải **hành vi**:

```
Agent = Persona + Knowledge + Workflow
Skill = Knowledge + Instructions
```

### 2. Trigger-based

Skills được load dựa trên:
- **Keywords** trong description
- **Yêu cầu trực tiếp** từ user
- **Reference** từ agent

### 3. Composable

Skills có thể:
- Kết hợp với agents
- Reference lẫn nhau
- Stack multiple skills

---

## Use Cases điển hình

### 1. API Design

```yaml
---
name: api-designer
description: "Design RESTful APIs following best practices"
---
```

Khi user yêu cầu thiết kế API, skill này được load tự động.

### 2. Code Formatting

```yaml
---
name: code-formatter
description: "Format code theo project conventions"
---
```

### 3. Documentation

```yaml
---
name: doc-writer
description: "Write technical documentation"
---
```

### 4. Database Schema

```yaml
---
name: db-schema
description: "Design database schemas and migrations"
---
```

---

## Quick Start Example

### Bước 1: Tạo folder

```bash
mkdir -p .claude/skills/commit-helper
```

### Bước 2: Tạo SKILL.md

```yaml
---
name: commit-helper
description: "Help write good commit messages"
---

# Commit Helper

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

| Type | Dùng khi |
|------|----------|
| feat | Tính năng mới |
| fix | Sửa bug |
| docs | Chỉ thay đổi docs |
| refactor | Refactor code |
| test | Thêm/sửa tests |

## Examples

Good:
```
feat(auth): add JWT token refresh
```

Bad:
```
fix bug
```
```

### Bước 3: Sử dụng

```
User: "Giúp tôi viết commit message cho thay đổi này"
Claude: [Loads commit-helper skill và áp dụng conventions]
```

---

## Skill vs Agent: Tóm tắt nhanh

| Câu hỏi | Agent | Skill |
|---------|-------|-------|
| Cần persona? | Yes | No |
| Cần memory? | Yes | No |
| Workflow phức tạp? | Yes | No |
| One-shot task? | No | Yes |
| Reusable knowledge? | Sometimes | Always |

> Chi tiết hơn: [02. Agent vs Skill](./02-agent-vs-skill.md)

---

## Tiếp theo

- [So sánh Agent vs Skill](./02-agent-vs-skill.md)
- [Cấu trúc Skill chi tiết](./03-skill-anatomy.md)
