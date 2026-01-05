#!/bin/bash
# SEPA - Calculate Fitness Score
# Compute score from automatic signals (no human input)
#
# Usage: ./calculate-score.sh [executions_file]
#
# Output: Score on 0-100 scale

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$AGENT_DIR/memory"

# Input file
EXECUTIONS_FILE="${1:-$MEMORY_DIR/executions.jsonl}"

if [ ! -f "$EXECUTIONS_FILE" ]; then
    echo "0"
    exit 0
fi

# Count total and successful tool calls
TOTAL_TOOLS=$(wc -l < "$EXECUTIONS_FILE" | tr -d ' ')
if [ "$TOTAL_TOOLS" -eq 0 ]; then
    echo "0"
    exit 0
fi

SUCCESSFUL_TOOLS=$(grep -c '"success":"true"' "$EXECUTIONS_FILE" 2>/dev/null || echo "0")

# Calculate tool success rate (0-1)
TOOL_SUCCESS=$(echo "scale=4; $SUCCESSFUL_TOOLS / $TOTAL_TOOLS" | bc)

# Count errors
ERROR_COUNT=$(grep -c '"success":"false"' "$EXECUTIONS_FILE" 2>/dev/null | tr -d '\n' || echo "0")
[ -z "$ERROR_COUNT" ] && ERROR_COUNT=0

# Calculate error rate (capped at 1.0)
ERROR_RATE=$(echo "scale=4; if ($ERROR_COUNT / 10 > 1) 1 else $ERROR_COUNT / 10" | bc)
ERROR_SCORE=$(echo "scale=4; 1 - $ERROR_RATE" | bc)

# Efficiency: based on tool count
# Assume max expected tools = 15 for medium task
MAX_TOOLS=15
EFFICIENCY=$(echo "scale=4; if ($TOTAL_TOOLS > $MAX_TOOLS) 0 else 1 - ($TOTAL_TOOLS / ($MAX_TOOLS * 2))" | bc)
# Clamp to 0-1
EFFICIENCY=$(echo "scale=4; if ($EFFICIENCY < 0) 0 else if ($EFFICIENCY > 1) 1 else $EFFICIENCY" | bc)

# Output quality: estimate based on tool diversity
# More diverse tools = likely better output
# Use grep instead of jq for better compatibility
UNIQUE_TOOLS=$(grep -o '"tool":"[^"]*"' "$EXECUTIONS_FILE" 2>/dev/null | sort -u | wc -l | tr -d ' ' || echo "1")
OUTPUT_QUALITY=$(echo "scale=4; if ($UNIQUE_TOOLS > 5) 1 else $UNIQUE_TOOLS / 5" | bc)

# Structure score: placeholder (would need actual output analysis)
# Default to 0.7 as baseline
STRUCTURE_SCORE="0.7"

# Calculate final score using weights
# Score = 0.35*tool_success + 0.25*output_quality + 0.20*efficiency + 0.15*error_score + 0.05*structure
SCORE=$(echo "scale=4; \
    0.35 * $TOOL_SUCCESS + \
    0.25 * $OUTPUT_QUALITY + \
    0.20 * $EFFICIENCY + \
    0.15 * $ERROR_SCORE + \
    0.05 * $STRUCTURE_SCORE" | bc)

# Convert to 0-100 scale and round
FINAL_SCORE=$(echo "scale=2; $SCORE * 100" | bc)

# Output score
echo "$FINAL_SCORE"

# Also output details to stderr for debugging
>&2 echo "=== Score Breakdown ==="
>&2 echo "Tool Success Rate: $TOOL_SUCCESS (weight: 0.35)"
>&2 echo "Output Quality: $OUTPUT_QUALITY (weight: 0.25)"
>&2 echo "Efficiency: $EFFICIENCY (weight: 0.20)"
>&2 echo "Error Score: $ERROR_SCORE (weight: 0.15)"
>&2 echo "Structure Score: $STRUCTURE_SCORE (weight: 0.05)"
>&2 echo "Final Score: $FINAL_SCORE / 100"
