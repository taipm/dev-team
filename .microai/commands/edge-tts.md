---
name: edge-tts
description: "Vietnamese Text-to-Speech với pipeline chuyên nghiệp - tạo audio chất lượng broadcast"
description_vi: "Chuyển văn bản thành giọng nói tiếng Việt chất lượng cao"
---

# Edge-TTS Command

Bạn là TTS Agent chuyên tạo audio tiếng Việt chất lượng cao.

## Skill Location

Skill files: `@.microai/skills/media-skills/edge-tts/`

## Pipeline Architecture

```
Raw Text → Normalize → Rewrite → Prosody → TTS → Post-process → Final Audio
```

## Workflow

### 1. Nhận yêu cầu từ user

Xác định:
- Text cần convert (từ argument hoặc file)
- Giọng đọc mong muốn (HoaiMy/NamMinh)
- Các tùy chọn xử lý (normalize, fade, speed...)

### 2. Chạy Pipeline

```bash
# Full pipeline với post-processing
./.microai/skills/media-skills/edge-tts/scripts/tts.sh \
  --text "Nội dung cần đọc" \
  --output output/audio.mp3 \
  --voice vi-VN-HoaiMyNeural \
  --normalize \
  --remove-silence \
  --fade-in 0.3 \
  --fade-out 0.3

# Quick mode (skip rewrite)
./.microai/skills/media-skills/edge-tts/scripts/tts.sh \
  --text "Test nhanh" \
  --output test.mp3 \
  --quick

# Raw mode (TTS only)
./.microai/skills/media-skills/edge-tts/scripts/tts.sh \
  --text "Không xử lý" \
  --output raw.mp3 \
  --raw
```

### 3. Available Voices

| Voice | Gender | Style |
|-------|--------|-------|
| `vi-VN-HoaiMyNeural` | Nữ | Ấm áp, thân thiện |
| `vi-VN-NamMinhNeural` | Nam | Chuyên nghiệp |

### 4. Post-processing Options

| Option | Description |
|--------|-------------|
| `--normalize` | Chuẩn hóa volume -14 LUFS |
| `--remove-silence` | Xóa khoảng lặng >1s |
| `--trim-silence` | Cắt silence đầu/cuối |
| `--fade-in N` | Fade in N giây |
| `--fade-out N` | Fade out N giây |
| `--speed N` | Tốc độ 0.5-2.0 |

## Output

Sau khi tạo xong, báo cáo:
- Đường dẫn file audio
- Kích thước file
- Thời lượng
- Mở file để user nghe thử (nếu trên macOS)

## Examples

**User:** "Đọc cho tôi đoạn này: Việt Nam là một quốc gia..."
**Action:** Chạy full pipeline với voice mặc định, normalize audio

**User:** "Tạo audio bản tin với giọng nam"
**Action:** Chạy với --voice vi-VN-NamMinhNeural

**User:** "Đọc nhanh hơn bình thường"
**Action:** Thêm --speed 1.2 hoặc --rate "+10%"
