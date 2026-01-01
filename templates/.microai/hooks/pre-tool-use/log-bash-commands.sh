#!/bin/bash
# ============================================================================
# MicroAI Hook: Log Bash Commands
# Type: PreToolUse
# Matcher: Bash
# Description: Logs all bash commands for audit trail and debugging
# ============================================================================

# Configuration
LOG_DIR=".microai/logs"
LOG_FILE="$LOG_DIR/bash-commands.log"
MAX_LOG_SIZE=10485760  # 10MB

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Rotate log if too large
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d_%H%M%S').bak"
fi

# Read tool input from stdin (Claude Code passes JSON via stdin)
INPUT=$(cat)

# Extract command from tool input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Log the command with timestamp
if [ -n "$COMMAND" ]; then
    {
        echo "========================================"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Command: $COMMAND"
        echo "========================================"
    } >> "$LOG_FILE"
fi

# Always exit 0 - this is a logging hook, should never block
exit 0
