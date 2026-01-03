#!/usr/bin/env bash
# =============================================================================
# Long Text TTS Pipeline
# =============================================================================
# Xử lý file văn bản dài bằng cách:
# 1. Tự động chia nhỏ thành chunks
# 2. TTS từng chunk song song hoặc tuần tự
# 3. Merge tất cả thành một file audio
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
MAX_CHARS=50000          # ~30-40 minutes per chunk
PARALLEL=false           # Process chunks in parallel
MAX_PARALLEL=3           # Max parallel jobs
SILENCE_BETWEEN=0.5      # Silence between chunks
KEEP_CHUNKS=false        # Keep intermediate files
VERBOSE=false

# Pipeline options (passed to tts.sh)
NORMALIZE=false
REMOVE_SILENCE=false
FADE_IN=0
FADE_OUT=0

usage() {
    cat << EOF
${CYAN}╔══════════════════════════════════════════════════════════════════╗
║          Long Text TTS - Audiobook Generator                        ║
╚══════════════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Usage:${NC} $(basename "$0") --input FILE --output FILE [OPTIONS]

${YELLOW}Required:${NC}
    --input FILE          Input text file

${YELLOW}Output:${NC}
    --output FILE         Output audio file (default: output.mp3)

${YELLOW}Voice:${NC}
    --voice VOICE         Voice name (default: vi-VN-HoaiMyNeural)

${YELLOW}Chunking:${NC}
    --max-chars N         Max characters per chunk (default: 50000)
    --silence N           Silence between chunks in seconds (default: 0.5)

${YELLOW}Performance:${NC}
    --parallel            Process chunks in parallel
    --max-parallel N      Max parallel jobs (default: 3)

${YELLOW}Audio Processing:${NC}
    --normalize           Normalize final audio volume
    --remove-silence      Remove long silences
    --fade-in N           Fade in duration (seconds)
    --fade-out N          Fade out duration (seconds)

${YELLOW}Other:${NC}
    --keep-chunks         Keep intermediate chunk files
    --verbose             Show detailed progress
    -h, --help            Show this help

${YELLOW}Examples:${NC}
    # Basic audiobook generation
    $(basename "$0") --input book.txt --output audiobook.mp3

    # With male voice and normalization
    $(basename "$0") --input story.txt --output story.mp3 \\
        --voice vi-VN-NamMinhNeural --normalize --fade-in 0.5 --fade-out 1

    # Parallel processing for speed
    $(basename "$0") --input long-book.txt --output book.mp3 --parallel

${YELLOW}Estimated Time:${NC}
    ~50,000 chars ≈ 30-40 minutes audio ≈ 2-3 min processing
    A 100-page book (~200,000 chars) ≈ 2-3 hours audio ≈ 10-15 min processing
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
        --voice)
            VOICE="$2"
            shift 2
            ;;
        --max-chars)
            MAX_CHARS="$2"
            shift 2
            ;;
        --silence)
            SILENCE_BETWEEN="$2"
            shift 2
            ;;
        --parallel)
            PARALLEL=true
            shift
            ;;
        --max-parallel)
            MAX_PARALLEL="$2"
            shift 2
            ;;
        --normalize)
            NORMALIZE=true
            shift
            ;;
        --remove-silence)
            REMOVE_SILENCE=true
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
        --keep-chunks)
            KEEP_CHUNKS=true
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

# Process a single chunk
process_chunk() {
    local chunk_file="$1"
    local audio_file="$2"
    local chunk_num="$3"
    local total_chunks="$4"

    echo -e "${BLUE}  [$chunk_num/$total_chunks] Processing $(basename "$chunk_file")...${NC}" >&2

    # Build tts.sh command
    local tts_args=(
        --input "$chunk_file"
        --output "$audio_file"
        --voice "$VOICE"
        --quick  # Skip rewrite for speed on chunks
    )

    # Run TTS
    "$SCRIPT_DIR/tts.sh" "${tts_args[@]}" 2>/dev/null

    if [[ -f "$audio_file" ]]; then
        local duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file" 2>/dev/null || echo "?")
        echo -e "${GREEN}  [$chunk_num/$total_chunks] Done: $(basename "$audio_file") (${duration}s)${NC}" >&2
    else
        echo -e "${RED}  [$chunk_num/$total_chunks] Failed: $(basename "$chunk_file")${NC}" >&2
        return 1
    fi
}

