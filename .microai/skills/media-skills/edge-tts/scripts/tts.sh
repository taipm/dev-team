#!/bin/bash
# =============================================================================
# Vietnamese TTS Pipeline - Main Script
# =============================================================================
# Full pipeline: Normalize → Rewrite → Prosody → TTS → Post-process
#
# Usage:
#   ./tts.sh --text "Xin chào" --output hello.mp3
#   ./tts.sh --input article.txt --output audiobook.mp3 --normalize
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
OUTPUT="output.mp3"
VOICE="${EDGE_TTS_VOICE:-vi-VN-HoaiMyNeural}"
RATE="${EDGE_TTS_RATE:-+0%}"
PITCH="${EDGE_TTS_PITCH:-+0Hz}"

# Pipeline options
SKIP_NORMALIZE=false
SKIP_REWRITE=false
SKIP_PROSODY=false
RAW_MODE=false
QUICK_MODE=false

# Post-processing options
DO_AUDIO_NORMALIZE=false
DO_REMOVE_SILENCE=false
DO_TRIM_SILENCE=false
FADE_IN=0
FADE_OUT=0
SPEED=1.0

# Other options
VERBOSE=false
KEEP_TEMP=false
DRY_RUN=false

usage() {
    cat << EOF
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║          Vietnamese TTS Pipeline - Professional Audio              ║
╚══════════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Usage:${NC} $(basename "$0") [OPTIONS]

${YELLOW}Input Options:${NC}
    --text TEXT           Input text string
    --input FILE          Input text file
    --output FILE         Output audio file (default: output.mp3)

${YELLOW}Voice Options:${NC}
    --voice VOICE         Voice name (default: vi-VN-HoaiMyNeural)
                          Options: vi-VN-HoaiMyNeural (female)
                                   vi-VN-NamMinhNeural (male)
    --rate RATE           Speaking rate, e.g., +10%, -5%
    --pitch PITCH         Voice pitch, e.g., +10Hz, -5Hz

${YELLOW}Pipeline Control:${NC}
    --raw                 Skip all preprocessing (TTS only)
    --quick               Skip rewrite stage only
    --skip-normalize      Skip text normalization
    --skip-rewrite        Skip rewrite-for-speech
    --skip-prosody        Skip prosody planning

${YELLOW}Audio Post-processing:${NC}
    --normalize           Normalize audio volume (-14 LUFS)
    --remove-silence      Remove long silence gaps (>1s)
    --trim-silence        Trim silence from start/end
    --fade-in N           Fade in duration in seconds
    --fade-out N          Fade out duration in seconds
    --speed N             Playback speed (0.5-2.0)

${YELLOW}Other Options:${NC}
    --verbose             Show detailed pipeline output
    --keep-temp           Keep temporary files for debugging
    --dry-run             Show what would be done without executing
    -h, --help            Show this help

${YELLOW}Examples:${NC}
    # Quick TTS
    $(basename "$0") --text "Xin chào Việt Nam" --output hello.mp3

    # Full pipeline with post-processing
    $(basename "$0") --input article.txt --output audiobook.mp3 \\
        --normalize --remove-silence --fade-in 0.3 --fade-out 0.3

    # Male voice, faster speed
    $(basename "$0") --text "Bản tin hôm nay" --voice vi-VN-NamMinhNeural \\
        --speed 1.1 --output news.mp3

    # Raw TTS (no preprocessing)
    $(basename "$0") --text "Test nhanh" --raw --output test.mp3

${YELLOW}Pipeline Stages:${NC}
    1. ${GREEN}Normalize${NC}   - Clean text, expand abbreviations, numbers → words
    2. ${GREEN}Rewrite${NC}     - Restructure for natural speech
    3. ${GREEN}Prosody${NC}     - Add pauses and intonation markers
    4. ${GREEN}TTS${NC}         - Generate audio with Edge-TTS
    5. ${GREEN}Post-process${NC} - Normalize volume, remove silence, fade
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
        --raw)
            RAW_MODE=true
            shift
            ;;
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --skip-normalize)
            SKIP_NORMALIZE=true
            shift
            ;;
        --skip-rewrite)
            SKIP_REWRITE=true
            shift
            ;;
        --skip-prosody)
            SKIP_PROSODY=true
            shift
            ;;
        --normalize)
            DO_AUDIO_NORMALIZE=true
            shift
            ;;
        --remove-silence)
            DO_REMOVE_SILENCE=true
            shift
            ;;
        --trim-silence)
            DO_TRIM_SILENCE=true
            shift
            ;;
        --fade-in)
            FADE_IN="$2"
            shift 2
            ;;
        --fade-out)
            FADE_OUT="$2"
            shift 2
            ;;
        --speed)
            SPEED="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --keep-temp)
            KEEP_TEMP=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Get input text
