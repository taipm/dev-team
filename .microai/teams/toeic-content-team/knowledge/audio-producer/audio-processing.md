# Audio Processing Guidelines

> Knowledge file cho Audio Producer Agent
> Version: 1.0

---

## Audio Specifications

### Output Standards

```yaml
audio_standards:
  format: mp3
  codec: libmp3lame
  bitrate: 192kbps
  sample_rate: 44100
  channels: 1 (mono)
  bit_depth: 16

  loudness:
    target_lufs: -14
    loudness_range: 11
    true_peak: -1.5dB

  duration:
    shorts:
      min: 15s
      max: 60s
    standard:
      min: 120s
      max: 600s
```

---

## FFmpeg Commands

### Basic Audio Operations

```bash
# Convert to standard format
ffmpeg -i input.wav -acodec libmp3lame -ab 192k -ar 44100 -ac 1 output.mp3

# Normalize loudness (EBU R128)
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11 output.mp3

# Two-pass normalization for precise control
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=summary -f null -
# Then use measured values in second pass
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=-20:measured_TP=-5:measured_LRA=8:measured_thresh=-30:offset=0 output.mp3
```

### Silence and Padding

```bash
# Add silence at beginning (500ms)
ffmpeg -i input.mp3 -af "adelay=500|500" output.mp3

# Add silence at end (500ms)
ffmpeg -i input.mp3 -af "apad=pad_dur=0.5" output.mp3

# Trim silence from beginning and end
ffmpeg -i input.mp3 -af "silenceremove=start_periods=1:start_duration=0.1:start_threshold=-50dB,areverse,silenceremove=start_periods=1:start_duration=0.1:start_threshold=-50dB,areverse" output.mp3
```

### Combining Audio Files

```bash
# Create concat list file
echo "file 'segment1.mp3'" > concat.txt
echo "file 'segment2.mp3'" >> concat.txt
echo "file 'segment3.mp3'" >> concat.txt

# Concatenate with re-encoding
ffmpeg -f concat -safe 0 -i concat.txt -c:a libmp3lame -b:a 192k output.mp3

# Concatenate without re-encoding (if same format)
ffmpeg -f concat -safe 0 -i concat.txt -c copy output.mp3
```

### Adding Pause Between Segments

```bash
# Create 300ms silence file
ffmpeg -f lavfi -i anullsrc=r=44100:cl=mono -t 0.3 -acodec libmp3lame silence.mp3

# Then include in concat list
echo "file 'segment1.mp3'" > concat.txt
echo "file 'silence.mp3'" >> concat.txt
echo "file 'segment2.mp3'" >> concat.txt
```

---

## Audio Processing Pipeline

### Complete Pipeline Script

```bash
#!/bin/bash
# audio-pipeline.sh

INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Step 1: Generate TTS segments (done by Edge-TTS)

# Step 2: Normalize each segment
for file in "$INPUT_DIR"/*.mp3; do
    ffmpeg -i "$file" -af loudnorm=I=-14:TP=-1.5:LRA=11 \
        "${file%.mp3}_normalized.mp3"
done

# Step 3: Add padding between segments
# (Using Python script for precise control)

# Step 4: Concatenate all segments
ffmpeg -f concat -safe 0 -i "$INPUT_DIR/concat.txt" \
    -c:a libmp3lame -b:a 192k "$OUTPUT_DIR/voiceover.mp3"

# Step 5: Final loudness check
ffmpeg -i "$OUTPUT_DIR/voiceover.mp3" \
    -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json \
    -f null - 2>&1 | grep -A50 "Parsed_loudnorm"
```

---

## Timing and Synchronization

### Timestamp Generation

```yaml
timestamp_format:
  fields:
    - segment_id: "seg_001"
    - start_ms: 0
    - end_ms: 3000
    - text: "Từ này 90% người Việt phát âm sai!"
    - voice: "vi-VN-HoaiMyNeural"
    - language: "vi"

  output_file: audio-timestamps.json

  example:
    segments:
      - segment_id: "seg_001"
        start_ms: 0
        end_ms: 3000
        text: "Từ này 90% người Việt phát âm sai!"
        voice: "vi-VN-HoaiMyNeural"

      - segment_id: "seg_002"
        start_ms: 3000
        end_ms: 5000
        text: "negotiate"
        voice: "en-US-JennyNeural"

      - segment_id: "pause_001"
        start_ms: 5000
        end_ms: 5300
        type: "silence"

      - segment_id: "seg_003"
        start_ms: 5300
        end_ms: 8000
        text: "/nɪˈɡoʊʃieɪt/"
        voice: "en-US-JennyNeural"
```

### Sync with Visuals

