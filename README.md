# @microai.club/dev-team

Claude Code configuration framework for development teams.

Bộ công cụ cấu hình Claude Code cho team phát triển phần mềm - bao gồm agents, skills, commands và hooks system.

---

## Quick Start

```bash
npx @microai.club/dev-team@alpha install
```

Xem [Hướng dẫn chi tiết](./docs/README.md) để biết thêm.

---

## Features

- **Custom Agents** - Chuyên gia AI cho từng tác vụ cụ thể
- **Skills Framework** - Bộ kiến thức có thể tái sử dụng
- **Slash Commands** - Shortcuts cho các workflow thường dùng
- **Hooks System** - Automation, logging và security
- **Team Configuration** - Chia sẻ config qua Git

---

## Installation

### NPX (Recommended)

```bash
npx @microai.club/dev-team@alpha install
```

### Global Install

```bash
npm install -g @microai.club/dev-team
dev-team install
```

### Options

| Option | Description |
|--------|-------------|
| `--no-interactive` | Cài đặt tất cả mà không hỏi |
| `--force` | Ghi đè files hiện có |
| `--path <path>` | Cài vào thư mục khác |

---

## What Gets Installed

```
your-project/
├── .claude/
│   ├── CLAUDE.md       # Project context
│   ├── settings.json   # Team configuration
│   ├── agents/         # Custom agents
│   ├── skills/         # Custom skills
│   └── commands/       # Slash commands
└── .microai/
    ├── agents/         # Advanced agents
    └── hooks/          # Automation hooks
```

---

## Built-in Agents

| Agent | Description |
|-------|-------------|
| Father Agent | Meta-agent để tạo agents khác |
| Go Dev Agent | Chuyên gia Go development |
| Go Refactor Agent | Refactoring với 5W2H workflow |
| Go Review Agent | Code review style Linus Torvalds |
| GitHub Agent | GitHub operations |
| NPM Agent | NPM package management |
| First Thinking | First principles analysis |

Xem [danh sách đầy đủ](./docs/agents/built-in-agents.md).

---

## Documentation

| Section | Description |
|---------|-------------|
| [Getting Started](./docs/getting-started/) | Cài đặt và bắt đầu |
| [Guides](./docs/guides/) | Hướng dẫn chi tiết |
| [Agents](./docs/agents/) | Agent documentation |
| [Reference](./docs/reference/) | Technical specs |
| [Contributing](./docs/contributing/) | Đóng góp code |
| [FAQ](./docs/faq.md) | Câu hỏi thường gặp |

**Documentation Hub:** [docs/README.md](./docs/README.md)

---

## Quick Examples

### Create Agent

```yaml
# .claude/agents/reviewer.md
---
name: code-reviewer
description: "Use for code review"
tools: Read, Grep
---

# Code Reviewer
Review code for quality and security.
```

### Create Command

```yaml
# .claude/commands/review.md
---
description: "Review code changes"
---

Review git diff for issues.
Focus on: $ARGUMENTS
```

### Use Agent

```
/microai:go:go-dev
```

---

## Contributing

Xem [Contributing Guide](./docs/contributing/submitting-pr.md).

---

## Support

- **Documentation:** [docs/](./docs/)
- **Issues:** https://github.com/taipm/dev-team/issues
- **NPM:** https://www.npmjs.com/package/@microai.club/dev-team

---

## License

MIT
