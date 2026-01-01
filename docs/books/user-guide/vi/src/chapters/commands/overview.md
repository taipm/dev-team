# Slash Commands

Tổng quan về hệ thống slash commands.

## Slash Command là gì?

Slash commands là cách nhanh để kích hoạt agents, teams, hoặc workflows trong Claude Code.

```
/namespace:command
```

## Cấu Trúc

```
/microai:deep-question
│       │
│       └── Command name
└── Namespace
```

## Namespaces

| Namespace | Mô tả |
|-----------|-------|
| `microai` | MicroAI framework commands |
| `custom` | Custom commands của bạn |

## Cách Hoạt Động

1. User gõ `/microai:deep-question`
2. Claude Code tìm file `.claude/commands/microai/deep-question.md`
3. Load và thực thi command
4. Agent/Team được kích hoạt

## Vị Trí Files

```
.claude/commands/
├── microai/
│   ├── deep-question.md
│   ├── deep-thinking.md
│   ├── npm.md
│   └── go/
│       ├── go-dev.md
│       └── go-refactor.md
└── custom/
    └── your-command.md
```

## Command File Format

```yaml
---
name: 'command-name'
description: 'Mô tả command'
---

Nội dung prompt để thực thi...
```

## Ví Dụ Sử Dụng

```
You: /microai:deep-question

Deep Question Agent: 🔮 Sẵn sàng!
Bạn muốn khám phá vấn đề gì?
```

## Liệt Kê Commands

```
/help
```

Hoặc:

```bash
dev-team list
```

## Xem Thêm

- [Danh Sách Commands](./command-list.md)
- [Cách Sử Dụng](./usage.md)
