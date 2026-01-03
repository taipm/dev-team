---
name: edge-tts
description: "Vietnamese Text-to-Speech with professional audio pipeline. Includes text normalization, speech rewriting, prosody planning, TTS generation, and audio post-processing. Produces natural, broadcast-quality Vietnamese speech."
description_vi: "Chuyển văn bản thành giọng nói tiếng Việt với pipeline chuyên nghiệp. Bao gồm chuẩn hóa văn bản, viết lại cho speech, lập kế hoạch prosody, tạo TTS, và xử lý hậu kỳ âm thanh."
license: apache-2.0
version: "1.0.0"
tags: [tts, text-to-speech, vietnamese, audio, speech, edge-tts, microsoft]
category: media-skills
created: "2026-01-02"
author: MicroAI Team
---

# Edge-TTS Skill

> Professional Vietnamese Text-to-Speech với full audio pipeline.

## Pipeline Architecture

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Raw Text   │───▶│  Normalize  │───▶│  Rewrite    │───▶│   Prosody   │───▶│    TTS      │
│             │    │  (clean)    │    │  for Speech │    │  Planning   │    │  (edge-tts) │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                                    │
                                                                                    ▼
                                                                            ┌─────────────┐
                                                                            │ Post-process│
                                                                            │   Audio     │
                                                                            └─────────────┘
```

## Quick Start

```bash
# 1. Simple TTS (full pipeline)
./scripts/tts.sh --text "Xin chào Việt Nam" --output hello.mp3

# 2. With specific voice
./scripts/tts.sh --voice vi-VN-NamMinhNeural --text "Bản tin hôm nay" --output news.mp3

# 3. From file (recommended for long text)
./scripts/tts.sh --input article.txt --output audiobook.mp3

# 4. Skip pipeline (raw TTS only)
./scripts/tts.sh --raw --text "Test nhanh" --output test.mp3
```

## Prerequisites

```bash
# Install edge-tts
pip install edge-tts

# Optional: audio post-processing
pip install pydub
brew install ffmpeg  # macOS
```

## Pipeline Stages

### Stage 1: Text Normalization (`normalize.sh`)

Chuẩn hóa văn bản đầu vào:

| Input | Output | Rule |
|-------|--------|------|
| `100.000đ` | `một trăm nghìn đồng` | Currency |
| `15/01/2025` | `ngày mười lăm tháng một năm hai không hai lăm` | Date |
| `3.14` | `ba phẩy mười bốn` | Decimal |
| `COVID-19` | `Cô vít mười chín` | Acronym |
| `Mr.` | `Mister` | Abbreviation |
| `😊` | `` | Remove emoji |
| `https://...` | `` | Remove URLs |

```bash
./scripts/normalize.sh --input raw.txt --output normalized.txt
```

### Stage 2: Rewrite for Speech (`rewrite.sh`)

Viết lại văn bản cho tự nhiên khi đọc:

| Issue | Before | After |
|-------|--------|-------|
| Long sentence | "A, B, C, D và E" | "A, B, C. Cùng với D và E" |
| Parentheses | "Python (ngôn ngữ lập trình)" | "Python, một ngôn ngữ lập trình," |
| Passive voice | "Được cho rằng..." | "Người ta cho rằng..." |
| Complex clause | "Mặc dù..., nhưng..." | "Điều này... Tuy nhiên,..." |

```bash
./scripts/rewrite.sh --input normalized.txt --output speech-ready.txt
```

### Stage 3: Prosody Planning (`prosody.sh`)

Thêm SSML markup cho ngữ điệu tự nhiên:

```xml
<!-- Input -->
Hôm nay trời đẹp quá!

<!-- Output with SSML -->
<speak>
  <prosody rate="medium" pitch="medium">
    Hôm nay trời đẹp quá!
  </prosody>
  <break time="300ms"/>
</speak>
```

**Prosody Rules:**
- Questions: pitch +10%
- Exclamations: rate +5%, pitch +15%
- Lists: pause 200ms between items
- Paragraphs: pause 500ms
- Emphasis words: rate -10%

```bash
./scripts/prosody.sh --input speech-ready.txt --output prosody.ssml
```

### Stage 4: TTS Generation (`tts-core.sh`)

Gọi Microsoft Edge TTS:

```bash
# With SSML
./scripts/tts-core.sh --ssml prosody.ssml --output raw-audio.mp3

# Plain text (no SSML)
./scripts/tts-core.sh --text "Xin chào" --output raw-audio.mp3
```

**Available Voices:**

| Voice | Gender | Style | Best For |
|-------|--------|-------|----------|
| `vi-VN-HoaiMyNeural` | Female | Warm, friendly | Audiobooks, assistants |
| `vi-VN-NamMinhNeural` | Male | Professional | News, presentations |

