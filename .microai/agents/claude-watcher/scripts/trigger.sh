#!/bin/bash
# Claude Watcher - Smart Trigger System
# Determines when to invoke the Thinker for analysis
#
# Trigger conditions:
# 1. Tool count: After every N tool calls
# 2. Pattern detection: Repeated errors, stuck loops, long running
# 3. Time-based: Periodic health check

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WATCHER_DIR/memory"
CONFIG_DIR="$WATCHER_DIR/config"
STATE_FILE="$MEMORY_DIR/state.yaml"
OBSERVATIONS_FILE="$MEMORY_DIR/observations.jsonl"
TRIGGER_FILE="$MEMORY_DIR/.trigger_lock"

# Default configuration
TOOL_COUNT_THRESHOLD=15
TIME_INTERVAL_SECONDS=600  # 10 minutes
COOLDOWN_SECONDS=60
POST_INTERVENTION_COOLDOWN=120

# Load config if exists
if [ -f "$CONFIG_DIR/triggers.yaml" ]; then
    # Parse YAML config (simple parsing)
    TOOL_COUNT_THRESHOLD=$(grep 'threshold:' "$CONFIG_DIR/triggers.yaml" | head -1 | awk '{print $2}' || echo "15")
fi

# Check if in cooldown period
check_cooldown() {
    if [ ! -f "$STATE_FILE" ]; then
        return 0  # No state = no cooldown
    fi

    local last_think=$(grep 'last_think_timestamp:' "$STATE_FILE" | cut -d'"' -f2 | cut -d"'" -f2)

    if [ -z "$last_think" ]; then
        return 0
    fi

    # Parse timestamp and compare
    local now=$(date +%s)
    local last_sec=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_think" +%s 2>/dev/null || echo "0")

    local diff=$((now - last_sec))

    if [ "$diff" -lt "$COOLDOWN_SECONDS" ]; then
        return 1  # Still in cooldown
    fi

    return 0
}

# Trigger 1: Check tool count threshold
check_tool_count() {
    if [ ! -f "$OBSERVATIONS_FILE" ]; then
        return 1
    fi

    # Handle empty file case
    local current_count=0
    if [ -s "$OBSERVATIONS_FILE" ]; then
        current_count=$(grep -c '"type":"pre"' "$OBSERVATIONS_FILE" 2>/dev/null || echo "0")
    fi

    # Get last think count from state
    local last_count=0
    if [ -f "$STATE_FILE" ]; then
        last_count=$(grep 'last_think_at_count:' "$STATE_FILE" | awk '{print $2}')
        last_count=${last_count:-0}
    fi

    # Ensure numeric values
    current_count=${current_count:-0}
    last_count=${last_count:-0}

    local diff=$((current_count - last_count))

    if [ "$diff" -ge "$TOOL_COUNT_THRESHOLD" ]; then
        echo "tool_count:$diff"
        return 0
    fi

    return 1
}

# Trigger 2: Check for repeated errors
check_repeated_errors() {
    if [ ! -f "$OBSERVATIONS_FILE" ]; then
        return 1
    fi

    # Count errors in last 20 observations
    local error_count=$(tail -40 "$OBSERVATIONS_FILE" | grep '"type":"post"' | grep -v '"exit":"0"' | grep -v '"exit":0' | wc -l | tr -d ' ')

    if [ "$error_count" -ge 3 ]; then
        echo "repeated_errors:$error_count"
        return 0
    fi

    return 1
}

# Trigger 2b: Check for stuck loop (same file edited multiple times)
check_stuck_loop() {
    if [ ! -f "$OBSERVATIONS_FILE" ]; then
        return 1
    fi

    # Look for same file being edited 5+ times in recent observations
    local stuck=$(tail -50 "$OBSERVATIONS_FILE" | \
        grep '"tool":"Edit"' | \
        jq -r '.params.file_path // empty' 2>/dev/null | \
        sort | uniq -c | sort -rn | head -1)

    local count=$(echo "$stuck" | awk '{print $1}')

    if [ -n "$count" ] && [ "$count" -ge 5 ]; then
        echo "stuck_loop:$count"
        return 0
    fi

    return 1
}

