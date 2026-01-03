#!/usr/bin/env bash
# =============================================================================
# Text Splitter for Long TTS Files
# =============================================================================
# Chia văn bản dài thành các chunks nhỏ hơn để TTS xử lý
# - Chia theo paragraph hoặc số ký tự
# - Giữ nguyên câu (không cắt giữa câu)
# - Output: chunk_001.txt, chunk_002.txt, ...
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
OUTPUT_DIR=""
MAX_CHARS=50000          # Max characters per chunk (~30-40 min audio)
SPLIT_BY="smart"         # smart, paragraph, chars
PREFIX="chunk"
VERBOSE=false

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Split long text files into chunks for TTS processing.

Options:
    --input FILE          Input text file (required)
    --output-dir DIR      Output directory for chunks (default: input_chunks/)
    --max-chars N         Max characters per chunk (default: 50000)
    --split-by MODE       Split mode: smart, paragraph, chars (default: smart)
    --prefix PREFIX       Chunk file prefix (default: chunk)
    --verbose             Show detailed output
    -h, --help            Show this help

Split Modes:
    smart       Smart split at paragraph boundaries, respecting max-chars
    paragraph   Split by double newlines (paragraphs)
    chars       Split by character count (may cut mid-sentence)

Examples:
    $(basename "$0") --input book.txt --output-dir chapters/
    $(basename "$0") --input article.txt --max-chars 30000 --split-by smart
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
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --max-chars)
            MAX_CHARS="$2"
            shift 2
            ;;
        --split-by)
            SPLIT_BY="$2"
            shift 2
            ;;
        --prefix)
            PREFIX="$2"
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

# Validate input
if [[ -z "$INPUT" ]]; then
    echo -e "${RED}Error: --input is required${NC}" >&2
    exit 1
fi

if [[ ! -f "$INPUT" ]]; then
    echo -e "${RED}Error: Input file not found: $INPUT${NC}" >&2
    exit 1
fi

