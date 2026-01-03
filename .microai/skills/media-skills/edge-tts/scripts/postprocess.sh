#!/bin/bash
# =============================================================================
# Audio Post-processing for TTS
# =============================================================================
# Xử lý hậu kỳ âm thanh:
# - Normalize volume (LUFS)
# - Remove/trim silence
# - Fade in/out
# - Speed adjustment
# - Format conversion
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
OUTPUT=""
DO_NORMALIZE=false
DO_REMOVE_SILENCE=false
DO_TRIM_SILENCE=false
FADE_IN=0
FADE_OUT=0
SPEED=1.0
OUTPUT_FORMAT=""
TARGET_LUFS=-14
SILENCE_THRESHOLD="-50dB"
SILENCE_DURATION="1"
VERBOSE=false

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Post-process TTS audio for broadcast quality.

Options:
    --input FILE          Input audio file (required)
    --output FILE         Output audio file (default: input with _processed suffix)

    Audio Processing:
    --normalize           Normalize volume to -14 LUFS (broadcast standard)
    --target-lufs N       Target LUFS level (default: -14)
    --remove-silence      Remove long silence gaps (>1s)
    --trim-silence        Trim silence from start/end only
    --silence-threshold   Silence detection threshold (default: -50dB)
    --silence-duration    Min silence duration to remove (default: 1s)

    Effects:
    --fade-in N           Fade in duration in seconds
    --fade-out N          Fade out duration in seconds
    --speed N             Playback speed (0.5-2.0, default: 1.0)

    Output:
    --format FORMAT       Output format (mp3, wav, ogg, m4a)

    Other:
    --verbose             Show detailed output
    -h, --help            Show this help

Examples:
    # Full processing for podcast
    $(basename "$0") --input raw.mp3 --output final.mp3 \\
        --normalize --remove-silence --fade-in 0.5 --fade-out 0.5

    # Quick trim and normalize
    $(basename "$0") --input raw.mp3 --trim-silence --normalize

    # Speed up and convert
    $(basename "$0") --input raw.mp3 --speed 1.2 --format wav --output fast.wav
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
        --normalize)
            DO_NORMALIZE=true
            shift
            ;;
        --target-lufs)
            TARGET_LUFS="$2"
            shift 2
            ;;
        --remove-silence)
            DO_REMOVE_SILENCE=true
            shift
            ;;
        --trim-silence)
            DO_TRIM_SILENCE=true
            shift
            ;;
        --silence-threshold)
            SILENCE_THRESHOLD="$2"
            shift 2
            ;;
        --silence-duration)
            SILENCE_DURATION="$2"
            shift 2
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
        --format)
            OUTPUT_FORMAT="$2"
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

# Check required arguments
if [[ -z "$INPUT" ]]; then
    echo -e "${RED}Error: --input is required${NC}" >&2
    usage
fi

if [[ ! -f "$INPUT" ]]; then
    echo -e "${RED}Error: Input file not found: $INPUT${NC}" >&2
    exit 1
fi

# Check ffmpeg
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}Error: ffmpeg not found${NC}" >&2
        echo "Install with: brew install ffmpeg" >&2
        exit 1
    fi
}

# Set default output
set_default_output() {
    if [[ -z "$OUTPUT" ]]; then
        local dir
        local name
        local ext

        dir=$(dirname "$INPUT")
        name=$(basename "$INPUT")
        ext="${name##*.}"
        name="${name%.*}"

        if [[ -n "$OUTPUT_FORMAT" ]]; then
            ext="$OUTPUT_FORMAT"
        fi

        OUTPUT="${dir}/${name}_processed.${ext}"
    elif [[ -n "$OUTPUT_FORMAT" ]]; then
        # Change extension if format specified
        OUTPUT="${OUTPUT%.*}.${OUTPUT_FORMAT}"
    fi
}

# Get audio duration
get_duration() {
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1" 2>/dev/null
}

