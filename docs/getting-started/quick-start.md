# Bắt đầu nhanh

Làm quen với @microai.club/dev-team trong 5 phút.

---

## Bước 1: Cài đặt

```bash
cd your-project
npx @microai.club/dev-team@alpha install
```

Chọn các components khi được hỏi (hoặc chọn "All").

---

## Bước 2: Mở Claude Code

Khởi động Claude Code trong thư mục project:

```bash
claude
```

---

## Bước 3: Xem agents có sẵn

Trong Claude Code session, gõ:

```
/agents
```

Hoặc xem file `.claude/agents/README.md`.

---

## Bước 4: Thử dùng agent

Trong Claude Code, bạn có thể yêu cầu Claude sử dụng agent:

```
Use the code-reviewer agent to review this code.
```

Hoặc trigger tự động bằng keywords trong description của agent.

---

## Bước 5: Thử custom command

Nếu có command `/review`:

```
/review src/api/
```

---

## Cấu trúc đã cài đặt

```
your-project/
└── .claude/
    ├── CLAUDE.md       # Mô tả project (CHỈNH SỬA FILE NÀY!)
    ├── settings.json   # Permissions và hooks
    ├── agents/         # Custom agents
    ├── skills/         # Custom skills
    └── commands/       # Slash commands
```

---

## Việc cần làm tiếp

### 1. Chỉnh sửa CLAUDE.md

Mở `.claude/CLAUDE.md` và thêm thông tin về project:

```markdown
# My Project

## Overview
Mô tả ngắn về project.

## Tech Stack
- Backend: Node.js
- Database: PostgreSQL

## Important Directories
- `src/api/` - API routes
- `src/models/` - Database models
```

### 2. Tạo agent đầu tiên

Tạo file `.claude/agents/my-agent.md`:

```yaml
---
name: my-agent
description: "Use when [trigger condition]"
tools: Read, Edit, Grep
---

# My Agent

## Role
You are a specialized agent for [task].

## Guidelines
- Guideline 1
- Guideline 2
```

### 3. Đọc thêm

- [Cấu hình chi tiết](./configuration.md)
- [Tạo Agent](../guides/creating-agents.md)
- [Tạo Skill](../guides/creating-skills.md)

---

## Troubleshooting

### Agent không được gọi?

1. Kiểm tra file có đuôi `.md`
2. YAML frontmatter đúng format
3. Restart Claude Code session

### Command không hoạt động?

1. Kiểm tra file trong `.claude/commands/`
2. Có YAML frontmatter với `description`
3. Restart Claude Code session
