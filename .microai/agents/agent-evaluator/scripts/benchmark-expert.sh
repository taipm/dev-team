#!/usr/bin/env bash
#
# benchmark-expert.sh - Run Expert Tier Benchmark
# Bash 3 compatible version
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

AGENT_ID="$1"
TIMEOUT=120  # Expert tests need more time

if [[ -z "$AGENT_ID" ]]; then
    AGENT_ID="go-review-linus-agent"
fi

AGENT_FILE="$MICROAI_DIR/agents/$AGENT_ID/agent.md"
AGENT_SYSTEM=$(sed -n '/system: |/,/must:/p' "$AGENT_FILE" 2>/dev/null | head -20 | tail -n +2 | sed 's/^      //' || echo "You are an AI assistant.")

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║        EXPERT TIER BENCHMARK v2.0                                      ║${NC}"
echo -e "${CYAN}║        Differentiates: opus > sonnet > haiku                           ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Tests: 3 | Max Score: 25                                              ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Output
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/expert-benchmark-${AGENT_ID}-${TIMESTAMP}.md"

# Clean ANSI
clean_ansi() {
    echo "$1" | sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g' | sed 's/\[?[0-9]*[lh]//g' | tr -d '⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋⠛⠿'
}

# Run Ollama test
run_ollama() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Explain your reasoning. Be thorough. /no_think"

    local response=$("$OLLAMA_SCRIPT" --model "$model" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || echo ""
    local clean=$(clean_ansi "$response")
    local grade=$("$GRADE_SCRIPT" --response "$clean" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$clean" | tr '\n' ' ' | cut -c1-150)"
}

# Run Claude test
run_claude() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Explain your reasoning. Be thorough."

    local response=$(echo "$full_prompt" | claude --model "$model" --print 2>&1) || echo ""
    local grade=$("$GRADE_SCRIPT" --response "$response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$response" | tr '\n' ' ' | cut -c1-150)"
}

# Initialize totals
QWEN=0; DEEPSEEK=0; OPUS=0; SONNET=0; HAIKU=0

# Start report
cat > "$REPORT_FILE" << 'EOF'
# Expert Tier Benchmark Report

> Tests: 3 | Max Score: 25 points
> Purpose: Differentiate opus > sonnet > haiku
> Expected: Local 5-15%, Haiku 10%+, Sonnet 30%+, Opus 50%+

---

## Results

| Test | Points | qwen3 | deepseek | opus | sonnet | haiku |
|------|--------|-------|----------|------|--------|-------|
EOF

echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
echo -e "${MAGENTA}   EXPERT TIER (3 tests, 25 points)${NC}"
echo -e "${MAGENTA}   These tests require deep system design and architectural thinking${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

# X-1: Distributed Rate Limiter (10 pts)
echo -e "\n${YELLOW}[X-1] Distributed Rate Limiter Design (10 pts)${NC}"
PROMPT="Design a distributed rate limiter: 1) Works across multiple API gateway instances, 2) Supports per-user and global limits, 3) Handles network partitions gracefully, 4) Sub-millisecond latency for most requests. Describe architecture, data structures, and trade-offs."
KEYWORDS="Redis,sliding window,token bucket,local cache,consistency,CAP,partition,latency"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 10); s1=$(echo "$r"|cut -d'|' -f1); m1=$(echo "$r"|cut -d'|' -f2); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/10${NC} [$m1]"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 10); s2=$(echo "$r"|cut -d'|' -f1); m2=$(echo "$r"|cut -d'|' -f2); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/10${NC} [$m2]"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 10); s3=$(echo "$r"|cut -d'|' -f1); m3=$(echo "$r"|cut -d'|' -f2); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/10${NC} [$m3]"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 10); s4=$(echo "$r"|cut -d'|' -f1); m4=$(echo "$r"|cut -d'|' -f2); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/10${NC} [$m4]"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 10); s5=$(echo "$r"|cut -d'|' -f1); m5=$(echo "$r"|cut -d'|' -f2); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/10${NC} [$m5]"
echo "| X-1 Rate Limiter | 10 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# X-2: Complex Refactoring (8 pts)
echo -e "\n${YELLOW}[X-2] Complex Function Refactoring (8 pts)${NC}"
PROMPT="A 200-line function processes orders with nested if-else: order types (express/standard/international), user types (premium/regular), service calls (inventory/payment/shipping). Each combination has different logic. Propose refactoring strategy using SOLID principles. Show patterns and interfaces."
KEYWORDS="strategy,interface,dependency injection,single responsibility,separate,factory,SOLID,pattern"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 8); s1=$(echo "$r"|cut -d'|' -f1); m1=$(echo "$r"|cut -d'|' -f2); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/8${NC} [$m1]"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 8); s2=$(echo "$r"|cut -d'|' -f1); m2=$(echo "$r"|cut -d'|' -f2); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/8${NC} [$m2]"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 8); s3=$(echo "$r"|cut -d'|' -f1); m3=$(echo "$r"|cut -d'|' -f2); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/8${NC} [$m3]"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 8); s4=$(echo "$r"|cut -d'|' -f1); m4=$(echo "$r"|cut -d'|' -f2); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/8${NC} [$m4]"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 8); s5=$(echo "$r"|cut -d'|' -f1); m5=$(echo "$r"|cut -d'|' -f2); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/8${NC} [$m5]"
echo "| X-2 Refactoring | 8 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# X-3: Advanced Cache Design (7 pts)
echo -e "\n${YELLOW}[X-3] Advanced Cache Design (7 pts)${NC}"
PROMPT="Design a cache: 1) Concurrent reads, exclusive writes, 2) Prevents thundering herd on cache miss, 3) Bounded memory with LRU eviction, 4) TTL expiration. Outline synchronization strategy, data structures, and potential pitfalls."
KEYWORDS="RWMutex,singleflight,LRU,TTL,thundering herd,eviction,concurrent,lock"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); m1=$(echo "$r"|cut -d'|' -f2); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC} [$m1]"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); m2=$(echo "$r"|cut -d'|' -f2); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC} [$m2]"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); m3=$(echo "$r"|cut -d'|' -f2); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC} [$m3]"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); m4=$(echo "$r"|cut -d'|' -f2); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC} [$m4]"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); m5=$(echo "$r"|cut -d'|' -f2); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC} [$m5]"
echo "| X-3 Cache Design | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# Calculate percentages
MAX=25
QWEN_PCT=$(echo "scale=0; $QWEN * 100 / $MAX" | bc)
DEEPSEEK_PCT=$(echo "scale=0; $DEEPSEEK * 100 / $MAX" | bc)
OPUS_PCT=$(echo "scale=0; $OPUS * 100 / $MAX" | bc)
SONNET_PCT=$(echo "scale=0; $SONNET * 100 / $MAX" | bc)
HAIKU_PCT=$(echo "scale=0; $HAIKU * 100 / $MAX" | bc)

