# Accessibility Audit Report

> Template cho báo cáo kiểm tra accessibility của video

---

## Metadata

```yaml
audit_id: "ACC-{YYYY-MM-DD}-{VIDEO_ID}"
video_id: "{video_id}"
video_title: "{title}"
video_format: shorts | standard
audited_by: ux-designer-agent
audited_at: "{timestamp}"
version: "1.0"
```

---

## Tóm tắt Kết quả

```
┌─────────────────────────────────────────────────────────────────┐
│  ACCESSIBILITY SCORE: {TOTAL}/100                               │
│                                                                  │
│  Visual:    {score}/25  ████████████░░░░░░░░░░░░░  {status}     │
│  Audio:     {score}/25  ████████████████░░░░░░░░░  {status}     │
│  Cognitive: {score}/25  ████████████████████░░░░░  {status}     │
│  Technical: {score}/25  ██████████████████████░░░  {status}     │
│                                                                  │
│  OVERALL STATUS: PASS / CONDITIONAL PASS / FAIL                 │
└─────────────────────────────────────────────────────────────────┘
```

### Tóm tắt Nhanh

| Hạng mục | Checks | Pass | Fail | Score |
|----------|--------|------|------|-------|
| Visual | {n} | {n} | {n} | {score}/25 |
| Audio | {n} | {n} | {n} | {score}/25 |
| Cognitive | {n} | {n} | {n} | {score}/25 |
| Technical | {n} | {n} | {n} | {score}/25 |
| **TOTAL** | **{n}** | **{n}** | **{n}** | **{score}/100** |

---

## 1. Visual Accessibility

### 1.1 Color Contrast

| Element | Foreground | Background | Ratio | Required | Status |
|---------|------------|------------|-------|----------|--------|
| Heading text | {hex} | {hex} | {n}:1 | 4.5:1 | PASS/FAIL |
| Body text | {hex} | {hex} | {n}:1 | 4.5:1 | PASS/FAIL |
| Accent text | {hex} | {hex} | {n}:1 | 3:1 | PASS/FAIL |
| Captions | {hex} | {hex} | {n}:1 | 4.5:1 | PASS/FAIL |

**Lowest Contrast Found:** {ratio}:1 at {timestamp}

**Screenshots:**
- [ ] Slide with lowest contrast: `{path}`

### 1.2 Color Independence

| Check | Status | Notes |
|-------|--------|-------|
| Info not color-only | PASS/FAIL | {notes} |
| Icons accompany colors | PASS/FAIL | {notes} |
| Text labels present | PASS/FAIL | {notes} |
| Works in grayscale | PASS/FAIL | {notes} |

**Color Blind Simulation:**
- [ ] Deuteranopia (Red-Green): {status}
- [ ] Protanopia (Red-Green): {status}
- [ ] Tritanopia (Blue-Yellow): {status}

### 1.3 Typography

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Heading size | {n}px | ≥64px (Shorts: ≥72px) | PASS/FAIL |
| Body size | {n}px | ≥36px (Shorts: ≥48px) | PASS/FAIL |
| Caption size | {n}px | ≥32px | PASS/FAIL |
| Font weight | {weight} | ≥400 | PASS/FAIL |
| Line height | {n} | 1.4-1.6 | PASS/FAIL |

**Font Used:** {font_name}
**Font Readability:** GOOD / ACCEPTABLE / POOR

### 1.4 Visual Hierarchy

| Check | Status | Notes |
|-------|--------|-------|
| Clear focal point | PASS/FAIL | {notes} |
| Logical reading order | PASS/FAIL | {notes} |
| Consistent layout | PASS/FAIL | {notes} |
| Safe zone respected | PASS/FAIL | {notes} |

### 1.5 Motion & Animation

| Check | Status | Notes |
|-------|--------|-------|
| No flashing/strobing | PASS/FAIL | {notes} |
| Smooth transitions | PASS/FAIL | {notes} |
| Animation not distracting | PASS/FAIL | {notes} |
| Reduced motion compatible | PASS/FAIL | {notes} |

**Visual Score: {score}/25**

---

## 2. Audio Accessibility

