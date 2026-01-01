# Statistical Frameworks for A/B Testing

> Core statistical methods và foundations cho experiment design và analysis.

---

## 1. Hypothesis Testing Framework

### The Foundation

```
┌─────────────────────────────────────────────────────────┐
│                  HYPOTHESIS TESTING                     │
├─────────────────────────────────────────────────────────┤
│  H₀ (Null Hypothesis)                                   │
│  "There is no difference between variants"              │
│                                                         │
│  H₁ (Alternative Hypothesis)                            │
│  "Treatment has an effect on the metric"                │
│                                                         │
│  Goal: Collect evidence to reject or fail to reject H₀  │
└─────────────────────────────────────────────────────────┘
```

### Key Concepts

| Concept | Definition | Typical Value |
|---------|------------|---------------|
| **α (Alpha)** | Probability of Type I error (false positive) | 0.05 (5%) |
| **β (Beta)** | Probability of Type II error (false negative) | 0.20 (20%) |
| **Power (1-β)** | Probability of detecting true effect | 0.80 (80%) |
| **p-value** | Probability of observing data if H₀ is true | < α to reject |

### Type I vs Type II Errors

```
                    Reality
                    ┌─────────────┬─────────────┐
                    │ H₀ True     │ H₀ False    │
                    │ (No Effect) │ (Effect)    │
┌───────────────────┼─────────────┼─────────────┤
│ Reject H₀         │ Type I      │ Correct     │
│ (Ship Treatment)  │ Error (α)   │ (Power)     │
├───────────────────┼─────────────┼─────────────┤
│ Fail to Reject H₀ │ Correct     │ Type II     │
│ (Keep Control)    │ (1-α)       │ Error (β)   │
└───────────────────┴─────────────┴─────────────┘
```

### One-Tailed vs Two-Tailed Tests

| Test Type | When to Use | Critical Region |
|-----------|-------------|-----------------|
| **Two-tailed** | "Is there any difference?" | Both ends |
| **One-tailed** | "Is treatment better/worse?" | One end only |

```
Two-tailed (α=0.05):
   ← 2.5% →              ← 2.5% →
   ████░░░░░░░░░░░░░░░░░░░░░████
   -1.96                    +1.96

One-tailed (α=0.05):
                         ← 5% →
   ░░░░░░░░░░░░░░░░░░░░░░░░█████
                          +1.645
```

---

## 2. Frequentist Methods

### 2.1 Z-Test for Proportions

**When to use:** Comparing conversion rates with large samples (n > 30)

**Formula:**
```
Z = (p₁ - p₂) / √[p̂(1-p̂)(1/n₁ + 1/n₂)]

Where:
- p₁, p₂ = conversion rates of control and treatment
- p̂ = pooled proportion = (x₁ + x₂)/(n₁ + n₂)
- n₁, n₂ = sample sizes
```

**Example:**
```
Control:  1,000 conversions / 10,000 visitors = 10%
Treatment: 1,100 conversions / 10,000 visitors = 11%

p̂ = (1000 + 1100) / (10000 + 10000) = 0.105
SE = √[0.105 × 0.895 × (1/10000 + 1/10000)] = 0.00433
Z = (0.11 - 0.10) / 0.00433 = 2.31

p-value (two-tailed) = 0.021 < 0.05 → Significant!
```

### 2.2 T-Test for Means

**When to use:** Comparing continuous metrics (revenue, time on site)