### Stage 5: Audio Post-processing (`postprocess.sh`)

Xử lý hậu kỳ âm thanh:

```bash
./scripts/postprocess.sh --input raw-audio.mp3 --output final.mp3 \
  --normalize \
  --remove-silence \
  --fade-in 0.5 \
  --fade-out 0.5
```

**Options:**

| Option | Description |
|--------|-------------|
| `--normalize` | Chuẩn hóa volume (-14 LUFS) |
| `--remove-silence` | Xóa khoảng lặng dài >1s |
| `--trim-silence` | Cắt silence đầu/cuối |
| `--fade-in N` | Fade in N giây |
| `--fade-out N` | Fade out N giây |
| `--speed N` | Thay đổi tốc độ (0.5-2.0) |
| `--format FORMAT` | Output format (mp3/wav/ogg) |

## Full Pipeline Script

### tts.sh - One Command

```bash
# Full pipeline (recommended)
./scripts/tts.sh \
  --input article.txt \
  --output audiobook.mp3 \
  --voice vi-VN-HoaiMyNeural \
  --normalize \
  --remove-silence

# Quick mode (skip rewrite)
./scripts/tts.sh \
  --text "Nội dung ngắn" \
  --output quick.mp3 \
  --quick

# Raw mode (TTS only, no pipeline)
./scripts/tts.sh \
  --text "Test" \
  --output test.mp3 \
  --raw
```

## Integration Patterns

### Pattern 1: Audiobook Generator

```bash
#!/bin/bash
# Generate audiobook from markdown

for chapter in chapters/*.md; do
  name=$(basename "$chapter" .md)
  ./scripts/tts.sh \
    --input "$chapter" \
    --output "audiobook/${name}.mp3" \
    --voice vi-VN-HoaiMyNeural \
    --normalize \
    --remove-silence
done

# Merge all chapters
./scripts/merge-audio.sh audiobook/*.mp3 --output full-audiobook.mp3
```

### Pattern 2: News Reader

```bash
#!/bin/bash
# Daily news TTS

./scripts/tts.sh \
  --input today-news.txt \
  --output "news-$(date +%Y%m%d).mp3" \
  --voice vi-VN-NamMinhNeural \
  --normalize
```

### Pattern 3: Batch Processing

```bash
#!/bin/bash
# Process multiple files

for file in input/*.txt; do
  name=$(basename "$file" .txt)
  ./scripts/tts.sh \
    --input "$file" \
    --output "output/${name}.mp3"
done
```

### Pattern 4: API Server (with FastAPI)

```python
# See references/api-server.md for full implementation
from fastapi import FastAPI
import subprocess

app = FastAPI()

@app.post("/tts")
async def text_to_speech(text: str, voice: str = "vi-VN-HoaiMyNeural"):
    # Call tts.sh
    result = subprocess.run([
        "./scripts/tts.sh",
        "--text", text,
        "--voice", voice,
        "--output", "output.mp3"
    ])
    return FileResponse("output.mp3")
```

## Configuration

### Environment Variables

```bash
export EDGE_TTS_VOICE="vi-VN-HoaiMyNeural"
export EDGE_TTS_RATE="+0%"          # Speed adjustment
export EDGE_TTS_PITCH="+0Hz"        # Pitch adjustment
export EDGE_TTS_VOLUME="+0%"        # Volume adjustment
export EDGE_TTS_OUTPUT_DIR="./output"
```

### Config File (`.edge-tts.yaml`)

```yaml
default_voice: vi-VN-HoaiMyNeural
pipeline:
  normalize: true
  rewrite: true
  prosody: true
  postprocess:
    normalize_audio: true
    remove_silence: true
    fade_in: 0.3
    fade_out: 0.3
output:
  format: mp3
  sample_rate: 24000
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No internet | Edge-TTS requires internet connection |
| Robotic voice | Enable full pipeline, don't use --raw |
| Weird pauses | Check text for special characters |
| Too fast/slow | Use --rate "+10%" or "-10%" |
| Clipping audio | Use --normalize in postprocess |
| Large file | Split text into chunks |

## Quality Tips

1. **Luôn dùng full pipeline** cho văn bản dài
2. **Thêm dấu câu đúng** - giúp prosody tự nhiên hơn
3. **Tránh viết tắt** - normalize sẽ expand nhưng có thể sai
4. **Chia paragraph ngắn** - tối đa 3-4 câu/đoạn
5. **Review normalized text** trước khi TTS

## References

- `references/01-ssml-guide.md` - SSML markup reference
- `references/02-normalization-rules.md` - Vietnamese text normalization
- `references/03-prosody-patterns.md` - Prosody planning patterns
- `references/04-audio-processing.md` - FFmpeg audio processing
