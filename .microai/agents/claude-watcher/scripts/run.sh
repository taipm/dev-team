#!/bin/bash
# Claude Watcher - Main Orchestration Script
# Central control for the watcher system

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WATCHER_DIR/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"
CONFIG_DIR="$WATCHER_DIR/config"
TEMPLATES_DIR="$WATCHER_DIR/templates"

STATE_FILE="$MEMORY_DIR/state.yaml"
OBSERVATIONS_FILE="$MEMORY_DIR/observations.jsonl"
METRICS_FILE="$MEMORY_DIR/metrics.yaml"
DECISIONS_FILE="$MEMORY_DIR/decisions.md"
COMMAND_FILE="$MEMORY_DIR/next-command.md"

# Initialize watcher system
init() {
    echo "Initializing Claude Watcher..."

    # Create directories
    mkdir -p "$MEMORY_DIR/archive"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$TEMPLATES_DIR"

    # Initialize observations file
    touch "$OBSERVATIONS_FILE"

    # Initialize state
    cat > "$STATE_FILE" << EOF
# Claude Watcher State
goal: ""
started_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
last_think_timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
last_think_at_count: 0
total_interventions: 0
last_intervention: null
status: inactive
EOF

    # Initialize metrics
    cat > "$METRICS_FILE" << EOF
# Claude Watcher Metrics
total_tools: 0
error_count: 0
error_rate: 0%
top_tools: []
last_updated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

    # Initialize decisions log
    cat > "$DECISIONS_FILE" << EOF
# Claude Watcher Decisions Log

---

EOF

    echo "Claude Watcher initialized successfully!"
    echo "Use '/watcher start \"your goal\"' to begin watching"
}

# Start watching with a goal
start() {
    local goal="$1"

    if [ -z "$goal" ]; then
        echo "Error: Please provide a goal"
        echo "Usage: run.sh start \"your goal here\""
        exit 1
    fi

    echo "Starting Claude Watcher..."
    echo "Goal: $goal"

    # Update state
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^goal:.*/goal: \"$goal\"/" "$STATE_FILE"
        sed -i '' "s/^status:.*/status: active/" "$STATE_FILE"
        sed -i '' "s/^started_at:.*/started_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)/" "$STATE_FILE"
    else
        sed -i "s/^goal:.*/goal: \"$goal\"/" "$STATE_FILE"
        sed -i "s/^status:.*/status: active/" "$STATE_FILE"
        sed -i "s/^started_at:.*/started_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)/" "$STATE_FILE"
    fi

    # Clear old observations
    > "$OBSERVATIONS_FILE"

    echo ""
    echo "Claude Watcher is now ACTIVE"
    echo "Hooks will observe all tool calls and trigger analysis when needed"
}

# Stop watching
stop() {
    echo "Stopping Claude Watcher..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^status:.*/status: inactive/" "$STATE_FILE"
    else
        sed -i "s/^status:.*/status: inactive/" "$STATE_FILE"
    fi

    echo "Claude Watcher is now INACTIVE"
}

# Show current status
status() {
    echo "=========================================="
    echo "       Claude Watcher Status"
    echo "=========================================="
    echo ""

    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "Not initialized. Run: run.sh init"
    fi

    echo ""
    echo "=========================================="

    if [ -f "$METRICS_FILE" ]; then
        echo ""
        cat "$METRICS_FILE"
    fi

    echo ""
    echo "=========================================="
    echo "Observations: $(wc -l < "$OBSERVATIONS_FILE" 2>/dev/null || echo "0") entries"
    echo "=========================================="
}

