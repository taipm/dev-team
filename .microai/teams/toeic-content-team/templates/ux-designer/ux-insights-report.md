# UX Insights Report

> Template cho báo cáo phân tích UX định kỳ

---

## Metadata

```yaml
report_id: "UX-{YYYY-MM-DD}-{SEQ}"
period: "{start_date} - {end_date}"
generated_by: ux-designer-agent
generated_at: "{timestamp}"
version: "1.0"
```

---

## Tóm tắt Điều hành

| Chỉ số | Kỳ này | Kỳ trước | Thay đổi |
|--------|--------|----------|----------|
| **Avg Watch Time** | {time}s | {time}s | {+/-}% |
| **Avg Retention** | {%}% | {%}% | {+/-}% |
| **CTR** | {%}% | {%}% | {+/-}% |
| **Engagement Rate** | {%}% | {%}% | {+/-}% |

### Đánh giá Tổng quan

```
Trạng thái: IMPROVING / STABLE / DECLINING
Điểm UX: {score}/100
Trend: ↑ / → / ↓
```

---

## 1. Phân tích Retention

### Retention Curves

```
VIDEO TYPE: SHORTS
─────────────────────────────────────────────────────
100% ┼─────╮
 80% ┼     ╰──────────────────────
 60% ┼                            ──────────
 40% ┼                                     ───
 20% ┼                                        ───
  0% ┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼
     0s   10s   20s   30s   40s   50s   60s

Avg Retention: {%}%
Target: >70%
Status: PASS / FAIL
```

```
VIDEO TYPE: STANDARD
─────────────────────────────────────────────────────
100% ┼─────╮
 80% ┼     ╰────────
 60% ┼              ────────────────
 40% ┼                              ──────────────
 20% ┼
  0% ┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼
     0m   1m    2m    3m    4m    5m    6m    7m

Avg Retention: {%}%
Target: >50%
Status: PASS / FAIL
```

### Drop-off Points

| Thời điểm | Drop Rate | Nguyên nhân Có thể | Đề xuất |
|-----------|-----------|---------------------|---------|
| 0-5s | {%}% | {reason} | {action} |
| {timestamp} | {%}% | {reason} | {action} |
| {timestamp} | {%}% | {reason} | {action} |

### Re-watch Sections

| Section | Re-watch Rate | Thời điểm | Ý nghĩa |
|---------|---------------|-----------|---------|
| {section} | {%}% | {time} | {interpretation} |
| {section} | {%}% | {time} | {interpretation} |

---

## 2. Phân tích Thumbnail

### CTR Performance

| Thumbnail Style | Videos | Avg CTR | Impressions | Status |
|-----------------|--------|---------|-------------|--------|
| {style_1} | {n} | {%}% | {n}K | TOP / OK / LOW |
| {style_2} | {n} | {%}% | {n}K | TOP / OK / LOW |
| {style_3} | {n} | {%}% | {n}K | TOP / OK / LOW |

### Top Performers

| Video | CTR | Thumbnail Elements | Learnings |
|-------|-----|-------------------|-----------|
| {title} | {%}% | {elements} | {what_worked} |
| {title} | {%}% | {elements} | {what_worked} |
| {title} | {%}% | {elements} | {what_worked} |

### Underperformers

| Video | CTR | Issues | Recommendations |
|-------|-----|--------|-----------------|
| {title} | {%}% | {issues} | {fix} |
| {title} | {%}% | {issues} | {fix} |

---

## 3. Phân tích Hook

### First 5 Seconds Performance

| Hook Type | Videos | 5s Retention | Effectiveness |
|-----------|--------|--------------|---------------|
| Question | {n} | {%}% | HIGH / MEDIUM / LOW |
| Problem | {n} | {%}% | HIGH / MEDIUM / LOW |
| Promise | {n} | {%}% | HIGH / MEDIUM / LOW |
| Curiosity | {n} | {%}% | HIGH / MEDIUM / LOW |
| Direct | {n} | {%}% | HIGH / MEDIUM / LOW |

### Hook Learnings

```yaml
most_effective:
  type: "{hook_type}"
  avg_retention: "{%}%"
  example: "{example_text}"

least_effective:
  type: "{hook_type}"
  avg_retention: "{%}%"
  issue: "{why_failed}"

recommendation:
  for_vocabulary: "{hook_type}"
  for_listening: "{hook_type}"
  for_grammar: "{hook_type}"
```

---

## 4. Phân tích Content Type

### Performance by Content Type

| Type | Videos | Watch Time | Retention | CTR | Engagement |
|------|--------|------------|-----------|-----|------------|
| Vocabulary | {n} | {time}s | {%}% | {%}% | {%}% |
| Listening | {n} | {time}s | {%}% | {%}% | {%}% |
| Grammar | {n} | {time}s | {%}% | {%}% | {%}% |

### Content Type Insights

```yaml
vocabulary:
  strength: "{what_works}"
  weakness: "{what_fails}"
  recommendation: "{action}"

listening:
  strength: "{what_works}"
  weakness: "{what_fails}"
  recommendation: "{action}"

grammar:
  strength: "{what_works}"
  weakness: "{what_fails}"
  recommendation: "{action}"
```

