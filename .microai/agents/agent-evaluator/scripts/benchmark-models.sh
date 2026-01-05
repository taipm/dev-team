#!/usr/bin/env bash
#
# benchmark-models.sh - Compare agent performance across different LLM models
#
# Usage:
#   benchmark-models.sh --agent AGENT_ID [--models "model1,model2"]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

# Defaults
AGENT_ID=""
TIMEOUT=60

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --agent)
            AGENT_ID="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [[ -z "$AGENT_ID" ]]; then
    echo -e "${RED}Error: --agent is required${NC}"
    exit 1
fi

AGENT_FILE="$MICROAI_DIR/agents/$AGENT_ID/agent.md"
if [[ ! -f "$AGENT_FILE" ]]; then
    echo -e "${RED}Error: Agent not found: $AGENT_ID${NC}"
    exit 1
fi

# Extract system prompt
AGENT_SYSTEM=$(sed -n '/system: |/,/must:/p' "$AGENT_FILE" 2>/dev/null | head -20 | tail -n +2 | sed 's/^      //' || echo "You are an AI assistant.")

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           MULTI-MODEL BENCHMARK                                        ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Models: qwen3:1.7b, deepseek-r1:1.5b, claude (opus/sonnet/haiku)     ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test cases - with descriptions and categories
declare -a TEST_IDS=("R-L1" "R-M1" "R-E1" "A-A1" "O-C1")
declare -a TEST_CATEGORIES=("Reasoning" "Reasoning" "Reasoning" "Adaptability" "Output Quality")
declare -a TEST_NAMES=(
    "Syllogism Logic"
    "Dependency Resolution"
    "Circular Dependency Detection"
    "Ambiguity Handling"
    "OOP Knowledge"
)
declare -a TEST_DESCRIPTIONS=(
    "Kiểm tra khả năng suy luận logic cơ bản (A→B, B→C ⇒ A→C)"
    "Kiểm tra khả năng suy luận multi-step để xác định thứ tự khởi tạo"
    "Kiểm tra phát hiện edge case: circular dependency"
    "Kiểm tra khả năng xử lý input mơ hồ - cần hỏi lại thay vì đoán"
    "Kiểm tra domain knowledge về OOP fundamentals"
)
declare -a TEST_PROMPTS=(
    "All programmers use computers. John is a programmer. Does John use a computer?"
    "Module A imports B. B imports C. C imports D. What is the correct initialization order?"
    "Service A calls B. B calls A. What problem does this create?"
    "Fix the bug"
    "What are the 4 pillars of OOP?"
)
declare -a TEST_KEYWORDS=(
    "yes,correct,true,does,uses"
    "D,C,B,A"
    "circular,cycle,infinite,loop,deadlock"
    "which,what,where,information,clarify,specify"
    "encapsulation,inheritance,polymorphism,abstraction"
)
declare -a TEST_POINTS=(2 3 3 3 4)

# Results storage
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/model-benchmark-${AGENT_ID}-${TIMESTAMP}.md"

