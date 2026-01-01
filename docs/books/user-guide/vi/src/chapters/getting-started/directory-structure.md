# Cấu Trúc Thư Mục

Tổng quan về cấu trúc thư mục sau khi cài đặt dev-team.

## Hai Thư Mục Chính

```
your-project/
├── .claude/          # Claude Code configuration
└── .microai/         # MicroAI framework
```

## .claude/ - Claude Code Configuration

```
.claude/
├── CLAUDE.md           # Project context cho Claude Code
├── settings.json       # Team settings (shared)
├── settings.local.json # Personal settings (git ignored)
├── agents/             # Claude Code agents
│   └── README.md
├── skills/             # Claude Code skills
│   └── README.md
└── commands/           # Slash commands
    └── microai/        # MicroAI commands
        ├── deep-question.md
        ├── deep-thinking.md
        └── ...
```

## .microai/ - MicroAI Framework

```
.microai/
├── settings.json        # Framework settings
├── settings.local.json  # Personal settings (git ignored)
├── agents/              # Agent definitions
│   ├── father-agent/
│   ├── npm-agent/
│   └── microai/
│       └── teams/       # Team definitions
├── commands/            # Additional commands
├── hooks/               # Automation hooks
├── kanban/              # Task boards
├── knowledge/           # Shared knowledge
└── logs/                # Logs (git ignored)
```

## Files Quan Trọng

| File | Mục đích |
|------|----------|
| `.claude/CLAUDE.md` | Project context |
| `.claude/settings.json` | Shared permissions |
| `.microai/agents/*/agent.md` | Agent definitions |
| `.microai/agents/microai/teams/*/workflow.md` | Team workflows |

## Xem Thêm

- [settings.json](./settings-json.md)
- [settings.local.json](./settings-local.md)
