# Initial Configuration

Post-installation configuration guide.

## Configuration Files

| File | Purpose | Commit to Git? |
|------|---------|----------------|
| `.claude/settings.json` | Team settings | Yes |
| `.claude/settings.local.json` | Personal settings | No |
| `.microai/settings.json` | Framework settings | Yes |
| `.microai/settings.local.json` | Personal settings | No |

## settings.json

Team-shared configuration:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)"
    ],
    "deny": [
      "Read(.env)"
    ]
  }
}
```

## settings.local.json

Personal configuration (not committed):

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)"
    ]
  }
}
```

## Create settings.local.json

```bash
echo '{
  "permissions": {
    "allow": []
  }
}' > .claude/settings.local.json
```

## Update .gitignore

Ensure local files are ignored:

```
# Claude Code local settings
.claude/settings.local.json

# MicroAI local settings
.microai/settings.local.json
.microai/logs/
```

## See Also

- [Directory Structure](./directory-structure.md)
- [settings.json Reference](./settings-json.md)
