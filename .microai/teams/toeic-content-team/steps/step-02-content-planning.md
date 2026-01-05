# Step 02: Content Planning

```yaml
step: 2
name: content-planning
description: Nghiên cứu topics và tạo content briefs
trigger: step-01-complete
agent: content-planner-agent
next: step-03-script-writing
checkpoint: true
```

---

## Purpose

Content Planner nghiên cứu trending topics, keywords, và tạo detailed briefs cho batch videos.

---

## Input

```yaml
from_session:
  - batch_size
  - content_mix
  - formats
from_knowledge:
  - toeic-fundamentals.md
  - youtube-best-practices.md
```

---

## Actions

### 1. Topic Research

```yaml
research:
  sources:
    - YouTube trending (TOEIC category)
    - Google Trends (TOEIC keywords)
    - Competitor analysis
  criteria:
    - High search volume
    - Low competition
    - Educational value
    - Evergreen potential
```

### 2. Keyword Analysis

```yaml
keywords:
  primary: 1 per video
  secondary: 3-5 per video
  long_tail: 2-3 per video
  analysis:
    - Search volume
    - Competition score
    - Relevance to TOEIC
```

### 3. Content Calendar Generation

```yaml
calendar:
  distribution:
    vocabulary: {batch_size * vocab_pct}
    listening: {batch_size * listening_pct}
    grammar: {batch_size * grammar_pct}
  scheduling:
    shorts: morning posts
    standard: evening posts
```

### 4. Brief Generation

For each video in batch:

```yaml
brief:
  title: SEO-optimized
  type: vocabulary|listening|grammar
  format: shorts|standard
  duration: estimated
  keywords: primary + secondary
  outline: structured sections
  level: beginner|intermediate|advanced
  notes: special instructions
```

---

## Output

```yaml
deliverables:
  - planning/topic-briefs.json
  - planning/keywords.json
  - planning/content-calendar.yaml

published:
  - content.topic_brief (per video)
  - content.keywords
  - content.calendar
```

---

## Quality Gate

```yaml
validation:
  - All briefs have required fields
  - Keywords researched and validated
  - Distribution matches content_mix
  - No duplicate topics
```

---

## Checkpoint

Save state after planning complete:

```yaml
checkpoint:
  step: 2
  status: complete
  briefs_count: {n}
  timestamp: {time}
```

---

## Handoff

→ **Step 03: Script Writing** với Script Writer Agent

Pass: First topic brief from queue

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║               📋 CONTENT PLANNER - PLANNING COMPLETE                   ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Topics Generated: {count}                                            ║
║                                                                        ║
║   Distribution:                                                        ║
║   ├── Vocabulary: {v_count} ({v_pct}%)                                ║
║   ├── Listening: {l_count} ({l_pct}%)                                 ║
║   └── Grammar: {g_count} ({g_pct}%)                                   ║
║                                                                        ║
║   Formats:                                                             ║
║   ├── Shorts: {shorts_count}                                          ║
║   └── Standard: {standard_count}                                      ║
║                                                                        ║
║   Keywords Researched: {keyword_count}                                 ║
║   Average Search Volume: {avg_volume}                                  ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Handoff to Script Writer...                                       ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
