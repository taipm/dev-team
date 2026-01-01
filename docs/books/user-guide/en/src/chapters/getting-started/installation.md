# Installation

Guide to installing **@microai.club/dev-team** in your project.

## System Requirements

Before installation, ensure you have:

| Requirement | Version | Notes |
|-------------|---------|-------|
| Node.js | >= 18.0.0 | [Download](https://nodejs.org/) |
| npm | >= 8.0.0 | Comes with Node.js |
| Claude Code | Latest | [Installation guide](https://claude.ai/code) |

### Check Current Versions

```bash
# Check Node.js
node --version  # Result: v18.x.x or higher

# Check npm
npm --version   # Result: 8.x.x or higher
```

## Quick Installation

### Using npx (Recommended)

```bash
# Navigate to your project directory
cd your-project

# Run the installer
npx @microai.club/dev-team@alpha install
```

### Global Installation

```bash
# Install the package
npm install -g @microai.club/dev-team@alpha

# Run the installer
dev-team install
```

## Installation Process

When running `dev-team install`, you'll see:

### 1. Component Selection

```
? Select components to install:
  ◉ CLAUDE.md (project context)
  ◉ settings.json (team configuration)
  ◉ agents/ (agent templates)
  ◉ skills/ (skill templates)
  ◉ commands/ (slash commands)
  ◉ MicroAI Framework (.microai/)
  ◉ Hooks (automation)
```

### 2. Handle Existing Directories

If your project already has `.claude/` or `.microai/`:

```
? Directory .claude/ already exists. What do you want to do?
  ❯ Merge (keep existing, add new)
    Overwrite (replace all)
    Cancel
```

> **Recommended**: Choose **Merge** to preserve your existing configuration.

### 3. Completion

```
✔ Installation successful!

Created structure:
├── .claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── agents/
│   ├── skills/
│   └── commands/
└── .microai/
    ├── agents/
    ├── commands/
    ├── hooks/
    └── kanban/
```

## Installation Options

### Non-interactive Mode

```bash
# Install everything without prompts
dev-team install --no-interactive
```

### Force Overwrite

```bash
# Overwrite all existing files
dev-team install --force
```

### Custom Path

```bash
# Install to a different directory
dev-team install --path /path/to/project
```

### Combined Options

```bash
# Force install to specific path
dev-team install --path /path/to/project --force --no-interactive
```

## Post-Installation

### 1. Configure settings.local.json

Create `.claude/settings.local.json` for personal configuration:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)"
    ]
  }
}
```

> **Note**: This file should not be committed to git.

### 2. Add to .gitignore

The installer automatically adds to `.gitignore`:

```
# Claude Code local settings
.claude/settings.local.json

# MicroAI local settings
.microai/settings.local.json
.microai/logs/
```

### 3. Verify Installation

```bash
# List installed components
dev-team list
```

## Uninstallation

To remove dev-team from your project:

```bash
# Remove directories
rm -rf .claude/ .microai/
```

> **Warning**: This will delete all agents, skills, and custom configurations.

## Troubleshooting

### "command not found" Error

```bash
# Try with npx
npx @microai.club/dev-team@alpha install

# Or check PATH
echo $PATH
```

### Permission Denied Error

```bash
# Add execute permission to hooks
chmod +x .microai/hooks/**/*.sh
```

### npm Registry Error

```bash
# Check registry
npm config get registry

# Reset to default if needed
npm config set registry https://registry.npmjs.org/
```

## Next Steps

- [Verify Installation](./verification.md)
- [Initial Configuration](./configuration.md)
- [5-Minute Quickstart](./quickstart.md)
