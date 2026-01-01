# Cấu trúc Skill

> Hướng dẫn chi tiết về cấu trúc folder, format file, và các fields trong Skill.

---

## Folder Structure

### Cấu trúc cơ bản

```
.claude/skills/
└── skill-name/
    ├── SKILL.md        # Required - file định nghĩa chính
    ├── reference.md    # Optional - tài liệu chi tiết
    ├── examples/       # Optional - thư mục ví dụ
    │   └── example.md
    └── templates/      # Optional - thư mục templates
        └── template.md
```

### Quy tắc đặt tên

| Thành phần | Quy tắc | Ví dụ |
|------------|---------|-------|
| Folder name | kebab-case | `api-designer`, `db-schema` |
| SKILL.md | Phải viết hoa | `SKILL.md` (không phải `skill.md`) |
| Reference files | lowercase | `reference.md`, `conventions.md` |
| Subfolders | lowercase | `examples/`, `templates/` |

---

## SKILL.md Format

### Cấu trúc tổng quan

```yaml
---
# YAML Frontmatter
name: skill-name
description: "When to use this skill"
allowed-tools: Read, Write
---

# Markdown Body
Nội dung skill ở đây
```

### Ví dụ hoàn chỉnh

```yaml
---
name: api-designer
description: "Design RESTful APIs following best practices. Use when creating new endpoints, reviewing API design, or documenting APIs."
allowed-tools: Read, Write
---

# API Designer

## Purpose
Design consistent, well-documented RESTful APIs.

## Conventions
- Use plural nouns for resources
- Use HTTP methods correctly (GET, POST, PUT, DELETE)
- Include proper error responses
- Version APIs (v1, v2)

## URL Patterns

| Resource | GET | POST | PUT | DELETE |
|----------|-----|------|-----|--------|
| /users | List all | Create | - | - |
| /users/{id} | Get one | - | Update | Delete |

## References
- [API Conventions](./conventions.md)
- [Examples](./examples/)
```

---

## Frontmatter Fields

### Required Fields

| Field | Type | Mô tả |
|-------|------|-------|
| `name` | string | Unique identifier, phải khớp với folder name |
| `description` | string | Mô tả khi nào skill được load |

### Optional Fields

| Field | Type | Default | Mô tả |
|-------|------|---------|-------|
| `allowed-tools` | string | all | Tools được phép khi skill active |

---

## Field Details

### name

Unique identifier cho skill. **PHẢI** khớp với folder name.

```yaml
# Good
name: api-designer      # folder: api-designer/

# Bad
name: API Designer      # Not kebab-case
name: apidesigner       # Doesn't match folder api-designer/
```

### description

Mô tả khi nào skill nên được load. Claude dùng description để tự động trigger skill.

```yaml
# Good - clear triggers
description: "Design RESTful APIs following best practices"
description: "Generate PDF documents from data"
description: "Write commit messages following conventional commits"

# Bad - too vague
description: "API stuff"
description: "Helper"
```

**Tips cho description:**
- Bao gồm keywords rõ ràng
- Mô tả USE CASE, không phải implementation
- Dưới 100 ký tự

### allowed-tools

Giới hạn tools khi skill active (optional).

```yaml
# File operations only
allowed-tools: Read, Write

# Include bash commands
allowed-tools: Read, Write, Bash

# All tools (default)
# Không cần specify
```

---

## Body Content

### Recommended Structure

```markdown
# Skill Name

## Purpose
Mô tả ngắn gọn skill làm gì.

## [Main Topic 1]
Nội dung chính...

## [Main Topic 2]
Nội dung chính...

## Quick Reference
Bảng tóm tắt nhanh...

## References
- [File 1](./file1.md)
- [File 2](./file2.md)
```

### Size Guidelines

| Metric | Recommended | Maximum |
|--------|-------------|---------|
| SKILL.md lines | ~200 | 500 |
| Total files | 3-5 | 10 |
| Nesting depth | 1 level | 2 levels |

### Content Types

| Type | Dùng cho | Ví dụ |
|------|----------|-------|
| **Tables** | Quick reference | Conventions, mappings |
| **Code blocks** | Examples | Templates, patterns |
| **Lists** | Guidelines | Best practices, do/don't |
| **Links** | References | External docs, other files |

---

## Reference Files

### Naming Conventions

| Pattern | Purpose |
|---------|---------|
| `reference.md` | Main reference documentation |
| `conventions.md` | Coding/design conventions |
| `examples/*.md` | Example files |
| `templates/*.md` | Template files |
| `patterns/*.md` | Pattern documentation |

### Linking trong SKILL.md

Dùng relative paths:

```markdown
## References
- [API Conventions](./conventions.md)
- [REST Example](./examples/rest.md)
- [GraphQL Example](./examples/graphql.md)
```

### Khi nào tách file?

| Tách ra khi | Giữ trong SKILL.md khi |
|-------------|------------------------|
| Topic > 100 lines | Topic < 50 lines |
| Nhiều code examples | Ít code examples |
| Reference thường xuyên | One-time read |
| Độc lập có ý nghĩa | Chỉ có nghĩa với context |

---

## Validation Checklist

| Check | Error nếu |
|-------|-----------|
| SKILL.md exists | Missing trong folder |
| Frontmatter valid | Missing `---` delimiters |
| name field | Missing hoặc không khớp folder |
| description field | Missing |
| References | Broken links |
| File size | SKILL.md > 500 lines |

---

## Common Mistakes

### 1. Name mismatch

```yaml
# Folder: api-designer/
# SKILL.md:
name: api_designer  # ❌ Wrong - underscore instead of hyphen
name: api-designer  # ✅ Correct
```

### 2. Vague description

```yaml
description: "API"           # ❌ Too vague
description: "Design RESTful APIs following best practices"  # ✅ Clear
```

### 3. Too much content

```yaml
# ❌ Everything in SKILL.md (1000+ lines)
# ✅ Split into reference files:
#    - SKILL.md (overview, 200 lines)
#    - conventions.md (details)
#    - examples/
```

### 4. Deep nesting

```
# ❌ Too deep
skills/api/v1/rest/design/SKILL.md

# ✅ Flat
skills/api-designer/SKILL.md
```

---

## Tiếp theo

- [Tạo Skill step-by-step](./04-creating-skills.md)
- [Patterns nâng cao](./05-advanced-patterns.md)
