# FAQ - Câu hỏi thường gặp

Các câu hỏi thường gặp khi sử dụng @microai.club/dev-team.

---

## Cài đặt

### Q: Làm sao để cài đặt dev-team?

```bash
npx @microai.club/dev-team@alpha install
```

Xem chi tiết: [Hướng dẫn cài đặt](./getting-started/installation.md)

---

### Q: Làm sao để update khi có version mới?

```bash
npx @microai.club/dev-team@alpha install
# Chọn "Merge" để giữ files hiện có và thêm files mới
```

---

### Q: Cài đặt bị lỗi permission?

Thử chạy với sudo (không khuyến khích) hoặc fix npm permissions:

```bash
# Option 1: Change npm default directory
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

---

## Agents

### Q: Agent của tôi không được gọi?

Kiểm tra:

1. File có đuôi `.md`
2. YAML frontmatter đúng format (có `---` ở đầu và cuối)
3. Description có trigger keywords
4. Restart Claude Code session

---

### Q: Làm sao để dùng agent?

**Cách 1: Trigger tự động**

Khi bạn nhắc đến keywords trong description, Claude tự động gọi agent.

**Cách 2: Yêu cầu trực tiếp**

```
Use the code-reviewer agent to review this file.
```

**Cách 3: Slash command**

```
/microai:go:go-dev
```

---

### Q: Sự khác nhau giữa .claude/agents/ và .microai/agents/?

| Location | Type | Use Case |
|----------|------|----------|
| `.claude/agents/` | Simple agents | Single-file agent definitions |
| `.microai/agents/` | Complex agents | Agents with knowledge bases |

---

### Q: Làm sao để tạo agent mới?

Xem: [Hướng dẫn tạo Agent](./guides/creating-agents.md)

---

## Skills

### Q: Skill không load?

Kiểm tra:

1. Có file `SKILL.md` trong folder
2. YAML frontmatter đúng format
3. Name trong frontmatter khớp với folder name
4. Restart Claude Code session

---

### Q: Skill vs Agent khác nhau thế nào?

| Aspect | Agent | Skill |
|--------|-------|-------|
| Purpose | Define behavior | Provide knowledge |
| Structure | Single file | Folder with files |
| Trigger | Automatic/manual | Loaded by agents |

---

## Commands

### Q: Command không hoạt động?

Kiểm tra:

1. File trong `.claude/commands/`
2. File có đuôi `.md`
3. Có YAML frontmatter với `description`
4. Restart Claude Code session

---

### Q: $ARGUMENTS không nhận giá trị?

Đảm bảo:

1. Viết đúng: `$ARGUMENTS` (uppercase)
2. Có khoảng trắng sau command name

```
/review src/api/
       ^-- khoảng trắng ở đây
```

---

## Hooks

### Q: Hook không chạy?

Kiểm tra:

1. Quyền execute: `chmod +x .microai/hooks/**/*.sh`
2. `settings.json` có hooks section
3. Path trong settings.json đúng

---

### Q: Hook block sai command?

1. Kiểm tra regex patterns trong script
2. Thêm exception nếu cần
3. Test hook thủ công:

```bash
echo '{"tool_name":"Bash","tool_input":{"command":"your command"}}' | ./hook.sh
```

---

### Q: Logs không được ghi?

1. Kiểm tra thư mục `.microai/logs/` tồn tại
2. Kiểm tra quyền ghi
3. Tạo thư mục: `mkdir -p .microai/logs`

---

## Configuration

### Q: Làm sao share config với team?

1. Commit `.claude/` vào git (trừ `settings.local.json`)
2. Team members pull và có cùng config
3. Mỗi người tạo `settings.local.json` riêng cho cấu hình cá nhân

---

### Q: Sensitive files bị đọc?

Thêm vào `settings.json`:

```json
{
  "permissions": {
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)"
    ]
  }
}
```

---

### Q: settings.local.json có gì khác settings.json?

| File | Purpose | Commit? |
|------|---------|---------|
| `settings.json` | Team config | Yes |
| `settings.local.json` | Personal overrides | No |

Local settings override team settings.

---

## Troubleshooting

### Q: Claude Code không nhận config?

1. Restart Claude Code session
2. Kiểm tra file paths đúng
3. Validate JSON format trong settings.json

---

### Q: Lỗi "jq: command not found"?

Install jq:

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Windows
choco install jq
```

---

### Q: Lỗi permission denied khi chạy hooks?

```bash
chmod +x .microai/hooks/**/*.sh
```

---

## General

### Q: dev-team có free không?

Có, dev-team là open source và free.

---

### Q: Support ở đâu?

- **Issues:** https://github.com/taipm/dev-team/issues
- **NPM:** https://www.npmjs.com/package/@microai.club/dev-team

---

### Q: Làm sao để contribute?

Xem: [Hướng dẫn đóng góp](./contributing/submitting-pr.md)

---

## Tiếp theo

- [Bắt đầu nhanh](./getting-started/quick-start.md)
- [Cấu hình](./getting-started/configuration.md)
- [Tạo Agent](./guides/creating-agents.md)
