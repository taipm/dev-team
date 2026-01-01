# Paper Quality Assessment Guide

## Overview

Hướng dẫn đánh giá chất lượng papers một cách systematic, covering methodology, evidence quality, reproducibility, và overall trustworthiness.

---

## Quality Dimensions

### 1. Methodological Rigor

```yaml
scoring_criteria:
  excellent: # 9-10
    - "Clear problem formulation"
    - "Justified methodology choices"
    - "Comprehensive experimental design"
    - "Fair and up-to-date baselines"
    - "Thorough ablation studies"
    - "Statistical significance established"

  good: # 7-8
    - "Clear problem statement"
    - "Reasonable methodology"
    - "Adequate experiments"
    - "Fair baselines"
    - "Some ablations"

  adequate: # 5-6
    - "Problem stated but could be clearer"
    - "Methodology works but not well justified"
    - "Limited experiments"
    - "Missing some baselines"

  weak: # 3-4
    - "Unclear problem definition"
    - "Unjustified choices"
    - "Insufficient experiments"
    - "Outdated baselines"

  poor: # 1-2
    - "Fundamental methodology issues"
    - "Missing critical experiments"
    - "Unfair comparisons"
```

### 2. Evidence Quality

```yaml
evaluation_checklist:
  experimental_coverage:
    - question: "Bao nhiêu datasets được test?"
      scoring:
        "5+": "Excellent"
        "3-4": "Good"
        "2": "Adequate"
        "1": "Weak"

    - question: "Baselines có up-to-date không?"
      scoring:
        "All within 1 year": "Excellent"
        "Most within 2 years": "Good"
        "Mix of old and new": "Adequate"
        "Mostly outdated": "Weak"

    - question: "Ablation studies?"
      scoring:
        "All components ablated": "Excellent"
        "Main components ablated": "Good"
        "Some ablations": "Adequate"
        "No ablations": "Weak"

  statistical_rigor:
    - question: "Multiple runs với different seeds?"
      required: true
      good_practice: "≥3 runs, report mean±std"

    - question: "Statistical significance tests?"
      required: "For close results"
      good_practice: "p-values or confidence intervals"

    - question: "Effect size reported?"
      required: false
      good_practice: "Helps interpret practical significance"
```

### 3. Reproducibility

```yaml
reproducibility_checklist:
  code:
    - "Source code available?" # High impact
    - "Documentation adequate?"
    - "Dependencies specified?"
    - "Can run out-of-box?"

  data:
    - "Data publicly available?"
    - "Preprocessing documented?"
    - "Train/val/test splits specified?"

  hyperparameters:
    - "All hyperparameters listed?"
    - "Search procedure described?"
    - "Sensitivity analysis done?"

  environment:
    - "Hardware specified?"
    - "Software versions listed?"
    - "Random seeds fixed?"

scoring:
  fully_reproducible: "10/10 items checked"
  mostly_reproducible: "7-9/10 items"
  partially_reproducible: "4-6/10 items"
  difficult_to_reproduce: "<4/10 items"
```

### 4. Claim-Evidence Alignment

```yaml
assessment_matrix:
  for_each_major_claim:
    claim: "{Exact claim from paper}"
    evidence_type: "Experiment / Proof / Citation / Reasoning"
    evidence_strength:
      strong: "Direct evidence, statistically significant"
      moderate: "Indirect evidence or limited scope"
      weak: "Anecdotal or reasoning only"
      missing: "No supporting evidence"

  overall_alignment:
    excellent: "All claims strongly supported"
    good: "Most claims supported, some moderate"
    adequate: "Mix of support levels"
    poor: "Multiple unsupported claims"
```

---

## Red Flags Taxonomy

### Severe Red Flags (Potential Deal-breakers)

