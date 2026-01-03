#!/bin/bash
# =============================================================================
# Dialogue TTS - Multi-Voice Conversation
# =============================================================================
# Tạo audio hội thoại với nhiều giọng nói khác nhau
# - Tự động phát hiện người nói từ format "Tên: nội dung"
# - Gán giọng khác nhau cho từng người
# - Merge thành file audio liền mạch
# =============================================================================

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default values
INPUT=""
OUTPUT="dialogue.mp3"
VOICE_MALE="vi-VN-NamMinhNeural"
VOICE_FEMALE="vi-VN-HoaiMyNeural"
SILENCE_BETWEEN=0.3      # Silence between lines
NORMALIZE=true
VERBOSE=false

# Speaker mapping will be handled in functions

usage() {
    cat << EOF
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║          Dialogue TTS - Multi-Voice Conversation                    ║
╚══════════════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Usage:${NC} $(basename "$0") --input FILE --output FILE [OPTIONS]

${YELLOW}Required:${NC}
    --input FILE          Input text file with dialogue format:
                          "Tên: Nội dung nói"

${YELLOW}Output:${NC}
    --output FILE         Output audio file (default: dialogue.mp3)

${YELLOW}Voices:${NC}
    --voice-male VOICE    Male voice (default: vi-VN-NamMinhNeural)
    --voice-female VOICE  Female voice (default: vi-VN-HoaiMyNeural)
    --speaker NAME:VOICE  Map specific speaker to voice
                          Example: --speaker "Minh:vi-VN-NamMinhNeural"

${YELLOW}Options:${NC}
    --silence N           Silence between lines in seconds (default: 0.3)
    --no-normalize        Skip audio normalization
    --verbose             Show detailed progress
    -h, --help            Show this help

${YELLOW}Input Format:${NC}
    The input file should have dialogue in this format:

    Minh: Xin chào, tôi là Minh.
    Lan: Chào Minh, tôi là Lan.
    Minh: Rất vui được gặp bạn.

    Lines without "Name:" prefix will use narrator voice.

${YELLOW}Examples:${NC}
    # Basic dialogue
    $(basename "$0") --input conversation.txt --output talk.mp3

    # Custom speaker voices
    $(basename "$0") --input story.txt --output story.mp3 \\
        --speaker "Narrator:vi-VN-HoaiMyNeural" \\
        --speaker "Hero:vi-VN-NamMinhNeural"
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
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --voice-male)
            VOICE_MALE="$2"
            shift 2
            ;;
        --voice-female)
            VOICE_FEMALE="$2"
            shift 2
            ;;
        --speaker)
            # Not supported in this version
            echo "Warning: --speaker not supported, using auto-detection" >&2
            shift 2
            ;;
        --silence)
            SILENCE_BETWEEN="$2"
            shift 2
            ;;
        --no-normalize)
            NORMALIZE=false
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

# Validate input
if [[ -z "$INPUT" ]]; then
    echo -e "${RED}Error: --input is required${NC}" >&2
    exit 1
fi

if [[ ! -f "$INPUT" ]]; then
    echo -e "${RED}Error: Input file not found: $INPUT${NC}" >&2
    exit 1
fi

# Detect speakers and assign voices
detect_speakers() {
    local input="$1"

    # Find all unique speaker names (format: "Name: text")
    grep -oE '^[A-Za-zÀ-ỹ]+:' "$input" | sed 's/:$//' | sort -u | tr '\n' ' '
}

# Assign voice to speaker based on name patterns
get_voice_for_speaker() {
    local speaker="$1"

    # Auto-detect based on Vietnamese name patterns
    # Common female names
    case "$speaker" in
        Lan|Hoa|Mai|Linh|Huong|Thao|Nga|Ngoc|Trang|Hanh|Yen|Vy|My|Thy|Chi|Nhu|Thuy|Thanh|Xuan|Thu|Ha|Phuong)
            echo "$VOICE_FEMALE"
            ;;
        *)
            echo "$VOICE_MALE"
            ;;
    esac
}

