# Step 05: Visual Design

```yaml
step: 5
name: visual-design
description: Thiết kế slides và visual assets
trigger: visual cues + audio timestamps received
agent: visual-designer-agent
next: step-06-video-assembly
checkpoint: true
loop: true
```

---

## Purpose

Visual Designer tạo slides, graphics, và thumbnail dựa trên visual cues và synchronized với audio timestamps.

---

## Input

```yaml
subscribed:
  - script.visual_cues
  - audio.timestamps

from_visual_cues:
  - Cue list with types
  - Content per cue
  - Timing requirements

from_timestamps:
  - Actual audio durations
  - Sync points

from_knowledge:
  - slide-templates.md
  - brand-guidelines.md
```

---

## Actions

### 1. Parse Visual Requirements

```yaml
parsing:
  - Map cues to slide types
  - Extract text content
  - Identify special elements
  - Calculate durations from timestamps
```

### 2. Load Brand Assets

```yaml
brand:
  colors:
    primary: "#FF6B35"
    secondary: "#4ECDC4"
    accent: "#45B7D1"
    background: "#1A1A2E"

  fonts:
    heading: Inter Bold
    body: Roboto Regular
    accent: Roboto Mono

  assets:
    logo: assets/logo.png
    watermark: assets/watermark.png
```

### 3. Generate Slides

For each visual cue:

```yaml
slide_generation:
  - Select template based on cue type
  - Apply brand colors and fonts
  - Insert content
  - Resize for format (9:16 or 16:9)
  - Export as PNG
```

Slide types:
- `title_card`: Video title, branding
- `word_card`: Vocabulary display with IPA
- `example_card`: Example sentences
- `tip_card`: Learning tips with icon
- `summary_card`: Key takeaways
- `cta_card`: Subscribe, follow

### 4. Create Thumbnail

```yaml
thumbnail:
  variants: 3
  elements:
    - Large, readable text
    - Brand colors
    - Topic visual
    - Attention grabber
  size: 1280x720
```

### 5. Generate Visual Manifest

```yaml
manifest:
  slides:
    - id: slide_01
      file: slides/01_title.png
      start_ms: 0
      end_ms: 5000
      transition: fade
      duration_ms: 500
  thumbnail:
    file: thumbnail.png
    variants: [a, b, c]
```

---

## Output

```yaml
deliverables:
  - visuals/{video_id}/slides/*.png
  - visuals/{video_id}/thumbnail.png
  - visuals/{video_id}/thumbnail_variants/
  - visuals/{video_id}/visual-manifest.json

published:
  - visual.slides
  - visual.thumbnail
```

---

## Quality Gate

```yaml
validation:
  - All slides generated
  - Text readable at target resolution
  - Brand colors applied correctly
  - Timing matches audio timestamps
  - Thumbnail compelling
```

---

## Design Specifications

### Shorts (9:16)

```yaml
shorts:
  resolution: 1080x1920
  safe_zone: 108x192 margin
  text:
    heading: 72px
    body: 48px
    minimum: 36px
```

### Standard (16:9)

```yaml
standard:
  resolution: 1920x1080
  safe_zone: 192x108 margin
  text:
    heading: 64px
    body: 36px
    minimum: 24px
```

---

## Checkpoint

```yaml
checkpoint:
  step: 5
  video_id: {id}
  status: complete
  slides_count: {n}
  thumbnail: created
  timestamp: {time}
```

---

## Handoff

→ **Step 06: Video Assembly** với Video Assembler Agent

Pass: visual.slides, visual-manifest.json

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║               🎨 VISUAL DESIGNER - VISUALS COMPLETE                    ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Visual Assets:                                                       ║
║   ├── Slides: {count} generated                                       ║
║   ├── Thumbnail: ✓ + 3 variants                                       ║
║   ├── Format: {shorts|standard}                                       ║
║   └── Resolution: {resolution}                                        ║
║                                                                        ║
║   Brand Compliance: ✓ Verified                                        ║
║                                                                        ║
║   Transitions:                                                         ║
║   ├── Fade: {count}                                                   ║
║   ├── Slide: {count}                                                  ║
║   └── None: {count}                                                   ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Handoff to Video Assembler...                                     ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
