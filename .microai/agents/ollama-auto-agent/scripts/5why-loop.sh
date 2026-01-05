#!/bin/bash
#
# 5-Why Auto Loop Script
# Runs continuous 5-Why analysis using Ollama until root cause is found
#
# Usage: ./5why-loop.sh --problem "Your problem statement"
#        ./5why-loop.sh --problem "Your problem" --model qwen3:8b --max-depth 15
#

# ============================================================================
# Configuration
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$AGENT_DIR/output"

# Defaults
DEFAULT_MODEL="qwen3:1.7b"
DEFAULT_MAX_DEPTH=20
DEFAULT_TIMEOUT=180

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ============================================================================
# Helper Functions
# ============================================================================
print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_why() {
    local num=$1
    local question=$2
    echo -e "\n${YELLOW}WHY #${num}:${NC} ${question}"
}

print_answer() {
    echo -e "${GREEN}ANSWER:${NC} $1"
}

print_root_cause() {
    echo -e "\n${RED}${BOLD}🎯 ROOT CAUSE FOUND (iteration #$1)${NC}"
    echo -e "${RED}→ $2${NC}"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Call Ollama API and extract clean response
call_ollama() {
    local model="$1"
    local system="$2"
    local prompt="$3"
    local timeout="${4:-180}"

    # Add /no_think prefix to disable extended thinking for qwen3 models
    local full_prompt="/no_think $prompt"

    # Escape special chars for JSON
    local escaped_system=$(echo "$system" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | tr '\n' ' ')
    local escaped_prompt=$(echo "$full_prompt" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | tr '\n' ' ')

    # Make API call with enough tokens to complete thinking + answer
    local response
    response=$(curl -s --max-time "$timeout" http://localhost:11434/api/generate \
        -H "Content-Type: application/json" \
        -d "{\"model\": \"$model\", \"prompt\": \"$escaped_prompt\", \"system\": \"$escaped_system\", \"stream\": false, \"options\": {\"num_predict\": 500}}" 2>/dev/null)

    # Check if we got a valid response
    if [ -z "$response" ]; then
        echo ""
        return 1
    fi

    # Extract response field using jq
    local text
    if command -v jq &> /dev/null; then
        text=$(echo "$response" | jq -r '.response // empty' 2>/dev/null)
    else
        text=$(echo "$response" | grep -o '"response":"[^"]*"' | head -1 | sed 's/"response":"//;s/"$//')
    fi

    # Remove <think>...</think> tags and content (qwen3 thinking mode)

    # First, remove empty think blocks: <think>\n\n</think> or <think></think>
    text=$(echo "$text" | sed 's/<think>[[:space:]]*<\/think>//g')

    # If there's still </think>, get content after it
    if echo "$text" | grep -q '</think>'; then
        text=$(echo "$text" | awk -F'</think>' '{print $NF}')
    fi

    # Remove any remaining <think> tag (without closing)
    text=$(echo "$text" | sed 's/<think>//g')

    # Clean up whitespace and newlines
    text=$(echo "$text" | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

    echo "$text"
}

# ============================================================================
# Parse Arguments
# ============================================================================
PROBLEM=""
MODEL="$DEFAULT_MODEL"
MAX_DEPTH="$DEFAULT_MAX_DEPTH"
TIMEOUT="$DEFAULT_TIMEOUT"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --problem|-p)
            PROBLEM="$2"
            shift 2
            ;;
        --model|-m)
            MODEL="$2"
            shift 2
            ;;
        --max-depth|-d)
            MAX_DEPTH="$2"
            shift 2
            ;;
        --timeout|-t)
            TIMEOUT="$2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 --problem \"Your problem statement\" [options]"
            echo ""
            echo "Options:"
            echo "  --problem, -p    Problem statement to analyze (required)"
            echo "  --model, -m      Ollama model to use (default: $DEFAULT_MODEL)"
            echo "  --max-depth, -d  Maximum iterations (default: $DEFAULT_MAX_DEPTH)"
            echo "  --timeout, -t    Timeout per inference in seconds (default: $DEFAULT_TIMEOUT)"
            echo "  --verbose, -v    Show detailed output"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$PROBLEM" ]; then
    print_error "Problem statement is required. Use --problem \"your problem\""
    exit 1
fi

# ============================================================================
# Check Prerequisites
# ============================================================================
echo -e "${BLUE}🔍 5-Why Auto Analyzer${NC}"
echo -e "Model: ${MODEL}"
echo -e "Max Depth: ${MAX_DEPTH}"

# Check Ollama service is running
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    print_error "Ollama not running. Please run: ollama serve"
    exit 1
fi
echo -e "${GREEN}✓ Ollama ready${NC}"

# Create output directory
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/5why-${TIMESTAMP}.md"

# ============================================================================
# Initialize Analysis
# ============================================================================
print_header "5-Why Analysis Started"
echo -e "Problem: ${BOLD}${PROBLEM}${NC}"
START_TIME=$(date +%s)

# Initialize context and tracking
TEMP_DIR=$(mktemp -d)
CHAIN_FILE="$TEMP_DIR/chain.txt"
touch "$CHAIN_FILE"
ITERATION=0
ROOT_CAUSE_FOUND=false
LAST_ANSWER=""
RETRY_COUNT=0
MAX_RETRIES=3

# ============================================================================
# System Prompts - Enforce Vietnamese output
# ============================================================================
SYSTEM_PROMPT_WHY="BẮT BUỘC: Trả lời HOÀN TOÀN bằng TIẾNG VIỆT. Không được dùng tiếng Anh.

