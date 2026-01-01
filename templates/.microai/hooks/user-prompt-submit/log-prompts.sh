#!/bin/bash
# ============================================================================
# MicroAI Hook: Log User Prompts
# Type: UserPromptSubmit
# Description: Logs all user prompts for history and analysis
# ============================================================================

# Configuration
LOG_DIR=".microai/logs"
LOG_FILE="$LOG_DIR/prompts.log"
MAX_LOG_SIZE=10485760  # 10MB
MAX_PROMPT_LENGTH=500  # Truncate long prompts in log

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Rotate log if too large
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d_%H%M%S').bak"
fi

# Read input from stdin
INPUT=$(cat)

# Extract prompt text from JSON
# Claude Code passes: {"prompt": "user's text", "session_id": "...", ...}
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# If no prompt extracted, try alternative formats
if [ -z "$PROMPT" ]; then
    PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // empty' 2>/dev/null)
fi

# Log the prompt if we got something
if [ -n "$PROMPT" ]; then
    # Truncate if too long (for log readability)
    if [ ${#PROMPT} -gt $MAX_PROMPT_LENGTH ]; then
        PROMPT="${PROMPT:0:$MAX_PROMPT_LENGTH}... [truncated]"
    fi

    # Escape newlines for single-line logging
    PROMPT_ESCAPED=$(echo "$PROMPT" | tr '\n' ' ' | sed 's/  */ /g')

    {
        echo "========================================"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Prompt: $PROMPT_ESCAPED"
        echo "========================================"
    } >> "$LOG_FILE"
fi

# Always exit 0 - this is a logging hook
exit 0
