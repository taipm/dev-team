#!/usr/bin/env bash
#
# evaluate-agent-dynamic.sh - Complete dynamic evaluation of an agent
#
# Usage:
#   evaluate-agent-dynamic.sh --agent AGENT_ID [OPTIONS]
#
# Options:
#   --agent AGENT_ID      Agent to evaluate (required)
#   --categories CATS     Comma-separated categories (default: all)
#   --model MODEL         LLM model (default: qwen3:1.7b)
#   --output-dir DIR      Output directory
#   --verbose             Show detailed output
#   --summary-only        Only show summary, skip individual tests
#
# Categories:
#   reasoning, adaptability, output, creativity, domain

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_EVALUATOR_DIR="$(dirname "$SCRIPT_DIR")"
MICROAI_DIR="$(dirname "$(dirname "$AGENT_EVALUATOR_DIR")")"
OLLAMA_SCRIPT="$MICROAI_DIR/skills/development-skills/ollama/scripts/ollama-run.sh"
GRADE_SCRIPT="$SCRIPT_DIR/grade-response.sh"

# Defaults
AGENT_ID=""
CATEGORIES="reasoning,adaptability,output,creativity"
MODEL="qwen3:1.7b"
OUTPUT_DIR="$AGENT_EVALUATOR_DIR/test-results"
VERBOSE=false
SUMMARY_ONLY=false
TIMEOUT=30

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --agent)
            AGENT_ID="$2"
            shift 2
            ;;
        --categories)
            CATEGORIES="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --summary-only)
            SUMMARY_ONLY=true
            shift
            ;;
        --help)
            head -20 "$0" | grep -E "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Validate
if [[ -z "$AGENT_ID" ]]; then
    echo -e "${RED}Error: --agent is required${NC}" >&2
    exit 1
fi

AGENT_DIR="$MICROAI_DIR/agents/$AGENT_ID"
AGENT_FILE="$AGENT_DIR/agent.md"

if [[ ! -f "$AGENT_FILE" ]]; then
    echo -e "${RED}Error: Agent not found: $AGENT_ID${NC}" >&2
    echo "Looking for: $AGENT_FILE" >&2
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RESULT_FILE="$OUTPUT_DIR/${AGENT_ID}-dynamic-${TIMESTAMP}.json"

# Extract agent system prompt
extract_agent_info() {
    local agent_file="$1"
    sed -n '/system: |/,/must:/p' "$agent_file" 2>/dev/null | head -20 | tail -n +2 | sed 's/^      //' || echo "You are an AI assistant."
}

AGENT_SYSTEM=$(extract_agent_info "$AGENT_FILE")

# Detect domain from agent tags
detect_domain() {
    local agent_file="$1"
    if grep -q "golang\|go-dev" "$agent_file" 2>/dev/null; then
        echo "go_dev"
    elif grep -q "python" "$agent_file" 2>/dev/null; then
        echo "python_dev"
    elif grep -q "qa\|test" "$agent_file" 2>/dev/null; then
        echo "qa"
    else
        echo "general"
    fi
}

AGENT_DOMAIN=$(detect_domain "$AGENT_FILE")

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           DYNAMIC AGENT EVALUATION v2.0                        ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Domain: ${AGENT_DOMAIN}${NC}"
echo -e "${CYAN}║  Model: ${MODEL}${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Initialize scores (using simple variables instead of associative arrays for bash 3 compat)
REASONING_SCORE=0
REASONING_MAX=20
ADAPT_SCORE=0
ADAPT_MAX=15
OUTPUT_SCORE=0
OUTPUT_MAX=10
CREATIVITY_SCORE=0
CREATIVITY_MAX=10
DOMAIN_SCORE=0
DOMAIN_MAX=15

