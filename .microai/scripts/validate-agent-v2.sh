#!/bin/bash
# validate-agent-v2.sh - Agent v2.1 Schema Validation
# Usage: ./validate-agent-v2.sh <agent-name>
# Updated: 2026-01-01 - Support v2.1 schema (instruction.system, reasoning, on_start)

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0
PASSED=0

AGENT_NAME=$1
BASE_DIR="${2:-.}"

if [ -z "$AGENT_NAME" ]; then
    echo "Usage: ./validate-agent-v2.sh <agent-name> [base-dir]"
    echo "Example: ./validate-agent-v2.sh father-agent"
    exit 1
fi

AGENT_PATH="$BASE_DIR/.microai/agents/$AGENT_NAME/agent.md"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  AGENT v2.0 VALIDATION                                         ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  Agent: $AGENT_NAME"
echo "║  Path:  $AGENT_PATH"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 1: FILE EXISTENCE
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 1: File Existence ═══"

if [ -f "$AGENT_PATH" ]; then
    echo -e "${GREEN}✓${NC} agent.md exists"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} agent.md NOT FOUND at $AGENT_PATH"
    ((ERRORS++))
    echo ""
    echo "Validation failed: Agent file not found"
    exit 1
fi

# Check workflows directory
WORKFLOW_DIR="$BASE_DIR/.microai/agents/$AGENT_NAME/workflows"
if [ -d "$WORKFLOW_DIR" ]; then
    echo -e "${GREEN}✓${NC} workflows/ directory exists"
    ((PASSED++))

    # Count workflow files
    WORKFLOW_COUNT=$(find "$WORKFLOW_DIR" -name "*.yaml" -o -name "*.yml" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${BLUE}  → Found $WORKFLOW_COUNT workflow files${NC}"
else
    echo -e "${YELLOW}⚠${NC} workflows/ directory not found (optional)"
    ((WARNINGS++))
fi

# Check knowledge directory
KNOWLEDGE_DIR="$BASE_DIR/.microai/agents/$AGENT_NAME/knowledge"
if [ -d "$KNOWLEDGE_DIR" ]; then
    echo -e "${GREEN}✓${NC} knowledge/ directory exists"
    ((PASSED++))

    KNOWLEDGE_COUNT=$(find "$KNOWLEDGE_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${BLUE}  → Found $KNOWLEDGE_COUNT knowledge files${NC}"
else
    echo -e "${YELLOW}⚠${NC} knowledge/ directory not found (optional)"
    ((WARNINGS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 2: v2.0 STRUCTURE CHECK
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 2: v2.0 Structure ═══"

# Check for agent: root namespace
if grep -q "^agent:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} agent: root namespace present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Missing 'agent:' root namespace (v2.0 required)"
    ((ERRORS++))
fi

# Check for nested metadata
if grep -q "^  metadata:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} agent.metadata block present"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Missing 'agent.metadata' block"
    ((ERRORS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 3: REQUIRED FIELDS (v2.0)
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 3: Required Fields ═══"

# Required metadata fields
REQUIRED_META=("id:" "name:" "title:" "model:" "language:")
for field in "${REQUIRED_META[@]}"; do
    if grep -q "^    $field" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} metadata.$field present"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} metadata.$field MISSING (required)"
        ((ERRORS++))
    fi
done

# Required instruction block (v2.1)
if grep -q "^  instruction:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} agent.instruction block present"
    ((PASSED++))

    if grep -q "^    system:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} instruction.system present (LLM prompt)"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} instruction.system MISSING (required in v2.1)"
        ((ERRORS++))
    fi

    # Check optional but recommended must/must_not
    if grep -q "^    must:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} instruction.must defined"
        ((PASSED++))
    fi
    if grep -q "^    must_not:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} instruction.must_not defined"
        ((PASSED++))
    fi
else
    echo -e "${RED}✗${NC} agent.instruction block MISSING (required in v2.1)"
    ((ERRORS++))
fi

# Optional persona block (simplified in v2.1)
if grep -q "^  persona:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} agent.persona block present"
    ((PASSED++))
else
    echo -e "${YELLOW}○${NC} agent.persona not defined (optional in v2.1)"
    ((WARNINGS++))
fi

# Required activation
if grep -q "^  activation:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} agent.activation block present"
    ((PASSED++))

    if grep -q "^    on_start:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} activation.on_start present"
        ((PASSED++))
    elif grep -q "^    steps:" "$AGENT_PATH"; then
        echo -e "${YELLOW}⚠${NC} activation.steps found (deprecated, use on_start in v2.1)"
        ((WARNINGS++))
    else
        echo -e "${RED}✗${NC} activation.on_start MISSING (required)"
        ((ERRORS++))
    fi
else
    echo -e "${RED}✗${NC} agent.activation block MISSING (required)"
    ((ERRORS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 4: OPTIONAL FIELDS
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 4: Optional Fields ═══"

# Check optional but recommended fields
OPTIONAL_FIELDS=("icon:" "color:" "version:" "tags:")
for field in "${OPTIONAL_FIELDS[@]}"; do
    if grep -q "$field" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} $field present"
        ((PASSED++))
    else
        echo -e "${YELLOW}○${NC} $field not defined (recommended)"
        ((WARNINGS++))
    fi
done

# Check capabilities block
if grep -q "^  capabilities:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} capabilities block present"
    ((PASSED++))

    if grep -q "^    tools:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} capabilities.tools defined"
        ((PASSED++))
    fi
else
    echo -e "${YELLOW}○${NC} capabilities block not defined"
    ((WARNINGS++))
fi

# Check menu block
if grep -q "^  menu:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} menu block present"
    ((PASSED++))

    # Check for fuzzy triggers
    if grep -q "trigger:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} fuzzy triggers defined"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} No fuzzy triggers found in menu"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}○${NC} menu block not defined"
    ((WARNINGS++))
fi

# Check reasoning block (renamed from thinking in v2.1)
if grep -q "^  reasoning:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} reasoning block present"
    ((PASSED++))
elif grep -q "^  thinking:" "$AGENT_PATH"; then
    echo -e "${YELLOW}⚠${NC} thinking block found (renamed to reasoning in v2.1)"
    ((WARNINGS++))
else
    echo -e "${YELLOW}○${NC} reasoning block not defined"
    ((WARNINGS++))
fi

# Check memory block
if grep -q "^  memory:" "$AGENT_PATH"; then
    echo -e "${GREEN}✓${NC} memory block present"
    ((PASSED++))

    if grep -q "enabled:" "$AGENT_PATH"; then
        echo -e "${GREEN}✓${NC} memory.enabled explicitly set"
        ((PASSED++))
    fi
else
    echo -e "${YELLOW}○${NC} memory block not defined"
    ((WARNINGS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 5: WORKFLOW VALIDATION
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 5: Workflow Validation ═══"

# Extract workflow references from menu
if [ -d "$WORKFLOW_DIR" ]; then
    # Check each workflow reference - only from menu section
    while IFS= read -r workflow_ref; do
        # Skip empty, inline, comments, and schema examples
        if [ -n "$workflow_ref" ] && \
           [ "$workflow_ref" != "inline" ] && \
           [[ ! "$workflow_ref" =~ ^# ]] && \
           [[ ! "$workflow_ref" =~ string ]] && \
           [[ "$workflow_ref" =~ \.yaml$ || "$workflow_ref" =~ \.yml$ ]]; then
            # Remove quotes and leading ./
            workflow_file=$(echo "$workflow_ref" | tr -d '"' | sed 's|^\./||')
            full_path="$BASE_DIR/.microai/agents/$AGENT_NAME/$workflow_file"

            if [ -f "$full_path" ]; then
                echo -e "${GREEN}✓${NC} Workflow exists: $workflow_file"
                ((PASSED++))
            else
                echo -e "${RED}✗${NC} Workflow NOT FOUND: $workflow_file"
                ((ERRORS++))
            fi
        fi
    done < <(grep "workflow:" "$AGENT_PATH" | awk '{print $2}' | grep -v "inline")
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 6: COMMAND REGISTRATION
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 6: Command Registration ═══"

# Check source command
SOURCE_CMD="$BASE_DIR/.microai/commands/$AGENT_NAME.md"
if [ -f "$SOURCE_CMD" ]; then
    echo -e "${GREEN}✓${NC} Source command exists: .microai/commands/$AGENT_NAME.md"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠${NC} Source command not found (may need registration)"
    ((WARNINGS++))
fi

# Check runtime command
RUNTIME_CMD="$BASE_DIR/.claude/commands/microai/$AGENT_NAME.md"
if [ -f "$RUNTIME_CMD" ]; then
    echo -e "${GREEN}✓${NC} Runtime command exists: .claude/commands/microai/$AGENT_NAME.md"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠${NC} Runtime command not registered"
    ((WARNINGS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# PHASE 7: YAML SYNTAX
# ════════════════════════════════════════════════════════════════════
echo "═══ PHASE 7: YAML Syntax ═══"

# Check for tabs (YAML doesn't allow tabs)
if grep -q $'\t' "$AGENT_PATH"; then
    echo -e "${RED}✗${NC} Found TAB characters (YAML requires spaces)"
    ((ERRORS++))
else
    echo -e "${GREEN}✓${NC} No tab characters found"
    ((PASSED++))
fi

# Check frontmatter delimiters
if head -1 "$AGENT_PATH" | grep -q "^---$"; then
    echo -e "${GREEN}✓${NC} Opening frontmatter delimiter found"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Missing opening --- delimiter"
    ((ERRORS++))
fi

# Count --- delimiters (should be exactly 2)
DELIMITER_COUNT=$(grep -c "^---$" "$AGENT_PATH" || true)
if [ "$DELIMITER_COUNT" -ge 2 ]; then
    echo -e "${GREEN}✓${NC} Frontmatter properly closed"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Missing closing --- delimiter"
    ((ERRORS++))
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# SUMMARY
# ════════════════════════════════════════════════════════════════════
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  VALIDATION SUMMARY                                            ║"
echo "╠═══════════════════════════════════════════════════════════════╣"

TOTAL=$((PASSED + ERRORS + WARNINGS))
SCORE=$((PASSED * 100 / TOTAL))

if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "║  Status: ${GREEN}PASSED${NC} - Agent is v2.1 compliant                      ║"
        GRADE="A"
    else
        echo -e "║  Status: ${GREEN}PASSED${NC} with warnings                                  ║"
        GRADE="B"
    fi
else
    echo -e "║  Status: ${RED}FAILED${NC} - Please fix errors before deployment          ║"
    GRADE="F"
fi

echo "╠═══════════════════════════════════════════════════════════════╣"
echo -e "║  ${GREEN}Passed:${NC}   $PASSED                                                    ║"
echo -e "║  ${RED}Errors:${NC}   $ERRORS                                                    ║"
echo -e "║  ${YELLOW}Warnings:${NC} $WARNINGS                                                    ║"
echo "║  Score:   $SCORE% (Grade: $GRADE)                                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Exit with error code if validation failed
if [ $ERRORS -gt 0 ]; then
    exit 1
fi

exit 0