# Write totals
cat >> "$REPORT_FILE" << EOF
| **TOTAL** | **25** | **$QWEN ($QWEN_PCT%)** | **$DEEPSEEK ($DEEPSEEK_PCT%)** | **$OPUS ($OPUS_PCT%)** | **$SONNET ($SONNET_PCT%)** | **$HAIKU ($HAIKU_PCT%)** |

---

## Ranking

| Rank | Model | Score | % | Grade |
|------|-------|-------|---|-------|
EOF

# Sort and rank
rank=1
echo "$OPUS:claude-opus" "$SONNET:claude-sonnet" "$HAIKU:claude-haiku" "$DEEPSEEK:deepseek-r1" "$QWEN:qwen3" | tr ' ' '\n' | sort -t: -k1 -nr | while read item; do
    score=$(echo "$item" | cut -d: -f1)
    model=$(echo "$item" | cut -d: -f2)
    pct=$(echo "scale=0; $score * 100 / $MAX" | bc)
    if [ "$pct" -ge 50 ]; then grade="A"; elif [ "$pct" -ge 30 ]; then grade="B"; elif [ "$pct" -ge 15 ]; then grade="C"; else grade="D"; fi
    echo "| #$rank | $model | $score/25 | $pct% | $grade |"
    rank=$((rank + 1))
