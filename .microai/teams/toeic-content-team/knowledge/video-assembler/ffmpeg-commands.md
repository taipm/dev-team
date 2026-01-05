# FFmpeg Commands Reference

> Knowledge file cho Video Assembler Agent
> Version: 1.0

---

## Video Specifications

### Shorts Format (9:16)

```yaml
shorts:
  resolution: 1080x1920
  fps: 30
  codec: h264
  profile: high
  preset: medium
  crf: 23
  audio_codec: aac
  audio_bitrate: 128k
  duration: 15-60s
  max_file_size: 10MB
```

### Standard Format (16:9)

```yaml
standard:
  resolution: 1920x1080
  fps: 30
  codec: h264
  profile: high
  preset: medium
  crf: 20
  audio_codec: aac
  audio_bitrate: 192k
  duration: 120-600s
  max_file_size: 50MB
```

---

## Basic FFmpeg Commands

### Create Video from Image Sequence

```bash
# Create video from numbered images
ffmpeg -framerate 30 -i slides/%02d-*.png \
    -c:v libx264 -profile:v high -crf 23 -preset medium \
    -pix_fmt yuv420p \
    -s 1080x1920 \
    output.mp4

# With specific duration per image
ffmpeg -framerate 1/3 -i slides/%02d-*.png \
    -c:v libx264 -r 30 -pix_fmt yuv420p \
    output.mp4
```

### Add Audio to Video

```bash
# Simple audio add
ffmpeg -i video.mp4 -i audio.mp3 \
    -c:v copy -c:a aac -b:a 128k \
    -map 0:v:0 -map 1:a:0 \
    output.mp4

# Replace audio
ffmpeg -i video.mp4 -i new_audio.mp3 \
    -c:v copy -c:a aac -b:a 128k \
    -map 0:v -map 1:a \
    -shortest \
    output.mp4
```

### Combine Image + Audio with Duration

```bash
# Single image with audio duration
ffmpeg -loop 1 -i image.png -i audio.mp3 \
    -c:v libx264 -tune stillimage -c:a aac \
    -b:a 128k -pix_fmt yuv420p \
    -shortest \
    output.mp4
```

---

## Slide-Based Video Assembly

### Method 1: Concat with Filter Complex

```bash
# Create video from slides with specific durations
ffmpeg \
    -loop 1 -t 3 -i slides/01-hook.png \
    -loop 1 -t 5 -i slides/02-word.png \
    -loop 1 -t 7 -i slides/03-definition.png \
    -loop 1 -t 7 -i slides/04-example.png \
    -loop 1 -t 5 -i slides/05-tip.png \
    -loop 1 -t 3 -i slides/06-cta.png \
    -i audio/voiceover.mp3 \
    -filter_complex \
    "[0:v][1:v][2:v][3:v][4:v][5:v]concat=n=6:v=1:a=0[outv]" \
    -map "[outv]" -map 6:a \
    -c:v libx264 -c:a aac -b:a 128k \
    -pix_fmt yuv420p \
    -shortest \
    output.mp4
```

### Method 2: Concat Demuxer

```bash
# Create concat file
cat > concat.txt << EOF
file 'slides/01-hook.mp4'
duration 3
file 'slides/02-word.mp4'
duration 5
file 'slides/03-definition.mp4'
duration 7
file 'slides/04-example.mp4'
duration 7
file 'slides/05-tip.mp4'
duration 5
file 'slides/06-cta.mp4'
duration 3
EOF

# Concat with demuxer
ffmpeg -f concat -safe 0 -i concat.txt \
    -c:v libx264 -c:a aac \
    output.mp4
```

### Method 3: Image to Video per Slide

