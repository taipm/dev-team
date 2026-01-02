#!/bin/bash
# migrate-to-v2.sh - Migrate agent from v1.x to v2.0 format
# Usage: ./migrate-to-v2.sh <agent-name> [--dry-run]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

AGENT_NAME=$1
DRY_RUN=false
BASE_DIR="${3:-.}"

if [ "$2" = "--dry-run" ]; then
    DRY_RUN=true
fi

if [ -z "$AGENT_NAME" ]; then
    echo "Usage: ./migrate-to-v2.sh <agent-name> [--dry-run]"
    echo ""
    echo "Options:"
    echo "  --dry-run    Show what would be changed without making changes"
    echo ""
    echo "Examples:"
    echo "  ./migrate-to-v2.sh go-dev-agent"
    echo "  ./migrate-to-v2.sh go-dev-agent --dry-run"
    exit 1
fi

AGENT_PATH="$BASE_DIR/.microai/agents/$AGENT_NAME/agent.md"
BACKUP_PATH="$BASE_DIR/.microai/agents/$AGENT_NAME/agent.md.v1.backup"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  AGENT v1.x → v2.0 MIGRATION                                   ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  Agent: $AGENT_NAME"
echo "║  Path:  $AGENT_PATH"
if [ "$DRY_RUN" = true ]; then
echo -e "║  Mode:  ${YELLOW}DRY RUN${NC} (no changes will be made)"
fi
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Check if agent exists
if [ ! -f "$AGENT_PATH" ]; then
    echo -e "${RED}Error:${NC} Agent file not found: $AGENT_PATH"
    exit 1
fi

# Check if already v2.0
if grep -q "^agent:" "$AGENT_PATH"; then
    echo -e "${YELLOW}Warning:${NC} Agent appears to already be v2.0 format"
    echo "  (Found 'agent:' root namespace)"
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# ════════════════════════════════════════════════════════════════════
# STEP 1: Create Backup
# ════════════════════════════════════════════════════════════════════
echo "═══ Step 1: Create Backup ═══"
if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}[DRY RUN]${NC} Would create backup: $BACKUP_PATH"
else
    cp "$AGENT_PATH" "$BACKUP_PATH"
    echo -e "${GREEN}✓${NC} Backup created: $BACKUP_PATH"
fi
echo ""

# ════════════════════════════════════════════════════════════════════
# STEP 2: Extract Current Values
# ════════════════════════════════════════════════════════════════════
echo "═══ Step 2: Extract Current Values ═══"

# Extract values from v1.x format
extract_value() {
    local key=$1
    grep "^$key:" "$AGENT_PATH" | head -1 | sed "s/^$key: *//" | tr -d '"'
}

NAME=$(extract_value "name")
# shellcheck disable=SC2034
DESCRIPTION=$(grep -A 10 "^description:" "$AGENT_PATH" | head -10)
MODEL=$(extract_value "model")
COLOR=$(extract_value "color")
ICON=$(extract_value "icon")
LANGUAGE=$(extract_value "language")
VERSION=$(extract_value "version")

echo "  name: $NAME"
echo "  model: $MODEL"
echo "  color: $COLOR"
echo "  icon: $ICON"
echo "  language: $LANGUAGE"
echo "  version: $VERSION → 2.0"

# Extract tools
TOOLS=$(grep -A 20 "^tools:" "$AGENT_PATH" | grep "^  - " | sed 's/^  - //' | tr '\n' ',' | sed 's/,$//')
echo "  tools: $TOOLS"

# Extract skills
SKILLS=$(grep -A 10 "^skills:" "$AGENT_PATH" | grep "^  - " | sed 's/^  - //' | tr '\n' ',' | sed 's/,$//')
echo "  skills: $SKILLS"

# Extract tags
TAGS=$(grep -A 10 "^tags:" "$AGENT_PATH" | grep "^  - " | sed 's/^  - //' | tr '\n' ',' | sed 's/,$//')
echo "  tags: $TAGS"

echo ""

# ════════════════════════════════════════════════════════════════════
# STEP 3: Generate v2.0 Frontmatter
# ════════════════════════════════════════════════════════════════════
echo "═══ Step 3: Generate v2.0 Format ═══"

# Create temporary file with new format
TEMP_FILE=$(mktemp)

