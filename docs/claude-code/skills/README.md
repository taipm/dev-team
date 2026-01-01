# Skills trong Claude Code

> Tài liệu tham khảo toàn diện về Skills - kỹ năng tái sử dụng trong Claude Code.

---

## Giới thiệu

**Skills** là các "kỹ năng" có thể tái sử dụng, cung cấp kiến thức và hướng dẫn cho Claude Code thực hiện các tác vụ chuyên biệt. Khác với Agents (định nghĩa hành vi), Skills tập trung vào việc cung cấp knowledge.

---

## Mục lục

| Chapter | Nội dung | Khi nào đọc |
|---------|----------|-------------|
| [01. Skill là gì?](./01-what-is-skill.md) | Khái niệm, use cases | Mới bắt đầu |
| [02. Agent vs Skill](./02-agent-vs-skill.md) | So sánh, decision tree | Chọn approach |
| [03. Cấu trúc Skill](./03-skill-anatomy.md) | Format, fields | Khi tạo skill |
| [04. Tạo Skill](./04-creating-skills.md) | Step-by-step guide | Khi tạo skill |
| [05. Patterns nâng cao](./05-advanced-patterns.md) | Best practices | Nâng cao |
| [06. Examples Gallery](./06-examples-gallery.md) | Ví dụ thực tế | Tham khảo |

---

## Quick Start

### Cấu trúc cơ bản

```
.claude/skills/
└── my-skill/
    ├── SKILL.md        # File định nghĩa chính
    └── [optional files]
```

### SKILL.md tối thiểu

```yaml
---
name: my-skill
description: "Khi nào dùng skill này"
---

# My Skill

Nội dung skill ở đây.
```

---

## Tài liệu liên quan

- [Hướng dẫn tạo Skill](../../guides/creating-skills.md)
- [Skill Specification](../../reference/skill-spec.md)
- [Agent Specification](../../reference/agent-spec.md)

---

*Cập nhật lần cuối: 2026-01-01*
