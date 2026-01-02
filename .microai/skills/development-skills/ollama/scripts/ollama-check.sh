#!/bin/bash
#
# ollama-check.sh - Check Ollama service and model availability
#
# Usage:
#   ollama-check.sh [OPTIONS]
#
# Options:
#   --model MODEL   Check if specific model is available
#   --verbose       Show detailed output
#   --help          Show this help
#
# Exit codes:
#   0 - Service running (and model available if specified)
#   1 - Service not running
#   2 - Model not found
#
# Examples:
#   ollama-check.sh                     # Check service only
#   ollama-check.sh --model qwen3:1.7b  # Check service + model
#   ollama-check.sh --verbose           # Verbose output

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Defaults
MODEL=""
VERBOSE=false
ENDPOINT="${OLLAMA_ENDPOINT:-http://localhost:11434}"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            head -30 "$0" | grep -E "^#" | sed 's/^# *//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

log_info() {
    if $VERBOSE; then
        echo -e "${GREEN}[INFO]${NC} $1"
    fi
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check 1: Ollama command exists
if ! command -v ollama &> /dev/null; then
    log_error "Ollama not installed. Visit https://ollama.ai"
    exit 1
fi

log_info "Ollama command found"

# Check 2: Service is running
if ! ollama list &> /dev/null; then
    log_error "Ollama service not running. Start with: ollama serve"
    exit 1
fi

log_info "Ollama service is running"

# Check 3: Model available (if specified)
if [[ -n "$MODEL" ]]; then
    if ! ollama list | grep -q "$MODEL"; then
        log_error "Model '$MODEL' not found. Pull with: ollama pull $MODEL"
        if $VERBOSE; then
            echo ""
            echo "Available models:"
            ollama list
        fi
        exit 2
    fi
    log_info "Model '$MODEL' is available"
fi

# Success output
if $VERBOSE; then
    echo ""
    echo -e "${GREEN}✓ Ollama ready${NC}"
    if [[ -n "$MODEL" ]]; then
        echo "  Model: $MODEL"
    fi
    echo "  Endpoint: $ENDPOINT"
    echo ""
    echo "Available models:"
    ollama list
fi

exit 0