```yaml
data_issues:
  - name: "Data Leakage"
    description: "Test data influenced training"
    how_to_detect:
      - "Suspiciously high performance"
      - "No clear train/test separation"
      - "Preprocessing on entire dataset"

  - name: "Cherry-picked Datasets"
    description: "Only favorable benchmarks used"
    how_to_detect:
      - "Avoiding standard benchmarks"
      - "Using custom/obscure datasets"
      - "No comparison on author-unfavorable data"

methodology_issues:
  - name: "Unfair Baselines"
    description: "Baselines deliberately weakened"
    how_to_detect:
      - "Baseline performance below published"
      - "Different hyperparameters for baselines"
      - "Missing obvious strong baselines"

  - name: "P-hacking"
    description: "Selective reporting of experiments"
    how_to_detect:
      - "Only positive results shown"
      - "Many metrics reported, only some highlighted"
      - "Suspicious round numbers"

  - name: "HARKing"
    description: "Hypothesizing After Results Known"
    how_to_detect:
      - "Story too perfect"
      - "All experiments support hypothesis"
      - "No negative results at all"
```

### Moderate Red Flags

```yaml
presentation_issues:
  - name: "Overclaiming"
    description: "Claims stronger than evidence"
    examples:
      - "First to..." (without thorough search)
      - "State-of-the-art" (on limited benchmarks)
      - "Significantly better" (without significance test)

  - name: "Vague Methodology"
    description: "Key details omitted"
    examples:
      - "We found that..." (no specifics)
      - "Standard preprocessing" (not defined)
      - "Competitive hyperparameters" (not listed)

  - name: "Missing Limitations"
    description: "No honest discussion of weaknesses"
    examples:
      - "No limitations section"
      - "Only trivial limitations mentioned"
      - "Future work without acknowledging gaps"
```

### Yellow Flags (Investigate Further)

```yaml
investigate:
  - name: "Single Dataset"
    concern: "Results may not generalize"
    mitigation: "Check if standard for this task"

  - name: "Small Improvements"
    concern: "May be noise"
    mitigation: "Check if statistically significant"

  - name: "Large Author List"
    concern: "Contribution distribution unclear"
    mitigation: "Check author roles if stated"

  - name: "Industry Paper"
    concern: "May have unreported advantages"
    mitigation: "Check resource requirements"
```

---

## Quality Scoring Framework

### Overall Quality Score

```yaml
dimensions:
  methodology: # 25%
    weight: 0.25
    score: 1-10

  evidence: # 25%
    weight: 0.25
    score: 1-10

  reproducibility: # 20%
    weight: 0.20
    score: 1-10

  claim_alignment: # 15%
    weight: 0.15
    score: 1-10

  presentation: # 15%
    weight: 0.15
    score: 1-10

overall_score: weighted_average

interpretation:
  "9-10": "Excellent - High confidence in results"
  "7-8": "Good - Results likely reliable"
  "5-6": "Adequate - Some concerns but usable"
  "3-4": "Weak - Significant concerns"
  "1-2": "Poor - Major issues, do not trust"
```

### Trust Level Assessment

```yaml
trust_levels:
  high_trust:
    criteria:
      - "Overall score ≥ 8"
      - "No severe red flags"
      - "Reproducible"
    recommendation: "Can build on this work"

  moderate_trust:
    criteria:
      - "Overall score 6-7"
      - "No severe red flags"
      - "Most results reproducible"
    recommendation: "Use with verification"

  low_trust:
    criteria:
      - "Overall score 4-5"
      - "Some red flags present"
      - "Reproducibility concerns"
    recommendation: "Treat as preliminary"

  no_trust:
    criteria:
      - "Overall score < 4"
      - "Severe red flags"
      - "Cannot reproduce"
    recommendation: "Do not rely on results"
```

---

## Baseline Evaluation Checklist

### Baseline Fairness Assessment

```yaml
checklist:
  selection:
    - "All relevant baselines included?"
    - "Recent baselines (< 2 years)?"
    - "Strong baselines from major labs?"
    - "Simple baselines included?"

  implementation:
    - "Official implementations used when available?"
    - "Hyperparameters from original papers?"
    - "Same preprocessing for all methods?"
    - "Same compute budget?"

  reporting:
    - "Baseline numbers match published?"
    - "If different, explained why?"
    - "Error bars for all methods?"

  fairness_score:
    all_yes: "Fair comparison"
    mostly_yes: "Mostly fair"
    mixed: "Questionable fairness"
    mostly_no: "Unfair comparison"
```

### Missing Baseline Detection

