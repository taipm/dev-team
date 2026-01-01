# Analysis Methods for A/B Testing

> Comprehensive guide to analyzing experiment results với statistical rigor.

---

## 1. Pre-Analysis Validation

### Data Quality Checks

```
┌─────────────────────────────────────────────────────────┐
│             PRE-ANALYSIS CHECKLIST                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  [ ] Sample Ratio Mismatch (SRM) Check                  │
│  [ ] Minimum Runtime Achieved                           │
│  [ ] Data Collection Complete                           │
│  [ ] No External Confounders                            │
│  [ ] Metric Definitions Consistent                      │
│  [ ] Outlier Analysis                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Sample Ratio Mismatch (SRM)

**Definition:** When actual traffic split differs from expected split.

**Detection:**
```
Expected: 50% Control, 50% Treatment
Actual:   48% Control, 52% Treatment

Chi-square test:
χ² = Σ[(O-E)²/E]
χ² = (4800-5000)²/5000 + (5200-5000)²/5000
χ² = 8 + 8 = 16

p-value < 0.0001 → SRM DETECTED!
```

**SRM Alert Thresholds:**
```
p-value > 0.05  → OK
p-value ≤ 0.05  → WARNING - investigate
p-value ≤ 0.001 → CRITICAL - likely bug
```

**Common SRM Causes:**
| Cause | How to Detect |
|-------|---------------|
| Bot filtering | Check user agents |
| Redirect issues | Check page loads |
| Browser compatibility | Check by browser |
| Caching issues | Check assignment logs |
| Race conditions | Check timing data |

### Runtime Validation

```yaml
minimum_runtime_checks:
  weekly_cycle:
    requirement: "At least 7 days"
    reason: "Capture weekday vs weekend patterns"

  business_cycle:
    requirement: "At least 1 full business cycle"
    reason: "E.g., monthly billing cycle, pay periods"

  sample_size:
    requirement: "Achieved target sample size"
    reason: "Statistical power"

  novelty_effect:
    requirement: "14+ days for UX changes"
    reason: "Allow novelty to wear off"
```

---

## 2. Statistical Analysis

### Analysis Workflow

```
┌─────────────────────────────────────────────────────────┐
│              ANALYSIS WORKFLOW                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. VALIDATE                                            │
│     └── SRM, runtime, data quality                      │
│                                                         │
│  2. CALCULATE                                           │
│     ├── Point estimates                                 │
│     ├── Confidence intervals                            │
│     └── P-values / Posterior probabilities              │
│                                                         │
│  3. INTERPRET                                           │
│     ├── Statistical significance                        │
│     ├── Practical significance                          │
│     └── Effect size                                     │
│                                                         │
│  4. SEGMENT                                             │
│     └── Pre-defined segments only                       │
│                                                         │
│  5. DECIDE                                              │
│     └── Ship / Don't Ship / Keep Testing                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Frequentist Analysis

**Step 1: Calculate Point Estimates**
```
Control:
  Conversions: 500
  Users: 10,000
  Rate: 5.00%

Treatment:
  Conversions: 550
  Users: 10,000
  Rate: 5.50%

Absolute Lift: +0.50%
Relative Lift: +10.00%
```

**Step 2: Calculate Standard Error**
```
SE = √[p_c(1-p_c)/n_c + p_t(1-p_t)/n_t]
SE = √[0.05×0.95/10000 + 0.055×0.945/10000]
SE = √[0.00000475 + 0.00000520]
SE = 0.00315 = 0.315%
```

**Step 3: Calculate Confidence Interval**
```
95% CI = (p_t - p_c) ± 1.96 × SE
95% CI = 0.50% ± 1.96 × 0.315%
95% CI = [−0.12%, +1.12%]
```

**Step 4: Calculate P-value**
```
Z = (p_t - p_c) / SE
Z = 0.50% / 0.315% = 1.59

Two-tailed p-value = 2 × P(Z > 1.59) = 0.112
```

