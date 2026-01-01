# Paper Analysis Card Template

## Usage

Dùng template này để tạo analysis card cho mỗi paper. Fill in các placeholders và xóa instructions.

---

```markdown
# Paper Analysis Card: {Paper Title}

## Quick Stats

| Field | Value |
|-------|-------|
| **arXiv ID** | {2312.xxxxx} |
| **Authors** | {First Author} et al. ({N} authors) |
| **Institution** | {Primary affiliation} |
| **Date** | {YYYY-MM-DD} |
| **Categories** | {cs.AI, cs.LG, ...} |
| **Relevance Score** | {score}/100 |
| **Read Priority** | {Must-read / Should-read / Optional} |
| **Code** | {GitHub link or N/A} |
| **Data** | {Dataset links or N/A} |

---

## Feynman Summary (3 sentences)

**Sentence 1 (Problem):**
{Problem in everyday terms that anyone can understand}

**Sentence 2 (Solution):**
{Key insight/approach in simple analogy}

**Sentence 3 (Impact):**
{Why this matters and what changes}

---

## What's Actually New (First Principles)

### Genuine Contributions
1. **{Contribution 1}**
   - Novel because: {why this is new}
   - Evidence: {where demonstrated}

2. **{Contribution 2}**
   - Novel because: {why}
   - Evidence: {where}

### Building on Existing Work
- Extends: {Previous work}
- Borrows: {Techniques from X}
- Combines: {Ideas A and B}

### Key Assumptions

| Assumption | Type | Risk Level | Challenge |
|------------|------|------------|-----------|
| {Assumption 1} | Fundamental / Convention | Low/Med/High | {If false, then...} |
| {Assumption 2} | ... | ... | ... |

---

## 5 Whys Analysis

1. **Why this problem?**
   → {Answer}

2. **Why wasn't it solved before?**
   → {Answer}

3. **Why this approach?**
   → {Answer}

4. **Why does it work?**
   → {Answer}

5. **Why does it matter?**
   → {Answer}

**Root Insight:** {One-sentence distillation of the core value}

---

## 6W2H Coverage

| Dimension | Answer |
|-----------|--------|
| **What** | {What paper does, outputs, artifacts} |
| **Why** | {Motivation, gap filled} |
| **Who** | {Target users, beneficiaries} |
| **Where** | {Domain, applicable contexts} |
| **When** | {Timing significance, builds on recent X} |
| **Which** | {Choices made, alternatives rejected} |
| **How** | {Methodology summary} |
| **How much** | {Improvements, costs, requirements} |

---

## Critical Assessment

### Strengths

1. **{Strength 1}**
   - Evidence: {Quote or result}
   - Significance: {Why this matters}

2. **{Strength 2}**
   - Evidence: ...
   - Significance: ...

3. **{Strength 3}**
   - Evidence: ...
   - Significance: ...

### Weaknesses (Devil's Advocate)

1. **{Weakness 1}** 🔴/🟠/🟡
   - Concern: {Specific issue}
   - Evidence: {What raises this concern}
   - Impact if true: {Consequences}
   - Verification: {How to check}

2. **{Weakness 2}** {Severity}
   - Concern: ...
   - Evidence: ...
   - Impact: ...
   - Verification: ...

### Pre-mortem: Why This Might Fail

| Failure Mode | Probability | Impact | Early Warning |
|--------------|-------------|--------|---------------|
| {Mode 1} | Low/Med/High | Low/Med/High | {Signal to watch} |
| {Mode 2} | ... | ... | ... |

---

## Killer Questions Answered

### Is it genuinely new?
**Verdict:** {Yes / Partially / No}
**Reasoning:** {Explanation with evidence}

### What's the weakest point?
**Answer:** {Specific weakness}
**Why:** {Explanation}

### Can I use it tomorrow?
**Verdict:** {Yes / With effort / No}
**What's needed:**
- {Requirement 1}
- {Requirement 2}

### Hidden gems?
**Found:** {Insight from appendix/ablation/etc.}
**Location:** {Section or page}
**Value:** {Why this is interesting}

### What's next?
**Obvious follow-up:** {Next paper idea}
**Combination opportunity:** {This + X = Y}

---

## Quality Assessment

| Dimension | Score | Notes |
|-----------|-------|-------|
| Methodology | {1-10} | {Brief note} |
| Evidence | {1-10} | {Brief note} |
| Reproducibility | {1-10} | {Brief note} |
| Claim-Evidence Alignment | {1-10} | {Brief note} |
| **Overall** | **{1-10}** | |

**Trust Level:** {High / Moderate / Low}

---

## Actionable Takeaways

### Use Tomorrow
- [ ] {Specific technique or insight to apply}
- [ ] {Code snippet or approach to try}

### Follow-up Reading
- {Related Paper 1} - {Why relevant}
- {Related Paper 2} - {Why relevant}

### Research Ideas Spawned
- {Idea 1}
- {Idea 2}

### Resources
- **Code:** {GitHub URL or N/A}
- **Data:** {Dataset URL or N/A}
- **Demo:** {Demo URL or N/A}
- **Blog:** {Author blog post or N/A}

---

## Connection to My Research

**Tracked Interests Match:** {List matching interests}

**How it connects:**
{Specific connection to your work}

**Potential application:**
{How you could use this}

---

## BibTeX

```bibtex
@article{{author{year}{keyword},
  title={{{Paper Title}}},
  author={{{Authors}}},
  journal={{arXiv preprint arXiv:{ID}}},
  year={{{Year}}}
}}
```

---

*Analysis by Deep Research Agent*
*Frameworks: First Principles, 5 Whys, 6W2H, Feynman, Pre-mortem, Devil's Advocate*
*Generated: {YYYY-MM-DD HH:MM}*
```