```yaml
should_include:
  type_1: "Obvious SOTA"
    method: "Check papers from last 2 years on same task"

  type_2: "Simple Baseline"
    method: "Is there a simple method that often works?"
    examples: ["Linear model", "TF-IDF", "Random Forest"]

  type_3: "Ablated Method"
    method: "Their method minus key component"

  type_4: "Related Approach"
    method: "Alternative paradigm for same problem"
```

---

## Ablation Study Quality

### Required Ablations

```yaml
component_ablation:
  purpose: "Verify each component contributes"
  method: "Remove each component one at a time"
  red_flag: "No ablations = Can't trust what matters"

hyperparameter_sensitivity:
  purpose: "Results robust to choices?"
  method: "Vary key hyperparameters"
  red_flag: "Single setting = May be overfitted"

data_ablation:
  purpose: "How much data needed?"
  method: "Train with different data sizes"
  red_flag: "Only full data = Unclear data efficiency"
```

### Ablation Quality Assessment

```yaml
excellent_ablation:
  - "All components ablated"
  - "Interactions studied"
  - "Clear conclusions about contribution"
  - "Statistical significance"

adequate_ablation:
  - "Main components ablated"
  - "Basic sensitivity analysis"
  - "Results interpretable"

weak_ablation:
  - "Few components tested"
  - "No sensitivity analysis"
  - "Unclear what matters"

no_ablation:
  - "Cannot determine component contributions"
  - "Major red flag"
```

---

## Assessment Templates

### Quick Assessment (5 min)

```markdown
## Quick Quality Check: {Paper Title}

### Red Flags Scan
- [ ] Data leakage suspected?
- [ ] Baselines fair and recent?
- [ ] Claims match evidence?
- [ ] Reproducibility info present?

### Quick Scores (1-5)
- Methodology: _/5
- Evidence: _/5
- Reproducibility: _/5

### Trust Level: {High / Moderate / Low / None}

### Quick Verdict: {Read deeper / Skim only / Skip}
```

### Detailed Assessment (30 min)

```markdown
## Detailed Quality Assessment: {Paper Title}

### 1. Methodology (Score: _/10)

**Strengths:**
- {Strength 1}
- {Strength 2}

**Concerns:**
- {Concern 1}
- {Concern 2}

**Red Flags:** {None / List}

---

### 2. Evidence Quality (Score: _/10)

**Datasets Used:**
| Dataset | Standard? | Results |
|---------|-----------|---------|
| {Name} | Yes/No | {Summary} |

**Baselines:**
| Baseline | Fair? | Up-to-date? |
|----------|-------|-------------|
| {Name} | Yes/No | Yes/No |

**Ablations:** {Comprehensive / Adequate / Limited / None}

**Statistical Rigor:** {Strong / Adequate / Weak}

---

### 3. Reproducibility (Score: _/10)

| Item | Status |
|------|--------|
| Code available | ✅/❌ |
| Data available | ✅/❌ |
| Hyperparameters listed | ✅/❌ |
| Environment specified | ✅/❌ |
| Can reproduce | ✅/⚠️/❌ |

---

### 4. Claim-Evidence Alignment (Score: _/10)

| Claim | Evidence | Strength |
|-------|----------|----------|
| {Claim 1} | {Evidence} | Strong/Moderate/Weak |
| {Claim 2} | {Evidence} | Strong/Moderate/Weak |

---

### 5. Overall Assessment

**Quality Score:** _/10

**Trust Level:** {High / Moderate / Low / None}

**Recommendation:** {Strongly trust / Use with caution / Verify first / Do not use}

**Key Concerns:**
1. {Top concern}
2. {Second concern}

**What would increase trust:**
- {Action 1}
- {Action 2}
```

---

## Common Quality Patterns by Venue

```yaml
top_venues: # NeurIPS, ICML, ICLR, ACL, CVPR
  expectation:
    - "Thorough experiments"
    - "Multiple datasets"
    - "Strong baselines"
    - "Ablations present"
  but_still_check:
    - "Reproducibility"
    - "Overclaiming"

arxiv_preprints:
  expectation:
    - "Variable quality"
    - "May be preliminary"
    - "Not peer-reviewed"
  must_verify:
    - "All claims independently"
    - "Baselines and comparisons"
    - "Reproducibility"

workshop_papers:
  expectation:
    - "Early/exploratory work"
    - "May have limited experiments"
  appropriate_trust:
    - "As ideas, not proven results"
```