# Function to run test with Ollama - returns score|status|response|matched
run_ollama_test() {
    local model="$1"
    local prompt="$2"
    local keywords="$3"
    local points="$4"

    local full_prompt="$AGENT_SYSTEM

User: $prompt

Respond concisely. /no_think"

    local response=""
    response=$("$OLLAMA_SCRIPT" --model "$model" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || {
        echo "0|error|[No response]|"
        return
    }

    # Clean response before grading (remove ANSI codes that may interfere with grep)
    local clean_for_grade=$(echo "$response" | \
        sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g' | \
        sed 's/\[?[0-9]*[lh]//g' | \
        tr -d '⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋⠛⠿')

    local grade=$("$GRADE_SCRIPT" --response "$clean_for_grade" --keywords "$keywords" --points "$points" --json 2>/dev/null) || {
        echo "0|error|$response|"
        return
    }

    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local status=$(echo "$grade" | grep -o '"status": "[^"]*"' | head -1 | cut -d'"' -f4)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    # Clean response for display: remove thinking tags, normalize whitespace
    local clean_response=$(echo "$clean_for_grade" | \
        sed 's/<think>.*<\/think>//g' | \
        sed 's/Thinking\.\.\.//g' | \
        tr '\n' ' ' | \
        sed 's/  */ /g' | \
        sed 's/^ *//' | \
        cut -c1-150)
    echo "${score:-0}|${status:-fail}|${clean_response}|${matched}"
}

# Function to run test with Claude - returns score|status|response|matched
run_claude_test() {
    local model="$1"
    local prompt="$2"
    local keywords="$3"
    local points="$4"

    local full_prompt="$AGENT_SYSTEM

User: $prompt

Respond concisely and directly in 1-2 sentences."

    local response=""
    # Use claude CLI with specific model
    response=$(echo "$full_prompt" | claude --model "$model" --print 2>&1) || {
        echo "0|error|[No response]|"
        return
    }

    local grade=$("$GRADE_SCRIPT" --response "$response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || {
        echo "0|error|$response|"
        return
    }

    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local status=$(echo "$grade" | grep -o '"status": "[^"]*"' | head -1 | cut -d'"' -f4)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    # Clean response for report (first 200 chars, single line)
    local clean_response=$(echo "$response" | tr '\n' ' ' | cut -c1-200)
    echo "${score:-0}|${status:-fail}|${clean_response}|${matched}"
}

# Initialize model scores
QWEN_TOTAL=0
DEEPSEEK_TOTAL=0
OPUS_TOTAL=0
SONNET_TOTAL=0
HAIKU_TOTAL=0
MAX_TOTAL=0

# Start report
cat > "$REPORT_FILE" << EOF
# Multi-Model Benchmark Report

> So sánh hiệu suất agent trên các LLM providers và models khác nhau.

---

## Thông tin Benchmark

| Thuộc tính | Giá trị |
|------------|---------|
| **Agent** | $AGENT_ID |
| **Thời gian** | $(date '+%Y-%m-%d %H:%M:%S') |
| **Models tested** | qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku |
| **Tổng test cases** | ${#TEST_IDS[@]} |
| **Điểm tối đa** | 15 |

---

## Tổng hợp Điểm số

| Test | Max | qwen3:1.7b | deepseek-r1:1.5b | claude-opus | claude-sonnet | claude-haiku |
|------|-----|------------|------------------|-------------|---------------|--------------|
EOF

# Storage for detailed results
DETAILED_RESULTS=""

# Run tests
for i in "${!TEST_IDS[@]}"; do
    test_id="${TEST_IDS[$i]}"
    test_name="${TEST_NAMES[$i]}"
    test_category="${TEST_CATEGORIES[$i]}"
    test_desc="${TEST_DESCRIPTIONS[$i]}"
    prompt="${TEST_PROMPTS[$i]}"
    keywords="${TEST_KEYWORDS[$i]}"
    points="${TEST_POINTS[$i]}"

    MAX_TOTAL=$((MAX_TOTAL + points))

    echo -e "${YELLOW}Testing: $test_id - $test_name (${points} pts)${NC}"
    echo "  Prompt: ${prompt:0:50}..."

    # Start detailed section for this test
    DETAILED_RESULTS+="
### $test_id: $test_name

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | $test_category |
| **Mô tả** | $test_desc |
| **Prompt** | \`$prompt\` |
| **Keywords expected** | \`$keywords\` |
| **Điểm tối đa** | $points |

#### Kết quả theo Model

"

    # Ollama models
    echo -n "  qwen3:1.7b... "
    result=$(run_ollama_test "qwen3:1.7b" "$prompt" "$keywords" "$points")
    qwen_score=$(echo "$result" | cut -d'|' -f1)
    qwen_status=$(echo "$result" | cut -d'|' -f2)
    qwen_response=$(echo "$result" | cut -d'|' -f3)
    qwen_matched=$(echo "$result" | cut -d'|' -f4)
    QWEN_TOTAL=$(echo "$QWEN_TOTAL + ${qwen_score:-0}" | bc)
    if [[ "$qwen_status" == "pass" ]]; then
        echo -e "${GREEN}${qwen_score}/${points}${NC}"
        qwen_icon="✅"
    else
        echo -e "${RED}${qwen_score}/${points}${NC}"
        qwen_icon="❌"
    fi

    echo -n "  deepseek-r1:1.5b... "
    result=$(run_ollama_test "deepseek-r1:1.5b" "$prompt" "$keywords" "$points")
    deepseek_score=$(echo "$result" | cut -d'|' -f1)
    deepseek_status=$(echo "$result" | cut -d'|' -f2)
    deepseek_response=$(echo "$result" | cut -d'|' -f3)
    deepseek_matched=$(echo "$result" | cut -d'|' -f4)
    DEEPSEEK_TOTAL=$(echo "$DEEPSEEK_TOTAL + ${deepseek_score:-0}" | bc)
    if [[ "$deepseek_status" == "pass" ]]; then
        echo -e "${GREEN}${deepseek_score}/${points}${NC}"
        deepseek_icon="✅"
    else
        echo -e "${RED}${deepseek_score}/${points}${NC}"
        deepseek_icon="❌"
    fi

    # Claude models
    echo -n "  claude-opus... "
    result=$(run_claude_test "opus" "$prompt" "$keywords" "$points")
    opus_score=$(echo "$result" | cut -d'|' -f1)
    opus_status=$(echo "$result" | cut -d'|' -f2)
    opus_response=$(echo "$result" | cut -d'|' -f3)
    opus_matched=$(echo "$result" | cut -d'|' -f4)
    OPUS_TOTAL=$(echo "$OPUS_TOTAL + ${opus_score:-0}" | bc)
    if [[ "$opus_status" == "pass" ]]; then
        echo -e "${GREEN}${opus_score}/${points}${NC}"
        opus_icon="✅"
    else
        echo -e "${RED}${opus_score}/${points}${NC}"
        opus_icon="❌"
    fi

    echo -n "  claude-sonnet... "
    result=$(run_claude_test "sonnet" "$prompt" "$keywords" "$points")
    sonnet_score=$(echo "$result" | cut -d'|' -f1)
    sonnet_status=$(echo "$result" | cut -d'|' -f2)
    sonnet_response=$(echo "$result" | cut -d'|' -f3)
    sonnet_matched=$(echo "$result" | cut -d'|' -f4)
    SONNET_TOTAL=$(echo "$SONNET_TOTAL + ${sonnet_score:-0}" | bc)
    if [[ "$sonnet_status" == "pass" ]]; then
        echo -e "${GREEN}${sonnet_score}/${points}${NC}"
        sonnet_icon="✅"
    else
        echo -e "${RED}${sonnet_score}/${points}${NC}"
        sonnet_icon="❌"
    fi

    echo -n "  claude-haiku... "
    result=$(run_claude_test "haiku" "$prompt" "$keywords" "$points")
    haiku_score=$(echo "$result" | cut -d'|' -f1)
    haiku_status=$(echo "$result" | cut -d'|' -f2)
    haiku_response=$(echo "$result" | cut -d'|' -f3)
    haiku_matched=$(echo "$result" | cut -d'|' -f4)
    HAIKU_TOTAL=$(echo "$HAIKU_TOTAL + ${haiku_score:-0}" | bc)
    if [[ "$haiku_status" == "pass" ]]; then
        echo -e "${GREEN}${haiku_score}/${points}${NC}"
        haiku_icon="✅"
    else
        echo -e "${RED}${haiku_score}/${points}${NC}"
        haiku_icon="❌"
    fi

    # Write summary to report
    echo "| $test_id | $points | $qwen_score | $deepseek_score | $opus_score | $sonnet_score | $haiku_score |" >> "$REPORT_FILE"

    # Add detailed results
    DETAILED_RESULTS+="| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | ${qwen_score}/${points} | ${qwen_icon} | \`${qwen_matched:-none}\` | ${qwen_response:0:100}... |
| deepseek-r1:1.5b | ${deepseek_score}/${points} | ${deepseek_icon} | \`${deepseek_matched:-none}\` | ${deepseek_response:0:100}... |
| claude-opus | ${opus_score}/${points} | ${opus_icon} | \`${opus_matched:-none}\` | ${opus_response:0:100}... |
| claude-sonnet | ${sonnet_score}/${points} | ${sonnet_icon} | \`${sonnet_matched:-none}\` | ${sonnet_response:0:100}... |
| claude-haiku | ${haiku_score}/${points} | ${haiku_icon} | \`${haiku_matched:-none}\` | ${haiku_response:0:100}... |

---
"
    echo ""
done

# Calculate percentages
QWEN_PCT=$(echo "scale=0; $QWEN_TOTAL * 100 / $MAX_TOTAL" | bc)
DEEPSEEK_PCT=$(echo "scale=0; $DEEPSEEK_TOTAL * 100 / $MAX_TOTAL" | bc)
OPUS_PCT=$(echo "scale=0; $OPUS_TOTAL * 100 / $MAX_TOTAL" | bc)
SONNET_PCT=$(echo "scale=0; $SONNET_TOTAL * 100 / $MAX_TOTAL" | bc)
HAIKU_PCT=$(echo "scale=0; $HAIKU_TOTAL * 100 / $MAX_TOTAL" | bc)

# Add totals to report
echo "| **TOTAL** | **$MAX_TOTAL** | **$QWEN_TOTAL ($QWEN_PCT%)** | **$DEEPSEEK_TOTAL ($DEEPSEEK_PCT%)** | **$OPUS_TOTAL ($OPUS_PCT%)** | **$SONNET_TOTAL ($SONNET_PCT%)** | **$HAIKU_TOTAL ($HAIKU_PCT%)** |" >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## Summary

| Rank | Model | Score | Percentage | Type |
|------|-------|-------|------------|------|
EOF

# Sort and rank
declare -a scores=("$QWEN_TOTAL:qwen3:1.7b:Ollama" "$DEEPSEEK_TOTAL:deepseek-r1:1.5b:Ollama" "$OPUS_TOTAL:claude-opus:Claude" "$SONNET_TOTAL:claude-sonnet:Claude" "$HAIKU_TOTAL:claude-haiku:Claude")
IFS=$'\n' sorted=($(sort -t: -k1 -nr <<<"${scores[*]}")); unset IFS

rank=1
for item in "${sorted[@]}"; do
    score=$(echo "$item" | cut -d: -f1)
    model=$(echo "$item" | cut -d: -f2)
    type=$(echo "$item" | cut -d: -f3)
    pct=$(echo "scale=0; $score * 100 / $MAX_TOTAL" | bc)
    echo "| #$rank | $model | $score/$MAX_TOTAL | $pct% | $type |" >> "$REPORT_FILE"
    rank=$((rank + 1))
done

cat >> "$REPORT_FILE" << EOF

---

## Phân tích Tổng hợp

### Local Models (Ollama)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| qwen3:1.7b | ${QWEN_TOTAL}/${MAX_TOTAL} | ${QWEN_PCT}% | $(if [ "$QWEN_PCT" -ge 70 ]; then echo "✅ Tốt"; elif [ "$QWEN_PCT" -ge 50 ]; then echo "⚠️ Trung bình"; else echo "❌ Yếu"; fi) |
| deepseek-r1:1.5b | ${DEEPSEEK_TOTAL}/${MAX_TOTAL} | ${DEEPSEEK_PCT}% | $(if [ "$DEEPSEEK_PCT" -ge 70 ]; then echo "✅ Tốt"; elif [ "$DEEPSEEK_PCT" -ge 50 ]; then echo "⚠️ Trung bình"; else echo "❌ Yếu"; fi) |

### Cloud Models (Claude)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| claude-opus | ${OPUS_TOTAL}/${MAX_TOTAL} | ${OPUS_PCT}% | $(if [ "$OPUS_PCT" -ge 70 ]; then echo "✅ Tốt"; elif [ "$OPUS_PCT" -ge 50 ]; then echo "⚠️ Trung bình"; else echo "❌ Yếu"; fi) |
| claude-sonnet | ${SONNET_TOTAL}/${MAX_TOTAL} | ${SONNET_PCT}% | $(if [ "$SONNET_PCT" -ge 70 ]; then echo "✅ Tốt"; elif [ "$SONNET_PCT" -ge 50 ]; then echo "⚠️ Trung bình"; else echo "❌ Yếu"; fi) |
| claude-haiku | ${HAIKU_TOTAL}/${MAX_TOTAL} | ${HAIKU_PCT}% | $(if [ "$HAIKU_PCT" -ge 70 ]; then echo "✅ Tốt"; elif [ "$HAIKU_PCT" -ge 50 ]; then echo "⚠️ Trung bình"; else echo "❌ Yếu"; fi) |

---

## Chi tiết từng Test Case

$DETAILED_RESULTS

---

## Kết luận

- **Best performer**: Model đạt điểm cao nhất trên agent này
- **Local vs Cloud**: So sánh hiệu suất giữa local models và cloud models
- **Recommendations**: Đề xuất model phù hợp cho use case cụ thể

---

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*
*Agent Evaluator v2.0*
EOF

# Final summary
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           BENCHMARK RESULTS                                            ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "qwen3:1.7b (Ollama):" "$QWEN_TOTAL" "$MAX_TOTAL" "$QWEN_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "deepseek-r1:1.5b (Ollama):" "$DEEPSEEK_TOTAL" "$MAX_TOTAL" "$DEEPSEEK_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-opus (Cloud):" "$OPUS_TOTAL" "$MAX_TOTAL" "$OPUS_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-sonnet (Cloud):" "$SONNET_TOTAL" "$MAX_TOTAL" "$SONNET_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-haiku (Cloud):" "$HAIKU_TOTAL" "$MAX_TOTAL" "$HAIKU_PCT"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Report saved to: $REPORT_FILE"