# Process single line
process_line() {
    local line="$1"
    local output_file="$2"
    local voice="$3"

    # Remove speaker prefix if present
    local text="$line"
    if [[ "$line" =~ ^[A-Za-zÀ-ỹ]+:\ (.+)$ ]]; then
        text="${BASH_REMATCH[1]}"
    fi

    # Skip empty lines
    if [[ -z "$text" || "$text" =~ ^[[:space:]]*$ ]]; then
        return 1
    fi

    # Generate audio
    edge-tts --voice "$voice" --text "$text" --write-media "$output_file" 2>/dev/null

    return 0
}

# Main execution
main() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Dialogue TTS - Multi-Voice Conversation${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Input: $INPUT"
    echo "Output: $OUTPUT"
    echo ""

    # Create temp directory
    local temp_dir
    temp_dir=$(mktemp -d)
    local audio_dir="${temp_dir}/audio"
    mkdir -p "$audio_dir"

    # Detect speakers
    echo -e "${BLUE}[1/4] Detecting speakers...${NC}"
    local speakers
    speakers=$(detect_speakers "$INPUT")
    echo -e "  Found speakers: $speakers"

    # Show voice assignments
    echo ""
    echo -e "${BLUE}[2/4] Voice assignments:${NC}"
    for speaker in $speakers; do
        local voice
        voice=$(get_voice_for_speaker "$speaker")
        echo -e "  $speaker → $voice"
    done
    echo ""

    # Process each line
    echo -e "${BLUE}[3/4] Generating audio for each line...${NC}"

    local line_num=0
    local audio_files=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and title lines (no colon)
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]]; then
            continue
        fi

        # Skip title (first line without colon pattern)
        if [[ ! "$line" =~ : && $line_num -eq 0 ]]; then
            ((line_num++))
            continue
        fi

        # Determine speaker and voice
        local speaker="Narrator"
        local voice="$VOICE_FEMALE"

        if [[ "$line" =~ ^([A-Za-zÀ-ỹ]+):\ .+ ]]; then
            speaker="${BASH_REMATCH[1]}"
            voice=$(get_voice_for_speaker "$speaker")
        fi

        local audio_file
        audio_file=$(printf "%s/line_%04d.mp3" "$audio_dir" "$line_num")

        if $VERBOSE; then
            echo -e "  [$line_num] $speaker: ${line:0:50}..."
        fi

        if process_line "$line" "$audio_file" "$voice"; then
            audio_files+=("$audio_file")
        fi

        ((line_num++))
    done < "$INPUT"

    echo -e "  Generated ${#audio_files[@]} audio segments"
    echo ""

    # Merge all audio files
    echo -e "${BLUE}[4/4] Merging audio...${NC}"

    "$SCRIPT_DIR/merge-audio.sh" \
        --input-dir "$audio_dir" \
        --pattern "*.mp3" \
        --output "$OUTPUT" \
        --silence "$SILENCE_BETWEEN" \
        $(if $VERBOSE; then echo "--verbose"; fi) 2>/dev/null

    # Post-process if needed
    if $NORMALIZE; then
        local temp_output="${temp_dir}/merged.mp3"
        mv "$OUTPUT" "$temp_output"

        "$SCRIPT_DIR/postprocess.sh" \
            --input "$temp_output" \
            --output "$OUTPUT" \
            --normalize \
            --fade-in 0.3 \
            --fade-out 0.5 2>/dev/null
    fi

    # Cleanup
    rm -rf "$temp_dir"

    # Final output
    if [[ -f "$OUTPUT" ]]; then
        local final_duration final_size
        final_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT" 2>/dev/null || echo "?")
        final_size=$(du -h "$OUTPUT" | cut -f1)

        # Convert to minutes:seconds
        local mins secs
        mins=$(echo "$final_duration / 60" | bc)
        secs=$(echo "$final_duration % 60" | bc)

        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  ✓ Dialogue Generation Complete${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "Output: ${CYAN}$OUTPUT${NC}"
        echo -e "Size: $final_size"
        printf "Duration: %d:%02d\n" "$mins" "${secs%.*}"
        echo -e "Lines processed: ${#audio_files[@]}"
    else
        echo -e "${RED}Error: Failed to create output file${NC}" >&2
        exit 1
    fi
}

main
