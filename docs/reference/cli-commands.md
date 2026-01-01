# CLI Commands Reference

Reference cho các lệnh CLI của @microai.club/dev-team.

---

## Installation

```bash
npm install -g @microai.club/dev-team@alpha
# or
npx @microai.club/dev-team@alpha <command>
```

---

## Commands

### install

Cài đặt dev-team vào project.

```bash
dev-team install [options]
```

#### Options

| Option | Description |
|--------|-------------|
| `--path <path>` | Target directory (default: current) |
| `--no-interactive` | Skip prompts, install all |
| `--force` | Overwrite existing files |

#### Examples

```bash
# Interactive install
dev-team install

# Install to specific path
dev-team install --path /path/to/project

# Non-interactive, install all
dev-team install --no-interactive

# Force overwrite
dev-team install --force
```

#### Components

When running interactively, you can select:

| Component | Description |
|-----------|-------------|
| Claude Config | `.claude/` folder with settings |
| MicroAI Agents | `.microai/agents/` with built-in agents |
| Hooks | `.microai/hooks/` with safety hooks |
| All | All components |

---

### list

Liệt kê các components có sẵn.

```bash
dev-team list
```

#### Output

```
Available components:

Claude Configuration:
  - CLAUDE.md (project context)
  - settings.json (team config)
  - agents/ (custom agents)
  - skills/ (custom skills)
  - commands/ (slash commands)

MicroAI Agents:
  - father-agent
  - go-dev-agent
  - go-refactor-agent
  - github-agent
  - npm-agent
  ...

Hooks:
  - pre-tool-use/
  - post-tool-use/
  - user-prompt-submit/
  - session-start/
```

---

### update

Cập nhật components đã cài đặt.

```bash
dev-team update [options]
```

#### Options

| Option | Description |
|--------|-------------|
| `--path <path>` | Target directory |
| `--component <name>` | Update specific component |

#### Examples

```bash
# Update all
dev-team update

# Update specific component
dev-team update --component hooks
```

---

### help

Hiển thị help.

```bash
dev-team --help
dev-team <command> --help
```

#### Output

```
Usage: dev-team [options] [command]

MicroAI Dev Team - Claude Code configuration toolkit

Options:
  -V, --version    output version number
  -h, --help       display help

Commands:
  install          Install dev-team to your project
  list             List available components
  update           Update installed components
  help [command]   display help for command
```

---

### version

Hiển thị version.

```bash
dev-team --version
# or
dev-team -V
```

---

## NPX Usage

Không cần install global:

```bash
npx @microai.club/dev-team@alpha install
npx @microai.club/dev-team@alpha list
npx @microai.club/dev-team@alpha --help
```

---

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid arguments |

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DEV_TEAM_PATH` | Default install path | Current directory |
| `DEV_TEAM_FORCE` | Force overwrite | false |

---

## Examples

### First Time Setup

```bash
cd my-project
npx @microai.club/dev-team@alpha install
# Select components interactively
```

### CI/CD Setup

```bash
npx @microai.club/dev-team@alpha install --no-interactive --force
```

### Update After Package Update

```bash
npm update @microai.club/dev-team
npx @microai.club/dev-team@alpha update
```

---

## Tiếp theo

- [Cài đặt](../getting-started/installation.md)
- [Cấu hình](../getting-started/configuration.md)
