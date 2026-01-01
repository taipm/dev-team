# Cấu hình

Hướng dẫn cấu hình @microai.club/dev-team cho project.

---

## Các file cấu hình

| File | Mục đích | Commit vào Git? |
|------|----------|-----------------|
| `CLAUDE.md` | Context về project | Yes |
| `settings.json` | Permissions, hooks cho team | Yes |
| `settings.local.json` | Cấu hình cá nhân | No |

---

## CLAUDE.md

File này chứa context về project để Claude hiểu. Claude đọc file này mỗi khi bắt đầu session.

### Cấu trúc đề xuất

```markdown
# Project Name

## Overview
Mô tả ngắn về project.

## Tech Stack
- Backend: Node.js + Express
- Database: PostgreSQL
- Frontend: React

## Architecture
Giải thích kiến trúc tổng quan.

## Coding Conventions
- Use TypeScript
- Follow ESLint rules
- Write tests for new features

## Important Directories
- `src/config/` - Configuration files
- `src/api/` - API routes
- `src/models/` - Database models

## Common Commands
- `npm run dev` - Start development server
- `npm test` - Run tests
- `npm run build` - Build for production
```

---

## settings.json

Cấu hình team, được chia sẻ qua git.

### Permissions

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(git:*)",
      "Bash(docker:*)"
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

### Hooks

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": ".microai/hooks/pre-tool-use/log-bash-commands.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": ".microai/hooks/post-tool-use/log-file-changes.sh"
      }
    ]
  }
}
```

### Permissions patterns

| Pattern | Mô tả |
|---------|-------|
| `Bash(npm:*)` | Cho phép tất cả npm commands |
| `Read(.env)` | Đọc file .env |
| `Read(**/*.key)` | Đọc tất cả .key files |
| `Write(src/**)` | Ghi vào thư mục src |

---

## settings.local.json

Cấu hình cá nhân, KHÔNG commit vào git.

### Tạo file

```bash
touch .claude/settings.local.json
```

### Ví dụ

```json
{
  "model": "opus",
  "permissions": {
    "allow": [
      "Bash(my-custom-script:*)"
    ]
  }
}
```

### Các tùy chọn

| Key | Mô tả | Giá trị |
|-----|-------|---------|
| `model` | Model mặc định | sonnet, opus, haiku |
| `permissions` | Permissions cá nhân | allow, deny arrays |

---

## Merge cấu hình

Khi có cả `settings.json` và `settings.local.json`:

1. `settings.json` được load trước (team config)
2. `settings.local.json` được merge vào (cá nhân override)
3. Local settings ưu tiên hơn

---

## Best Practices

### Security

- Luôn deny sensitive files:
  - `.env`, `.env.*`
  - `secrets/**`
  - `**/*.pem`, `**/*.key`
  - `credentials.json`

- Không commit `settings.local.json`

### Team Collaboration

- Thống nhất permissions trong `settings.json`
- Document conventions trong `CLAUDE.md`
- Review changes khi có PR đụng đến `.claude/`

### Git Configuration

Đảm bảo `.gitignore` có:

```
.claude/settings.local.json
```

---

## Tiếp theo

- [Tạo Agent](../guides/creating-agents.md)
- [Tạo Skill](../guides/creating-skills.md)
- [Sử dụng Hooks](../guides/using-hooks.md)
