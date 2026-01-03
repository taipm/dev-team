#!/bin/bash
# =============================================================================
# TTS Core - Edge-TTS Wrapper
# =============================================================================
# Core TTS engine using Microsoft Edge TTS.
# Supports plain text and SSML input.
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
INPUT=""
OUTPUT="output.mp3"
VOICE="${EDGE_TTS_VOICE:-vi-VN-HoaiMyNeural}"
RATE="${EDGE_TTS_RATE:-+0%}"
PITCH="${EDGE_TTS_PITCH:-+0Hz}"
VOLUME="${EDGE_TTS_VOLUME:-+0%}"
IS_SSML=false
WITH_SUBTITLES=false
VERBOSE=false
LIST_VOICES=false

# Available Vietnamese voices
VOICES=(
    "vi-VN-HoaiMyNeural:Female:Warm, friendly - audiobooks, assistants"
    "vi-VN-NamMinhNeural:Male:Professional - news, presentations"
)

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Core TTS engine using Microsoft Edge TTS.

Options:
    --text TEXT           Input text string
    --input FILE          Input text/SSML file
    --output FILE         Output audio file (default: output.mp3)
    --voice VOICE         Voice name (default: vi-VN-HoaiMyNeural)
    --rate RATE           Speaking rate, e.g., +10%, -5% (default: +0%)
    --pitch PITCH         Voice pitch, e.g., +10Hz, -5Hz (default: +0Hz)
    --volume VOLUME       Volume adjustment, e.g., +10%, -10% (default: +0%)
    --ssml                Input is SSML format
    --subtitles           Generate SRT subtitles
    --list-voices         List available Vietnamese voices
    --verbose             Show detailed output
    -h, --help            Show this help

Voices:
    vi-VN-HoaiMyNeural    Female - warm, friendly (default)
    vi-VN-NamMinhNeural   Male - professional

Examples:
    $(basename "$0") --text "Xin chào" --output hello.mp3
    $(basename "$0") --input speech.txt --voice vi-VN-NamMinhNeural --output news.mp3
    $(basename "$0") --input prosody.ssml --ssml --output speech.mp3
    $(basename "$0") --text "Test" --rate "+10%" --pitch "+5Hz" --output fast.mp3
    $(basename "$0") --list-voices
EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --text)
            TEXT="$2"
            shift 2
            ;;
        --input)
            INPUT="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --voice)
            VOICE="$2"
            shift 2
            ;;
        --rate)
            RATE="$2"
            shift 2
            ;;
        --pitch)
            PITCH="$2"
            shift 2
            ;;
        --volume)
            VOLUME="$2"
            shift 2
            ;;
        --ssml)
            IS_SSML=true
            shift
            ;;
        --subtitles)
            WITH_SUBTITLES=true
            shift
            ;;
        --list-voices)
            LIST_VOICES=true
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

# List voices and exit
if $LIST_VOICES; then
    echo -e "${BLUE}=== Vietnamese Voices ===${NC}"
    echo ""
    printf "%-25s %-8s %s\n" "VOICE" "GENDER" "DESCRIPTION"
    printf "%-25s %-8s %s\n" "-----" "------" "-----------"
    for voice_info in "${VOICES[@]}"; do
        IFS=':' read -r voice gender desc <<< "$voice_info"
        printf "%-25s %-8s %s\n" "$voice" "$gender" "$desc"
    done
    echo ""
    echo -e "${YELLOW}Tip: Use --voice to select a voice${NC}"
    exit 0
fi

# Check edge-tts is installed
check_edge_tts() {
    if ! command -v edge-tts &> /dev/null; then
        echo -e "${RED}Error: edge-tts not found${NC}" >&2
        echo "Install with: pip install edge-tts" >&2
        exit 1
    fi
}

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

# Run TTS
run_tts() {
    local input_text="$1"
    local output_file="$2"

    # Build command
    local cmd="edge-tts"
    cmd+=" --voice '$VOICE'"
    cmd+=" --rate '$RATE'"
    cmd+=" --pitch '$PITCH'"
    cmd+=" --volume '$VOLUME'"
    cmd+=" --write-media '$output_file'"

    if $WITH_SUBTITLES; then
        local srt_file="${output_file%.*}.srt"
        cmd+=" --write-subtitles '$srt_file'"
    fi

    # Create temp file for input
    local temp_file
    temp_file=$(mktemp)

    if $IS_SSML; then
        # For SSML, we need to use the --ssml flag (if supported)
        # Edge-TTS has limited SSML support, so we'll extract text
        echo "$input_text" > "$temp_file"

        # Check if edge-tts supports SSML
        # For now, extract text from SSML for compatibility
        local plain_text
        plain_text=$(echo "$input_text" | sed 's/<[^>]*>//g' | sed '/^$/d')
        echo "$plain_text" > "$temp_file"

        if $VERBOSE; then
            echo -e "${YELLOW}Note: Converting SSML to plain text for edge-tts${NC}" >&2
        fi
    else
        echo "$input_text" > "$temp_file"
    fi

    cmd+=" --file '$temp_file'"

    if $VERBOSE; then
        echo -e "${BLUE}=== TTS Configuration ===${NC}" >&2
        echo "Voice: $VOICE" >&2
        echo "Rate: $RATE" >&2
        echo "Pitch: $PITCH" >&2
        echo "Volume: $VOLUME" >&2
        echo "Output: $output_file" >&2
        echo "" >&2
        echo -e "${BLUE}=== Running edge-tts ===${NC}" >&2
    fi

    # Run edge-tts
    if eval "$cmd" 2>&1; then
        if $VERBOSE; then
            echo -e "${GREEN}TTS completed successfully${NC}" >&2
        fi
    else
        echo -e "${RED}TTS failed${NC}" >&2
        rm -f "$temp_file"
        exit 1
    fi

    # Cleanup
    rm -f "$temp_file"

    # Show output info
    if [[ -f "$output_file" ]]; then
        local size
        size=$(du -h "$output_file" | cut -f1)
        echo -e "${GREEN}Generated: $output_file ($size)${NC}" >&2

        if $WITH_SUBTITLES; then
            local srt_file="${output_file%.*}.srt"
            if [[ -f "$srt_file" ]]; then
                echo -e "${GREEN}Subtitles: $srt_file${NC}" >&2
            fi
        fi
    fi
}

# Main execution
main() {
    check_edge_tts

    local input_text
    input_text=$(get_input)

    if [[ -z "$input_text" ]]; then
        echo -e "${RED}Error: No input provided${NC}" >&2
        echo "Use --text, --input, or pipe text to stdin" >&2
        exit 1
    fi

    # Create output directory if needed
    local output_dir
    output_dir=$(dirname "$OUTPUT")
    if [[ ! -d "$output_dir" && "$output_dir" != "." ]]; then
        mkdir -p "$output_dir"
    fi

    run_tts "$input_text" "$OUTPUT"
}

main
