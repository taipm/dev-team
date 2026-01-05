# Step 04.5: CHARACTER VOICE

> Fiction-only: Map characters to distinct voices

---

## Step Info

```yaml
step: 4.5
name: character-voice
title: "Character Voice Mapping"
description: "Detect characters, analyze traits, assign distinct voices"

trigger: step.04.complete AND genre == "fiction"
agent: character-voice-agent

duration: "3-10 minutes"
checkpoint: false

condition:
  field: structure.genre
  value: ["fiction", "novel", "short_story", "drama"]
  if_not_matched: skip_to_step_05
```

---

## Responsible Agent

**Character Voice Agent** (`🎭`)
- Detects characters from dialogue
- Analyzes character traits
- Assigns unique voices
- Tags dialogue in scripts

---

## Input

```yaml
input:
  from_step: step-04-adaptation
  files:
    - scripts/chapter-{NNN}-script.yaml
    - structure/book-structure.json

  subscribe:
    - script.adapted
    - structure.genre
```

---

## Process

### 1. Character Detection

```python
patterns = [
    r'"([^"]+)"\s+said\s+(\w+)',
    r'"([^"]+)"\s*-\s*(\w+)',
    r'(\w+)\s+said:\s*"([^"]+)"',
]
```

### 2. Trait Analysis

| Trait | Indicators |
|-------|------------|
| Gender | Pronouns, titles, names |
| Age | Speech patterns, vocabulary |
| Personality | Tone, word choice |
| Social class | Formality, grammar |

### 3. Voice Assignment

```yaml
voice_pool:
  english:
    female:
      - en-US-JennyNeural
      - en-US-AriaNeural
      - en-US-SaraNeural
    male:
      - en-US-GuyNeural
      - en-US-ChristopherNeural
      - en-US-EricNeural

  vietnamese:
    female:
      - vi-VN-HoaiMyNeural
    male:
      - vi-VN-NamMinhNeural
```

### 4. Dialogue Tagging

```yaml
segments:
  - id: "ch1-s001"
    type: narration
    voice: vi-VN-HoaiMyNeural

  - id: "ch1-s002"
    type: dialogue
    character: "John"
    voice: en-US-GuyNeural
```

---

## Output

```yaml
output:
  files:
    - voice/character-map.yaml
    - voice/tagged-scripts/chapter-{NNN}-tagged.yaml

  character_map_format:
    characters:
      - name: string
        voice: string
        gender: male|female
        age: young|adult|elderly
        traits: [list]
        dialogue_count: number
        prosody:
          rate: string
          pitch: string

  publish:
    - topic: voice.character_map
      payload: character-map.yaml
    - topic: voice.dialogue_tagged
      payload: tagged-scripts/
```

---

## Success Criteria

```yaml
success:
  - all_characters_detected: true
  - unique_voice_per_character: true
  - narrator_distinct: true
  - all_dialogue_tagged: true
  - character_map_complete: true
```

---

## Skip Condition

```yaml
skip:
  if: genre NOT IN ["fiction", "novel", "short_story", "drama"]
  action: proceed_to_step_05
  note: "Non-fiction uses single narrator voice"
```

---

## Error Handling

```yaml
errors:
  no_characters:
    action: use_single_narrator

  ambiguous_speaker:
    action: use_narrator_voice

  insufficient_voices:
    action: vary_prosody_for_same_voice
```

---

## Next Step

- **Step 05: PRODUCTION** - Audio Producer Agent generates TTS audio
