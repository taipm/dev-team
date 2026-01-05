# Video Formats & Platform Requirements

> Knowledge file cho Video Assembler Agent
> Version: 1.0

---

## Platform Specifications

### YouTube Shorts

```yaml
youtube_shorts:
  resolution:
    required: "1080x1920 (9:16)"
    alternatives:
      - "720x1280"
      - "1080x1350 (4:5)"

  duration:
    minimum: 15s
    maximum: 60s
    recommended: 30-45s

  file:
    format: MP4
    codec: H.264
    audio_codec: AAC
    max_size: 256MB (but aim for <10MB)

  frame_rate:
    minimum: 24fps
    recommended: 30fps
    maximum: 60fps

  bitrate:
    video: 5-8 Mbps
    audio: 128-192 kbps

  upload_settings:
    category: "27"  # Education
    made_for_kids: false
    default_language: "vi"
```

### YouTube Standard

```yaml
youtube_standard:
  resolution:
    recommended: "1920x1080 (16:9)"
    alternatives:
      - "1280x720"
      - "2560x1440"
      - "3840x2160"

  duration:
    minimum: "No limit"
    recommended: "3-10 minutes for education"
    maximum: "12 hours (verified accounts)"

  file:
    format: MP4
    codec: H.264 or H.265
    audio_codec: AAC
    max_size: 256GB

  frame_rate:
    options: [24, 25, 30, 48, 50, 60]
    recommended: 30fps

  bitrate:
    720p: 5 Mbps
    1080p: 8 Mbps
    1440p: 16 Mbps
    2160p: 35-45 Mbps
```

### TikTok

```yaml
tiktok:
  resolution:
    recommended: "1080x1920 (9:16)"
    minimum: "720x1280"

  duration:
    standard: 15s, 60s
    extended: up to 3 minutes
    long_form: up to 10 minutes

  file:
    format: MP4, MOV
    codec: H.264
    max_size: 287.6MB (web), 72MB (mobile)

  frame_rate:
    recommended: 30fps

  aspect_ratio:
    recommended: "9:16"
    supported: ["9:16", "1:1", "16:9"]
```

### Facebook/Instagram Reels

```yaml
facebook_reels:
  resolution:
    recommended: "1080x1920 (9:16)"
    minimum: "540x960"

  duration:
    minimum: 3s
    maximum: 60s (Reels), 90s (Instagram)

  file:
    format: MP4, MOV
    codec: H.264
    max_size: 4GB

  frame_rate:
    minimum: 23fps
    maximum: 60fps
```

---

## Output Format Specifications

### Shorts Output (Primary)

```yaml
shorts_output:
  filename: "shorts.mp4"
  specifications:
    resolution: 1080x1920
    fps: 30
    codec: libx264
    profile: high
    level: "4.0"
    crf: 23
    preset: medium
    pixel_format: yuv420p

    audio:
      codec: aac
      bitrate: 128k
      sample_rate: 44100
      channels: 1

  target_size: "<10MB"
  target_duration: "30-60s"

  ffmpeg_command: |
    ffmpeg -i input.mp4 \
        -c:v libx264 -profile:v high -level 4.0 \
        -crf 23 -preset medium \
        -pix_fmt yuv420p \
        -c:a aac -b:a 128k -ar 44100 -ac 1 \
        -movflags +faststart \
        shorts.mp4
```

### Standard Output (Secondary)

```yaml
standard_output:
  filename: "standard.mp4"
  specifications:
    resolution: 1920x1080
    fps: 30
    codec: libx264
    profile: high
    level: "4.1"
    crf: 20
    preset: medium
    pixel_format: yuv420p

    audio:
      codec: aac
      bitrate: 192k
      sample_rate: 44100
      channels: 2

  target_size: "<50MB"

  # Convert from shorts (9:16) to standard (16:9)
  conversion_command: |
    ffmpeg -i shorts.mp4 \
        -vf "scale=-1:1080,pad=1920:1080:(ow-iw)/2:0:black" \
        -c:v libx264 -profile:v high -crf 20 \
        -c:a copy \
        -movflags +faststart \
        standard.mp4
```

---

## Aspect Ratio Handling

### 9:16 to 16:9 Conversion

```yaml
vertical_to_horizontal:
  method: letterbox
  description: "Add black bars on sides"
  command: |
    ffmpeg -i input_9x16.mp4 \
        -vf "scale=-1:1080,pad=1920:1080:(ow-iw)/2:0:black" \
        output_16x9.mp4

  alternative_method: blur_background
  description: "Blurred version as background"
  command: |
    ffmpeg -i input.mp4 \
        -filter_complex \
        "[0:v]scale=1920:1080,boxblur=20[bg]; \
         [0:v]scale=-1:1080[fg]; \
         [bg][fg]overlay=(W-w)/2:(H-h)/2" \
        output.mp4
```

### 16:9 to 9:16 Conversion

