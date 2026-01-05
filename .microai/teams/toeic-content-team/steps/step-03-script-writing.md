# Step 03: Script Writing

```yaml
step: 3
name: script-writing
description: Viết script chi tiết với timestamps và visual cues
trigger: content.topic_brief received
agent: script-writer-agent
next: step-04-audio-production
checkpoint: true
loop: true  # Loops for each video in batch
```

---

## Purpose

Script Writer chuyển topic brief thành production-ready script với timestamps, visual cues, và TOEIC-validated content.

---

## Input

```yaml
subscribed:
  - content.topic_brief

from_brief:
  - title
  - type (vocabulary|listening|grammar)
  - format (shorts|standard)
  - keywords
  - outline
  - level
  - duration target

from_knowledge:
  - toeic-fundamentals.md
  - script-formats.md
  - toeic-vocabulary.md
```

---

## Actions

### 1. Parse Topic Brief

Extract requirements:
- Content type
- Target duration
- Key messages
- Special instructions

### 2. Generate Script Structure

```yaml
structure:
  shorts:
    - hook (0-5s)
    - problem (5-10s)
    - main_content (10-45s)
    - summary (45-55s)
    - cta (55-60s)

  standard:
    - hook (0-15s)
    - intro (15-45s)
    - main_content (45s-{end-60s})
    - summary ({end-60s}-{end-15s})
    - cta ({end-15s}-end)
```

### 3. Write Script Content

For each section:
- Write spoken text
- Mark timestamps
- Add visual cues [VISUAL: ...]
- Add audio cues [AUDIO: ...]
- Add pause markers [PAUSE]

### 4. Validate TOEIC Content

```yaml
validation:
  vocabulary:
    - Word in official TOEIC list
    - Definition accurate
    - Example grammatically correct
    - Usage appropriate

  listening:
    - Context realistic
    - Language level appropriate
    - Key phrases identified

  grammar:
    - Rule explanation correct
    - Examples valid
    - Common mistakes accurate
```

### 5. Generate Visual Cues

```yaml
cues:
  - type: title|word|example|tip|summary|cta
  - timestamp: start-end
  - content: text or description
  - style: slide template reference
```

---

## Output

```yaml
deliverables:
  - scripts/{video_id}/script.md
  - scripts/{video_id}/visual-cues.json
  - scripts/{video_id}/timestamps.json

published:
  - script.complete
  - script.visual_cues
```

---

## Quality Gate

```yaml
validation:
  - Script word count matches duration
  - All sections have timestamps
  - Visual cues generated
  - TOEIC content validated
  - No placeholder text remaining
```

---

## Checkpoint

```yaml
checkpoint:
  step: 3
  video_id: {id}
  status: complete
  word_count: {n}
  visual_cues: {n}
  timestamp: {time}
```

---

## Loop Control

```yaml
loop:
  condition: while topic_briefs_remaining > 0
  on_complete: process next brief
  on_batch_complete: proceed to step-04
```

---

## Handoff

→ **Step 04: Audio Production** với Audio Producer Agent

Pass: script.complete message

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║               ✍️ SCRIPT WRITER - SCRIPT COMPLETE                       ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Script Details:                                                      ║
║   ├── Type: {vocabulary|listening|grammar}                            ║
║   ├── Format: {shorts|standard}                                       ║
║   ├── Word Count: {count}                                             ║
║   ├── Est. Duration: {duration}                                       ║
║   └── Visual Cues: {cue_count}                                        ║
║                                                                        ║
║   TOEIC Validation: ✓ Passed                                          ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Handoff to Audio Producer...                                      ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