done >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## Differentiation Analysis

### Expected vs Actual

| Model | Expected | Actual | Gap Analysis |
|-------|----------|--------|--------------|
| opus | 50%+ | $OPUS_PCT% | $(if [ "$OPUS_PCT" -ge 50 ]; then echo "✅ Met expectation"; else echo "❌ Below target"; fi) |
| sonnet | 30%+ | $SONNET_PCT% | $(if [ "$SONNET_PCT" -ge 30 ]; then echo "✅ Met expectation"; else echo "❌ Below target"; fi) |
| haiku | 10%+ | $HAIKU_PCT% | $(if [ "$HAIKU_PCT" -ge 10 ]; then echo "✅ Met expectation"; else echo "❌ Below target"; fi) |
| deepseek | 5-15% | $DEEPSEEK_PCT% | $(if [ "$DEEPSEEK_PCT" -le 20 ]; then echo "✅ As expected"; else echo "⚠️ Higher than expected"; fi) |
| qwen3 | 5-15% | $QWEN_PCT% | $(if [ "$QWEN_PCT" -le 20 ]; then echo "✅ As expected"; else echo "⚠️ Higher than expected"; fi) |

### Model Hierarchy Check

Expected: opus > sonnet > haiku > local models

$(if [ "$OPUS_PCT" -gt "$SONNET_PCT" ]; then echo "✅ opus > sonnet: Yes ($OPUS_PCT% > $SONNET_PCT%)"; else echo "❌ opus > sonnet: No ($OPUS_PCT% <= $SONNET_PCT%)"; fi)
$(if [ "$SONNET_PCT" -gt "$HAIKU_PCT" ]; then echo "✅ sonnet > haiku: Yes ($SONNET_PCT% > $HAIKU_PCT%)"; else echo "❌ sonnet > haiku: No ($SONNET_PCT% <= $HAIKU_PCT%)"; fi)
$(if [ "$HAIKU_PCT" -gt "$QWEN_PCT" ] && [ "$HAIKU_PCT" -gt "$DEEPSEEK_PCT" ]; then echo "✅ haiku > local: Yes"; else echo "⚠️ haiku > local: Mixed results"; fi)

---

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*
*Expert Tier - Designed to differentiate advanced reasoning capabilities*
EOF

# Final summary
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           EXPERT TIER RESULTS                                          ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
printf "${CYAN}║  %-25s %5.1f/25 (%3d%%)${NC}\n" "qwen3:1.7b (Local):" "$QWEN" "$QWEN_PCT"
printf "${CYAN}║  %-25s %5.1f/25 (%3d%%)${NC}\n" "deepseek-r1:1.5b (Local):" "$DEEPSEEK" "$DEEPSEEK_PCT"
printf "${CYAN}║  %-25s %5.1f/25 (%3d%%)${NC}\n" "claude-opus:" "$OPUS" "$OPUS_PCT"
printf "${CYAN}║  %-25s %5.1f/25 (%3d%%)${NC}\n" "claude-sonnet:" "$SONNET" "$SONNET_PCT"
printf "${CYAN}║  %-25s %5.1f/25 (%3d%%)${NC}\n" "claude-haiku:" "$HAIKU" "$HAIKU_PCT"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Hierarchy Check: opus > sonnet > haiku > local${NC}"
if [ "$OPUS_PCT" -gt "$SONNET_PCT" ] && [ "$SONNET_PCT" -gt "$HAIKU_PCT" ]; then
    echo -e "${GREEN}║  ✅ Cloud model hierarchy is correct!${NC}"
else
    echo -e "${RED}║  ⚠️ Cloud model hierarchy needs review${NC}"
fi
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Report: ${GREEN}$REPORT_FILE${NC}"
