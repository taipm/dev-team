# Task Templates

Templates for different task types in Daily Agent.

---

## Research Task Template

```yaml
type: research
title: "{topic} Research"
description: "Research {topic} from arxiv papers"
priority: medium
config:
  topic: "{topic}"
  max_papers: 5
  categories:
    - cs.AI
    - cs.LG
    - cs.CL
  date_range: "last_7_days"
  output_format: "digest"
```

### Research Output Structure

```
output/daily/{date}/research/
├── digest.md           # Summary of all papers
├── papers/
│   └── {arxiv_id}.md   # Individual paper analysis
└── papers.bib          # BibTeX export
```

### Research Digest Template

```markdown
# Research Digest - {date}

## Topic: {topic}

### Papers Found: {count}

---

## Top Papers

### 1. {paper_title}
- **Authors**: {authors}
- **arXiv ID**: {arxiv_id}
- **Summary**: {summary}
- **Key Insights**: {insights}

---

## Trends Identified

- {trend_1}
- {trend_2}

## Recommendations

- {recommendation_1}
- {recommendation_2}
```

---

## Facebook Post Task Template

```yaml
type: post
title: "FB Post: {topic}"
description: "Create and post content about {topic}"
priority: medium
config:
  platform: "facebook"
  content_type: "text"  # text|image|link|multi_photo
  draft_first: true
  requires_confirmation: true
```

### Post Content Template

```markdown
# Facebook Post Draft

## Topic: {topic}

## Content:

{content_body}

## Hashtags:
#{hashtag_1} #{hashtag_2} #{hashtag_3}

## Media:
- [ ] Image attached: {image_path}
- [ ] Link preview: {link_url}

## Scheduled:
- Time: {scheduled_time}
- Status: draft|ready|published
```

---

## Content Creation Task Template

```yaml
type: content
title: "Content: {platform} - {topic}"
description: "Create {platform} content about {topic}"
priority: medium
config:
  platform: "youtube|blog|social"
  topic: "{topic}"
  style: "educational|entertaining|promotional"
  length: "short|medium|long"
```

### YouTube Content Template

```markdown
# YouTube Video Plan

## Topic: {topic}

## Format:
- Type: shorts|standard
- Duration: {duration}
- Style: {style}

## Script Outline:
1. Hook: {hook}
2. Problem: {problem}
3. Solution: {solution}
4. Call-to-action: {cta}

## Visual Notes:
- {visual_1}
- {visual_2}

## Status:
- [ ] Script done
- [ ] Animation designed
- [ ] Rendered
- [ ] Uploaded
```

### Blog Content Template

```markdown
# Blog Post: {title}

## Metadata:
- Category: {category}
- Tags: {tags}
- Status: draft|review|published

## Outline:

### 1. Introduction
{intro}

### 2. Main Points
{points}

### 3. Conclusion
{conclusion}

## SEO:
- Focus keyword: {keyword}
- Meta description: {description}
```

---

## Daily Report Task Template

```yaml
type: report
title: "Daily Report - {date}"
description: "Generate daily summary report"
priority: low
config:
  include:
    - completed_tasks
    - pending_tasks
    - metrics
    - learnings
  format: "markdown"
```

### Daily Report Template

See `templates/daily-summary.md`

---

## Custom Task Template

```yaml
type: custom
title: "{custom_title}"
description: "{custom_description}"
priority: medium
config:
  steps:
    - step_1: "{action}"
    - step_2: "{action}"
  dependencies: []
  output_path: "{path}"
```

---

## Quick Reference

| Type | Priority | Typical Duration | Confirmation |
|------|----------|------------------|--------------|
| research | medium | 5-10 min | No |
| post | medium | 2-5 min | Yes |
| content | high | 10-30 min | Varies |
| report | low | 1-2 min | No |
| custom | varies | varies | Varies |
