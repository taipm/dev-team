# Audio Standards for Audiobook Production

> Tiêu chuẩn kỹ thuật audio cho sản xuất audiobook chất lượng broadcast

---

## 1. Audio Format Specifications

### 1.1 MP3 Format

```yaml
mp3_specs:
  codec: MPEG Audio Layer III
  bitrate: 192 kbps CBR (Constant Bit Rate)
  sample_rate: 44100 Hz
  channels: Mono
  bit_depth: 16-bit (inherent to MP3)

  why_these_settings:
    bitrate_192: "Balance between quality and file size"
    cbr: "Required by most platforms (not VBR)"
    44100: "CD quality, universal compatibility"
    mono: "Audiobooks don't need stereo"
```

### 1.2 M4B Format (Audiobook)

```yaml
m4b_specs:
  codec: AAC (Advanced Audio Coding)
  bitrate: 128 kbps (sufficient for speech)
  sample_rate: 44100 Hz
  channels: Mono
  container: MP4 with .m4b extension

  advantages:
    - Chapter markers support
    - Smaller file size than MP3
    - Better quality per bitrate
    - Bookmark support in players
```

### 1.3 WAV Format (Archive/Processing)

```yaml
wav_specs:
  codec: PCM (uncompressed)
  sample_rate: 44100 Hz or 48000 Hz
  channels: Mono
  bit_depth: 16-bit or 24-bit

  use_cases:
    - Intermediate processing
    - Archive/master copy
    - Source for other formats
```

---

## 2. Loudness Standards

### 2.1 LUFS (Loudness Units relative to Full Scale)

```yaml
lufs_explained:
  definition: "Measure of perceived loudness over time"
  unit: "LUFS or LKFS (same thing)"
  measurement: "Integrated loudness over entire track"

loudness_targets:
  broadcast_standard:
    integrated: -14 LUFS
    true_peak: -1.5 dBTP
    loudness_range: 11 LU

  audible_acx:
    integrated: "-23 to -18 LUFS (RMS equivalent)"
    true_peak: -3 dB
    noise_floor: -60 dB

  spotify:
    integrated: -14 LUFS
    true_peak: -1 dBTP

  youtube:
    integrated: -14 LUFS
    true_peak: -1 dBTP
```

### 2.2 Measuring Loudness

```bash
# Using FFmpeg to analyze loudness
ffmpeg -i input.mp3 -af loudnorm=print_format=json -f null - 2>&1 | grep -A20 "input_"

# Expected output:
# "input_i" : "-20.5"        (Integrated loudness)
# "input_tp" : "-2.3"        (True peak)
# "input_lra" : "8.5"        (Loudness range)
```

### 2.3 Normalization

```bash
# Two-pass loudness normalization (recommended)

# Pass 1: Analyze
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null - 2>&1

# Pass 2: Apply with measured values
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=-20.5:measured_TP=-2.3:measured_LRA=8.5:measured_thresh=-30.5:offset=-0.5 output.mp3

# Single-pass (simpler but less accurate)
ffmpeg -i input.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11 output.mp3
```

---

## 3. Dynamic Range

### 3.1 Loudness Range (LRA)

```yaml
loudness_range:
  definition: "Difference between loud and quiet parts"
  target: "7-11 LU for audiobooks"

  too_narrow: "< 5 LU - sounds compressed, fatiguing"
  ideal: "7-11 LU - natural, easy to listen"
  too_wide: "> 15 LU - quiet parts inaudible, loud parts startling"
```

### 3.2 Compression (if needed)

```bash
# Light compression for audiobook
ffmpeg -i input.mp3 -af "acompressor=threshold=-20dB:ratio=3:attack=5:release=50" output.mp3

# Parameters:
# threshold: Level where compression starts
# ratio: Amount of compression (3:1 = 3dB above threshold → 1dB output)
# attack: How fast compression kicks in (ms)
# release: How fast compression releases (ms)
```

---

## 4. Silence Standards

### 4.1 Silence Durations

| Position | Duration | Purpose |
|----------|----------|---------|
| Start of file | 0.5-1.0s | Clean opening |
| End of file | 1.0-3.0s | Clean ending |
| Between sentences | 0.3-0.8s | Natural pause |
| Between paragraphs | 0.8-1.5s | Content break |
| Between chapters | 2.0-3.0s | Clear separation |

### 4.2 Room Tone