### 2.1 Voice Clarity

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Sample rate | {n}kHz | ≥44.1kHz | PASS/FAIL |
| Noise floor | {n}dB | <-60dB | PASS/FAIL |
| Consistent volume | {range}dB | ±3dB | PASS/FAIL |
| No clipping | {peak}dB | <-1dB | PASS/FAIL |

**Voice Type:** {voice_name}
**Speaking Rate:** {n} WPM (Target: 120-150)

### 2.2 Background Audio

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Music volume | {n}dB below voice | ≥-20dB | PASS/FAIL |
| Music type | {type} | Non-distracting | PASS/FAIL |
| No lyrics | {yes/no} | Yes | PASS/FAIL |
| Sound effects | {level} | Not startling | PASS/FAIL |

### 2.3 Captions

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Captions present | {yes/no} | Yes | PASS/FAIL |
| Accuracy | {n}% | ≥99% | PASS/FAIL |
| Sync timing | ±{n}s | ±0.5s | PASS/FAIL |
| Max lines | {n} | ≤2 | PASS/FAIL |
| Chars per line | {n} | ≤42 | PASS/FAIL |
| Min duration | {n}s | ≥1s | PASS/FAIL |
| Max duration | {n}s | ≤7s | PASS/FAIL |

**Caption Style:**
- Font: {font}
- Size: {size}px
- Background: {color} at {opacity}%
- Position: {position}

**Caption Issues Found:**

| Timestamp | Issue | Severity |
|-----------|-------|----------|
| {time} | {issue} | HIGH/MEDIUM/LOW |
| {time} | {issue} | HIGH/MEDIUM/LOW |

### 2.4 Audio Description (Optional)

| Check | Status | Notes |
|-------|--------|-------|
| Key visuals described | N/A / PASS / FAIL | {notes} |
| Timing appropriate | N/A / PASS / FAIL | {notes} |

**Audio Score: {score}/25**

---

## 3. Cognitive Accessibility

### 3.1 Information Density

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Items per slide | {n} | ≤3 (Shorts) / ≤5 (Standard) | PASS/FAIL |
| Words per slide | {n} | ≤15 (Shorts) / ≤30 (Standard) | PASS/FAIL |
| Concepts per video | {n} | 1 (Shorts) / 3-5 (Standard) | PASS/FAIL |
| Info per second | {n} | Comfortable pace | PASS/FAIL |

**Highest Density Slide:** Slide {n} at {timestamp} ({items} items)

### 3.2 Pacing

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Speaking rate | {n} WPM | 120-150 | PASS/FAIL |
| Pause after key points | {yes/no} | Yes | PASS/FAIL |
| Transition time | {n}s | ≥0.5s | PASS/FAIL |
| Overall pacing | {assessment} | Comfortable | PASS/FAIL |

**Pacing Issues:**

| Timestamp | Issue |
|-----------|-------|
| {time} | {too_fast/too_slow/no_pause} |

### 3.3 Structure & Predictability

| Check | Status | Notes |
|-------|--------|-------|
| Clear sections | PASS/FAIL | {notes} |
| Signposting used | PASS/FAIL | "First...", "Now...", "Finally..." |
| Consistent patterns | PASS/FAIL | {notes} |
| Logical flow | PASS/FAIL | {notes} |

### 3.4 Language Clarity

| Check | Status | Notes |
|-------|--------|-------|
| Simple vocabulary | PASS/FAIL | {notes} |
| Short sentences | PASS/FAIL | Avg {n} words |
| Jargon explained | PASS/FAIL | {notes} |
| Active voice | PASS/FAIL | {notes} |

**Complex Terms Used (should be explained):**
- {term_1}: {explained? yes/no}
- {term_2}: {explained? yes/no}

### 3.5 Dual Coding

| Check | Status | Notes |
|-------|--------|-------|
| Visual supports audio | PASS/FAIL | {notes} |
| Text synced with speech | PASS/FAIL | {notes} |
| Icons clarify concepts | PASS/FAIL | {notes} |
| Not just reading text | PASS/FAIL | {notes} |

**Cognitive Score: {score}/25**

---

## 4. Technical Accessibility

### 4.1 Video Quality

