# Hướng dẫn sử dụng @microai.club/dev-team

Hướng dẫn cài đặt và sử dụng bộ cấu hình Claude Code cho dự án của bạn.

---

## Mục lục

1. [Cài đặt nhanh](#1-cài-đặt-nhanh)
2. [Các tùy chọn cài đặt](#2-các-tùy-chọn-cài-đặt)
3. [Cấu trúc thư mục](#3-cấu-trúc-thư-mục)
4. [Tùy chỉnh cấu hình](#4-tùy-chỉnh-cấu-hình)
5. [Tạo Agent mới](#5-tạo-agent-mới)
6. [Tạo Skill mới](#6-tạo-skill-mới)
7. [Tạo Command mới](#7-tạo-command-mới)
8. [Best Practices](#8-best-practices)
9. [FAQ](#9-faq)

---

## 1. Cài đặt nhanh

### Yêu cầu
- Node.js >= 18.0.0
- npm hoặc npx

### Cài đặt

Mở terminal trong thư mục project của bạn và chạy:

```bash
npx @microai.club/dev-team@alpha install
```

### Kết quả

Sau khi cài đặt, thư mục `.claude/` sẽ được tạo:

```
your-project/
└── .claude/
    ├── CLAUDE.md       # Project context
    ├── settings.json   # Team configuration
    ├── agents/         # Agent templates
    ├── skills/         # Skill templates
    └── commands/       # Command templates
```

---

## 2. Các tùy chọn cài đặt

### Interactive mode (mặc định)

```bash
npx @microai.club/dev-team@alpha install
```

Cho phép bạn:
- Chọn components muốn cài đặt
- Quyết định merge hoặc overwrite nếu đã có `.claude/`

### Non-interactive mode

```bash
npx @microai.club/dev-team@alpha install --no-interactive
```

Cài đặt tất cả components mà không hỏi.

### Force overwrite

```bash
npx @microai.club/dev-team@alpha install --force
```

Ghi đè tất cả files hiện có.

### Cài đặt vào đường dẫn khác

```bash
npx @microai.club/dev-team@alpha install --path /path/to/project
```

### Xem danh sách components

```bash
npx @microai.club/dev-team@alpha list
```

### Xem help

```bash
npx @microai.club/dev-team@alpha --help
npx @microai.club/dev-team@alpha install --help
```

---

## 3. Cấu trúc thư mục

### Sau khi cài đặt

```
.claude/
├── CLAUDE.md           # Project context cho Claude
├── settings.json       # Cấu hình team (shared qua git)
├── settings.local.json # Cấu hình cá nhân (gitignored)
├── agents/
│   └── README.md       # Hướng dẫn tạo agent
├── skills/
│   └── README.md       # Hướng dẫn tạo skill
└── commands/
    └── README.md       # Hướng dẫn tạo command
```

### Giải thích các file

| File | Mục đích | Commit vào Git? |
|------|----------|-----------------|
| `CLAUDE.md` | Context về project để Claude hiểu | ✅ Có |
| `settings.json` | Permissions, hooks cho team | ✅ Có |
| `settings.local.json` | Cấu hình cá nhân | ❌ Không |
| `agents/*.md` | Định nghĩa custom agents | ✅ Có |
| `skills/*/SKILL.md` | Định nghĩa custom skills | ✅ Có |
| `commands/*.md` | Custom slash commands | ✅ Có |

---

## 4. Tùy chỉnh cấu hình

### 4.1. Chỉnh sửa CLAUDE.md

File này chứa context về project để Claude hiểu. Mở và thêm:

```markdown
# My Project

## Overview
Mô tả ngắn về project.

## Tech Stack
- Backend: Node.js + Express
- Database: PostgreSQL
- Frontend: React

## Coding Conventions
- Use TypeScript
- Follow ESLint rules
- Write tests for new features

## Important Files
- `src/config/` - Configuration files
- `src/api/` - API routes
- `src/models/` - Database models
```

### 4.2. Cấu hình settings.json

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

### 4.3. Cấu hình cá nhân (settings.local.json)

Tạo file `.claude/settings.local.json` cho cấu hình riêng:

```json
{
  "model": "opus"
}
```

> **Lưu ý:** File này đã được thêm vào `.gitignore` tự động.

---

## 5. Tạo Agent mới

### 5.1. Cấu trúc file agent

Tạo file `.claude/agents/my-agent.md`:

```yaml
---
name: my-agent
description: "Use this agent when [trigger condition]"
tools: Read, Grep, Edit, Bash
model: sonnet
---

# My Agent

## Role
You are a specialized agent for [specific task].

## Guidelines
- Guideline 1
- Guideline 2

## Output Format
Describe expected output.
```

### 5.2. Ví dụ: Code Reviewer Agent

```yaml
---
name: code-reviewer
description: "PROACTIVELY use for code review, security analysis"
tools: Read, Grep, Glob
model: sonnet
---

# Code Reviewer

## Role
You are a senior code reviewer focused on quality and security.

## Review Checklist
1. Code correctness
2. Security vulnerabilities
3. Performance issues
4. Code style consistency
5. Test coverage

## Output Format
Provide structured feedback with:
- **Issues found** (Critical/Warning/Info)
- **Suggested fixes**
- **Good practices observed**
```

### 5.3. Ví dụ: Documentation Agent

```yaml
---
name: doc-writer
description: "Use when writing or updating documentation"
tools: Read, Write, Glob
model: haiku
---

# Documentation Writer

## Role
You write clear, concise documentation.

## Guidelines
- Use simple language
- Include code examples
- Add diagrams when helpful

## Output Format
Markdown formatted documentation.
```

### 5.4. YAML Fields

| Field | Bắt buộc | Mô tả |
|-------|----------|-------|
| `name` | ✅ | Tên agent (kebab-case) |
| `description` | ✅ | Khi nào dùng agent này |
| `tools` | ❌ | Danh sách tools được phép |
| `model` | ❌ | sonnet (default), opus, haiku |
| `permissionMode` | ❌ | default, acceptEdits, bypassPermissions |
| `skills` | ❌ | Tự động load skills |

---

## 6. Tạo Skill mới

### 6.1. Cấu trúc skill

```
.claude/skills/
└── my-skill/
    ├── SKILL.md        # Bắt buộc
    ├── reference.md    # Tùy chọn
    └── examples/       # Tùy chọn
        └── example.md
```

### 6.2. Tạo SKILL.md

```yaml
---
name: api-designer
description: "Design RESTful APIs following best practices"
allowed-tools: Read, Write
---

# API Designer

## Purpose
Design consistent, RESTful APIs.

## Conventions
- Use plural nouns for resources
- Use HTTP methods correctly
- Include proper error responses

## References
See [reference.md](./reference.md) for detailed guidelines.
```

### 6.3. Ví dụ: PDF Generator Skill

```
.claude/skills/
└── pdf-generator/
    ├── SKILL.md
    └── templates.md
```

**SKILL.md:**
```yaml
---
name: pdf-generator
description: "Generate PDF documents from data"
allowed-tools: Read, Write, Bash
---

# PDF Generator

## Capabilities
- Generate reports
- Create invoices
- Export documentation

## Usage
1. Prepare data in JSON format
2. Select template
3. Generate PDF

See [templates.md](./templates.md) for available templates.
```

---

## 7. Tạo Command mới

### 7.1. Cấu trúc command

Tạo file `.claude/commands/my-command.md`:

```yaml
---
description: "Short description for /help"
---

Command prompt content here.

Use $ARGUMENTS for user input after the command.
```

### 7.2. Ví dụ: /review command

```yaml
---
description: "Review code changes"
---

Review the current git diff for:
1. Code quality issues
2. Potential bugs
3. Security concerns
4. Performance problems

Focus on: $ARGUMENTS
```

**Sử dụng:**
```
/review security
/review src/api/
```

### 7.3. Ví dụ: /test command

```yaml
---
description: "Run tests and analyze results"
---

Run the project tests and provide analysis:

1. Execute test suite
2. Report failures with details
3. Suggest fixes for failing tests

Test scope: $ARGUMENTS
```

**Sử dụng:**
```
/test
/test unit
/test src/api/
```

### 7.4. Ví dụ: /commit command

```yaml
---
description: "Create a commit with AI-generated message"
---

1. Run git status to see changes
2. Run git diff to understand changes
3. Generate a concise commit message
4. Create the commit

Additional context: $ARGUMENTS
```

---

## 8. Best Practices

### 8.1. Agent Design

✅ **Nên:**
- Một agent = một nhiệm vụ rõ ràng
- Dùng trigger keywords trong description
- Chỉ cho phép tools cần thiết
- Viết guidelines cụ thể

❌ **Không nên:**
- Agent làm quá nhiều việc
- Description mơ hồ
- Cho phép tất cả tools
- Instructions không rõ ràng

### 8.2. Skill Design

✅ **Nên:**
- SKILL.md dưới 500 dòng
- Dùng reference files cho chi tiết
- Include examples
- Clear trigger keywords

❌ **Không nên:**
- Nhồi tất cả vào SKILL.md
- Thiếu documentation
- Description quá chung

### 8.3. Security

✅ **Nên:**
- Deny sensitive files trong settings.json
- Không commit secrets
- Review permissions regularly

❌ **Không nên:**
- Allow Read cho .env files
- Commit settings.local.json
- Bypass permissions không cần thiết

### 8.4. Version Control

✅ **Commit vào Git:**
- `CLAUDE.md`
- `settings.json`
- `agents/*.md`
- `skills/*/`
- `commands/*.md`

❌ **Không commit:**
- `settings.local.json`
- Sensitive data

---

## 9. FAQ

### Q: Làm sao để update khi có version mới?

```bash
npx @microai.club/dev-team@alpha install
# Chọn "Merge" để giữ files hiện có và thêm files mới
```

### Q: Agent của tôi không được gọi?

Kiểm tra:
1. File có đuôi `.md`
2. YAML frontmatter đúng format
3. Description có trigger keywords
4. Restart Claude Code session

### Q: Làm sao để dùng agent?

Trong Claude Code, đề cập đến trigger keywords trong description của agent, Claude sẽ tự động gọi agent phù hợp.

Hoặc dùng Task tool với `subagent_type`:
```
Use the code-reviewer agent to review this file.
```

### Q: Skill không load?

Kiểm tra:
1. Có file `SKILL.md` trong folder
2. YAML frontmatter đúng format
3. Name trong frontmatter khớp với folder name

### Q: Command không hoạt động?

Kiểm tra:
1. File trong `.claude/commands/`
2. Có YAML frontmatter với `description`
3. Restart Claude Code session

### Q: Làm sao share config với team?

1. Commit `.claude/` vào git (trừ `settings.local.json`)
2. Team members pull và có cùng config
3. Mỗi người tạo `settings.local.json` riêng cho cấu hình cá nhân

---

## Hỗ trợ

- **Issues:** https://github.com/taipm/dev-team/issues
- **NPM:** https://www.npmjs.com/package/@microai.club/dev-team