**Step 5: Interpret**
```
P-value (0.112) > α (0.05)
→ NOT statistically significant

BUT: CI includes meaningful effects (up to +1.12%)
→ May need more data
```

### Bayesian Analysis

**Step 1: Define Prior**
```python
# Non-informative prior
prior_alpha = 1
prior_beta = 1

# Informative prior (from historical data)
# If historical rate = 5% with n=1000
prior_alpha = 50
prior_beta = 950
```

**Step 2: Calculate Posterior**
```
Control:
  Prior: Beta(1, 1)
  Data: 500 successes, 9500 failures
  Posterior: Beta(501, 9501)
  Mean: 5.01%

Treatment:
  Prior: Beta(1, 1)
  Data: 550 successes, 9450 failures
  Posterior: Beta(551, 9451)
  Mean: 5.51%
```

**Step 3: Calculate P(Treatment > Control)**
```python
# Monte Carlo simulation
samples_control = np.random.beta(501, 9501, 100000)
samples_treatment = np.random.beta(551, 9451, 100000)

prob_treatment_wins = np.mean(samples_treatment > samples_control)
# Result: 94.5%
```

**Step 4: Calculate Expected Loss**
```python
# Expected loss if we choose Treatment but Control is better
loss_if_choose_treatment = np.mean(
    np.maximum(0, samples_control - samples_treatment)
)
# Result: 0.03%

# Expected loss if we choose Control but Treatment is better
loss_if_choose_control = np.mean(
    np.maximum(0, samples_treatment - samples_control)
)
# Result: 0.53%
```

**Step 5: Interpret**
```
P(Treatment > Control) = 94.5%
Expected Loss (Treatment) = 0.03%
Expected Loss (Control) = 0.53%

→ Strong evidence for Treatment
→ Low risk if Treatment is chosen
```

---

## 3. Effect Size Interpretation

### Practical Significance Framework

```
┌─────────────────────────────────────────────────────────┐
│         PRACTICAL SIGNIFICANCE MATRIX                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                    Statistically Significant?           │
│                    ┌───────────┬───────────┐           │
│                    │    Yes    │    No     │           │
│  ┌─────────────────┼───────────┼───────────┤           │
│  │ Practically     │  SHIP     │ NEED MORE │           │
│  │ Significant?    │  ✅       │ DATA      │           │
│  │ Yes             │           │ 🔄        │           │
│  ├─────────────────┼───────────┼───────────┤           │
│  │ Practically     │ PROBABLY  │ NO        │           │
│  │ Significant?    │ DON'T     │ EFFECT    │           │
│  │ No              │ SHIP ⚠️   │ ❌        │           │
│  └─────────────────┴───────────┴───────────┘           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Business Impact Calculator

```markdown
## Business Impact Assessment

### Inputs
| Parameter | Value |
|-----------|-------|
| Monthly Traffic | 1,000,000 |
| Baseline Conversion | 5% |
| Observed Lift | +10% |
| Revenue per Conversion | $50 |

### Impact Calculation
Current monthly conversions: 1,000,000 × 5% = 50,000
With treatment: 1,000,000 × 5.5% = 55,000
Additional conversions: 5,000/month
Additional revenue: 5,000 × $50 = $250,000/month

### Annualized Impact
$250,000 × 12 = $3,000,000/year

### Confidence Interval for Impact
95% CI for lift: [−0.12%, +1.12%]
Lower bound: −$24,000/month
Upper bound: +$224,000/month
```

### Minimum Practically Significant Effect

```yaml
guidelines:
  micro_optimization:
    threshold: "< 2% relative lift"
    consideration: "Is implementation cost worth it?"

  standard_change:
    threshold: "2-10% relative lift"
    consideration: "Good candidate for shipping"

  significant_improvement:
    threshold: "> 10% relative lift"
    consideration: "Strong ship, investigate why"

  too_good:
    threshold: "> 50% relative lift"
    consideration: "Verify data, possible bug"