# Set default output directory
if [[ -z "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR="${INPUT%.*}_chunks"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get file stats
get_file_stats() {
    local file="$1"
    local chars lines words
    chars=$(wc -c < "$file" | tr -d ' ')
    lines=$(wc -l < "$file" | tr -d ' ')
    words=$(wc -w < "$file" | tr -d ' ')
    echo "$chars $lines $words"
}

# Smart split - split at paragraph boundaries respecting max chars
smart_split() {
    local input="$1"
    local output_dir="$2"
    local max_chars="$3"
    local prefix="$4"

    local chunk_num=1
    local current_chunk=""
    local current_size=0

    if $VERBOSE; then
        echo -e "${BLUE}Smart splitting with max $max_chars chars per chunk...${NC}" >&2
    fi

    # Read file and split by paragraphs (double newline)
    local paragraph=""
    local in_paragraph=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ -z "$line" ]]; then
            # Empty line - end of paragraph
            if [[ -n "$paragraph" ]]; then
                local para_size=${#paragraph}

                # Check if adding this paragraph exceeds limit
                if [[ $((current_size + para_size + 2)) -gt $max_chars && $current_size -gt 0 ]]; then
                    # Save current chunk
                    local chunk_file
                    chunk_file=$(printf "%s/%s_%03d.txt" "$output_dir" "$prefix" "$chunk_num")
                    echo "$current_chunk" > "$chunk_file"

                    if $VERBOSE; then
                        echo -e "  Chunk $chunk_num: $current_size chars → $chunk_file" >&2
                    fi

                    ((chunk_num++))
                    current_chunk=""
                    current_size=0
                fi

                # Add paragraph to current chunk
                if [[ -n "$current_chunk" ]]; then
                    current_chunk+=$'\n\n'
                    current_size=$((current_size + 2))
                fi
                current_chunk+="$paragraph"
                current_size=$((current_size + para_size))

                paragraph=""
            fi
        else
            # Add line to current paragraph
            if [[ -n "$paragraph" ]]; then
                paragraph+=$'\n'
            fi
            paragraph+="$line"
        fi
    done < "$input"

    # Handle last paragraph
    if [[ -n "$paragraph" ]]; then
        local para_size=${#paragraph}
        if [[ $((current_size + para_size + 2)) -gt $max_chars && $current_size -gt 0 ]]; then
            local chunk_file
            chunk_file=$(printf "%s/%s_%03d.txt" "$output_dir" "$prefix" "$chunk_num")
            echo "$current_chunk" > "$chunk_file"
            if $VERBOSE; then
                echo -e "  Chunk $chunk_num: $current_size chars → $chunk_file" >&2
            fi
            ((chunk_num++))
            current_chunk="$paragraph"
            current_size=$para_size
        else
            if [[ -n "$current_chunk" ]]; then
                current_chunk+=$'\n\n'
            fi
            current_chunk+="$paragraph"
            current_size=$((current_size + para_size))
        fi
    fi

    # Save last chunk
    if [[ -n "$current_chunk" ]]; then
        local chunk_file
        chunk_file=$(printf "%s/%s_%03d.txt" "$output_dir" "$prefix" "$chunk_num")
        echo "$current_chunk" > "$chunk_file"
        if $VERBOSE; then
            echo -e "  Chunk $chunk_num: $current_size chars → $chunk_file" >&2
        fi
    fi

    echo "$chunk_num"
}

# Paragraph split - one chunk per paragraph group
paragraph_split() {
    local input="$1"
    local output_dir="$2"
    local prefix="$3"

    if $VERBOSE; then
        echo -e "${BLUE}Splitting by paragraphs...${NC}" >&2
    fi

    # Use awk to split by double newlines
    awk -v dir="$output_dir" -v prefix="$prefix" -v verbose="$VERBOSE" '
    BEGIN { RS = "\n\n+"; chunk = 1 }
    {
        if (NF > 0) {
            filename = sprintf("%s/%s_%03d.txt", dir, prefix, chunk)
            print $0 > filename
            close(filename)
            if (verbose == "true") {
                print "  Chunk " chunk ": " length($0) " chars" > "/dev/stderr"
            }
            chunk++
        }
    }
    END { print chunk - 1 }
    ' "$input"
}

# Character split - fixed size chunks (may cut sentences)
char_split() {
    local input="$1"
    local output_dir="$2"
    local max_chars="$3"
    local prefix="$4"

    if $VERBOSE; then
        echo -e "${BLUE}Splitting by $max_chars characters...${NC}" >&2
    fi

    # Use split command
    split -b "$max_chars" -d -a 3 "$input" "${output_dir}/${prefix}_"

    # Rename to .txt and count
    local count=0
    for f in "${output_dir}/${prefix}_"*; do
        if [[ -f "$f" && ! "$f" =~ \.txt$ ]]; then
            mv "$f" "${f}.txt"
            ((count++))
        fi
    done

    echo "$count"
}

# Main execution
main() {
    local stats
    stats=$(get_file_stats "$INPUT")
    local total_chars total_lines total_words
    read -r total_chars total_lines total_words <<< "$stats"

    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Text Splitter${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo "Input: $INPUT"
    echo "  Characters: $total_chars"
    echo "  Lines: $total_lines"
    echo "  Words: $total_words"
    echo ""
    echo "Settings:"
    echo "  Max chars/chunk: $MAX_CHARS"
    echo "  Split mode: $SPLIT_BY"
    echo "  Output dir: $OUTPUT_DIR"
    echo ""

    # Check if splitting is needed
    if [[ $total_chars -le $MAX_CHARS ]]; then
        echo -e "${YELLOW}File is small enough ($total_chars chars), no split needed.${NC}"
        # Just copy the file
        cp "$INPUT" "${OUTPUT_DIR}/${PREFIX}_001.txt"
        echo -e "${GREEN}Copied to: ${OUTPUT_DIR}/${PREFIX}_001.txt${NC}"
        echo "1"
        exit 0
    fi

    # Estimate chunks
    local estimated_chunks=$(( (total_chars / MAX_CHARS) + 1 ))
    echo "Estimated chunks: ~$estimated_chunks"
    echo ""

    # Perform split
    local num_chunks
    case "$SPLIT_BY" in
        smart)
            num_chunks=$(smart_split "$INPUT" "$OUTPUT_DIR" "$MAX_CHARS" "$PREFIX")
            ;;
        paragraph)
            num_chunks=$(paragraph_split "$INPUT" "$OUTPUT_DIR" "$PREFIX")
            ;;
        chars)
            num_chunks=$(char_split "$INPUT" "$OUTPUT_DIR" "$MAX_CHARS" "$PREFIX")
            ;;
        *)
            echo -e "${RED}Unknown split mode: $SPLIT_BY${NC}" >&2
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✓ Split Complete${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo "Created $num_chunks chunks in: $OUTPUT_DIR"
    echo ""

    # List chunks
    ls -la "$OUTPUT_DIR"/${PREFIX}_*.txt 2>/dev/null | head -20

    if [[ $num_chunks -gt 20 ]]; then
        echo "... and $((num_chunks - 20)) more"
    fi
}

main
