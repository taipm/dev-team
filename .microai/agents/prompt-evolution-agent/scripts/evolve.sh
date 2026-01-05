#!/bin/bash
# SEPA - Evolution Cycle
# Main orchestration script for prompt evolution
#
# This script:
# 1. Calculates score for current version
# 2. Checks rollback conditions
# 3. Selects mutation strategy
# 4. Applies mutation
# 5. Updates version tracking

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$AGENT_DIR/memory"
VERSIONS_DIR="$MEMORY_DIR/versions"

# Files
EXECUTIONS_FILE="$MEMORY_DIR/executions.jsonl"
SCORES_FILE="$MEMORY_DIR/scores.yaml"
CONTEXT_FILE="$MEMORY_DIR/context.md"
EVOLUTION_LOG="$MEMORY_DIR/evolution-log.md"

# Config
POPULATION_SIZE=5
ROLLBACK_THRESHOLD=2

# Ensure directories exist
mkdir -p "$VERSIONS_DIR"

# Get current state
get_current_version() {
    if [ -f "$CONTEXT_FILE" ]; then
        grep 'current_version:' "$CONTEXT_FILE" 2>/dev/null | sed 's/.*current_version:[[:space:]]*//' | tr -d ' ' || echo "v001"
    else
        echo "v001"
    fi
}

get_consecutive_failures() {
    if [ -f "$CONTEXT_FILE" ]; then
        grep 'consecutive_failures:' "$CONTEXT_FILE" 2>/dev/null | sed 's/.*consecutive_failures:[[:space:]]*//' | tr -d ' ' || echo "0"
    else
        echo "0"
    fi
}

get_best_version() {
    if [ -f "$SCORES_FILE" ]; then
        # Find version with highest score (macOS compatible)
        grep -A1 "^  v[0-9]*:" "$SCORES_FILE" 2>/dev/null | \
            grep 'score:' | sed 's/.*score:[[:space:]]*//' | \
            grep -v null | sort -rn | head -1
    fi
    echo "v001"
}

# Calculate current score
CURRENT_VERSION=$(get_current_version)
SCORE=$("$SCRIPT_DIR/calculate-score.sh" "$EXECUTIONS_FILE")
CONSECUTIVE_FAILURES=$(get_consecutive_failures)

echo "Evolution cycle started"
echo "Current version: $CURRENT_VERSION"
echo "Current score: $SCORE"
echo "Consecutive failures: $CONSECUTIVE_FAILURES"

# Get previous score for comparison
PREVIOUS_SCORE=$(grep -A1 "^  $CURRENT_VERSION:" "$SCORES_FILE" 2>/dev/null | grep 'score:' | sed 's/.*score:[[:space:]]*//' | grep -v null || echo "0")

# Check if score dropped
SCORE_DROPPED=false
if [ -n "$PREVIOUS_SCORE" ] && [ "$PREVIOUS_SCORE" != "0" ]; then
    COMPARISON=$(echo "$SCORE < $PREVIOUS_SCORE" | bc)
    if [ "$COMPARISON" -eq 1 ]; then
        SCORE_DROPPED=true
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    else
        CONSECUTIVE_FAILURES=0
    fi
fi

# Check rollback conditions
if [ "$CONSECUTIVE_FAILURES" -ge "$ROLLBACK_THRESHOLD" ]; then
    echo "Rollback triggered: $CONSECUTIVE_FAILURES consecutive failures"
    BEST_VERSION=$(get_best_version)

    # Update context to best version
    cat > "$CONTEXT_FILE" << EOF
# SEPA Context

current_version: $BEST_VERSION
consecutive_failures: 0
last_evolution: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
last_action: rollback
rollback_reason: consecutive_failures
EOF

    # Log rollback
    echo "" >> "$EVOLUTION_LOG"
    echo "## Rollback - $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$EVOLUTION_LOG"
    echo "- From: $CURRENT_VERSION (score: $SCORE)" >> "$EVOLUTION_LOG"
    echo "- To: $BEST_VERSION" >> "$EVOLUTION_LOG"
    echo "- Reason: $CONSECUTIVE_FAILURES consecutive failures" >> "$EVOLUTION_LOG"

    # Clear executions
    > "$EXECUTIONS_FILE"

    exit 0
fi

