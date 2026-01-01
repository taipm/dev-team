# Common Pitfalls in A/B Testing

> Những lỗi thường gặp và cách tránh để đảm bảo experiment results đáng tin cậy.

---

## 1. Design Phase Pitfalls

### P0: Underpowered Tests

**Problem:** Sample size quá nhỏ để detect effect size mong muốn.

```
Example:
- Baseline: 5%
- Expected lift: 10% relative (0.5% absolute)
- Actual sample: 1,000 per variant
- Required sample: 31,000 per variant

Result: 97% chance of missing true effect!
```

**Symptoms:**
- Inconclusive results
- Wide confidence intervals
- "No statistically significant difference"

**Prevention:**
```yaml
checklist:
  - [ ] Calculate sample size BEFORE running
  - [ ] Use realistic MDE (not "hoped for" effect)
  - [ ] Account for multiple variants
  - [ ] Build in buffer for drop-offs
```

### P0: No Pre-Registration

**Problem:** Decisions made after seeing data can be biased.

**Risks without pre-registration:**
```
- Change primary metric to one that "worked"
- Add segments until finding significant one
- Extend runtime until significant
- Rationalize any result
```

**Prevention:**
```markdown
## Pre-Registration Must Include:
1. Hypothesis
2. Primary metric (single OEC)
3. Sample size calculation
4. Analysis method
5. Stopping rules
6. Pre-defined segments
7. Decision criteria

Lock this document BEFORE experiment starts.
```

### P1: Wrong Randomization Unit

**Problem:** Randomization unit không phù hợp với use case.

**Examples:**
```
❌ Session-level randomization for personalization
   Problem: Same user sees different variants across sessions

❌ User-level for network effect features
   Problem: Users influence each other

❌ Page-level for checkout flow
   Problem: Inconsistent experience mid-flow
```

**Prevention:**
```yaml
guidelines:
  user_level:
    use_for: "Most UX experiments"
    ensures: "Consistent experience"

  session_level:
    use_for: "Anonymous users, content tests"
    caveat: "Higher variance"

  cluster_level:
    use_for: "Network effects, marketplace"
    method: "Randomize by region, team, etc."
```

### P1: Too Many Variants

**Problem:** Mỗi variant cần full sample size.

```
Sample size cho 2 variants: 30,000 total
Sample size cho 4 variants: 60,000 total
Sample size cho 8 variants: 120,000 total

Effect: 4x variants = 4x duration
```

**Prevention:**
```
- Limit to 2-4 variants
- Run sequential tests for exploration
- Use multi-armed bandit for optimization
- Consider fractional factorial designs
```

---

## 2. Execution Phase Pitfalls

### P0: Sample Ratio Mismatch (SRM)

**Problem:** Traffic split khác với expected.

**Detection:**
```
Expected: 50/50
Observed: 48/52 (with large sample)

Chi-square test p-value < 0.001 → SRM detected
```

**Common causes:**
| Cause | How to Debug |
|-------|--------------|
| Bot filtering | Check user agent distribution |
| Redirect issues | Check page load events |
| Browser caching | Check assignment consistency |
| JavaScript errors | Check error logs by variant |
| Race conditions | Check assignment timing |
| Exclusion logic bugs | Review targeting rules |

**Action when detected:**
```
1. STOP interpreting results
2. Debug the cause
3. Consider restarting experiment
4. If unclear, consult data science team
```

### P0: Peeking at Results

**Problem:** Checking p-values repeatedly inflates Type I error.

```
Traditional testing assumes ONE look at data.

Actual false positive rate with peeking:
Checks  | Actual α (nominal 5%)
--------|----------------------
1       | 5.0%
5       | 14.2%
10      | 19.3%
50      | 38.0%
```

**Prevention:**
```yaml
options:
  option_1: "Don't look until minimum runtime"
    pros: Simple, maintains α
    cons: Can't catch issues early

  option_2: "Use sequential testing"
    methods:
      - O'Brien-Fleming
      - Bayesian with expected loss
      - Always-valid inference
    pros: Can stop early correctly
    cons: More complex

  option_3: "Only look at validation metrics"
    look_at: [SRM, sample size, error rates]
    don't_look_at: [primary metric, p-values]
    pros: Catch issues without peeking
```

### P1: Novelty Effects

**Problem:** Initial spike/drop do người dùng phản ứng với thay đổi.

```
Example:
Week 1: +20% (users exploring new feature)
Week 2: +10% (novelty wearing off)
Week 3: +5% (true effect)
Week 4: +5% (stable)

If stopped at Week 1, would over-estimate effect by 4x!
```

**Detection:**
```
1. Plot metric by day/week
2. Look for trend (up or down)
3. Compare early vs late periods
4. Wait for stabilization
```

