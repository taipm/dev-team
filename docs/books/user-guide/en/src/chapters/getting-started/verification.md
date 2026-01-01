# Verifying Installation

Guide to confirm dev-team is installed correctly.

## Check Directory Structure

```bash
ls -la .claude/ .microai/
```

Expected result:

```
.claude/
├── CLAUDE.md
├── settings.json
├── agents/
├── skills/
└── commands/

.microai/
├── agents/
├── commands/
├── hooks/
└── kanban/
```

## Check in Claude Code

```bash
claude
```

Type:
```
/help
```

If you see commands with `/microai:*`, installation was successful.

## Test First Agent

```
/microai:deep-question
```

The agent will greet you and be ready for questions.

## Troubleshooting

### Commands not visible

Check if `.claude/commands/` has files:
```bash
ls -la .claude/commands/
```

### Permission denied

```bash
chmod +x .microai/hooks/**/*.sh
```

## See Also

- [Initial Configuration](./configuration.md)
- [5-Minute Quickstart](./quickstart.md)