# Select mutation strategy based on score components
# (Simplified - in production would analyze specific metrics)
STRATEGIES=("instruction_rephrase" "constraint_add" "example_inject" "emphasis_shift")
STRATEGY_INDEX=$((RANDOM % ${#STRATEGIES[@]}))
STRATEGY="${STRATEGIES[$STRATEGY_INDEX]}"

echo "Selected strategy: $STRATEGY"

# Generate new version number
LAST_VERSION=$(ls -1 "$VERSIONS_DIR" 2>/dev/null | sed 's/v\([0-9]*\).*/\1/' | sort -rn | head -1 || echo "0")
NEW_VERSION_NUM=$((LAST_VERSION + 1))
NEW_VERSION=$(printf "v%03d" $NEW_VERSION_NUM)

echo "Creating new version: $NEW_VERSION"

# For now, copy current version with mutation note
# In production, this would actually mutate the prompt using Claude
CURRENT_VERSION_FILE="$VERSIONS_DIR/$CURRENT_VERSION.md"
NEW_VERSION_FILE="$VERSIONS_DIR/$NEW_VERSION.md"

if [ -f "$CURRENT_VERSION_FILE" ]; then
    cp "$CURRENT_VERSION_FILE" "$NEW_VERSION_FILE"
else
    # Create base version if doesn't exist
    cat > "$NEW_VERSION_FILE" << 'EOF'
# Base Prompt Version

This is the base prompt for the Self-Evolving Prompt Agent.

## Core Instructions

You are an AI assistant that helps users with various tasks.
Be helpful, accurate, and efficient.

## Guidelines

1. Understand the user's request fully before acting
2. Use appropriate tools for the task
3. Provide clear explanations
4. Handle errors gracefully
EOF
fi

# Add mutation note to new version
echo "" >> "$NEW_VERSION_FILE"
echo "<!-- Mutation: $STRATEGY applied at $(date -u +"%Y-%m-%dT%H:%M:%SZ") -->" >> "$NEW_VERSION_FILE"

# Update scores file
if [ ! -f "$SCORES_FILE" ]; then
    cat > "$SCORES_FILE" << EOF
schema_version: "1.0"
last_updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

current_active: $NEW_VERSION
best_all_time:
  version: $CURRENT_VERSION
  score: $SCORE

versions:
EOF
fi

# Add new version to scores
cat >> "$SCORES_FILE" << EOF
  $NEW_VERSION:
    score: null
    created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
    mutation: $STRATEGY
    parent: $CURRENT_VERSION
    parent_score: $SCORE
    status: current
EOF

# Update context
cat > "$CONTEXT_FILE" << EOF
# SEPA Context

current_version: $NEW_VERSION
consecutive_failures: $CONSECUTIVE_FAILURES
last_evolution: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
last_action: mutation
last_strategy: $STRATEGY
parent_version: $CURRENT_VERSION
parent_score: $SCORE
EOF

# Log evolution
if [ ! -f "$EVOLUTION_LOG" ]; then
    echo "# Evolution Log" > "$EVOLUTION_LOG"
    echo "" >> "$EVOLUTION_LOG"
fi

echo "" >> "$EVOLUTION_LOG"
echo "## Evolution - $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$EVOLUTION_LOG"
echo "- From: $CURRENT_VERSION (score: $SCORE)" >> "$EVOLUTION_LOG"
echo "- To: $NEW_VERSION" >> "$EVOLUTION_LOG"
echo "- Strategy: $STRATEGY" >> "$EVOLUTION_LOG"

# Clear executions for next cycle
> "$EXECUTIONS_FILE"

# Prune old versions (keep last POPULATION_SIZE)
VERSION_COUNT=$(ls -1 "$VERSIONS_DIR" 2>/dev/null | wc -l)
if [ "$VERSION_COUNT" -gt "$POPULATION_SIZE" ]; then
    # Archive oldest versions
    ARCHIVE_DIR="$MEMORY_DIR/archive"
    mkdir -p "$ARCHIVE_DIR"

    ls -1t "$VERSIONS_DIR" | tail -n +$((POPULATION_SIZE + 1)) | while read OLD_VERSION; do
        mv "$VERSIONS_DIR/$OLD_VERSION" "$ARCHIVE_DIR/" 2>/dev/null || true
    done
fi

echo "Evolution complete: $CURRENT_VERSION -> $NEW_VERSION (strategy: $STRATEGY)"
