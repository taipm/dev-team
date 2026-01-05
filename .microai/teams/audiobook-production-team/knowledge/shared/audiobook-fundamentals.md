# Audiobook Fundamentals

> Kiến thức cơ bản về sản xuất audiobook chuyên nghiệp

---

## 1. Audiobook là gì?

Audiobook là phiên bản audio của sách, được đọc bởi narrator (người thật hoặc AI). Audiobook chất lượng cao cần:

- **Giọng đọc rõ ràng, tự nhiên**
- **Chất lượng audio broadcast-ready**
- **Cấu trúc chapters rõ ràng**
- **Metadata đầy đủ cho distribution**

---

## 2. Thành phần của Audiobook

### 2.1 Audio Content

```
┌─────────────────────────────────────────┐
│            AUDIOBOOK STRUCTURE          │
├─────────────────────────────────────────┤
│  Opening Credits (optional)             │
│  ├── Title announcement                 │
│  ├── Author name                        │
│  └── Narrator name                      │
│                                         │
│  Main Content                           │
│  ├── Chapter 1                          │
│  │   ├── Chapter title announcement     │
│  │   └── Chapter content                │
│  ├── Chapter 2                          │
│  │   └── ...                            │
│  └── ...                                │
│                                         │
│  Closing Credits (optional)             │
│  ├── "The End"                          │
│  ├── Credits                            │
│  └── Copyright notice                   │
└─────────────────────────────────────────┘
```

### 2.2 Metadata

| Field | Description | Required |
|-------|-------------|----------|
| Title | Tên sách | Yes |
| Author | Tác giả | Yes |
| Narrator | Người đọc | Yes |
| Duration | Tổng thời lượng | Yes |
| Language | Ngôn ngữ | Yes |
| Genre | Thể loại | Yes |
| Description | Mô tả nội dung | Yes |
| Cover | Ảnh bìa | Yes |
| ISBN | Mã ISBN | Optional |
| Publisher | Nhà xuất bản | Optional |
| Copyright | Bản quyền | Recommended |

### 2.3 Cover Art

| Platform | Size | Format |
|----------|------|--------|
| Audible | 2400x2400 px | JPEG, RGB |
| Spotify | 3000x3000 px | JPEG, RGB |
| Apple Books | 2400x2400 px | JPEG, RGB |
| Google Play | 2400x2400 px | JPEG, RGB |
| Thumbnail | 500x500 px | JPEG, RGB |

---

## 3. Các thể loại Audiobook

### 3.1 Fiction (Tiểu thuyết)

**Đặc điểm:**
- Nhiều nhân vật, cần nhiều giọng đọc
- Dialogue phức tạp
- Cần diễn cảm, emotions
- Pacing thay đổi theo tình huống

**Production notes:**
- Character voice mapping quan trọng
- Dialogue attribution cần rõ ràng
- Narrator voice khác character voices

### 3.2 Non-Fiction / Business

**Đặc điểm:**
- Thường một narrator
- Giọng đọc chuyên nghiệp, rõ ràng
- Tốc độ đều, dễ theo dõi
- Có thể có quotes, statistics

**Production notes:**
- Single voice thường đủ
- Emphasis cho key points
- Pauses cho concepts phức tạp

### 3.3 Education / Technical

**Đặc điểm:**
- Nhiều thuật ngữ chuyên ngành
- Có thể có code, formulas
- Cần pronunciation chính xác
- Structure rõ ràng

**Production notes:**
- Slow pacing cho concepts khó
- Spell out abbreviations
- Handle code/formulas carefully

### 3.4 Self-Help

**Đặc điểm:**
- Conversational tone
- Inspirational, motivational
- Actionable advice
- Personal stories

**Production notes:**
- Warm, friendly voice
- Emphasis cho key takeaways
- Natural pacing

---

## 4. Production Standards

### 4.1 Audio Quality

```yaml
technical_specs:
  format: MP3 or M4B
  bitrate: 192 kbps (MP3) / 128 kbps (M4B)
  sample_rate: 44100 Hz
  channels: Mono
  loudness: -14 LUFS (broadcast) / -23 to -18 LUFS (ACX)
  true_peak: -1.5 dBTP (broadcast) / -3 dB (ACX)
  noise_floor: < -60 dB
```

### 4.2 Silence Standards

| Position | Duration |
|----------|----------|
| Between sentences | 0.5-1.0s |
| Between paragraphs | 1.0-2.0s |
| Between chapters | 2.0-3.0s |
| Opening/Closing | 0.5-1.0s |

### 4.3 Pacing Guidelines