# Invoke Thinker for analysis
invoke_thinker() {
    local trigger_reason="${1:-manual}"

    echo ""
    echo "=========================================="
    echo "    Claude Watcher - Invoking Thinker"
    echo "=========================================="
    echo "Trigger: $trigger_reason"
    echo "Time: $(date)"
    echo ""

    # Get current state
    local goal=""
    if [ -f "$STATE_FILE" ]; then
        goal=$(grep 'goal:' "$STATE_FILE" | sed 's/goal: //' | tr -d '"')
    fi

    # Get observations
    local obs_count=$(grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0")
    local recent_obs=$(tail -20 "$OBSERVATIONS_FILE")

    # Get metrics
    local error_count=$(grep '"exit"' "$OBSERVATIONS_FILE" | grep -v '"exit":"0"' | grep -v '"exit":0' | wc -l | tr -d ' ')
    local error_rate=0
    if [ "$obs_count" -gt 0 ]; then
        error_rate=$(echo "scale=1; $error_count * 100 / $obs_count" | bc 2>/dev/null || echo "0")
    fi

    # Get top tools
    local top_tools=$(grep '"type":"pre"' "$OBSERVATIONS_FILE" | jq -r '.tool' 2>/dev/null | sort | uniq -c | sort -rn | head -5 | awk '{print $2}' | tr '\n' ', ' | sed 's/,$//')

    # Build analysis prompt
    local analysis_prompt="# Watcher Analysis Request

## Current State
- **Goal**: $goal
- **Tool calls since last check**: $obs_count
- **Errors detected**: $error_count
- **Error rate**: ${error_rate}%
- **Trigger reason**: $trigger_reason

## Recent Observations (last 20)
\`\`\`json
$recent_obs
\`\`\`

## Metrics
- Total tool calls: $obs_count
- Error rate: ${error_rate}%
- Most used tools: [$top_tools]

---

## Your Task

1. **Analyze**: Worker đang làm gì? On-track hay off-track?
2. **Identify**: Có vấn đề gì không? (errors, inefficiency, wrong direction)
3. **Decide**: CONTINUE / REDIRECT / HELP / STOP
4. **Action**: Nếu không CONTINUE, viết command cho Worker

## Output Format

### Analysis
[Phân tích của bạn]

### Decision: [CONTINUE/REDIRECT/HELP/STOP]
[Lý do]

### Command (nếu có)
\`\`\`
[Command cho Worker - ONLY if not CONTINUE]
\`\`\`"

    echo "Calling Thinker with analysis prompt..."
    echo ""

    # Call Claude CLI as Thinker
    local thinker_response=""
    if command -v claude &> /dev/null; then
        thinker_response=$(claude --print "You are Claude Watcher Thinker - a meta-agent that analyzes Worker Claude Code activity.

$analysis_prompt" 2>/dev/null || echo "Error invoking thinker")
    else
        echo "Warning: claude CLI not found"
        thinker_response="Error: claude CLI not available"
    fi

    # Save thinker response
    echo "$thinker_response" > "$MEMORY_DIR/thinker-response.md"

    # Log decision
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    cat >> "$DECISIONS_FILE" << EOF

## Decision - $timestamp

**Trigger**: $trigger_reason

$thinker_response

---

EOF

    # Parse decision
    local decision=$(echo "$thinker_response" | grep -i "### Decision:" | head -1 || echo "")

    echo "Thinker response saved"
    echo "Decision: $decision"

    # Extract and save command if not CONTINUE
    if [[ "$decision" != *"CONTINUE"* ]] && [[ -n "$decision" ]]; then
        # Extract command block
        local command=$(echo "$thinker_response" | sed -n '/### Command/,/```$/p' | grep -v '### Command' | grep -v '```' || echo "")

        if [ -n "$command" ]; then
            echo "$command" > "$COMMAND_FILE"
            echo "Command saved to: $COMMAND_FILE"

            # Execute command
            "$SCRIPT_DIR/commander.sh" execute
        fi
    else
        echo "Decision: CONTINUE - No intervention needed"
    fi

    # Update state
    local current_count=$(grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0")
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^last_think_timestamp:.*/last_think_timestamp: $timestamp/" "$STATE_FILE"
        sed -i '' "s/^last_think_at_count:.*/last_think_at_count: $current_count/" "$STATE_FILE"
    else
        sed -i "s/^last_think_timestamp:.*/last_think_timestamp: $timestamp/" "$STATE_FILE"
        sed -i "s/^last_think_at_count:.*/last_think_at_count: $current_count/" "$STATE_FILE"
    fi

    echo ""
    echo "Thinker analysis complete"
    echo "=========================================="
}

# Reset watcher (clear all data)
reset() {
    echo "Resetting Claude Watcher..."

    # Clear observations
    > "$OBSERVATIONS_FILE"

    # Reset state
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^last_think_at_count:.*/last_think_at_count: 0/" "$STATE_FILE"
        sed -i '' "s/^total_interventions:.*/total_interventions: 0/" "$STATE_FILE"
    else
        sed -i "s/^last_think_at_count:.*/last_think_at_count: 0/" "$STATE_FILE"
        sed -i "s/^total_interventions:.*/total_interventions: 0/" "$STATE_FILE"
    fi

    echo "Claude Watcher reset complete"
}

# Main command handler
case "$1" in
    init)
        init
        ;;
    start)
        start "$2"
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    invoke_thinker)
        invoke_thinker "$2"
        ;;
    think)
        invoke_thinker "manual"
        ;;
    reset)
        reset
        ;;
    *)
        echo "Claude Watcher - Meta-Agent for Claude Code"
        echo ""
        echo "Usage: run.sh {command}"
        echo ""
        echo "Commands:"
        echo "  init              Initialize watcher system"
        echo "  start \"goal\"      Start watching with a goal"
        echo "  stop              Stop watching"
        echo "  status            Show current status"
        echo "  think             Force Thinker analysis (manual trigger)"
        echo "  reset             Reset all data"
        echo ""
        exit 1
        ;;
esac
