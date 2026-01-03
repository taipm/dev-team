#!/bin/bash
#
# grade-response.sh - Grade an agent response against expected criteria
#
# Usage:
#   grade-response.sh --response "response text" --keywords "kw1,kw2" --points N
#   echo "response" | grade-response.sh --keywords "kw1,kw2" --points N
#
# Options:
#   --response TEXT     Response to grade (or use stdin)
#   --keywords LIST     Comma-separated expected keywords
#   --points N          Maximum points for this test
#   --min-ratio R       Minimum match ratio (default: 0.5)
#   --json              Output as JSON
#   --verbose           Show detailed matching info
#
# Output (default):
#   score/max (pass|fail)
#
# Output (--json):
#   {"score": N, "max": N, "status": "pass|fail", "matched": ["kw1"], "ratio": 0.X}

set -e

# Defaults
RESPONSE=""
KEYWORDS=""
POINTS=1
MIN_RATIO=0.5
JSON_OUTPUT=false
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --response)
            RESPONSE="$2"
            shift 2
            ;;
        --keywords)
            KEYWORDS="$2"
            shift 2
            ;;
        --points)
            POINTS="$2"
            shift 2
            ;;
        --min-ratio)
            MIN_RATIO="$2"
            shift 2
            ;;
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            head -25 "$0" | grep -E "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Read from stdin if no response provided
if [[ -z "$RESPONSE" ]]; then
    if [ -t 0 ]; then
        echo "Error: No response provided" >&2
        exit 1
    fi
    RESPONSE=$(cat)
fi

if [[ -z "$KEYWORDS" ]]; then
    echo "Error: --keywords is required" >&2
    exit 1
fi

# Convert keywords to array
IFS=',' read -ra KEYWORD_ARRAY <<< "$KEYWORDS"
TOTAL_KEYWORDS=${#KEYWORD_ARRAY[@]}

# Match keywords (case-insensitive)
MATCHED_KEYWORDS=()
MATCHED_COUNT=0

for keyword in "${KEYWORD_ARRAY[@]}"; do
    # Trim whitespace
    keyword=$(echo "$keyword" | xargs)

    # Case-insensitive match
    if echo "$RESPONSE" | grep -qi "$keyword"; then
        MATCHED_KEYWORDS+=("$keyword")
        MATCHED_COUNT=$((MATCHED_COUNT + 1))
    fi
done

# Calculate ratio and score
if [[ $TOTAL_KEYWORDS -gt 0 ]]; then
    RATIO=$(echo "scale=2; $MATCHED_COUNT / $TOTAL_KEYWORDS" | bc)
    SCORE=$(echo "scale=2; $POINTS * $MATCHED_COUNT / $TOTAL_KEYWORDS" | bc)
else
    RATIO=0
    SCORE=0
fi

# Determine pass/fail
if (( $(echo "$RATIO >= $MIN_RATIO" | bc -l) )); then
    STATUS="pass"
else
    STATUS="fail"
fi

# Output
if $JSON_OUTPUT; then
    # Build matched keywords JSON array
    MATCHED_JSON="["
    for i in "${!MATCHED_KEYWORDS[@]}"; do
        if [[ $i -gt 0 ]]; then
            MATCHED_JSON+=","
        fi
        MATCHED_JSON+="\"${MATCHED_KEYWORDS[$i]}\""
    done
    MATCHED_JSON+="]"

    echo "{\"score\": $SCORE, \"max\": $POINTS, \"status\": \"$STATUS\", \"matched\": $MATCHED_JSON, \"ratio\": $RATIO, \"matched_count\": $MATCHED_COUNT, \"total_keywords\": $TOTAL_KEYWORDS}"
else
    if $VERBOSE; then
        echo "Response: ${RESPONSE:0:100}..."
        echo "Keywords: $KEYWORDS"
        echo "Matched: ${MATCHED_KEYWORDS[*]}"
        echo "Ratio: $MATCHED_COUNT/$TOTAL_KEYWORDS = $RATIO"
    fi
    echo "$SCORE/$POINTS ($STATUS)"
fi
