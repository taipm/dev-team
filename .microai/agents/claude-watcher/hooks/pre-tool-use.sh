#!/bin/bash
# Claude Watcher - Pre-Tool-Use Hook
# Observe tool calls BEFORE execution
#
# This hook captures:
# - Tool name being called
# - Tool parameters
# - Timestamp
# - Session ID
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
PARAMS=$(echo "$INPUT" | jq -c '.tool_input // {}')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Skip if this is the watcher itself to prevent loops
if [[ "$PARAMS" == *"claude-watcher"* ]]; then
    exit 0
fi

# Create observation record
OBSERVATION=$(jq -n \
    --arg ts "$TIMESTAMP" \
    --arg type "pre" \
    --arg tool "$TOOL" \
    --argjson params "$PARAMS" \
    --arg session "$SESSION_ID" \
    '{ts: $ts, type: $type, tool: $tool, params: $params, session: $session}')

# Append to observations log
echo "$OBSERVATION" >> "$OBSERVATIONS_FILE"

# Update metrics (non-blocking)
"$WATCHER_DIR/scripts/observer.sh" update_metrics "$TOOL" &>/dev/null &

# Check trigger conditions (non-blocking)
"$WATCHER_DIR/scripts/trigger.sh" check &>/dev/null &

# Always exit 0 - never block tool execution
exit 0