```bash
#!/bin/bash
# Convert each slide to video with duration

DURATIONS=(3 5 7 7 5 3)  # seconds per slide
SLIDES=(hook word definition example tip cta)

for i in "${!SLIDES[@]}"; do
    ffmpeg -loop 1 -t "${DURATIONS[$i]}" \
        -i "slides/$((i+1))-${SLIDES[$i]}.png" \
        -c:v libx264 -tune stillimage \
        -pix_fmt yuv420p -r 30 \
        "slides/$((i+1))-${SLIDES[$i]}.mp4"
done

# Then concat
ffmpeg -f concat -safe 0 -i concat.txt -c copy slides_combined.mp4

# Add audio
ffmpeg -i slides_combined.mp4 -i audio/voiceover.mp3 \
    -c:v copy -c:a aac -shortest \
    final.mp4
```

---

## Video Transformations

### Resize and Crop

```bash
# Resize to 1080x1920 (Shorts)
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" output.mp4

# Convert 16:9 to 9:16 with letterbox
ffmpeg -i input_16x9.mp4 -vf "scale=1080:-1,pad=1080:1920:0:(oh-ih)/2" output_9x16.mp4

# Convert 9:16 to 16:9 with letterbox
ffmpeg -i input_9x16.mp4 -vf "scale=-1:1080,pad=1920:1080:(ow-iw)/2:0" output_16x9.mp4
```

### Add Subtitles

```bash
# Burn ASS subtitles into video
ffmpeg -i input.mp4 -vf "ass=subtitles.ass" output.mp4

# Burn SRT subtitles
ffmpeg -i input.mp4 -vf "subtitles=subtitles.srt:force_style='FontSize=24,PrimaryColour=&HFFFFFF'" output.mp4
```

### Add Watermark

```bash
# Add logo watermark
ffmpeg -i input.mp4 -i logo.png \
    -filter_complex "overlay=W-w-10:10" \
    output.mp4

# Add text watermark
ffmpeg -i input.mp4 \
    -vf "drawtext=text='TOEIC Daily':fontsize=24:fontcolor=white:x=w-tw-10:y=10" \
    output.mp4
```

---

## Audio Processing in Video

### Audio Normalization

```bash
# Normalize audio in video
ffmpeg -i input.mp4 \
    -af "loudnorm=I=-14:TP=-1.5:LRA=11" \
    -c:v copy \
    output.mp4
```

### Audio Fade

```bash
# Fade in/out audio
ffmpeg -i input.mp4 \
    -af "afade=t=in:st=0:d=0.5,afade=t=out:st=28:d=2" \
    -c:v copy \
    output.mp4
```

### Add Background Music

```bash
# Mix voiceover with background music
ffmpeg -i video.mp4 -i bgm.mp3 \
    -filter_complex "[1:a]volume=0.1[bgm];[0:a][bgm]amix=inputs=2:duration=first" \
    -c:v copy \
    output.mp4
```

---

## Video Effects

### Fade Transitions

```bash
# Add fade in/out
ffmpeg -i input.mp4 \
    -vf "fade=t=in:st=0:d=0.5,fade=t=out:st=28:d=2" \
    output.mp4
```

### Cross-Fade Between Clips

```bash
# Cross-fade two videos
ffmpeg -i clip1.mp4 -i clip2.mp4 \
    -filter_complex \
    "[0:v]fade=t=out:st=2.5:d=0.5[v0]; \
     [1:v]fade=t=in:st=0:d=0.5[v1]; \
     [v0][v1]concat=n=2:v=1:a=0" \
    output.mp4
```

---

## Quality Control Commands

### Get Video Info

```bash
# Detailed info
ffprobe -v quiet -show_format -show_streams -print_format json input.mp4

# Quick info
ffprobe -v quiet -show_entries format=duration,size,bit_rate -of csv=p=0 input.mp4
```

### Validate Output

```bash
#!/bin/bash
# validate-video.sh

VIDEO="$1"

# Check resolution
RESOLUTION=$(ffprobe -v quiet -show_entries stream=width,height -of csv=p=0 "$VIDEO" | head -1)

# Check duration
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$VIDEO")

# Check codecs
VIDEO_CODEC=$(ffprobe -v quiet -show_entries stream=codec_name -of csv=p=0 "$VIDEO" | head -1)
AUDIO_CODEC=$(ffprobe -v quiet -show_entries stream=codec_name -of csv=p=0 "$VIDEO" | tail -1)

# Check file size
FILE_SIZE=$(stat -f%z "$VIDEO" 2>/dev/null || stat -c%s "$VIDEO")

echo "Resolution: $RESOLUTION"
echo "Duration: ${DURATION}s"
echo "Video Codec: $VIDEO_CODEC"
echo "Audio Codec: $AUDIO_CODEC"
echo "File Size: $((FILE_SIZE / 1048576)) MB"
```