```yaml
sync_strategy:
  # Audio timestamps drive visual timing
  # Video Assembler uses audio-timestamps.json

  pause_markers:
    between_hook_and_word: 500ms
    between_word_and_definition: 300ms
    between_example_sentences: 400ms
    before_cta: 500ms

  transition_cues:
    on_segment_end: trigger_next_slide
    on_pause_start: hold_current_slide
```

---

## Quality Checks

### Audio Validation Script

```bash
#!/bin/bash
# audio-qc.sh

AUDIO_FILE="$1"

echo "=== Audio Quality Check ==="

# Get duration
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
echo "Duration: ${DURATION}s"

# Get loudness
LOUDNESS=$(ffmpeg -i "$AUDIO_FILE" -af loudnorm=print_format=json -f null - 2>&1 | grep -A20 "input_i")
echo "Loudness: $LOUDNESS"

# Check for clipping
CLIPPING=$(ffmpeg -i "$AUDIO_FILE" -af "astats=metadata=1:reset=1" -f null - 2>&1 | grep "Crest factor")
echo "Clipping check: $CLIPPING"

# Check sample rate
SAMPLE_RATE=$(ffprobe -v quiet -show_entries stream=sample_rate -of csv=p=0 "$AUDIO_FILE")
echo "Sample Rate: ${SAMPLE_RATE}Hz"

# Check bitrate
BITRATE=$(ffprobe -v quiet -show_entries format=bit_rate -of csv=p=0 "$AUDIO_FILE")
echo "Bitrate: ${BITRATE}bps"

# Verdict
if [ "$(echo "$DURATION > 10 && $DURATION < 70" | bc)" -eq 1 ]; then
    echo "✓ Duration OK"
else
    echo "✗ Duration out of range"
fi
```

### Quality Criteria

```yaml
quality_criteria:
  must_pass:
    - duration_within_spec: true
    - no_clipping: peak < 0dB
    - loudness_normalized: -16 to -12 LUFS
    - no_artifacts: manual_check
    - correct_sample_rate: 44100Hz

  should_pass:
    - consistent_voice_quality: no_drops
    - natural_pacing: appropriate_pauses
    - clear_pronunciation: intelligible

  nice_to_have:
    - background_music: optional
    - sound_effects: minimal
```

---

## Error Handling

### Common Issues and Solutions

```yaml
error_handling:
  edge_tts_timeout:
    symptom: "Connection timeout"
    solution:
      - retry: 3 times
      - delay: 5s between retries
      - fallback: use_gtts

  audio_clipping:
    symptom: "Peak > 0dB"
    solution:
      - reduce_volume: -3dB
      - re_normalize

  loudness_mismatch:
    symptom: "Segments have different loudness"
    solution:
      - normalize_each_segment_first
      - then_concatenate

  silence_detection_failed:
    symptom: "Unwanted silence in output"
    solution:
      - adjust_threshold: from -50dB to -40dB
      - manual_trim

  sync_drift:
    symptom: "Audio drifts from visuals"
    solution:
      - recalculate_timestamps
      - check_sample_rate_consistency
```

### Fallback Options

```yaml
fallback_options:
  tts_fallback:
    primary: edge_tts
    secondary: gtts
    tertiary: pyttsx3

  voice_fallback:
    vi-VN-HoaiMyNeural: vi-VN-NamMinhNeural
    en-US-JennyNeural: en-US-AriaNeural
```

---

## Output Structure

### File Organization

```
audio/
├── segments/
│   ├── seg_001_hook.mp3
│   ├── seg_002_word.mp3
│   ├── seg_003_ipa.mp3
│   ├── seg_004_definition.mp3
│   ├── seg_005_example.mp3
│   ├── seg_006_tip.mp3
│   └── seg_007_cta.mp3
├── voiceover.mp3           # Combined final audio
├── audio-timestamps.json    # Timing metadata
└── qc-report.txt           # Quality check results
```

### Metadata File Format

```json
{
  "version": "1.0",
  "generated_at": "2026-01-04T12:00:00Z",
  "total_duration_ms": 30000,
  "segments": [
    {
      "id": "seg_001",
      "file": "segments/seg_001_hook.mp3",
      "start_ms": 0,
      "end_ms": 3000,
      "text": "Từ này 90% người Việt phát âm sai!",
      "voice": "vi-VN-HoaiMyNeural",
      "language": "vi"
    }
  ],
  "quality_metrics": {
    "loudness_lufs": -14.2,
    "true_peak_db": -1.8,
    "sample_rate": 44100,
    "bitrate": 192000
  }
}
```

---

## Best Practices

1. **Normalize Early**: Normalize từng segment trước khi ghép
2. **Consistent Pauses**: Sử dụng pause time nhất quán
3. **Test Voice Quality**: Nghe thử trước khi sử dụng
4. **Document Timestamps**: Luôn export timestamps cho Video Assembler
5. **Keep Raw Segments**: Giữ lại segments gốc để edit lại nếu cần

---

*Last updated: 2026-01-04*
