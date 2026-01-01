# Killer Questions Database

## Overview

Những câu hỏi cốt tử giúp đánh giá nhanh và chính xác giá trị thực sự của một paper. Mỗi câu hỏi được thiết kế để phơi bày điều mà paper có thể cố tình hoặc vô tình che giấu.

---

## Category 1: Contribution Assessment

### Câu hỏi cốt lõi

```yaml
novelty_questions:
  - question: "What is genuinely NEW vs incremental improvement?"
    purpose: "Phân biệt innovation thực sự vs optimization nhỏ"
    red_flags:
      - "Improvement chỉ 1-2% trên benchmark"
      - "Kết hợp techniques đã biết mà không có insight mới"
      - "Chỉ thay đổi hyperparameters hoặc architecture details"
    green_flags:
      - "Đề xuất problem formulation mới"
      - "Phương pháp có thể generalize sang nhiều domains"
      - "Opens new research direction"

  - question: "Would the field be meaningfully different if this paper didn't exist?"
    purpose: "Đánh giá impact thực sự"
    scoring:
      high: "Enables new capabilities hoặc changes best practices"
      medium: "Provides useful insights hoặc moderate improvements"
      low: "Could be independently discovered easily"

  - question: "In 5 years, will this be cited for its method or just as a baseline?"
    purpose: "Dự đoán lasting impact"
    signals_method_citation:
      - "Novel architecture component"
      - "New training technique"
      - "Theoretical contribution"
    signals_baseline_only:
      - "SOTA on specific benchmark"
      - "Engineering optimizations"
      - "Dataset-specific insights"
```

### Classification Framework

| Type | Description | Example | Impact |
|------|-------------|---------|--------|
| **Paradigm Shift** | Thay đổi cách nghĩ về problem | Transformers, GANs | Revolutionary |
| **Methodology** | Kỹ thuật mới reusable | Dropout, BatchNorm | High |
| **Application** | Áp dụng known methods vào domain mới | BERT for legal text | Medium |
| **Optimization** | Cải thiện existing approaches | Faster training tricks | Low-Medium |
| **Benchmark** | SOTA trên metrics cụ thể | New ImageNet record | Low |

---

## Category 2: Technical Validity

### Evidence Quality Questions

```yaml
experimental_validity:
  - question: "What's the weakest link in their proof/experiment?"
    checklist:
      - "Có ablation study không?"
      - "Baselines có fair và up-to-date không?"
      - "Statistical significance được report không?"
      - "Error bars / confidence intervals?"
      - "Multiple runs với different seeds?"

  - question: "What's their most questionable assumption?"
    common_issues:
      - "i.i.d. assumption khi data không i.i.d."
      - "Assumption về distribution của data"
      - "Assumption về availability của resources"
      - "Implicit assumptions trong preprocessing"

  - question: "What experiment could DISPROVE their main claim?"
    purpose: "Tìm falsifiability"
    example: |
      Claim: "Method X generalizes to all domains"
      Disproof experiment: "Test on adversarial domain shift"
```

### Red Flags Checklist

```yaml
methodology_red_flags:
  severe:
    - "Không có ablation studies"
    - "Chỉ test trên 1 dataset"
    - "Baselines outdated > 2 years"
    - "Không report variance / error bars"
    - "Cherry-picking metrics"

  moderate:
    - "Limited hyperparameter sensitivity analysis"
    - "Missing important baseline"
    - "Evaluation metrics không standard"
    - "Small test set"

  minor:
    - "Missing some ablations"
    - "Could use more datasets"
    - "Presentation issues"
```

---

## Category 3: Practical Impact

### Actionability Questions

```yaml
immediate_use:
  - question: "Can I use this tomorrow? What would I need?"
    assessment_criteria:
      - code_availability: "GitHub repo với documentation?"
      - dependencies: "Standard libraries hay custom?"
      - compute_requirements: "Chạy được trên available hardware?"
      - data_requirements: "Cần data gì? Available không?"
      - integration_effort: "Bao nhiêu engineering work?"

  - question: "What's the minimum compute/data to reproduce core result?"
    thresholds:
      accessible: "1 GPU, public data, <1 day training"
      moderate: "4-8 GPUs, moderate data, <1 week"
      expensive: "Cluster, large proprietary data, weeks+"
      prohibitive: "Massive resources, not practical"

  - question: "Who would ACTUALLY adopt this and why?"
    adoption_barriers:
      - "Switching cost from current solution"
      - "Risk of new approach"
      - "Integration complexity"
      - "Maintenance burden"
      - "Interpretability requirements"
```

### Deployment Readiness

```yaml
production_checklist:
  must_have:
    - "Inference latency acceptable?"
    - "Memory footprint reasonable?"
    - "Edge cases handled?"
    - "Error handling robust?"

  should_have:
    - "Monitoring/logging built-in?"
    - "Graceful degradation?"
    - "Version compatibility?"

  nice_to_have:
    - "Easy to update/retrain?"
    - "Interpretable outputs?"
    - "A/B testing friendly?"
```

---

## Category 4: Hidden Gems

### Appendix Mining

