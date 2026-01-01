#!/bin/bash
# ============================================================
# Agent Metadata Migration Script v1.0
# ============================================================
# Cập nhật agents để tuân thủ 10-agent-metadata-spec.md
#
# Usage:
#   ./migrate-agent-metadata.sh --scan           # Scan và report issues
#   ./migrate-agent-metadata.sh --fix <agent>    # Fix một agent cụ thể
#   ./migrate-agent-metadata.sh --fix-all        # Fix tất cả agents
#   ./migrate-agent-metadata.sh --dry-run        # Preview changes
#
# ============================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Default paths
AGENTS_DIR=".microai/agents"
CLAUDE_AGENTS_DIR=".claude/agents"

# Counters
TOTAL=0
MISSING_LANGUAGE=0
MISSING_COLOR=0
MISSING_ICON=0
ISSUES_FOUND=0

# ============================================================
# Helper Functions
# ============================================================

print_header() {
    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║          AGENT METADATA MIGRATION TOOL v1.0                   ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --scan              Scan all agents and report issues"
    echo "  --fix <agent-name>  Fix metadata for specific agent"
    echo "  --fix-all           Fix all agents with issues"
    echo "  --dry-run           Preview changes without applying"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --scan"
    echo "  $0 --fix father-agent"
    echo "  $0 --fix-all --dry-run"
}

# Check if field exists in frontmatter
check_field() {
    local file=$1
    local field=$2
    grep -q "^${field}:" "$file" 2>/dev/null
}

# Get field value from frontmatter
get_field() {
    local file=$1
    local field=$2
    grep "^${field}:" "$file" 2>/dev/null | head -1 | sed "s/^${field}:[[:space:]]*//"
}

# Suggest color based on agent name/type
suggest_color() {
    local name=$1
    case "$name" in
        *father*|*meta*|*orchestrat*|*ab-test*)
            echo "purple"
            ;;
        *dev*|*go-dev*|*npm*|*code*)
            echo "red"
            ;;
        *test*|*qa*|*validation*)
            echo "green"
            ;;
        *config*|*setup*|*ollama*|*production*)
            echo "orange"
            ;;
        *explore*|*analysis*|*kanban*|*mine*)
            echo "blue"
            ;;
        *route*|*gateway*|*comm*)
            echo "cyan"
            ;;
        *doc*|*write*)
            echo "yellow"
            ;;
        *security*|*hack*|*white*)
            echo "red"
            ;;
        *)
            echo "blue"
            ;;
    esac
}

# Suggest icon based on agent name/type
suggest_icon() {
    local name=$1
    case "$name" in
        *father*)
            echo "👨‍👦"
            ;;
        *go-dev*|*dev*)
            echo "🔧"
            ;;
        *test*|*qa*)
            echo "🧪"
            ;;
        *npm*)
            echo "📦"
            ;;
        *ollama*)
            echo "🦙"
            ;;
        *deep-question*|*thinking*)
            echo "🔮"
            ;;
        *security*|*hack*)
            echo "🔒"
            ;;
        *config*)
            echo "⚙️"
            ;;
        *route*|*gateway*)
            echo "🌐"
            ;;
        *doc*)
            echo "📝"
            ;;
        *architect*)
            echo "🏗️"
            ;;
        *explore*|*mine*)
            echo "🔍"
            ;;
        *production*|*deploy*)
            echo "🚀"
            ;;
        *kanban*|*task*)
            echo "📋"
            ;;
        *github*)
            echo "🐙"
            ;;
        *)
            echo "🤖"
            ;;
    esac
}

# ============================================================
# Scan Functions
# ============================================================

scan_agent() {
    local file=$1
    local name=$(get_field "$file" "name")
    local issues=""
    local has_issues=0

    ((TOTAL++))

    # Check required fields
    if ! check_field "$file" "language"; then
        issues="${issues}  ❌ Missing: language\n"
        ((MISSING_LANGUAGE++))
        has_issues=1
    fi

    # Check style fields
    if ! check_field "$file" "color"; then
        issues="${issues}  ⚠️  Missing: color (suggested: $(suggest_color "$name"))\n"
        ((MISSING_COLOR++))
        has_issues=1
    fi

    if ! check_field "$file" "icon"; then
        issues="${issues}  ⚠️  Missing: icon (suggested: $(suggest_icon "$name"))\n"
        ((MISSING_ICON++))
        has_issues=1
    fi

    # Check description format
    local desc=$(get_field "$file" "description")
    if [[ "$desc" != "|" ]] && [[ -n "$desc" ]]; then
        # Inline description, should be multi-line
        if ! grep -A1 "^description:" "$file" | grep -q "|"; then
            issues="${issues}  ⚠️  Description should use multi-line format (|)\n"
            has_issues=1
        fi
    fi

    if [[ $has_issues -eq 1 ]]; then
        ((ISSUES_FOUND++))
        echo -e "${YELLOW}📁 $name${NC} ($file)"
        echo -e "$issues"
    fi
}

