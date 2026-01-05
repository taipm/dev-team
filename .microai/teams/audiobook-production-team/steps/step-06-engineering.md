# Step 06: ENGINEERING

> Master, normalize, and merge audio files

---

## Step Info

```yaml
step: 6
name: engineering
title: "Audio Engineering"
description: "Merge segments, normalize loudness, apply fades, create final audio"

trigger: step.05.complete
agent: audio-engineer-agent

duration: "5-30 minutes"
checkpoint: true
```

---

## Responsible Agent

**Audio Engineer Agent** (`🎛️`)
- Merges segments into chapters
- Normalizes loudness to -14 LUFS
- Removes unwanted silences
- Applies fade in/out
- Creates full audiobook

---

## Input

```yaml
input:
  from_step: step-05-production
  files:
    - audio/segments/chapter-{NNN}/segment-{NNNN}.mp3
    - audio/timestamps.json

  subscribe:
    - audio.segments
    - audio.timestamps
```

---

## Process

### 1. Segment Merging

```bash
# Merge segments per chapter
ffmpeg -f concat -safe 0 -i concat.txt \
    -af "acrossfade=d=0.1:c1=tri:c2=tri" \
    -c:a libmp3lame -b:a 192k \
    chapter-001.mp3
```

### 2. Loudness Normalization

```bash
# Two-pass normalization to -14 LUFS
ffmpeg -i input.mp3 \
    -af "loudnorm=I=-14:TP=-1.5:LRA=11" \
    -ar 44100 -ac 1 \
    -c:a libmp3lame -b:a 192k \
    output.mp3
```

### 3. Silence Handling

```bash
# Remove silences > 2 seconds
ffmpeg -i input.mp3 \
    -af "silenceremove=stop_periods=-1:stop_duration=2:stop_threshold=-40dB" \
    output.mp3
```

### 4. Fade Application

```bash
# Fade in 0.5s, fade out 1.0s
ffmpeg -i input.mp3 \
    -af "afade=t=in:st=0:d=0.5,afade=t=out:st=$END:d=1" \
    output.mp3
```

### 5. Full Audiobook Assembly

```bash
# Concatenate all chapters
ffmpeg -f concat -safe 0 -i chapters.txt \
    -c:a libmp3lame -b:a 192k \
    full-audiobook.mp3
```

---

## Output

```yaml
output:
  files:
    - mastered/chapter-{NNN}.mp3
    - mastered/full-audiobook.mp3
    - mastered/audio-report.json

  specifications:
    format: MP3
    bitrate: 192 kbps CBR
    sample_rate: 44100 Hz
    channels: Mono
    loudness: -14 LUFS
    true_peak: -1.5 dBTP

  publish:
    - topic: audio.chapters_merged
      payload: mastered/
    - topic: audio.mastered
      payload: mastered/

  checkpoint:
    name: "engineering-complete"
```

---

## Audio Report Format

```json
{
  "generated_at": "...",
  "total_chapters": 14,
  "total_duration": "8:20:00",
  "total_size_mb": 576,
  "specifications": {
    "format": "MP3",
    "bitrate": "192 kbps",
    "sample_rate": 44100,
    "channels": 1,
    "loudness_lufs": -14.2,
    "true_peak_db": -1.8
  },
  "chapters": [
    {
      "chapter": 1,
      "file": "chapter-001.mp3",
      "duration": "35:20",
      "size_mb": 40.5,
      "loudness_lufs": -14.1
    }
  ]
}
```

---

## Success Criteria

```yaml
success:
  - all_chapters_processed: true
  - loudness_within_spec: "-16 to -12 LUFS"
  - no_clipping: "peaks < -1 dB"
  - no_long_silences: "> 3s"
  - fades_applied: true
  - full_audiobook_created: true
```

---

## Error Handling

```yaml
errors:
  ffmpeg_failure:
    action: retry
    max_retries: 2
    fallback: skip_processing

  missing_segments:
    action: report_error
    note: "Cannot merge incomplete chapter"

  normalization_failure:
    action: use_simple_gain
```

---

## Next Step

- **Step 07: REVIEW** - Quality Reviewer Agent validates audio quality
