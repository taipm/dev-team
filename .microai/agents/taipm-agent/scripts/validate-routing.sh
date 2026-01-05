#!/bin/bash
# validate-routing.sh
# Validate routing rules consistency and coverage
# Usage: ./validate-routing.sh [--verbose] [--fix]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
KNOWLEDGE_DIR="$AGENT_DIR/knowledge"
AGENTS_DIR="$(dirname "$AGENT_DIR")"
TEAMS_DIR="$(dirname "$AGENTS_DIR")/teams"

VERBOSE=false
FIX=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v) VERBOSE=true; shift ;;
        --fix|-f) FIX=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "🧠 Taipm Agent - Routing Validation"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to log
log_error() {
    echo -e "${RED}❌ ERROR:${NC} $1"
    ((ERRORS++))
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
    ((WARNINGS++))
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "   $1"
    fi
}

# 1. Check knowledge files exist
echo "📂 Checking Knowledge Files..."
REQUIRED_KNOWLEDGE=(
    "01-agent-registry.md"
    "02-routing-rules.md"
    "03-user-preferences-guide.md"
    "04-workflow-catalog.md"
    "05-handoff-protocol.md"
    "06-learning-patterns.md"
)

for file in "${REQUIRED_KNOWLEDGE[@]}"; do
    if [ -f "$KNOWLEDGE_DIR/$file" ]; then
        log_success "Found: $file"
        log_verbose "$(wc -l < "$KNOWLEDGE_DIR/$file") lines"
    else
        log_error "Missing: $file"
    fi
done
echo ""

# 2. Check workflow files exist
echo "📋 Checking Workflow Files..."
WORKFLOW_DIR="$AGENT_DIR/workflows"
REQUIRED_WORKFLOWS=(
    "route-request.yaml"
    "daily-briefing.yaml"
    "learn-pattern.yaml"
)

for file in "${REQUIRED_WORKFLOWS[@]}"; do
    if [ -f "$WORKFLOW_DIR/$file" ]; then
        log_success "Found: $file"
    else
        log_error "Missing: $file"
    fi
done
echo ""

# 3. Validate agent registry against actual agents
echo "🔍 Validating Agent Registry..."
REGISTRY_FILE="$KNOWLEDGE_DIR/01-agent-registry.md"

if [ -f "$REGISTRY_FILE" ]; then
    # Count agents in registry
    REGISTRY_COUNT=$(grep -c "^\| \*\*" "$REGISTRY_FILE" 2>/dev/null || echo "0")

    # Count actual agents
    ACTUAL_AGENTS=$(find "$AGENTS_DIR" -maxdepth 1 -type d ! -name ".*" | wc -l)
    ACTUAL_AGENTS=$((ACTUAL_AGENTS - 1))  # Exclude the agents dir itself

    log_verbose "Registry entries: ~$REGISTRY_COUNT"
    log_verbose "Actual agents: $ACTUAL_AGENTS"

    # Check each agent directory has entry in registry
    for agent_dir in "$AGENTS_DIR"/*/; do
        agent_name=$(basename "$agent_dir")
        if [ "$agent_name" != "taipm-agent" ]; then
            if grep -q "$agent_name" "$REGISTRY_FILE" 2>/dev/null; then
                log_verbose "Found in registry: $agent_name"
            else
                log_warning "Agent not in registry: $agent_name"
            fi
        fi
    done
    log_success "Agent registry validation complete"
else
    log_error "Agent registry file not found"
fi
echo ""

# 4. Validate routing rules
echo "🔗 Validating Routing Rules..."
ROUTING_FILE="$KNOWLEDGE_DIR/02-routing-rules.md"

if [ -f "$ROUTING_FILE" ]; then
    # Extract routes from routing rules
    ROUTES=$(grep -oE "route: [a-z-]+" "$ROUTING_FILE" | cut -d' ' -f2 | sort -u)

    for route in $ROUTES; do
        # Check if route exists as agent or team
        if [ -d "$AGENTS_DIR/$route" ] || [ -d "$TEAMS_DIR/$route" ]; then
            log_verbose "Valid route: $route"
        else
            log_error "Invalid route target: $route (not found in agents or teams)"
        fi
    done
    log_success "Routing rules validation complete"
else
    log_error "Routing rules file not found"
fi
echo ""

# 5. Check memory structure
echo "💾 Checking Memory Structure..."
MEMORY_DIR="$AGENT_DIR/memory"
UNIFIED_MEMORY="$(dirname "$AGENTS_DIR")/memory"

REQUIRED_MEMORY=(
    "$MEMORY_DIR/context.md"
    "$MEMORY_DIR/learning.md"
    "$UNIFIED_MEMORY/context.md"
    "$UNIFIED_MEMORY/preferences.yaml"
    "$UNIFIED_MEMORY/insights.md"
)

for file in "${REQUIRED_MEMORY[@]}"; do
    if [ -f "$file" ]; then
        log_success "Found: $(basename "$file")"
    else
        log_warning "Missing memory file: $file"
        if [ "$FIX" = true ]; then
            echo "Creating: $file"
            mkdir -p "$(dirname "$file")"
            touch "$file"
        fi
    fi
done
echo ""

# 6. Check command entry point
echo "🎯 Checking Command Entry Point..."
COMMAND_FILE="$(dirname "$AGENTS_DIR")/../.claude/commands/microai/taipm.md"

if [ -f "$COMMAND_FILE" ]; then
    log_success "Command entry point exists"
    log_verbose "Path: $COMMAND_FILE"
else
    log_error "Command entry point missing: taipm.md"
fi
echo ""

# 7. Summary
echo "===================================="
echo "📊 Validation Summary"
echo "===================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo ""
    echo "Taipm Agent routing is properly configured."
else
    echo -e "Errors: ${RED}$ERRORS${NC}"
    echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
    echo ""
    if [ $ERRORS -gt 0 ]; then
        echo -e "${RED}Please fix errors before using Taipm Agent.${NC}"
        exit 1
    fi
fi

echo ""
echo "Run with --verbose for detailed output"
echo "Run with --fix to auto-create missing files"
