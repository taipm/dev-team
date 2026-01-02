#!/bin/bash
# map-knowledge-usage.sh - Map which agents use which knowledge files
# Part of Knowledge Forge initiative

set -e

MICROAI_DIR="${1:-.microai}"
OUTPUT_DIR="${2:-/tmp/knowledge-audit}"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=============================================="
echo "   KNOWLEDGE USAGE MAPPING"
echo "=============================================="
echo ""

mkdir -p "$OUTPUT_DIR"

# Find all agent.md files
echo -e "${BLUE}Finding agent definitions...${NC}"
find "$MICROAI_DIR" -name "agent.md" -type f > "$OUTPUT_DIR/agents.txt"
AGENT_COUNT=$(wc -l < "$OUTPUT_DIR/agents.txt" | tr -d ' ')
echo "  Found: $AGENT_COUNT agent.md files"

# Create usage map
echo ""
echo -e "${BLUE}Analyzing knowledge references in agents...${NC}"
echo ""

: > "$OUTPUT_DIR/knowledge-usage-map.txt"
: > "$OUTPUT_DIR/knowledge-references.txt"

while IFS= read -r agent_file; do
    agent_name=$(dirname "$agent_file" | xargs basename)
    agent_dir=$(dirname "$agent_file")

    echo -e "${GREEN}Agent: $agent_name${NC}" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
    echo "  Path: $agent_file" >> "$OUTPUT_DIR/knowledge-usage-map.txt"

    # Check for knowledge field in frontmatter
    if grep -q "^knowledge:" "$agent_file" 2>/dev/null; then
        echo "  Has knowledge field: YES" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
        # Extract knowledge paths
        awk '/^knowledge:/,/^[a-z]/' "$agent_file" | grep -E "^\s*-|path:" | head -20 >> "$OUTPUT_DIR/knowledge-usage-map.txt"
    else
        echo "  Has knowledge field: NO" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
    fi

    # Check for local knowledge directory
    if [ -d "$agent_dir/knowledge" ]; then
        local_count=$(find "$agent_dir/knowledge" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "  Local knowledge files: $local_count" >> "$OUTPUT_DIR/knowledge-usage-map.txt"

        # List local knowledge files
        find "$agent_dir/knowledge" -name "*.md" -type f 2>/dev/null | while read -r kf; do
            basename "$kf" >> "$OUTPUT_DIR/knowledge-references.txt"
            echo "    - $(basename "$kf")" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
        done
    else
        echo "  Local knowledge files: 0" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
    fi

    echo "" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
done < "$OUTPUT_DIR/agents.txt"

# Analyze team knowledge
echo ""
echo -e "${BLUE}Analyzing team knowledge...${NC}"
echo ""

echo "=== TEAM KNOWLEDGE ===" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
echo "" >> "$OUTPUT_DIR/knowledge-usage-map.txt"

find "$MICROAI_DIR/teams" -type d -name "knowledge" 2>/dev/null | while read -r team_knowledge; do
    team_path=$(dirname "$team_knowledge")
    team_name=$(basename "$team_path")

    echo -e "${GREEN}Team: $team_name${NC}" >> "$OUTPUT_DIR/knowledge-usage-map.txt"

    # Check for shared
    if [ -d "$team_knowledge/shared" ]; then
        shared_count=$(find "$team_knowledge/shared" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        echo "  Shared knowledge: $shared_count files" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
    fi

    # Count total
    total_count=$(find "$team_knowledge" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "  Total knowledge: $total_count files" >> "$OUTPUT_DIR/knowledge-usage-map.txt"

    # List subdirs
    for subdir in "$team_knowledge"/*/; do
        if [ -d "$subdir" ]; then
            subname=$(basename "$subdir")
            subcount=$(find "$subdir" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
            echo "    $subname/: $subcount files" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
        fi
    done

    echo "" >> "$OUTPUT_DIR/knowledge-usage-map.txt"
done

# Summary
echo ""
echo -e "${BLUE}Generating summary...${NC}"

{
    echo ""
    echo "=== KNOWLEDGE FILE POPULARITY ==="
    echo ""
    sort "$OUTPUT_DIR/knowledge-references.txt" | uniq -c | sort -rn | head -20
} >> "$OUTPUT_DIR/knowledge-usage-map.txt"

echo ""
echo "=============================================="
echo "   MAPPING COMPLETE"
echo "=============================================="
echo ""
echo "  Report saved to: $OUTPUT_DIR/knowledge-usage-map.txt"
echo ""

# Display summary
echo -e "${YELLOW}Top 10 Most Common Knowledge Files:${NC}"
sort "$OUTPUT_DIR/knowledge-references.txt" | uniq -c | sort -rn | head -10