```

---

## 4. Segment Analysis

### Pre-Defined Segments

```yaml
standard_segments:
  device_type:
    values: [mobile, desktop, tablet]
    importance: high
    reason: "Different UX, behavior patterns"

  user_tenure:
    values: [new, established, power]
    importance: high
    reason: "Familiarity with product"

  platform:
    values: [iOS, Android, Web]
    importance: medium
    reason: "Technical differences"

  geography:
    values: [by_country or by_region]
    importance: medium
    reason: "Cultural, economic differences"

  traffic_source:
    values: [organic, paid, referral, direct]
    importance: low
    reason: "Intent differences"
```

### Heterogeneous Treatment Effects (HTE)

**Question:** Does treatment effect vary by segment?

**Analysis:**
```
Segment    | Control | Treatment | Lift    | P-value
-----------|---------|-----------|---------|--------
Mobile     | 4.0%    | 5.0%      | +25%    | 0.01
Desktop    | 6.0%    | 5.5%      | −8%     | 0.15
Overall    | 5.0%    | 5.25%     | +5%     | 0.08

Interpretation:
- Treatment works great on Mobile (+25%)
- Treatment might hurt Desktop (−8%)
- Overall effect is masked by heterogeneity
```

**Interaction Test:**
```
H₀: Effect is the same across segments
H₁: Effect differs by segment

Test: Chi-square for homogeneity
If p < 0.05: Segment-specific effects exist
```

### Simpson's Paradox Warning

```
Example:
Treatment seems worse overall, but better in every segment

       | Control         | Treatment
-------|-----------------|------------------
Mobile | 4% (of 8000)    | 5% (of 2000)
Desktop| 6% (of 2000)    | 7% (of 8000)
-------|-----------------|------------------
Overall| 4.4% (320+120)  | 6.5% (100+560)

Explanation:
- Treatment has more Desktop users (higher baseline)
- Within each segment, Treatment wins
- Overall, Treatment seems to win due to mix shift
- Actually: Treatment is better in BOTH segments!
```

---

## 5. Multiple Testing Correction

### When to Apply

```yaml
correction_needed:
  - Multiple metrics being tested
  - Multiple segments being compared
  - Multiple time periods analyzed

correction_not_needed:
  - Pre-specified single OEC
  - Pre-specified single comparison
  - Guardrail metrics (use different threshold)
```

### Bonferroni Correction

```
Original α = 0.05
Number of tests = 5
Adjusted α = 0.05 / 5 = 0.01

Apply: Each test must have p < 0.01 to be significant
```

### Benjamini-Hochberg (FDR)

```
Step 1: Sort p-values
P₁ = 0.001, P₂ = 0.015, P₃ = 0.030, P₄ = 0.045, P₅ = 0.200

Step 2: Calculate threshold for each
α = 0.05, m = 5

i | p-value | Threshold (i/m × α) | Reject?
--|---------|---------------------|--------
1 | 0.001   | 0.01                | Yes
2 | 0.015   | 0.02                | Yes
3 | 0.030   | 0.03                | Yes
4 | 0.045   | 0.04                | No
5 | 0.200   | 0.05                | No

Result: First 3 hypotheses rejected
```

---

## 6. Sensitivity Analysis

### Outlier Impact

```python
# Check if outliers drive the result
def sensitivity_analysis(data, metric):
    # Full data
    result_full = analyze(data)

    # Without top 1% (outliers)
    data_trimmed = data[data[metric] < data[metric].quantile(0.99)]
    result_trimmed = analyze(data_trimmed)

    # Winsorized (cap at 99th percentile)
    data_winsorized = data.copy()
    cap = data[metric].quantile(0.99)
    data_winsorized[metric] = data_winsorized[metric].clip(upper=cap)
    result_winsorized = analyze(data_winsorized)

    return compare(result_full, result_trimmed, result_winsorized)
