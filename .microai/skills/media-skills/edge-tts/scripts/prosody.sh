#!/bin/bash
# =============================================================================
# Prosody Planning for Vietnamese TTS
# =============================================================================
# Thêm SSML markup để điều khiển ngữ điệu:
# - Pause giữa câu, đoạn
# - Điều chỉnh pitch cho câu hỏi, cảm thán
# - Điều chỉnh rate cho emphasis
# - Break time cho dấu phẩy, chấm
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
USE_SSML=true  # Edge-TTS supports SSML

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Add prosody markup to Vietnamese text for natural TTS.

Options:
    --input FILE      Input text file
    --text TEXT       Input text string
    --output FILE     Output file (default: stdout)
    --no-ssml         Output plain text with pause markers instead of SSML
    --verbose         Show prosody planning steps
    -h, --help        Show this help

Examples:
    $(basename "$0") --input speech-ready.txt --output prosody.ssml
    $(basename "$0") --text "Xin chào! Bạn khỏe không?"
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
        --no-ssml)
            USE_SSML=false
            shift
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

# Add SSML prosody markup
add_ssml_prosody() {
    local text="$1"
    local result=""

    # Start SSML document
    result='<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="vi-VN">'
    result+=$'\n'

    # Process text paragraph by paragraph
    while IFS= read -r paragraph || [[ -n "$paragraph" ]]; do
        [[ -z "$paragraph" ]] && continue

        result+='  <p>'
        result+=$'\n'

        # Process each sentence
        local sentences
        # Split by sentence-ending punctuation
        IFS=$'\n' read -d '' -ra sentences < <(echo "$paragraph" | sed 's/\([.!?]\) /\1\n/g' && printf '\0')

        for sentence in "${sentences[@]}"; do
            [[ -z "$sentence" ]] && continue

            result+='    <s>'

            # Check sentence type and apply prosody
            if [[ "$sentence" =~ \?$ ]]; then
                # Question - raise pitch at end
                result+='<prosody pitch="+5%" rate="98%">'
                result+=$(escape_xml "$sentence")
                result+='</prosody>'
                result+='<break time="400ms"/>'

            elif [[ "$sentence" =~ \!$ ]]; then
                # Exclamation - increase rate and pitch
                result+='<prosody pitch="+10%" rate="105%" volume="+5%">'
                result+=$(escape_xml "$sentence")
                result+='</prosody>'
                result+='<break time="350ms"/>'

            elif [[ "$sentence" =~ \.\.\.$ ]]; then
                # Trailing off - slow down
                result+='<prosody rate="90%">'
                result+=$(escape_xml "$sentence")
                result+='</prosody>'
                result+='<break time="600ms"/>'

            else
                # Normal sentence
                # Add breaks for commas
                local processed_sentence
                processed_sentence=$(echo "$sentence" | sed 's/,/<break time="150ms"\/>,/g')
                # Add break for colons
                processed_sentence=$(echo "$processed_sentence" | sed 's/:/<break time="200ms"\/>:/g')
                # Add break for semicolons
                processed_sentence=$(echo "$processed_sentence" | sed 's/;/<break time="250ms"\/>;/g')

                result+='<prosody rate="medium" pitch="medium">'
                result+="$processed_sentence"
                result+='</prosody>'
                result+='<break time="300ms"/>'
            fi

            result+='</s>'
            result+=$'\n'
        done

        result+='  </p>'
        result+=$'\n'
        # Paragraph break
        result+='  <break time="500ms"/>'
        result+=$'\n'

    done <<< "$text"

    result+='</speak>'

    echo "$result"
}

# Escape XML special characters
escape_xml() {
    local text="$1"
    text="${text//&/&amp;}"
    text="${text//</&lt;}"
    text="${text//>/&gt;}"
    # Don't escape quotes as we're not in attributes here
    echo "$text"
}

# Add plain text prosody markers (alternative to SSML)
add_plain_prosody() {
    local text="$1"

    # Simple pass-through with minimal modifications
    # Edge-TTS handles punctuation pauses naturally

    # Just ensure proper spacing after punctuation
    text=$(echo "$text" | sed 's/\.  */. /g')
    text=$(echo "$text" | sed 's/,  */, /g')
    text=$(echo "$text" | sed 's/?  */? /g')
    text=$(echo "$text" | sed 's/!  */! /g')

    echo "$text"
}

# Analyze text and suggest prosody adjustments
analyze_prosody_needs() {
    local text="$1"

    echo "=== Prosody Analysis ===" >&2

    # Count sentence types
    local questions=$(echo "$text" | grep -o '?' | wc -l | tr -d ' ')
    local exclamations=$(echo "$text" | grep -o '!' | wc -l | tr -d ' ')
    local statements=$(echo "$text" | grep -o '\.' | wc -l | tr -d ' ')

    echo "Questions: $questions" >&2
    echo "Exclamations: $exclamations" >&2
    echo "Statements: $statements" >&2

    # Check for emphasis words
    local emphasis_words=("rất" "cực kỳ" "vô cùng" "quan trọng" "đặc biệt" "nhất")
    for word in "${emphasis_words[@]}"; do
        local count=$(echo "$text" | grep -oi "$word" | wc -l | tr -d ' ')
        if [[ $count -gt 0 ]]; then
            echo "Emphasis '$word': $count occurrences" >&2
        fi
    done

    # Check for list patterns
    if echo "$text" | grep -qE '(thứ nhất|thứ hai|đầu tiên|tiếp theo|cuối cùng)'; then
        echo "Contains enumeration markers - will add list prosody" >&2
    fi

    echo "========================" >&2
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
        analyze_prosody_needs "$input_text"
    fi

    local result
    if $USE_SSML; then
        result=$(add_ssml_prosody "$input_text")
    else
        result=$(add_plain_prosody "$input_text")
    fi

    if $VERBOSE; then
        echo -e "${YELLOW}=== With Prosody ===${NC}" >&2
        echo "$result" >&2
        echo "" >&2
    fi

    if [[ -n "$OUTPUT" ]]; then
        echo "$result" > "$OUTPUT"
        echo -e "${GREEN}Saved to: $OUTPUT${NC}" >&2
    else
        echo "$result"
    fi
}

main
