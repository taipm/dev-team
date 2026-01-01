# 09 - Hooks System | Hệ thống Hooks

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Hooks System enables **automation and extension** by executing custom commands at specific events during agent execution.

Hệ thống Hooks cho phép **tự động hóa và mở rộng** bằng cách thực thi các lệnh tùy chỉnh tại các sự kiện cụ thể trong quá trình thực thi agent.

---

## Hook Types | Các loại Hook

| Hook | Trigger | Use Cases |
|------|---------|-----------|
| `PreToolUse` | Before tool execution | Logging, validation, blocking |
| `PostToolUse` | After tool execution | Logging, cleanup, notifications |
| `UserPromptSubmit` | On user message | Prompt logging, context injection |
| `SessionStart` | On session begin | Environment setup, welcome message |
| `SessionEnd` | On session close | Cleanup, archiving, statistics |

---

## Configuration | Cấu hình

### In settings.json | Trong settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "echo \"[$(date -Iseconds)] Bash: $INPUT\" >> /tmp/bash-log.txt"
      },
      {
        "matcher": "Read",
        "command": "echo \"[$(date -Iseconds)] Read: $INPUT\" >> /tmp/access-log.txt"
      }
    ],

    "PostToolUse": [
      {
        "matcher": "Edit",
        "command": "echo \"[$(date -Iseconds)] Edited: $INPUT\" >> /tmp/changes-log.txt"
      }
    ],

    "UserPromptSubmit": [
      {
        "command": "echo \"$PROMPT\" >> /tmp/prompts.txt"
      }
    ],

    "SessionStart": [
      {
        "command": "echo \"Session started: $SESSION_ID at $TIMESTAMP\" >> /tmp/sessions.txt"
      }
    ],

    "SessionEnd": [
      {
        "command": "echo \"Session ended: $SESSION_ID\" >> /tmp/sessions.txt"
      }
    ]
  }
}
```

---

## Hook Schema | Schema Hook

### Hook Entry | Entry Hook

```typescript
interface HookEntry {
  // Matcher: which tool/event this hook applies to
  // Matcher: hook này áp dụng cho tool/event nào
  matcher?: string;           // Tool name pattern (PreToolUse/PostToolUse only)

  // Command: shell command to execute
  // Command: lệnh shell để thực thi
  command: string;

  // Optional: timeout in milliseconds
  // Tùy chọn: timeout tính bằng milliseconds
  timeout?: number;           // Default: 5000ms

  // Optional: continue on failure
  // Tùy chọn: tiếp tục khi thất bại
  continueOnFailure?: boolean; // Default: true

  // Optional: run condition
  // Tùy chọn: điều kiện chạy
  condition?: string;         // Shell command, run hook if exit code 0
}
```

### Complete Schema | Schema đầy đủ

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "validation-script.sh $INPUT",
        "timeout": 3000,
        "continueOnFailure": false
      }
    ],
    "PostToolUse": [...],
    "UserPromptSubmit": [...],
    "SessionStart": [...],
    "SessionEnd": [...]
  }
}
```

---

## Available Variables | Các biến khả dụng

### Tool Hooks (PreToolUse, PostToolUse)

| Variable | Description | Example |
|----------|-------------|---------|
| `$TOOL_NAME` | Name of tool being invoked | `Bash`, `Read`, `Edit` |
| `$INPUT` | Tool input parameters (JSON) | `{"command":"git status"}` |
| `$OUTPUT` | Tool output (PostToolUse only) | `{...result...}` |
| `$TIMESTAMP` | ISO timestamp | `2025-12-31T10:30:00Z` |
| `$SESSION_ID` | Current session ID | `abc123` |

### User Hooks (UserPromptSubmit)

| Variable | Description | Example |
|----------|-------------|---------|
| `$PROMPT` | User's prompt text | `Fix the bug in auth` |
| `$TIMESTAMP` | ISO timestamp | `2025-12-31T10:30:00Z` |
| `$SESSION_ID` | Current session ID | `abc123` |
| `$USER_NAME` | User name | `taipm` |

### Session Hooks (SessionStart, SessionEnd)

| Variable | Description | Example |
|----------|-------------|---------|
| `$SESSION_ID` | Current session ID | `abc123` |
| `$TIMESTAMP` | ISO timestamp | `2025-12-31T10:30:00Z` |
| `$PROJECT_ROOT` | Project directory | `/Users/dev/project` |
| `$PLATFORM` | Adapter platform | `claude-code` |
| `$AGENT_NAME` | Active agent (if any) | `go-dev` |

---

## Matcher Patterns | Các pattern Matcher

### Tool Matching | Khớp Tool

```json
{
  "matcher": "Bash"           // Exact tool name
}

{
  "matcher": "Bash(git:*)"    // Tool with parameter pattern
}

{
  "matcher": "*"              // All tools
}
```

### Pattern Examples | Ví dụ pattern

