# Step 07.5: COVER DESIGN

> Generate or process audiobook cover artwork

---

## Step Info

```yaml
step: 7.5
name: cover-design
title: "Cover Design"
description: "Generate AI cover or process user-provided cover, create all sizes"

trigger: step.07.complete AND quality.approved
agent: cover-designer-agent

duration: "2-5 minutes"
checkpoint: false
```

---

## Responsible Agent

**Cover Designer Agent** (`🎨`)
- Generates AI cover art (if needed)
- Processes user-provided cover
- Creates all platform sizes
- Validates cover quality

---

## Input

```yaml
input:
  from_step: step-07-review
  files:
    - structure/book-structure.json
    - raw/source-metadata.json

  subscribe:
    - quality.approved
    - structure.book_analysis

  optional:
    - user_provided_cover.jpg
```

---

## Process

### 1. Cover Source Decision

```yaml
sources:
  user_provided:
    check: exists(user_cover.jpg)
    action: validate_and_process

  ai_generated:
    check: not exists(user_cover.jpg)
    action: generate_prompt_and_create
```

### 2. AI Generation (if needed)

```yaml
prompt_template: |
  Professional audiobook cover for "{title}" by {author}.
  Genre: {genre}. Style: {genre_style}.
  High quality, square format, no text.

genre_styles:
  business: "professional, corporate, minimalist"
  fiction: "atmospheric, cinematic, evocative"
  self_help: "inspiring, warm, uplifting"
  technical: "modern, clean, tech-forward"
```

### 3. Size Generation

```yaml
sizes:
  master: 3000x3000 PNG
  audible: 2400x2400 JPEG
  standard: 1400x1400 JPEG
  thumbnail: 500x500 JPEG
  preview: 200x200 JPEG
```

### 4. Validation

```yaml
validation:
  - square_format: true
  - minimum_size: 2400x2400
  - valid_format: JPEG or PNG
  - file_not_corrupt: true
```

---

## Output

```yaml
output:
  files:
    - covers/cover-master-3000.png
    - covers/cover-audible-2400.jpg
    - covers/cover-standard-1400.jpg
    - covers/cover-thumbnail-500.jpg
    - covers/cover-preview-200.jpg
    - covers/cover-metadata.json
    - covers/prompt.txt (if AI-generated)

  publish:
    - topic: cover.generated
    - topic: cover.assets
```

---

## Success Criteria

```yaml
success:
  - cover_exists: true
  - all_sizes_generated: true
  - minimum_resolution: 2400x2400
  - valid_format: true
  - metadata_created: true
```

---

## Error Handling

```yaml
errors:
  ai_generation_failed:
    action: retry_different_prompt
    max_retries: 3
    fallback: use_placeholder

  low_resolution_input:
    action: upscale_if_possible
    min_quality: 1200x1200
    fallback: regenerate

  invalid_format:
    action: convert_to_valid
```

---

## Next Step

- **Step 08: METADATA** - Metadata Agent packages for distribution
