# Experiment Design Patterns

> Templates và best practices cho việc thiết kế A/B tests.

---

## 1. Experiment Design Workflow

### Complete Workflow

```
┌─────────────────────────────────────────────────────────┐
│            EXPERIMENT DESIGN WORKFLOW                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. DEFINE                                              │
│     ├── Problem statement                               │
│     ├── Hypothesis (H₀, H₁)                             │
│     └── Success criteria                                │
│                                                         │
│  2. MEASURE                                             │
│     ├── Primary metric (OEC)                            │
│     ├── Secondary metrics                               │
│     └── Guardrail metrics                               │
│                                                         │
│  3. CALCULATE                                           │
│     ├── Baseline rates                                  │
│     ├── Minimum Detectable Effect (MDE)                 │
│     ├── Sample size                                     │
│     └── Duration                                        │
│                                                         │
│  4. DESIGN                                              │
│     ├── Variants (Control, Treatment)                   │
│     ├── Randomization unit                              │
│     ├── Targeting/Segmentation                          │
│     └── Exclusion criteria                              │
│                                                         │
│  5. PRE-REGISTER                                        │
│     ├── Document all decisions                          │
│     ├── Define stopping rules                           │
│     └── Set analysis plan                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Hypothesis Formulation

### Template

```markdown
## Hypothesis Statement

**Background:**
{Context about the problem and what led to this experiment}

