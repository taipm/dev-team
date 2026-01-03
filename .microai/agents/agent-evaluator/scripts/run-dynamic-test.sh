#!/bin/bash
#
# run-dynamic-test.sh - Execute dynamic tests for agent evaluation
#
# Usage:
#   run-dynamic-test.sh --agent AGENT_ID --test-file TEST_FILE [OPTIONS]
#
# Options:
#   --agent AGENT_ID      Agent to test (e.g., go-dev-agent)
#   --test-file FILE      Test case file (YAML format)
#   --category CAT        Test category (reasoning, knowledge, adaptability, output)
#   --output-dir DIR      Output directory for results
#   --model MODEL         LLM model to use (default: qwen3:1.7b)
#   --timeout SECS        Timeout per test (default: 30)
#   --verbose             Show detailed output
#   --dry-run             Show tests without executing
#   --help                Show this help
#
# Exit codes:
#   0 - All tests passed
#   1 - Some tests failed
#   2 - Configuration error
#   3 - Execution error

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"

# Defaults
AGENT_ID=""
TEST_FILE=""
CATEGORY=""
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
MODEL="qwen3:1.7b"
TIMEOUT=30
VERBOSE=false
DRY_RUN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --agent)
            AGENT_ID="$2"
            shift 2
            ;;
        --test-file)
            TEST_FILE="$2"
            shift 2
            ;;
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            head -30 "$0" | grep -E "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

# Validate inputs
if [[ -z "$AGENT_ID" ]]; then
    echo -e "${RED}Error: --agent is required${NC}" >&2
    exit 2
fi

if [[ -z "$TEST_FILE" ]]; then
    TEST_FILE="$AGENT_EVALUATOR_DIR/knowledge/06-dynamic-test-cases.yaml"
fi

if [[ ! -f "$TEST_FILE" ]]; then
    echo -e "${RED}Error: Test file not found: $TEST_FILE${NC}" >&2
    exit 2
fi

# Load agent system prompt
AGENT_DIR="$MICROAI_DIR/agents/$AGENT_ID"
AGENT_FILE="$AGENT_DIR/agent.md"

if [[ ! -f "$AGENT_FILE" ]]; then
    echo -e "${RED}Error: Agent not found: $AGENT_ID${NC}" >&2
    exit 2
fi

# Extract agent system prompt from agent.md
extract_system_prompt() {
    local agent_file="$1"
    # Extract the instruction.system section
    sed -n '/instruction:/,/must:/p' "$agent_file" | \
        grep -A 100 "system:" | \
        sed -n '2,/must:/p' | \
        head -n -1 | \
        sed 's/^      //'
}

AGENT_SYSTEM_PROMPT=$(extract_system_prompt "$AGENT_FILE")

# Create output directory
mkdir -p "$OUTPUT_DIR"
RESULT_FILE="$OUTPUT_DIR/${AGENT_ID}-$(date +%Y%m%d-%H%M%S).json"

# Initialize results
echo "{" > "$RESULT_FILE"
echo '  "agent": "'$AGENT_ID'",' >> "$RESULT_FILE"
echo '  "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",' >> "$RESULT_FILE"
echo '  "model": "'$MODEL'",' >> "$RESULT_FILE"
echo '  "tests": [' >> "$RESULT_FILE"

# Function to run a single test
run_test() {
    local test_id="$1"
    local test_prompt="$2"
    local expected_keywords="$3"
    local points="$4"

    if $VERBOSE; then
        echo -e "${BLUE}Running test: $test_id${NC}"
        echo "  Prompt: $test_prompt"
    fi

    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY-RUN] Would execute test: $test_id${NC}"
        return 0
    fi

    # Combine agent system prompt with test prompt
    local full_prompt="$AGENT_SYSTEM_PROMPT

User request: $test_prompt

