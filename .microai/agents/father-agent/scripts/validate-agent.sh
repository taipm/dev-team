#!/bin/bash
# validate-agent.sh - Quick agent validation for MicroAI agents
# Usage: ./validate-agent.sh <agent-name>
# Example: ./validate-agent.sh root-cause-agent

set -e

AGENT_NAME=$1
BASE_PATH=".microai/agents"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

print_fail() {
    echo -e "${RED}✗${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "○ $1"
}

# Check usage
if [ -z "$AGENT_NAME" ]; then
    echo "Usage: ./validate-agent.sh <agent-name>"
    echo "Example: ./validate-agent.sh root-cause-agent"
    exit 1
fi

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           AGENT VALIDATION: ${AGENT_NAME}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"

ERRORS=0
WARNINGS=0

# ============================================
# PHASE 1: FILE STRUCTURE
# ============================================
print_header "PHASE 1: File Structure"

AGENT_PATH="$BASE_PATH/$AGENT_NAME/agent.md"
if [ -f "$AGENT_PATH" ]; then
    print_pass "agent.md exists at $AGENT_PATH"
else
    print_fail "agent.md NOT FOUND at $AGENT_PATH"
    ERRORS=$((ERRORS + 1))
    echo "Cannot continue without agent.md"
    exit 1
fi

# Check command file (try both full name and short name)
CMD_PATH=".microai/commands/$AGENT_NAME.md"
CMD_PATH_SHORT=".microai/commands/${AGENT_NAME%-agent}.md"
if [ -f "$CMD_PATH" ]; then
    print_pass "Command file exists at $CMD_PATH"
    ACTIVE_CMD_PATH="$CMD_PATH"
elif [ -f "$CMD_PATH_SHORT" ]; then
    print_pass "Command file exists at $CMD_PATH_SHORT"
    ACTIVE_CMD_PATH="$CMD_PATH_SHORT"
else
    print_warn "Command file not found (tried $CMD_PATH and $CMD_PATH_SHORT)"
    WARNINGS=$((WARNINGS + 1))
    ACTIVE_CMD_PATH=""
fi