```json
{
  "PreToolUse": [
    // All Bash commands
    {
      "matcher": "Bash",
      "command": "log-bash.sh \"$INPUT\""
    },

    // Only git commands
    {
      "matcher": "Bash(git:*)",
      "command": "log-git.sh \"$INPUT\""
    },

    // All file reads
    {
      "matcher": "Read",
      "command": "log-access.sh \"$INPUT\""
    },

    // All tools (catch-all)
    {
      "matcher": "*",
      "command": "log-all.sh \"$TOOL_NAME\" \"$INPUT\""
    }
  ]
}
```

---

## Hook Execution | Thực thi Hook

### Execution Flow | Luồng thực thi

```
┌─────────────────────────────────────────────────────────────┐
│ TOOL INVOCATION: Edit("file.go", "old", "new")             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ PreToolUse Hooks                                            │
│ ════════════════                                            │
│ 1. Find matching hooks for "Edit"                          │
│ 2. Execute each hook in order                              │
│ 3. If any hook returns non-zero AND continueOnFailure=false│
│    → BLOCK tool execution                                   │
│ 4. Otherwise → continue to tool                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ TOOL EXECUTION                                              │
│ ════════════════                                            │
│ Execute the actual Edit tool                                │
│ Capture result                                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ PostToolUse Hooks                                           │
│ ═════════════════                                           │
│ 1. Find matching hooks for "Edit"                          │
│ 2. Execute each hook with $OUTPUT available                │
│ 3. Hooks are fire-and-forget (don't block)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ RETURN RESULT TO AGENT                                      │
└─────────────────────────────────────────────────────────────┘
```

### Blocking Behavior | Hành vi blocking

```python
def execute_pre_tool_hooks(tool: str, input: str, hooks: List[HookEntry]) -> bool:
    """
    Execute PreToolUse hooks. Return True to proceed, False to block.
    Thực thi PreToolUse hooks. Trả về True để tiếp tục, False để chặn.
    """
    matching_hooks = [h for h in hooks if matches_tool(h.matcher, tool, input)]

    for hook in matching_hooks:
        env = {
            "TOOL_NAME": tool,
            "INPUT": json.dumps(input),
            "TIMESTAMP": get_iso_timestamp(),
            "SESSION_ID": get_session_id()
        }

        result = execute_shell(
            hook.command,
            env=env,
            timeout=hook.timeout or 5000
        )

        # If hook fails and continueOnFailure is False, block the tool
        if result.exit_code != 0 and not hook.continueOnFailure:
            log_warning(f"PreToolUse hook blocked {tool}: {hook.command}")
            return False

    return True
```

---

## Common Use Cases | Các trường hợp sử dụng phổ biến

### 1. Audit Logging | Ghi log kiểm tra

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "command": "jq -nc --arg tool \"$TOOL_NAME\" --arg input \"$INPUT\" --arg ts \"$TIMESTAMP\" '{timestamp: $ts, tool: $tool, input: $input}' >> audit.jsonl"
      }
    ],
    "UserPromptSubmit": [
      {
        "command": "jq -nc --arg prompt \"$PROMPT\" --arg ts \"$TIMESTAMP\" '{timestamp: $ts, type: \"prompt\", content: $prompt}' >> audit.jsonl"
      }
    ]
  }
}
```

### 2. Command Validation | Kiểm tra lệnh

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "validate-bash.sh \"$INPUT\"",
        "continueOnFailure": false
      }
    ]
  }
}
```

```bash
#!/bin/bash
# validate-bash.sh - Block dangerous commands

INPUT="$1"

# Check for dangerous patterns
if echo "$INPUT" | grep -qE "(rm -rf /|sudo|chmod 777)"; then
    echo "BLOCKED: Dangerous command detected"
    exit 1
fi

exit 0
```

### 3. Notifications | Thông báo

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "notify-file-change.sh \"$INPUT\""
      }
    ],
    "SessionEnd": [
      {
        "command": "notify-session-end.sh \"$SESSION_ID\""
      }
    ]
  }
}
```

### 4. Automatic Backup | Backup tự động

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "command": "backup-before-edit.sh \"$INPUT\""
      }
    ]
  }
}
```

```bash
#!/bin/bash
# backup-before-edit.sh - Create backup before editing

INPUT="$1"
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path')

if [ -f "$FILE_PATH" ]; then
    BACKUP_DIR=".backups/$(date +%Y-%m-%d)"
    mkdir -p "$BACKUP_DIR"
    cp "$FILE_PATH" "$BACKUP_DIR/$(basename $FILE_PATH).$(date +%H%M%S)"
fi
```

### 5. Statistics Collection | Thu thập thống kê

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": "stats-session-start.sh"
      }
    ],
    "SessionEnd": [
      {
        "command": "stats-session-end.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "*",
        "command": "stats-tool-use.sh \"$TOOL_NAME\""
      }
    ]
  }
}
```

### 6. Context Injection | Tiêm context

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": "inject-context.sh"
      }
    ]
  }
}
```

```bash
#!/bin/bash
# inject-context.sh - Output additional context for session

echo "## Project Status"
echo ""
git status --short 2>/dev/null || echo "Not a git repository"
echo ""
echo "## Recent Changes"
git log --oneline -5 2>/dev/null || echo "No git history"
```