| Check | Value | Required | Status |
|-------|-------|----------|--------|
| Resolution | {w}x{h} | ≥1080p | PASS/FAIL |
| Frame rate | {n}fps | 30fps | PASS/FAIL |
| Bitrate | {n}kbps | Adequate | PASS/FAIL |
| Compression artifacts | {level} | Not visible on text | PASS/FAIL |

### 4.2 Mobile Compatibility

| Check | Status | Notes |
|-------|--------|-------|
| Text readable at 50% size | PASS/FAIL | {notes} |
| Touch targets adequate | N/A / PASS / FAIL | {notes} |
| Portrait orientation | PASS/FAIL | {notes} |
| Safe zones correct | PASS/FAIL | {notes} |

### 4.3 Platform Compliance

| Check | Status | Notes |
|-------|--------|-------|
| Duration within limits | PASS/FAIL | {duration} |
| File size acceptable | PASS/FAIL | {size}MB |
| Format correct | PASS/FAIL | {format} |
| Aspect ratio correct | PASS/FAIL | {ratio} |

### 4.4 Navigation

| Check | Status | Notes |
|-------|--------|-------|
| Chapters added | PASS/FAIL / N/A | {notes} |
| Chapter titles clear | PASS/FAIL / N/A | {notes} |
| Timestamps accurate | PASS/FAIL / N/A | {notes} |

**Technical Score: {score}/25**

---

## 5. Issues Summary

### Critical Issues (Must Fix)

| # | Category | Issue | Timestamp | Fix Required |
|---|----------|-------|-----------|--------------|
| 1 | {cat} | {issue} | {time} | {fix} |
| 2 | {cat} | {issue} | {time} | {fix} |

### Major Issues (Should Fix)

| # | Category | Issue | Timestamp | Fix Required |
|---|----------|-------|-----------|--------------|
| 1 | {cat} | {issue} | {time} | {fix} |
| 2 | {cat} | {issue} | {time} | {fix} |

### Minor Issues (Nice to Fix)

| # | Category | Issue | Timestamp | Fix Required |
|---|----------|-------|-----------|--------------|
| 1 | {cat} | {issue} | {time} | {fix} |
| 2 | {cat} | {issue} | {time} | {fix} |

---

## 6. Recommendations

### Immediate Actions (Pre-publish)

- [ ] {action_1}
- [ ] {action_2}
- [ ] {action_3}

### Future Improvements

- [ ] {improvement_1}
- [ ] {improvement_2}

### Template Updates

| Template | Change Required | Priority |
|----------|-----------------|----------|
| {template} | {change} | HIGH/MEDIUM/LOW |

---

## 7. Compliance Summary

### WCAG Level Assessment

| Level | Status | Notes |
|-------|--------|-------|
| A (Minimum) | PASS/PARTIAL/FAIL | {notes} |
| AA (Recommended) | PASS/PARTIAL/FAIL | {notes} |
| AAA (Ideal) | PASS/PARTIAL/FAIL | {notes} |

### Platform Guidelines

| Platform | Status | Notes |
|----------|--------|-------|
| YouTube | COMPLIANT/PARTIAL/NON-COMPLIANT | {notes} |
| TikTok | COMPLIANT/PARTIAL/NON-COMPLIANT | {notes} |

---

## 8. Sign-off

```yaml
audit_result:
  score: {total}/100
  status: PASS | CONDITIONAL_PASS | FAIL

  pass_criteria:
    minimum_score: 80
    no_critical_issues: true
    all_categories_above: 15

  conditions: # If CONDITIONAL_PASS
    - "{condition_1}"
    - "{condition_2}"

  approved_for_publish: true | false

  auditor: ux-designer-agent
  date: "{date}"
```

---

## Appendix

### Audit Checklist Used

```yaml
visual_checks: 15
audio_checks: 10
cognitive_checks: 12
technical_checks: 8
total_checks: 45
```

### Screenshots/Evidence

| Item | Path | Description |
|------|------|-------------|
| Low contrast | {path} | {desc} |
| Caption issue | {path} | {desc} |
| Dense slide | {path} | {desc} |

### Tools Used

- Color contrast: {tool}
- Caption accuracy: {tool}
- Audio analysis: {tool}

---

*Báo cáo được tạo bởi UX Designer Agent*
*Template version: 1.0*