---

## 5. Engagement Analysis

### Engagement Metrics

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Like Rate | {%}% | 4-6% | GOOD / OK / LOW |
| Comment Rate | {%}% | 0.5-2% | GOOD / OK / LOW |
| Share Rate | {%}% | 0.1-0.5% | GOOD / OK / LOW |
| Save Rate | {%}% | 1-3% | GOOD / OK / LOW |

### Top Comments Themes

| Theme | Count | Sentiment | Action |
|-------|-------|-----------|--------|
| {theme} | {n} | Positive / Negative / Neutral | {action} |
| {theme} | {n} | Positive / Negative / Neutral | {action} |
| {theme} | {n} | Positive / Negative / Neutral | {action} |

### Feature Requests from Comments

| Request | Mentions | Priority | Feasibility |
|---------|----------|----------|-------------|
| {request} | {n} | HIGH / MEDIUM / LOW | Easy / Medium / Hard |
| {request} | {n} | HIGH / MEDIUM / LOW | Easy / Medium / Hard |

---

## 6. A/B Test Results

### Completed Tests

| Test ID | Hypothesis | Winner | Lift | Confidence |
|---------|------------|--------|------|------------|
| {id} | {hypothesis} | A / B | {+/-}% | {%}% |
| {id} | {hypothesis} | A / B | {+/-}% | {%}% |

### Test Details

#### Test: {TEST_ID}

```yaml
test_name: "{name}"
hypothesis: "{hypothesis}"
duration: "{days} days"
sample_size: {n} videos

variants:
  A_control:
    description: "{desc}"
    ctr: {%}%
    watch_time: {time}s

  B_variant:
    description: "{desc}"
    ctr: {%}%
    watch_time: {time}s

result:
  winner: "A / B / Inconclusive"
  lift: "{+/-}%"
  confidence: "{%}%"

action:
  implement: true / false
  apply_to: ["{templates}"]
  notes: "{notes}"
```

### Running Tests

| Test ID | Status | Days Left | Current Trend |
|---------|--------|-----------|---------------|
| {id} | Running | {n} days | A leading / B leading / Tied |

---

## 7. Accessibility Score

### Current Status

| Category | Score | Target | Status |
|----------|-------|--------|--------|
| Visual | {score}/25 | 20+ | PASS / FAIL |
| Audio | {score}/25 | 20+ | PASS / FAIL |
| Cognitive | {score}/25 | 20+ | PASS / FAIL |
| Technical | {score}/25 | 20+ | PASS / FAIL |
| **TOTAL** | **{score}/100** | **80+** | **PASS / FAIL** |

### Issues Found

| Issue | Severity | Videos Affected | Fix Required |
|-------|----------|-----------------|--------------|
| {issue} | HIGH / MEDIUM / LOW | {n} | {fix} |
| {issue} | HIGH / MEDIUM / LOW | {n} | {fix} |

---

## 8. Recommendations

### For Content Planner

| Priority | Recommendation | Expected Impact |
|----------|----------------|-----------------|
| P0 | {recommendation} | {impact} |
| P1 | {recommendation} | {impact} |
| P2 | {recommendation} | {impact} |

### For Script Writer

| Priority | Recommendation | Expected Impact |
|----------|----------------|-----------------|
| P0 | {recommendation} | {impact} |
| P1 | {recommendation} | {impact} |

### For Visual Designer

| Priority | Recommendation | Expected Impact |
|----------|----------------|-----------------|
| P0 | {recommendation} | {impact} |
| P1 | {recommendation} | {impact} |

### For Audio Producer

| Priority | Recommendation | Expected Impact |
|----------|----------------|-----------------|
| P0 | {recommendation} | {impact} |

---

## 9. Action Items

### Immediate (This Week)

- [ ] {action_1} - Owner: {agent}
- [ ] {action_2} - Owner: {agent}
- [ ] {action_3} - Owner: {agent}

### Short-term (Next 2 Weeks)

- [ ] {action_1} - Owner: {agent}
- [ ] {action_2} - Owner: {agent}

### Proposed A/B Tests

| Test Name | Hypothesis | Priority |
|-----------|------------|----------|
| {name} | {hypothesis} | P0 / P1 / P2 |
| {name} | {hypothesis} | P0 / P1 / P2 |

---

## 10. Appendix

### Data Sources

```yaml
sources:
  youtube_analytics:
    period: "{date_range}"
    metrics: [views, watch_time, retention, ctr, engagement]

  comments:
    analyzed: {n}
    sentiment_model: "basic"

  ab_tests:
    platform: "youtube_native"
    confidence_threshold: 95%
```

### Methodology Notes

```yaml
retention_analysis:
  sample: "All videos in period"
  aggregation: "Average weighted by views"

ctr_benchmarks:
  source: "Channel historical + industry"
  good: ">5%"
  excellent: ">10%"

engagement_calculation:
  formula: "(likes + comments + shares) / views * 100"
```

---

*Báo cáo được tạo bởi UX Designer Agent*
*Template version: 1.0*