get_input() {
    if [[ -n "${TEXT:-}" ]]; then
        echo "$TEXT"
    elif [[ -n "$INPUT" ]]; then
        if [[ ! -f "$INPUT" ]]; then
            echo -e "${RED}Error: Input file not found: $INPUT${NC}" >&2
            exit 1
        fi
        cat "$INPUT"
    else
        echo -e "${RED}Error: No input provided${NC}" >&2
        echo "Use --text or --input to provide text" >&2
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    local missing=()

    if ! command -v edge-tts &> /dev/null; then
        missing+=("edge-tts (pip install edge-tts)")
    fi

    # Post-processing requires ffmpeg
    if $DO_AUDIO_NORMALIZE || $DO_REMOVE_SILENCE || $DO_TRIM_SILENCE || \
       [[ "$FADE_IN" != "0" ]] || [[ "$FADE_OUT" != "0" ]] || [[ "$SPEED" != "1.0" ]]; then
        if ! command -v ffmpeg &> /dev/null; then
            missing+=("ffmpeg (brew install ffmpeg)")
        fi
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}Missing dependencies:${NC}" >&2
        for dep in "${missing[@]}"; do
            echo "  - $dep" >&2
        done
        exit 1
    fi
}

# Print stage header
print_stage() {
    local stage_num="$1"
    local stage_name="$2"
    local status="$3"

    if $VERBOSE; then
        if [[ "$status" == "running" ]]; then
            echo -e "${BLUE}[${stage_num}/5] ${stage_name}...${NC}" >&2
        elif [[ "$status" == "skipped" ]]; then
            echo -e "${YELLOW}[${stage_num}/5] ${stage_name} (skipped)${NC}" >&2
        elif [[ "$status" == "done" ]]; then
            echo -e "${GREEN}[${stage_num}/5] ${stage_name} ✓${NC}" >&2
        fi
    fi
}