**Prevention:**
```yaml
guidelines:
  minimum_runtime:
    ux_changes: "14+ days"
    content_changes: "7+ days"
    backend_changes: "7+ days"

  check_for_novelty:
    - Plot daily/weekly trends
    - Compare first half vs second half
    - If trending, extend runtime
```

### P1: Primacy Effects

**Problem:** Existing users prefer familiar experience.

```
Example:
Returning users: -10% (don't like change)
New users: +15% (no baseline to compare)
Overall: +5% (masked by mix)

Long-term: Effect likely closer to new user result (+15%)
```

**Prevention:**
```
1. Segment by user tenure
2. Wait for new user cohort to mature
3. Consider different rollout for existing vs new
```

### P2: External Confounders

**Problem:** Factors ngoài experiment ảnh hưởng kết quả.

**Examples:**
```
- Holiday traffic (different behavior)
- Marketing campaign (different intent)
- Competitor actions (market shift)
- Product bugs (unrelated issues)
- Seasonal effects (weather, events)
```

**Prevention:**
```yaml
documentation:
  before_experiment:
    - Note planned campaigns
    - Check calendar for holidays
    - Document external factors

  during_experiment:
    - Log any anomalies
    - Track external events
    - Monitor for unexpected patterns

  analysis:
    - Control for known confounders
    - Note any external events
    - Consider in interpretation
```

---

## 3. Analysis Phase Pitfalls

### P0: P-Hacking

**Problem:** Tìm kiếm cho đến khi có kết quả significant.

**Forms of p-hacking:**
```
1. Try different metrics until one is significant
2. Try different segments until one works
3. Try different time periods
4. Add/remove outliers strategically
5. Change statistical test
6. Round p-values down
```

**Example:**
```
Tried 20 different segments:
- 19 not significant
- 1 significant (p = 0.04)

Expected by chance: 20 × 5% = 1 false positive
This is the "winner"!
```

**Prevention:**
```yaml
pre_registration:
  - Define primary metric before experiment
  - Define segments before experiment
  - Define analysis method before experiment
  - Apply multiple testing correction

transparency:
  - Report all analyses attempted
  - Report all metrics measured
  - Use correction for exploratory analysis
```

### P0: Ignoring Practical Significance

**Problem:** P-value nhỏ không có nghĩa effect lớn.

```
Example:
Sample: 10,000,000 per variant
Control: 5.000%
Treatment: 5.015%
Lift: +0.015% (0.3% relative)
P-value: 0.001 (highly significant!)

Practical impact: 1,500 extra conversions
Cost of change: $50,000 development
ROI: Negative!
```

**Prevention:**
```yaml
always_calculate:
  - Effect size (not just p-value)
  - Confidence interval
  - Business impact in dollars
  - Implementation cost
  - ROI analysis

decision_framework:
  statistically_significant: true
  practically_significant: "Is the effect worth the cost?"
  ship_decision: "Based on both"
```

### P1: Simpson's Paradox

**Problem:** Aggregate results hide segment-specific effects.

```
Classic Example:
         | Control      | Treatment
---------|--------------|------------
Mobile   | 3% (n=7000)  | 4% (n=3000)
Desktop  | 5% (n=3000)  | 6% (n=7000)
---------|--------------|------------
Overall  | 3.6%         | 5.4%

Treatment wins overall (+50%)
Treatment wins in each segment
BUT: Overall effect is inflated due to mix shift!

True effects:
- Mobile: +33%
- Desktop: +20%
- Overall (if same mix): ~+25%
```

**Prevention:**
```
1. Always check segment breakdown
2. Look for mix shifts between variants
3. Use stratified randomization
4. Report segment-level AND overall results
```

### P1: Survivorship Bias

**Problem:** Only analyzing users who completed the flow.

```
Example:
Analyzing "revenue per purchaser"
Control: $100, Treatment: $120 (+20%)

But:
Control purchasers: 1000
Treatment purchasers: 800

Control total revenue: $100,000
Treatment total revenue: $96,000 (-4%)

Treatment scared off buyers, remaining ones spend more!
```

**Prevention:**
```yaml
principle: "Intent to Treat"

analyze:
  - ALL users assigned to variant
  - Not just those who completed

metrics:
  good: "Revenue per visitor"
  bad: "Revenue per purchaser"

  good: "Conversion rate (all visitors)"
  bad: "Conversion rate (engaged visitors)"
```

### P2: Wrong Baseline

**Problem:** So sánh với baseline sai.

```
Example:
Pre-experiment conversion: 5%
Experiment baseline: 4% (due to seasonality)

Interpretation:
"Treatment at 5% is +25% lift!" ❌
"Treatment at 5% is back to normal" ✓
```

**Prevention:**
```
1. Use concurrent control group (not historical)
2. A/B test, not before/after comparison
3. Account for known seasonality
4. Check control matches expectations
```

---

## 4. Interpretation Pitfalls