```

### Different Analysis Methods

```
Method        | Point Est | 95% CI        | Significant?
--------------|-----------|---------------|-------------
Z-test        | +10%      | [−2%, +22%]   | No
T-test        | +10%      | [−1%, +21%]   | No
Bayesian      | +10%      | [−1%, +21%]   | P(B>A)=94%
Mann-Whitney  | +8%       | [−3%, +19%]   | No

Interpretation:
All methods agree on direction and approximate effect size.
Borderline significance across methods.
```

### Time Period Sensitivity

```
Period        | Lift   | P-value | Notes
--------------|--------|---------|------------------------
Week 1        | +15%   | 0.03    | Novelty effect?
Week 2        | +8%    | 0.12    | Settling down
Week 3        | +9%    | 0.08    | Stable
Week 4        | +10%   | 0.05    | Stable
Full Period   | +10%   | 0.02    | Significant

Interpretation:
Initial novelty effect present, but effect persists.
True effect likely around +8-10%.
```

---

## 7. Decision Framework

### Decision Tree

```
┌─────────────────────────────────────────────────────────┐
│               DECISION TREE                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Is the experiment valid?                            │
│     ├── No → Debug, re-run                              │
│     └── Yes → Continue                                  │
│                                                         │
│  2. Is OEC statistically significant?                   │
│     ├── No → Is it directionally positive?              │
│     │        ├── No → Don't ship                        │
│     │        └── Yes → Need more data or accept risk    │
│     └── Yes → Continue                                  │
│                                                         │
│  3. Is the effect practically significant?              │
│     ├── No → Probably don't ship (ROI)                  │
│     └── Yes → Continue                                  │
│                                                         │
│  4. Are guardrails safe?                                │
│     ├── No → Don't ship or investigate                  │
│     └── Yes → Continue                                  │
│                                                         │
│  5. Any concerning segment patterns?                    │
│     ├── Yes → Consider segment-specific rollout         │
│     └── No → SHIP IT!                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Decision Documentation

```markdown
## Experiment Decision: {name}

### Summary Statistics
| Metric | Control | Treatment | Lift | P-value | Decision |
|--------|---------|-----------|------|---------|----------|
| OEC    | X%      | Y%        | +Z%  | 0.0X    | ✅/❌   |
| Guard1 | A%      | B%        | +C%  | 0.XX    | ✅/❌   |

### Validity Checks
- [x] SRM Check: Passed
- [x] Runtime: 14 days (minimum 7)
- [x] Sample Size: Achieved

### Statistical Conclusion
{Statistically significant / Not significant}

### Practical Conclusion
{Effect size is / is not practically meaningful}

### Final Decision
**SHIP / DON'T SHIP / CONTINUE TESTING**

### Rationale
{Why this decision was made}

### Next Steps
1. {action item}
2. {action item}

### Learnings
- {key learning 1}
- {key learning 2}

---
Decision by: {name}
Date: {YYYY-MM-DD}
```

---

## 8. Common Analysis Mistakes

### Mistakes to Avoid

| Mistake | Why It's Wrong | Correct Approach |
|---------|----------------|------------------|
| **Stopping early** | Inflates false positive rate | Pre-define stopping rules |
| **P-hacking** | Cherry-picking significant results | Pre-register analysis |
| **Ignoring SRM** | Invalid comparison groups | Always check first |
| **Post-hoc segments** | Multiple testing without correction | Pre-define segments |
| **Ignoring effect size** | Statistical ≠ Practical significance | Always calculate |
| **One-metric focus** | Missing full picture | Check guardrails too |

### Red Flags

```yaml
red_flags:
  - "P-value is 0.049" (suspiciously close to threshold)
  - "We just need a few more days" (waiting for significance)
  - "Let's check this other segment" (fishing)
  - "The lift is 50%!" (too good to be true)
  - "We'll figure out the metric later" (no pre-registration)
  - "Sample size doesn't matter for big effects" (always matters)
```

---

*Rigorous analysis is the bridge between data and decisions.*
