# Template Recommendation

> Template cho đề xuất cập nhật template gửi đến Visual Designer

---

## Metadata

```yaml
recommendation_id: "REC-{YYYY-MM-DD}-{SEQ}"
from: ux-designer-agent
to: visual-designer-agent
created_at: "{timestamp}"
priority: P0 | P1 | P2
status: pending | accepted | rejected | implemented
```

---

## Tóm tắt

| Field | Value |
|-------|-------|
| **Recommendation** | {one_line_summary} |
| **Target Template(s)** | {template_names} |
| **Expected Impact** | {expected_improvement} |
| **Effort** | Low / Medium / High |
| **Priority** | P0 (Immediate) / P1 (This week) / P2 (Next sprint) |

---

## 1. Context

### Data Source

```yaml
source:
  type: ab_test | analytics | accessibility_audit | user_feedback | competitive_analysis
  reference: "{reference_id}"  # ABT-xxx, UX-xxx, ACC-xxx
  period: "{date_range}"
  sample_size: "{n} videos / {n} views"
```

### Current Performance

| Metric | Current | Target | Gap |
|--------|---------|--------|-----|
| {metric_1} | {value} | {target} | {gap} |
| {metric_2} | {value} | {target} | {gap} |
| {metric_3} | {value} | {target} | {gap} |

### Problem Statement

```
{Clear description of the problem or opportunity}

Evidence:
- {evidence_1}
- {evidence_2}
- {evidence_3}
```

---

## 2. Recommendation

### Overview

```
{Detailed description of the recommended change}
```

### Specific Changes

#### Template: {template_name}

| Element | Current | Recommended | Rationale |
|---------|---------|-------------|-----------|
| {element_1} | {current} | {new} | {why} |
| {element_2} | {current} | {new} | {why} |
| {element_3} | {current} | {new} | {why} |

### Visual Comparison

```
BEFORE                          AFTER
┌────────────────────┐          ┌────────────────────┐
│                    │          │                    │
│  {current_layout}  │    →     │  {new_layout}      │
│                    │          │                    │
└────────────────────┘          └────────────────────┘
```

### Implementation Details

```yaml
changes:
  colors:
    - element: "{element}"
      from: "{hex}"
      to: "{hex}"

  typography:
    - element: "{element}"
      property: "{property}"
      from: "{value}"
      to: "{value}"

  layout:
    - element: "{element}"
      property: "{property}"
      from: "{value}"
      to: "{value}"

  components:
    - add: "{component}"
      specification: "{spec}"

    - modify: "{component}"
      changes: "{changes}"

    - remove: "{component}"
      reason: "{reason}"
```

---

## 3. Expected Impact

### Primary Metrics

| Metric | Current | Expected | Lift |
|--------|---------|----------|------|
| {primary_metric} | {value} | {expected} | {+/-}% |

### Secondary Metrics

| Metric | Expected Change | Confidence |
|--------|-----------------|------------|
| {metric_1} | {change} | High / Medium / Low |
| {metric_2} | {change} | High / Medium / Low |

### Risk Assessment

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| {risk_1} | Low / Medium / High | {mitigation} |
| {risk_2} | Low / Medium / High | {mitigation} |

---

## 4. Implementation Plan

### Steps

1. **Preparation**
   - [ ] {prep_step_1}
   - [ ] {prep_step_2}

2. **Implementation**
   - [ ] {impl_step_1}
   - [ ] {impl_step_2}

3. **Validation**
   - [ ] {validation_step_1}
   - [ ] {validation_step_2}

### Timeline

| Phase | Duration | Completion |
|-------|----------|------------|
| Preparation | {time} | {date} |
| Implementation | {time} | {date} |
| Testing | {time} | {date} |
| Rollout | {time} | {date} |

### Dependencies

- [ ] {dependency_1}
- [ ] {dependency_2}

---

## 5. Testing Plan

### A/B Test (if applicable)

```yaml
ab_test:
  required: true | false
  test_id: "{ABT-xxx}"  # Will be assigned

  setup:
    control: "Current template"
    variant: "With recommended changes"
    duration: "{days} days"
    sample: "{n} videos per variant"

  success_criteria:
    primary: "{metric} improves by >{n}%"
    guardrail: "{metric} does not decrease by >{n}%"
```

### Manual Testing

- [ ] Accessibility check (contrast, font size)
- [ ] Mobile preview (Shorts format)
- [ ] Desktop preview (Standard format)
- [ ] Brand consistency check
- [ ] Readability at small sizes

---

## 6. Rollout Strategy

```yaml
rollout:
  strategy: immediate | gradual | test_first

  phases:
    - name: "Pilot"
      scope: "5 new videos"
      criteria: "{success_criteria}"

    - name: "Expansion"
      scope: "All new videos"
      criteria: "{adoption_criteria}"

  rollback:
    trigger: "{what_triggers_rollback}"
    action: "{how_to_rollback}"
```

---

## 7. Examples

### Example Implementation

**Template:** shorts-vocab-1word-30s

**Before:**
```yaml
slide_word_card:
  background: "#1A1A2E"
  word:
    size: 64px
    color: "#FFFFFF"
  definition:
    size: 32px
    color: "#B8B8B8"
```

**After (Recommended):**
```yaml
slide_word_card:
  background: "#1A1A2E"
  word:
    size: 72px        # Increased for mobile
    color: "#FFFFFF"
  definition:
    size: 40px        # Increased for readability
    color: "#D0D0D0"  # Better contrast
  emoji:
    enabled: true     # New: add relevant emoji
    size: 48px
    position: "after_word"
```

### Visual Mock-up

```
┌─────────────────────────────────┐
│                                 │
│         NEGOTIATE               │
│            🤝                   │
│                                 │
│    /nɪˈɡoʊʃieɪt/               │
│                                 │
│   To discuss and reach         │
│   an agreement                  │
│                                 │
│                                 │
└─────────────────────────────────┘
```

---

## 8. Supporting Data

### Analytics Summary

```yaml
data_period: "{date_range}"
videos_analyzed: {n}

findings:
  - insight: "{insight_1}"
    evidence: "{data}"

  - insight: "{insight_2}"
    evidence: "{data}"
```

### Competitor Analysis (if applicable)

| Competitor | Approach | Performance |
|------------|----------|-------------|
| {channel_1} | {approach} | {metrics} |
| {channel_2} | {approach} | {metrics} |

### User Feedback (if applicable)

| Source | Feedback | Frequency |
|--------|----------|-----------|
| Comments | "{feedback}" | {n} mentions |
| Survey | "{feedback}" | {%}% of respondents |

---

## 9. Approval

### Review

| Reviewer | Status | Comments | Date |
|----------|--------|----------|------|
| ux-designer | Proposed | - | {date} |
| visual-designer | Pending | - | - |

### Decision

```yaml
decision:
  status: pending | accepted | rejected | modified
  decided_by: "{agent}"
  date: "{date}"

  if_accepted:
    implementation_date: "{date}"
    assigned_to: visual-designer

  if_rejected:
    reason: "{reason}"
    alternative: "{suggested_alternative}"

  if_modified:
    modifications: "{what_was_modified}"
    new_specification: "{updated_spec}"
```

---

## 10. Follow-up

### After Implementation

- [ ] Update design system documentation
- [ ] Notify affected agents
- [ ] Monitor metrics for {n} days
- [ ] Report results in next UX Insights

### Success Criteria Check

| Criteria | Target | Actual | Status |
|----------|--------|--------|--------|
| {metric_1} | {target} | - | Pending |
| {metric_2} | {target} | - | Pending |

---

*Recommendation generated by UX Designer Agent*
*Template version: 1.0*