### P0: "Almost Significant"

**Problem:** Treating p = 0.06 như gần như significant.

```
❌ "P-value is 0.06, so it's almost significant"
❌ "Trending towards significance"
❌ "Marginally significant"

Truth: Either significant or not.
P = 0.06 is NOT statistically significant at α = 0.05.
```

**Correct approaches:**
```yaml
option_1: "Accept null hypothesis"
  statement: "No significant effect detected"

option_2: "Discuss effect size"
  statement: "Effect estimate is X% (CI: Y% to Z%)"

option_3: "Consider more data"
  statement: "Underpowered, need N more samples"

option_4: "Use Bayesian"
  statement: "P(B > A) = 93%, expected loss = 0.1%"
```

### P1: Causal Over-Interpretation

**Problem:** Kết luận nhân quả từ correlation.

```
Experiment shows: Users who saw feature X have higher retention

Possible explanations:
1. Feature X improves retention (causal) ✓
2. Engaged users more likely to find feature X (selection)
3. Power users use feature X AND retain (confounder)
```

**Prevention:**
```
A/B testing establishes causation IF:
- Random assignment
- No SRM
- No peeking/p-hacking
- Single intervention

Correlation in observational data:
- Cannot establish causation
- Need controlled experiment
- Or sophisticated causal inference
```

### P1: Over-Generalizing

**Problem:** Áp dụng kết quả vượt quá scope của experiment.

```
Experiment:
- Tested on: English-speaking users in US
- Result: +10% conversion

Over-generalization:
- "Will work globally" ❌
- "Will work for all user segments" ❌
- "Will work for similar products" ❌
```

**Prevention:**
```yaml
state_explicitly:
  population: "Who was in the experiment"
  time_period: "When it ran"
  conditions: "What was controlled"

caveat_when_generalizing:
  - Different populations may respond differently
  - Effect may not persist long-term
  - Context matters
```

### P2: Winner's Curse

**Problem:** Observed effect size thường bị inflated.

```
True effect: 5%
Experiment result: 8% (significant)

Why:
- Only "won" because estimate was high
- True effect likely lower
- Called "regression to the mean"
```

**Mitigation:**
```
1. Use larger samples
2. Pre-register realistic MDE
3. Expect follow-up experiments to show smaller effects
4. Focus on lower bound of CI
```

---

## 5. Organizational Pitfalls

### P1: HiPPO Effect

**Problem:** Highest Paid Person's Opinion overrides data.

```
Data: Treatment has no significant effect
HiPPO: "I think it looks better, ship it"
Result: Ship based on opinion, not data
```

**Prevention:**
```yaml
culture:
  - Commit to data-driven decisions upfront
  - Pre-register decision criteria
  - Make experiment results visible
  - Celebrate learning (even negative results)

process:
  - Document decision rationale
  - Require sign-off on overrides
  - Track outcomes of overridden decisions
```

### P1: Not Learning from Negative Results

**Problem:** Chỉ công bố experiments "thành công".

```
Reality:
- Most experiments don't win
- ~70-80% are flat or negative
- All experiments generate learnings

Problem:
- Publishing only winners creates false narrative
- Repeating failed experiments
- Not understanding why things don't work
```

**Prevention:**
```yaml
document_all_experiments:
  - Negative results are valuable
  - Explain why it didn't work
  - Inform future experiments

share_learnings:
  - Regular experiment review meetings
  - Repository of past experiments
  - Searchable database
```

### P2: Experimentation Theater

**Problem:** Running experiments for optics, not learning.

```
Signs:
- Experiments never influence decisions
- Results ignored when inconvenient
- No follow-through on learnings
- "We experimented" as checkbox

Result: Waste of resources, false confidence
```

**Prevention:**
```
1. Tie experiments to decisions
2. Track action rate on results
3. Measure experiment ROI
4. Reward learning, not just winning
```

---

## 6. Quick Reference: Pitfall Checklist

### Before Running

```
[ ] Sample size calculated?
[ ] Pre-registration complete?
[ ] Randomization unit appropriate?
[ ] Reasonable number of variants?
[ ] External events documented?
```

### While Running

```
[ ] SRM checked daily?
[ ] Not peeking at primary metric?
[ ] Minimum runtime enforced?
[ ] External events logged?
[ ] Error rates monitored?
```

### During Analysis

```
[ ] Used pre-registered analysis plan?
[ ] Applied multiple testing correction?
[ ] Checked practical significance?
[ ] Analyzed pre-defined segments?
[ ] Checked for survivorship bias?
```

### When Interpreting

```
[ ] Avoiding "almost significant"?
[ ] Not over-generalizing?
[ ] Documented learnings?
[ ] Made decision based on data?
[ ] Shared results (positive or negative)?
```

---

*Awareness of pitfalls is the first step to avoiding them.*
