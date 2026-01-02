#!/bin/bash
#
# ollama-run.sh - Execute inference with Ollama
#
# Usage:
#   ollama-run.sh [OPTIONS]
#
# Options:
#   --model MODEL     Model to use (default: qwen3:1.7b)
#   --prompt PROMPT   Prompt text (or use stdin)
#   --system SYSTEM   System prompt
#   --timeout SECS    Timeout in seconds (default: 120)
#   --json            Request JSON output format
#   --help            Show this help
#
# Exit codes:
#   0 - Success
#   1 - Service error
#   2 - Model not found
#   3 - Timeout
#   4 - Empty response
#
# Examples:
#   ollama-run.sh --prompt "Hello"
#   ollama-run.sh --model codellama --prompt "Write quicksort"
#   cat prompt.txt | ollama-run.sh
#   ollama-run.sh --system "You are a translator" --prompt "Translate: Hello"

set -e

# Defaults
MODEL="${OLLAMA_DEFAULT_MODEL:-qwen3:1.7b}"
TIMEOUT="${OLLAMA_DEFAULT_TIMEOUT:-120}"
PROMPT=""
SYSTEM=""
JSON_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        --prompt)
            PROMPT="$2"
            shift 2
            ;;
        --system)
            SYSTEM="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --json)
            JSON_MODE=true
            shift
            ;;
        --help)
            head -30 "$0" | grep -E "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Read from stdin if no prompt provided
if [[ -z "$PROMPT" ]]; then
    if [ -t 0 ]; then
        echo "Error: No prompt provided. Use --prompt or pipe content." >&2
        exit 1
    fi
    PROMPT=$(cat)
fi

# Check service
if ! ollama list &> /dev/null; then
    echo "Error: Ollama service not running. Start with: ollama serve" >&2
    exit 1
fi

# Check model
if ! ollama list | grep -q "$MODEL"; then
    echo "Error: Model '$MODEL' not found. Pull with: ollama pull $MODEL" >&2
    exit 2
fi

# Build the full prompt
FULL_PROMPT=""
if [[ -n "$SYSTEM" ]]; then
    FULL_PROMPT="$SYSTEM

"
fi
FULL_PROMPT="$FULL_PROMPT$PROMPT"

# Add JSON instruction if requested
if $JSON_MODE; then
    FULL_PROMPT="$FULL_PROMPT

Output only valid JSON, no explanation."
fi

# Execute with timeout (macOS compatible - using perl if timeout not available)
run_with_timeout() {
    local timeout_sec=$1
    shift
    if command -v timeout &> /dev/null; then
        timeout "$timeout_sec" "$@"
    elif command -v gtimeout &> /dev/null; then
        gtimeout "$timeout_sec" "$@"
    else
        # Use perl for macOS (no coreutils installed)
        perl -e 'alarm shift; exec @ARGV' "$timeout_sec" "$@"
    fi
}

RESPONSE=""
RESPONSE=$(run_with_timeout "$TIMEOUT" bash -c "echo \"\$1\" | ollama run \"\$2\"" -- "$FULL_PROMPT" "$MODEL" 2>&1) || {
    EXIT_CODE=$?
    if [[ $EXIT_CODE -eq 124 ]] || [[ $EXIT_CODE -eq 142 ]]; then
        echo "Error: Timeout after ${TIMEOUT}s" >&2
        exit 3
    fi
    echo "Error: Ollama execution failed: $RESPONSE" >&2
    exit 1
}

# Check for empty response
if [[ -z "$RESPONSE" ]]; then
    echo "Error: Empty response from model" >&2
    exit 4
fi

# Output response
echo "$RESPONSE"
