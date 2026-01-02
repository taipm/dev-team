# Step 05: TTS Voice Generation

## Purpose
🗣️ TTS Voice Agent convert scripts thành voice narration.

## Agent
**tts-voice** (🗣️)

## Trigger
Step 04 (Script) completed.

## Prerequisites

```bash
# Install edge-tts
pip install edge-tts

# Verify installation
edge-tts --list-voices | grep -E "vi-VN|en-US"
```

## Actions

### 1. Load Scripts

```bash
# Check script files exist
ls -la "$WORKSPACE/output/script_vi.txt"
ls -la "$WORKSPACE/output/script_en.txt"
```

### 2. Select Voices

| Language | Recommended Voice | Alternative |
|----------|-------------------|-------------|
| Vietnamese | `vi-VN-NamMinhNeural` (M) | `vi-VN-HoaiMyNeural` (F) |
| English | `en-US-GuyNeural` (M) | `en-US-JennyNeural` (F) |

### 3. Generate Vietnamese Narration

```bash
edge-tts \
  --voice "vi-VN-NamMinhNeural" \
  --rate "-5%" \
  --file "$WORKSPACE/output/script_vi.txt" \
  --write-media "$WORKSPACE/output/narration_vi.mp3" \
  --write-subtitles "$WORKSPACE/output/narration_vi.vtt"

echo "Vietnamese narration generated"
```

### 4. Generate English Narration

```bash
edge-tts \
  --voice "en-US-GuyNeural" \
  --rate "-3%" \
  --file "$WORKSPACE/output/script_en.txt" \
  --write-media "$WORKSPACE/output/narration_en.mp3" \
  --write-subtitles "$WORKSPACE/output/narration_en.vtt"

echo "English narration generated"
```

### 5. Validate Audio Duration

```bash
# Check duration matches expected (~90s)
echo "=== Vietnamese ==="
ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 \
  "$WORKSPACE/output/narration_vi.mp3"

echo "=== English ==="
ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 \
  "$WORKSPACE/output/narration_en.mp3"

# Acceptable range: 80-100 seconds
```

### 6. Adjust if Needed

If duration is off:

```bash
# Speed up if too long (> 100s)
ffmpeg -i narration_vi.mp3 \
  -filter:a "atempo=1.1" \
  narration_vi_adjusted.mp3

# Slow down if too short (< 80s)  
ffmpeg -i narration_vi.mp3 \
  -filter:a "atempo=0.9" \
  narration_vi_adjusted.mp3
```

Or re-generate with different rate:
```bash
# Faster: --rate "+5%"
# Slower: --rate "-10%"
```

### 7. Convert VTT to SRT (Optional)

```python
def vtt_to_srt(vtt_path: str, srt_path: str):
    """Convert WebVTT to SRT format."""
    with open(vtt_path, 'r') as f:
        content = f.read()
    
    # Remove WEBVTT header
    content = content.replace('WEBVTT\n\n', '')
    
    # Convert timestamps (. to ,)
    import re
    content = re.sub(r'(\d{2}:\d{2}:\d{2})\.(\d{3})', r'\1,\2', content)
    
    # Add sequence numbers
    blocks = content.strip().split('\n\n')
    srt_content = []
    for i, block in enumerate(blocks, 1):
        srt_content.append(f"{i}\n{block}")
    
    with open(srt_path, 'w') as f:
        f.write('\n\n'.join(srt_content))

vtt_to_srt('narration_vi.vtt', 'narration_vi.srt')
vtt_to_srt('narration_en.vtt', 'narration_en.srt')
```

### 8. Log Completion

```
🗣️ TTS VOICE GENERATION COMPLETE
├── Vietnamese:
│   ├── Audio: narration_vi.mp3 ({duration}s)
│   └── Subtitles: narration_vi.vtt
├── English:
│   ├── Audio: narration_en.mp3 ({duration}s)
│   └── Subtitles: narration_en.vtt
├── Voice: NamMinhNeural (VI), GuyNeural (EN)
└── Rate: -5% VI, -3% EN

Proceeding to Audio Mixing...
```

## Output Files

```
output/
├── narration_vi.mp3      # Vietnamese voice audio
├── narration_vi.vtt      # Vietnamese subtitles
├── narration_en.mp3      # English voice audio
└── narration_en.vtt      # English subtitles
```

## Transition
→ Step 06: Audio Mixing (voice + background music)

## Error Handling

| Error | Solution |
|-------|----------|
| edge-tts not installed | `pip install edge-tts` |
| Voice not available | Check `edge-tts --list-voices` |
| Duration too long | Increase rate or edit script |
| Duration too short | Decrease rate or add content |
| Network error | edge-tts needs internet first time |
