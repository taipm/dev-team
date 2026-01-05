# Step 07: Quality Review

```yaml
step: 7
name: quality-review
description: QC, SEO optimization, và metadata generation
trigger: videos received
agent: quality-reviewer-agent
next: step-08-export (if approved) or quarantine (if rejected)
checkpoint: true
loop: true
```

---

## Purpose

Quality Reviewer kiểm tra chất lượng video, validate TOEIC content accuracy, và generate SEO-optimized metadata.

---

## Input

```yaml
subscribed:
  - video.shorts
  - video.standard

from_videos:
  - shorts.mp4
  - standard.mp4
  - video-metadata.json

from_previous_steps:
  - script.md
  - topic-brief.json
  - keywords.json

from_knowledge:
  - qc-checklist.md
  - seo-guidelines.md
  - toeic-fundamentals.md
```

---

## Actions

### 1. Technical Quality Check

```yaml
technical_qc:
  video:
    - Plays without errors
    - Resolution correct
    - Duration within spec
    - File not corrupted

  audio:
    - Clear and audible
    - Properly synced
    - Levels normalized

  visuals:
    - Readable text
    - Consistent branding
    - No artifacts
```

### 2. Content Quality Check

```yaml
content_qc:
  toeic_accuracy:
    - Vocabulary verified against corpus
    - Grammar rules correct
    - Examples accurate
    - Level appropriate

  educational_value:
    - Clear explanations
    - Useful information
    - Engaging delivery

  brand_compliance:
    - Visual identity correct
    - Watermark present
    - CTA included
```

### 3. Calculate Quality Score

```yaml
scoring:
  technical: 30%
    - video_playback: 10
    - audio_quality: 10
    - visual_quality: 10

  content: 40%
    - toeic_accuracy: 15
    - educational_value: 10
    - engagement: 10
    - brand_consistency: 5

  seo: 30%
    - title_optimization: 10
    - description_quality: 10
    - tag_relevance: 10
```

### 4. Generate SEO Metadata

```yaml
metadata:
  title:
    - Include primary keyword
    - Under 60 characters
    - Engaging hook

  description:
    - First 150 chars critical
    - Include keywords naturally
    - Add timestamps
    - CTA included

  tags:
    - Primary keyword first
    - 8-15 tags total
    - Mix broad + specific
```

### 5. Make Approval Decision

```yaml
decision:
  approved:
    - Score >= 7.0
    - No critical issues
    - Action: proceed to export

  approved_with_notes:
    - Score 5.0-6.9
    - Minor issues only
    - Action: proceed with notes

  rejected:
    - Score < 5.0 OR critical issues
    - Action: quarantine
    - Required: manual review
```

---

## Output

```yaml
deliverables:
  - metadata/{video_id}/qc-report.json
  - metadata/{video_id}/metadata.json
  - upload-ready/{video_id}/ (if approved)
  - quarantine/{video_id}/ (if rejected)

published:
  - quality.approved (with metadata)
  - quality.rejected (with issues)
```

---

## Quality Report Structure

```json
{
  "video_id": "{id}",
  "title": "{title}",
  "status": "APPROVED|APPROVED_WITH_NOTES|REJECTED",
  "scores": {
    "overall": 8.5,
    "technical": 9.0,
    "content": 8.5,
    "seo": 8.0
  },
  "checklist": {
    "technical": {...},
    "content": {...},
    "brand": {...}
  },
  "issues": [],
  "notes": "",
  "recommendations": []
}
```

---

## SEO Metadata Structure

```json
{
  "title": "{SEO title}",
  "description": "{Full description with timestamps, keywords, CTA}",
  "tags": ["TOEIC", "..."],
  "category": "27",
  "thumbnail": "thumbnail.png",
  "visibility": "public",
  "playlist": "{playlist_name}"
}
```

---

## Error Handling

```yaml
errors:
  video_corrupt:
    status: REJECTED
    reason: "Video file corrupted"
    action: reassemble

  toeic_inaccuracy:
    status: REJECTED
    reason: "TOEIC content error"
    action: rewrite_script

  low_quality:
    status: APPROVED_WITH_NOTES
    condition: score >= 5.0
    action: proceed_with_warning
```

---

## Quarantine Process

If rejected:

```
quarantine/{video_id}/
├── shorts.mp4
├── standard.mp4
├── qc-report.json
├── issues.md
└── original-assets/
```

Quarantined videos can be:
1. Fixed and resubmitted (`*reprocess:{video_id}`)
2. Manually approved (`*force-approve:{video_id}`)
3. Permanently rejected (`*discard:{video_id}`)

---

## Checkpoint

```yaml
checkpoint:
  step: 7
  video_id: {id}
  status: {approved|approved_with_notes|rejected}
  score: {n}
  timestamp: {time}
```

---

## Handoff

If APPROVED/APPROVED_WITH_NOTES:
→ **Step 08: Export**

If REJECTED:
→ **Quarantine** (workflow paused for this video)

---

## Display

### Approved

```
╔═══════════════════════════════════════════════════════════════════════╗
║               ✅ QUALITY REVIEWER - APPROVED                           ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Quality Score: {score}/10 ✓                                         ║
║   ├── Technical: {tech}/10                                            ║
║   ├── Content: {content}/10                                           ║
║   └── SEO: {seo}/10                                                   ║
║                                                                        ║
║   TOEIC Validation: ✓ Passed                                          ║
║   Brand Compliance: ✓ Verified                                        ║
║                                                                        ║
║   SEO Metadata: ✓ Generated                                           ║
║   ├── Title: {title_preview}...                                       ║
║   └── Tags: {tag_count}                                               ║
║                                                                        ║
║   [CHECKPOINT SAVED]                                                   ║
║                                                                        ║
║   → Proceeding to Export...                                           ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```

### Rejected

```
╔═══════════════════════════════════════════════════════════════════════╗
║               ❌ QUALITY REVIEWER - REJECTED                           ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Video: {title}                                                       ║
║   Progress: [{current}/{total}]                                        ║
║                                                                        ║
║   Quality Score: {score}/10 ✗                                         ║
║                                                                        ║
║   Issues Found:                                                        ║
║   {issue_list}                                                         ║
║                                                                        ║
║   Required Actions:                                                    ║
║   {action_list}                                                        ║
║                                                                        ║
║   Video moved to: ./quarantine/{video_id}/                            ║
║                                                                        ║
║   Commands:                                                            ║
║   • *reprocess:{video_id} - Fix and resubmit                         ║
║   • *force-approve:{video_id} - Override (admin)                     ║
║   • *discard:{video_id} - Permanently reject                         ║
║                                                                        ║
║   → Continuing with next video...                                     ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
