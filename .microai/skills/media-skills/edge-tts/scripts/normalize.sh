#!/usr/bin/env bash
# =============================================================================
# Text Normalization for Vietnamese TTS
# =============================================================================
# Chuẩn hóa văn bản tiếng Việt trước khi TTS:
# - Số → chữ (100 → một trăm)
# - Ngày tháng → chữ
# - Viết tắt → đầy đủ
# - Ký hiệu → chữ
# - Xóa emoji, URLs
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

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Normalize Vietnamese text for TTS.

Options:
    --input FILE      Input text file
    --text TEXT       Input text string
    --output FILE     Output file (default: stdout)
    --verbose         Show normalization steps
    -h, --help        Show this help

Examples:
    $(basename "$0") --input article.txt --output normalized.txt
    $(basename "$0") --text "Giá 100.000đ"
    echo "Test 123" | $(basename "$0")
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

# Vietnamese digit words (simple array for compatibility)
get_digit_word() {
    case "$1" in
        0) echo "không" ;;
        1) echo "một" ;;
        2) echo "hai" ;;
        3) echo "ba" ;;
        4) echo "bốn" ;;
        5) echo "năm" ;;
        6) echo "sáu" ;;
        7) echo "bảy" ;;
        8) echo "tám" ;;
        9) echo "chín" ;;
        *) echo "$1" ;;
    esac
}

# Convert number to Vietnamese words (simplified, compatible version)
number_to_words() {
    local num="$1"

    # Handle special cases
    case "$num" in
        0) echo "không"; return ;;
        1) echo "một"; return ;;
        10) echo "mười"; return ;;
        100) echo "một trăm"; return ;;
        1000) echo "một nghìn"; return ;;
    esac

    # For simplicity, just read digits for now
    # This is a basic implementation
    local result=""
    local len=${#num}

    # Handle common cases
    if [[ $num -lt 10 ]]; then
        get_digit_word "$num"
        return
    elif [[ $num -lt 100 ]]; then
        local tens=$((num / 10))
        local ones=$((num % 10))
        if [[ $tens -eq 1 ]]; then
            result="mười"
        else
            result="$(get_digit_word $tens) mươi"
        fi
        if [[ $ones -ne 0 ]]; then
            if [[ $ones -eq 1 && $tens -ne 1 ]]; then
                result+=" mốt"
            elif [[ $ones -eq 5 ]]; then
                result+=" lăm"
            else
                result+=" $(get_digit_word $ones)"
            fi
        fi
        echo "$result"
        return
    elif [[ $num -lt 1000 ]]; then
        local hundreds=$((num / 100))
        local remainder=$((num % 100))
        result="$(get_digit_word $hundreds) trăm"
        if [[ $remainder -gt 0 ]]; then
            if [[ $remainder -lt 10 ]]; then
                result+=" lẻ $(get_digit_word $remainder)"
            else
                result+=" $(number_to_words $remainder)"
            fi
        fi
        echo "$result"
        return
    elif [[ $num -lt 1000000 ]]; then
        local thousands=$((num / 1000))
        local remainder=$((num % 1000))
        result="$(number_to_words $thousands) nghìn"
        if [[ $remainder -gt 0 ]]; then
            if [[ $remainder -lt 100 ]]; then
                result+=" không trăm"
            fi
            result+=" $(number_to_words $remainder)"
        fi
        echo "$result"
        return
    else
        # For very large numbers, just output as-is
        echo "$num"
        return
    fi
}

