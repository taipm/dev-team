# Step 07b: YouTube Shorts Generation

## Purpose
🎬 Tạo vertical video cho YouTube Shorts từ main video.

## Agent
**render-engineer** (🎬)

## Trigger
Step 07 (Final Render) completed với ít nhất 720p video.

## Actions

### 1. Analyze Best Segment
```python
# Xác định segment hay nhất (thường là climax)
# Cho 90s video:
# - Intro (0-10s): Skip
# - Build (10-40s): Good for some topics
# - Climax (40-75s): BEST - most action
# - Outro (75-90s): Skip

recommended_start = 25  # seconds
recommended_duration = 45  # seconds (sweet spot for Shorts)
```

### 2. Generate Shorts
```bash
# Using shorts-generator template
python3 templates/shorts-generator.py \
  "$WORKSPACE/output/{topic}_720p.mp4" \
  "$WORKSPACE/output/{topic}_shorts.mp4" \
  "$WORKSPACE/output/background_music.m4a" \
  "{Topic Title}"
```

Hoặc manual FFmpeg:
```bash
ffmpeg -y \
  -ss 25 -t 45 \
  -i "$WORKSPACE/output/{topic}_720p.mp4" \
  -ss 25 -t 45 \
  -i "$WORKSPACE/output/background_music.m4a" \
  -vf "scale=1920:-1,crop=1080:1920:(iw-1080)/2:(ih-1920)/2,\
       drawtext=text='{TOPIC}':fontsize=60:fontcolor=white:\
       borderw=3:bordercolor=black:x=(w-text_w)/2:y=80" \
  -c:v libx264 -preset medium -crf 18 -r 30 \
  -c:a aac -b:a 128k \
  -map 0:v:0 -map 1:a:0 \
  -movflags +faststart \
  "$WORKSPACE/output/{topic}_shorts.mp4"
```

### 3. Validate Shorts
```bash
ffprobe -v error \
  -show_entries stream=width,height,r_frame_rate \
  -show_entries format=duration \
  -of default=noprint_wrappers=1 \
  "$WORKSPACE/output/{topic}_shorts.mp4"

# Expected:
# width=1080
# height=1920
# r_frame_rate=30/1
# duration=45.000000
```

### 4. Log Completion
```
🎬 SHORTS GENERATED
├── File: {topic}_shorts.mp4
├── Resolution: 1080x1920 (9:16)
├── Duration: 45s
├── Segment: 25s - 70s from main
├── Title overlay: {topic}
└── Audio: Included

YouTube Shorts ready!
```

## Shorts Best Practices

### Content Selection
| Topic Type | Best Segment | Why |
|------------|--------------|-----|
| Fractals (zoom) | 30-75s | Maximum detail |
| Morphing | 25-70s | Most transformation |
| Physics (chaos) | 20-65s | Full divergence visible |
| Curves | 15-60s | Complete pattern |

### Visual Adjustments
- **Zoom in** slightly (vì crop sẽ mất edges)
- **Center focus** - đảm bảo action ở giữa
- **Bold title** - nhỏ gọn, dễ đọc trên mobile
- **No small text** - YouTube Shorts xem trên điện thoại

### Audio for Shorts
- **Louder** hơn main video một chút
- **Faster tempo** nếu có thể
- **Hook trong 3s đầu** - giữ chân viewer

## Transition
→ Step 08: Quality Check (include Shorts validation)

## Error Handling
- Crop failed: Adjust scale factor
- Duration mismatch: Trim precisely
- No audio: Generate silent or use video audio
