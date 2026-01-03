#!/bin/bash
# =============================================================================
# Rewrite Text for Natural Speech
# =============================================================================
# Viết lại văn bản để đọc tự nhiên hơn:
# - Chia câu dài thành câu ngắn
# - Xử lý ngoặc đơn, ngoặc kép
# - Chuyển passive → active (một số trường hợp)
# - Thêm từ nối tự nhiên
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default values
INPUT=""
OUTPUT=""
VERBOSE=false
MAX_SENTENCE_LENGTH=100  # Characters per sentence

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Rewrite Vietnamese text for natural speech.

Options:
    --input FILE          Input text file
    --text TEXT           Input text string
    --output FILE         Output file (default: stdout)
    --max-length N        Max characters per sentence (default: 100)
    --verbose             Show rewriting steps
    -h, --help            Show this help

Examples:
    $(basename "$0") --input article.txt --output speech-ready.txt
    $(basename "$0") --text "Câu rất dài với nhiều mệnh đề, bao gồm A, B, C và D."
EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --input)
            INPUT="$2"
            shift 2
            ;;
        --text)
            TEXT="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --max-length)
            MAX_SENTENCE_LENGTH="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}" >&2
            exit 1
            ;;
    esac
done

# Get input text
get_input() {
    if [[ -n "${TEXT:-}" ]]; then
        echo "$TEXT"
    elif [[ -n "$INPUT" ]]; then
        cat "$INPUT"
    else
        cat  # Read from stdin
    fi
}

