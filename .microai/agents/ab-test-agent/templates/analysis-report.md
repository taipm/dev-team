# Experiment Analysis: {NAME}

## Summary

| Field | Value |
|-------|-------|
| Experiment ID | {EXP-XXX} |
| Name | {name} |
| Duration | {start} → {end} ({N days}) |
| Analyst | {name} |
| Analysis Date | {YYYY-MM-DD} |

### Quick Result
| Metric | Control | Treatment | Lift | P-value | Verdict |
|--------|---------|-----------|------|---------|---------|
| {OEC} | {X%} | {Y%} | {+Z%} | {0.0X} | {✅/❌} |

---

## Validation Checks

### Sample Ratio Mismatch (SRM)
| Variant | Expected | Actual | Difference |
|---------|----------|--------|------------|
| Control | 50% | {X%} | {diff} |
| Treatment | 50% | {Y%} | {diff} |

**SRM Test**: χ² = {value}, p-value = {value}
**Status**: {PASSED ✅ / FAILED ❌}

### Runtime Check
| Check | Required | Actual | Status |
|-------|----------|--------|--------|
| Minimum days | 7 | {N} | {✅/❌} |
| Full weeks | 1+ | {N} | {✅/❌} |
| Sample size | {N} | {actual} | {✅/❌} |

### Data Quality
- [ ] No missing data
- [ ] Metric definitions consistent
- [ ] No external confounders identified

---

## Statistical Analysis

### Primary Metric: {metric name}

**Point Estimates**
| Variant | N | Conversions | Rate | 95% CI |
|---------|---|-------------|------|--------|
| Control | {N} | {X} | {%} | [{low}, {high}] |
| Treatment | {N} | {X} | {%} | [{low}, {high}] |

**Comparison**
| Metric | Value |
|--------|-------|
| Absolute Difference | {X%} |
| Relative Lift | {Y%} |
| 95% CI for Difference | [{low}, {high}] |
| P-value | {value} |
| Statistically Significant | {Yes/No} |

### Secondary Metrics

| Metric | Control | Treatment | Lift | P-value | Notes |
|--------|---------|-----------|------|---------|-------|
| {metric 1} | {X%} | {Y%} | {Z%} | {p} | |
| {metric 2} | {X%} | {Y%} | {Z%} | {p} | |

### Guardrail Metrics

| Metric | Control | Treatment | Change | Threshold | Status |
|--------|---------|-----------|--------|-----------|--------|
| {guard 1} | {X%} | {Y%} | {Z%} | <{T%} | {✅/⚠️/❌} |

---

## Segment Analysis

### Pre-Defined Segments

#### By Device Type
| Segment | Control | Treatment | Lift | P-value | N |
|---------|---------|-----------|------|---------|---|
| Mobile | {X%} | {Y%} | {Z%} | {p} | {n} |
| Desktop | {X%} | {Y%} | {Z%} | {p} | {n} |

#### By User Type
| Segment | Control | Treatment | Lift | P-value | N |
|---------|---------|-----------|------|---------|---|
| New | {X%} | {Y%} | {Z%} | {p} | {n} |
| Returning | {X%} | {Y%} | {Z%} | {p} | {n} |

### Heterogeneous Treatment Effects
{Any significant segment differences?}

---

## Effect Size & Practical Significance

### Business Impact

| Metric | Value |
|--------|-------|
| Monthly Traffic | {N} |
| Current Conversions | {N} |
| Expected Lift | {X%} |
| Additional Conversions | {N} |
| Revenue Impact | ${amount}/month |
| Annualized Impact | ${amount}/year |

### Confidence Interval for Impact
| Scenario | Lift | Monthly Impact |
|----------|------|----------------|
| Lower Bound (95% CI) | {X%} | ${amount} |
| Point Estimate | {Y%} | ${amount} |
| Upper Bound (95% CI) | {Z%} | ${amount} |

### Practical Significance Assessment
{Is the effect large enough to justify implementation costs?}

---

## Sensitivity Analysis

### Outlier Impact
| Analysis | Result | Significant? |
|----------|--------|--------------|
| Full data | {lift} | {Yes/No} |
| Excluding top 1% | {lift} | {Yes/No} |
| Winsorized | {lift} | {Yes/No} |

### Time Trend
| Period | Lift | Notes |
|--------|------|-------|
| Week 1 | {X%} | {novelty?} |
| Week 2 | {Y%} | |
| Full Period | {Z%} | |

---

## Interpretation

### Summary
{2-3 sentence summary of results}

### Key Findings
1. {Finding 1}
2. {Finding 2}
3. {Finding 3}

### Caveats
- {Caveat 1}
- {Caveat 2}

---

## Decision

### Recommendation
**{SHIP / DON'T SHIP / CONTINUE TESTING}**

### Rationale
{Why this decision?}

### Conditions (if applicable)
- {Condition for shipping}
- {Segment-specific considerations}

---

## Next Steps

1. [ ] {Action item 1}
2. [ ] {Action item 2}
3. [ ] {Follow-up experiment if needed}

---

## Learnings

### What We Learned
- {Learning 1}
- {Learning 2}

### Ideas for Future Experiments
- {Idea 1}
- {Idea 2}

---

## Appendix

### Raw Data Summary
{If applicable}

### Additional Charts
{Links to dashboards or visualizations}

### Change Log
| Date | Change | By |
|------|--------|-----|
| {date} | Initial analysis | {name} |

---

*Analysis completed: {date}*
*Template version: 1.0*
