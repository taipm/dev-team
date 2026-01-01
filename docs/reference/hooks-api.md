# Hooks API Reference

API reference cho Claude Code hooks system.

---

## Hook Types

| Type | Trigger | Use Case |
|------|---------|----------|
| `PreToolUse` | Before tool execution | Validate, log, block |
| `PostToolUse` | After tool execution | Log, cleanup |
| `UserPromptSubmit` | When user sends prompt | Log, preprocess |
| `SessionStart` | When session starts | Initialize, setup |

---

## Configuration

Hooks được cấu hình trong `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...],
    "SessionStart": [...]
  }
}
```

---

## Hook Definition

```json
{
  "matcher": "ToolPattern",
  "hooks": [
    {
      "type": "command",
      "command": "path/to/script.sh"
    }
  ]
}
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `matcher` | string | Tool pattern to match |
| `hooks` | array | List of hook commands |
| `hooks[].type` | string | Must be "command" |
| `hooks[].command` | string | Path to script |

---

## Matchers

### Exact Match

```json
{
  "matcher": "Bash"
}
```

Matches only `Bash` tool.

### OR Pattern

```json
{
  "matcher": "Write|Edit"
}
```

Matches `Write` or `Edit`.

### Wildcard

```json
{
  "matcher": "*"
}
```

Matches all tools.

### Common Matchers

| Matcher | Matches |
|---------|---------|
| `Bash` | Bash commands |
| `Write` | Write tool |
| `Edit` | Edit tool |
| `Read` | Read tool |
| `Write\|Edit` | Write or Edit |
| `*` | All tools |

---

## Hook Input

Hooks receive JSON via stdin:

### PreToolUse / PostToolUse

```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm install"
  },
  "session_id": "abc123",
  "timestamp": "2025-01-01T00:00:00Z"
}
```

### UserPromptSubmit

```json
{
  "prompt": "User's message",
  "session_id": "abc123",
  "timestamp": "2025-01-01T00:00:00Z"
}
```

### SessionStart

```json
{
  "session_id": "abc123",
  "working_directory": "/path/to/project",
  "timestamp": "2025-01-01T00:00:00Z"
}
```

---

## Hook Output

### Exit Codes

| Code | Meaning | Effect |
|------|---------|--------|
| 0 | Success | Operation continues |
| 1 | Block | Operation blocked (PreToolUse only) |
| Other | Error | Logged, operation continues |

### Stderr

Messages written to stderr are shown to user:

```bash
echo "Warning: Dangerous command" >&2
exit 1
```

### Stdout

Stdout is ignored by Claude Code.

---

## Script Template

```bash
#!/bin/bash

# Read JSON input
INPUT=$(cat)

# Parse with jq
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Your logic here
if [[ "$COMMAND" =~ "dangerous" ]]; then
    echo "Blocked: dangerous command detected" >&2
    exit 1
fi

# Allow operation
exit 0
```

---

## Full Configuration Example

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/log-bash-commands.sh"
          },
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/block-dangerous.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/pre-tool-use/protect-sensitive.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/post-tool-use/log-file-changes.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/user-prompt-submit/log-prompts.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".microai/hooks/session-start/init-env.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Tool Input Schema

### Bash

```json
{
  "tool_input": {
    "command": "string",
    "timeout": "number (optional)"
  }
}
```

### Write

```json
{
  "tool_input": {
    "file_path": "string",
    "content": "string"
  }
}
```

### Edit

```json
{
  "tool_input": {
    "file_path": "string",
    "old_string": "string",
    "new_string": "string"
  }
}
```

### Read

```json
{
  "tool_input": {
    "file_path": "string",
    "offset": "number (optional)",
    "limit": "number (optional)"
  }
}
```

---

## Common Patterns

### Logging Hook

```bash
#!/bin/bash
INPUT=$(cat)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

echo "[$TIMESTAMP] $COMMAND" >> .microai/logs/commands.log
exit 0
```

### Blocking Hook

```bash
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block rm -rf /
if [[ "$COMMAND" =~ "rm -rf /" ]]; then
    echo "BLOCKED: Cannot delete root" >&2
    exit 1
fi

exit 0
```

### Sensitive File Protection

```bash
#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Block .env files
if [[ "$FILE_PATH" =~ \.env ]]; then
    echo "BLOCKED: Cannot modify .env files" >&2
    exit 1
fi

exit 0
```

---

## Debugging

### Test Hook Manually

```bash
echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | ./hook.sh
echo $?  # Check exit code
```

### Enable Verbose Logging

Add to script:

```bash
exec 2>>.microai/logs/hook-debug.log
set -x
```

---

## Tiếp theo

- [CLI Commands](./cli-commands.md)
- [Sử dụng Hooks](../guides/using-hooks.md)
- [Cấu hình](../getting-started/configuration.md)
