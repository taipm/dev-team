# Step 07: REVIEW

> Quality validation and approval decision

---

## Step Info

```yaml
step: 7
name: review
title: "Quality Review"
description: "Validate audio quality, score, and make approval decision"

trigger: step.06.complete
agent: quality-reviewer-agent

duration: "2-10 minutes"
checkpoint: true
```

---

## Responsible Agent

**Quality Reviewer Agent** (`✅`)
- Analyzes audio technical specs
- Validates loudness compliance
- Checks for issues
- Scores and makes decision

---

## Input

```yaml
input:
  from_step: step-06-engineering
  files:
    - mastered/chapter-{NNN}.mp3
    - mastered/full-audiobook.mp3
    - mastered/audio-report.json

  subscribe:
    - audio.mastered
    - audio.chapters_merged
```

---

## Process

### 1. Technical Validation

```yaml
checks:
  - file_integrity
  - format_compliance
  - duration_accuracy
```

### 2. Loudness Validation

```yaml
loudness_checks:
  integrated_lufs: "-16 to -12"
  true_peak: "<= -1.5 dBTP"
  loudness_range: "5-15 LRA"
```

### 3. Content Checks

```yaml
content_checks:
  - no_clipping
  - no_long_silences (> 3s)
  - fades_present
  - transitions_smooth
```

### 4. Scoring

```yaml
scoring:
  technical_quality: 30%
  loudness_compliance: 25%
  content_quality: 25%
  structure_quality: 20%

grades:
  A: 90-100  # Publish immediately
  B: 80-89   # Publish with notes
  C: 60-79   # Review required
  D: 40-59   # Fixes required
  F: 0-39    # Rejected
```

### 5. Decision

```yaml
decisions:
  APPROVED:
    score: ">= 90"
    action: proceed_to_cover_design

  APPROVED_WITH_NOTES:
    score: "80-89"
    action: proceed_with_notes

  REVIEW_REQUIRED:
    score: "60-79"
    action: flag_for_human_review

  FIXES_REQUIRED:
    score: "40-59"
    action: return_to_engineering

  REJECTED:
    score: "< 40"
    action: quarantine
```

---

## Output

```yaml
output:
  files:
    - quality/qc-report.json
    - quality/analysis/  # Detailed analysis files

  qc_report_format:
    generated_at: timestamp
    total_chapters: number
    average_score: number
    grade: A|B|C|D|F
    decision: APPROVED|APPROVED_WITH_NOTES|REVIEW_REQUIRED|FIXES_REQUIRED|REJECTED
    issues: [list]
    checks: {object}
    recommendations: [list]

  publish:
    - topic: quality.approved (if approved)
    - topic: quality.rejected (if rejected)
    - topic: quality.report

  checkpoint:
    name: "review-complete"
```

---

## Success Criteria

```yaml
success:
  - all_chapters_analyzed: true
  - qc_report_generated: true
  - decision_made: true
  - score_calculated: true
```

---

## Decision Flow

```
Score >= 90 → APPROVED → Step 07.5 (Cover Design)
Score 80-89 → APPROVED_WITH_NOTES → Step 07.5
Score 60-79 → REVIEW_REQUIRED → Human review
Score 40-59 → FIXES_REQUIRED → Back to Step 06
Score < 40 → REJECTED → Quarantine
```

---

## Error Handling

```yaml
errors:
  analysis_failure:
    action: retry_then_skip
    max_retries: 2
    fallback: manual_review

  borderline_score:
    range: "75-85"
    action: flag_for_human_review
```

---

## Next Step

- **Step 07.5: COVER DESIGN** (if approved) - Cover Designer Agent generates artwork
- **Step 06: ENGINEERING** (if fixes required) - Re-process audio
