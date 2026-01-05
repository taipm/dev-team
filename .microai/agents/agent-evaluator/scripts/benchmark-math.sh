#!/usr/bin/env bash
#
# benchmark-math.sh - Run Mathematics Benchmark
# Tests mathematical reasoning capabilities across difficulty tiers
#
# Usage:
#   benchmark-math.sh [--tier easy|medium|hard|expert|all]
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

# Parse arguments
TIER="all"
while [[ $# -gt 0 ]]; do
    case $1 in
        --tier) TIER="$2"; shift 2 ;;
        easy|medium|hard|expert|all) TIER="$1"; shift ;;
        *) shift ;;
    esac
done
TIMEOUT=90

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║            MATHEMATICS BENCHMARK v1.0                                  ║${NC}"
echo -e "${CYAN}║            Testing Mathematical Reasoning Capabilities                 ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Tier: ${TIER}${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Output
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/math-benchmark-${TIER}-${TIMESTAMP}.md"

# Clean ANSI
clean_ansi() {
    echo "$1" | sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g' | sed 's/\[?[0-9]*[lh]//g' | tr -d '⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋⠛⠿'
}

# Run Ollama test
run_ollama() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="You are a math expert. Solve this problem step by step.

$prompt

Show your work clearly. Give the final answer. /no_think"

    local response=$("$OLLAMA_SCRIPT" --model "$model" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || echo ""
    local clean=$(clean_ansi "$response")
    local grade=$("$GRADE_SCRIPT" --response "$clean" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$clean" | tr '\n' ' ' | cut -c1-200)"
}

# Run Claude test
run_claude() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="You are a math expert. Solve this problem step by step.

$prompt

Show your work clearly. Give the final answer."

    local response=$(echo "$full_prompt" | claude --model "$model" --print 2>&1) || echo ""
    local grade=$("$GRADE_SCRIPT" --response "$response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$response" | tr '\n' ' ' | cut -c1-200)"
}

# Initialize totals
QWEN=0; DEEPSEEK=0; OPUS=0; SONNET=0; HAIKU=0
MAX_POINTS=0

# Start report
cat > "$REPORT_FILE" << 'EOF'
# Mathematics Benchmark Report

> Testing mathematical reasoning across difficulty tiers
> Models: qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku

---

## Results

| Test | Points | qwen3 | deepseek | opus | sonnet | haiku |
|------|--------|-------|----------|------|--------|-------|
EOF

# Function to run a test
run_test() {
    local id="$1" name="$2" prompt="$3" keywords="$4" points="$5"

    echo -e "\n${YELLOW}[$id] $name ($points pts)${NC}"

    echo -n "  qwen3:1.7b... "
    r=$(run_ollama "qwen3:1.7b" "$prompt" "$keywords" "$points")
    s1=$(echo "$r"|cut -d'|' -f1)
    m1=$(echo "$r"|cut -d'|' -f2)
    QWEN=$(echo "$QWEN+$s1"|bc)
    echo -e "${GREEN}$s1/$points${NC} [$m1]"

    echo -n "  deepseek-r1:1.5b... "
    r=$(run_ollama "deepseek-r1:1.5b" "$prompt" "$keywords" "$points")
    s2=$(echo "$r"|cut -d'|' -f1)
    m2=$(echo "$r"|cut -d'|' -f2)
    DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc)
    echo -e "${GREEN}$s2/$points${NC} [$m2]"

    echo -n "  claude-opus... "
    r=$(run_claude "opus" "$prompt" "$keywords" "$points")
    s3=$(echo "$r"|cut -d'|' -f1)
    m3=$(echo "$r"|cut -d'|' -f2)
    OPUS=$(echo "$OPUS+$s3"|bc)
    echo -e "${GREEN}$s3/$points${NC} [$m3]"

    echo -n "  claude-sonnet... "
    r=$(run_claude "sonnet" "$prompt" "$keywords" "$points")
    s4=$(echo "$r"|cut -d'|' -f1)
    m4=$(echo "$r"|cut -d'|' -f2)
    SONNET=$(echo "$SONNET+$s4"|bc)
    echo -e "${GREEN}$s4/$points${NC} [$m4]"

    echo -n "  claude-haiku... "
    r=$(run_claude "haiku" "$prompt" "$keywords" "$points")
    s5=$(echo "$r"|cut -d'|' -f1)
    m5=$(echo "$r"|cut -d'|' -f2)
    HAIKU=$(echo "$HAIKU+$s5"|bc)
    echo -e "${GREEN}$s5/$points${NC} [$m5]"

    echo "| $id $name | $points | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"
    MAX_POINTS=$((MAX_POINTS + points))
}

