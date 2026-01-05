# Edge-TTS Voice Configuration

> Knowledge file cho Audio Producer Agent
> Version: 1.0

---

## Voice Selection cho TOEIC Content

### Primary Voices

```yaml
voices:
  vietnamese:
    primary:
      name: vi-VN-HoaiMyNeural
      gender: female
      description: "Giọng nữ tự nhiên, ấm áp, phù hợp cho giảng dạy"
      use_for:
        - explanations
        - translations
        - instructions
        - cta_calls
        - tips

    alternative:
      name: vi-VN-NamMinhNeural
      gender: male
      description: "Giọng nam rõ ràng, chuyên nghiệp"
      use_for:
        - formal_content
        - business_context
        - alternative_narrator

  english:
    primary:
      name: en-US-JennyNeural
      gender: female
      description: "Giọng nữ Mỹ rõ ràng, chuẩn pronunciation"
      use_for:
        - vocabulary_words
        - ipa_pronunciation
        - example_sentences
        - collocations
        - english_content

    alternative:
      name: en-US-GuyNeural
      gender: male
      description: "Giọng nam Mỹ, phù hợp cho dialogue"
      use_for:
        - male_speaker_dialogues
        - business_conversations
        - alternative_narrator
```

### Voice Selection Rules

```yaml
language_to_voice_mapping:
  rules:
    - pattern: "English word/phrase"
      voice: en-US-JennyNeural
      examples:
        - "negotiate"
        - "/nɪˈɡoʊʃieɪt/"
        - "We need to negotiate a deal."

    - pattern: "Vietnamese explanation"
      voice: vi-VN-HoaiMyNeural
      examples:
        - "Nghĩa là đàm phán, thương lượng"
        - "Từ này 90% người Việt phát âm sai!"
        - "Follow để học mỗi ngày!"

    - pattern: "IPA pronunciation"
      voice: en-US-JennyNeural
      rate: "-10%"  # Slower for clarity
      note: "Speak IPA more slowly"

    - pattern: "Collocation/phrase"
      voice: en-US-JennyNeural
      examples:
        - "negotiate a contract"
        - "meet the deadline"
```

---

## Edge-TTS Command Reference

### Basic Usage

```bash
# Generate Vietnamese audio
edge-tts --voice vi-VN-HoaiMyNeural --text "Xin chào" --write-media output.mp3

# Generate English audio
edge-tts --voice en-US-JennyNeural --text "Hello" --write-media output.mp3

# With rate adjustment
edge-tts --voice en-US-JennyNeural --rate="+10%" --text "negotiate" --write-media output.mp3

# With pitch adjustment
edge-tts --voice vi-VN-HoaiMyNeural --pitch="+0Hz" --text "Xin chào" --write-media output.mp3
```

### SSML for Advanced Control

```xml
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
  <voice name="en-US-JennyNeural">
    <prosody rate="-10%" pitch="+0Hz">
      negotiate
    </prosody>
  </voice>
</speak>
```

### Python Integration

```python
import edge_tts
import asyncio

async def generate_audio(text, voice, output_file, rate="+0%"):
    """Generate audio using Edge-TTS"""
    communicate = edge_tts.Communicate(text, voice, rate=rate)
    await communicate.save(output_file)

# Vietnamese
asyncio.run(generate_audio(
    "Từ này 90% người Việt phát âm sai!",
    "vi-VN-HoaiMyNeural",
    "hook.mp3"
))

# English with slower rate for pronunciation
asyncio.run(generate_audio(
    "negotiate",
    "en-US-JennyNeural",
    "word.mp3",
    rate="-10%"
))
```

---

## Voice Parameters

### Rate (Speed)

```yaml
rate_settings:
  normal: "+0%"
  slightly_fast: "+10%"      # Recommended for shorts
  fast: "+20%"
  slightly_slow: "-10%"      # For pronunciation focus
  slow: "-20%"               # For learning
  very_slow: "-30%"          # For IPA

  recommended:
    hooks: "+10%"
    vocabulary: "-10%"
    ipa: "-20%"
    explanations: "+0%"
    cta: "+10%"
```

### Pitch

