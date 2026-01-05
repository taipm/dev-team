#!/usr/bin/env bash
#
# benchmark-hard.sh - Run Hard Tier Benchmark
# Bash 3 compatible version
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

AGENT_ID="$1"
TIMEOUT=90

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
echo -e "${CYAN}║        HARD TIER BENCHMARK v2.0                                        ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Tests: 5 | Max Score: 35                                              ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Output
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/hard-benchmark-${AGENT_ID}-${TIMESTAMP}.md"

# Clean ANSI
clean_ansi() {
    echo "$1" | sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g' | sed 's/\[?[0-9]*[lh]//g' | tr -d '⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋⠛⠿'
}

# Run Ollama test
run_ollama() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Be concise. /no_think"

    local response=$("$OLLAMA_SCRIPT" --model "$model" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || echo ""
    local clean=$(clean_ansi "$response")
    local grade=$("$GRADE_SCRIPT" --response "$clean" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$clean" | tr '\n' ' ' | cut -c1-100)"
}

# Run Claude test
run_claude() {
    local model="$1" prompt="$2" keywords="$3" points="$4"
    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Be concise."

    local response=$(echo "$full_prompt" | claude --model "$model" --print 2>&1) || echo ""
    local grade=$("$GRADE_SCRIPT" --response "$response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || echo '{"score":0}'
    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    echo "${score:-0}|${matched:-none}|$(echo "$response" | tr '\n' ' ' | cut -c1-100)"
}

# Initialize totals
QWEN=0; DEEPSEEK=0; OPUS=0; SONNET=0; HAIKU=0

# Start report
cat > "$REPORT_FILE" << 'EOF'
# Hard Tier Benchmark Report

> Tests: 5 | Max Score: 35 points
> Expected: Local 15-40%, Cloud 50-70%

---

## Results

| Test | Points | qwen3 | deepseek | opus | sonnet | haiku |
|------|--------|-------|----------|------|--------|-------|
EOF

echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
echo -e "${MAGENTA}   HARD TIER (5 tests, 35 points)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"

# H-1: Deadlock Analysis
echo -e "\n${YELLOW}[H-1] Deadlock Analysis (7 pts)${NC}"
PROMPT="func transfer(from, to *Account, amount int) { from.mu.Lock(); defer from.mu.Unlock(); to.mu.Lock(); defer to.mu.Unlock(); from.balance -= amount; to.balance += amount }. Two goroutines: transfer(A,B,100) and transfer(B,A,50). Problem and solution?"
KEYWORDS="deadlock,lock order,consistent,circular,waiting"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC}"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC}"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC}"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC}"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC}"
echo "| H-1 Deadlock | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# H-2: Multiple Code Bugs
echo -e "\n${YELLOW}[H-2] Multiple Code Bugs (7 pts)${NC}"
PROMPT="func processRequests(requests <-chan Request) { for req := range requests { go func() { result := process(req); _ = result }() } }. What are ALL problems?"
KEYWORDS="loop variable,closure,capture,unbounded,goroutine"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC}"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC}"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC}"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC}"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC}"
echo "| H-2 Code Bugs | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# H-3: REST API Review
echo -e "\n${YELLOW}[H-3] REST API Review (7 pts)${NC}"
PROMPT="Review: POST /users/create, GET /users/getUser?id=123, PUT /users/updateUser, DELETE /users/deleteUser?id=123. Problems and fixes?"
KEYWORDS="redundant,verb,RESTful,resource,inconsistent"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC}"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC}"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC}"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC}"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC}"
echo "| H-3 API Review | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# H-4: Fan-In Pattern
echo -e "\n${YELLOW}[H-4] Fan-In Pattern (7 pts)${NC}"
PROMPT="Implement fan-in: merge multiple channels into one, handle closure, stop on ctx cancel, no goroutine leaks. Sketch implementation."
KEYWORDS="select,WaitGroup,ctx.Done,close,range"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC}"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC}"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC}"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC}"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC}"
echo "| H-4 Fan-In | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# H-5: SQL Injection
echo -e "\n${YELLOW}[H-5] SQL Injection (7 pts)${NC}"
PROMPT="func getUserData(w, r) { userID := r.URL.Query().Get(\"id\"); query := fmt.Sprintf(\"SELECT * FROM users WHERE id = '%s'\", userID); rows, _ := db.Query(query) }. ALL security issues and fixes?"
KEYWORDS="SQL injection,parameterized,prepared,error,sanitize"