# Trigger 3: Check time-based trigger
check_time_interval() {
    if [ ! -f "$STATE_FILE" ]; then
        return 1
    fi

    local last_think=$(grep 'last_think_timestamp:' "$STATE_FILE" | cut -d'"' -f2 | cut -d"'" -f2)

    if [ -z "$last_think" ]; then
        return 1
    fi

    local now=$(date +%s)
    local last_sec=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_think" +%s 2>/dev/null || echo "0")

    local diff=$((now - last_sec))

    if [ "$diff" -ge "$TIME_INTERVAL_SECONDS" ]; then
        echo "time_interval:${diff}s"
        return 0
    fi

    return 1
}

# Main check - evaluates all triggers
check_all() {
    # First check cooldown
    if ! check_cooldown; then
        echo "In cooldown period, skipping"
        return 1
    fi

    # Check if watcher is active
    if [ -f "$STATE_FILE" ]; then
        local status=$(grep 'status:' "$STATE_FILE" | awk '{print $2}')
        if [ "$status" != "active" ]; then
            return 1
        fi
    else
        return 1  # No state = not active
    fi

    # Prevent concurrent triggers
    if [ -f "$TRIGGER_FILE" ]; then
        local lock_time=$(cat "$TRIGGER_FILE")
        local now=$(date +%s)
        if [ $((now - lock_time)) -lt 30 ]; then
            return 1  # Another trigger in progress
        fi
    fi

    # Check triggers in priority order
    local trigger_reason=""

    # High priority: Pattern detection
    if result=$(check_repeated_errors); then
        trigger_reason="$result"
    elif result=$(check_stuck_loop); then
        trigger_reason="$result"
    # Normal priority: Tool count
    elif result=$(check_tool_count); then
        trigger_reason="$result"
    # Low priority: Time interval
    elif result=$(check_time_interval); then
        trigger_reason="$result"
    fi

    if [ -n "$trigger_reason" ]; then
        # Create lock
        date +%s > "$TRIGGER_FILE"

        # Store trigger reason
        echo "$trigger_reason" > "$MEMORY_DIR/.last_trigger_reason"

        echo "Trigger activated: $trigger_reason"

        # Invoke thinker
        "$WATCHER_DIR/scripts/run.sh" invoke_thinker "$trigger_reason"

        # Remove lock
        rm -f "$TRIGGER_FILE"

        return 0
    fi

    return 1
}

# Force trigger (manual)
force_trigger() {
    echo "Force trigger activated"
    echo "manual:forced" > "$MEMORY_DIR/.last_trigger_reason"
    "$WATCHER_DIR/scripts/run.sh" invoke_thinker "manual:forced"
}

# Main command handler
case "$1" in
    check)
        check_all
        ;;
    force)
        force_trigger
        ;;
    status)
        echo "=== Trigger Status ==="
        echo "Tool count threshold: $TOOL_COUNT_THRESHOLD"
        echo "Time interval: ${TIME_INTERVAL_SECONDS}s"
        echo "Cooldown: ${COOLDOWN_SECONDS}s"
        echo ""

        if check_cooldown; then
            echo "Cooldown: NOT in cooldown"
        else
            echo "Cooldown: IN COOLDOWN"
        fi

        echo ""
        echo "Individual checks:"
        check_tool_count && echo "  Tool count: WOULD TRIGGER" || echo "  Tool count: no"
        check_repeated_errors && echo "  Repeated errors: WOULD TRIGGER" || echo "  Repeated errors: no"
        check_stuck_loop && echo "  Stuck loop: WOULD TRIGGER" || echo "  Stuck loop: no"
        check_time_interval && echo "  Time interval: WOULD TRIGGER" || echo "  Time interval: no"
        ;;
    *)
        echo "Usage: trigger.sh {check|force|status}"
        exit 1
        ;;
esac
