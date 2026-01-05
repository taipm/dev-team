#!/bin/bash
# TOEIC Content Team - Video Quality Control Script
# Usage: ./qc-video.sh <video_path> [format: shorts|standard]

set -e

VIDEO="$1"
FORMAT="${2:-auto}"

# Auto-detect format based on duration
if [ "$FORMAT" = "auto" ]; then
    TEMP_DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$VIDEO" 2>/dev/null | cut -d. -f1)
    if [ "$TEMP_DURATION" -le 60 ]; then
        FORMAT="shorts"
    else
        FORMAT="standard"
    fi
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              TOEIC VIDEO QUALITY CONTROL                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

if [ -z "$VIDEO" ]; then
    echo -e "${RED}ERROR: No video file specified${NC}"
    echo "Usage: $0 <video_path> [shorts|standard]"
    exit 1
fi

if [ ! -f "$VIDEO" ]; then
    echo -e "${RED}ERROR: Video file not found: $VIDEO${NC}"
    exit 1
fi

echo "📹 Video: $VIDEO"
echo "📐 Format: $FORMAT"
echo ""

# Initialize score
SCORE=100
ISSUES=""

# Get video info
INFO=$(ffprobe -v quiet -show_format -show_streams "$VIDEO" 2>/dev/null)

# Extract values
WIDTH=$(echo "$INFO" | grep "^width=" | head -1 | cut -d= -f2)
HEIGHT=$(echo "$INFO" | grep "^height=" | head -1 | cut -d= -f2)
DURATION=$(echo "$INFO" | grep "^duration=" | head -1 | cut -d= -f2 | cut -d. -f1)
BITRATE=$(echo "$INFO" | grep "^bit_rate=" | head -1 | cut -d= -f2)
FILESIZE=$(stat -f%z "$VIDEO" 2>/dev/null || stat -c%s "$VIDEO" 2>/dev/null)
CODEC_V=$(echo "$INFO" | grep "^codec_name=" | head -1 | cut -d= -f2)
CODEC_A=$(echo "$INFO" | grep "^codec_name=" | tail -1 | cut -d= -f2)
SAMPLE_RATE=$(echo "$INFO" | grep "^sample_rate=" | head -1 | cut -d= -f2)

echo "═══════════════════════════════════════════════════════════════"
echo "                        SPECIFICATIONS"
echo "═══════════════════════════════════════════════════════════════"
printf "%-20s: %s x %s\n" "Resolution" "$WIDTH" "$HEIGHT"
printf "%-20s: %s seconds\n" "Duration" "$DURATION"
printf "%-20s: %s bps\n" "Bitrate" "$BITRATE"
printf "%-20s: %s bytes (%.2f MB)\n" "File Size" "$FILESIZE" "$(echo "scale=2; $FILESIZE / 1048576" | bc)"
printf "%-20s: %s\n" "Video Codec" "$CODEC_V"
printf "%-20s: %s\n" "Audio Codec" "$CODEC_A"
printf "%-20s: %s Hz\n" "Sample Rate" "$SAMPLE_RATE"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "                        QC CHECKS"
echo "═══════════════════════════════════════════════════════════════"

# Check 1: Resolution (accept both 9:16 and 16:9 for standard format)
if [ "$FORMAT" = "shorts" ]; then
    if [ "$WIDTH" = "1080" ] && [ "$HEIGHT" = "1920" ]; then
        echo -e "${GREEN}✓${NC} [T1] Resolution: 1080x1920 (9:16 Shorts)"
    else
        echo -e "${RED}✗${NC} [T1] Resolution: Expected 1080x1920, got ${WIDTH}x${HEIGHT}"
        SCORE=$((SCORE - 25))
        ISSUES="${ISSUES}T1: Wrong resolution for Shorts\n"
    fi
else
    # Standard format accepts both 16:9 and 9:16 (vertical videos for mobile)
    if [ "$WIDTH" = "1920" ] && [ "$HEIGHT" = "1080" ]; then
        echo -e "${GREEN}✓${NC} [T1] Resolution: 1920x1080 (16:9 Standard)"
    elif [ "$WIDTH" = "1080" ] && [ "$HEIGHT" = "1920" ]; then
        echo -e "${GREEN}✓${NC} [T1] Resolution: 1080x1920 (9:16 Vertical Standard)"
    else
        echo -e "${RED}✗${NC} [T1] Resolution: Expected 1920x1080 or 1080x1920, got ${WIDTH}x${HEIGHT}"
        SCORE=$((SCORE - 25))
        ISSUES="${ISSUES}T1: Wrong resolution for Standard\n"
    fi
fi

# Check 2: Duration
if [ "$FORMAT" = "shorts" ]; then
    if [ "$DURATION" -ge 15 ] && [ "$DURATION" -le 60 ]; then
        echo -e "${GREEN}✓${NC} [T2] Duration: ${DURATION}s (15-60s for Shorts)"
    else
        echo -e "${YELLOW}!${NC} [T2] Duration: ${DURATION}s (outside 15-60s range)"
        SCORE=$((SCORE - 10))
        ISSUES="${ISSUES}T2: Duration outside Shorts range\n"
    fi
