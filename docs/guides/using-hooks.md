# Sử dụng Hooks

Hướng dẫn sử dụng hooks system trong Claude Code.

---

## Hooks là gì?

Hooks là scripts chạy tự động khi Claude Code thực hiện các hành động:
- **PreToolUse** - Trước khi tool chạy
- **PostToolUse** - Sau khi tool chạy
- **UserPromptSubmit** - Khi user gửi prompt
- **SessionStart** - Khi session bắt đầu

---

## Use Cases

- **Audit & Logging** - Ghi lại mọi hoạt động
- **Security** - Chặn các lệnh nguy hiểm
- **Protection** - Bảo vệ files nhạy cảm
- **Initialization** - Setup môi trường tự động

---

## Cài đặt Hooks

### Qua dev-team installer

```bash
npx @microai.club/dev-team@alpha install
# Chọn "Hooks" trong danh sách components
```

### Cấu trúc sau cài đặt

```
.microai/hooks/
├── pre-tool-use/
│   ├── log-bash-commands.sh
│   ├── block-dangerous.sh
│   └── protect-sensitive.sh
├── post-tool-use/
│   └── log-file-changes.sh
├── user-prompt-submit/
│   └── log-prompts.sh
└── session-start/
    └── init-env.sh
```

---

## Hooks có sẵn

### PreToolUse Hooks

#### `log-bash-commands.sh`
- **Trigger**: Trước mỗi lệnh Bash
- **Chức năng**: Log command vào `.microai/logs/bash-commands.log`
- **Blocking**: Không

#### `block-dangerous.sh`
- **Trigger**: Trước mỗi lệnh Bash
- **Chức năng**: Chặn các lệnh nguy hiểm:
  - `rm -rf /` hoặc system directories
  - `git push --force` đến main/master
  - `chmod 777`
  - `curl | bash`
- **Blocking**: Có (exit 1 nếu nguy hiểm)

#### `protect-sensitive.sh`
- **Trigger**: Trước Write/Edit
- **Chức năng**: Chặn modification của:
  - `.env` files
  - Files chứa credentials/secrets
  - SSH keys
- **Blocking**: Có

### PostToolUse Hooks

#### `log-file-changes.sh`
- **Trigger**: Sau Write/Edit
- **Chức năng**: Log file modifications
- **Output**: `.microai/logs/file-changes.log`

### UserPromptSubmit Hooks

#### `log-prompts.sh`
- **Trigger**: Khi user submit prompt
- **Chức năng**: Log prompt content
- **Output**: `.microai/logs/prompts.log`

### SessionStart Hooks

#### `init-env.sh`
- **Trigger**: Khi session bắt đầu
- **Chức năng**: Load .env files, check prerequisites
- **Output**: `.microai/logs/sessions.log`

---

## Cấu hình trong settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/log-bash-commands.sh"
          },
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/block-dangerous.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/protect-sensitive.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/post-tool-use/log-file-changes.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/user-prompt-submit/log-prompts.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/session-start/init-env.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Tạo Hook mới

### 1. Tạo script

```bash
#!/bin/bash

# Đọc input từ stdin
INPUT=$(cat)

# Parse JSON với jq
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Logic của bạn
if [[ "$COMMAND" =~ "dangerous" ]]; then
    echo "Blocked: dangerous command" >&2
    exit 1
fi

# Cho phép tiếp tục
exit 0
```

### 2. Chmod +x

```bash
chmod +x .microai/hooks/pre-tool-use/my-hook.sh
```

### 3. Đăng ký trong settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/my-hook.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Hook Input Format

Hooks nhận JSON input qua stdin:

```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "ls -la"
  },
  "session_id": "abc123",
  "timestamp": "2025-01-01T00:00:00Z"
}
```

---

## Hook Output

- **Exit 0** - Cho phép operation
- **Exit 1** - Block operation
- **Stderr** - Thông báo lỗi cho user

---

## Matchers

| Matcher | Mô tả |
|---------|-------|
| `Bash` | Chỉ Bash commands |
| `Write` | Write tool |
| `Edit` | Edit tool |
| `Write\|Edit` | Write hoặc Edit |
| `Read` | Read tool |
| `*` | Tất cả tools |

---

## Log Files

| File | Nội dung |
|------|----------|
| `.microai/logs/bash-commands.log` | Lịch sử bash commands |
| `.microai/logs/file-changes.log` | Lịch sử file modifications |
| `.microai/logs/prompts.log` | Lịch sử user prompts |
| `.microai/logs/sessions.log` | Lịch sử sessions |

---

## Troubleshooting

### Hook không chạy

1. Kiểm tra quyền: `chmod +x script.sh`
2. Kiểm tra settings.json có hooks section
3. Kiểm tra path đúng

### Hook block sai

1. Kiểm tra regex patterns
2. Thêm exception nếu cần

### Logs không ghi

1. Kiểm tra `.microai/logs/` tồn tại
2. Kiểm tra quyền ghi

---

## Security Notes

- Logs có thể chứa sensitive data
- `.microai/logs/` đã trong `.gitignore`
- Review hooks định kỳ

---

## Tiếp theo

- [Hooks API Reference](../reference/hooks-api.md)
- [Cấu hình](../getting-started/configuration.md)
