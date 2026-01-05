# AI Tools Integration Guide

## Overview

TOEIC Content Team sử dụng stack AI tools sau:
- **Claude API**: Complex content generation
- **Ollama**: Cost-effective local LLM
- **Edge-TTS**: Text-to-speech
- **FFmpeg**: Video processing

---

## Claude API

### Configuration

```yaml
claude:
  model: claude-sonnet-4-20250514
  max_tokens: 4096
  temperature: 0.7
```

### Use Cases

| Task | Agent | Notes |
|------|-------|-------|
| Topic research | Content Planner | WebSearch + analysis |
| Script writing | Script Writer | Creative + structured |
| SEO optimization | Quality Reviewer | Metadata generation |
| Content validation | Quality Reviewer | Accuracy check |

### Best Practices

```python
# System prompt structure
system = """
You are {role} for the TOEIC Content Team.
Your task: {specific_task}
Output format: {format}
Constraints: {constraints}
"""

# Request structure
messages = [
    {"role": "system", "content": system},
    {"role": "user", "content": task_prompt}
]
```

### Rate Limiting

```yaml
rate_limits:
  requests_per_minute: 60
  tokens_per_minute: 100000

handling:
  on_rate_limit:
    - wait: exponential_backoff
    - fallback: ollama
```

---

## Ollama (Local LLM)

### Configuration

```yaml
ollama:
  model: qwen3:1.7b
  host: http://localhost:11434
  timeout: 30s
```

### Use Cases

| Task | Notes |
|------|-------|
| Simple text generation | Cost-free |
| Draft content | Fast iteration |
| Fallback for Claude | Rate limit handling |
| Batch processing | Offline capability |

### Integration

```bash
# Check Ollama status
ollama list

# Run query
ollama run qwen3:1.7b "Generate a TOEIC vocabulary example for 'accomplish'"

# API call
curl http://localhost:11434/api/generate \
  -d '{
    "model": "qwen3:1.7b",
    "prompt": "Your prompt here",
    "stream": false
  }'
```

### When to Use

```yaml
use_ollama:
  - Simple keyword generation
  - Basic text formatting
  - Draft content
  - High-volume batch tasks
  - Fallback when Claude unavailable

use_claude:
  - Complex content creation
  - Nuanced script writing
  - Quality validation
  - SEO optimization
  - Critical accuracy tasks
```

---

## Edge-TTS

### Voice Options

| Voice ID | Language | Gender | Style |
|----------|----------|--------|-------|
| vi-VN-HoaiMyNeural | Vietnamese | Female | Natural, warm |
| vi-VN-NamMinhNeural | Vietnamese | Male | Professional |
| en-US-JennyNeural | English | Female | Clear, friendly |
| en-US-GuyNeural | English | Male | Professional |

### Basic Usage

```bash
# Simple text to speech
edge-tts --voice "vi-VN-HoaiMyNeural" \
         --text "Xin chào, hôm nay chúng ta sẽ học TOEIC" \
         --write-media output.mp3

# With rate adjustment
edge-tts --voice "vi-VN-HoaiMyNeural" \
         --rate "+10%" \
         --text "..." \
         --write-media output.mp3

# With SSML for advanced control
edge-tts --voice "vi-VN-HoaiMyNeural" \
         --text "<speak><prosody rate='medium'>Your text</prosody></speak>" \
         --write-media output.mp3
```

### Mixed Language

For TOEIC content với mixed Vietnamese/English:

```python
# Strategy: Segment by language
segments = [
    {"text": "Từ vựng hôm nay là", "voice": "vi-VN-HoaiMyNeural"},
    {"text": "accomplish", "voice": "en-US-JennyNeural"},
    {"text": "có nghĩa là hoàn thành", "voice": "vi-VN-HoaiMyNeural"}
]

# Generate each segment, then combine
```

### Audio Post-Processing

```bash
# Normalize volume
ffmpeg -i input.mp3 \
       -filter:a loudnorm=I=-14:LRA=11:TP=-1.5 \
       normalized.mp3

# Combine segments
ffmpeg -f concat -safe 0 -i segments.txt \
       -c:a libmp3lame -q:a 2 \
       combined.mp3

# Add padding
ffmpeg -i input.mp3 \
       -af "adelay=500|500,apad=pad_dur=500ms" \
       padded.mp3
```

---

## FFmpeg

### Video Assembly

```bash
# Create video from images + audio
ffmpeg -framerate 1/5 \
       -i slides/%03d.png \
       -i voiceover.mp3 \
       -c:v libx264 -crf 18 -preset medium \
       -c:a aac -b:a 192k \
       -pix_fmt yuv420p \
       -shortest \
       output.mp4
```

### Resolution Handling

```bash
# Shorts (9:16)
ffmpeg -i input.mp4 \
       -vf "scale=1080:1920:force_original_aspect_ratio=decrease,\
            pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
       shorts.mp4

# Standard (16:9)
ffmpeg -i input.mp4 \
       -vf "scale=1920:1080:force_original_aspect_ratio=decrease,\
            pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
       standard.mp4
```

### Transitions

```bash
# Fade between images
ffmpeg -loop 1 -t 5 -i slide1.png \
       -loop 1 -t 5 -i slide2.png \
       -filter_complex "[0][1]xfade=transition=fade:duration=0.5:offset=4.5" \
       output.mp4

# Available transitions: fade, wipeleft, wiperight, slidedown, slideup
```

### Watermark

```bash
# Add watermark (bottom-right)
ffmpeg -i input.mp4 -i watermark.png \
       -filter_complex "overlay=W-w-20:H-h-20" \
       output.mp4
```

### Encoding Profiles

```yaml
profiles:
  high_quality:
    video:
      codec: libx264
      crf: 18
      preset: medium
      profile: high
    audio:
      codec: aac
      bitrate: 192k
    options:
      - "-movflags +faststart"
      - "-pix_fmt yuv420p"

  fast:
    video:
      codec: libx264
      crf: 23
      preset: fast
    audio:
      codec: aac
      bitrate: 128k
```

---

## Error Handling

### Fallback Chain

```yaml
fallback_chain:
  llm:
    primary: claude-sonnet
    secondary: ollama/qwen3
    tertiary: cached_response

  tts:
    primary: edge-tts
    secondary: gtts
    tertiary: skip_audio

  video:
    primary: ffmpeg
    secondary: save_intermediate
    tertiary: manual_queue
```

### Retry Logic

```python
def retry_with_backoff(func, max_retries=3, base_delay=5):
    for attempt in range(max_retries):
        try:
            return func()
        except RateLimitError:
            delay = base_delay * (2 ** attempt)
            time.sleep(delay)
        except Exception as e:
            if attempt == max_retries - 1:
                raise
    return fallback()
```

---

## Performance Optimization

### Batch Processing

```yaml
batch_config:
  videos_per_batch: 10
  parallel_audio: 3
  parallel_video: 2

# Process audio in parallel (no dependencies)
# Process video sequentially (resource intensive)
```

### Resource Management

```yaml
resources:
  claude_api:
    concurrent_requests: 5
    queue_size: 20

  ollama:
    concurrent_requests: 2
    memory_limit: 4GB

  ffmpeg:
    threads: 4
    nice: 10  # Lower priority
```

### Caching

```yaml
cache:
  claude_responses:
    enabled: true
    ttl: 24h
    key: hash(prompt)

  tts_audio:
    enabled: true
    ttl: 7d
    key: hash(text + voice + rate)

  slide_images:
    enabled: true
    ttl: 7d
    key: hash(content + template)
```