Respond concisely and directly."

    # Execute with Ollama
    local response=""
    local start_time=$(date +%s)

    response=$("$OLLAMA_SCRIPT" --model "$MODEL" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || {
        echo -e "${RED}Test $test_id: EXECUTION FAILED${NC}"
        echo '    {"id": "'$test_id'", "status": "error", "error": "execution_failed", "score": 0},' >> "$RESULT_FILE"
        return 1
    }

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Grade response against keywords
    local score=0
    local matched_keywords=""

    # Convert expected_keywords (comma-separated) to array
    IFS=',' read -ra KEYWORDS <<< "$expected_keywords"
    local total_keywords=${#KEYWORDS[@]}
    local matched_count=0

    for keyword in "${KEYWORDS[@]}"; do
        keyword=$(echo "$keyword" | xargs)  # trim whitespace
        if echo "$response" | grep -qi "$keyword"; then
            matched_count=$((matched_count + 1))
            matched_keywords="$matched_keywords,$keyword"
        fi
    done

    # Calculate score proportionally
    if [[ $total_keywords -gt 0 ]]; then
        score=$(echo "scale=2; $points * $matched_count / $total_keywords" | bc)
    fi

    # Determine pass/fail
    local status="fail"
    if (( $(echo "$matched_count >= $total_keywords / 2" | bc -l) )); then
        status="pass"
        if $VERBOSE; then
            echo -e "${GREEN}  PASSED (score: $score/$points)${NC}"
        fi
    else
        if $VERBOSE; then
            echo -e "${RED}  FAILED (score: $score/$points)${NC}"
        fi
    fi

    # Escape response for JSON
    local escaped_response=$(echo "$response" | head -c 500 | sed 's/"/\\"/g' | tr '\n' ' ')

    # Write result
    echo '    {' >> "$RESULT_FILE"
    echo '      "id": "'$test_id'",' >> "$RESULT_FILE"
    echo '      "status": "'$status'",' >> "$RESULT_FILE"
    echo '      "score": '$score',' >> "$RESULT_FILE"
    echo '      "max_score": '$points',' >> "$RESULT_FILE"
    echo '      "matched_keywords": "'${matched_keywords:1}'",' >> "$RESULT_FILE"
    echo '      "duration_sec": '$duration',' >> "$RESULT_FILE"
    echo '      "response_preview": "'$escaped_response'"' >> "$RESULT_FILE"
    echo '    },' >> "$RESULT_FILE"
}

# Parse and run tests from YAML file
echo -e "${BLUE}=== Dynamic Test Execution ===${NC}"
echo "Agent: $AGENT_ID"
echo "Test file: $TEST_FILE"
echo "Model: $MODEL"
echo ""

# Simple YAML parser for test cases
# Format expected:
# tests:
#   - id: TEST_ID
#     prompt: "prompt text"
#     keywords: ["keyword1", "keyword2"]
#     points: 5

TOTAL_SCORE=0
TOTAL_MAX=0
TESTS_PASSED=0
TESTS_FAILED=0

# Parse tests using grep and sed (simple approach for structured YAML)
current_id=""
current_prompt=""
current_keywords=""
current_points=""
in_test=false

while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Detect test start
    if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*id:[[:space:]]*(.+) ]]; then
        # If we have a previous test, run it
        if [[ -n "$current_id" && -n "$current_prompt" ]]; then
            run_test "$current_id" "$current_prompt" "$current_keywords" "${current_points:-1}"
        fi
        # Start new test
        current_id="${BASH_REMATCH[1]}"
        current_prompt=""
        current_keywords=""
        current_points=""
        in_test=true
    elif $in_test; then
        if [[ "$line" =~ ^[[:space:]]*prompt:[[:space:]]*[\"\']*(.+)[\"\']*$ ]]; then
            current_prompt="${BASH_REMATCH[1]}"
            # Remove trailing quote if present
            current_prompt="${current_prompt%\"}"
            current_prompt="${current_prompt%\'}"
        elif [[ "$line" =~ ^[[:space:]]*keywords:[[:space:]]*\[(.+)\] ]]; then
            current_keywords="${BASH_REMATCH[1]}"
            # Clean up keywords
            current_keywords=$(echo "$current_keywords" | sed 's/"//g' | sed "s/'//g")
        elif [[ "$line" =~ ^[[:space:]]*points:[[:space:]]*([0-9]+) ]]; then
            current_points="${BASH_REMATCH[1]}"
        fi
    fi
done < "$TEST_FILE"

# Run last test if exists
if [[ -n "$current_id" && -n "$current_prompt" ]]; then
    run_test "$current_id" "$current_prompt" "$current_keywords" "${current_points:-1}"
fi

# Close JSON array (remove trailing comma)
sed -i.bak '$ s/,$//' "$RESULT_FILE" 2>/dev/null || sed -i '' '$ s/,$//' "$RESULT_FILE"
rm -f "${RESULT_FILE}.bak"

echo '  ],' >> "$RESULT_FILE"
echo '  "summary": {' >> "$RESULT_FILE"
echo '    "total_tests": '$((TESTS_PASSED + TESTS_FAILED))',' >> "$RESULT_FILE"
echo '    "passed": '$TESTS_PASSED',' >> "$RESULT_FILE"
echo '    "failed": '$TESTS_FAILED',' >> "$RESULT_FILE"
echo '    "total_score": '$TOTAL_SCORE',' >> "$RESULT_FILE"
echo '    "max_score": '$TOTAL_MAX >> "$RESULT_FILE"
echo '  }' >> "$RESULT_FILE"
echo '}' >> "$RESULT_FILE"

# Summary
echo ""
echo -e "${BLUE}=== Summary ===${NC}"
echo "Results saved to: $RESULT_FILE"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
else
    exit 0
fi