**Change:**
{What we're changing in the treatment variant}

**Hypothesis:**
We believe that {change} will {expected effect} because {reasoning}.

**Null Hypothesis (H₀):**
{Change} has no effect on {primary metric}.

**Alternative Hypothesis (H₁):**
{Change} {increases/decreases} {primary metric} by at least {MDE}.
```

### Examples

**Good Hypothesis:**
```
We believe that changing the CTA button from "Sign Up" to "Start Free Trial"
will increase registration conversion rate by at least 10%
because it reduces perceived commitment and emphasizes the free aspect.
```

**Bad Hypothesis:**
```
We think the new button will be better.
(Too vague - no specific metric or expected effect)
```

### Hypothesis Checklist

| Criterion | Check |
|-----------|-------|
| Specific change defined? | [ ] |
| Measurable outcome? | [ ] |
| Expected direction stated? | [ ] |
| Reasoning provided? | [ ] |
| Falsifiable? | [ ] |

---

## 3. Metric Selection

### Metric Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                  METRIC HIERARCHY                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────┐           │
│  │     PRIMARY METRIC (OEC)                │           │
│  │     - One metric to rule them all       │           │
│  │     - Decision maker                    │           │
│  └─────────────────────────────────────────┘           │
│                    ▲                                    │
│  ┌─────────────────────────────────────────┐           │
│  │     SECONDARY METRICS                   │           │
│  │     - Support primary hypothesis        │           │
│  │     - Provide additional insights       │           │
│  │     - Exploratory analysis              │           │
│  └─────────────────────────────────────────┘           │
│                    ▲                                    │
│  ┌─────────────────────────────────────────┐           │
│  │     GUARDRAIL METRICS                   │           │
│  │     - Must not regress                  │           │
│  │     - Safety checks                     │           │
│  │     - Business constraints              │           │
│  └─────────────────────────────────────────┘           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Common Metrics by Domain

**E-commerce:**
```yaml
primary:
  - Conversion Rate (Purchases / Visitors)
  - Revenue per Visitor
secondary:
  - Add to Cart Rate
  - Checkout Completion Rate
  - Average Order Value
guardrails:
  - Return Rate
  - Customer Support Contacts
  - Page Load Time
```

**SaaS:**
```yaml
primary:
  - Trial-to-Paid Conversion
  - Activation Rate
secondary:
  - Feature Adoption
  - Time to First Value
  - User Engagement
guardrails:
  - Churn Rate
  - Support Tickets
  - Error Rate
```

**Media/Content:**
```yaml
primary:
  - Click-through Rate
  - Time on Site
secondary:
  - Pages per Session
  - Scroll Depth
  - Social Shares
guardrails:
  - Bounce Rate
  - Ad Revenue
  - Load Time
```

### Metric Properties

| Property | Good Metric | Bad Metric |
|----------|-------------|------------|
| **Sensitive** | Detects small changes | Noisy, requires huge samples |
| **Robust** | Not easily gamed | Can be manipulated |
| **Timely** | Quick feedback | Takes months to measure |
| **Interpretable** | Clear meaning | Complex composite |
| **Aligned** | Reflects business goal | Proxy metric misaligned |

---

## 4. Sample Size Planning

### Input Parameters

```yaml
sample_size_inputs:
  baseline_rate:
    description: "Current conversion rate"
    how_to_get: "Historical data (30+ days)"
    example: 5%

  minimum_detectable_effect:
    description: "Smallest meaningful improvement"
    how_to_get: "Business judgment - what's worth shipping?"
    example: 10% relative (0.5% absolute)

  statistical_power:
    description: "Probability of detecting true effect"
    default: 80%
    when_higher: "Critical decisions (90%)"

  significance_level:
    description: "Threshold for statistical significance"
    default: 5%
    when_lower: "High-risk changes (1%)"
```

### MDE Selection Guide

```
┌─────────────────────────────────────────────────────────┐
│           CHOOSING MDE (Relative Lift)                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  5%  - Very sensitive, need huge sample                 │
│        Use for: High-traffic, incremental improvements  │
│                                                         │
│  10% - Standard for most experiments                    │
│        Use for: Typical product changes                 │
│                                                         │
│  20% - Larger effect, smaller sample                    │
│        Use for: Major redesigns, new features           │
│                                                         │
│  50%+ - Only major changes will be detected             │
│         Use for: Very low traffic, big bets             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Sample Size Calculator Template

```markdown
## Sample Size Calculation

### Inputs
| Parameter | Value |
|-----------|-------|
| Baseline Rate | {X%} |
| MDE (Relative) | {Y%} |
| MDE (Absolute) | {X × Y%} |
| Power | 80% |
| Significance | 5% |
| Variants | 2 |

### Calculation
Using formula: n = 2 × (Z_α + Z_β)² × p(1-p) / δ²

n = 2 × (1.96 + 0.84)² × {X} × (1-{X}) / {absolute MDE}²
n = {result} per variant

### Duration Estimate
Daily Traffic: {N users}
Total Sample Needed: {2 × n}
Estimated Duration: {2n / N} days

### Recommendation
Run for minimum {max(duration, 7)} days to account for weekly patterns.
```

---

## 5. Randomization Design

### Randomization Units

| Unit | When to Use | Considerations |
|------|-------------|----------------|
| **User** | Most experiments | Best for UX changes |
| **Session** | Anonymous users | Higher variance |
| **Page View** | Content experiments | Inconsistent experience |
| **Device** | Cross-device users | May have multiple |
| **Account** | B2B, Teams | Fewer units |
| **Cluster** | Marketplace, Social | Network effects |

### Stratified Randomization

```yaml
stratification:
  purpose: "Ensure balanced groups for known confounders"

  common_strata:
    - device_type: [mobile, desktop, tablet]
    - user_segment: [new, returning, power]
    - geography: [US, EU, APAC]
    - platform: [iOS, Android, Web]

  how_it_works: |
    1. Define strata before experiment
    2. Randomize within each stratum
    3. Ensures proportional representation

  example: |
    Without stratification:
    Control might get 60% mobile, Treatment 40%

    With stratification:
    Both Control and Treatment get 50% mobile
```

### Holdout Groups

```
┌─────────────────────────────────────────────────────────┐
│                  TRAFFIC ALLOCATION                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ██████████████████████████████████░░░░░░░░░░  85%     │
│  │← Experiment Traffic →│          │← Holdout →│        │
│                                                         │
│  Experiment Traffic (85%):                              │
│  ├── Control (42.5%)                                    │
│  └── Treatment (42.5%)                                  │
│                                                         │
│  Holdout (15%):                                         │
│  └── Never sees any experiments                         │
│      Used for long-term impact measurement              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 6. Variant Design

### Control vs Treatment

```yaml
control:
  definition: "Current experience (status quo)"
  rules:
    - No changes from production
    - Same as what users currently see
    - Baseline for comparison

treatment:
  definition: "New experience being tested"
  rules:
    - Only ONE change from control
    - Isolate the variable being tested
    - Document all differences
```

### Multi-Variant Testing

```
A/B Test: 2 variants
├── Control (A)
└── Treatment (B)

A/B/n Test: Multiple treatments
├── Control (A)
├── Treatment 1 (B)
├── Treatment 2 (C)
└── Treatment 3 (D)

Warning: Each variant needs full sample size!
4 variants = 4× sample = 4× duration
```

### Factorial Design

```
Test multiple factors simultaneously:

Factor 1: Button Color (Blue vs Green)
Factor 2: Button Text ("Sign Up" vs "Get Started")

Variants:
A: Blue + "Sign Up" (Control)
B: Green + "Sign Up"
C: Blue + "Get Started"
D: Green + "Get Started"

Benefit: Can detect interaction effects
Cost: Need 4× sample for same power
```

---

## 7. Targeting & Segmentation

### Pre-Experiment Targeting

```yaml
targeting_criteria:
  include:
    - users with 3+ visits
    - registered accounts
    - specific countries

  exclude:
    - internal employees
    - bots/crawlers
    - users in other experiments
    - known outliers
```

### Pre-Defined Segments

```yaml
segments_to_analyze:
  device:
    - mobile
    - desktop

  user_type:
    - new (first 7 days)
    - returning (8+ days)

  geography:
    - US
    - EU
    - Other

documentation: |
  Pre-define ALL segments in experiment design.
  Post-hoc segmentation is exploratory only.
```

---

## 8. Pre-Registration Document

### Template

```markdown
# Experiment Pre-Registration

## Metadata
| Field | Value |
|-------|-------|
| Experiment ID | {EXP-XXX} |
| Name | {Descriptive name} |
| Owner | {Name} |
| Pre-registered Date | {YYYY-MM-DD} |
| Planned Start | {YYYY-MM-DD} |
| Planned End | {YYYY-MM-DD} |

## Hypothesis
{Full hypothesis statement}

## Metrics

### Primary Metric (OEC)
- **Name**: {metric name}
- **Definition**: {exact calculation}
- **Baseline**: {X%}
- **MDE**: {Y%}

### Secondary Metrics
1. {Metric 1}: {definition}
2. {Metric 2}: {definition}

### Guardrail Metrics
1. {Guardrail 1}: Must not regress by more than {Z%}

## Statistical Plan

### Sample Size
- Per variant: {N}
- Total: {2N}
- Expected duration: {D days}

### Analysis Method
- Primary: {Frequentist Z-test / Bayesian Beta-Binomial}
- Significance level: {5%}
- Power: {80%}
- Multiple testing correction: {Bonferroni / None}

## Variants

### Control (A)
{Description of control experience}

### Treatment (B)
{Description of treatment experience}
{Screenshot or mockup if applicable}

## Randomization
- Unit: {User / Session}
- Allocation: {50/50}
- Stratification: {None / device_type}

## Stopping Rules

### Early Stopping
- For harm: If guardrail degrades by >{X}% with 99% confidence
- For success: {Not allowed / Alpha spending method}

### Minimum Runtime
- {14 days} regardless of results

## Exclusions
- {Internal users}
- {Users in experiment XYZ}
- {Known bots}

## Segments
Pre-defined segments for analysis:
1. {Segment 1}
2. {Segment 2}

## Risks and Mitigations
| Risk | Mitigation |
|------|------------|
| {Risk 1} | {Mitigation} |

## Approval
- [ ] Product: {Name, Date}
- [ ] Engineering: {Name, Date}
- [ ] Data Science: {Name, Date}

---
*Pre-registered before any data collection*
```

---

## 9. Experiment Lifecycle

### States

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│ PLANNING │ →  │ RUNNING  │ →  │ ANALYSIS │
└──────────┘    └──────────┘    └──────────┘
     │               │               │
     ▼               ▼               ▼
  Design         Monitor         Interpret
  Calculate      Validate        Recommend
  Pre-register   Debug           Document
```

### Checklist by Phase

**Planning Phase:**
```
[ ] Hypothesis defined
[ ] Primary metric chosen
[ ] Sample size calculated
[ ] Duration estimated
[ ] Variants designed
[ ] Pre-registration complete
[ ] Stakeholders aligned
```

**Running Phase:**
```
[ ] Randomization verified
[ ] Sample Ratio Mismatch checked daily
[ ] No peeking at results
[ ] Monitoring for errors/bugs
[ ] External events documented
```

**Analysis Phase:**
```
[ ] Minimum runtime reached
[ ] SRM check passed
[ ] Statistical analysis complete
[ ] Practical significance assessed
[ ] Segments analyzed
[ ] Results documented
[ ] Decision made and communicated
```

---

## 10. Common Design Patterns

### Feature Flag Pattern

```python
# Simple feature flag for A/B test
def get_variant(user_id):
    # Hash user_id for consistent assignment
    hash_value = hash(user_id) % 100
    if hash_value < 50:
        return "control"
    else:
        return "treatment"

# In application code
variant = get_variant(current_user.id)
if variant == "treatment":
    show_new_feature()
else:
    show_old_feature()
```

### Ramp-Up Pattern

```
Day 1-2:   1% traffic (catch bugs)
Day 3-4:   10% traffic (validate metrics)
Day 5+:    50% traffic (full experiment)

Purpose:
- Minimize risk of bad changes
- Early detection of issues
- Build confidence before full rollout
```

### Experiment Isolation

```yaml
isolation_strategies:
  mutex_groups:
    description: "Users can only be in one experiment at a time"
    use_when: "Experiments might interact"

  layered_experiments:
    description: "Independent experiments on separate layers"
    use_when: "Experiments are orthogonal"

  holdout_sets:
    description: "Some users never see experiments"
    use_when: "Need to measure long-term cumulative impact"
```

---

*Good experiment design is the foundation of trustworthy results.*
