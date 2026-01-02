#!/bin/bash
#
# ollama-models.sh - Manage Ollama models
#
# Usage:
#   ollama-models.sh <command> [MODEL]
#
# Commands:
#   list              List available models
#   pull MODEL        Pull/download a model
#   info MODEL        Show model details
#   delete MODEL      Delete a model
#   help              Show this help
#
# Exit codes:
#   0 - Success
#   1 - Service error
#   2 - Model error
#
# Examples:
#   ollama-models.sh list
#   ollama-models.sh pull qwen3:1.7b
#   ollama-models.sh info codellama
#   ollama-models.sh delete mistral

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    head -25 "$0" | grep -E "^#" | sed 's/^# *//'
}

check_service() {
    if ! ollama list &> /dev/null; then
        echo -e "${RED}Error: Ollama service not running. Start with: ollama serve${NC}" >&2
        exit 1
    fi
}

cmd_list() {
    check_service
    echo -e "${BLUE}Available Ollama Models:${NC}"
    echo ""
    ollama list
    echo ""
    echo -e "${YELLOW}Tip: Pull more models with: ollama-models.sh pull <model>${NC}"
    echo "Popular: qwen3:1.7b, llama3.2, codellama, mistral, phi3"
}

cmd_pull() {
    local model="$1"
    if [[ -z "$model" ]]; then
        echo -e "${RED}Error: Model name required${NC}" >&2
        echo "Usage: ollama-models.sh pull <model>"
        exit 2
    fi

    check_service
    echo -e "${BLUE}Pulling model: $model${NC}"
    echo ""

    if ollama pull "$model"; then
        echo ""
        echo -e "${GREEN}✓ Model '$model' pulled successfully${NC}"
    else
        echo -e "${RED}Failed to pull model '$model'${NC}" >&2
        exit 2
    fi
}

cmd_info() {
    local model="$1"
    if [[ -z "$model" ]]; then
        echo -e "${RED}Error: Model name required${NC}" >&2
        echo "Usage: ollama-models.sh info <model>"
        exit 2
    fi

    check_service

    if ! ollama list | grep -q "$model"; then
        echo -e "${RED}Error: Model '$model' not found locally${NC}" >&2
        echo "Pull it first: ollama-models.sh pull $model"
        exit 2
    fi

    echo -e "${BLUE}Model Info: $model${NC}"
    echo ""
    ollama show "$model"
}

cmd_delete() {
    local model="$1"
    if [[ -z "$model" ]]; then
        echo -e "${RED}Error: Model name required${NC}" >&2
        echo "Usage: ollama-models.sh delete <model>"
        exit 2
    fi

    check_service

    if ! ollama list | grep -q "$model"; then
        echo -e "${YELLOW}Model '$model' not found locally${NC}"
        exit 0
    fi

    echo -e "${YELLOW}Deleting model: $model${NC}"

    if ollama rm "$model"; then
        echo -e "${GREEN}✓ Model '$model' deleted${NC}"
    else
        echo -e "${RED}Failed to delete model '$model'${NC}" >&2
        exit 2
    fi
}

# Main
COMMAND="${1:-help}"
MODEL="${2:-}"

case "$COMMAND" in
    list)
        cmd_list
        ;;
    pull)
        cmd_pull "$MODEL"
        ;;
    info)
        cmd_info "$MODEL"
        ;;
    delete|rm)
        cmd_delete "$MODEL"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}" >&2
        echo "Run 'ollama-models.sh help' for usage"
        exit 1
        ;;
esac