# ===============================
# EASY TIER (15 points)
# ===============================
if [[ "$TIER" == "easy" || "$TIER" == "all" ]]; then
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}   EASY TIER (4 tests, 15 points)${NC}"
    echo -e "${MAGENTA}   Expected: Local 60%+, Cloud 90%+${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

    run_test "M-E1" "Arithmetic" \
        "Tính: 3 + 5 × 2 + 4 ÷ 2 = ? Giải thích thứ tự thực hiện phép tính." \
        "15,nhân,chia,trước,PEMDAS,BODMAS" \
        3

    run_test "M-E2" "Linear Equation" \
        "Giải phương trình: 3x + 7 = 2x + 12. Tìm giá trị của x." \
        "5,x = 5,x=5" \
        4

    run_test "M-E3" "Triangle Area" \
        "Tính diện tích tam giác có đáy 8cm và chiều cao 6cm. Công thức và kết quả?" \
        "24,1/2,đáy,cao,base,height" \
        4

    run_test "M-E4" "Percentage" \
        "Một mặt hàng giá gốc 150.000đ được giảm 10%. Tính giá sau khi giảm?" \
        "135,135000,15000,90%" \
        4
fi

# ===============================
# MEDIUM TIER (25 points)
# ===============================
if [[ "$TIER" == "medium" || "$TIER" == "all" ]]; then
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}   MEDIUM TIER (5 tests, 25 points)${NC}"
    echo -e "${MAGENTA}   Expected: Local 30-50%, Cloud 70%+${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

    run_test "M-M1" "Quadratic Equation" \
        "Giải phương trình bậc 2: x² - 5x + 6 = 0. Tìm tất cả các nghiệm." \
        "2,3,x = 2,x = 3,delta,phân tích,factor" \
        5

    run_test "M-M2" "Arithmetic Sequence" \
        "Cho dãy số cộng: 2, 5, 8, 11, ... a) Tìm công sai d. b) Tìm số hạng thứ 17 của dãy." \
        "3,50,d = 3,công sai" \
        5

    run_test "M-M3" "Trigonometry" \
        "Trong tam giác vuông ABC vuông tại A, biết BC = 10cm, góc B = 30°. Tính cạnh AC. Dùng: sin30° = 0.5" \
        "5,sin,AC = 5" \
        5

    run_test "M-M4" "Probability" \
        "Gieo một con xúc xắc cân đối. Tính xác suất để được mặt 6 chấm? Giải thích." \
        "1/6,0.167,không gian mẫu,thuận lợi" \
        5

    run_test "M-M5" "Parabola Vertex" \
        "Cho hàm số y = x² + 2x + 5. Xác định tọa độ đỉnh của parabol. Hàm đạt min ở đâu?" \
        "-1,4,đỉnh,vertex,min" \
        5
fi

# ===============================
# HARD TIER (35 points)
# ===============================
if [[ "$TIER" == "hard" || "$TIER" == "all" ]]; then
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}   HARD TIER (5 tests, 35 points)${NC}"
    echo -e "${MAGENTA}   Expected: Local 10-20%, Cloud 50%+${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

    run_test "M-H1" "Polynomial Division" \
        "Cho đa thức P(x) = x³ - 3x² + ax - 6. Tìm giá trị của a để P(x) chia hết cho (x - 2)." \
        "5,a = 5,Bézout,P(2) = 0" \
        7

    run_test "M-H2" "AM-GM Inequality" \
        "Cho x > 0. Tìm giá trị nhỏ nhất của S = x² + 4/x + 8/x². Dùng bất đẳng thức AM-GM." \
        "AM-GM,Cauchy,min,đạo hàm,derivative" \
        7

    run_test "M-H3" "Number Theory Proof" \
        "Chứng minh rằng với mọi n nguyên dương: n(n+1)(n+2) chia hết cho 6." \
        "chia hết,divisible,số chẵn,even,liên tiếp,consecutive" \
        7

    run_test "M-H4" "Combinatorics" \
        "Có 10 học sinh, chọn 3 làm ban cán sự (như nhau). a) Có bao nhiêu cách? b) Trong 10 có 6 nam 4 nữ, chọn ít nhất 1 nữ?" \
        "120,100,C(10,3),tổ hợp,combination" \
        7

    run_test "M-H5" "Law of Sines" \
        "Tam giác ABC có BC = 8cm, góc B = 60°, góc C = 45°. Tính cạnh AB dùng định lý sin." \
        "định lý sin,law of sines,sin 75" \
        7
