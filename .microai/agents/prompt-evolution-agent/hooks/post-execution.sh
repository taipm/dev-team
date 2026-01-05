#!/bin/bash
# SEPA - Post Execution Hook
# Log execution metrics and trigger evolution when threshold reached
#
# This hook:
# 1. Logs tool execution metrics
# 2. Counts executions since last evolution
# 3. Triggers evolution cycle when count >= 3

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$AGENT_DIR/memory"
SCRIPTS_DIR="$AGENT_DIR/scripts"

# Files
EXECUTIONS_FILE="$MEMORY_DIR/executions.jsonl"
CONTEXT_FILE="$MEMORY_DIR/context.md"
SCORES_FILE="$MEMORY_DIR/scores.yaml"

# Config
EVOLUTION_INTERVAL=3

# Ensure directories exist
mkdir -p "$MEMORY_DIR"

# Read input from stdin (JSON from Claude Code)
INPUT=$(cat)

# Parse JSON fields
TOOL=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
EXIT_CODE=$(echo "$INPUT" | jq -r '.exit_code // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Skip self-references to prevent loops
PARAMS=$(echo "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null || echo "{}")
if [[ "$PARAMS" == *"prompt-evolution"* ]] || [[ "$TOOL" == *"prompt-evolution"* ]]; then
    exit 0
fi

# Skip certain tools that don't indicate real work
SKIP_TOOLS=("TodoWrite" "AskUserQuestion")
for skip in "${SKIP_TOOLS[@]}"; do
    if [[ "$TOOL" == "$skip" ]]; then
        exit 0
    fi
done

# Get current version from context
CURRENT_VERSION="v001"
if [ -f "$CONTEXT_FILE" ]; then
    CURRENT_VERSION=$(grep -oP 'current_version:\s*\K[^\s]+' "$CONTEXT_FILE" 2>/dev/null || echo "v001")
fi

# Determine success
SUCCESS="true"
if [ "$EXIT_CODE" != "0" ]; then
    SUCCESS="false"
fi

# Create execution record
EXECUTION=$(jq -n \
    --arg ts "$TIMESTAMP" \
    --arg tool "$TOOL" \
    --arg exit "$EXIT_CODE" \
    --arg success "$SUCCESS" \
    --arg version "$CURRENT_VERSION" \
    --arg session "$SESSION_ID" \
    '{ts: $ts, tool: $tool, exit: $exit, success: $success, version: $version, session: $session}')

# Append to executions log
echo "$EXECUTION" >> "$EXECUTIONS_FILE"

# Count executions since last evolution
EXECUTION_COUNT=$(wc -l < "$EXECUTIONS_FILE" 2>/dev/null | tr -d ' ' || echo "0")

# Check if evolution should trigger
if [ "$EXECUTION_COUNT" -ge "$EVOLUTION_INTERVAL" ]; then
    # Trigger evolution in background
    if [ -f "$SCRIPTS_DIR/evolve.sh" ]; then
        "$SCRIPTS_DIR/evolve.sh" &>/dev/null &
    fi
fi

# Always exit 0 - hooks should not block
exit 0
