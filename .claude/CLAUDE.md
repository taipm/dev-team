# Dev Team Project

## Overview
This is the dev-team project configuration for Claude Code.

## Project Structure
```
dev-team/
├── .claude/           # Claude Code configuration
│   ├── agents/        # Custom agent definitions
│   ├── skills/        # Custom skills
│   └── commands/      # Custom slash commands
├── docs/              # Project documentation
└── microai/           # MicroAI agent system (separate)
```

## Development Guidelines

### Code Style
- Use clear, descriptive names
- Follow existing patterns in the codebase
- Write self-documenting code

### Working with Claude Code
- Use agents in `.claude/agents/` for specialized tasks
- Use skills in `.claude/skills/` for reusable workflows
- Check `settings.json` for team-shared permissions

## Quick Start

### Creating a new agent
1. Create a file in `.claude/agents/` with `.md` extension
2. Add YAML frontmatter with `name`, `description`, `tools`
3. Write system prompt in markdown body

### Creating a new skill
1. Create a folder in `.claude/skills/`
2. Add `SKILL.md` with frontmatter
3. Add supporting files as needed

## Security Notes
- Never commit `.env` files
- Use `settings.local.json` for personal overrides
- Sensitive files are denied by default in `settings.json`