**Formula (Welch's t-test):**
```
t = (x̄₁ - x̄₂) / √(s₁²/n₁ + s₂²/n₂)

Where:
- x̄₁, x̄₂ = sample means
- s₁², s₂² = sample variances
- n₁, n₂ = sample sizes
```

**Degrees of freedom (Welch-Satterthwaite):**
```
df = (s₁²/n₁ + s₂²/n₂)² / [(s₁²/n₁)²/(n₁-1) + (s₂²/n₂)²/(n₂-1)]
```

### 2.3 Chi-Square Test

**When to use:** Categorical outcomes with multiple categories

**Formula:**
```
χ² = Σ [(O - E)² / E]

Where:
- O = Observed frequency
- E = Expected frequency
```

**Example:**
```
              Control  Treatment
Purchased        100       120
Not Purchased    900       880
              ─────────────────
Total           1000      1000

χ² = (100-110)²/110 + (120-110)²/110 +
     (900-890)²/890 + (880-890)²/890
   = 0.91 + 0.91 + 0.11 + 0.11 = 2.04

df = 1, p-value = 0.15 > 0.05 → Not Significant
```

### 2.4 Mann-Whitney U Test

**When to use:** Non-parametric alternative when data isn't normally distributed

**Assumptions:**
- No normality requirement
- Ordinal or continuous data
- Independent samples

---

## 3. Bayesian Methods

### 3.1 Bayesian Framework

```
┌─────────────────────────────────────────────────────────┐
│              BAYESIAN INFERENCE                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Posterior ∝ Likelihood × Prior                         │
│                                                         │
│  P(θ|Data) ∝ P(Data|θ) × P(θ)                          │
│                                                         │
│  "Update your beliefs with evidence"                    │
└─────────────────────────────────────────────────────────┘
```

### 3.2 Beta-Binomial Model (for Conversion Rates)

**Prior:** Beta(α₀, β₀) - represents prior belief about conversion rate

**Likelihood:** Binomial(n, p)

**Posterior:** Beta(α₀ + successes, β₀ + failures)

**Common priors:**
```
Non-informative: Beta(1, 1) - Uniform
Weakly informative: Beta(1, 1) - Jeffreys
Informative: Beta(α, β) based on historical data
```

**Example:**
```
Prior: Beta(1, 1) - no prior knowledge
Data: 100 conversions out of 1000 visitors

Posterior: Beta(1 + 100, 1 + 900) = Beta(101, 901)
Mean: 101/(101+901) = 10.1%
95% Credible Interval: [8.3%, 12.1%]
```

### 3.3 Probability to Beat Control

**Key Bayesian metric:** P(Treatment > Control)

**Calculation (Monte Carlo):**
```python
# Sample from posteriors
samples_control = np.random.beta(α_c, β_c, 100000)
samples_treatment = np.random.beta(α_t, β_t, 100000)

# Calculate probability
prob_treatment_wins = np.mean(samples_treatment > samples_control)
```

**Interpretation:**
```
P(B > A) = 95%  → "95% probability Treatment is better"
P(B > A) = 50%  → "Coin flip - no clear winner"
P(B > A) = 5%   → "95% probability Control is better"
```

### 3.4 Expected Loss

**Definition:** Expected loss from choosing the wrong variant

```
Expected Loss(A) = E[max(0, p_B - p_A)]
Expected Loss(B) = E[max(0, p_A - p_B)]
```

**Decision rule:**
```
If Expected Loss(B) < threshold → Ship B
Typical threshold: 0.1% to 1% of baseline
```

---

## 4. Sample Size Calculation

### 4.1 For Proportions (Conversion Rates)

**Formula:**
```
n = 2 × [(Z_α/2 + Z_β)² × p(1-p)] / δ²

Where:
- n = sample size per variant
- Z_α/2 = Z-score for significance (1.96 for 95%)
- Z_β = Z-score for power (0.84 for 80%)
- p = baseline proportion
- δ = minimum detectable effect (absolute)
```

**Simplified formula:**
```
n ≈ 16 × p(1-p) / δ²   (for 80% power, 95% significance)
```

### 4.2 Quick Reference Tables

**For Conversion Rates (80% power, 95% significance, two-tailed):**

| Baseline | 5% Relative MDE | 10% Relative MDE | 20% Relative MDE |
|----------|-----------------|------------------|------------------|
| 1% | 505,000 | 127,000 | 32,000 |
| 2% | 247,000 | 62,000 | 16,000 |
| 5% | 97,000 | 25,000 | 7,000 |
| 10% | 46,000 | 12,000 | 3,000 |
| 20% | 21,000 | 5,000 | 1,500 |

### 4.3 Duration Calculator

**Formula:**
```
Duration (days) = (Sample Size × 2) / Daily Traffic

Example:
- Need 25,000 per variant
- Daily traffic: 5,000
- Duration = 50,000 / 5,000 = 10 days
```

**Considerations:**
- Run at least 1 full week (capture day-of-week effects)
- Run at least 2 business cycles
- Account for holidays, special events

---

## 5. Confidence Intervals

### 5.1 For Proportions

**Wald Interval:**
```
CI = p ± Z_α/2 × √[p(1-p)/n]

Example:
p = 0.10, n = 1000
SE = √[0.10 × 0.90 / 1000] = 0.0095
95% CI = 0.10 ± 1.96 × 0.0095 = [0.081, 0.119]
```

**Wilson Score Interval (recommended for small samples):**
```
CI = (p + Z²/2n ± Z√[p(1-p)/n + Z²/4n²]) / (1 + Z²/n)
```

### 5.2 For Difference in Proportions

```
CI(p₁ - p₂) = (p₁ - p₂) ± Z_α/2 × √[p₁(1-p₁)/n₁ + p₂(1-p₂)/n₂]

Example:
Control: p₁ = 0.10, n₁ = 1000
Treatment: p₂ = 0.12, n₂ = 1000

Diff = 0.02
SE = √[0.10×0.90/1000 + 0.12×0.88/1000] = 0.0134
95% CI = 0.02 ± 1.96 × 0.0134 = [-0.006, 0.046]

Interpretation: Effect could be anywhere from -0.6% to +4.6%
```

### 5.3 Relative Lift Confidence Interval

```
Relative Lift = (p₂ - p₁) / p₁

CI for Relative Lift ≈ Lift × [1 ± Z_α/2 × √(1/x₁ + 1/x₂ - 1/n₁ - 1/n₂)]

Where x₁, x₂ = number of conversions
```

---

## 6. Multiple Testing Correction

### 6.1 The Problem

```
Testing 20 metrics at α = 0.05
Expected false positives = 20 × 0.05 = 1

P(at least one false positive) = 1 - (0.95)^20 = 64%!
```

### 6.2 Bonferroni Correction

**Method:** Divide α by number of tests

```
α_adjusted = α / m

Example:
- Original α = 0.05
- Number of metrics = 5
- Adjusted α = 0.05 / 5 = 0.01
```

**Pros:** Simple, controls family-wise error rate
**Cons:** Very conservative, reduces power

### 6.3 Benjamini-Hochberg (FDR Control)

**Method:** Controls false discovery rate instead of family-wise error

```
1. Sort p-values: p(1) ≤ p(2) ≤ ... ≤ p(m)
2. Find largest k where p(k) ≤ (k/m) × α
3. Reject H₀ for all tests with p ≤ p(k)
```

**Pros:** More power than Bonferroni
**Cons:** Some false positives expected

### 6.4 Practical Approach

```
1. Designate ONE primary metric (OEC) - no correction needed
2. Secondary metrics are exploratory - use FDR control
3. Guardrail metrics - use traditional α
4. Document all metrics analyzed in pre-registration
```

---

## 7. Effect Size Metrics

### 7.1 Cohen's d (for means)

```
d = (x̄₁ - x̄₂) / s_pooled

Interpretation:
- |d| < 0.2: Small effect
- |d| ≈ 0.5: Medium effect
- |d| > 0.8: Large effect
```

### 7.2 Risk Ratio (Relative Risk)

```
RR = p_treatment / p_control

Example: 11% / 10% = 1.10
Interpretation: "Treatment has 10% higher conversion rate"
```

### 7.3 Odds Ratio

```
OR = [p_t / (1 - p_t)] / [p_c / (1 - p_c)]

Example:
p_t = 0.11, p_c = 0.10
OR = (0.11/0.89) / (0.10/0.90) = 1.11

Interpretation: "Odds of conversion 11% higher in treatment"
```

### 7.4 Number Needed to Treat (NNT)

```
NNT = 1 / |p_t - p_c|

Example: 1 / (0.11 - 0.10) = 100
Interpretation: "Need 100 users in treatment to get 1 additional conversion"
```

---

## 8. Sequential Testing

### 8.1 The Peeking Problem

```
Traditional hypothesis testing assumes ONE look at data.

Checking results repeatedly inflates Type I error:

Checks  | Actual α (nominal 5%)
--------|----------------------
1       | 5.0%
2       | 8.3%
5       | 14.2%
10      | 19.3%
20      | 26.6%
```

### 8.2 Group Sequential Methods

**Alpha Spending Functions:**

```
O'Brien-Fleming: Very conservative early, α saved for end
Pocock: Equal spending at each look
Haybittle-Peto: Use α/1000 early, full α at end
```

**Example (O'Brien-Fleming, 5 looks):**
```
Look | Cumulative α | Z boundary
-----|--------------|------------
1    | 0.0001       | 4.56
2    | 0.0013       | 3.23
3    | 0.0084       | 2.63
4    | 0.0228       | 2.28
5    | 0.0500       | 2.04
```

### 8.3 Always Valid Inference (AVI)

**Confidence sequences:** CIs that remain valid at any stopping time

**Mixture sequential probability ratio test (mSPRT):**
- Can check continuously
- Maintains Type I error control
- More complex to implement

---

## Decision Framework Summary

```
┌─────────────────────────────────────────────────────────┐
│              WHICH METHOD TO USE?                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Question: "Is A different from B?"                     │
│  ↓                                                      │
│  Metric type?                                           │
│  ├── Proportion (conversion) → Z-test or Beta-Binomial │
│  ├── Continuous (revenue) → T-test or Normal-Normal    │
│  └── Categorical (choices) → Chi-square                │
│  ↓                                                      │
│  Philosophy?                                            │
│  ├── Frequentist → p-value, CI                         │
│  └── Bayesian → Posterior, P(B>A), Expected Loss       │
│  ↓                                                      │
│  Multiple metrics?                                      │
│  ├── One primary → No correction                       │
│  └── Multiple → Bonferroni or FDR                      │
│  ↓                                                      │
│  Peeking needed?                                        │
│  ├── No → Standard test                                │
│  └── Yes → Sequential testing                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

*Statistical rigor is the foundation of trustworthy experiments.*
