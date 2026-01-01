# Experiment Design: {NAME}

## Metadata

| Field | Value |
|-------|-------|
| Experiment ID | {EXP-XXX} |
| Name | {Descriptive name} |
| Owner | {Name} |
| Pre-registered | {YYYY-MM-DD} |
| Planned Start | {YYYY-MM-DD} |
| Planned End | {YYYY-MM-DD} |

---

## Hypothesis

### Background
{Context about the problem and what led to this experiment}

### Change
{What we're changing in the treatment variant}

### Hypothesis Statement
We believe that **{change}** will **{expected effect}** because **{reasoning}**.

### Null Hypothesis (H₀)
{Change} has no effect on {primary metric}.

### Alternative Hypothesis (H₁)
{Change} {increases/decreases} {primary metric} by at least {MDE}.

---

## Metrics

### Primary Metric (OEC)
- **Name**: {metric name}
- **Definition**: {exact calculation}
- **Baseline**: {X%}
- **MDE (Relative)**: {Y%}
- **MDE (Absolute)**: {Z%}

### Secondary Metrics
1. **{Metric 1}**: {definition}
2. **{Metric 2}**: {definition}

### Guardrail Metrics
1. **{Guardrail 1}**: Must not regress by more than {X%}
2. **{Guardrail 2}**: Must not regress by more than {Y%}

---

## Statistical Plan

### Parameters
| Parameter | Value |
|-----------|-------|
| Significance Level (α) | 5% |
| Power (1-β) | 80% |
| Test Type | Two-tailed |
| Analysis Method | {Frequentist / Bayesian} |

### Sample Size
- **Per Variant**: {N}
- **Total**: {2N}
- **Daily Traffic**: {X users}
- **Expected Duration**: {D days}

### Multiple Testing
- Correction Method: {None / Bonferroni / FDR}
- Adjusted α: {value}

---

## Variants

### Control (A)
{Description of control experience}

**Screenshot/Mockup**: {link or description}

### Treatment (B)
{Description of treatment experience}

**Screenshot/Mockup**: {link or description}

**Key Differences**:
- {difference 1}
- {difference 2}

---

## Randomization

| Parameter | Value |
|-----------|-------|
| Unit | {User / Session / Device} |
| Allocation | {50/50} |
| Stratification | {None / device_type / etc.} |

---

## Targeting

### Include
- {Criterion 1}
- {Criterion 2}

### Exclude
- Internal employees
- Bots/crawlers
- {Other criterion}

---

## Segments

Pre-defined segments for analysis:
1. **Device Type**: Mobile vs Desktop
2. **User Type**: New vs Returning
3. {Segment 3}

---

## Stopping Rules

### Early Stopping for Harm
If guardrail metric degrades by >{X}% with 99% confidence, stop experiment.

### Early Stopping for Success
{Not allowed / Sequential testing method}

### Minimum Runtime
{14 days} regardless of results to ensure:
- [ ] Full weekly cycle captured
- [ ] Novelty effects stabilized
- [ ] Sample size achieved

---

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk 1} | {L/M/H} | {L/M/H} | {Mitigation} |
| {Risk 2} | {L/M/H} | {L/M/H} | {Mitigation} |

---

## Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product | | | [ ] |
| Engineering | | | [ ] |
| Data Science | | | [ ] |

---

## Notes

{Any additional notes or context}

---

*Pre-registered before any data collection*
*Template version: 1.0*
