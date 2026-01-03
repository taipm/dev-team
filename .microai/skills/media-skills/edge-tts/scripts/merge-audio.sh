#!/usr/bin/env bash
# =============================================================================
# Audio Merger for TTS Chunks
# =============================================================================
# Merge multiple audio files into one continuous file
# - Supports MP3, WAV, OGG, M4A
# - Optional crossfade between chunks
# - Optional silence padding between chunks
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default values
INPUT_DIR=""
INPUT_PATTERN="*.mp3"
OUTPUT=""
SILENCE_BETWEEN=0.5      # Seconds of silence between chunks
CROSSFADE=0              # Crossfade duration (0 = disabled)
FORMAT="mp3"
VERBOSE=false

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [FILE1 FILE2 ...]

Merge multiple audio files into one.

Options:
    --input-dir DIR       Directory containing audio chunks
    --pattern GLOB        File pattern (default: *.mp3)
    --output FILE         Output file (required)
    --silence N           Silence between chunks in seconds (default: 0.5)
    --crossfade N         Crossfade duration in seconds (default: 0, disabled)
    --format FORMAT       Output format: mp3, wav, ogg, m4a (default: mp3)
    --verbose             Show detailed output
    -h, --help            Show this help

Examples:
    # Merge all chunks in a directory
    $(basename "$0") --input-dir chunks/ --output audiobook.mp3

    # Merge specific files
    $(basename "$0") chapter1.mp3 chapter2.mp3 chapter3.mp3 --output book.mp3

    # With crossfade
    $(basename "$0") --input-dir chunks/ --output merged.mp3 --crossfade 0.5
EOF
    exit 0
}

# Collect input files
INPUT_FILES=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --input-dir)
            INPUT_DIR="$2"
            shift 2
            ;;
        --pattern)
            INPUT_PATTERN="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --silence)
            SILENCE_BETWEEN="$2"
            shift 2
            ;;
        --crossfade)
            CROSSFADE="$2"
            shift 2
            ;;
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}" >&2
            exit 1
            ;;
        *)
            # Treat as input file
            INPUT_FILES+=("$1")
            shift
            ;;
    esac
done

# Check ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}Error: ffmpeg not found${NC}" >&2
    echo "Install with: brew install ffmpeg" >&2
    exit 1
fi

# Validate output
if [[ -z "$OUTPUT" ]]; then
    echo -e "${RED}Error: --output is required${NC}" >&2
    exit 1
fi

# Collect files from directory if specified
if [[ -n "$INPUT_DIR" ]]; then
    if [[ ! -d "$INPUT_DIR" ]]; then
        echo -e "${RED}Error: Directory not found: $INPUT_DIR${NC}" >&2
        exit 1
    fi

    # Find and sort files
    while IFS= read -r -d '' file; do
        INPUT_FILES+=("$file")
    done < <(find "$INPUT_DIR" -name "$INPUT_PATTERN" -print0 | sort -z)
fi

# Check we have files
if [[ ${#INPUT_FILES[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No input files found${NC}" >&2
    exit 1
fi

# Get audio duration
get_duration() {
    ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1" 2>/dev/null || echo "0"
}

# Simple merge using concat demuxer (fastest, no re-encoding if same format)
simple_merge() {
    local temp_list
    temp_list=$(mktemp)

    # Create file list for ffmpeg concat
    for file in "${INPUT_FILES[@]}"; do
        echo "file '$file'" >> "$temp_list"
    done

    if $VERBOSE; then
        echo -e "${BLUE}Using concat demuxer (fast, no re-encode)${NC}" >&2
        cat "$temp_list" >&2
    fi

    ffmpeg -y -f concat -safe 0 -i "$temp_list" -c copy "$OUTPUT" 2>/dev/null

    rm -f "$temp_list"
}

# Merge with silence padding between chunks
merge_with_silence() {
    local silence_duration="$1"
    local temp_dir
    temp_dir=$(mktemp -d)

    if $VERBOSE; then
        echo -e "${BLUE}Merging with ${silence_duration}s silence between chunks${NC}" >&2
    fi

    # Generate silence file
    local silence_file="${temp_dir}/silence.mp3"
    ffmpeg -y -f lavfi -i anullsrc=r=24000:cl=mono -t "$silence_duration" -q:a 9 "$silence_file" 2>/dev/null

    # Create file list with silence between
    local temp_list="${temp_dir}/filelist.txt"
    local first=true

    for file in "${INPUT_FILES[@]}"; do
        if $first; then
            first=false
        else
            echo "file '$silence_file'" >> "$temp_list"
        fi
        echo "file '$file'" >> "$temp_list"
    done

    # Merge
    ffmpeg -y -f concat -safe 0 -i "$temp_list" -c copy "$OUTPUT" 2>/dev/null

    rm -rf "$temp_dir"
}

# Merge with crossfade (requires re-encoding)
merge_with_crossfade() {
    local crossfade_duration="$1"

    if $VERBOSE; then
        echo -e "${BLUE}Merging with ${crossfade_duration}s crossfade (will re-encode)${NC}" >&2
    fi

    # For crossfade, we need to use filter_complex
    # Build filter graph
    local num_files=${#INPUT_FILES[@]}

    if [[ $num_files -lt 2 ]]; then
        # Only one file, just copy
        cp "${INPUT_FILES[0]}" "$OUTPUT"
        return
    fi

    # Build input args
    local inputs=""
    for file in "${INPUT_FILES[@]}"; do
        inputs+=" -i \"$file\""
    done

    # Build filter graph for acrossfade
    local filter="[0:a]"
    for ((i=1; i<num_files; i++)); do
        filter+="[$i:a]acrossfade=d=${crossfade_duration}:c1=tri:c2=tri"
        if [[ $i -lt $((num_files - 1)) ]]; then
            filter+="[a$i];[a$i]"
        fi
    done

    # Execute ffmpeg
    eval "ffmpeg -y $inputs -filter_complex \"$filter\" -q:a 2 \"$OUTPUT\"" 2>/dev/null
}

# Main execution
main() {
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Audio Merger${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo "Input files: ${#INPUT_FILES[@]}"
    echo "Output: $OUTPUT"
    echo ""

    # Calculate total input duration
    local total_input_duration=0
    local i=1
    for file in "${INPUT_FILES[@]}"; do
        local duration
        duration=$(get_duration "$file")
        total_input_duration=$(echo "$total_input_duration + $duration" | bc)

        if $VERBOSE; then
            printf "  %3d. %s (%.1fs)\n" "$i" "$(basename "$file")" "$duration" >&2
        fi
        ((i++))
    done

    echo "Total input duration: ${total_input_duration}s"
    echo ""

    # Choose merge strategy
    if [[ "$CROSSFADE" != "0" && "$CROSSFADE" != "0.0" ]]; then
        merge_with_crossfade "$CROSSFADE"
    elif [[ "$SILENCE_BETWEEN" != "0" && "$SILENCE_BETWEEN" != "0.0" ]]; then
        merge_with_silence "$SILENCE_BETWEEN"
    else
        simple_merge
    fi

    # Verify output
    if [[ -f "$OUTPUT" ]]; then
        local output_duration output_size
        output_duration=$(get_duration "$OUTPUT")
        output_size=$(du -h "$OUTPUT" | cut -f1)

        echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  ✓ Merge Complete${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
        echo "Output: $OUTPUT"
        echo "Size: $output_size"
        echo "Duration: ${output_duration}s"
    else
        echo -e "${RED}Error: Failed to create output file${NC}" >&2
        exit 1
    fi
}

main
