# Edge-TTS Voice Reference

> Available voices for audiobook production

---

## Vietnamese Voices

| Voice ID | Gender | Description | Use Case |
|----------|--------|-------------|----------|
| vi-VN-HoaiMyNeural | Female | Warm, natural | Primary narrator |
| vi-VN-NamMinhNeural | Male | Clear, professional | Male narrator |

### Vietnamese Voice Characteristics

**vi-VN-HoaiMyNeural** (Recommended)
- Natural, warm tone
- Excellent for educational content
- Good pacing and clarity
- Best for: Narration, general content

**vi-VN-NamMinhNeural**
- Clear, authoritative
- Good for professional content
- Slightly formal tone
- Best for: Business, technical content

---

## English Voices

### Female Voices

| Voice ID | Description | Use Case |
|----------|-------------|----------|
| en-US-JennyNeural | Warm, friendly | Default female |
| en-US-AriaNeural | Young, energetic | Young characters |
| en-US-SaraNeural | Calm, professional | Business content |
| en-US-MichelleNeural | Clear, neutral | General purpose |

### Male Voices

| Voice ID | Description | Use Case |
|----------|-------------|----------|
| en-US-GuyNeural | Authoritative, deep | Default male |
| en-US-ChristopherNeural | Friendly, warm | Conversational |
| en-US-EricNeural | Young, casual | Younger characters |
| en-US-DavisNeural | Professional, clear | Business content |

---

## Voice Selection Guide

### By Genre

| Genre | Recommended Voice |
|-------|-------------------|
| Business | vi-VN-HoaiMyNeural + en-US-SaraNeural |
| Fiction | Multiple voices based on characters |
| Self-Help | vi-VN-HoaiMyNeural (warm, friendly) |
| Technical | vi-VN-NamMinhNeural (clear, precise) |
| Biography | vi-VN-HoaiMyNeural |

### By Character Type

| Character | Recommended Voice |
|-----------|-------------------|
| Narrator | vi-VN-HoaiMyNeural |
| Male protagonist | en-US-GuyNeural |
| Female protagonist | en-US-JennyNeural |
| Young female | en-US-AriaNeural |
| Young male | en-US-EricNeural |
| Elderly | en-US-ChristopherNeural (-15% rate) |
| Authority figure | en-US-GuyNeural |

---

## Prosody Adjustments

### Rate Modifiers

| Modifier | Effect | Use Case |
|----------|--------|----------|
| -20% | Very slow | Complex concepts |
| -10% | Slow | Important points |
| +0% | Normal | Default |
| +10% | Fast | Excitement, action |
| +15% | Very fast | High energy |

### Pitch Modifiers

| Modifier | Effect | Use Case |
|----------|--------|----------|
| -10Hz | Lower | Elderly, serious |
| +0Hz | Normal | Default |
| +10Hz | Higher | Questions |
| +15Hz | High | Children, excited |

---

## Edge-TTS Command Examples

### Basic Generation

```bash
edge-tts --text "Hello world" \
    --voice en-US-JennyNeural \
    --write-media output.mp3
```

### With Rate Adjustment

```bash
edge-tts --text "Important point" \
    --voice vi-VN-HoaiMyNeural \
    --rate "-10%" \
    --write-media output.mp3
```

### With Pitch Adjustment

```bash
edge-tts --text "Question?" \
    --voice en-US-JennyNeural \
    --pitch "+10%" \
    --write-media output.mp3
```

### Combined Adjustments

```bash
edge-tts --text "Excited speech!" \
    --voice en-US-AriaNeural \
    --rate "+10%" \
    --pitch "+5Hz" \
    --write-media output.mp3
```

---

## Voice Quality Tips

### Best Practices

1. **Use consistent voices** - Don't change narrator mid-book
2. **Test pronunciation** - Check technical terms
3. **Adjust rate for complexity** - Slow down for difficult content
4. **Use pauses** - Add natural breaks between sections

### Common Issues

| Issue | Solution |
|-------|----------|
| Mispronunciation | Spell phonetically |
| Too fast | Reduce rate by 10% |
| Monotone | Add prosody markers |
| Unnatural pauses | Adjust punctuation |

---

## Language-Specific Notes

### Vietnamese

- Edge-TTS handles Vietnamese tones well
- Diacritics must be correct
- Numbers read correctly

### English

- Wide voice variety
- Good pronunciation
- Handles most technical terms

### Mixed Content

- Tag language switches explicitly
- Use appropriate voice for each language
- Allow brief pause at transitions

---

*"The right voice brings words to life."*