fi

# ===============================
# EXPERT TIER (25 points)
# ===============================
if [[ "$TIER" == "expert" || "$TIER" == "all" ]]; then
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}   EXPERT TIER (3 tests, 25 points) - IMO Level${NC}"
    echo -e "${MAGENTA}   Expected: Local <10%, Cloud 30%+${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

    run_test "M-X1" "IMO Functional Equation" \
        "Tìm tất cả hàm f: ℝ → ℝ thỏa mãn: f(x + f(y)) = f(x) + y với mọi x, y ∈ ℝ. Chứng minh đầy đủ." \
        "f(x) = x,identity,đơn ánh,injective,toàn ánh,surjective" \
        10

    run_test "M-X2" "IMO Geometry - Orthocenter" \
        "Chứng minh rằng ba đường cao của tam giác đồng quy tại một điểm (trực tâm tồn tại)." \
        "đồng quy,concurrent,trực tâm,orthocenter,Ceva,vector" \
        8

    run_test "M-X3" "Euclid Infinite Primes" \
        "Chứng minh rằng có vô hạn số nguyên tố (Định lý Euclid)." \
        "vô hạn,infinite,phản chứng,contradiction,p₁p₂...pₙ + 1" \
        7
fi

# Calculate percentages
QWEN_PCT=$(echo "scale=0; $QWEN * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)
DEEPSEEK_PCT=$(echo "scale=0; $DEEPSEEK * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)
OPUS_PCT=$(echo "scale=0; $OPUS * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)
SONNET_PCT=$(echo "scale=0; $SONNET * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)
HAIKU_PCT=$(echo "scale=0; $HAIKU * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)

# Write totals to report
cat >> "$REPORT_FILE" << EOF
| **TOTAL** | **$MAX_POINTS** | **$QWEN ($QWEN_PCT%)** | **$DEEPSEEK ($DEEPSEEK_PCT%)** | **$OPUS ($OPUS_PCT%)** | **$SONNET ($SONNET_PCT%)** | **$HAIKU ($HAIKU_PCT%)** |

---

## Ranking

| Rank | Model | Score | % |
|------|-------|-------|---|
EOF

# Sort and rank
rank=1
echo "$OPUS:claude-opus" "$SONNET:claude-sonnet" "$HAIKU:claude-haiku" "$DEEPSEEK:deepseek-r1" "$QWEN:qwen3" | tr ' ' '\n' | sort -t: -k1 -nr | while read item; do
    score=$(echo "$item" | cut -d: -f1)
    model=$(echo "$item" | cut -d: -f2)
    pct=$(echo "scale=0; $score * 100 / $MAX_POINTS" | bc 2>/dev/null || echo 0)
    echo "| #$rank | $model | $score/$MAX_POINTS | $pct% |"
    rank=$((rank + 1))
done >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## Analysis

### Expected Performance

| Tier | Local Models | Haiku | Sonnet | Opus |
|------|--------------|-------|--------|------|
| Easy | 60%+ | 85%+ | 90%+ | 95%+ |
| Medium | 30-50% | 60%+ | 75%+ | 85%+ |
| Hard | 10-20% | 35%+ | 50%+ | 65%+ |
| Expert | <10% | 15%+ | 25%+ | 40%+ |

### Notes

- Mathematics tests focus on reasoning and problem-solving
- Keyword matching may underestimate verbose correct answers
- IMO-level problems test advanced mathematical maturity

---

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*
*Tier: $TIER | Max Points: $MAX_POINTS*
EOF

# Final summary
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           MATH BENCHMARK RESULTS                                       ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "qwen3:1.7b (Local):" "$QWEN" "$MAX_POINTS" "$QWEN_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "deepseek-r1:1.5b (Local):" "$DEEPSEEK" "$MAX_POINTS" "$DEEPSEEK_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-opus:" "$OPUS" "$MAX_POINTS" "$OPUS_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-sonnet:" "$SONNET" "$MAX_POINTS" "$SONNET_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-haiku:" "$HAIKU" "$MAX_POINTS" "$HAIKU_PCT"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Report: ${GREEN}$REPORT_FILE${NC}"
