#!/bin/bash
# Claude Watcher - Post-Tool-Use Hook
# Observe tool results AFTER execution
#
# This hook captures:
# - Tool name that was called
# - Tool output (truncated to 1000 chars)
# - Exit code
# - Timestamp
#
# Output: Appends to observations.jsonl

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WATCHER_DIR/memory"
OBSERVATIONS_FILE="$MEMORY_DIR/observations.jsonl"

# Ensure memory directory exists
mkdir -p "$MEMORY_DIR"

# Read input from stdin (JSON from Claude Code)
INPUT=$(cat)

# Parse JSON fields
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
# Truncate output to prevent huge logs
OUTPUT=$(echo "$INPUT" | jq -c '.tool_output // ""' | head -c 1000)
EXIT_CODE=$(echo "$INPUT" | jq -r '.exit_code // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Skip if this is the watcher itself to prevent loops
PARAMS=$(echo "$INPUT" | jq -c '.tool_input // {}')
if [[ "$PARAMS" == *"claude-watcher"* ]]; then
    exit 0
fi

# Create observation record
OBSERVATION=$(jq -n \
    --arg ts "$TIMESTAMP" \
    --arg type "post" \
    --arg tool "$TOOL" \
    --arg output "$OUTPUT" \
    --arg exit_code "$EXIT_CODE" \
    --arg session "$SESSION_ID" \
    '{ts: $ts, type: $type, tool: $tool, output: $output, exit: $exit_code, session: $session}')

# Append to observations log
echo "$OBSERVATION" >> "$OBSERVATIONS_FILE"

# Record error if exit code != 0
if [ "$EXIT_CODE" != "0" ]; then
    "$WATCHER_DIR/scripts/observer.sh" record_error "$TOOL" "$EXIT_CODE" &>/dev/null &
fi

# Always exit 0 - post hooks don't block
exit 0
