# TTS Best Practices for Audiobook Production

> Hướng dẫn tối ưu hóa Text-to-Speech cho sản xuất audiobook chất lượng cao

---

## 1. Text Preprocessing Pipeline

```
Raw Text → Normalize → Rewrite → Prosody → TTS → Post-process → Final Audio
```

### 1.1 Text Normalization

**Mục đích**: Chuyển đổi text thành dạng phát âm được

| Input | Output | Rule |
|-------|--------|------|
| `100` | "một trăm" (vi) / "one hundred" (en) | Number to words |
| `$50` | "năm mươi đô la" | Currency |
| `15/01/2025` | "ngày mười lăm tháng một năm hai không hai lăm" | Date |
| `3.14` | "ba phẩy mười bốn" | Decimal |
| `Mr.` | "Mister" | Abbreviation |
| `Dr.` | "Doctor" | Abbreviation |
| `e.g.` | "for example" | Abbreviation |
| `&` | "và" (vi) / "and" (en) | Symbol |
| `%` | "phần trăm" | Symbol |
| `@` | "at" | Symbol |
| URLs | [remove or describe] | Special |
| Emojis | [remove] | Special |

### 1.2 Text Rewriting for Speech

**Mục đích**: Tối ưu cấu trúc câu cho giọng nói tự nhiên

```
Before: The company (founded in 2010) has grown significantly.
After:  The company, founded in 2010, has grown significantly.

Before: He said: "I'll be there."
After:  He said, "I'll be there."

Before: This is a very, very, very important point.
After:  This is an extremely important point.
```

**Rules:**
- Tách câu dài thành câu ngắn hơn
- Chuyển parentheses thành commas
- Loại bỏ repetition không cần thiết
- Đơn giản hóa passive voice

### 1.3 Prosody Planning

**Mục đích**: Thêm hints cho TTS về cách đọc

```yaml
prosody_markers:
  pause:
    short: "[pause:300ms]"   # After comma
    medium: "[pause:500ms]"  # After sentence
    long: "[pause:1000ms]"   # New paragraph

  emphasis:
    strong: "[emphasis:strong]"
    moderate: "[emphasis:moderate]"

  rate:
    slow: "[rate:-10%]"      # Important info
    fast: "[rate:+10%]"      # Excitement

  pitch:
    question: "[pitch:+10%]"
    exclaim: "[pitch:+5%]"
```

---

## 2. Voice Selection

### 2.1 Vietnamese Voices (Edge-TTS)

| Voice ID | Gender | Style | Best For |
|----------|--------|-------|----------|
| `vi-VN-HoaiMyNeural` | Female | Warm, friendly | Narration, business |
| `vi-VN-NamMinhNeural` | Male | Professional | News, formal |

### 2.2 English Voices (Edge-TTS)

| Voice ID | Gender | Style | Best For |
|----------|--------|-------|----------|
| `en-US-JennyNeural` | Female | Clear, neutral | Narration |
| `en-US-GuyNeural` | Male | Professional | Business |
| `en-US-AriaNeural` | Female | Expressive | Fiction |
| `en-US-ChristopherNeural` | Male | Deep | Fiction |
| `en-US-SaraNeural` | Female | Young | Young characters |
| `en-US-EricNeural` | Male | Warm | Friendly content |

### 2.3 Voice Selection Guidelines

```yaml
voice_selection:
  single_narrator:
    default_female: vi-VN-HoaiMyNeural
    default_male: vi-VN-NamMinhNeural

  multi_voice_fiction:
    narrator: vi-VN-HoaiMyNeural
    male_characters:
      - en-US-GuyNeural
      - en-US-ChristopherNeural
      - en-US-EricNeural
    female_characters:
      - en-US-JennyNeural
      - en-US-AriaNeural
      - en-US-SaraNeural

  mixed_language:
    vietnamese: vi-VN-HoaiMyNeural
    english_words: en-US-JennyNeural
```

---

## 3. TTS Configuration

### 3.1 Edge-TTS Parameters

```bash
# Basic usage
edge-tts --text "Hello world" --voice en-US-JennyNeural --write-media output.mp3

# With rate adjustment
edge-tts --text "..." --voice vi-VN-HoaiMyNeural --rate "+10%"

# With pitch adjustment
edge-tts --text "..." --voice vi-VN-HoaiMyNeural --pitch "+5Hz"

# With volume adjustment
edge-tts --text "..." --voice vi-VN-HoaiMyNeural --volume "+10%"
```