```yaml
pitch_settings:
  normal: "+0Hz"
  higher: "+5Hz"
  lower: "-5Hz"

  recommended:
    hooks: "+2Hz"       # Slightly more energetic
    vocabulary: "+0Hz"  # Natural
    cta: "+3Hz"         # Enthusiastic
```

### Volume

```yaml
volume_settings:
  normal: "+0%"
  louder: "+20%"
  quieter: "-20%"

  note: "Volume is typically normalized in post-processing"
```

---

## Mixed Language Handling

### Strategy for TOEIC Content

```yaml
mixed_language_strategy:
  # Generate separate audio files for each language
  # Then combine with precise timing

  example:
    script: "Từ 'negotiate' /nɪˈɡoʊʃieɪt/ nghĩa là đàm phán"

    segments:
      - text: "Từ"
        voice: vi-VN-HoaiMyNeural
        file: segment_01.mp3

      - text: "negotiate"
        voice: en-US-JennyNeural
        rate: "-10%"
        file: segment_02.mp3

      - text: "/nɪˈɡoʊʃieɪt/"
        voice: en-US-JennyNeural
        rate: "-20%"
        file: segment_03.mp3

      - text: "nghĩa là đàm phán"
        voice: vi-VN-HoaiMyNeural
        file: segment_04.mp3

    # Combine with FFmpeg
    combine_command: "ffmpeg -i concat.txt -c copy output.mp3"
```

### Language Detection Rules

```yaml
language_detection:
  english_markers:
    - all_ascii_letters
    - contains_ipa_brackets: "//.../"
    - known_english_word_in_corpus
    - quoted_english_phrase

  vietnamese_markers:
    - contains_vietnamese_diacritics: "áàảãạ..."
    - common_vietnamese_words: ["là", "có", "của", "và", "để"]
    - instruction_phrases: ["Nghĩa là", "Follow để", "Nhớ"]
```

---

## Quality Settings

### Audio Output Specifications

```yaml
audio_specs:
  format: mp3
  bitrate: 192kbps
  sample_rate: 44100
  channels: mono

  # Alternative for smaller file size
  compact:
    bitrate: 128kbps
    sample_rate: 24000
```

### Post-Processing Pipeline

```yaml
post_processing:
  1_normalize:
    target_lufs: -14
    true_peak: -1.5
    command: "ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11 output.mp3"

  2_silence_padding:
    start_padding: 500ms
    end_padding: 500ms
    between_segments: 300ms

  3_quality_check:
    min_duration: 1s
    max_duration: 60s
    check_clipping: true
    check_silence: true
```

---

## Available Voices Reference

### Vietnamese Voices

| Voice Name | Gender | Style |
|------------|--------|-------|
| vi-VN-HoaiMyNeural | Female | Natural, warm |
| vi-VN-NamMinhNeural | Male | Clear, professional |

### English Voices (US)

| Voice Name | Gender | Style |
|------------|--------|-------|
| en-US-JennyNeural | Female | Clear, friendly |
| en-US-GuyNeural | Male | Professional |
| en-US-AriaNeural | Female | Expressive |
| en-US-DavisNeural | Male | Casual |

### English Voices (UK) - Alternative

| Voice Name | Gender | Style |
|------------|--------|-------|
| en-GB-SoniaNeural | Female | British accent |
| en-GB-RyanNeural | Male | British accent |

---

## Error Handling

```yaml
error_handling:
  edge_tts_failure:
    retry: 3
    backoff: exponential
    fallback: gtts  # Google TTS as backup

  voice_not_available:
    action: use_alternative_voice
    alternatives:
      vi-VN-HoaiMyNeural: vi-VN-NamMinhNeural
      en-US-JennyNeural: en-US-AriaNeural

  rate_limit:
    action: wait_and_retry
    wait_time: 5s
```

---

## Best Practices

1. **Consistent Voice**: Sử dụng cùng voice cho cùng loại content
2. **Rate Adjustment**: Chậm hơn cho vocabulary, nhanh hơn cho hooks
3. **Segment Generation**: Tạo segments riêng rồi ghép
4. **Normalization**: Luôn normalize audio sau khi tạo
5. **Preview**: Test audio trước khi sử dụng production

---

*Last updated: 2026-01-04*