# Check knowledge directory
KNOWLEDGE_PATH="$BASE_PATH/$AGENT_NAME/knowledge"
if [ -d "$KNOWLEDGE_PATH" ]; then
    KNOWLEDGE_COUNT=$(ls -1 "$KNOWLEDGE_PATH"/*.md 2>/dev/null | wc -l)
    print_pass "Knowledge directory exists ($KNOWLEDGE_COUNT files)"
else
    print_info "No knowledge directory (optional)"
fi

# ============================================
# PHASE 2: REQUIRED FIELDS
# ============================================
print_header "PHASE 2: Required Fields (Metadata Spec v1.2)"

REQUIRED_FIELDS=("name:" "description:" "model:" "tools:" "language:")
for field in "${REQUIRED_FIELDS[@]}"; do
    if grep -q "^$field" "$AGENT_PATH"; then
        # Get field value for validation
        VALUE=$(grep "^$field" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
        print_pass "$field $VALUE"
    else
        print_fail "$field MISSING (required)"
        ERRORS=$((ERRORS + 1))
    fi
done

# ============================================
# PHASE 3: STYLE FIELDS (Recommended)
# ============================================
print_header "PHASE 3: Style Fields (Recommended)"

STYLE_FIELDS=("color:" "icon:")
for field in "${STYLE_FIELDS[@]}"; do
    if grep -q "^$field" "$AGENT_PATH"; then
        VALUE=$(grep "^$field" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
        print_pass "$field $VALUE"
    else
        print_warn "$field missing (recommended for UI)"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# ============================================
# PHASE 4: v1.2 OPTIONAL FIELDS
# ============================================
print_header "PHASE 4: v1.2 Optional Fields"

V12_FIELDS=("persona:" "thinking:" "critical_actions:" "skills:")
for field in "${V12_FIELDS[@]}"; do
    if grep -q "^$field" "$AGENT_PATH"; then
        print_pass "$field present"
    else
        print_info "$field not used (optional)"
    fi
done

# ============================================
# PHASE 5: FIELD VALUE VALIDATION
# ============================================
print_header "PHASE 5: Field Value Validation"

# Validate model value
MODEL=$(grep "^model:" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
if [[ "$MODEL" == "opus" || "$MODEL" == "sonnet" || "$MODEL" == "haiku" ]]; then
    print_pass "model: valid value ($MODEL)"
else
    print_fail "model: invalid value '$MODEL' (must be opus/sonnet/haiku)"
    ERRORS=$((ERRORS + 1))
fi

# Validate language value
LANGUAGE=$(grep "^language:" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
if [[ "$LANGUAGE" == "vi" || "$LANGUAGE" == "en" ]]; then
    print_pass "language: valid value ($LANGUAGE)"
else
    print_fail "language: invalid value '$LANGUAGE' (must be vi/en)"
    ERRORS=$((ERRORS + 1))
fi

# Validate name matches directory
NAME=$(grep "^name:" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
if [[ "$NAME" == "$AGENT_NAME" ]]; then
    print_pass "name matches directory ($NAME)"
else
    print_warn "name '$NAME' does not match directory '$AGENT_NAME'"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for valid color
if grep -q "^color:" "$AGENT_PATH"; then
    COLOR=$(grep "^color:" "$AGENT_PATH" | head -1 | cut -d':' -f2 | xargs)
    VALID_COLORS=("purple" "red" "green" "orange" "blue" "cyan" "yellow" "pink")
    if [[ " ${VALID_COLORS[@]} " =~ " ${COLOR} " ]]; then
        print_pass "color: valid value ($COLOR)"
    else
        print_warn "color: '$COLOR' not in standard palette"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# ============================================
# PHASE 6: CONTENT CHECK
# ============================================
print_header "PHASE 6: Content Quality"

# Check for description examples
if grep -q "Examples:" "$AGENT_PATH" || grep -q "Example:" "$AGENT_PATH"; then
    print_pass "Description has examples"
else
    print_warn "Description missing examples section"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for activation protocol
if grep -q "<activation" "$AGENT_PATH" || grep -q "Activation Protocol" "$AGENT_PATH"; then
    print_pass "Activation protocol present"
else
    print_warn "No activation protocol found"
    WARNINGS=$((WARNINGS + 1))
fi

# Check line count
LINE_COUNT=$(wc -l < "$AGENT_PATH")
if [ "$LINE_COUNT" -lt 50 ]; then
    print_warn "agent.md is short ($LINE_COUNT lines) - may need more content"
    WARNINGS=$((WARNINGS + 1))
elif [ "$LINE_COUNT" -gt 800 ]; then
    print_warn "agent.md is very long ($LINE_COUNT lines) - consider splitting"
    WARNINGS=$((WARNINGS + 1))
else
    print_pass "agent.md size reasonable ($LINE_COUNT lines)"
fi

# ============================================
# PHASE 7: COMMAND FILE CHECK
# ============================================
if [ -n "$ACTIVE_CMD_PATH" ]; then
    print_header "PHASE 7: Command File Validation"

    # Check command file has frontmatter
    if grep -q "^---" "$ACTIVE_CMD_PATH"; then
        print_pass "Command file has frontmatter"
    else
        print_fail "Command file missing frontmatter"
        ERRORS=$((ERRORS + 1))
    fi

    # Check LOAD instruction
    if grep -q "LOAD" "$ACTIVE_CMD_PATH"; then
        print_pass "Command has LOAD instruction"
    else
        print_warn "Command missing LOAD instruction"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      VALIDATION SUMMARY                        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ PASSED - Agent is fully compliant with Metadata Spec v1.2${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ PASSED WITH WARNINGS${NC}"
    echo "  Errors: $ERRORS"
    echo "  Warnings: $WARNINGS"
    echo ""
    echo "Agent is functional but could be improved."
    exit 0
else
    echo -e "${RED}✗ FAILED${NC}"
    echo "  Errors: $ERRORS"
    echo "  Warnings: $WARNINGS"
    echo ""
    echo "Please fix errors before deploying."
    exit 1
fi
