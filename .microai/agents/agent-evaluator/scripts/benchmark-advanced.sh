#!/usr/bin/env bash
# Requires bash 4+ for associative arrays
# On macOS: brew install bash && use /opt/homebrew/bin/bash
#
# benchmark-advanced.sh - Advanced Multi-Tier Benchmark v2.0
# Designed by Deep Thinking Team (Dijkstra, Linus, Polya, Munger)
#
# Features:
# - 4 difficulty tiers (Easy/Medium/Hard/Expert)
# - 20 test cases with 100 max points
# - Differentiation targets: opus > sonnet > haiku
#
# Usage:
#   benchmark-advanced.sh --agent AGENT_ID [--tier all|easy|medium|hard|expert]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

# Defaults
AGENT_ID=""
TIMEOUT=90
TIER_FILTER="all"

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
        --agent) AGENT_ID="$2"; shift 2 ;;
        --tier) TIER_FILTER="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [[ -z "$AGENT_ID" ]]; then
    echo -e "${RED}Error: --agent is required${NC}"
    echo "Usage: benchmark-advanced.sh --agent AGENT_ID [--tier all|easy|medium|hard|expert]"
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
echo -e "${CYAN}║        ADVANCED MULTI-TIER BENCHMARK v2.0                              ║${NC}"
echo -e "${CYAN}║        Designed by Deep Thinking Team                                  ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Tier: ${TIER_FILTER}${NC}"
echo -e "${CYAN}║  Models: qwen3:1.7b, deepseek-r1:1.5b, claude (opus/sonnet/haiku)     ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# TEST DEFINITIONS - v2.0 Advanced Test Suite
# =============================================================================

# Easy Tier (15 points) - All models should score 70%+
declare -a EASY_IDS=("E-1" "E-2" "E-3" "E-4" "E-5")
declare -a EASY_NAMES=("Basic Error Handling" "Simple Dependency" "Interface Implicit" "Map Concurrency" "Nil vs Empty Slice")
declare -a EASY_PROMPTS=(
    "All Go functions that return errors should be checked. The function ReadFile returns an error. What should the caller do?"
    "Package A imports B. Package B has no imports. What initializes first?"
    "In Go, does a struct need to explicitly declare that it implements an interface?"
    "Two goroutines write to the same map without synchronization. What happens?"
    "What is the difference between 'var s []int' and 's := []int{}'?"
)
declare -a EASY_KEYWORDS=(
    "check,handle,error,err,nil"
    "B,first,before,dependency"
    "no,implicit,duck,automatically"
    "race,crash,fatal,unsafe,undefined"
    "nil,empty,allocated,memory"
)
declare -a EASY_POINTS=(3 3 3 3 3)

# Medium Tier (25 points) - Local 40-60%, Cloud 70%+
declare -a MEDIUM_IDS=("M-1" "M-2" "M-3" "M-4" "M-5")
declare -a MEDIUM_NAMES=("Complex Dependency Chain" "Context Cancellation" "Error Wrapping" "Interface Segregation" "Race in Counter")
declare -a MEDIUM_PROMPTS=(
    "Service deps: API Gateway → Auth → User DB; API Gateway → Product → Product DB; Product → Cache; Auth → Cache. What order should services start?"
    "func process(ctx context.Context) error { for i := 0; i < 1000; i++ { time.Sleep(10 * time.Millisecond) } return nil } What's wrong with context handling?"
    "Handler → Service → Repository. Repository returns errors.New(\"connection refused\"). How should errors be wrapped for debugging?"
    "type DataStore interface { Create, Read, Update, Delete, List, Search, Backup, Restore }. A component only needs Read. Design problem?"
    "type Counter struct { count int }; Increment() { c.count++ }; Get() { return c.count }. Multiple goroutines call these. Safe?"
)
declare -a MEDIUM_KEYWORDS=(
    "DB,Cache,Auth,Product,Gateway"
    "ctx.Done,select,cancellation,check,ignore"
    "%w,fmt.Errorf,Wrap,chain,context"
    "interface segregation,too large,Reader,smaller,ISP"
    "not safe,mutex,atomic,sync,race"
)
declare -a MEDIUM_POINTS=(5 5 5 5 5)

