# YouTube Video Specifications

## Standard Videos (16:9 Landscape)

### Resolution Options

| Quality | Resolution | Recommended For |
|---------|------------|-----------------|
| 720p HD | 1280×720 | Draft, quick preview |
| **1080p Full HD** | 1920×1080 | **Most videos** |
| 1440p 2K | 2560×1440 | High quality content |
| **2160p 4K UHD** | 3840×2160 | **Premium content** |
| 4320p 8K | 7680×4320 | Future-proof |

### Frame Rate

| FPS | Use Case |
|-----|----------|
| 24 | Cinematic look |
| 25 | PAL standard |
| **30** | **Standard video** |
| 50 | PAL high motion |
| **60** | **Smooth animations, gaming** |

### Bitrate (SDR)

| Resolution | 30fps | 60fps |
|------------|-------|-------|
| 720p | 5 Mbps | 7.5 Mbps |
| 1080p | 8 Mbps | 12 Mbps |
| 1440p | 16 Mbps | 24 Mbps |
| 2160p (4K) | 35-45 Mbps | 53-68 Mbps |

### Bitrate (HDR)

| Resolution | 30fps | 60fps |
|------------|-------|-------|
| 1080p | 10 Mbps | 15 Mbps |
| 1440p | 20 Mbps | 30 Mbps |
| 2160p (4K) | 44-56 Mbps | 66-85 Mbps |

---

## YouTube Shorts (9:16 Vertical)

### Specifications

| Spec | Value |
|------|-------|
| **Aspect Ratio** | 9:16 (vertical) |
| **Resolution** | 1080×1920 (recommended) |
| **Max Duration** | 60 seconds |
| **Min Duration** | No minimum (15s+ recommended) |
| Format | MP4 (H.264) |

### Resolution Options for Shorts

| Quality | Resolution |
|---------|------------|
| Full HD | 1080×1920 |
| 2K QHD | 1440×2560 |
| 4K UHD | 2160×3840 |

### Shorts Best Practices

1. **Keep it short**: 15-30 seconds performs best
2. **Hook in first 2 seconds**: Grab attention immediately
3. **Large text**: Optimize for mobile viewing
4. **Vertical framing**: Content centered, key info in safe zones
5. **No letterboxing**: Fill the full vertical frame

---

## Manim Render Commands

### YouTube Standard (16:9)

```bash
# 1080p 60fps (recommended)
manim -qh scene.py SceneName

# 4K 60fps
manim -qk scene.py SceneName

# Custom bitrate (ffmpeg post-process)
ffmpeg -i input.mp4 -b:v 12M -c:a copy output.mp4
```

### YouTube Shorts (9:16)

```bash
# 1080x1920 vertical
manim -qh -r 1080,1920 scene.py SceneName

# 4K vertical
manim -qk -r 2160,3840 scene.py SceneName
```

### Quality Flag Reference

| Flag | Resolution | FPS | Aspect |
|------|------------|-----|--------|
| `-ql` | 854×480 | 15 | 16:9 |
| `-qm` | 1280×720 | 30 | 16:9 |
| `-qh` | 1920×1080 | 60 | 16:9 |
| `-qp` | 2560×1440 | 60 | 16:9 |
| `-qk` | 3840×2160 | 60 | 16:9 |

---

## File Format

### Recommended

- **Container**: MP4
- **Video Codec**: H.264
- **Audio Codec**: AAC-LC
- **Audio Bitrate**: 128-384 kbps

### Supported Formats

- MP4 (recommended)
- MOV
- AVI
- WMV
- FLV
- WebM

---

## Upload Limits

| Limit | Value |
|-------|-------|
| Max file size | 256 GB |
| Max duration | 12 hours |
| Min duration | None |

---

## Manim Config for YouTube

### manim.cfg for 1080p

```ini
[CLI]
quality = high_quality
preview = False

[video]
frame_rate = 60
pixel_width = 1920
pixel_height = 1080
```

### manim.cfg for Shorts

```ini
[CLI]
quality = high_quality
preview = False

[video]
frame_rate = 60
pixel_width = 1080
pixel_height = 1920
frame_width = 9
frame_height = 16
```

### Python Config

```python
from manim import *

# YouTube 1080p
config.frame_rate = 60
config.pixel_width = 1920
config.pixel_height = 1080
config.frame_width = 16
config.frame_height = 9

# YouTube Shorts
config.frame_rate = 60
config.pixel_width = 1080
config.pixel_height = 1920
config.frame_width = 9
config.frame_height = 16
```

---

## Post-Processing with FFmpeg

### Compress for Upload

```bash
# Standard compression
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium output.mp4

# High quality (larger file)
ffmpeg -i input.mp4 -c:v libx264 -crf 18 -preset slow output.mp4
```

### Convert to Shorts Aspect

```bash
# Crop 16:9 to 9:16 (center crop)
ffmpeg -i input.mp4 -vf "crop=ih*9/16:ih" output.mp4

# Scale and pad
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" output.mp4
```

### Add Audio

```bash
ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac output.mp4
```

---

## Checklist Before Upload

### Technical

- [ ] Resolution: 1920×1080 or 3840×2160
- [ ] Frame rate: 60fps for animations
- [ ] Format: MP4 with H.264
- [ ] File size: Under 256GB

### Content (Shorts)

- [ ] Duration: Under 60 seconds
- [ ] Aspect ratio: 9:16
- [ ] Text readable on mobile
- [ ] Hook in first 2 seconds

### Thumbnail

- Resolution: 1280×720
- Aspect ratio: 16:9
- Format: JPG, PNG, GIF
- Max size: 2MB

---

*YouTube Specs Reference - Animated Math Skill*
