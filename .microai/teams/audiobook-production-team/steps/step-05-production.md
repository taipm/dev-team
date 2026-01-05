# Step 05: PRODUCTION

> Generate audio segments using TTS

---

## Step Info

```yaml
step: 5
name: production
title: "Audio Production"
description: "Generate TTS audio segments for all chapters (parallel processing)"

trigger: step.04.complete OR step.04.5.complete
agent: audio-producer-agent

duration: "10-60 minutes"
checkpoint: true
parallel: true
```

---

## Responsible Agent

**Audio Producer Agent** (`🎤`)
- Orchestrates Edge-TTS generation
- Handles multi-voice switching
- Generates timestamps
- Parallel chapter processing

---

## Input

```yaml
input:
  from_step: step-04 OR step-04.5
  files:
    - scripts/chapter-{NNN}-script.yaml  # Non-fiction
    - voice/tagged-scripts/chapter-{NNN}-tagged.yaml  # Fiction

  subscribe:
    - script.adapted
    - script.prosody
    - voice.character_map (optional)
    - voice.dialogue_tagged (optional)
```

---

## Process

### 1. Voice Selection

```yaml
default_voices:
  narrator:
    vi: vi-VN-HoaiMyNeural
    en: en-US-JennyNeural

  characters: # From character-map.yaml if fiction
```

### 2. TTS Generation

```bash
# Per segment
edge-tts \
  --text "$TEXT" \
  --voice "$VOICE" \
  --rate "$RATE" \
  --pitch "$PITCH" \
  --write-media "segment-$ID.mp3"
```

### 3. Parallel Processing

```yaml
parallel:
  max_workers: 4
  unit: chapter
  rate_limiting:
    requests_per_second: 5
    backoff_on_429: true
```

### 4. Timestamp Generation

```json
{
  "chapter": 1,
  "total_duration_ms": 200000,
  "segments": [
    {
      "id": "ch1-s001",
      "start_ms": 0,
      "end_ms": 3500,
      "text": "...",
      "voice": "vi-VN-HoaiMyNeural"
    }
  ]
}
```

---

## Output

```yaml
output:
  files:
    - audio/segments/chapter-{NNN}/segment-{NNNN}.mp3
    - audio/timestamps.json

  directory_structure:
    audio/
    ├── segments/
    │   ├── chapter-001/
    │   │   ├── segment-0001.mp3
    │   │   └── ...
    │   └── chapter-002/
    └── timestamps.json

  publish:
    - topic: audio.segments
      payload: audio/segments/
    - topic: audio.timestamps
      payload: timestamps.json

  checkpoint:
    name: "production-complete"
```

---

## Success Criteria

```yaml
success:
  - all_segments_generated: true
  - no_empty_files: true
  - timestamps_sequential: true
  - duration_reasonable: true
  - voices_correct: true
```

---

## Error Handling

```yaml
errors:
  tts_failure:
    action: retry_with_backoff
    max_retries: 3
    backoff: [2s, 5s, 10s]
    fallback: gtts

  rate_limit:
    action: wait_and_retry
    wait: 60s

  empty_audio:
    action: regenerate
    fallback: use_silence
```

---

## Next Step

- **Step 06: ENGINEERING** - Audio Engineer Agent masters and merges audio