# Hard Tier (35 points) - Local 15-40%, Cloud 50-70%
declare -a HARD_IDS=("H-1" "H-2" "H-3" "H-4" "H-5")
declare -a HARD_NAMES=("Deadlock Analysis" "Multiple Code Bugs" "REST API Review" "Fan-In Pattern" "SQL Injection")
declare -a HARD_PROMPTS=(
    "func transfer(from, to *Account, amount int) { from.mu.Lock(); defer from.mu.Unlock(); to.mu.Lock(); defer to.mu.Unlock(); from.balance -= amount; to.balance += amount }. Two goroutines: transfer(A,B,100) and transfer(B,A,50). Problem and solution?"
    "func processRequests(requests <-chan Request) { for req := range requests { go func() { result := process(req); _ = result }() } }. What are ALL problems?"
    "Review: POST /users/create, GET /users/getUser?id=123, PUT /users/updateUser, DELETE /users/deleteUser?id=123, GET /users/getAllUsers. Problems?"
    "Implement fan-in: merge multiple input channels into one output, handle closure, stop on ctx cancel, no goroutine leaks. Sketch implementation."
    "func getUserData(w, r) { userID := r.URL.Query().Get(\"id\"); query := fmt.Sprintf(\"SELECT * FROM users WHERE id = '%s'\", userID); rows, _ := db.Query(query) }. ALL security issues and fixes?"
)
declare -a HARD_KEYWORDS=(
    "deadlock,lock order,consistent,circular,waiting"
    "loop variable,closure,capture,unbounded,goroutine"
    "redundant,verb,RESTful,resource,inconsistent"
    "select,WaitGroup,ctx.Done,close,range"
    "SQL injection,parameterized,prepared,error,sanitize"
)
declare -a HARD_POINTS=(7 7 7 7 7)

# Expert Tier (25 points) - Differentiates opus > sonnet > haiku
declare -a EXPERT_IDS=("X-1" "X-2" "X-3")
declare -a EXPERT_NAMES=("Distributed Rate Limiter" "Complex Refactoring" "Advanced Cache Design")
declare -a EXPERT_PROMPTS=(
    "Design distributed rate limiter: works across API gateway instances, per-user and global limits, handles network partitions, sub-ms latency. Architecture and trade-offs?"
    "200-line function with nested if-else for order types (express/standard), user types (premium/regular), service calls (inventory/payment/shipping). Refactoring strategy using SOLID?"
    "Design cache: concurrent reads + exclusive writes, prevents thundering herd, bounded memory with LRU, TTL expiration. Synchronization strategy and pitfalls?"
)
declare -a EXPERT_KEYWORDS=(
    "Redis,sliding window,token bucket,local cache,consistency,CAP"
    "strategy,interface,dependency injection,single responsibility,separate"
    "RWMutex,singleflight,LRU,TTL,thundering herd"
)
declare -a EXPERT_POINTS=(10 8 7)

# Ambiguity Tier (10 points) - Tests clarification ability
declare -a AMBIG_IDS=("A-1" "A-2" "A-3")
declare -a AMBIG_NAMES=("Vague Bug Report" "Underspecified Feature" "Contradictory Requirements")
declare -a AMBIG_PROMPTS=(
    "The API is slow. Fix it."
    "Add authentication to the API."
    "Requirements: 1) API responds in <10ms, 2) All data fetched fresh from DB (no cache), 3) DB is in another region with 50ms latency. Implement."
)
declare -a AMBIG_KEYWORDS=(
    "which,how slow,metrics,clarify,endpoint,what"
    "what type,JWT,OAuth,requirements,existing"
    "impossible,contradiction,cannot,conflict,trade-off"
)
declare -a AMBIG_POINTS=(3 3 4)

# Results storage
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$OUTPUT_DIR/advanced-benchmark-${AGENT_ID}-${TIMESTAMP}.md"