cat > "$TEMP_FILE" << EOF
---
agent:
  # ════════════════════════════════════════════════════════════════════
  # METADATA - Identity & Configuration
  # ════════════════════════════════════════════════════════════════════
  metadata:
    id: ".microai/agents/$AGENT_NAME/agent.md"
    name: $NAME
    title: ${NAME//-/ } # TODO: Add proper title
    icon: "$ICON"
    color: $COLOR
    version: "2.0"
    model: $MODEL
    language: $LANGUAGE
    tags:
EOF

# Add tags
if [ -n "$TAGS" ]; then
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    for tag in "${TAG_ARRAY[@]}"; do
        echo "      - $tag" >> "$TEMP_FILE"
    done
fi

cat >> "$TEMP_FILE" << 'EOF'

  # ════════════════════════════════════════════════════════════════════
  # CAPABILITIES - Tools, Skills, Knowledge
  # ════════════════════════════════════════════════════════════════════
  capabilities:
    tools:
EOF

# Add tools
if [ -n "$TOOLS" ]; then
    IFS=',' read -ra TOOL_ARRAY <<< "$TOOLS"
    for tool in "${TOOL_ARRAY[@]}"; do
        echo "      - $tool" >> "$TEMP_FILE"
    done
fi

if [ -n "$SKILLS" ]; then
    echo "" >> "$TEMP_FILE"
    echo "    skills:" >> "$TEMP_FILE"
    IFS=',' read -ra SKILL_ARRAY <<< "$SKILLS"
    for skill in "${SKILL_ARRAY[@]}"; do
        echo "      - $skill" >> "$TEMP_FILE"
    done
fi

cat >> "$TEMP_FILE" << 'EOF'

    knowledge:
      auto_load: []
      on_demand: []

  # ════════════════════════════════════════════════════════════════════
  # PERSONA - Character Definition
  # ════════════════════════════════════════════════════════════════════
  persona:
    role: # TODO: Extract from v1 persona.role
    identity: |
      # TODO: Extract from v1 persona.identity
    communication_style: []
    principles: []

  # ════════════════════════════════════════════════════════════════════
  # THINKING - Reasoning Patterns
  # ════════════════════════════════════════════════════════════════════
  thinking:
    main_task: []

  # ════════════════════════════════════════════════════════════════════
  # MENU - Commands with Fuzzy Triggers
  # ════════════════════════════════════════════════════════════════════
  menu: []
    # TODO: Add menu items with fuzzy triggers
    # - cmd: "*command"
    #   trigger: "keyword1|keyword2"
    #   workflow: "./workflows/workflow.yaml"
    #   description: "Description"

  # ════════════════════════════════════════════════════════════════════
  # ACTIVATION - Startup Protocol
  # ════════════════════════════════════════════════════════════════════
  activation:
    critical: true
    steps:
      - Load persona từ file này
      - Display greeting/menu
    critical_actions: []

  # ════════════════════════════════════════════════════════════════════
  # MEMORY - Persistence (Optional)
  # ════════════════════════════════════════════════════════════════════
  memory:
    enabled: false
    files:
      - context.md
      - decisions.md
      - learnings.md
---

EOF

# Extract body content (everything after the frontmatter)
BODY_START=$(grep -n "^---$" "$AGENT_PATH" | tail -1 | cut -d: -f1)
if [ -n "$BODY_START" ]; then
    tail -n +$((BODY_START + 1)) "$AGENT_PATH" >> "$TEMP_FILE"
fi

echo -e "${GREEN}✓${NC} v2.0 format generated"
echo ""

# ════════════════════════════════════════════════════════════════════
# STEP 4: Show Diff
# ════════════════════════════════════════════════════════════════════
echo "═══ Step 4: Changes Preview ═══"
echo ""
if command -v diff &> /dev/null; then
    echo -e "${BLUE}--- Original (v1.x)${NC}"
    echo -e "${GREEN}+++ New (v2.0)${NC}"
    echo ""
    diff -u "$AGENT_PATH" "$TEMP_FILE" | head -100 || true
    echo ""
    echo "(showing first 100 lines of diff)"
else
    echo "Diff not available. New content preview:"
    head -50 "$TEMP_FILE"
fi
echo ""

# ════════════════════════════════════════════════════════════════════
# STEP 5: Apply Changes
# ════════════════════════════════════════════════════════════════════
if [ "$DRY_RUN" = true ]; then
    echo "═══ Step 5: Apply Changes (DRY RUN) ═══"
    echo -e "${CYAN}[DRY RUN]${NC} Would replace $AGENT_PATH with v2.0 format"
    echo ""
    echo "To apply changes, run without --dry-run:"
    echo "  ./migrate-to-v2.sh $AGENT_NAME"
    rm "$TEMP_FILE"
else
    echo "═══ Step 5: Apply Changes ═══"
    read -p "Apply v2.0 migration? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv "$TEMP_FILE" "$AGENT_PATH"
        echo -e "${GREEN}✓${NC} Migration applied"
        echo ""
        echo -e "${YELLOW}IMPORTANT:${NC} The migration created a template with TODO items."
        echo "Please review and complete the following manually:"
        echo "  1. Add proper title in metadata"
        echo "  2. Fill in persona.role and persona.identity"
        echo "  3. Add menu items with fuzzy triggers"
        echo "  4. Configure knowledge auto_load/on_demand"
        echo "  5. Set up activation steps"
        echo ""
        echo "Backup saved at: $BACKUP_PATH"
    else
        echo "Migration cancelled"
        rm "$TEMP_FILE"
    fi
fi

echo ""

# ════════════════════════════════════════════════════════════════════
# STEP 6: Create Workflows Directory
# ════════════════════════════════════════════════════════════════════
WORKFLOW_DIR="$BASE_DIR/.microai/agents/$AGENT_NAME/workflows"
if [ ! -d "$WORKFLOW_DIR" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}[DRY RUN]${NC} Would create: $WORKFLOW_DIR"
    else
        mkdir -p "$WORKFLOW_DIR"
        echo -e "${GREEN}✓${NC} Created workflows directory"
    fi
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  MIGRATION COMPLETE                                            ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  Next steps:                                                    ║"
echo "║    1. Review and fill TODO items in agent.md                   ║"
echo "║    2. Create workflow YAML files in workflows/                 ║"
echo "║    3. Run validation: ./validate-agent-v2.sh $AGENT_NAME       ║"
echo "║    4. Test: /microai:$AGENT_NAME                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
