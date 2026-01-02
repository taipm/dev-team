#!/bin/bash
# audit-knowledge.sh - Audit knowledge files for duplicates and issues
# Part of Knowledge Forge initiative

set -e

MICROAI_DIR="${1:-.microai}"
OUTPUT_DIR="${2:-/tmp/knowledge-audit}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=============================================="
echo "   KNOWLEDGE AUDIT - Finding Duplicates"
echo "=============================================="
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Step 1: Find all knowledge files
echo -e "${BLUE}Step 1: Finding all knowledge files...${NC}"
find "$MICROAI_DIR" -type f -name "*.md" -path "*knowledge*" > "$OUTPUT_DIR/all-files.txt"
TOTAL_FILES=$(wc -l < "$OUTPUT_DIR/all-files.txt" | tr -d ' ')
echo "  Found: $TOTAL_FILES knowledge .md files"

# Step 2: Find all knowledge directories
echo ""
echo -e "${BLUE}Step 2: Finding knowledge directories...${NC}"
find "$MICROAI_DIR" -type d -name "knowledge" > "$OUTPUT_DIR/all-dirs.txt"
TOTAL_DIRS=$(wc -l < "$OUTPUT_DIR/all-dirs.txt" | tr -d ' ')
echo "  Found: $TOTAL_DIRS knowledge directories"

# Step 3: Find exact duplicates by content hash
echo ""
echo -e "${BLUE}Step 3: Finding exact duplicates (by content hash)...${NC}"
: > "$OUTPUT_DIR/hashes.txt"
while IFS= read -r file; do
    if [ -f "$file" ]; then
        hash=$(md5 -q "$file" 2>/dev/null || md5sum "$file" | cut -d' ' -f1)
        echo "$hash $file" >> "$OUTPUT_DIR/hashes.txt"
    fi
done < "$OUTPUT_DIR/all-files.txt"

# Group by hash (macOS compatible)
cut -d' ' -f1 "$OUTPUT_DIR/hashes.txt" | sort | uniq -d > "$OUTPUT_DIR/duplicate-hashes.txt"
if [ -s "$OUTPUT_DIR/duplicate-hashes.txt" ]; then
    echo -e "  ${RED}EXACT DUPLICATES FOUND:${NC}"
    while IFS= read -r hash_only; do
        echo ""
        echo -e "  ${YELLOW}Hash: $hash_only${NC}"
        grep "^$hash_only" "$OUTPUT_DIR/hashes.txt" | cut -d' ' -f2-
    done < "$OUTPUT_DIR/duplicate-hashes.txt"
else
    echo -e "  ${GREEN}No exact duplicates found${NC}"
fi

# Step 4: Find files with same name in different locations
echo ""
echo -e "${BLUE}Step 4: Finding same-name files in different locations...${NC}"
: > "$OUTPUT_DIR/same-names.txt"
while IFS= read -r file; do
    basename "$file" >> "$OUTPUT_DIR/same-names.txt"
done < "$OUTPUT_DIR/all-files.txt"

sort "$OUTPUT_DIR/same-names.txt" | uniq -c | sort -rn | while read -r count name; do
    if [ "$count" -gt 1 ]; then
        echo ""
        echo -e "  ${YELLOW}\"$name\" appears $count times:${NC}"
        grep "/$name$" "$OUTPUT_DIR/all-files.txt" | sed 's/^/    /'
    fi
done > "$OUTPUT_DIR/duplicate-names-report.txt"

if [ -s "$OUTPUT_DIR/duplicate-names-report.txt" ]; then
    echo -e "  ${RED}SAME-NAME FILES FOUND:${NC}"
    cat "$OUTPUT_DIR/duplicate-names-report.txt"
else
    echo -e "  ${GREEN}No same-name files in different locations${NC}"
fi

# Step 5: Find knowledge-index.yaml files
echo ""
echo -e "${BLUE}Step 5: Finding knowledge-index.yaml files...${NC}"
find "$MICROAI_DIR" -type f -name "knowledge-index.yaml" > "$OUTPUT_DIR/index-files.txt"
INDEX_COUNT=$(wc -l < "$OUTPUT_DIR/index-files.txt" | tr -d ' ')
echo "  Found: $INDEX_COUNT knowledge-index.yaml files"

# Step 6: Check registry.yaml
echo ""
echo -e "${BLUE}Step 6: Checking registry.yaml...${NC}"
REGISTRY="$MICROAI_DIR/knowledge/shared/registry.yaml"
if [ -f "$REGISTRY" ]; then
    echo "  Registry exists at: $REGISTRY"
    # Extract declared paths and check if they exist
    echo "  Checking declared files..."
    grep "path:" "$REGISTRY" 2>/dev/null | while read -r line; do
        path=$(echo "$line" | sed 's/.*path: *//' | tr -d '"' | tr -d "'")
        full_path="$MICROAI_DIR/knowledge/shared/$path"
        if [ -f "$full_path" ]; then
            echo -e "    ${GREEN}EXISTS:${NC} $path"
        else
            echo -e "    ${RED}MISSING:${NC} $path"
        fi
    done
else
    echo -e "  ${YELLOW}No registry.yaml found${NC}"
fi

# Step 7: Analyze file sizes
echo ""
echo -e "${BLUE}Step 7: Analyzing file sizes...${NC}"
: > "$OUTPUT_DIR/sizes.txt"
while IFS= read -r file; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file" | tr -d ' ')
        lines=$(wc -l < "$file" | tr -d ' ')
        echo "$size $lines $file" >> "$OUTPUT_DIR/sizes.txt"
    fi
done < "$OUTPUT_DIR/all-files.txt"

echo "  Largest files:"
sort -rn "$OUTPUT_DIR/sizes.txt" | head -10 | while read -r size lines file; do
    echo "    $(printf '%6d' "$size") bytes, $(printf '%4d' "$lines") lines: $(basename "$file")"
done

echo ""
echo "  Smallest files (potential stubs):"
sort -n "$OUTPUT_DIR/sizes.txt" | head -5 | while read -r size lines file; do
    echo "    $(printf '%6d' "$size") bytes, $(printf '%4d' "$lines") lines: $(basename "$file")"
done

# Step 8: Summary
echo ""
echo "=============================================="
echo "   AUDIT SUMMARY"
echo "=============================================="
echo ""
echo "  Total knowledge files:     $TOTAL_FILES"
echo "  Total knowledge dirs:      $TOTAL_DIRS"
echo "  Index files found:         $INDEX_COUNT"

EXACT_DUPES=$(cut -d' ' -f1 "$OUTPUT_DIR/hashes.txt" | sort | uniq -d | wc -l | tr -d ' ')
echo "  Exact duplicate sets:      $EXACT_DUPES"

NAME_DUPES=$(sort "$OUTPUT_DIR/same-names.txt" | uniq -d | wc -l | tr -d ' ')
echo "  Same-name file sets:       $NAME_DUPES"

echo ""
echo "  Detailed reports saved to: $OUTPUT_DIR/"
echo "    - all-files.txt"
echo "    - all-dirs.txt"
echo "    - hashes.txt"
echo "    - sizes.txt"
echo "    - duplicate-names-report.txt"
echo ""
