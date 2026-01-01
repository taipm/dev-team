#!/bin/bash
# ============================================================================
# MicroAI Hook: Log File Changes
# Type: PostToolUse
# Matcher: Write|Edit
# Description: Logs all file modifications for tracking and audit
# ============================================================================

# Configuration
LOG_DIR=".microai/logs"
LOG_FILE="$LOG_DIR/file-changes.log"
MAX_LOG_SIZE=10485760  # 10MB

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Rotate log if too large
if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d_%H%M%S').bak"
fi

# Read tool input from stdin
INPUT=$(cat)

# Extract information from tool input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Determine operation type
case "$TOOL_NAME" in
    "Write")
        OPERATION="WRITE"
        ;;
    "Edit")
        OPERATION="EDIT"
        ;;
    *)
        OPERATION="MODIFY"
        ;;
esac

# Log the file change with timestamp
if [ -n "$FILE_PATH" ]; then
    {
        echo "========================================"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Operation: $OPERATION"
        echo "File: $FILE_PATH"

        # Get file info if exists
        if [ -f "$FILE_PATH" ]; then
            SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
            echo "Size: $SIZE bytes"
        fi

        echo "========================================"
    } >> "$LOG_FILE"
fi

# Always exit 0 - this is a logging hook
exit 0