### 3.2 SSML Support (Limited)

```xml
<speak>
  <prosody rate="slow">Important information here.</prosody>
  <break time="500ms"/>
  <prosody pitch="+10%">Question?</prosody>
</speak>
```

**Note**: Edge-TTS có SSML support hạn chế. Sử dụng text preprocessing thay vì SSML khi có thể.

### 3.3 Recommended Settings by Content Type

| Content Type | Rate | Pitch | Notes |
|--------------|------|-------|-------|
| Narration | +0% | +0Hz | Natural default |
| Dialogue | +5% | varies | Slightly faster |
| Technical | -10% | +0Hz | Slower for clarity |
| Action | +10% | +0Hz | Faster, exciting |
| Emotional | -10% | -5Hz | Slower, lower |
| Questions | +0% | +10% | Rising pitch |

---

## 4. Handling Special Content

### 4.1 Numbers

```python
# Vietnamese
100 → "một trăm"
1,234 → "một nghìn hai trăm ba mươi bốn"
3.14 → "ba phẩy mười bốn"
50% → "năm mươi phần trăm"
$100 → "một trăm đô la"

# English
100 → "one hundred"
1,234 → "one thousand two hundred thirty-four"
3.14 → "three point one four"
50% → "fifty percent"
$100 → "one hundred dollars"
```

### 4.2 Dates

```python
# Vietnamese format
15/01/2025 → "ngày mười lăm tháng một năm hai không hai lăm"
2024 (year) → "năm hai không hai bốn"

# English format
January 15, 2025 → "January fifteenth, twenty twenty-five"
2024 (year) → "twenty twenty-four"
```

### 4.3 Abbreviations

```yaml
common_abbreviations:
  "Mr." → "Mister"
  "Mrs." → "Missus"
  "Dr." → "Doctor"
  "Prof." → "Professor"
  "e.g." → "for example"
  "i.e." → "that is"
  "etc." → "et cetera"
  "vs." → "versus"
  "Jr." → "Junior"
  "Sr." → "Senior"
  "Inc." → "Incorporated"
  "Ltd." → "Limited"
  "CEO" → "C.E.O." (spell out)
  "AI" → "A.I." (spell out)
```

### 4.4 Proper Nouns

```yaml
pronunciation_hints:
  # Common mispronunciations
  "Nguyen" → "Win" (Vietnamese name)
  "Pho" → "Fuh" (Vietnamese dish)
  "Rendezvous" → "Ron-day-voo"

  # Add phonetic hints when needed
  "Siobhan [shuh-VAHN]" → Process phonetic guide
```

### 4.5 Code and Technical Content

```yaml
code_handling:
  strategy: "describe or skip"

  examples:
    "x = 5" → "x equals five"
    "print('hello')" → "print quote hello end quote"
    "function foo()" → "function foo"

  long_code_blocks:
    action: "summarize"
    example: "The following code block demonstrates..."
```

---

## 5. Multi-Language Content

### 5.1 Language Detection

```python
def detect_language(text):
    # Simple heuristic
    vietnamese_chars = set("àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ")
    if any(c in vietnamese_chars for c in text.lower()):
        return "vi"
    return "en"
```

### 5.2 Mixed Language Handling

```yaml
# Input
"Từ 'accomplish' có nghĩa là hoàn thành"

# Segment detection
segments:
  - text: "Từ"
    lang: vi
    voice: vi-VN-HoaiMyNeural

  - text: "accomplish"
    lang: en
    voice: en-US-JennyNeural

  - text: "có nghĩa là hoàn thành"
    lang: vi
    voice: vi-VN-HoaiMyNeural

# Process each segment with appropriate voice
# Merge segments maintaining natural flow
```

### 5.3 Voice Switching Best Practices

- **Minimize switches**: Group same-language content
- **Natural transitions**: Add brief pause between switches
- **Consistent voices**: Same language = same voice throughout
- **Fallback**: If detection fails, use primary language voice

---

## 6. Audio Post-Processing

### 6.1 Loudness Normalization

```bash
# Normalize to -14 LUFS (broadcast standard)
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11 output.mp3

# For Audible ACX (-23 to -18 LUFS)
ffmpeg -i input.mp3 -af loudnorm=I=-20:TP=-3:LRA=7 output.mp3
```

### 6.2 Silence Removal

```bash
# Remove silences longer than 2 seconds
ffmpeg -i input.mp3 -af silenceremove=stop_periods=-1:stop_duration=2:stop_threshold=-40dB output.mp3
```

