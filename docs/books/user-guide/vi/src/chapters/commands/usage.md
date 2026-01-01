# Cách Sử Dụng Commands

Hướng dẫn sử dụng slash commands hiệu quả.

## Gọi Command

### Cú pháp cơ bản

```
/namespace:command
```

### Với arguments

```
/microai:npm publish
```

## Nested Commands

Commands có thể được tổ chức theo nhóm:

```
/microai:go:go-dev
│       │  │
│       │  └── Command
│       └── Group
└── Namespace
```

## Tips Sử Dụng

### 1. Tab Completion

Trong Claude Code, gõ `/` rồi Tab để xem suggestions.

### 2. Provide Context

Sau khi gọi command, cung cấp context:

```
You: /microai:dev-architect-session

Agent: Sẵn sàng! Bạn muốn thiết kế gì?

You: Thiết kế authentication system cho mobile app.
Tech stack: Go backend, PostgreSQL.
Requirements: Social login, 2FA.
```

### 3. Sử Dụng Observer Commands

Trong team sessions:

```
*status    # Xem trạng thái
*focus X   # Focus vào agent X
*next      # Chuyển phase
```

## Tạo Custom Command

### 1. Tạo file

```bash
touch .claude/commands/custom/my-command.md
```

### 2. Định nghĩa command

```yaml
---
name: 'my-command'
description: 'My custom command'
---

Bạn sẽ [thực hiện tác vụ X].

Các bước:
1. Step 1
2. Step 2
3. Step 3
```

### 3. Sử dụng

```
/custom:my-command
```

## Troubleshooting

### Command không tìm thấy

Kiểm tra:
1. File có tồn tại trong `.claude/commands/`
2. YAML frontmatter đúng format
3. Reload Claude Code

### Command không hoạt động đúng

Kiểm tra:
1. Xem prompt trong file command
2. Agent/team references đúng path
3. Permissions trong settings.json

## Xem Thêm

- [Danh Sách Commands](./command-list.md)
- [Tạo Commands](../../developer-guide/creating-commands/overview.md)
