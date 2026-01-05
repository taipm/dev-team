#!/bin/bash
# Claude Watcher - User-Prompt-Submit Hook
# Observe user prompts as they are submitted
#
# This hook captures:
# - User prompt content
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
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
USER_NAME=$(echo "$INPUT" | jq -r '.user_name // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Skip if prompt is about watcher itself (prevent loops)
if [[ "$PROMPT" == *"/watcher"* ]]; then
    exit 0
fi

# Truncate prompt to prevent huge logs
PROMPT_TRUNCATED=$(echo "$PROMPT" | head -c 500)

# Create observation record
OBSERVATION=$(jq -n \
    --arg ts "$TIMESTAMP" \
    --arg type "prompt" \
    --arg prompt "$PROMPT_TRUNCATED" \
    --arg user "$USER_NAME" \
    --arg session "$SESSION_ID" \
    '{ts: $ts, type: $type, prompt: $prompt, user: $user, session: $session}')

# Append to observations log
echo "$OBSERVATION" >> "$OBSERVATIONS_FILE"

# Always exit 0 - never block user prompts
exit 0