scan_all() {
    print_header
    echo -e "${BLUE}Scanning agents for metadata issues...${NC}"
    echo ""

    # Scan .microai/agents
    if [[ -d "$AGENTS_DIR" ]]; then
        for agent_dir in "$AGENTS_DIR"/*/; do
            if [[ -f "${agent_dir}agent.md" ]]; then
                scan_agent "${agent_dir}agent.md"
            fi
        done

        # Scan nested agents (teams)
        for agent_file in $(find "$AGENTS_DIR" -name "agent.md" -o -name "*-agent.md" 2>/dev/null); do
            if [[ -f "$agent_file" ]]; then
                scan_agent "$agent_file"
            fi
        done
    fi

    # Scan .claude/agents
    if [[ -d "$CLAUDE_AGENTS_DIR" ]]; then
        for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
            if [[ -f "$agent_file" ]]; then
                scan_agent "$agent_file"
            fi
        done
    fi

    # Summary
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}                         SUMMARY                                ${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Total agents scanned:     ${BLUE}$TOTAL${NC}"
    echo -e "Agents with issues:       ${YELLOW}$ISSUES_FOUND${NC}"
    echo ""
    echo -e "Missing fields breakdown:"
    echo -e "  ❌ language (required): ${RED}$MISSING_LANGUAGE${NC}"
    echo -e "  ⚠️  color (style):       ${YELLOW}$MISSING_COLOR${NC}"
    echo -e "  ⚠️  icon (style):        ${YELLOW}$MISSING_ICON${NC}"
    echo ""

    if [[ $ISSUES_FOUND -gt 0 ]]; then
        echo -e "${YELLOW}Run with --fix-all to fix all issues${NC}"
    else
        echo -e "${GREEN}✅ All agents comply with metadata spec!${NC}"
    fi
}

# ============================================================
# Fix Functions
# ============================================================

fix_agent() {
    local file=$1
    local dry_run=$2
    local name=$(get_field "$file" "name")
    local changes=""
    local has_changes=0

    echo -e "${BLUE}Processing: $name${NC} ($file)"

    # Backup original
    if [[ "$dry_run" != "true" ]]; then
        cp "$file" "${file}.bak"
    fi

    # Fix missing language
    if ! check_field "$file" "language"; then
        changes="${changes}  + Adding: language: vi\n"
        has_changes=1
        if [[ "$dry_run" != "true" ]]; then
            # Add language after tools section
            sed -i '' '/^tools:/,/^[a-z]/ {
                /^[a-z]/ {
                    /^tools:/!i\
language: vi
                }
            }' "$file" 2>/dev/null || \
            sed -i '/^tools:/,/^[a-z]/ {
                /^[a-z]/ {
                    /^tools:/!i\
language: vi
                }
            }' "$file"
        fi
    fi

    # Fix missing color
    if ! check_field "$file" "color"; then
        local suggested_color=$(suggest_color "$name")
        changes="${changes}  + Adding: color: $suggested_color\n"
        has_changes=1
        if [[ "$dry_run" != "true" ]]; then
            # Add color after model
            sed -i '' "/^model:/a\\
color: $suggested_color" "$file" 2>/dev/null || \
            sed -i "/^model:/a\\
color: $suggested_color" "$file"
        fi
    fi

    # Fix missing icon
    if ! check_field "$file" "icon"; then
        local suggested_icon=$(suggest_icon "$name")
        changes="${changes}  + Adding: icon: \"$suggested_icon\"\n"
        has_changes=1
        if [[ "$dry_run" != "true" ]]; then
            # Add icon after color (or after model if no color)
            if check_field "$file" "color"; then
                sed -i '' "/^color:/a\\
icon: \"$suggested_icon\"" "$file" 2>/dev/null || \
                sed -i "/^color:/a\\
icon: \"$suggested_icon\"" "$file"
            else
                sed -i '' "/^model:/a\\
icon: \"$suggested_icon\"" "$file" 2>/dev/null || \
                sed -i "/^model:/a\\
icon: \"$suggested_icon\"" "$file"
            fi
        fi
    fi

    if [[ $has_changes -eq 1 ]]; then
        echo -e "$changes"
        if [[ "$dry_run" == "true" ]]; then
            echo -e "  ${YELLOW}(dry-run - no changes applied)${NC}"
        else
            echo -e "  ${GREEN}✅ Changes applied${NC}"
        fi
    else
        echo -e "  ${GREEN}✅ Already compliant${NC}"
    fi
    echo ""
}

fix_single() {
    local agent_name=$1
    local dry_run=$2

    print_header
    echo -e "${BLUE}Fixing agent: $agent_name${NC}"
    echo ""

    # Find agent file
    local found=0

    # Check .microai/agents/{name}/agent.md
    if [[ -f "$AGENTS_DIR/$agent_name/agent.md" ]]; then
        fix_agent "$AGENTS_DIR/$agent_name/agent.md" "$dry_run"
        found=1
    fi

    # Check .claude/agents/{name}.md
    if [[ -f "$CLAUDE_AGENTS_DIR/$agent_name.md" ]]; then
        fix_agent "$CLAUDE_AGENTS_DIR/$agent_name.md" "$dry_run"
        found=1
    fi

    if [[ $found -eq 0 ]]; then
        echo -e "${RED}Agent not found: $agent_name${NC}"
        echo "Searched in:"
        echo "  - $AGENTS_DIR/$agent_name/agent.md"
        echo "  - $CLAUDE_AGENTS_DIR/$agent_name.md"
        exit 1
    fi
}

fix_all() {
    local dry_run=$1

    print_header
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}DRY RUN MODE - No changes will be applied${NC}"
    else
        echo -e "${BLUE}Fixing all agents with metadata issues...${NC}"
    fi
    echo ""

    local fixed=0

    # Fix .microai/agents
    if [[ -d "$AGENTS_DIR" ]]; then
        for agent_dir in "$AGENTS_DIR"/*/; do
            if [[ -f "${agent_dir}agent.md" ]]; then
                fix_agent "${agent_dir}agent.md" "$dry_run"
                ((fixed++))
            fi
        done

        # Fix nested agents
        for agent_file in $(find "$AGENTS_DIR" -name "agent.md" -o -name "*-agent.md" 2>/dev/null | sort -u); do
            if [[ -f "$agent_file" ]]; then
                fix_agent "$agent_file" "$dry_run"
                ((fixed++))
            fi
        done
    fi

    # Fix .claude/agents
    if [[ -d "$CLAUDE_AGENTS_DIR" ]]; then
        for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
            if [[ -f "$agent_file" ]]; then
                fix_agent "$agent_file" "$dry_run"
                ((fixed++))
            fi
        done
    fi

    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "Processed: ${BLUE}$fixed${NC} agents"
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${YELLOW}Run without --dry-run to apply changes${NC}"
    else
        echo -e "${GREEN}✅ Migration complete!${NC}"
        echo -e "Backup files created with .bak extension"
    fi
}

# ============================================================
# Main
# ============================================================

case "$1" in
    --scan)
        scan_all
        ;;
    --fix)
        if [[ -z "$2" ]]; then
            echo -e "${RED}Error: Agent name required${NC}"
            echo "Usage: $0 --fix <agent-name>"
            exit 1
        fi
        dry_run="false"
        if [[ "$3" == "--dry-run" ]]; then
            dry_run="true"
        fi
        fix_single "$2" "$dry_run"
        ;;
    --fix-all)
        dry_run="false"
        if [[ "$2" == "--dry-run" ]]; then
            dry_run="true"
        fi
        fix_all "$dry_run"
        ;;
    --dry-run)
        if [[ "$2" == "--fix-all" ]]; then
            fix_all "true"
        else
            echo -e "${RED}Error: --dry-run must be used with --fix or --fix-all${NC}"
            exit 1
        fi
        ;;
    --help|-h|"")
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        print_usage
        exit 1
        ;;
esac