---

## Error Handling | Xử lý lỗi

### Hook Failures | Hook thất bại

```python
def handle_hook_error(hook: HookEntry, error: Exception) -> HookResult:
    """
    Handle hook execution errors.
    Xử lý lỗi thực thi hook.
    """
    if hook.continueOnFailure:
        log_warning(f"Hook failed but continuing: {error}")
        return HookResult(success=False, continue_execution=True)
    else:
        log_error(f"Hook failed and blocking: {error}")
        return HookResult(success=False, continue_execution=False)
```

### Timeout Handling | Xử lý timeout

```python
def execute_hook_with_timeout(hook: HookEntry, env: Dict) -> HookResult:
    """
    Execute hook with timeout.
    Thực thi hook với timeout.
    """
    timeout_ms = hook.timeout or 5000  # Default 5 seconds

    try:
        result = run_with_timeout(
            hook.command,
            env=env,
            timeout_ms=timeout_ms
        )
        return HookResult(
            success=result.exit_code == 0,
            output=result.stdout,
            continue_execution=True
        )
    except TimeoutError:
        log_warning(f"Hook timed out after {timeout_ms}ms: {hook.command}")
        return HookResult(
            success=False,
            continue_execution=hook.continueOnFailure
        )
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 3 Compliance | Cho tuân thủ Level 3

Adapters MUST:

1. **Parse hooks configuration**
   - Parse all hook types from settings.json
   - Validate hook entries

2. **Execute hooks at appropriate times**
   - PreToolUse: Before each tool
   - PostToolUse: After each tool
   - UserPromptSubmit: On user message
   - SessionStart/End: Session boundaries

3. **Provide variable substitution**
   - Replace all documented variables
   - Handle special characters in values

4. **Implement timeout handling**
   - Respect timeout configuration
   - Kill hung hooks

5. **Support blocking behavior**
   - PreToolUse can block tool execution
   - Respect continueOnFailure flag

### Hook Execution Algorithm | Thuật toán thực thi Hook

```python
def execute_hooks(
    hook_type: str,
    context: HookContext,
    settings: Settings
) -> HookResult:
    """
    Execute hooks for a given type.
    Thực thi hooks cho loại đã cho.
    """
    hooks = settings.hooks.get(hook_type, [])
    if not hooks:
        return HookResult(success=True)

    for hook in hooks:
        # Check matcher for tool hooks
        if hook_type in ["PreToolUse", "PostToolUse"]:
            if hook.matcher and not matches_tool(hook.matcher, context.tool_name, context.input):
                continue

        # Check condition if specified
        if hook.condition:
            condition_result = execute_shell(hook.condition, timeout=1000)
            if condition_result.exit_code != 0:
                continue

        # Prepare environment
        env = prepare_hook_env(hook_type, context)

        # Execute hook
        result = execute_shell(
            hook.command,
            env=env,
            timeout=hook.timeout or 5000
        )

        # Handle result
        if result.exit_code != 0:
            if not hook.continueOnFailure:
                return HookResult(
                    success=False,
                    blocked=True,
                    message=f"Hook blocked: {result.stderr}"
                )

    return HookResult(success=True)
```

---

## Best Practices | Thực hành tốt nhất

### 1. Keep Hooks Fast | Giữ hooks nhanh

```json
{
  "PreToolUse": [
    {
      "matcher": "*",
      "command": "quick-log.sh \"$INPUT\"",
      "timeout": 1000  // 1 second max
    }
  ]
}
```

### 2. Use continueOnFailure Wisely | Dùng continueOnFailure hợp lý

```json
{
  "PreToolUse": [
    // Logging should never block
    {
      "matcher": "*",
      "command": "log.sh",
      "continueOnFailure": true
    },

    // Security checks should block
    {
      "matcher": "Bash",
      "command": "security-check.sh",
      "continueOnFailure": false
    }
  ]
}
```

### 3. Handle JSON Carefully | Xử lý JSON cẩn thận

```bash
#!/bin/bash
# Use jq for JSON processing
INPUT="$1"

# Safe JSON parsing
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty')
if [ -n "$FILE_PATH" ]; then
    # Process file
fi
```

### 4. Log to Structured Format | Log theo định dạng có cấu trúc

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "command": "jq -nc '{ts: $ENV.TIMESTAMP, tool: $ENV.TOOL_NAME, input: ($ENV.INPUT | fromjson)}' >> hooks.jsonl"
      }
    ]
  }
}
```

---

## Summary | Tóm tắt

| Hook Type | When | Variables | Can Block |
|-----------|------|-----------|-----------|
| PreToolUse | Before tool | TOOL_NAME, INPUT | Yes |
| PostToolUse | After tool | TOOL_NAME, INPUT, OUTPUT | No |
| UserPromptSubmit | On user input | PROMPT | No |
| SessionStart | Session begin | SESSION_ID | No |
| SessionEnd | Session close | SESSION_ID | No |

---

*Next: [10-implementation-guide.md](./10-implementation-guide.md) - Step-by-Step Adapter Building*
