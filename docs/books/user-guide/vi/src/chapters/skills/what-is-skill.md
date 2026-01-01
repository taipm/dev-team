# Skills Là Gì?

Giải thích chi tiết về Skills.

## Định Nghĩa

**Skill** = Workflow + References + Examples

Skill đóng gói một quy trình làm việc có thể tái sử dụng.

## Components của Skill

### 1. SKILL.md
Định nghĩa skill với:
- Metadata (name, description)
- Instructions
- Reference links

### 2. Reference Files
Tài liệu hỗ trợ:
- Guidelines
- Templates
- Checklists

### 3. Examples
Ví dụ thực tế:
- Input/output samples
- Use case demonstrations

## Khi Nào Tạo Skill?

### ✅ Nên tạo Skill khi:

- Workflow lặp lại thường xuyên
- Cần standardize output format
- Muốn share với team
- Quy trình có nhiều steps

### ❌ Không cần Skill khi:

- Task đơn giản, một lần
- Agent có sẵn đã đủ
- Không cần reference files

## Ví Dụ Skill

### API Documentation Skill

```
api-doc/
├── SKILL.md
├── reference/
│   ├── openapi-template.yaml
│   └── style-guide.md
└── examples/
    └── user-api.md
```

**SKILL.md**:
```yaml
---
name: api-doc
description: Generate OpenAPI documentation
---

# API Documentation

## Steps

1. Read endpoint code
2. Extract parameters
3. Generate OpenAPI spec
4. Add examples

## Template
Use @reference/openapi-template.yaml

## Style
Follow @reference/style-guide.md
```

## Skill vs Agent

| Skill | Agent |
|-------|-------|
| Workflow focus | Capability focus |
| Reference-heavy | Knowledge-heavy |
| Task completion | Conversation |
| Stateless | Can have memory |

## Xem Thêm

- [Skills Có Sẵn](./built-in-skills.md)
- [Tạo Skills](../../developer-guide/creating-skills/overview.md)
