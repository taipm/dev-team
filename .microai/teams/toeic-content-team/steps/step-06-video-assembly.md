# Step 06: Video Assembly

```yaml
step: 6
name: video-assembly
description: Ghép audio + visuals thành video với FFmpeg
trigger: audio + visuals received
agent: video-assembler-agent
next: step-07-quality-review
checkpoint: true
loop: true
```

---

## Purpose

Video Assembler kết hợp audio và visual assets thành final video files sử dụng FFmpeg.

---

## Input

```yaml
subscribed:
  - audio.voiceover
  - visual.slides

from_audio:
  - voiceover.mp3
  - audio-timestamps.json

from_visuals:
  - slides/*.png
  - visual-manifest.json

from_knowledge:
  - ffmpeg-commands.md
  - video-formats.md
```

---

## Actions

### 1. Prepare Assembly

```yaml
preparation:
  - Parse visual manifest for timing
  - Sync với audio timestamps
  - Calculate slide durations
  - Prepare transition effects
```

### 2. Create Concat File

```txt
# concat.txt
file 'slides/01_title.png'
duration 5.0
file 'slides/02_word.png'
duration 10.0
file 'slides/03_example.png'
duration 15.0
# ... etc
```

### 3. Assemble Video

#### Shorts (9:16)

```bash
ffmpeg -f concat -safe 0 -i concat.txt \
       -i voiceover.mp3 \
       -c:v libx264 -crf 18 -preset medium \
       -c:a aac -b:a 192k \
       -vf "scale=1080:1920:force_original_aspect_ratio=decrease,\
            pad=1080:1920:(ow-iw)/2:(oh-ih)/2,\
            format=yuv420p" \
       -movflags +faststart \
       -shortest \
       shorts.mp4
```

#### Standard (16:9)

```bash
ffmpeg -f concat -safe 0 -i concat.txt \
       -i voiceover.mp3 \
       -c:v libx264 -crf 18 -preset medium \
       -c:a aac -b:a 192k \
       -vf "scale=1920:1080:force_original_aspect_ratio=decrease,\
            pad=1920:1080:(ow-iw)/2:(oh-ih)/2,\
            format=yuv420p" \
       -movflags +faststart \
       -shortest \
       standard.mp4
```

### 4. Add Transitions (Optional)

```bash
# Apply xfade transitions between slides
ffmpeg -i slide1.png -i slide2.png \
       -filter_complex "[0][1]xfade=transition=fade:duration=0.5:offset=4.5" \
       output.mp4
```

### 5. Add Watermark

```bash
ffmpeg -i assembled.mp4 -i watermark.png \
       -filter_complex "overlay=W-w-20:H-h-20:enable='between(t,0,9999)'" \
       -c:v libx264 -crf 18 \
       -c:a copy \
       watermarked.mp4
```

### 6. Generate Metadata

```yaml
video_metadata:
  video_id: {id}
  files:
    shorts:
      path: shorts.mp4
      resolution: 1080x1920
      duration_ms: {ms}
      size_bytes: {bytes}
    standard:
      path: standard.mp4
      resolution: 1920x1080
      duration_ms: {ms}
      size_bytes: {bytes}
```

---

## Output

```yaml
deliverables:
  - videos/{video_id}/shorts.mp4
  - videos/{video_id}/standard.mp4
  - videos/{video_id}/video-metadata.json

published:
  - video.shorts
  - video.standard
```

---

## Quality Gate

```yaml
validation:
  - Video files created
  - Duration matches expected
  - Audio/video synced
  - Resolution correct
  - File size reasonable
  - Plays without errors
```

---

## Encoding Profiles

```yaml
profiles:
  high_quality:
    codec: libx264
    crf: 18
    preset: medium
    profile: high
    level: "4.1"
    audio_codec: aac
    audio_bitrate: 192k
    movflags: "+faststart"

  fast:
    codec: libx264
    crf: 23
    preset: fast
    profile: main
    audio_codec: aac
    audio_bitrate: 128k
```

---

## Error Handling

```yaml
errors:
  ffmpeg_failure:
    retry: 2
    on_fail: save_intermediate

  sync_issue:
    action: realign_timestamps

  file_corruption:
    action: regenerate_from_assets

  size_too_large:
    action: increase_crf
```

---

## Checkpoint

```yaml
checkpoint:
  step: 6
  video_id: {id}
  status: complete
  shorts: {created|skipped}
  standard: {created|skipped}
  timestamp: {time}
```

---

## Handoff

→ **Step 07: Quality Review** với Quality Reviewer Agent

Pass: video.shorts, video.standard

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║               🎬 VIDEO ASSEMBLER - ASSEMBLY COMPLETE                   ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Output Files:                                                        ║
║   ├── Shorts: shorts.mp4                                              ║
║   │   ├── Resolution: 1080x1920                                       ║
║   │   ├── Duration: {duration}                                        ║
║   │   └── Size: {size}                                                ║
║   │                                                                    ║
║   └── Standard: standard.mp4                                          ║
║       ├── Resolution: 1920x1080                                       ║
║       ├── Duration: {duration}                                        ║
║       └── Size: {size}                                                ║
║                                                                        ║
║   Encoding: H.264/AAC (CRF 18)                                        ║
║   Watermark: ✓ Applied                                                ║
║   Fast Start: ✓ Enabled                                               ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Handoff to Quality Reviewer...                                    ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