# Initialize totals (bash 3 compatible - no associative arrays)
QWEN_TOTAL=0; DEEPSEEK_TOTAL=0; OPUS_TOTAL=0; SONNET_TOTAL=0; HAIKU_TOTAL=0
QWEN_EASY=0; QWEN_MEDIUM=0; QWEN_HARD=0; QWEN_EXPERT=0; QWEN_AMBIG=0
DEEPSEEK_EASY=0; DEEPSEEK_MEDIUM=0; DEEPSEEK_HARD=0; DEEPSEEK_EXPERT=0; DEEPSEEK_AMBIG=0
OPUS_EASY=0; OPUS_MEDIUM=0; OPUS_HARD=0; OPUS_EXPERT=0; OPUS_AMBIG=0
SONNET_EASY=0; SONNET_MEDIUM=0; SONNET_HARD=0; SONNET_EXPERT=0; SONNET_AMBIG=0
HAIKU_EASY=0; HAIKU_MEDIUM=0; HAIKU_HARD=0; HAIKU_EXPERT=0; HAIKU_AMBIG=0
EASY_MAX=15; MEDIUM_MAX=25; HARD_MAX=35; EXPERT_MAX=25; AMBIG_MAX=10

# Function to clean ANSI codes
clean_ansi() {
    echo "$1" | \
        sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g' | \
        sed 's/\[?[0-9]*[lh]//g' | \
        tr -d '⠙⠹⠸⠼⠴⠦⠧⠇⠏⠋⠛⠿'
}

# Function to run test with Ollama
run_ollama_test() {
    local model="$1"
    local prompt="$2"
    local keywords="$3"
    local points="$4"

    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Be concise but complete. /no_think"

    local response=""
    response=$("$OLLAMA_SCRIPT" --model "$model" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || {
        echo "0|error|[No response]|"
        return
    }

    local clean_response=$(clean_ansi "$response")
    local grade=$("$GRADE_SCRIPT" --response "$clean_response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || {
        echo "0|error|$response|"
        return
    }

    local score=$(echo "$grade" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local status=$(echo "$grade" | grep -o '"status": "[^"]*"' | head -1 | cut -d'"' -f4)
    local matched=$(echo "$grade" | grep -o '"matched": \[[^]]*\]' | head -1 | sed 's/"matched": //' | tr -d '[]"')
    local display=$(echo "$clean_response" | sed 's/<think>.*<\/think>//g' | sed 's/Thinking\.\.\.//g' | tr '\n' ' ' | sed 's/  */ /g' | cut -c1-150)
    echo "${score:-0}|${status:-fail}|${display}|${matched}"
}

# Function to run test with Claude
run_claude_test() {
    local model="$1"
    local prompt="$2"
    local keywords="$3"
    local points="$4"

    local full_prompt="$AGENT_SYSTEM

User: $prompt

Think step by step. Be concise but complete."

    local response=""
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
    local display=$(echo "$response" | tr '\n' ' ' | cut -c1-150)
    echo "${score:-0}|${status:-fail}|${display}|${matched}"
}

# Function to run a tier of tests
run_tier() {
    local tier_name="$1"
    local tier_upper="${tier_name^^}"
    local -n ids="${tier_upper}_IDS"
    local -n names="${tier_upper}_NAMES"
    local -n prompts="${tier_upper}_PROMPTS"
    local -n keywords="${tier_upper}_KEYWORDS"
    local -n points="${tier_upper}_POINTS"

    echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}   TIER: ${tier_upper} (${#ids[@]} tests)${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════════${NC}\n"

    local tier_results=""

    for i in "${!ids[@]}"; do
        local test_id="${ids[$i]}"
        local test_name="${names[$i]}"
        local prompt="${prompts[$i]}"
        local kw="${keywords[$i]}"
        local pts="${points[$i]}"

        echo -e "${YELLOW}[$test_id] $test_name (${pts} pts)${NC}"
        echo "  Prompt: ${prompt:0:60}..."

        # Run all models
        for model_info in "qwen3:1.7b:qwen:ollama" "deepseek-r1:1.5b:deepseek:ollama" "opus:opus:claude" "sonnet:sonnet:claude" "haiku:haiku:claude"; do
            IFS=: read model_name model_key model_type <<< "$model_info"
            echo -n "  $model_name... "

            if [[ "$model_type" == "ollama" ]]; then
                result=$(run_ollama_test "$model_name" "$prompt" "$kw" "$pts")
            else
                result=$(run_claude_test "$model_name" "$prompt" "$kw" "$pts")
            fi

            score=$(echo "$result" | cut -d'|' -f1)
            status=$(echo "$result" | cut -d'|' -f2)
            response=$(echo "$result" | cut -d'|' -f3)
            matched=$(echo "$result" | cut -d'|' -f4)

            # Update totals
            case "$model_key" in
                qwen) QWEN_TOTAL=$(echo "$QWEN_TOTAL + ${score:-0}" | bc); TIER_SCORES["qwen_$tier_name"]=$(echo "${TIER_SCORES[qwen_$tier_name]} + ${score:-0}" | bc) ;;
                deepseek) DEEPSEEK_TOTAL=$(echo "$DEEPSEEK_TOTAL + ${score:-0}" | bc); TIER_SCORES["deepseek_$tier_name"]=$(echo "${TIER_SCORES[deepseek_$tier_name]} + ${score:-0}" | bc) ;;
                opus) OPUS_TOTAL=$(echo "$OPUS_TOTAL + ${score:-0}" | bc); TIER_SCORES["opus_$tier_name"]=$(echo "${TIER_SCORES[opus_$tier_name]} + ${score:-0}" | bc) ;;
                sonnet) SONNET_TOTAL=$(echo "$SONNET_TOTAL + ${score:-0}" | bc); TIER_SCORES["sonnet_$tier_name"]=$(echo "${TIER_SCORES[sonnet_$tier_name]} + ${score:-0}" | bc) ;;
                haiku) HAIKU_TOTAL=$(echo "$HAIKU_TOTAL + ${score:-0}" | bc); TIER_SCORES["haiku_$tier_name"]=$(echo "${TIER_SCORES[haiku_$tier_name]} + ${score:-0}" | bc) ;;
            esac

            if [[ "$status" == "pass" ]]; then
                echo -e "${GREEN}${score}/${pts}${NC}"
            else
                echo -e "${RED}${score}/${pts}${NC}"
            fi

            # Store for report
            eval "${model_key}_${test_id//-/_}_score=$score"
            eval "${model_key}_${test_id//-/_}_matched='$matched'"
            eval "${model_key}_${test_id//-/_}_response='${response:0:100}'"
        done
        echo ""
    done
}