```yaml
appendix_questions:
  - question: "What insight is buried in the appendix?"
    where_to_look:
      - "Appendix experiments"
      - "Ablation studies"
      - "Failure case analysis"
      - "Hyperparameter tables"
      - "Extended related work"

  - question: "What did they try that didn't work?"
    value: |
      Failed experiments often contain valuable insights:
      - Why approach A didn't work
      - Unexpected behaviors discovered
      - Dead ends to avoid

  - question: "What's the real contribution beyond what the title claims?"
    patterns:
      - "Title focuses on application, but method is generalizable"
      - "Main paper discusses X, but technique Y is more interesting"
      - "Claimed contribution is minor, but side finding is significant"
```

### Unexpected Value Sources

```yaml
hidden_value_locations:
  methodology_details:
    - "Training tricks mentioned in passing"
    - "Data preprocessing insights"
    - "Architecture choices with brief justification"

  failure_analysis:
    - "When method breaks down"
    - "Edge cases discovered"
    - "Limitations acknowledged honestly"

  future_work:
    - "What authors think is next"
    - "Open problems identified"
    - "Research directions hinted"

  related_work:
    - "Unusual connections to other fields"
    - "Historical context"
    - "Alternative approaches reviewed"
```

---

## Category 5: Research Direction

### Follow-up Questions

```yaml
next_steps:
  - question: "What's the obvious next paper from this?"
    directions:
      - "Scale up the approach"
      - "Apply to new domain"
      - "Remove key limitation"
      - "Combine with method X"
      - "Theoretical understanding"

  - question: "What combination of this + X would be powerful?"
    combination_patterns:
      - "Method A efficiency + Method B quality"
      - "Technique from domain X + problem from domain Y"
      - "This paper's insight + different architecture"

  - question: "What assumption, if lifted, would 10x the impact?"
    common_assumptions_to_lift:
      - "Requires large labeled data"
      - "Assumes specific data format"
      - "Needs expensive compute"
      - "Limited to single language/domain"

  - question: "What application domain is unexplored?"
    exploration_framework:
      - "Where is similar problem structure?"
      - "What domains have this data type?"
      - "Who else could benefit?"
```

---

## Category 6: Meta-Questions

### Paper Quality Signals

```yaml
quality_indicators:
  strong_paper_signals:
    - "Clear problem statement"
    - "Honest limitations section"
    - "Comprehensive ablations"
    - "Fair baselines"
    - "Reproducibility focus"
    - "Open source code"

  weak_paper_signals:
    - "Overclaiming in abstract"
    - "Missing error bars"
    - "Cherry-picked metrics"
    - "Outdated references"
    - "No reproducibility info"
    - "Vague methodology"
```

### Author Credibility

```yaml
author_assessment:
  positive_signals:
    - "Track record in this area"
    - "Previous work is well-cited"
    - "Known for rigorous research"
    - "Institutional backing"

  neutral_signals:
    - "New to this area (but skilled elsewhere)"
    - "From industry (different standards)"
    - "Large author list"

  investigate_further:
    - "No prior publications"
    - "Previous work controversial"
    - "Conflict of interest possible"
```

---

## Quick Assessment Protocol

### 5-Minute Assessment

```yaml
rapid_evaluation:
  minute_1:
    - "Read title and abstract"
    - "Note main claim"

  minute_2:
    - "Check figures and tables"
    - "Look at main results"

  minute_3:
    - "Scan methodology section headers"
    - "Check baselines used"

  minute_4:
    - "Read limitations/conclusion"
    - "Check reproducibility info"

  minute_5:
    - "Answer: NEW or INCREMENTAL?"
    - "Answer: Can I use this?"
    - "Answer: Worth deep dive?"
```

### Deep Assessment (30 min)

```yaml
thorough_evaluation:
  phase_1_understand: # 10 min
    - "Read fully, take notes"
    - "Mark unclear sections"

  phase_2_question: # 10 min
    - "Apply killer questions"
    - "Identify weaknesses"
    - "Note strengths"

  phase_3_assess: # 10 min
    - "Fill out assessment template"
    - "Decide: use/cite/ignore"
    - "Note follow-up actions"
```

---

## Assessment Template

```markdown
## Paper: {Title}

### Killer Questions Summary

| Question | Answer | Confidence |
|----------|--------|------------|
| Genuinely new? | {Yes/Partial/No} | {High/Medium/Low} |
| Would field differ without it? | {Yes/Maybe/No} | {H/M/L} |
| Method or baseline citation? | {Method/Baseline/Neither} | {H/M/L} |
| Weakest experimental link? | {Description} | {H/M/L} |
| Questionable assumption? | {Description} | {H/M/L} |
| Can use tomorrow? | {Yes/With effort/No} | {H/M/L} |
| Who would adopt? | {Description} | {H/M/L} |
| Hidden gem? | {Description or N/A} | {H/M/L} |
| Obvious next paper? | {Description} | {H/M/L} |

### Verdict
- **Novelty**: {High/Medium/Low}
- **Validity**: {Strong/Adequate/Weak}
- **Actionability**: {Immediate/Moderate/Research-only}
- **Overall**: {Must-read/Worth-reading/Skip}

### Action Items
- [ ] {Specific action to take}
```