# Main execution
main() {
    # Get file stats
    local total_chars
    total_chars=$(wc -c < "$INPUT" | tr -d ' ')

    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Long Text TTS Pipeline${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Input: $INPUT ($total_chars characters)"
    echo "Output: $OUTPUT"
    echo "Voice: $VOICE"
    echo ""

    # Create temp directory
    local temp_dir
    temp_dir=$(mktemp -d)
    local chunks_dir="${temp_dir}/chunks"
    local audio_dir="${temp_dir}/audio"
    mkdir -p "$chunks_dir" "$audio_dir"

    # Check if splitting is needed
    if [[ $total_chars -le $MAX_CHARS ]]; then
        echo -e "${YELLOW}File is small enough, processing directly...${NC}"

        # Build tts.sh command
        local tts_args=(
            --input "$INPUT"
            --output "$OUTPUT"
            --voice "$VOICE"
        )

        $NORMALIZE && tts_args+=(--normalize)
        $REMOVE_SILENCE && tts_args+=(--remove-silence)
        [[ "$FADE_IN" != "0" ]] && tts_args+=(--fade-in "$FADE_IN")
        [[ "$FADE_OUT" != "0" ]] && tts_args+=(--fade-out "$FADE_OUT")
        $VERBOSE && tts_args+=(--verbose)

        "$SCRIPT_DIR/tts.sh" "${tts_args[@]}"

        rm -rf "$temp_dir"
        exit 0
    fi

    # Estimate
    local estimated_chunks=$(( (total_chars / MAX_CHARS) + 1 ))
    local estimated_duration=$(( total_chars / 20 ))  # ~20 chars/second
    local estimated_hours=$((estimated_duration / 3600))
    local estimated_mins=$(( (estimated_duration % 3600) / 60 ))

    echo "Estimated chunks: $estimated_chunks"
    echo "Estimated audio: ${estimated_hours}h ${estimated_mins}m"
    echo ""

    # Step 1: Split text
    echo -e "${BLUE}[1/3] Splitting text into chunks...${NC}"
    "$SCRIPT_DIR/split.sh" \
        --input "$INPUT" \
        --output-dir "$chunks_dir" \
        --max-chars "$MAX_CHARS" \
        --split-by smart \
        $(if $VERBOSE; then echo "--verbose"; fi) 2>/dev/null

    # Count chunks
    local chunk_files=("$chunks_dir"/chunk_*.txt)
    local num_chunks=${#chunk_files[@]}
    echo -e "${GREEN}  Created $num_chunks chunks${NC}"
    echo ""

    # Step 2: Process each chunk
    echo -e "${BLUE}[2/3] Generating audio for each chunk...${NC}"

    if $PARALLEL; then
        echo -e "  Mode: Parallel (max $MAX_PARALLEL jobs)"

        # Use GNU parallel or xargs for parallel processing
        local i=1
        for chunk_file in "${chunk_files[@]}"; do
            local audio_file="${audio_dir}/$(basename "${chunk_file%.txt}").mp3"
            # Run in background
            process_chunk "$chunk_file" "$audio_file" "$i" "$num_chunks" &

            # Limit parallel jobs
            if [[ $(jobs -r | wc -l) -ge $MAX_PARALLEL ]]; then
                wait -n
            fi
            ((i++))
        done
        # Wait for all to complete
        wait
    else
        echo -e "  Mode: Sequential"
        local i=1
        for chunk_file in "${chunk_files[@]}"; do
            local audio_file="${audio_dir}/$(basename "${chunk_file%.txt}").mp3"
            process_chunk "$chunk_file" "$audio_file" "$i" "$num_chunks"
            ((i++))
        done
    fi

    echo ""

    # Step 3: Merge audio files
    echo -e "${BLUE}[3/3] Merging audio chunks...${NC}"

    local merge_args=(
        --input-dir "$audio_dir"
        --pattern "*.mp3"
        --output "$OUTPUT"
        --silence "$SILENCE_BETWEEN"
    )
    $VERBOSE && merge_args+=(--verbose)

    "$SCRIPT_DIR/merge-audio.sh" "${merge_args[@]}" 2>/dev/null

    # Step 4: Post-process final audio (if requested)
    if $NORMALIZE || $REMOVE_SILENCE || [[ "$FADE_IN" != "0" ]] || [[ "$FADE_OUT" != "0" ]]; then
        echo ""
        echo -e "${BLUE}[4/4] Post-processing final audio...${NC}"

        local temp_output="${temp_dir}/final_raw.mp3"
        mv "$OUTPUT" "$temp_output"

        local postprocess_args=(
            --input "$temp_output"
            --output "$OUTPUT"
        )
        $NORMALIZE && postprocess_args+=(--normalize)
        $REMOVE_SILENCE && postprocess_args+=(--remove-silence)
        [[ "$FADE_IN" != "0" ]] && postprocess_args+=(--fade-in "$FADE_IN")
        [[ "$FADE_OUT" != "0" ]] && postprocess_args+=(--fade-out "$FADE_OUT")
        $VERBOSE && postprocess_args+=(--verbose)

        "$SCRIPT_DIR/postprocess.sh" "${postprocess_args[@]}" 2>/dev/null
    fi

    # Keep chunks if requested
    if $KEEP_CHUNKS; then
        local keep_dir="${OUTPUT%.*}_chunks"
        mkdir -p "$keep_dir"
        cp -r "$chunks_dir"/* "$keep_dir/"
        cp -r "$audio_dir"/* "$keep_dir/"
        echo -e "${YELLOW}Chunks saved to: $keep_dir${NC}"
    fi

    # Cleanup
    rm -rf "$temp_dir"

    # Final output
    if [[ -f "$OUTPUT" ]]; then
        local final_duration final_size
        final_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT" 2>/dev/null || echo "?")
        final_size=$(du -h "$OUTPUT" | cut -f1)

        # Convert to hours:minutes:seconds
        local hours mins secs
        hours=$(echo "$final_duration / 3600" | bc)
        mins=$(echo "($final_duration % 3600) / 60" | bc)
        secs=$(echo "$final_duration % 60" | bc)

        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  ✓ Audiobook Generation Complete${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "Output: ${CYAN}$OUTPUT${NC}"
        echo -e "Size: $final_size"
        printf "Duration: %02d:%02d:%02d\n" "$hours" "$mins" "${secs%.*}"
        echo -e "Chunks processed: $num_chunks"
    else
        echo -e "${RED}Error: Failed to create output file${NC}" >&2
        exit 1
    fi
}

main