# Start report
cat > "$REPORT_FILE" << EOF
# Advanced Multi-Tier Benchmark Report v2.0

> Designed by Deep Thinking Team (Dijkstra, Linus, Polya, Munger)
> Philosophy: "Quality of reasoning > Presence of keywords"

---

## Benchmark Info

| Property | Value |
|----------|-------|
| **Agent** | $AGENT_ID |
| **Time** | $(date '+%Y-%m-%d %H:%M:%S') |
| **Models** | qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku |
| **Total Tests** | 18 |
| **Max Score** | 110 |
| **Tier Filter** | $TIER_FILTER |

---

## Expected Performance by Model Tier

| Tier | Local (qwen/deepseek) | Haiku | Sonnet | Opus |
|------|----------------------|-------|--------|------|
| Easy (15 pts) | 70%+ | 85%+ | 90%+ | 95%+ |
| Medium (25 pts) | 40-60% | 60%+ | 75%+ | 85%+ |
| Hard (35 pts) | 15-40% | 30%+ | 50%+ | 70%+ |
| Expert (25 pts) | 5-15% | 10%+ | 30%+ | 50%+ |
| Ambiguity (10 pts) | 30-50% | 50%+ | 70%+ | 80%+ |

---

EOF

# Run tiers based on filter
[[ "$TIER_FILTER" == "all" || "$TIER_FILTER" == "easy" ]] && run_tier "easy"
[[ "$TIER_FILTER" == "all" || "$TIER_FILTER" == "medium" ]] && run_tier "medium"
[[ "$TIER_FILTER" == "all" || "$TIER_FILTER" == "hard" ]] && run_tier "hard"
[[ "$TIER_FILTER" == "all" || "$TIER_FILTER" == "expert" ]] && run_tier "expert"
[[ "$TIER_FILTER" == "all" || "$TIER_FILTER" == "ambig" ]] && run_tier "ambig"

# Calculate totals
if [[ "$TIER_FILTER" == "all" ]]; then
    MAX_TOTAL=$((EASY_MAX + MEDIUM_MAX + HARD_MAX + EXPERT_MAX + AMBIG_MAX))
