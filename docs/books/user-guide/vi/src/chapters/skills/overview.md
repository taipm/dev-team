# Skills

Tổng quan về hệ thống Skills.

## Skill là gì?

**Skill** là một workflow có thể tái sử dụng, được đóng gói với:
- Instructions
- Reference files
- Examples

## So sánh với Commands

| Aspect | Command | Skill |
|--------|---------|-------|
| Scope | Kích hoạt agent/team | Workflow cụ thể |
| Files | Single .md file | Folder với SKILL.md + files |
| Complexity | Simple | Can be complex |
| Reusability | Per project | Shareable |

## Cấu Trúc Skill

```
skill-name/
├── SKILL.md           # Skill definition
├── reference/         # Reference documents
│   └── guide.md
└── examples/          # Examples
    └── example-1.md
```

## SKILL.md Format

```yaml
---
name: skill-name
description: |
  Mô tả skill. Sử dụng khi:
  - Use case 1
  - Use case 2
---

# Skill Instructions

## Workflow

1. Step 1
2. Step 2
3. Step 3

## Reference Files

- @reference/guide.md
```

## Kích Hoạt Skill

```
/skill-name
```

Hoặc skill có thể được tự động suggest khi relevant.

## Vị Trí Files

```
.claude/skills/
├── my-skill/
│   ├── SKILL.md
│   └── reference/
└── another-skill/
    ├── SKILL.md
    └── examples/
```

## Xem Thêm

- [Skills Là Gì?](./what-is-skill.md)
- [Skills Có Sẵn](./built-in-skills.md)