# Main pipeline
run_pipeline() {
    local input_text
    input_text=$(get_input)

    if [[ -z "$input_text" ]]; then
        echo -e "${RED}Error: Empty input${NC}" >&2
        exit 1
    fi

    # Create temp directory
    local temp_dir
    temp_dir=$(mktemp -d)

    if $VERBOSE; then
        echo -e "${CYAN}═══════════════════════════════════════════════════${NC}" >&2
        echo -e "${CYAN}  Vietnamese TTS Pipeline${NC}" >&2
        echo -e "${CYAN}═══════════════════════════════════════════════════${NC}" >&2
        echo "" >&2
        echo "Voice: $VOICE" >&2
        echo "Output: $OUTPUT" >&2
        echo "Mode: $(if $RAW_MODE; then echo "Raw"; elif $QUICK_MODE; then echo "Quick"; else echo "Full"; fi)" >&2
        echo "" >&2
    fi

    # Save original input
    echo "$input_text" > "${temp_dir}/0_original.txt"
    local current_text="$input_text"

    # Stage 1: Normalize
    if ! $RAW_MODE && ! $SKIP_NORMALIZE; then
        print_stage 1 "Text Normalization" "running"
        current_text=$(echo "$current_text" | "$SCRIPT_DIR/normalize.sh")
        echo "$current_text" > "${temp_dir}/1_normalized.txt"
        print_stage 1 "Text Normalization" "done"
    else
        print_stage 1 "Text Normalization" "skipped"
    fi

    # Stage 2: Rewrite for speech
    if ! $RAW_MODE && ! $QUICK_MODE && ! $SKIP_REWRITE; then
        print_stage 2 "Rewrite for Speech" "running"
        current_text=$(echo "$current_text" | "$SCRIPT_DIR/rewrite.sh")
        echo "$current_text" > "${temp_dir}/2_rewritten.txt"
        print_stage 2 "Rewrite for Speech" "done"
    else
        print_stage 2 "Rewrite for Speech" "skipped"
    fi

    # Stage 3: Prosody planning
    if ! $RAW_MODE && ! $SKIP_PROSODY; then
        print_stage 3 "Prosody Planning" "running"
        # Use plain text prosody (edge-tts has limited SSML support)
        current_text=$(echo "$current_text" | "$SCRIPT_DIR/prosody.sh" --no-ssml)
        echo "$current_text" > "${temp_dir}/3_prosody.txt"
        print_stage 3 "Prosody Planning" "done"
    else
        print_stage 3 "Prosody Planning" "skipped"
    fi

    # Stage 4: TTS Generation
    print_stage 4 "TTS Generation" "running"
    local tts_output="${temp_dir}/4_audio.mp3"

    "$SCRIPT_DIR/tts-core.sh" \
        --text "$current_text" \
        --output "$tts_output" \
        --voice "$VOICE" \
        --rate "$RATE" \
        --pitch "$PITCH" \
        $(if $VERBOSE; then echo "--verbose"; fi) 2>/dev/null

    print_stage 4 "TTS Generation" "done"

    # Stage 5: Post-processing
    local needs_postprocess=false
    if $DO_AUDIO_NORMALIZE || $DO_REMOVE_SILENCE || $DO_TRIM_SILENCE || \
       [[ "$FADE_IN" != "0" ]] || [[ "$FADE_OUT" != "0" ]] || [[ "$SPEED" != "1.0" ]]; then
        needs_postprocess=true
    fi

    if $needs_postprocess; then
        print_stage 5 "Audio Post-processing" "running"

        local postprocess_args=(
            --input "$tts_output"
            --output "$OUTPUT"
        )

        $DO_AUDIO_NORMALIZE && postprocess_args+=(--normalize)
        $DO_REMOVE_SILENCE && postprocess_args+=(--remove-silence)
        $DO_TRIM_SILENCE && postprocess_args+=(--trim-silence)
        [[ "$FADE_IN" != "0" ]] && postprocess_args+=(--fade-in "$FADE_IN")
        [[ "$FADE_OUT" != "0" ]] && postprocess_args+=(--fade-out "$FADE_OUT")
        [[ "$SPEED" != "1.0" ]] && postprocess_args+=(--speed "$SPEED")
        $VERBOSE && postprocess_args+=(--verbose)

        "$SCRIPT_DIR/postprocess.sh" "${postprocess_args[@]}" 2>/dev/null

        print_stage 5 "Audio Post-processing" "done"
    else
        print_stage 5 "Audio Post-processing" "skipped"
        # Just copy the TTS output
        cp "$tts_output" "$OUTPUT"
    fi

    # Cleanup or keep temp files
    if $KEEP_TEMP; then
        echo -e "${YELLOW}Temp files kept at: ${temp_dir}${NC}" >&2
    else
        rm -rf "$temp_dir"
    fi

    # Final output
    if [[ -f "$OUTPUT" ]]; then
        local size duration
        size=$(du -h "$OUTPUT" | cut -f1)
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT" 2>/dev/null || echo "?")

        echo "" >&2
        echo -e "${GREEN}═══════════════════════════════════════════════════${NC}" >&2
        echo -e "${GREEN}  ✓ TTS Complete${NC}" >&2
        echo -e "${GREEN}═══════════════════════════════════════════════════${NC}" >&2
        echo -e "Output: ${CYAN}$OUTPUT${NC}" >&2
        echo -e "Size: $size | Duration: ${duration}s" >&2
    else
        echo -e "${RED}Error: Output file not created${NC}" >&2
        exit 1
    fi
}

# Main execution
main() {
    check_dependencies

    if $DRY_RUN; then
        echo -e "${YELLOW}=== Dry Run ===${NC}"
        echo "Would process text with:"
        echo "  Voice: $VOICE"
        echo "  Pipeline: $(if $RAW_MODE; then echo "Raw"; elif $QUICK_MODE; then echo "Quick"; else echo "Full"; fi)"
        echo "  Output: $OUTPUT"
        echo ""
        echo "Text preview:"
        get_input | head -c 200
        echo "..."
        exit 0
    fi

    run_pipeline
}

main
