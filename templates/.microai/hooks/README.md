# MicroAI Hooks System

Hệ thống hooks tự động cho Claude Code, được cài đặt bởi dev-team installer.

## Tổng quan

Hooks là các scripts chạy tự động khi Claude Code thực hiện các hành động. Chúng giúp:
- **Audit & Logging**: Ghi lại mọi hoạt động
- **Security**: Chặn các lệnh nguy hiểm
- **Protection**: Bảo vệ files nhạy cảm
- **Initialization**: Setup môi trường tự động

## Cấu trúc thư mục

```
.microai/hooks/
├── README.md                           # File này
├── pre-tool-use/
│   ├── log-bash-commands.sh           # Log tất cả bash commands
│   ├── block-dangerous.sh             # Chặn lệnh nguy hiểm
│   └── protect-sensitive.sh           # Bảo vệ files nhạy cảm
├── post-tool-use/
│   └── log-file-changes.sh            # Log file modifications
├── user-prompt-submit/
│   └── log-prompts.sh                 # Log user prompts
└── session-start/
    └── init-env.sh                    # Initialize environment
```

## Chi tiết từng hook

### PreToolUse Hooks

#### `log-bash-commands.sh`
- **Trigger**: Trước mỗi lệnh Bash
- **Chức năng**: Log command vào `.microai/logs/bash-commands.log`
- **Blocking**: Không (luôn cho phép)

#### `block-dangerous.sh`
- **Trigger**: Trước mỗi lệnh Bash
- **Chức năng**: Chặn các lệnh nguy hiểm:
  - `rm -rf /` hoặc system directories
  - `git push --force` đến main/master/develop
  - SQL operations không có WHERE clause
  - `chmod 777`
  - `curl | bash` (pipe to shell)
  - Disk formatting commands
  - Modification of /etc/passwd, /etc/shadow
- **Blocking**: Có (exit 1 nếu phát hiện nguy hiểm)

#### `protect-sensitive.sh`
- **Trigger**: Trước Write/Edit operations
- **Chức năng**: Chặn modification của:
  - `.env`, `.env.local`, `.env.*` files
  - Files chứa "credentials", "secrets", "password"
  - Token/API key files
  - SSH keys (~/.ssh/*)
  - Cloud provider credentials (.aws/, .gcloud/)
  - Keychain/Keystore files
- **Blocking**: Có (exit 1 nếu file nhạy cảm)

### PostToolUse Hooks

#### `log-file-changes.sh`
- **Trigger**: Sau Write/Edit operations
- **Chức năng**: Log file path và operation type
- **Output**: `.microai/logs/file-changes.log`
- **Blocking**: Không

### UserPromptSubmit Hooks

#### `log-prompts.sh`
- **Trigger**: Khi user submit prompt
- **Chức năng**: Log prompt content (truncated nếu quá dài)
- **Output**: `.microai/logs/prompts.log`
- **Blocking**: Không

### SessionStart Hooks

#### `init-env.sh`
- **Trigger**: Khi Claude Code session bắt đầu
- **Chức năng**:
  1. Load environment files (`.env`, `.env.local`, `.microai/.env`)
  2. Log session start info
  3. Check prerequisites (jq, git)
  4. Create session context file
- **Output**: `.microai/logs/sessions.log`
- **Blocking**: Không

## Log Files

Tất cả logs được lưu trong `.microai/logs/`:

| File | Nội dung |
|------|----------|
| `bash-commands.log` | Lịch sử bash commands |
| `file-changes.log` | Lịch sử file modifications |
| `prompts.log` | Lịch sử user prompts |
| `sessions.log` | Lịch sử sessions |

**Lưu ý**: Logs tự động rotate khi vượt 10MB.

## Customize Hooks

### Disable một hook

Sửa `.claude/settings.json`, xóa hook khỏi array tương ứng.

### Thêm hook mới

1. Tạo script trong thư mục phù hợp
2. Chmod +x cho script
3. Thêm vào `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "YourMatcher",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/your-hook.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Input Format

Hooks nhận JSON input qua stdin:

```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "ls -la"
  },
  "session_id": "...",
  "timestamp": "..."
}
```

### Hook Output

- **Exit 0**: Cho phép operation
- **Exit 1**: Block operation (hiển thị stderr cho user)
- **Stderr**: Thông báo lỗi/cảnh báo

## Troubleshooting

### Hook không chạy
1. Kiểm tra quyền: `chmod +x .microai/hooks/**/*.sh`
2. Kiểm tra settings.json có hooks section
3. Kiểm tra path trong settings.json đúng

### Hook block sai
1. Kiểm tra regex patterns trong script
2. Thêm exception nếu cần

### Logs không ghi
1. Kiểm tra thư mục `.microai/logs/` tồn tại
2. Kiểm tra quyền ghi

## Security Notes

- Logs có thể chứa sensitive data - không commit vào git
- `.microai/logs/` đã được thêm vào `.gitignore`
- Review hooks định kỳ để đảm bảo security patterns up-to-date

## Version

- **Version**: 1.0.0
- **Installed by**: dev-team installer
- **Compatible with**: Claude Code 1.0+
