# Step 04: ADAPTATION

> Convert text to speech-optimized scripts with prosody

---

## Step Info

```yaml
step: 4
name: adaptation
title: "Script Adaptation"
description: "Convert written text to TTS-friendly scripts with prosody hints"

trigger: step.03.complete
agent: script-adapter-agent

duration: "5-15 minutes"
checkpoint: true
```

---

## Responsible Agent

**Script Adapter Agent** (`✍️`)
- Expands abbreviations
- Converts numbers to words
- Adds prosody markers
- Tags language segments

---

## Input

```yaml
input:
  from_step: step-03-structure
  files:
    - structure/chapters/chapter-{NNN}.md
    - structure/book-structure.json

  subscribe:
    - structure.chapters
    - structure.genre
```

---

## Process

### 1. Abbreviation Expansion

| Input | Output |
|-------|--------|
| Mr. | Mister |
| Dr. | Doctor |
| CEO | C.E.O. |
| etc. | et cetera |

### 2. Number Conversion

| Input | Output |
|-------|--------|
| 100 | one hundred |
| $1.5M | one point five million dollars |
| 15% | fifteen percent |
| 2024 | twenty twenty-four |

### 3. Prosody Markers

```yaml
pauses:
  ",": 300ms
  ".": 500ms
  "!": 600ms
  "?": 600ms
  paragraph: 1000ms
  section: 2000ms

emphasis:
  quotes: moderate
  important_terms: strong

rate:
  normal: 0%
  important: -10%
  exciting: +10%
```

### 4. Language Tagging

```yaml
# For mixed-language content
segments:
  - text: "Từ"
    lang: vi
    voice: vi-VN-HoaiMyNeural

  - text: "accomplish"
    lang: en
    voice: en-US-JennyNeural
```

---

## Output

```yaml
output:
  files:
    - scripts/chapter-{NNN}-script.yaml
    - scripts/prosody-plan.json

  script_format:
    chapter: number
    title: string
    segments:
      - id: string
        original: string
        adapted: string
        type: narration|dialogue|heading
        lang: vi|en
        voice: string
        prosody:
          rate: string
          pitch: string
        pauses:
          before: ms
          after: ms

  publish:
    - topic: script.adapted
      payload: scripts/
    - topic: script.prosody
      payload: prosody-plan.json

  checkpoint:
    name: "adaptation-complete"
```

---

## Success Criteria

```yaml
success:
  - all_chapters_processed: true
  - abbreviations_expanded: true
  - numbers_converted: true
  - prosody_markers_added: true
  - segment_ids_unique: true
  - estimated_duration_reasonable: true
```

---

## Error Handling

```yaml
errors:
  unknown_abbreviation:
    action: keep_original

  complex_number:
    action: spell_digits

  language_detection_failed:
    action: use_primary_language
```

---

## Next Step

- **Step 04.5: CHARACTER VOICE** (if fiction) - Character Voice Agent maps voices
- **Step 05: PRODUCTION** (if non-fiction) - Audio Producer Agent generates TTS
