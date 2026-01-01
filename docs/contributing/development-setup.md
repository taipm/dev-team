# Development Setup

Hướng dẫn thiết lập môi trường phát triển cho dev-team.

---

## Yêu cầu

- **Node.js** >= 18.0.0
- **npm** >= 9.0.0
- **Git**
- **Claude Code** (để test)

---

## Clone Repository

```bash
git clone https://github.com/taipm/dev-team.git
cd dev-team
```

---

## Install Dependencies

```bash
npm install
```

---

## Project Structure

```
dev-team/
├── bin/                    # CLI entry point
│   └── cli.js
├── src/                    # Source code
│   ├── commands/           # CLI commands
│   │   ├── install.js
│   │   ├── list.js
│   │   └── update.js
│   └── utils/              # Utility functions
├── templates/              # Installation templates
│   ├── .claude/            # Claude config templates
│   └── .microai/           # MicroAI templates
├── docs/                   # Documentation
├── package.json
└── README.md
```

---

## Development Workflow

### 1. Create Branch

```bash
git checkout -b feature/my-feature
```

### 2. Make Changes

Edit files in `src/` or `templates/`.

### 3. Test Locally

```bash
# Link package globally
npm link

# Test in another project
cd /path/to/test-project
dev-team install
```

### 4. Run Linter

```bash
npm run lint
```

### 5. Commit

```bash
git add .
git commit -m "feat: add new feature"
```

---

## Testing

### Manual Testing

```bash
# Create test directory
mkdir -p /tmp/dev-team-test
cd /tmp/dev-team-test

# Test install
node /path/to/dev-team/bin/cli.js install

# Verify files
ls -la .claude/
ls -la .microai/
```

### Test Hooks

```bash
# Start Claude Code session
claude

# Trigger hooks
# Hooks should log to .microai/logs/
```

---

## Templates

Templates are in `templates/` folder:

| Path | Description |
|------|-------------|
| `templates/.claude/` | Claude Code configuration |
| `templates/.microai/agents/` | Agent templates |
| `templates/.microai/hooks/` | Hook scripts |

### Adding New Template

1. Create file in `templates/`
2. Update `src/commands/install.js` if needed
3. Test installation

---

## Scripts

| Script | Description |
|--------|-------------|
| `npm run lint` | Run ESLint |
| `npm run lint:fix` | Fix linting issues |
| `npm link` | Link for local testing |

---

## Debugging

### Debug CLI

```bash
# Run with Node inspector
node --inspect bin/cli.js install
```

### Debug Hooks

```bash
# Add to hook script
exec 2>>.microai/logs/debug.log
set -x
```

---

## IDE Setup

### VS Code

Recommended extensions:
- ESLint
- Prettier
- Markdown All in One

Settings (`.vscode/settings.json`):

```json
{
  "editor.formatOnSave": true,
  "eslint.validate": ["javascript"]
}
```

---

## Common Tasks

### Add New Agent

1. Create agent file in `templates/.microai/agents/`
2. Follow agent spec format
3. Update `docs/agents/built-in-agents.md`

### Add New Hook

1. Create script in `templates/.microai/hooks/`
2. Make executable: `chmod +x script.sh`
3. Add to `templates/.microai/hooks.json`
4. Update `docs/guides/using-hooks.md`

### Update Documentation

1. Edit files in `docs/`
2. Update `docs/README.md` if adding new pages
3. Check links work

---

## Tiếp theo

- [Code Style](./code-style.md)
- [Submitting PR](./submitting-pr.md)
