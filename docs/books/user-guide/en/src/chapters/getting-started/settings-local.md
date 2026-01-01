# settings.local.json

Personal configuration for dev-team.

## Location

```
.claude/settings.local.json
.microai/settings.local.json
```

## Purpose

- Personal settings for each developer
- Not committed to git
- Overrides settings from `settings.json`

## Structure

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)"
    ]
  }
}
```

## Examples

### Allow additional commands

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)",
      "Bash(kubectl:*)",
      "Bash(make:*)"
    ]
  }
}
```

### Debug mode

```json
{
  "debug": true,
  "logLevel": "verbose"
}
```

## Create File

```bash
echo '{
  "permissions": {
    "allow": []
  }
}' > .claude/settings.local.json
```

## Gitignore

Ensure file is ignored:

```bash
# In .gitignore
.claude/settings.local.json
.microai/settings.local.json
```

## See Also

- [settings.json](./settings-json.md)
- [Initial Configuration](./configuration.md)