Bạn là chuyên gia phân tích 5-Why. Quy tắc:
1. CHỈ trả lời bằng tiếng Việt
2. Trả lời ngắn gọn 1-2 câu
3. Đưa ra nguyên nhân trực tiếp
4. Nếu đây là nguyên nhân gốc rễ cuối cùng, bắt đầu bằng [ROOT_CAUSE]

Ví dụ câu trả lời đúng:
- Vì server quá tải do lượng truy cập cao.
- Do thiếu kiểm tra code trước khi deploy.
- [ROOT_CAUSE] Thiếu quy trình code review bắt buộc."

SYSTEM_PROMPT_EVALUATE="Trả lời CHỈ một từ: YES hoặc NO. Không giải thích."

# ============================================================================
# Main Analysis Loop
# ============================================================================
while [ "$ROOT_CAUSE_FOUND" = false ] && [ $ITERATION -lt $MAX_DEPTH ]; do
    ITERATION=$((ITERATION + 1))

    # Generate Why question
    if [ $ITERATION -eq 1 ]; then
        WHY_QUESTION="Tại sao '$PROBLEM' xảy ra?"
    else
        WHY_QUESTION="Tại sao '$LAST_ANSWER' xảy ra?"
    fi

    print_why "$ITERATION" "$WHY_QUESTION"

    # Build history
    HISTORY=""
    if [ -s "$CHAIN_FILE" ]; then
        HISTORY="Lịch sử phân tích:
$(cat "$CHAIN_FILE")"
    fi

    # Build context
    FULL_CONTEXT="Problem: $PROBLEM
$HISTORY
Câu hỏi: $WHY_QUESTION
Trả lời ngắn gọn:"

    # Get answer
    echo -ne "${CYAN}Thinking...${NC}"
    ANSWER=$(call_ollama "$MODEL" "$SYSTEM_PROMPT_WHY" "$FULL_CONTEXT" "$TIMEOUT")
    echo -ne "\r                    \r"

    # Validate answer
    if [ -z "$ANSWER" ] || [ ${#ANSWER} -lt 10 ]; then
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
            print_error "Failed to get response after $MAX_RETRIES retries"
            break
        fi
        echo -e "${YELLOW}Retrying ($RETRY_COUNT/$MAX_RETRIES)...${NC}"
        sleep 2
        ITERATION=$((ITERATION - 1))
        continue
    fi
    RETRY_COUNT=0

    print_answer "$ANSWER"

    # Check for root cause marker
    if [[ "$ANSWER" == *"[ROOT_CAUSE]"* ]] || [[ "$ANSWER" == *"ROOT_CAUSE"* ]]; then
        ANSWER=$(echo "$ANSWER" | sed 's/\[ROOT_CAUSE\]//g' | sed 's/ROOT_CAUSE//g' | sed 's/^[[:space:]]*//')
        ROOT_CAUSE_FOUND=true
        print_root_cause "$ITERATION" "$ANSWER"
    else
        # Auto-evaluate after iteration 4
        if [ $ITERATION -ge 4 ]; then
            EVAL_PROMPT="Phân tích: $ANSWER - Đây có phải root cause?"
            EVAL_RESULT=$(call_ollama "$MODEL" "$SYSTEM_PROMPT_EVALUATE" "$EVAL_PROMPT" "60")
            EVAL_RESULT=$(echo "$EVAL_RESULT" | tr '[:lower:]' '[:upper:]')

            if [[ "$EVAL_RESULT" == *"YES"* ]]; then
                ROOT_CAUSE_FOUND=true
                print_root_cause "$ITERATION" "$ANSWER"
            fi
        fi
    fi

    # Save to chain
    echo "Why #$ITERATION: $ANSWER" >> "$CHAIN_FILE"
    LAST_ANSWER="$ANSWER"

    sleep 1

done

# ============================================================================
# Generate Report
# ============================================================================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ "$ROOT_CAUSE_FOUND" = false ]; then
    echo -e "\n${YELLOW}⚠️  Max depth ($MAX_DEPTH) reached${NC}"
fi

ROOT_CAUSE="$LAST_ANSWER"

# Write report
cat > "$REPORT_FILE" << EOF
# 5-Why Analysis Report

> **Generated:** $(date '+%Y-%m-%d %H:%M:%S')
> **Model:** $MODEL
> **Iterations:** $ITERATION
> **Duration:** ${DURATION}s

## Problem Statement

**$PROBLEM**

## Analysis Chain

EOF

WHY_NUM=0
while IFS= read -r line; do
    WHY_NUM=$((WHY_NUM + 1))
    ANSWER_TEXT=$(echo "$line" | sed 's/^Why #[0-9]*: //')
    echo "### Why #$WHY_NUM" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "**A:** $ANSWER_TEXT" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
done < "$CHAIN_FILE"

cat >> "$REPORT_FILE" << EOF

## Root Cause

🎯 **$ROOT_CAUSE**

## Recommendations

1. **Immediate:** Address root cause directly
2. **Prevention:** Implement safeguards
3. **Verify:** Test solution resolves original problem

---
| Metric | Value |
|--------|-------|
| Model | $MODEL |
| Iterations | $ITERATION |
| Duration | ${DURATION}s |
| Root Found | $ROOT_CAUSE_FOUND |

*Generated by 5-Why Auto Analyzer*
EOF

rm -rf "$TEMP_DIR"

echo -e "\n${GREEN}📋 Report: ${REPORT_FILE}${NC}"

print_header "Analysis Complete"
echo -e "Iterations: ${BOLD}$ITERATION${NC}"
echo -e "Duration: ${BOLD}${DURATION}s${NC}"
echo -e "Root Cause Found: ${BOLD}$ROOT_CAUSE_FOUND${NC}"
echo -e "\n${BOLD}Root Cause:${NC}"
echo -e "${RED}$ROOT_CAUSE${NC}"
