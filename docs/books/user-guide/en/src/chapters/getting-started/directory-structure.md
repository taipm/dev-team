# Directory Structure

Overview of directory structure after installation.

## Two Main Directories

```
your-project/
├── .claude/          # Claude Code configuration
└── .microai/         # MicroAI framework
```

## .claude/ - Claude Code Configuration

```
.claude/
├── CLAUDE.md           # Project context for Claude Code
├── settings.json       # Team settings (shared)
├── settings.local.json # Personal settings (git ignored)
├── agents/             # Claude Code agents
├── skills/             # Claude Code skills
└── commands/           # Slash commands
    └── microai/        # MicroAI commands
```

## .microai/ - MicroAI Framework

```
.microai/
├── settings.json        # Framework settings
├── agents/              # Agent definitions
│   ├── father-agent/
│   ├── npm-agent/
│   └── microai/
│       └── teams/       # Team definitions
├── commands/            # Additional commands
├── hooks/               # Automation hooks
├── kanban/              # Task boards
└── knowledge/           # Shared knowledge
```

## Important Files

| File | Purpose |
|------|---------|
| `.claude/CLAUDE.md` | Project context |
| `.claude/settings.json` | Shared permissions |
| `.microai/agents/*/agent.md` | Agent definitions |
| `.microai/agents/microai/teams/*/workflow.md` | Team workflows |

## See Also

- [settings.json](./settings-json.md)
- [settings.local.json](./settings-local.md)