---

## Complete Assembly Pipeline

### Full Pipeline Script

```bash
#!/bin/bash
# assemble-video.sh
# Usage: ./assemble-video.sh <session_dir> <format: shorts|standard>

SESSION_DIR="$1"
FORMAT="${2:-shorts}"

SLIDES_DIR="$SESSION_DIR/visuals/slides"
AUDIO_FILE="$SESSION_DIR/audio/voiceover.mp3"
OUTPUT_DIR="$SESSION_DIR/videos"

mkdir -p "$OUTPUT_DIR"

# Read timing from timestamps file
TIMESTAMPS="$SESSION_DIR/audio/audio-timestamps.json"

# Step 1: Convert slides to video clips
echo "Converting slides to video clips..."
python3 slides_to_video.py "$SLIDES_DIR" "$TIMESTAMPS"

# Step 2: Concatenate slide videos
echo "Concatenating slides..."
ffmpeg -f concat -safe 0 -i "$SLIDES_DIR/concat.txt" \
    -c:v libx264 -preset medium -crf 23 \
    "$OUTPUT_DIR/slides_only.mp4"

# Step 3: Add audio
echo "Adding audio..."
ffmpeg -i "$OUTPUT_DIR/slides_only.mp4" -i "$AUDIO_FILE" \
    -c:v copy -c:a aac -b:a 128k \
    -map 0:v:0 -map 1:a:0 \
    -shortest \
    "$OUTPUT_DIR/${FORMAT}.mp4"

# Step 4: Add subtitles if available
if [ -f "$SESSION_DIR/subtitles.ass" ]; then
    echo "Adding subtitles..."
    ffmpeg -i "$OUTPUT_DIR/${FORMAT}.mp4" \
        -vf "ass=$SESSION_DIR/subtitles.ass" \
        -c:a copy \
        "$OUTPUT_DIR/${FORMAT}_subtitled.mp4"
    mv "$OUTPUT_DIR/${FORMAT}_subtitled.mp4" "$OUTPUT_DIR/${FORMAT}.mp4"
fi

# Step 5: Create alternative format if shorts
if [ "$FORMAT" = "shorts" ]; then
    echo "Creating standard (16:9) version..."
    ffmpeg -i "$OUTPUT_DIR/shorts.mp4" \
        -vf "scale=-1:1080,pad=1920:1080:(ow-iw)/2:0:black" \
        -c:a copy \
        "$OUTPUT_DIR/standard.mp4"
fi

# Step 6: Validate outputs
echo "Validating outputs..."
./validate-video.sh "$OUTPUT_DIR/${FORMAT}.mp4"

echo "Assembly complete!"
```

---

## Common Issues and Solutions

```yaml
issues:
  audio_video_desync:
    symptom: "Audio drifts from video"
    solution: |
      ffmpeg -i input.mp4 -itsoffset 0.5 -i audio.mp3 \
          -map 0:v -map 1:a -c:v copy -c:a aac output.mp4

  file_too_large:
    symptom: "Output exceeds size limit"
    solution: |
      # Increase CRF value (lower quality, smaller file)
      ffmpeg -i input.mp4 -c:v libx264 -crf 28 output.mp4

  codec_compatibility:
    symptom: "Playback issues on some devices"
    solution: |
      # Use baseline profile for maximum compatibility
      ffmpeg -i input.mp4 -c:v libx264 -profile:v baseline -level 3.0 output.mp4

  aspect_ratio_wrong:
    symptom: "Video stretched or cropped"
    solution: |
      # Force aspect ratio with padding
      ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" output.mp4
```

---

*Last updated: 2026-01-04*