```yaml
room_tone:
  definition: "Background silence that isn't pure digital silence"
  purpose: "Prevents jarring cuts, more natural"
  level: "-60 dB or quieter"
  duration: "0.5-1.0s at start and end"

  acx_requirement:
    - "0.5-1.0 seconds of room tone at beginning"
    - "1.0-5.0 seconds of room tone at end"
```

### 4.3 Silence Removal

```bash
# Remove silences longer than 2 seconds
ffmpeg -i input.mp3 -af "silenceremove=stop_periods=-1:stop_duration=2:stop_threshold=-40dB" output.mp3

# Parameters:
# stop_periods=-1: Process entire file
# stop_duration=2: Remove silences > 2 seconds
# stop_threshold=-40dB: Consider below this as silence
```

---

## 5. Noise Floor

### 5.1 Requirements

```yaml
noise_floor:
  target: "< -60 dB"
  maximum: "-50 dB (ACX requirement)"

  sources_of_noise:
    - Room ambient noise
    - Equipment hum
    - TTS artifacts
    - Compression artifacts

  detection:
    - Analyze silent sections
    - Use spectrum analyzer
    - Listen at high volume
```

### 5.2 Noise Reduction

```bash
# Basic noise gate
ffmpeg -i input.mp3 -af "agate=threshold=-40dB:ratio=2:attack=10:release=100" output.mp3

# Highpass filter (remove low rumble)
ffmpeg -i input.mp3 -af "highpass=f=80" output.mp3

# Combined
ffmpeg -i input.mp3 -af "highpass=f=80,agate=threshold=-40dB:ratio=2" output.mp3
```

---

## 6. Clipping and Peak Limiting

### 6.1 True Peak

```yaml
true_peak:
  definition: "Maximum sample value in dBFS"
  target: "-1.5 dBTP (broadcast)"
  acx_requirement: "-3 dB"

  why_headroom:
    - Prevents clipping during encoding
    - Allows for DAC reconstruction
    - Platform re-encoding safety margin
```

### 6.2 Detecting Clipping

```bash
# Analyze peaks
ffmpeg -i input.mp3 -af "astats=metadata=1:reset=1" -f null - 2>&1 | grep Peak

# Using volumedetect
ffmpeg -i input.mp3 -af volumedetect -f null - 2>&1
```

### 6.3 Limiting

```bash
# Hard limiter at -1.5 dB
ffmpeg -i input.mp3 -af "alimiter=limit=-1.5dB:attack=5:release=50" output.mp3

# Soft limiting (more natural)
ffmpeg -i input.mp3 -af "acompressor=threshold=-3dB:ratio=20:attack=0.1:release=50,volume=-1.5dB" output.mp3
```

---

## 7. Sample Rate and Bit Depth

### 7.1 Sample Rate

```yaml
sample_rates:
  44100_hz:
    standard: "CD quality, most common for audio"
    use_for: "Final audiobook delivery"

  48000_hz:
    standard: "Video/broadcast standard"
    use_for: "If source is 48kHz, keep it"

  24000_hz:
    standard: "TTS output common rate"
    note: "Upsample to 44100 for delivery"

conversion:
  command: "ffmpeg -i input.mp3 -ar 44100 output.mp3"
```

### 7.2 Bit Depth

```yaml
bit_depth:
  16_bit:
    range: "96 dB dynamic range"
    use_for: "Final delivery (MP3/M4B)"

  24_bit:
    range: "144 dB dynamic range"
    use_for: "Processing, mastering"

  note: "MP3 and AAC use 16-bit internally"
```

---

## 8. FFmpeg Reference Commands

### 8.1 Format Conversion

```bash
# MP3 to M4B
ffmpeg -i input.mp3 -c:a aac -b:a 128k output.m4b

# WAV to MP3
ffmpeg -i input.wav -c:a libmp3lame -b:a 192k -ar 44100 -ac 1 output.mp3

# Any to WAV (for processing)
ffmpeg -i input.mp3 -c:a pcm_s16le -ar 44100 -ac 1 output.wav
```

### 8.2 Audio Analysis

```bash
# Complete audio info
ffprobe -v quiet -show_format -show_streams input.mp3

# Duration only
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp3

# Bitrate
ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 input.mp3
```

### 8.3 Complete Processing Pipeline

