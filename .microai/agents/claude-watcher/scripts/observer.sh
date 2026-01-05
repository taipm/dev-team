#!/bin/bash
# Claude Watcher - Observer Module
# Process hook events, update metrics, track state

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WATCHER_DIR/memory"
METRICS_FILE="$MEMORY_DIR/metrics.yaml"
STATE_FILE="$MEMORY_DIR/state.yaml"
OBSERVATIONS_FILE="$MEMORY_DIR/observations.jsonl"

# Ensure files exist
mkdir -p "$MEMORY_DIR"
touch "$OBSERVATIONS_FILE"

# Initialize metrics file if not exists
init_metrics() {
    if [ ! -f "$METRICS_FILE" ]; then
        cat > "$METRICS_FILE" << EOF
# Claude Watcher Metrics
total_tools: 0
error_count: 0
error_rate: 0.0
tool_counts: {}
last_updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF
    fi
}

# Update metrics when a tool is called
update_metrics() {
    local tool="$1"
    init_metrics

    # Count total tools
    local total=$(wc -l < "$OBSERVATIONS_FILE" | tr -d ' ')
    local pre_count=$(grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0")

    # Count errors
    local error_count=$(grep '"exit"' "$OBSERVATIONS_FILE" | grep -v '"exit":"0"' | grep -v '"exit":0' | wc -l | tr -d ' ')

    # Calculate error rate
    local error_rate=0
    if [ "$pre_count" -gt 0 ]; then
        error_rate=$(echo "scale=1; $error_count * 100 / $pre_count" | bc 2>/dev/null || echo "0")
    fi

    # Get top tools
    local top_tools=$(grep '"type":"pre"' "$OBSERVATIONS_FILE" | jq -r '.tool' | sort | uniq -c | sort -rn | head -5 | awk '{print $2}' | tr '\n' ',' | sed 's/,$//')

    # Update metrics file
    cat > "$METRICS_FILE" << EOF
# Claude Watcher Metrics
total_tools: $pre_count
error_count: $error_count
error_rate: ${error_rate}%
top_tools: [$top_tools]
last_updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF
}

# Record an error occurrence
record_error() {
    local tool="$1"
    local exit_code="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Append to error log
    echo "$timestamp: Tool '$tool' failed with exit code $exit_code" >> "$MEMORY_DIR/errors.log"

    # Update metrics
    update_metrics "$tool"
}

# Get current observation count
get_observation_count() {
    if [ -f "$OBSERVATIONS_FILE" ]; then
        grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# Get recent observations (last N)
get_recent_observations() {
    local count="${1:-20}"
    if [ -f "$OBSERVATIONS_FILE" ]; then
        tail -n "$count" "$OBSERVATIONS_FILE"
    fi
}

# Clean old observations (keep last N)
prune_observations() {
    local keep="${1:-1000}"
    if [ -f "$OBSERVATIONS_FILE" ]; then
        local total=$(wc -l < "$OBSERVATIONS_FILE" | tr -d ' ')
        if [ "$total" -gt "$keep" ]; then
            local temp_file=$(mktemp)
            tail -n "$keep" "$OBSERVATIONS_FILE" > "$temp_file"
            mv "$temp_file" "$OBSERVATIONS_FILE"
            echo "Pruned observations: kept last $keep of $total"
        fi
    fi
}

# Get summary of recent activity
get_summary() {
    init_metrics

    local total=$(grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0")
    local errors=$(grep '"exit"' "$OBSERVATIONS_FILE" | grep -v '"exit":"0"' | grep -v '"exit":0' | wc -l | tr -d ' ')

    echo "=== Claude Watcher Summary ==="
    echo "Total tool calls: $total"
    echo "Errors: $errors"

    if [ -f "$METRICS_FILE" ]; then
        echo ""
        cat "$METRICS_FILE"
    fi

    if [ -f "$STATE_FILE" ]; then
        echo ""
        echo "=== State ==="
        cat "$STATE_FILE"
    fi
}

# Main command handler
case "$1" in
    update_metrics)
        update_metrics "$2"
        ;;
    record_error)
        record_error "$2" "$3"
        ;;
    count)
        get_observation_count
        ;;
    recent)
        get_recent_observations "$2"
        ;;
    prune)
        prune_observations "$2"
        ;;
    summary)
        get_summary
        ;;
    *)
        echo "Usage: observer.sh {update_metrics|record_error|count|recent|prune|summary}"
        exit 1
        ;;
esac