else
    MAX_TOTAL=0
    [[ "$TIER_FILTER" == "easy" ]] && MAX_TOTAL=$EASY_MAX
    [[ "$TIER_FILTER" == "medium" ]] && MAX_TOTAL=$MEDIUM_MAX
    [[ "$TIER_FILTER" == "hard" ]] && MAX_TOTAL=$HARD_MAX
    [[ "$TIER_FILTER" == "expert" ]] && MAX_TOTAL=$EXPERT_MAX
    [[ "$TIER_FILTER" == "ambig" ]] && MAX_TOTAL=$AMBIG_MAX
fi

# Calculate percentages
calc_pct() {
    local score=$1
    local max=$2
    if [[ "$max" -gt 0 ]]; then
        echo "scale=0; $score * 100 / $max" | bc
    else
        echo 0
    fi
}

QWEN_PCT=$(calc_pct "$QWEN_TOTAL" "$MAX_TOTAL")
DEEPSEEK_PCT=$(calc_pct "$DEEPSEEK_TOTAL" "$MAX_TOTAL")
OPUS_PCT=$(calc_pct "$OPUS_TOTAL" "$MAX_TOTAL")
SONNET_PCT=$(calc_pct "$SONNET_TOTAL" "$MAX_TOTAL")
HAIKU_PCT=$(calc_pct "$HAIKU_TOTAL" "$MAX_TOTAL")

# Write tier breakdown to report
cat >> "$REPORT_FILE" << EOF

## Score Summary

| Model | Total | % | Easy | Medium | Hard | Expert | Ambig |
|-------|-------|---|------|--------|------|--------|-------|
| qwen3:1.7b | ${QWEN_TOTAL}/${MAX_TOTAL} | ${QWEN_PCT}% | ${TIER_SCORES[qwen_easy]:-0}/${EASY_MAX} | ${TIER_SCORES[qwen_medium]:-0}/${MEDIUM_MAX} | ${TIER_SCORES[qwen_hard]:-0}/${HARD_MAX} | ${TIER_SCORES[qwen_expert]:-0}/${EXPERT_MAX} | ${TIER_SCORES[qwen_ambig]:-0}/${AMBIG_MAX} |
| deepseek-r1:1.5b | ${DEEPSEEK_TOTAL}/${MAX_TOTAL} | ${DEEPSEEK_PCT}% | ${TIER_SCORES[deepseek_easy]:-0}/${EASY_MAX} | ${TIER_SCORES[deepseek_medium]:-0}/${MEDIUM_MAX} | ${TIER_SCORES[deepseek_hard]:-0}/${HARD_MAX} | ${TIER_SCORES[deepseek_expert]:-0}/${EXPERT_MAX} | ${TIER_SCORES[deepseek_ambig]:-0}/${AMBIG_MAX} |
| claude-opus | ${OPUS_TOTAL}/${MAX_TOTAL} | ${OPUS_PCT}% | ${TIER_SCORES[opus_easy]:-0}/${EASY_MAX} | ${TIER_SCORES[opus_medium]:-0}/${MEDIUM_MAX} | ${TIER_SCORES[opus_hard]:-0}/${HARD_MAX} | ${TIER_SCORES[opus_expert]:-0}/${EXPERT_MAX} | ${TIER_SCORES[opus_ambig]:-0}/${AMBIG_MAX} |
| claude-sonnet | ${SONNET_TOTAL}/${MAX_TOTAL} | ${SONNET_PCT}% | ${TIER_SCORES[sonnet_easy]:-0}/${EASY_MAX} | ${TIER_SCORES[sonnet_medium]:-0}/${MEDIUM_MAX} | ${TIER_SCORES[sonnet_hard]:-0}/${HARD_MAX} | ${TIER_SCORES[sonnet_expert]:-0}/${EXPERT_MAX} | ${TIER_SCORES[sonnet_ambig]:-0}/${AMBIG_MAX} |
| claude-haiku | ${HAIKU_TOTAL}/${MAX_TOTAL} | ${HAIKU_PCT}% | ${TIER_SCORES[haiku_easy]:-0}/${EASY_MAX} | ${TIER_SCORES[haiku_medium]:-0}/${MEDIUM_MAX} | ${TIER_SCORES[haiku_hard]:-0}/${HARD_MAX} | ${TIER_SCORES[haiku_expert]:-0}/${EXPERT_MAX} | ${TIER_SCORES[haiku_ambig]:-0}/${AMBIG_MAX} |

