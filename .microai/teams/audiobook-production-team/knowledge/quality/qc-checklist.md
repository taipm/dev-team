# Quality Control Checklist

> Comprehensive QC checklist for audiobook production

---

## Technical Quality (30%)

### File Integrity
- [ ] All audio files are valid MP3/M4B
- [ ] No corrupted files
- [ ] File sizes are reasonable

### Format Compliance
- [ ] Format: MP3 192kbps CBR or M4B 128kbps AAC
- [ ] Sample rate: 44100 Hz
- [ ] Channels: Mono
- [ ] Duration matches expected

### Encoding Quality
- [ ] No compression artifacts
- [ ] Clean encoding without glitches
- [ ] Consistent quality throughout

---

## Loudness Compliance (25%)

### LUFS Standards
- [ ] Integrated loudness: -16 to -12 LUFS
- [ ] Target: -14 LUFS for broadcast
- [ ] Consistent across all chapters

### Peak Control
- [ ] True peak: <= -1.5 dBTP
- [ ] No clipping detected
- [ ] No digital overs

### Dynamic Range
- [ ] Loudness Range (LRA): 5-15 dB
- [ ] Natural dynamics preserved
- [ ] Not over-compressed

---

## Content Quality (25%)

### Audio Clarity
- [ ] Clear, intelligible speech
- [ ] No background noise
- [ ] No mic pops or clicks

### TTS Quality
- [ ] Natural-sounding pronunciation
- [ ] Correct word emphasis
- [ ] Appropriate pacing

### Language Handling
- [ ] Correct language detection
- [ ] Proper pronunciation of foreign words
- [ ] Smooth language transitions

---

## Structure Quality (20%)

### Chapter Organization
- [ ] All chapters present
- [ ] Correct chapter order
- [ ] Chapter durations reasonable

### Silence Handling
- [ ] No silences > 3 seconds
- [ ] Appropriate pauses between sections
- [ ] Clean chapter transitions

### Fades
- [ ] Fade-in applied at start (0.5s)
- [ ] Fade-out applied at end (1.0s)
- [ ] No abrupt starts/endings

### Transitions
- [ ] Smooth chapter-to-chapter flow
- [ ] No jarring cuts
- [ ] Consistent audio levels

---

## Metadata Quality

### ID3 Tags (MP3)
- [ ] Title present
- [ ] Artist (author) present
- [ ] Album (book title) present
- [ ] Track numbers correct
- [ ] Cover art embedded

### M4B Chapters
- [ ] Chapter markers present
- [ ] Chapter titles correct
- [ ] Timestamps accurate

---

## ACX/Audible Compliance

For Audible distribution:

### Audio Requirements
- [ ] MP3 format, 192 kbps CBR
- [ ] 44.1 kHz sample rate
- [ ] Mono channel

### Loudness Requirements
- [ ] RMS: -23 to -18 dB
- [ ] Peak: <= -3 dB
- [ ] Noise floor: <= -60 dB

### Structure Requirements
- [ ] 0.5-1s room tone at opening
- [ ] 1-5s room tone at closing
- [ ] No extraneous sounds

---

## Scoring Rubric

| Score | Grade | Description | Action |
|-------|-------|-------------|--------|
| 90-100 | A | Excellent | Publish immediately |
| 80-89 | B | Good | Publish with notes |
| 60-79 | C | Acceptable | Review recommended |
| 40-59 | D | Poor | Fixes required |
| 0-39 | F | Fail | Quarantine |

---

## Critical Failures (Auto-Reject)

The following issues result in automatic rejection:

- [ ] Corrupted audio files
- [ ] Severe clipping throughout
- [ ] Missing chapters
- [ ] Wrong audio content
- [ ] Completely silent audio
- [ ] Extremely low quality TTS
- [ ] Wrong language throughout

---

## Issue Severity

### Critical
- Results in rejection
- Must fix before publishing

### Major
- Score reduction: -15 to -25 points
- Should fix, may publish with notes

### Minor
- Score reduction: -5 to -10 points
- Nice to fix, can publish

### Cosmetic
- Score reduction: -1 to -5 points
- Optional fix

---

*"Quality is not negotiable - every listener deserves excellence."*