```yaml
horizontal_to_vertical:
  method: letterbox
  description: "Add black bars on top/bottom"
  command: |
    ffmpeg -i input_16x9.mp4 \
        -vf "scale=1080:-1,pad=1080:1920:0:(oh-ih)/2:black" \
        output_9x16.mp4

  alternative_method: center_crop
  description: "Crop to vertical (may lose content)"
  command: |
    ffmpeg -i input.mp4 \
        -vf "crop=ih*9/16:ih,scale=1080:1920" \
        output.mp4
```

---

## Thumbnail Specifications

```yaml
thumbnail:
  youtube:
    resolution: 1280x720
    aspect_ratio: "16:9"
    format: JPG, PNG, GIF
    max_size: 2MB

  shorts_thumbnail:
    resolution: 1080x1920
    aspect_ratio: "9:16"
    note: "YouTube auto-generates, but can upload custom"

  generation_command: |
    # Extract frame from video as thumbnail
    ffmpeg -i video.mp4 -ss 00:00:02 -vframes 1 \
        -vf "scale=1280:720" \
        thumbnail.jpg

    # For shorts (9:16)
    ffmpeg -i shorts.mp4 -ss 00:00:02 -vframes 1 \
        -vf "scale=1080:1920" \
        thumbnail_shorts.png
```

---

## Codec Compatibility Matrix

```yaml
codec_compatibility:
  h264:
    support: "Universal"
    profiles:
      baseline: "Maximum compatibility, mobile"
      main: "Good quality, wide support"
      high: "Best quality, most devices"
    recommendation: "Use High profile for YouTube"

  h265_hevc:
    support: "Growing"
    pros: "50% smaller file size"
    cons: "Less device compatibility"
    recommendation: "Use for archival, not distribution"

  vp9:
    support: "Web browsers, YouTube"
    pros: "Good compression, royalty-free"
    cons: "Slower encoding"
    recommendation: "Optional for web"

  audio_codecs:
    aac: "Universal, recommended"
    mp3: "Good compatibility"
    opus: "Modern, smaller files"
```

---

## Quality Presets

### Fast Production (Draft)

```yaml
draft_preset:
  use_case: "Quick preview, internal review"
  command: |
    ffmpeg -i input.mp4 \
        -c:v libx264 -preset ultrafast -crf 28 \
        -c:a aac -b:a 96k \
        draft.mp4

  expected_quality: "Low-Medium"
  encoding_speed: "Very Fast"
```

### Balanced (Standard)

```yaml
balanced_preset:
  use_case: "Normal production"
  command: |
    ffmpeg -i input.mp4 \
        -c:v libx264 -preset medium -crf 23 \
        -c:a aac -b:a 128k \
        standard.mp4

  expected_quality: "Good"
  encoding_speed: "Medium"
```

### High Quality (Final)

```yaml
high_quality_preset:
  use_case: "Final output, archive"
  command: |
    ffmpeg -i input.mp4 \
        -c:v libx264 -preset slow -crf 18 \
        -c:a aac -b:a 192k \
        high_quality.mp4

  expected_quality: "Excellent"
  encoding_speed: "Slow"
```

---

## File Size Optimization

```yaml
size_optimization:
  strategies:
    reduce_crf:
      description: "Increase CRF value (lower quality)"
      range: "18-28"
      tradeoff: "Visible quality loss above 26"

    reduce_bitrate:
      description: "Cap maximum bitrate"
      command: "-maxrate 5M -bufsize 10M"

    two_pass_encoding:
      description: "Better quality at target size"
      command: |
        ffmpeg -i input.mp4 -c:v libx264 -b:v 3M -pass 1 -f null /dev/null
        ffmpeg -i input.mp4 -c:v libx264 -b:v 3M -pass 2 output.mp4

  target_sizes:
    shorts: "<10MB for fast loading"
    standard_3min: "<30MB"
    standard_10min: "<100MB"
```

---

## Delivery Package

### Output Directory Structure

```
output/
├── shorts.mp4              # Primary vertical (9:16)
├── standard.mp4            # Secondary horizontal (16:9)
├── thumbnail.png           # Thumbnail image
├── metadata.json           # Platform metadata
├── subtitles.ass           # Subtitles file
└── qc-report.json          # Quality check results
```

### Metadata JSON Format

```json
{
  "title": "10 Từ Vựng TOEIC Hay Gặp | Học Trong 60s",
  "description": "...",
  "tags": ["TOEIC", "vocabulary", "..."],
  "category": "27",
  "default_language": "vi",
  "made_for_kids": false,
  "visibility": "public",
  "schedule": null,

  "files": {
    "shorts": "shorts.mp4",
    "standard": "standard.mp4",
    "thumbnail": "thumbnail.png",
    "subtitles": "subtitles.ass"
  },

  "technical": {
    "shorts": {
      "resolution": "1080x1920",
      "duration": 30,
      "file_size_mb": 8.5
    },
    "standard": {
      "resolution": "1920x1080",
      "duration": 30,
      "file_size_mb": 12.3
    }
  }
}
```

---

*Last updated: 2026-01-04*