| Content Type | Words per Minute |
|--------------|------------------|
| Dialogue | 140-160 WPM |
| Narration | 150-170 WPM |
| Technical | 130-150 WPM |
| Action scenes | 170-190 WPM |
| Emotional | 120-140 WPM |

---

## 5. Distribution Platforms

### 5.1 Audible/Amazon ACX

**Largest audiobook platform**

Requirements:
- 192 kbps CBR MP3
- 44.1 kHz, mono
- -23 to -18 LUFS (RMS)
- -3 dB peak max
- 0.5-1s room tone at start/end
- Opening/closing credits required
- Retail sample: first 5 minutes

### 5.2 Apple Books

Requirements:
- M4B with chapters preferred
- Similar audio specs to ACX
- Chapter markers required
- Cover: 2400x2400 JPEG

### 5.3 Google Play Books

Requirements:
- M4B or MP3
- Chapter markers recommended
- Metadata JSON
- Cover: 2400x2400 JPEG

### 5.4 Spotify (Podcasts)

Requirements:
- MP3 or M4A
- RSS feed format
- Episode-based structure
- Cover: 3000x3000 JPEG

---

## 6. Narrator Best Practices

### 6.1 Pronunciation

- **Proper nouns**: Research correct pronunciation
- **Foreign words**: Maintain original accent when appropriate
- **Technical terms**: Consistent pronunciation throughout
- **Abbreviations**: Expand or spell out as appropriate

### 6.2 Characterization (Fiction)

- **Distinct voices**: Each character should be recognizable
- **Consistency**: Same voice throughout the book
- **Attribution clarity**: Clear who is speaking
- **Emotion**: Match character's emotional state

### 6.3 Pacing

- **Vary speed**: Match content intensity
- **Pause effectively**: Let important points sink in
- **Chapter breaks**: Clear transition between chapters
- **Scene changes**: Brief pause to indicate shift

---

## 7. Common Mistakes to Avoid

| Mistake | Impact | Prevention |
|---------|--------|------------|
| Inconsistent volume | Listener fatigue | Use loudness normalization |
| Too fast pacing | Hard to follow | Aim for 150-160 WPM |
| Mouth noise | Unprofessional | Use audio processing |
| Long silences | Disrupts flow | Remove silences > 2s |
| Mispronunciations | Credibility loss | Research & verify |
| Missing chapters | Incomplete product | Validate structure |
| Poor metadata | Discovery issues | Complete all fields |

---

## 8. AI-Generated Audiobooks

### 8.1 Advantages

- Fast production time
- Consistent quality
- Lower cost
- Scalable

### 8.2 Considerations

- Less emotional range than human
- May mispronounce unusual words
- Character voices less distinct
- May need manual corrections

### 8.3 Best Practices for AI TTS

1. **Clean input text**: Remove artifacts, fix encoding
2. **Add prosody hints**: Guide pacing and emphasis
3. **Handle special content**: Numbers, abbreviations, names
4. **Post-process audio**: Normalize, remove artifacts
5. **Quality check**: Spot-check pronunciation
6. **Iterate**: Regenerate problematic sections

---

## 9. Chapter Management

### 9.1 Chapter Detection

Common patterns:
```
Chapter 1
CHAPTER ONE
Part I
Part One
1. Title
I. Title
Section 1
```

### 9.2 Chapter File Structure

```
chapters/
├── chapter-001.md    # Introduction
├── chapter-002.md    # Chapter 1
├── chapter-003.md    # Chapter 2
└── ...
```

### 9.3 Chapter Markers (M4B)

```
# chapters.txt format
00:00:00.000 Opening
00:01:30.000 Chapter 1: Beginning
00:45:00.000 Chapter 2: Rising Action
01:30:00.000 Chapter 3: Climax
02:00:00.000 Closing Credits
```

---

## 10. Quality Checklist

### Pre-Production
- [ ] Source text cleaned
- [ ] Chapters identified
- [ ] Metadata collected
- [ ] Voice selected

### Production
- [ ] All chapters recorded
- [ ] Timestamps accurate
- [ ] No missing content

### Post-Production
- [ ] Audio normalized
- [ ] Silences cleaned
- [ ] Fades applied
- [ ] Chapters merged

### Quality Control
- [ ] Pronunciation checked
- [ ] LUFS verified
- [ ] No clipping
- [ ] No artifacts
- [ ] Chapter markers correct

### Distribution
- [ ] Metadata complete
- [ ] Cover attached
- [ ] Platform specs met
- [ ] Files properly named

---

*"The best audiobooks are invisible - listeners forget they're listening to technology and become immersed in the story."*
