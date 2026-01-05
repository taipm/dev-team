# Step 04: Audio Production

```yaml
step: 4
name: audio-production
description: Tạo voiceover với Edge-TTS
trigger: script.complete received
agent: audio-producer-agent
next: step-05-visual-design
checkpoint: true
loop: true
```

---

## Purpose

Audio Producer chuyển script thành voiceover audio sử dụng Edge-TTS với mixed Vietnamese/English support.

---

## Input

```yaml
subscribed:
  - script.complete

from_script:
  - Full script text
  - Timestamps
  - Language markers
  - Pause markers

from_knowledge:
  - edge-tts-voices.md
  - audio-processing.md
```

---

## Actions

### 1. Parse Script for Audio

```yaml
parsing:
  - Extract spoken text
  - Identify language segments (Vi/En)
  - Map pause markers
  - Calculate section durations
```

### 2. Configure TTS

```yaml
tts_config:
  vietnamese:
    voice: vi-VN-HoaiMyNeural
    rate: "+10%"
    pitch: "+0Hz"

  english:
    voice: en-US-JennyNeural
    rate: "+0%"
    pitch: "+0Hz"
```

### 3. Generate Audio Segments

For each section:

```bash
# Vietnamese segments
edge-tts --voice "vi-VN-HoaiMyNeural" \
         --rate "+10%" \
         --text "{vietnamese_text}" \
         --write-media segment_vi_{n}.mp3

# English segments (words, phrases)
edge-tts --voice "en-US-JennyNeural" \
         --rate "+0%" \
         --text "{english_text}" \
         --write-media segment_en_{n}.mp3
```

### 4. Combine Segments

```bash
# Concatenate with pauses
ffmpeg -f concat -safe 0 -i segments.txt \
       -c:a libmp3lame -q:a 2 \
       combined.mp3
```

### 5. Audio Processing

```bash
# Normalize levels
ffmpeg -i combined.mp3 \
       -filter:a loudnorm=I=-14:LRA=11:TP=-1.5 \
       normalized.mp3

# Add padding
ffmpeg -i normalized.mp3 \
       -af "adelay=500|500,apad=pad_dur=500ms" \
       final_voiceover.mp3
```

### 6. Extract Actual Timestamps

```yaml
timestamps:
  - segment_id: hook
    start_ms: 0
    end_ms: {actual_end}
  - segment_id: intro
    start_ms: {previous_end}
    end_ms: {actual_end}
  # ... etc
```

---

## Output

```yaml
deliverables:
  - audio/{video_id}/voiceover.mp3
  - audio/{video_id}/segments/ (individual files)
  - audio/{video_id}/audio-timestamps.json

published:
  - audio.voiceover
  - audio.timestamps
```

---

## Quality Gate

```yaml
validation:
  - Audio file exists and plays
  - Duration within expected range
  - No audio artifacts
  - Timestamps accurate
  - Mixed language handled correctly
```

---

## Error Handling

```yaml
errors:
  edge_tts_failure:
    retry: 3
    fallback: gtts

  audio_artifact:
    action: regenerate_segment

  duration_mismatch:
    action: adjust_rate
```

---

## Checkpoint

```yaml
checkpoint:
  step: 4
  video_id: {id}
  status: complete
  duration_ms: {n}
  segments: {n}
  timestamp: {time}
```

---

## Handoff

→ **Step 05: Visual Design** với Visual Designer Agent

Pass: audio.voiceover, audio.timestamps

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║               🎙️ AUDIO PRODUCER - AUDIO COMPLETE                       ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Audio Details:                                                       ║
║   ├── Duration: {duration}                                            ║
║   ├── Segments: {count}                                               ║
║   ├── File Size: {size}                                               ║
║   └── Format: MP3 192kbps                                             ║
║                                                                        ║
║   Voice Configuration:                                                 ║
║   ├── Vietnamese: vi-VN-HoaiMyNeural                                  ║
║   └── English: en-US-JennyNeural                                      ║
║                                                                        ║
║   Processing: ✓ Normalized (-14 LUFS)                                 ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Handoff to Visual Designer...                                     ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