# Rewrite text for speech
rewrite_for_speech() {
    local text="$1"

    # Rule 1: Handle parentheses - convert to natural speech
    # "Python (ngôn ngữ lập trình)" → "Python, một ngôn ngữ lập trình,"
    text=$(echo "$text" | sed -E 's/([A-Za-zÀ-ỹ]+) \(([^)]+)\)/\1, tức là \2,/g')

    # Rule 2: Handle quotes for emphasis - remove all quote types
    text=$(echo "$text" | sed 's/["""]//g')
    text=$(echo "$text" | sed "s/[''']//g")

    # Rule 3: Handle bullet points and lists
    text=$(echo "$text" | sed 's/^- /Thứ nhất, /; s/^• /Tiếp theo, /')
    text=$(echo "$text" | sed 's/^[0-9]\+\. /Điểm tiếp theo, /g')

    # Rule 4: Break long enumerations
    # "A, B, C, D và E" → "A, B, C. Sau đó là D và E"
    # This is complex, simplified version:
    text=$(echo "$text" | sed -E 's/, ([^,]+), ([^,]+), ([^,]+) và /, \1, \2. Cùng với \3 và /g')

    # Rule 5: Handle semicolons - often better as period
    text=$(echo "$text" | sed 's/;/. /g')

    # Rule 6: Handle colons - add pause
    text=$(echo "$text" | sed 's/: /, đó là: /g')

    # Rule 7: Replace some connectors for variety
    # Avoid repetitive "và"
    text=$(echo "$text" | awk '
    BEGIN { count = 0 }
    {
        while (match($0, / và /)) {
            count++
            if (count % 3 == 0) {
                sub(/ và /, " cùng với ")
            } else if (count % 5 == 0) {
                sub(/ và /, " đồng thời ")
            } else {
                sub(/ và /, " & ")  # Temporary marker
            }
        }
        gsub(/ & /, " và ")
        print
    }')

    # Rule 8: Handle "tuy nhiên", "nhưng" - add pause before
    text=$(echo "$text" | sed 's/\. Tuy nhiên/. ... Tuy nhiên/g')
    text=$(echo "$text" | sed 's/, nhưng/. Nhưng/g')

    # Rule 9: Handle complex sentences with "mặc dù...nhưng"
    text=$(echo "$text" | sed 's/[Mm]ặc dù \([^,]*\), nhưng/\1. Tuy nhiên,/g')

    # Rule 10: Break at "do đó", "vì vậy", "cho nên"
    text=$(echo "$text" | sed 's/, do đó/. Do đó/g')
    text=$(echo "$text" | sed 's/, vì vậy/. Vì vậy/g')
    text=$(echo "$text" | sed 's/, cho nên/. Cho nên/g')

    # Rule 11: Handle "được cho rằng", "được biết đến"
    text=$(echo "$text" | sed 's/[Đđ]ược cho rằng/Người ta cho rằng/g')
    text=$(echo "$text" | sed 's/[Đđ]ược biết đến như/nổi tiếng như/g')

    # Rule 12: Handle numbers in context
    # "có 1000 người" → "có một nghìn người"
    # This should be handled by normalize.sh, just ensure spacing
    text=$(echo "$text" | sed -E 's/([0-9]+)([a-zA-ZÀ-ỹ])/\1 \2/g')

    # Rule 13: Handle acronyms - spell out or add context
    # Common tech terms
    text=$(echo "$text" | sed 's/\bAI\b/A I/g')  # Spell out
    text=$(echo "$text" | sed 's/\bAPI\b/A P I/g')
    text=$(echo "$text" | sed 's/\bURL\b/U R L/g')
    text=$(echo "$text" | sed 's/\bUSB\b/U S B/g')
    text=$(echo "$text" | sed 's/\bCPU\b/C P U/g')
    text=$(echo "$text" | sed 's/\bGPU\b/G P U/g')
    text=$(echo "$text" | sed 's/\bRAM\b/R A M/g')
    text=$(echo "$text" | sed 's/\bSSD\b/S S D/g')
    text=$(echo "$text" | sed 's/\bHDD\b/H D D/g')
    text=$(echo "$text" | sed 's/\bPDF\b/P D F/g')
    text=$(echo "$text" | sed 's/\bHTML\b/H T M L/g')
    text=$(echo "$text" | sed 's/\bCSS\b/C S S/g')
    text=$(echo "$text" | sed 's/\bSQL\b/S Q L/g')

    # Rule 14: Handle website mentions
    text=$(echo "$text" | sed -E 's/www\.([a-zA-Z0-9]+)\.com/trang web \1 chấm com/g')
    text=$(echo "$text" | sed -E 's/www\.([a-zA-Z0-9]+)\.vn/trang web \1 chấm vê en/g')

    # Rule 15: Clean up multiple spaces and punctuation
    text=$(echo "$text" | sed 's/\.\.\./. /g')  # Ellipsis to single period
    text=$(echo "$text" | sed 's/  */ /g')      # Multiple spaces to single
    text=$(echo "$text" | sed 's/\. \././g')    # ". ." to "."
    text=$(echo "$text" | sed 's/,,/,/g')       # Double comma

    # Rule 16: Ensure proper sentence ending
    text=$(echo "$text" | sed 's/[[:space:]]*$//')  # Trim trailing whitespace
    if [[ ! "$text" =~ [.!?]$ ]]; then
        text="${text}."
    fi

    echo "$text"
}

# Split long sentences
split_long_sentences() {
    local text="$1"
    local max_len="$MAX_SENTENCE_LENGTH"

    # Process each sentence
    echo "$text" | awk -v max="$max_len" '
    {
        # Split by period
        n = split($0, sentences, /\. /)
        for (i = 1; i <= n; i++) {
            sent = sentences[i]
            # If sentence is too long, try to split at comma
            if (length(sent) > max) {
                m = split(sent, parts, /, /)
                current = ""
                for (j = 1; j <= m; j++) {
                    if (length(current) + length(parts[j]) < max) {
                        if (current == "") {
                            current = parts[j]
                        } else {
                            current = current ", " parts[j]
                        }
                    } else {
                        if (current != "") {
                            printf "%s. ", current
                        }
                        current = parts[j]
                    }
                }
                if (current != "") {
                    printf "%s", current
                }
            } else {
                printf "%s", sent
            }
            if (i < n) {
                printf ". "
            }
        }
        printf "\n"
    }'
}

# Main execution
main() {
    local input_text
    input_text=$(get_input)

    if [[ -z "$input_text" ]]; then
        echo -e "${RED}Error: No input provided${NC}" >&2
        exit 1
    fi

    if $VERBOSE; then
        echo -e "${YELLOW}=== Input ===${NC}" >&2
        echo "$input_text" >&2
        echo "" >&2
    fi

    # Step 1: Rewrite for speech
    local rewritten
    rewritten=$(rewrite_for_speech "$input_text")

    if $VERBOSE; then
        echo -e "${YELLOW}=== After Rewrite ===${NC}" >&2
        echo "$rewritten" >&2
        echo "" >&2
    fi

    # Step 2: Split long sentences
    local final
    final=$(split_long_sentences "$rewritten")

    if $VERBOSE; then
        echo -e "${YELLOW}=== Final ===${NC}" >&2
        echo "$final" >&2
        echo "" >&2
    fi

    if [[ -n "$OUTPUT" ]]; then
        echo "$final" > "$OUTPUT"
        echo -e "${GREEN}Saved to: $OUTPUT${NC}" >&2
    else
        echo "$final"
    fi
}

main