```bash
#!/bin/bash
# audiobook-master.sh - Complete audiobook mastering

INPUT="$1"
OUTPUT="$2"
LUFS="${3:--14}"
PEAK="${4:--1.5}"

ffmpeg -i "$INPUT" \
  -af "highpass=f=80,\
       silenceremove=stop_periods=-1:stop_duration=2:stop_threshold=-40dB,\
       loudnorm=I=$LUFS:TP=$PEAK:LRA=11,\
       afade=t=in:st=0:d=0.5,\
       afade=t=out:st=END-1:d=1" \
  -ar 44100 -ac 1 \
  -c:a libmp3lame -b:a 192k \
  "$OUTPUT"
```

---

## 9. Platform-Specific Requirements

### 9.1 Audible ACX

```yaml
acx_specs:
  format: MP3
  bitrate: 192 kbps CBR
  sample_rate: 44100 Hz
  channels: Mono

  loudness:
    rms: "-23 to -18 dB"  # Not LUFS, but RMS
    peak: "-3 dB max"
    noise_floor: "-60 dB"

  structure:
    - Opening credits (title, author, narrator)
    - Main content
    - Closing credits
    - 0.5-1s room tone at start
    - 1-5s room tone at end

  file_requirements:
    - Each chapter as separate file
    - Files named: "Chapter01.mp3", etc.
    - Or sections: "Opening.mp3", "Part1_Chapter1.mp3"

  cover:
    size: "2400x2400 pixels"
    format: "JPEG, RGB"
```

### 9.2 Apple Books

```yaml
apple_books:
  format: M4B preferred (MP3 accepted)
  bitrate: 128-256 kbps AAC
  sample_rate: 44100 Hz
  channels: Mono

  chapters:
    - Must have chapter markers
    - Chapter titles required

  cover:
    size: "2400x2400 pixels minimum"
    format: "JPEG"
```

### 9.3 Spotify (Podcast)

```yaml
spotify_podcast:
  format: MP3 or M4A
  bitrate: 128-320 kbps
  sample_rate: 44100 Hz

  loudness:
    target: -14 LUFS

  cover:
    size: "3000x3000 pixels"
    format: "JPEG, PNG"
```

---

## 10. Quality Validation Script

```bash
#!/bin/bash
# validate-audiobook.sh - Validate audiobook audio quality

FILE="$1"

echo "=== Audiobook Audio Validation ==="
echo "File: $FILE"
echo ""

# Get format info
echo "--- Format Info ---"
ffprobe -v error -show_entries format=format_name,duration,bit_rate -of default=noprint_wrappers=1 "$FILE"

# Get audio stream info
echo ""
echo "--- Audio Stream ---"
ffprobe -v error -show_entries stream=codec_name,sample_rate,channels,bit_rate -of default=noprint_wrappers=1 "$FILE"

# Analyze loudness
echo ""
echo "--- Loudness Analysis ---"
ffmpeg -i "$FILE" -af loudnorm=print_format=summary -f null - 2>&1 | tail -20

# Check peaks
echo ""
echo "--- Peak Analysis ---"
ffmpeg -i "$FILE" -af volumedetect -f null - 2>&1 | grep -E "max_volume|mean_volume"

echo ""
echo "=== Validation Complete ==="
```

---

## 11. Quick Reference Card

```
┌────────────────────────────────────────────────────────────┐
│                AUDIOBOOK AUDIO STANDARDS                   │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  FORMAT          MP3: 192kbps CBR / M4B: 128kbps AAC      │
│  SAMPLE RATE     44100 Hz                                  │
│  CHANNELS        Mono                                      │
│                                                            │
│  LOUDNESS                                                  │
│  ├─ Broadcast    -14 LUFS, -1.5 dBTP                      │
│  └─ ACX/Audible  -23 to -18 LUFS, -3 dB peak             │
│                                                            │
│  NOISE FLOOR     < -60 dB                                 │
│  LOUDNESS RANGE  7-11 LU                                  │
│                                                            │
│  SILENCE                                                   │
│  ├─ Start/End    0.5-1.0s room tone                       │
│  ├─ Sentences    0.3-0.8s                                 │
│  ├─ Paragraphs   0.8-1.5s                                 │
│  └─ Chapters     2.0-3.0s                                 │
│                                                            │
│  FADES                                                     │
│  ├─ Fade In      0.5s                                     │
│  └─ Fade Out     1.0s                                     │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

*"Technical excellence is invisible - listeners only notice when something is wrong."*
