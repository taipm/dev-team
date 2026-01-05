# Step 03: STRUCTURE

> Analyze book structure, detect chapters, classify genre

---

## Step Info

```yaml
step: 3
name: structure
title: "Book Structure Analysis"
description: "Detect chapters, generate TOC, classify genre, split content"

trigger: step.02.complete
agent: book-structure-agent

duration: "2-5 minutes"
checkpoint: true
```

---

## Responsible Agent

**Book Structure Agent** (`📚`)
- Detects chapter boundaries
- Generates table of contents
- Classifies book genre
- Splits content into chapter files

---

## Input

```yaml
input:
  from_step: step-02-ingestion
  files:
    - raw/raw-content.txt
    - raw/source-metadata.json

  subscribe:
    - content.raw_text
    - content.source_metadata
```

---

## Process

### 1. Chapter Detection

```python
patterns = [
    r'^Chapter\s+\d+',
    r'^CHAPTER\s+\d+',
    r'^Chương\s+\d+',
    r'^Part\s+[IVXLCDM]+',
    r'^\d+\.\s+[A-Z]',
]
```

### 2. Genre Classification

| Genre | Indicators |
|-------|------------|
| Fiction | Dialogue, character names, scenes |
| Business | Statistics, frameworks, case studies |
| Self-Help | "You", advice, exercises |
| Technical | Code, formulas, diagrams |
| Biography | Dates, chronology |

### 3. Content Splitting

```
structure/chapters/
├── chapter-000-front-matter.md
├── chapter-001.md
├── chapter-002.md
├── ...
└── chapter-999-back-matter.md
```

### 4. TOC Generation

```json
{
  "book_title": "...",
  "author": "...",
  "total_chapters": 14,
  "total_words": 75000,
  "estimated_total_duration": "8:20:00",
  "genre": "business",
  "chapters": [
    {
      "number": 1,
      "title": "Chapter 1: Start",
      "file": "chapter-001.md",
      "word_count": 5000,
      "estimated_duration": "33:20"
    }
  ]
}
```

---

## Output

```yaml
output:
  files:
    - structure/chapters/chapter-{NNN}.md
    - structure/table-of-contents.json
    - structure/book-structure.json

  publish:
    - topic: structure.chapters
      payload: table-of-contents.json
    - topic: structure.toc
      payload: table-of-contents.json
    - topic: structure.genre
      payload: book-structure.json

  checkpoint:
    name: "structure-complete"
    files:
      - structure/table-of-contents.json
      - structure/book-structure.json
```

---

## Success Criteria

```yaml
success:
  - chapters_detected: ">= 1"
  - each_chapter_has_content: "> 100 words"
  - toc_valid: table-of-contents.json
  - genre_classified: confidence > 0.6
  - all_content_accounted: true
```

---

## Error Handling

```yaml
errors:
  no_chapters_detected:
    action: treat_as_single_chapter
    note: "Content treated as one chapter"

  too_many_chapters:
    threshold: 100
    action: merge_short_chapters
    min_words: 500

  genre_unclear:
    action: use_default
    default: "general"
```

---

## Next Step

- **Step 04: ADAPTATION** - Script Adapter Agent converts text to speech-ready scripts
