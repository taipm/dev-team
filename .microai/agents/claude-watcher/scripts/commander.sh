#!/bin/bash
# Claude Watcher - Commander Module
# Execute Thinker decisions by commanding Worker session

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WATCHER_DIR/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"
COMMAND_FILE="$MEMORY_DIR/next-command.md"
STATE_FILE="$MEMORY_DIR/state.yaml"
DECISIONS_FILE="$MEMORY_DIR/decisions.md"

# Ensure directories exist
mkdir -p "$ARCHIVE_DIR"

# Execute command by sending to Worker
execute_command() {
    if [ ! -f "$COMMAND_FILE" ]; then
        echo "No command file found"
        return 0
    fi

    local command=$(cat "$COMMAND_FILE")

    if [ -z "$command" ]; then
        echo "Empty command, skipping"
        return 0
    fi

    echo "=========================================="
    echo "Claude Watcher - Executing Command"
    echo "=========================================="
    echo ""
    echo "Command:"
    echo "$command"
    echo ""
    echo "=========================================="

    # Method 1: Use claude CLI in print mode
    # This sends the command to a new Claude session
    if command -v claude &> /dev/null; then
        echo "Sending command to Claude Code..."

        # Wrap command with context
        local full_prompt="[WATCHER INTERVENTION]

The Claude Watcher (meta-agent) has analyzed your recent activity and has the following instruction:

---

$command

---

Please acknowledge this instruction and adjust your approach accordingly."

        # Execute via claude CLI
        # Note: This creates a new session, not inject into existing
        # For true injection, would need different mechanism
        claude --print "$full_prompt" 2>/dev/null || {
            echo "Warning: Could not execute claude command"
            echo "Command saved to: $COMMAND_FILE"
        }
    else
        echo "Warning: claude CLI not found"
        echo "Command saved for manual execution: $COMMAND_FILE"
    fi

    # Archive the command
    local timestamp=$(date +%Y%m%d-%H%M%S)
    cp "$COMMAND_FILE" "$ARCHIVE_DIR/command-$timestamp.md"

    # Clear command file
    rm -f "$COMMAND_FILE"

    # Update state
    update_intervention_count

    echo ""
    echo "Command executed and archived"
}

# Update intervention count in state
update_intervention_count() {
    if [ -f "$STATE_FILE" ]; then
        local current=$(grep 'total_interventions:' "$STATE_FILE" | awk '{print $2}' || echo "0")
        local new=$((current + 1))

        # Update state file
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/^total_interventions:.*/total_interventions: $new/" "$STATE_FILE"
            sed -i '' "s/^last_intervention:.*/last_intervention: $(date -u +%Y-%m-%dT%H:%M:%SZ)/" "$STATE_FILE"
        else
            sed -i "s/^total_interventions:.*/total_interventions: $new/" "$STATE_FILE"
            sed -i "s/^last_intervention:.*/last_intervention: $(date -u +%Y-%m-%dT%H:%M:%SZ)/" "$STATE_FILE"
        fi
    fi
}

# Show pending command
show_pending() {
    if [ -f "$COMMAND_FILE" ]; then
        echo "=== Pending Command ==="
        cat "$COMMAND_FILE"
    else
        echo "No pending command"
    fi
}

# List archived commands
list_archive() {
    echo "=== Archived Commands ==="
    if [ -d "$ARCHIVE_DIR" ]; then
        ls -la "$ARCHIVE_DIR"/*.md 2>/dev/null || echo "No archived commands"
    else
        echo "No archive directory"
    fi
}

# Clear pending command
clear_pending() {
    if [ -f "$COMMAND_FILE" ]; then
        rm -f "$COMMAND_FILE"
        echo "Pending command cleared"
    else
        echo "No pending command to clear"
    fi
}

# Main command handler
case "$1" in
    execute)
        execute_command
        ;;
    pending)
        show_pending
        ;;
    archive)
        list_archive
        ;;
    clear)
        clear_pending
        ;;
    *)
        echo "Usage: commander.sh {execute|pending|archive|clear}"
        exit 1
        ;;
esac