echo -n "  qwen3:1.7b... "; r=$(run_ollama "qwen3:1.7b" "$PROMPT" "$KEYWORDS" 7); s1=$(echo "$r"|cut -d'|' -f1); QWEN=$(echo "$QWEN+$s1"|bc); echo -e "${GREEN}$s1/7${NC}"
echo -n "  deepseek-r1:1.5b... "; r=$(run_ollama "deepseek-r1:1.5b" "$PROMPT" "$KEYWORDS" 7); s2=$(echo "$r"|cut -d'|' -f1); DEEPSEEK=$(echo "$DEEPSEEK+$s2"|bc); echo -e "${GREEN}$s2/7${NC}"
echo -n "  claude-opus... "; r=$(run_claude "opus" "$PROMPT" "$KEYWORDS" 7); s3=$(echo "$r"|cut -d'|' -f1); OPUS=$(echo "$OPUS+$s3"|bc); echo -e "${GREEN}$s3/7${NC}"
echo -n "  claude-sonnet... "; r=$(run_claude "sonnet" "$PROMPT" "$KEYWORDS" 7); s4=$(echo "$r"|cut -d'|' -f1); SONNET=$(echo "$SONNET+$s4"|bc); echo -e "${GREEN}$s4/7${NC}"
echo -n "  claude-haiku... "; r=$(run_claude "haiku" "$PROMPT" "$KEYWORDS" 7); s5=$(echo "$r"|cut -d'|' -f1); HAIKU=$(echo "$HAIKU+$s5"|bc); echo -e "${GREEN}$s5/7${NC}"
echo "| H-5 SQL Injection | 7 | $s1 | $s2 | $s3 | $s4 | $s5 |" >> "$REPORT_FILE"

# Calculate percentages
MAX=35
QWEN_PCT=$(echo "scale=0; $QWEN * 100 / $MAX" | bc)
DEEPSEEK_PCT=$(echo "scale=0; $DEEPSEEK * 100 / $MAX" | bc)
OPUS_PCT=$(echo "scale=0; $OPUS * 100 / $MAX" | bc)
SONNET_PCT=$(echo "scale=0; $SONNET * 100 / $MAX" | bc)
HAIKU_PCT=$(echo "scale=0; $HAIKU * 100 / $MAX" | bc)

# Write totals
cat >> "$REPORT_FILE" << EOF
| **TOTAL** | **35** | **$QWEN ($QWEN_PCT%)** | **$DEEPSEEK ($DEEPSEEK_PCT%)** | **$OPUS ($OPUS_PCT%)** | **$SONNET ($SONNET_PCT%)** | **$HAIKU ($HAIKU_PCT%)** |

---

## Summary

| Rank | Model | Score | % |
|------|-------|-------|---|
EOF

# Sort and rank
echo "$OPUS:opus" "$SONNET:sonnet" "$HAIKU:haiku" "$DEEPSEEK:deepseek" "$QWEN:qwen" | tr ' ' '\n' | sort -t: -k1 -nr | while read item; do
    score=$(echo "$item" | cut -d: -f1)
    model=$(echo "$item" | cut -d: -f2)
    pct=$(echo "scale=0; $score * 100 / $MAX" | bc)
    echo "| $model | $score/35 | $pct% |"
done >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << EOF

---

## Analysis

Expected performance for Hard tier:
- Local models (qwen, deepseek): 15-40%
- Haiku: 30%+
- Sonnet: 50%+
- Opus: 70%+

### Actual Results

| Model | Score | Expected | Status |
|-------|-------|----------|--------|
| qwen3 | $QWEN_PCT% | 15-40% | $(if [ "$QWEN_PCT" -le 40 ]; then echo "✅ As expected"; else echo "⚠️ Higher than expected"; fi) |
| deepseek | $DEEPSEEK_PCT% | 15-40% | $(if [ "$DEEPSEEK_PCT" -le 40 ]; then echo "✅ As expected"; else echo "⚠️ Higher than expected"; fi) |
| haiku | $HAIKU_PCT% | 30%+ | $(if [ "$HAIKU_PCT" -ge 30 ]; then echo "✅ As expected"; else echo "❌ Below expected"; fi) |
| sonnet | $SONNET_PCT% | 50%+ | $(if [ "$SONNET_PCT" -ge 50 ]; then echo "✅ As expected"; else echo "❌ Below expected"; fi) |
| opus | $OPUS_PCT% | 70%+ | $(if [ "$OPUS_PCT" -ge 70 ]; then echo "✅ As expected"; else echo "❌ Below expected"; fi) |

---

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*
EOF

# Final summary
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           HARD TIER RESULTS                                            ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
printf "${CYAN}║  %-25s %5.1f/35 (%3d%%)${NC}\n" "qwen3:1.7b (Local):" "$QWEN" "$QWEN_PCT"
printf "${CYAN}║  %-25s %5.1f/35 (%3d%%)${NC}\n" "deepseek-r1:1.5b (Local):" "$DEEPSEEK" "$DEEPSEEK_PCT"
printf "${CYAN}║  %-25s %5.1f/35 (%3d%%)${NC}\n" "claude-opus:" "$OPUS" "$OPUS_PCT"
printf "${CYAN}║  %-25s %5.1f/35 (%3d%%)${NC}\n" "claude-sonnet:" "$SONNET" "$SONNET_PCT"
printf "${CYAN}║  %-25s %5.1f/35 (%3d%%)${NC}\n" "claude-haiku:" "$HAIKU" "$HAIKU_PCT"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Report: ${GREEN}$REPORT_FILE${NC}"
