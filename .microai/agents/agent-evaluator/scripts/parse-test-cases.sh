#!/usr/bin/env bash
#
# parse-test-cases.sh - Parse test cases from .md files
#
# Usage:
#   parse-test-cases.sh --tier easy|medium|hard|expert|ambiguity|all
#   parse-test-cases.sh --test E-1
#
# Output: JSON array of test cases

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_CASES_DIR="$(dirname "$SCRIPT_DIR")/test-cases"

TIER=""
TEST_ID=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tier) TIER="$2"; shift 2 ;;
        --test) TEST_ID="$2"; shift 2 ;;
        *) shift ;;
    esac
done

# Function to parse a single test file
parse_test_file() {
    local file="$1"
    local in_frontmatter=false
    local in_prompt=false
    local id="" name="" category="" difficulty="" points=""
    local keywords="" prompt=""

    while IFS= read -r line; do
        # Frontmatter detection
        if [[ "$line" == "---" ]]; then
            if [[ "$in_frontmatter" == "false" ]]; then
                in_frontmatter=true
                continue
            else
                in_frontmatter=false
                continue
            fi
        fi

        # Parse frontmatter
        if [[ "$in_frontmatter" == "true" ]]; then
            case "$line" in
                id:*) id=$(echo "$line" | sed 's/id: *//' | tr -d '"') ;;
                name:*) name=$(echo "$line" | sed 's/name: *//' | tr -d '"') ;;
                category:*) category=$(echo "$line" | sed 's/category: *//' | tr -d '"') ;;
                difficulty:*) difficulty=$(echo "$line" | sed 's/difficulty: *//' | tr -d '"') ;;
                points:*) points=$(echo "$line" | sed 's/points: *//' | tr -d '"') ;;
            esac

            # Keywords as array
            if [[ "$line" == "keywords:" ]]; then
                keywords=""
            elif [[ "$line" =~ ^[[:space:]]*-[[:space:]]+ ]] && [[ -n "$keywords" || "$line" =~ keywords ]]; then
                kw=$(echo "$line" | sed 's/^[[:space:]]*- *//' | tr -d '"')
                if [[ -n "$keywords" ]]; then
                    keywords="$keywords,$kw"
                else
                    keywords="$kw"
                fi
            fi
        fi

        # Prompt detection
        if [[ "$line" == "<prompt>" ]]; then
            in_prompt=true
            prompt=""
            continue
        fi
        if [[ "$line" == "</prompt>" ]]; then
            in_prompt=false
            continue
        fi
        if [[ "$in_prompt" == "true" ]]; then
            if [[ -n "$prompt" ]]; then
                prompt="$prompt\\n$line"
            else
                prompt="$line"
            fi
        fi
    done < "$file"

    # Output JSON
    if [[ -n "$id" && -n "$prompt" ]]; then
        echo "{\"id\":\"$id\",\"name\":\"$name\",\"category\":\"$category\",\"difficulty\":$difficulty,\"points\":$points,\"keywords\":\"$keywords\",\"prompt\":\"$prompt\"}"
    fi
}

# Function to get tier directory
get_tier_dir() {
    local tier="$1"
    case "$tier" in
        easy) echo "$TEST_CASES_DIR/easy" ;;
        medium) echo "$TEST_CASES_DIR/medium" ;;
        hard) echo "$TEST_CASES_DIR/hard" ;;
        expert) echo "$TEST_CASES_DIR/expert" ;;
        ambiguity|ambig) echo "$TEST_CASES_DIR/ambiguity" ;;
        *) echo "" ;;
    esac
}

# Main logic
if [[ -n "$TEST_ID" ]]; then
    # Find specific test
    found=""
    for tier_dir in "$TEST_CASES_DIR"/*/; do
        for file in "$tier_dir"*.md; do
            [[ -f "$file" ]] || continue
            [[ "$(basename "$file")" == "_index.md" ]] && continue

            if grep -q "id: $TEST_ID" "$file" 2>/dev/null; then
                parse_test_file "$file"
                exit 0
            fi
        done
    done
    echo "Test not found: $TEST_ID" >&2
    exit 1

elif [[ -n "$TIER" ]]; then
    # Get all tests in tier(s)
    echo "["

    if [[ "$TIER" == "all" ]]; then
        tiers=("easy" "medium" "hard" "expert" "ambiguity")
    else
        tiers=("$TIER")
    fi

    first=true
    for t in "${tiers[@]}"; do
        tier_dir=$(get_tier_dir "$t")
        [[ -d "$tier_dir" ]] || continue

        for file in "$tier_dir"/*.md; do
            [[ -f "$file" ]] || continue
            [[ "$(basename "$file")" == "_index.md" ]] && continue

            result=$(parse_test_file "$file")
            if [[ -n "$result" ]]; then
                if [[ "$first" == "true" ]]; then
                    first=false
                else
                    echo ","
                fi
                echo "$result"
            fi
        done
    done

    echo "]"
else
    echo "Usage: parse-test-cases.sh --tier TIER | --test TEST_ID" >&2
    exit 1
fi