# Build ffmpeg filter chain
build_filter_chain() {
    local filters=()

    # Speed adjustment (must be first if used)
    if [[ "$SPEED" != "1.0" && "$SPEED" != "1" ]]; then
        filters+=("atempo=$SPEED")
    fi

    # Remove silence (silenceremove filter)
    if $DO_REMOVE_SILENCE; then
        # Remove silence from middle of audio
        filters+=("silenceremove=stop_periods=-1:stop_duration=${SILENCE_DURATION}:stop_threshold=${SILENCE_THRESHOLD}")
    fi

    # Trim silence from start/end only
    if $DO_TRIM_SILENCE; then
        # Remove from start
        filters+=("silenceremove=start_periods=1:start_silence=0.1:start_threshold=${SILENCE_THRESHOLD}")
        # Remove from end (reverse, remove, reverse back)
        filters+=("areverse")
        filters+=("silenceremove=start_periods=1:start_silence=0.1:start_threshold=${SILENCE_THRESHOLD}")
        filters+=("areverse")
    fi

    # Fade in
    if [[ "$FADE_IN" != "0" ]]; then
        filters+=("afade=t=in:st=0:d=${FADE_IN}")
    fi

    # Fade out (need to calculate start time)
    if [[ "$FADE_OUT" != "0" ]]; then
        # Will be added after getting duration
        NEED_FADE_OUT=true
    fi

    # Join filters
    if [[ ${#filters[@]} -gt 0 ]]; then
        local IFS=','
        echo "${filters[*]}"
    else
        echo ""
    fi
}

# Normalize audio using loudnorm filter
normalize_audio() {
    local input_file="$1"
    local output_file="$2"

    if $VERBOSE; then
        echo -e "${BLUE}=== Normalizing to ${TARGET_LUFS} LUFS ===${NC}" >&2
    fi

    # Two-pass loudnorm for accurate normalization
    # First pass: analyze
    local analysis
    analysis=$(ffmpeg -i "$input_file" -af "loudnorm=I=${TARGET_LUFS}:TP=-1.5:LRA=11:print_format=json" -f null - 2>&1 | grep -A 12 '"input_i"')

    if $VERBOSE; then
        echo "Analysis: $analysis" >&2
    fi

    # Extract values for second pass
    local input_i input_tp input_lra input_thresh
    input_i=$(echo "$analysis" | grep '"input_i"' | sed 's/.*: "\([^"]*\)".*/\1/')
    input_tp=$(echo "$analysis" | grep '"input_tp"' | sed 's/.*: "\([^"]*\)".*/\1/')
    input_lra=$(echo "$analysis" | grep '"input_lra"' | sed 's/.*: "\([^"]*\)".*/\1/')
    input_thresh=$(echo "$analysis" | grep '"input_thresh"' | sed 's/.*: "\([^"]*\)".*/\1/')

    # Second pass: apply normalization
    local loudnorm_filter="loudnorm=I=${TARGET_LUFS}:TP=-1.5:LRA=11"
    if [[ -n "$input_i" ]]; then
        loudnorm_filter+=":measured_I=${input_i}:measured_TP=${input_tp}:measured_LRA=${input_lra}:measured_thresh=${input_thresh}:linear=true"
    fi

    ffmpeg -y -i "$input_file" -af "$loudnorm_filter" "$output_file" 2>/dev/null

    if $VERBOSE; then
        echo -e "${GREEN}Normalization complete${NC}" >&2
    fi
}

# Main processing function
process_audio() {
    local current_input="$INPUT"
    local temp_files=()
    local step=1

    # Create temp directory
    local temp_dir
    temp_dir=$(mktemp -d)

    # Step 1: Apply filter chain (speed, silence, fade-in)
    local filter_chain
    filter_chain=$(build_filter_chain)

    if [[ -n "$filter_chain" ]]; then
        if $VERBOSE; then
            echo -e "${BLUE}=== Step $step: Applying filters ===${NC}" >&2
            echo "Filters: $filter_chain" >&2
        fi

        local temp_output="${temp_dir}/step${step}.mp3"
        ffmpeg -y -i "$current_input" -af "$filter_chain" "$temp_output" 2>/dev/null

        current_input="$temp_output"
        temp_files+=("$temp_output")
        ((step++))
    fi

    # Step 2: Add fade-out (needs duration calculation)
    if [[ "$FADE_OUT" != "0" ]]; then
        local duration
        duration=$(get_duration "$current_input")
        local fade_start
        fade_start=$(echo "$duration - $FADE_OUT" | bc)

        if $VERBOSE; then
            echo -e "${BLUE}=== Step $step: Adding fade-out ===${NC}" >&2
            echo "Duration: ${duration}s, Fade start: ${fade_start}s" >&2
        fi

        local temp_output="${temp_dir}/step${step}.mp3"
        ffmpeg -y -i "$current_input" -af "afade=t=out:st=${fade_start}:d=${FADE_OUT}" "$temp_output" 2>/dev/null

        current_input="$temp_output"
        temp_files+=("$temp_output")
        ((step++))
    fi

    # Step 3: Normalize (should be last)
    if $DO_NORMALIZE; then
        if $VERBOSE; then
            echo -e "${BLUE}=== Step $step: Normalizing ===${NC}" >&2
        fi

        local temp_output="${temp_dir}/step${step}.mp3"
        normalize_audio "$current_input" "$temp_output"

        current_input="$temp_output"
        temp_files+=("$temp_output")
        ((step++))
    fi

    # Final step: Copy to output with format conversion if needed
    if $VERBOSE; then
        echo -e "${BLUE}=== Final: Writing output ===${NC}" >&2
    fi

    if [[ -n "$OUTPUT_FORMAT" ]]; then
        # Convert format
        ffmpeg -y -i "$current_input" "$OUTPUT" 2>/dev/null
    else
        # Just copy
        cp "$current_input" "$OUTPUT"
    fi

    # Cleanup temp files
    rm -rf "$temp_dir"

    # Show results
    local input_size output_size input_duration output_duration
    input_size=$(du -h "$INPUT" | cut -f1)
    output_size=$(du -h "$OUTPUT" | cut -f1)
    input_duration=$(get_duration "$INPUT")
    output_duration=$(get_duration "$OUTPUT")

    echo -e "${GREEN}=== Processing Complete ===${NC}"
    echo "Input:  $INPUT ($input_size, ${input_duration}s)"
    echo "Output: $OUTPUT ($output_size, ${output_duration}s)"
}

# Main execution
main() {
    check_ffmpeg
    set_default_output

    if $VERBOSE; then
        echo -e "${BLUE}=== Audio Post-processing ===${NC}" >&2
        echo "Input: $INPUT" >&2
        echo "Output: $OUTPUT" >&2
        echo "" >&2
        echo "Options:" >&2
        echo "  Normalize: $DO_NORMALIZE (target: ${TARGET_LUFS} LUFS)" >&2
        echo "  Remove silence: $DO_REMOVE_SILENCE" >&2
        echo "  Trim silence: $DO_TRIM_SILENCE" >&2
        echo "  Fade in: ${FADE_IN}s" >&2
        echo "  Fade out: ${FADE_OUT}s" >&2
        echo "  Speed: ${SPEED}x" >&2
        echo "" >&2
    fi

    process_audio
}

main