### 6.3 Fade In/Out

```bash
# Add 0.5s fade in and 1.0s fade out
ffmpeg -i input.mp3 -af "afade=t=in:st=0:d=0.5,afade=t=out:st=END-1:d=1" output.mp3
```

### 6.4 Full Processing Pipeline

```bash
#!/bin/bash
# Complete audio processing pipeline

INPUT="$1"
OUTPUT="$2"

ffmpeg -i "$INPUT" \
  -af "silenceremove=stop_periods=-1:stop_duration=2:stop_threshold=-40dB,\
       loudnorm=I=-14:TP=-1.5:LRA=11,\
       afade=t=in:st=0:d=0.5,\
       afade=t=out:st=END-1:d=1" \
  -ar 44100 -ac 1 -b:a 192k \
  "$OUTPUT"
```

---

## 7. Chunking Long Content

### 7.1 Why Chunk?

- TTS has character/token limits
- Memory constraints
- Better error recovery
- Parallel processing

### 7.2 Chunking Strategies

```yaml
chunking:
  max_chars: 5000

  break_points:
    priority_1: paragraph_end  # Best
    priority_2: sentence_end   # Good
    priority_3: clause_end     # Acceptable
    priority_4: word_boundary  # Last resort

  overlap: 0  # No overlap needed for audiobook

  metadata:
    - chunk_id
    - start_position
    - end_position
    - estimated_duration
```

### 7.3 Chunk Merging

```bash
# Create file list
for f in chunk-*.mp3; do echo "file '$f'" >> files.txt; done

# Merge with crossfade
ffmpeg -f concat -safe 0 -i files.txt -af "acrossfade=d=0.3" output.mp3
```

---

## 8. Error Handling

### 8.1 Common TTS Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Rate limit | Too many requests | Implement backoff |
| Timeout | Network issue | Retry with delay |
| Invalid chars | Unsupported characters | Clean text |
| Empty audio | No speakable content | Check input |

### 8.2 Retry Strategy

```python
def generate_with_retry(text, voice, max_retries=3):
    for attempt in range(max_retries):
        try:
            return generate_tts(text, voice)
        except RateLimitError:
            time.sleep(2 ** attempt)  # Exponential backoff
        except TimeoutError:
            time.sleep(5)
    return None  # Fallback to alternative TTS
```

### 8.3 Fallback Chain

```yaml
fallback_chain:
  1. edge-tts (primary)
  2. gtts (Google TTS)
  3. manual_recording_request
```

---

## 9. Quality Assurance

### 9.1 Spot Check Points

- [ ] First paragraph of each chapter
- [ ] Proper nouns and names
- [ ] Numbers and dates
- [ ] Technical terms
- [ ] Dialogue sections
- [ ] Emotional passages

### 9.2 Common Issues to Check

| Issue | Detection | Fix |
|-------|-----------|-----|
| Mispronunciation | Manual review | Add phonetic hint |
| Unnatural pause | Listen | Adjust punctuation |
| Wrong voice | Listen | Fix language detection |
| Clipping | Audio analysis | Reduce input volume |
| Artifacts | Listen | Regenerate segment |

### 9.3 Automated Checks

```python
def validate_audio(file_path):
    checks = {
        'duration': check_duration(file_path),  # Not too short/long
        'loudness': check_loudness(file_path),  # Within LUFS range
        'peaks': check_peaks(file_path),        # No clipping
        'silence': check_silence(file_path),    # Appropriate gaps
        'format': check_format(file_path),      # Correct specs
    }
    return all(checks.values()), checks
```

---

## 10. Performance Optimization

### 10.1 Parallel Processing

```python
from concurrent.futures import ThreadPoolExecutor

def process_chapters(chapters, max_workers=4):
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(process_chapter, ch) for ch in chapters]
        return [f.result() for f in futures]
```

### 10.2 Caching

```yaml
caching:
  enabled: true
  cache_dir: .cache/tts/

  cache_by:
    - text_hash
    - voice_id
    - rate
    - pitch

  ttl: 7d  # Time to live
```

### 10.3 Batch Processing Tips

1. **Pre-process all text first**: Normalize, clean, chunk
2. **Generate in parallel**: Multiple chapters simultaneously
3. **Post-process in batch**: Single FFmpeg command for normalization
4. **Validate before merge**: Check each segment before combining

---

*"Good TTS is invisible - listeners focus on content, not technology."*