# Main normalization function
normalize_text() {
    local text="$1"

    # Stage 1: Remove unwanted content
    # Remove URLs
    text=$(echo "$text" | sed -E 's|https?://[^ ]+||g')
    # Remove email addresses
    text=$(echo "$text" | sed -E 's|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}||g')
    # Remove emojis (basic)
    text=$(echo "$text" | sed 's/[\U0001F600-\U0001F64F]//g' 2>/dev/null || echo "$text")

    # Stage 2: Expand abbreviations
    # Vietnamese abbreviations
    text=$(echo "$text" | sed 's/\bTP\./Thành phố/g')
    text=$(echo "$text" | sed 's/\bTP\b/Thành phố/g')
    text=$(echo "$text" | sed 's/\bHCM\b/Hồ Chí Minh/g')
    text=$(echo "$text" | sed 's/\bHN\b/Hà Nội/g')
    text=$(echo "$text" | sed 's/\bĐN\b/Đà Nẵng/g')
    text=$(echo "$text" | sed 's/\bVN\b/Việt Nam/g')
    text=$(echo "$text" | sed 's/\bTW\b/Trung ương/g')
    text=$(echo "$text" | sed 's/\bGĐ\b/Giám đốc/g')
    text=$(echo "$text" | sed 's/\bPGĐ\b/Phó Giám đốc/g')
    text=$(echo "$text" | sed 's/\bCTy\b/Công ty/g')
    text=$(echo "$text" | sed 's/\bCty\b/Công ty/g')
    text=$(echo "$text" | sed 's/\bĐH\b/Đại học/g')
    text=$(echo "$text" | sed 's/\bTS\./Tiến sĩ/g')
    text=$(echo "$text" | sed 's/\bThS\./Thạc sĩ/g')
    text=$(echo "$text" | sed 's/\bPGS\./Phó Giáo sư/g')
    text=$(echo "$text" | sed 's/\bGS\./Giáo sư/g')
    text=$(echo "$text" | sed 's/\bKS\./Kỹ sư/g')
    text=$(echo "$text" | sed 's/\bBS\./Bác sĩ/g')

    # English abbreviations
    text=$(echo "$text" | sed 's/\bMr\.\?/Mister/g')
    text=$(echo "$text" | sed 's/\bMrs\.\?/Misses/g')
    text=$(echo "$text" | sed 's/\bMs\.\?/Miss/g')
    text=$(echo "$text" | sed 's/\bDr\.\?/Doctor/g')
    text=$(echo "$text" | sed 's/\bProf\.\?/Professor/g')
    text=$(echo "$text" | sed 's/\betc\./và vân vân/g')
    text=$(echo "$text" | sed 's/\be\.g\./ví dụ/g')
    text=$(echo "$text" | sed 's/\bi\.e\./tức là/g')

    # Stage 3: Currency
    text=$(echo "$text" | sed -E 's/([0-9]+)\.([0-9]{3})\.([0-9]{3})đ/\1\2\3 đồng/g')
    text=$(echo "$text" | sed -E 's/([0-9]+)\.([0-9]{3})đ/\1\2 đồng/g')
    text=$(echo "$text" | sed -E 's/([0-9]+)đ/\1 đồng/g')
    text=$(echo "$text" | sed -E 's/\$([0-9]+)/\1 đô la/g')
    text=$(echo "$text" | sed -E 's/([0-9]+)USD/\1 đô la Mỹ/g')
    text=$(echo "$text" | sed -E 's/([0-9]+)VND/\1 đồng/g')

    # Stage 4: Percentages
    text=$(echo "$text" | sed -E 's/([0-9]+)%/\1 phần trăm/g')

    # Stage 5: Time
    text=$(echo "$text" | sed -E 's/([0-9]{1,2}):([0-9]{2})/\1 giờ \2 phút/g')
    text=$(echo "$text" | sed -E 's/([0-9]{1,2})h([0-9]{2})/\1 giờ \2 phút/g')
    text=$(echo "$text" | sed -E 's/([0-9]{1,2})h\b/\1 giờ/g')

    # Stage 6: Dates (DD/MM/YYYY)
    text=$(echo "$text" | sed -E 's|([0-9]{1,2})/([0-9]{1,2})/([0-9]{4})|ngày \1 tháng \2 năm \3|g')
    text=$(echo "$text" | sed -E 's|([0-9]{1,2})/([0-9]{1,2})|ngày \1 tháng \2|g')

    # Stage 7: Phone numbers (format nicely)
    text=$(echo "$text" | sed -E 's/(\+84|0)([0-9]{2,3})([0-9]{3})([0-9]{4})/\1 \2 \3 \4/g')

    # Stage 8: Special characters
    text=$(echo "$text" | sed 's/&/ và /g')
    text=$(echo "$text" | sed 's/@/ a còng /g')
    text=$(echo "$text" | sed 's/#/ hashtag /g')
    text=$(echo "$text" | sed 's/+/ cộng /g')
    text=$(echo "$text" | sed 's/=/ bằng /g')
    text=$(echo "$text" | sed 's/×/ nhân /g')
    text=$(echo "$text" | sed 's/÷/ chia /g')

    # Stage 9: Normalize whitespace
    text=$(echo "$text" | sed 's/  */ /g')
    text=$(echo "$text" | sed 's/^ *//;s/ *$//')

    # Stage 10: Fix punctuation spacing
    text=$(echo "$text" | sed 's/ ,/,/g')
    text=$(echo "$text" | sed 's/ \././g')
    text=$(echo "$text" | sed 's/ !/!/g')
    text=$(echo "$text" | sed 's/ ?/?/g')

    echo "$text"
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

    local normalized
    normalized=$(normalize_text "$input_text")

    if $VERBOSE; then
        echo -e "${YELLOW}=== Normalized ===${NC}" >&2
        echo "$normalized" >&2
        echo "" >&2
    fi

    if [[ -n "$OUTPUT" ]]; then
        echo "$normalized" > "$OUTPUT"
        echo -e "${GREEN}Saved to: $OUTPUT${NC}" >&2
    else
        echo "$normalized"
    fi
}

main