---

## Ranking

| Rank | Model | Score | % | Grade |
|------|-------|-------|---|-------|
EOF

# Sort and rank
declare -a scores=("$QWEN_TOTAL:qwen3:1.7b:Local" "$DEEPSEEK_TOTAL:deepseek-r1:1.5b:Local" "$OPUS_TOTAL:claude-opus:Cloud" "$SONNET_TOTAL:claude-sonnet:Cloud" "$HAIKU_TOTAL:claude-haiku:Cloud")
IFS=$'\n' sorted=($(sort -t: -k1 -nr <<<"${scores[*]}")); unset IFS

rank=1
for item in "${sorted[@]}"; do
    score=$(echo "$item" | cut -d: -f1)
    model=$(echo "$item" | cut -d: -f2)
    type=$(echo "$item" | cut -d: -f3)
    pct=$(calc_pct "$score" "$MAX_TOTAL")
    if [[ "$pct" -ge 80 ]]; then grade="A"; elif [[ "$pct" -ge 70 ]]; then grade="B"; elif [[ "$pct" -ge 60 ]]; then grade="C"; elif [[ "$pct" -ge 50 ]]; then grade="D"; else grade="F"; fi
    echo "| #$rank | $model | $score/$MAX_TOTAL | $pct% | $grade |" >> "$REPORT_FILE"
    rank=$((rank + 1))
done

cat >> "$REPORT_FILE" << EOF

---

## Analysis

### Differentiation Check

Expected gaps:
- opus vs sonnet: 15-20% gap in hard/expert tiers
- sonnet vs haiku: 20-25% gap in medium/hard tiers
- cloud vs local: 30-40% overall gap

Actual gaps:
- opus vs sonnet: $((OPUS_PCT - SONNET_PCT))%
- sonnet vs haiku: $((SONNET_PCT - HAIKU_PCT))%
- cloud avg vs local avg: $(((OPUS_PCT + SONNET_PCT + HAIKU_PCT) / 3 - (QWEN_PCT + DEEPSEEK_PCT) / 2))%

### Key Observations

$(if [[ "$OPUS_PCT" -gt "$SONNET_PCT" && "$SONNET_PCT" -gt "$HAIKU_PCT" ]]; then
    echo "✅ Cloud models correctly ranked: opus > sonnet > haiku"
else
    echo "⚠️ Unexpected ranking among Claude models"
fi)

$(if [[ "$((OPUS_PCT - HAIKU_PCT))" -ge 20 ]]; then
    echo "✅ Good differentiation between opus and haiku ($((OPUS_PCT - HAIKU_PCT))% gap)"
else
    echo "⚠️ Insufficient differentiation between opus and haiku ($((OPUS_PCT - HAIKU_PCT))% gap)"
fi)

$(if [[ "$OPUS_PCT" -gt "$QWEN_PCT" && "$OPUS_PCT" -gt "$DEEPSEEK_PCT" ]]; then
    echo "✅ Cloud models outperform local models as expected"
else
    echo "⚠️ Unexpected: local models competing with cloud models"
fi)

---

*Generated: $(date '+%Y-%m-%d %H:%M:%S')*
*Agent Evaluator v2.0 - Advanced Benchmark*
EOF

# Final summary
echo -e "\n${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           ADVANCED BENCHMARK RESULTS                                   ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "qwen3:1.7b (Local):" "$QWEN_TOTAL" "$MAX_TOTAL" "$QWEN_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "deepseek-r1:1.5b (Local):" "$DEEPSEEK_TOTAL" "$MAX_TOTAL" "$DEEPSEEK_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-opus (Cloud):" "$OPUS_TOTAL" "$MAX_TOTAL" "$OPUS_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-sonnet (Cloud):" "$SONNET_TOTAL" "$MAX_TOTAL" "$SONNET_PCT"
printf "${CYAN}║  %-25s %6.1f/%-3d (%3d%%)${NC}\n" "claude-haiku (Cloud):" "$HAIKU_TOTAL" "$MAX_TOTAL" "$HAIKU_PCT"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Report saved to: ${GREEN}$REPORT_FILE${NC}"
