#!/bin/bash
# ============================================================================
# MicroAI Hook: Block Dangerous Commands
# Type: PreToolUse
# Matcher: Bash
# Description: Prevents execution of potentially destructive commands
# ============================================================================

# Read tool input from stdin
INPUT=$(cat)

# Extract command from tool input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# If no command, allow
if [ -z "$COMMAND" ]; then
    exit 0
fi

# ============================================================================
# Dangerous patterns to block
# ============================================================================

# Pattern 1: rm -rf with root or important paths
if echo "$COMMAND" | grep -qE 'rm\s+(-[rRf]+\s+)*(/|/\*|~/|/usr|/etc|/var|/home|/System|/Library)'; then
    echo "BLOCKED: Cannot delete system directories" >&2
    exit 1
fi

# Pattern 2: Force push to protected branches
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master|develop|production)'; then
    echo "BLOCKED: Force push to protected branch not allowed" >&2
    exit 1
fi

if echo "$COMMAND" | grep -qE 'git\s+push\s+-f\s+.*\s+(main|master|develop|production)'; then
    echo "BLOCKED: Force push to protected branch not allowed" >&2
    exit 1
fi

# Pattern 3: Dangerous SQL operations without WHERE clause
if echo "$COMMAND" | grep -qiE "(DELETE\s+FROM|DROP\s+TABLE|DROP\s+DATABASE|TRUNCATE)" | grep -qvE "WHERE"; then
    echo "BLOCKED: Dangerous SQL operation without WHERE clause" >&2
    exit 1
fi

# Pattern 4: chmod 777 (security risk)
if echo "$COMMAND" | grep -qE 'chmod\s+777\s+'; then
    echo "BLOCKED: chmod 777 is a security risk" >&2
    exit 1
fi

# Pattern 5: Pipe curl to shell (security risk)
if echo "$COMMAND" | grep -qE 'curl.*\|\s*(bash|sh|zsh)'; then
    echo "BLOCKED: Piping curl to shell is dangerous" >&2
    exit 1
fi

# Pattern 6: Format disk
if echo "$COMMAND" | grep -qE '(mkfs|fdisk|diskutil\s+eraseDisk)'; then
    echo "BLOCKED: Disk formatting commands not allowed" >&2
    exit 1
fi

# Pattern 7: Modify /etc/passwd or /etc/shadow
if echo "$COMMAND" | grep -qE '(cat|echo|>|>>)\s+.*/etc/(passwd|shadow|sudoers)'; then
    echo "BLOCKED: Cannot modify system authentication files" >&2
    exit 1
fi

# Pattern 8: Kill all processes
if echo "$COMMAND" | grep -qE 'killall\s+-9\s+\*|pkill\s+-9\s+'; then
    echo "BLOCKED: Mass process killing not allowed" >&2
    exit 1
fi

# All checks passed, allow command
exit 0