TOTAL_TESTS=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a single test
run_single_test() {
    local test_id="$1"
    local prompt="$2"
    local keywords="$3"
    local points="$4"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    if $VERBOSE; then
        echo -e "${BLUE}Test: $test_id${NC}"
        echo "  Prompt: ${prompt:0:50}..."
    fi

    # Build full prompt
    local full_prompt="$AGENT_SYSTEM

User: $prompt

Respond concisely and directly. /no_think"

    # Execute with Ollama
    local response=""
    response=$("$OLLAMA_SCRIPT" --model "$MODEL" --timeout "$TIMEOUT" --prompt "$full_prompt" 2>&1) || {
        echo -e "${RED}  FAILED: Execution error${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "0"
        return
    }

    # Grade response
    local grade_result=$("$GRADE_SCRIPT" --response "$response" --keywords "$keywords" --points "$points" --json 2>/dev/null) || {
        echo "0"
        return
    }

    local score=$(echo "$grade_result" | grep -o '"score": [0-9.]*' | head -1 | cut -d' ' -f2)
    local status=$(echo "$grade_result" | grep -o '"status": "[^"]*"' | head -1 | cut -d'"' -f4)

    # Default to 0 if empty
    score=${score:-0}

    if [[ "$status" == "pass" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        if $VERBOSE; then
            echo -e "${GREEN}  PASSED: $score/$points${NC}"
        fi
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        if $VERBOSE; then
            echo -e "${RED}  FAILED: $score/$points${NC}"
        fi
    fi

    echo "$score"
}

# ═══════════════════════════════════════════════════════════════════
# REASONING TESTS (20 pts)
# ═══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}=== REASONING TESTS (20 pts) ===${NC}"

score=$(run_single_test "R-L1" "All programmers use computers. John is a programmer. Does John use a computer?" "yes,correct,true,does,uses" "2")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-L2" "If it rains, the ground gets wet. The ground is wet. Did it rain?" "not necessarily,cannot conclude,might,other,fallacy" "3")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-M1" "Module A imports B. B imports C. C imports D. What is the correct initialization order?" "D,C,B,A" "3")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-M2" "Web server depends on API. API depends on Database. If Database fails, which services are affected?" "API,Web,both,all,cascade" "3")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-E1" "Service A calls B. B calls A. What problem does this create?" "circular,cycle,infinite,loop,deadlock" "3")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-E2" "What happens when you divide by zero in programming?" "error,exception,undefined,crash,infinity" "2")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-M3" "Task X takes 2 hours. Task Y depends on X and takes 3 hours. Task Z depends on Y and takes 1 hour. Total sequential time?" "6,six,hours" "2")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

score=$(run_single_test "R-L3" "No fish can fly. Some pets are fish. Can all pets fly?" "no,not all,some cannot" "2")
REASONING_SCORE=$(echo "$REASONING_SCORE + ${score:-0}" | bc)

echo -e "Reasoning Score: ${REASONING_SCORE}/${REASONING_MAX}"
echo ""

# ═══════════════════════════════════════════════════════════════════
# ADAPTABILITY TESTS (15 pts)
# ═══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}=== ADAPTABILITY TESTS (15 pts) ===${NC}"

score=$(run_single_test "A-A1" "Fix the bug" "which,what,where,information,clarify,specify" "3")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "A-A2" "Make it faster" "what,which,component,specific,measure,current" "3")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "A-A3" "Review the code" "which,file,what,focus,specific" "2")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "A-R1" "Run command: xyz_nonexistent_command_12345" "not found,error,invalid,unknown,try" "3")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "A-R2" "Read file: /this/path/does/not/exist/anywhere.txt" "not found,cannot,check,verify,exist" "2")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "A-R3" "Deploy to environment: undefined_env_xyz" "not found,unknown,check,verify,configure" "2")
ADAPT_SCORE=$(echo "$ADAPT_SCORE + ${score:-0}" | bc)

echo -e "Adaptability Score: ${ADAPT_SCORE}/${ADAPT_MAX}"
echo ""

# ═══════════════════════════════════════════════════════════════════
# OUTPUT QUALITY TESTS (10 pts)
# ═══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}=== OUTPUT QUALITY TESTS (10 pts) ===${NC}"

