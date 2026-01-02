# Step 06: Audio Mixing

## Purpose
🎵 Audio Composer mix voice narration với background music.

## Agent
**audio-composer** (🎵)

## Trigger
Step 05 (TTS) + Step 03 completed (cần cả voice và background music).

## Actions

### 1. Verify Input Files

```bash
# Check all audio files exist
ls -la "$WORKSPACE/output/narration_vi.mp3"
ls -la "$WORKSPACE/output/narration_en.mp3"
ls -la "$WORKSPACE/output/background_music.m4a"

# Check durations match
echo "=== Narration VI ===" && ffprobe -v error -show_entries format=duration -of csv=p=0 "$WORKSPACE/output/narration_vi.mp3"
echo "=== Narration EN ===" && ffprobe -v error -show_entries format=duration -of csv=p=0 "$WORKSPACE/output/narration_en.mp3"
echo "=== Background Music ===" && ffprobe -v error -show_entries format=duration -of csv=p=0 "$WORKSPACE/output/background_music.m4a"
```

### 2. Generate Background Music (if not exists)

```bash
# If no background music yet, generate ambient
python3 "$WORKSPACE/src/generate_audio.py"
```

### 3. Mix Vietnamese Version

```bash
ffmpeg -y \
  -i "$WORKSPACE/output/narration_vi.mp3" \
  -i "$WORKSPACE/output/background_music.m4a" \
  -filter_complex "\
    [0:a]volume=1.0,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[voice];\
    [1:a]volume=0.25,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[music];\
    [voice][music]amix=inputs=2:duration=longest:dropout_transition=2[mixed];\
    [mixed]loudnorm=I=-14:LRA=7:TP=-2[out]" \
  -map "[out]" \
  -c:a aac -b:a 192k \
  "$WORKSPACE/output/final_audio_vi.m4a"

echo "Vietnamese mix complete"
```

### 4. Mix English Version

```bash
ffmpeg -y \
  -i "$WORKSPACE/output/narration_en.mp3" \
  -i "$WORKSPACE/output/background_music.m4a" \
  -filter_complex "\
    [0:a]volume=1.0,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[voice];\
    [1:a]volume=0.25,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[music];\
    [voice][music]amix=inputs=2:duration=longest:dropout_transition=2[mixed];\
    [mixed]loudnorm=I=-14:LRA=7:TP=-2[out]" \
  -map "[out]" \
  -c:a aac -b:a 192k \
  "$WORKSPACE/output/final_audio_en.m4a"

echo "English mix complete"
```

### 5. Advanced: Sidechain Ducking (Optional)

For better ducking (music ducks when voice speaks):

```bash
ffmpeg -y \
  -i "$WORKSPACE/output/narration_vi.mp3" \
  -i "$WORKSPACE/output/background_music.m4a" \
  -filter_complex "\
    [0:a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[voice];\
    [1:a]volume=0.4,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo[music_pre];\
    [music_pre]asplit=2[music][sc];\
    [voice]asplit=2[voice_out][voice_sc];\
    [music][voice_sc]sidechaincompress=threshold=0.015:ratio=6:attack=20:release=300:level_sc=1[ducked];\
    [voice_out][ducked]amix=inputs=2:duration=longest[mixed];\
    [mixed]loudnorm=I=-14:LRA=7:TP=-2[out]" \
  -map "[out]" \
  -c:a aac -b:a 192k \
  "$WORKSPACE/output/final_audio_vi_ducked.m4a"
```

### 6. Validate Mixed Audio

```bash
# Check duration
echo "=== Final Audio VI ==="
ffprobe -v error \
  -show_entries format=duration,bit_rate \
  -show_entries stream=codec_name,sample_rate,channels \
  -of default=noprint_wrappers=1 \
  "$WORKSPACE/output/final_audio_vi.m4a"

echo "=== Final Audio EN ==="
ffprobe -v error \
  -show_entries format=duration,bit_rate \
  -show_entries stream=codec_name,sample_rate,channels \
  -of default=noprint_wrappers=1 \
  "$WORKSPACE/output/final_audio_en.m4a"

# Check loudness
ffmpeg -i "$WORKSPACE/output/final_audio_vi.m4a" \
  -af loudnorm=print_format=json -f null - 2>&1 | grep "input_i"
```

### 7. Log Completion

```
🎵 AUDIO MIXING COMPLETE
├── Vietnamese Mix:
│   ├── File: final_audio_vi.m4a
│   ├── Duration: {duration}s
│   ├── Voice level: 0 dB
│   └── Music level: -12 dB (ducked)
├── English Mix:
│   ├── File: final_audio_en.m4a
│   ├── Duration: {duration}s
│   ├── Voice level: 0 dB
│   └── Music level: -12 dB (ducked)
├── Loudness: -14 LUFS
└── Format: AAC 192kbps

Proceeding to Preview Render...
```

## Output Files

```
output/
├── final_audio_vi.m4a    # Vietnamese: voice + music
├── final_audio_en.m4a    # English: voice + music
├── narration_vi.mp3      # Voice only (backup)
├── narration_en.mp3      # Voice only (backup)
└── background_music.m4a  # Music only (backup)
```

## Mix Level Reference

| Component | Level | Notes |
|-----------|-------|-------|
| Voice narration | 0 dB | Reference level |
| Background music (mix) | -12 dB | ~25% volume |
| Background music (ducked) | -18 dB | When voice active |
| Final output | -14 LUFS | YouTube standard |

## Transition
→ Step 07: Preview Render (with audio sync)

## Error Handling

| Error | Solution |
|-------|----------|
| Duration mismatch | Pad shorter audio with silence |
| Clipping | Reduce input volumes |
| Voice too quiet | Increase voice volume to 1.2-1.5 |
| Music too loud | Decrease music to 0.15-0.2 |
