# Cấu Hình Ban Đầu

Hướng dẫn cấu hình dev-team sau khi cài đặt.

## Tổng Quan Cấu Hình

Sau khi cài đặt, bạn sẽ có 2 thư mục cấu hình:

```
your-project/
├── .claude/                    # Claude Code adapter
│   ├── CLAUDE.md              # Project context
│   ├── settings.json          # Team settings (shared)
│   └── settings.local.json    # Personal settings (gitignored)
│
└── .microai/                   # MicroAI core framework
    ├── settings.json          # Framework settings
    └── settings.local.json    # Personal overrides
```

## settings.json (Team Settings)

File này chứa cấu hình chung cho cả team, được commit vào git.

### Cấu Trúc Cơ Bản

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  },
  "hooks": [],
  "env": {}
}
```

### Permissions

Quản lý quyền truy cập tools:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(git:*)",
      "Bash(pnpm:*)",
      "Read(**/*.go)",
      "Write(**/*.go)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Read(**/*.pem)",
      "Read(**/*.key)"
    ]
  }
}
```

**Pattern Syntax:**

| Pattern | Ý nghĩa |
|---------|---------|
| `Bash(npm:*)` | Cho phép npm commands |
| `Read(**/*.go)` | Cho phép đọc Go files |
| `Write(src/**)` | Cho phép ghi trong src/ |
| `WebFetch(domain:github.com)` | Cho phép fetch từ GitHub |

### Hooks

Tự động hóa với hooks:

```json
{
  "hooks": [
    {
      "type": "UserPromptSubmit",
      "command": ".microai/hooks/user-prompt-submit/log-prompt.sh"
    },
    {
      "type": "PreToolUse",
      "matcher": "Bash",
      "command": ".microai/hooks/pre-tool-use/log-bash.sh"
    }
  ]
}
```

### Environment Variables

```json
{
  "env": {
    "PROJECT_NAME": "my-project",
    "DEFAULT_BRANCH": "main"
  }
}
```

## settings.local.json (Personal Settings)

File này chứa cấu hình cá nhân, **không** commit vào git.

### Tạo File

```bash
touch .claude/settings.local.json
```

### Ví Dụ Cấu Hình

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)",
      "Bash(kubectl:*)",
      "WebFetch(domain:internal.company.com)"
    ]
  }
}
```

### Merge Rules

Settings được merge theo thứ tự:

```
settings.json (base)
    ↓
settings.local.json (override)
    ↓
Final settings
```

**Rules:**
- `allow`: Được cộng dồn (union)
- `deny`: Được cộng dồn (union)
- `env`: Local override base

## CLAUDE.md

File này cung cấp context cho Claude về project.

### Template

```markdown
# Project Name

## Overview
Brief description of the project.

## Tech Stack
- Language: Go/Python/TypeScript
- Framework: ...
- Database: ...

## Directory Structure
Explain key directories.

## Development Commands
```bash
# Build
npm run build

# Test
npm test
```

## Conventions
- Code style guidelines
- Naming conventions
- Important patterns
```

### Best Practices

1. **Giữ ngắn gọn**: < 500 lines
2. **Focus vào context**: Không lặp lại docs có sẵn
3. **Update thường xuyên**: Khi project thay đổi

## Cấu Hình MicroAI

### .microai/settings.json

```json
{
  "version": "1.0",
  "defaultLanguage": "vi",
  "agentDefaults": {
    "model": "sonnet",
    "color": "blue"
  },
  "logging": {
    "enabled": true,
    "directory": ".microai/logs"
  }
}
```

### .microai/settings.local.json

```json
{
  "agentDefaults": {
    "model": "opus"
  },
  "logging": {
    "verbose": true
  }
}
```

## Gitignore

Đảm bảo các file sau được gitignore:

```gitignore
# Claude Code local settings
.claude/settings.local.json

# MicroAI local settings
.microai/settings.local.json

# MicroAI logs
.microai/logs/

# Session context
.microai/.session-context
```

## Xác Nhận Cấu Hình

Kiểm tra cấu hình đã đúng:

```bash
# Liệt kê các components
dev-team list

# Mở Claude Code
claude

# Thử một command
/microai:deep-question
```

## Troubleshooting

### Permissions không hoạt động

1. Kiểm tra syntax trong settings.json
2. Đảm bảo pattern đúng format
3. Restart Claude Code

### Hooks không chạy

1. Kiểm tra file script có execute permission
2. Kiểm tra path trong settings.json
3. Xem logs trong .microai/logs/

### CLAUDE.md không được đọc

1. Đảm bảo file ở đúng vị trí: `.claude/CLAUDE.md`
2. Kiểm tra encoding: UTF-8
3. Restart Claude Code

## Bước Tiếp Theo

- [Cấu trúc thư mục](./directory-structure.md)
- [settings.json chi tiết](./settings-json.md)
- [Quickstart](./quickstart.md)