score=$(run_single_test "O-F1" "List exactly 3 benefits of code review" "1,2,3,quality,bug,knowledge" "3")
OUTPUT_SCORE=$(echo "$OUTPUT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "O-F2" "Explain recursion in exactly 2 sentences" "function,calls,base,recursive" "3")
OUTPUT_SCORE=$(echo "$OUTPUT_SCORE + ${score:-0}" | bc)

score=$(run_single_test "O-C1" "What are the 4 pillars of OOP?" "encapsulation,inheritance,polymorphism,abstraction" "4")
OUTPUT_SCORE=$(echo "$OUTPUT_SCORE + ${score:-0}" | bc)

echo -e "Output Quality Score: ${OUTPUT_SCORE}/${OUTPUT_MAX}"
echo ""

# ═══════════════════════════════════════════════════════════════════
# CREATIVITY TESTS (10 pts)
# ═══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}=== CREATIVITY TESTS (10 pts) ===${NC}"

score=$(run_single_test "C-N1" "Propose 2 unconventional ways to reduce API latency besides caching" "precompute,edge,compression,batch,predict,async,parallel" "4")
CREATIVITY_SCORE=$(echo "$CREATIVITY_SCORE + ${score:-0}" | bc)

score=$(run_single_test "C-N2" "How would you debug a problem that only happens in production, not locally?" "logs,monitoring,reproduce,environment,data,traffic" "3")
CREATIVITY_SCORE=$(echo "$CREATIVITY_SCORE + ${score:-0}" | bc)

score=$(run_single_test "C-P1" "Users complain app is slow but metrics show 50ms response. What else could cause perceived slowness?" "perceived,UX,loading,animation,feedback,network,client,render" "3")
CREATIVITY_SCORE=$(echo "$CREATIVITY_SCORE + ${score:-0}" | bc)

echo -e "Creativity Score: ${CREATIVITY_SCORE}/${CREATIVITY_MAX}"
echo ""

# ═══════════════════════════════════════════════════════════════════
# DOMAIN TESTS (15 pts) - Go specific
# ═══════════════════════════════════════════════════════════════════
if [[ "$AGENT_DOMAIN" == "go_dev" ]]; then
    echo -e "${YELLOW}=== GO DOMAIN TESTS (15 pts) ===${NC}"

    score=$(run_single_test "D-GO1" "What is the zero value of a slice in Go?" "nil,null,empty" "3")
    DOMAIN_SCORE=$(echo "$DOMAIN_SCORE + ${score:-0}" | bc)

    score=$(run_single_test "D-GO2" "When should you use pointer receiver vs value receiver in Go?" "modify,large,struct,nil,copy" "4")
    DOMAIN_SCORE=$(echo "$DOMAIN_SCORE + ${score:-0}" | bc)

    score=$(run_single_test "D-GO3" "How do you prevent race conditions on map access in Go?" "mutex,sync,channel,lock,RWMutex" "4")
    DOMAIN_SCORE=$(echo "$DOMAIN_SCORE + ${score:-0}" | bc)

    score=$(run_single_test "D-GO4" "What is the difference between make and new in Go?" "make,slice,map,channel,new,pointer,zero" "4")
    DOMAIN_SCORE=$(echo "$DOMAIN_SCORE + ${score:-0}" | bc)

    echo -e "Domain Score: ${DOMAIN_SCORE}/${DOMAIN_MAX}"
    echo ""
fi

# ═══════════════════════════════════════════════════════════════════
# CALCULATE TOTALS
# ═══════════════════════════════════════════════════════════════════
TOTAL_SCORE=$(echo "$REASONING_SCORE + $ADAPT_SCORE + $OUTPUT_SCORE + $CREATIVITY_SCORE" | bc)
TOTAL_MAX=$(echo "$REASONING_MAX + $ADAPT_MAX + $OUTPUT_MAX + $CREATIVITY_MAX" | bc)

# Add domain if applicable
if [[ "$AGENT_DOMAIN" == "go_dev" ]]; then
    TOTAL_SCORE=$(echo "$TOTAL_SCORE + $DOMAIN_SCORE" | bc)
    TOTAL_MAX=$(echo "$TOTAL_MAX + $DOMAIN_MAX" | bc)
fi

# Calculate percentage
if [[ $TOTAL_MAX -gt 0 ]]; then
    PERCENTAGE=$(echo "scale=0; $TOTAL_SCORE * 100 / $TOTAL_MAX" | bc)
else
    PERCENTAGE=0
fi

# Assign grade
if [[ $PERCENTAGE -ge 90 ]]; then
    GRADE="A+"
    LEVEL="Exceptional"
elif [[ $PERCENTAGE -ge 80 ]]; then
    GRADE="A"
    LEVEL="Advanced"
elif [[ $PERCENTAGE -ge 70 ]]; then
    GRADE="B"
    LEVEL="Competent"
elif [[ $PERCENTAGE -ge 60 ]]; then
    GRADE="C"
    LEVEL="Basic"
elif [[ $PERCENTAGE -ge 50 ]]; then
    GRADE="D"
    LEVEL="Limited"
else
    GRADE="F"
    LEVEL="Failing"
fi

# ═══════════════════════════════════════════════════════════════════
# FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════════
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           DYNAMIC EVALUATION RESULTS                           ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Agent: ${AGENT_ID}${NC}"
echo -e "${CYAN}║  Total Score: ${TOTAL_SCORE}/${TOTAL_MAX} (${PERCENTAGE}%)${NC}"
echo -e "${CYAN}║  Grade: ${GRADE} - ${LEVEL}${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  BREAKDOWN:${NC}"
printf "${CYAN}║  %-15s %5.1f/%-5d${NC}\n" "Reasoning:" "$REASONING_SCORE" "$REASONING_MAX"
printf "${CYAN}║  %-15s %5.1f/%-5d${NC}\n" "Adaptability:" "$ADAPT_SCORE" "$ADAPT_MAX"
printf "${CYAN}║  %-15s %5.1f/%-5d${NC}\n" "Output:" "$OUTPUT_SCORE" "$OUTPUT_MAX"
printf "${CYAN}║  %-15s %5.1f/%-5d${NC}\n" "Creativity:" "$CREATIVITY_SCORE" "$CREATIVITY_MAX"
if [[ "$AGENT_DOMAIN" == "go_dev" ]]; then
    printf "${CYAN}║  %-15s %5.1f/%-5d${NC}\n" "Go Domain:" "$DOMAIN_SCORE" "$DOMAIN_MAX"
fi
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  Tests: ${TESTS_PASSED} passed, ${TESTS_FAILED} failed (${TOTAL_TESTS} total)${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"

# Save results
cat > "$RESULT_FILE" << EOF
{
  "agent": "$AGENT_ID",
  "domain": "$AGENT_DOMAIN",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "model": "$MODEL",
  "scores": {
    "reasoning": {"score": $REASONING_SCORE, "max": $REASONING_MAX},
    "adaptability": {"score": $ADAPT_SCORE, "max": $ADAPT_MAX},
    "output": {"score": $OUTPUT_SCORE, "max": $OUTPUT_MAX},
    "creativity": {"score": $CREATIVITY_SCORE, "max": $CREATIVITY_MAX},
    "domain": {"score": $DOMAIN_SCORE, "max": $DOMAIN_MAX}
  },
  "total": {
    "score": $TOTAL_SCORE,
    "max": $TOTAL_MAX,
    "percentage": $PERCENTAGE,
    "grade": "$GRADE",
    "level": "$LEVEL"
  },
  "tests": {
    "total": $TOTAL_TESTS,
    "passed": $TESTS_PASSED,
    "failed": $TESTS_FAILED
  }
}
EOF

echo ""
echo -e "Results saved to: $RESULT_FILE"