else
    if [ "$DURATION" -ge 120 ] && [ "$DURATION" -le 600 ]; then
        echo -e "${GREEN}✓${NC} [T2] Duration: ${DURATION}s (2-10min for Standard)"
    else
        echo -e "${YELLOW}!${NC} [T2] Duration: ${DURATION}s (outside 2-10min range)"
        SCORE=$((SCORE - 10))
        ISSUES="${ISSUES}T2: Duration outside Standard range\n"
    fi
fi

# Check 3: Video Codec
if [ "$CODEC_V" = "h264" ]; then
    echo -e "${GREEN}✓${NC} [T3] Video Codec: H.264"
else
    echo -e "${RED}✗${NC} [T3] Video Codec: Expected h264, got $CODEC_V"
    SCORE=$((SCORE - 15))
    ISSUES="${ISSUES}T3: Non-standard video codec\n"
fi

# Check 4: Audio Codec
if [ "$CODEC_A" = "aac" ]; then
    echo -e "${GREEN}✓${NC} [T4] Audio Codec: AAC"
else
    echo -e "${RED}✗${NC} [T4] Audio Codec: Expected aac, got $CODEC_A"
    SCORE=$((SCORE - 15))
    ISSUES="${ISSUES}T4: Non-standard audio codec\n"
fi

# Check 5: File size
MAX_SIZE_MB=10
if [ "$FORMAT" = "standard" ]; then
    MAX_SIZE_MB=50
fi
MAX_SIZE=$((MAX_SIZE_MB * 1048576))

if [ "$FILESIZE" -le "$MAX_SIZE" ]; then
    echo -e "${GREEN}✓${NC} [T5] File Size: $(echo "scale=2; $FILESIZE / 1048576" | bc) MB (max ${MAX_SIZE_MB}MB)"
else
    echo -e "${YELLOW}!${NC} [T5] File Size: $(echo "scale=2; $FILESIZE / 1048576" | bc) MB (exceeds ${MAX_SIZE_MB}MB)"
    SCORE=$((SCORE - 10))
    ISSUES="${ISSUES}T5: File size too large\n"
fi

# Check 6: Bitrate (sanity check)
if [ "$BITRATE" -ge 50000 ]; then
    echo -e "${GREEN}✓${NC} [T6] Bitrate: ${BITRATE} bps (adequate)"
else
    echo -e "${YELLOW}!${NC} [T6] Bitrate: ${BITRATE} bps (may be too low)"
    SCORE=$((SCORE - 10))
    ISSUES="${ISSUES}T6: Low bitrate\n"
fi

# Check related files
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "                     RELATED FILES"
echo "═══════════════════════════════════════════════════════════════"

DIR=$(dirname "$VIDEO")
BASE=$(basename "$VIDEO" .mp4)

# Check for thumbnail
if [ -f "$DIR/thumbnail.png" ]; then
    echo -e "${GREEN}✓${NC} thumbnail.png found"
else
    echo -e "${YELLOW}!${NC} thumbnail.png missing"
    SCORE=$((SCORE - 10))
    ISSUES="${ISSUES}Missing thumbnail\n"
fi

# Check for metadata
if [ -f "$DIR/metadata.json" ]; then
    echo -e "${GREEN}✓${NC} metadata.json found"
else
    echo -e "${YELLOW}!${NC} metadata.json missing"
    SCORE=$((SCORE - 10))
    ISSUES="${ISSUES}Missing metadata\n"
fi

# Check for subtitles
if [ -f "$DIR/subtitles.ass" ] || [ -f "$DIR/subtitles-v5.ass" ]; then
    echo -e "${GREEN}✓${NC} subtitles.ass found"
else
    echo -e "${YELLOW}!${NC} subtitles.ass missing"
fi

# Check for tagged segments
if [ -f "$DIR/tagged-segments.yaml" ]; then
    echo -e "${GREEN}✓${NC} tagged-segments.yaml found"
else
    echo -e "${YELLOW}!${NC} tagged-segments.yaml missing"
fi

# Final Score
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "                        FINAL SCORE"
echo "═══════════════════════════════════════════════════════════════"

if [ $SCORE -ge 90 ]; then
    GRADE="A"
    COLOR=$GREEN
    ACTION="✅ PUBLISH IMMEDIATELY"
elif [ $SCORE -ge 80 ]; then
    GRADE="B"
    COLOR=$GREEN
    ACTION="✅ PUBLISH WITH MINOR NOTES"
elif [ $SCORE -ge 60 ]; then
    GRADE="C"
    COLOR=$YELLOW
    ACTION="⚠️ REVIEW AND FIX ISSUES"
else
    GRADE="F"
    COLOR=$RED
    ACTION="❌ QUARANTINE - MAJOR REWORK NEEDED"
fi

echo ""
printf "Score: ${COLOR}%d/100${NC} (Grade: ${COLOR}%s${NC})\n" "$SCORE" "$GRADE"
echo ""
echo "Action: $ACTION"

if [ -n "$ISSUES" ]; then
    echo ""
    echo "Issues found:"
    echo -e "$ISSUES"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"

# Return exit code based on pass/fail
if [ $SCORE -ge 80 ]; then
    exit 0
else
    exit 1
fi
