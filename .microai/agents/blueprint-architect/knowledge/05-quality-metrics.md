# Quality Metrics

> Track and improve blueprint quality over time

---

## Metrics to Track

### 1. Spec Completeness Score

| Component | Weight | Criteria |
|-----------|--------|----------|
| Signatures | 20% | All functions have typed signatures |
| Preconditions | 20% | All functions have pre-conditions |
| Postconditions | 20% | Success AND failure cases defined |
| Invariants | 10% | Security/data invariants stated |
| Dependencies | 15% | Graph complete with order |
| Warnings | 10% | Abstraction leaks identified |
| Questions | 5% | Open questions listed |

**Calculation:**
```
Score = Σ (component_weight × component_score)
Target: >= 85%
```

### 2. Preview Acceptance Rate

How often users accept preview without changes.

```
Acceptance Rate = (accepted_previews / total_previews) × 100
Target: >= 80%
```

**Low Rate Indicates:**
- Not understanding user intent well
- Missing important functions in preview
- Overcomplicated initial design

### 3. Handoff Success Rate

How often coding agent implements without clarification.

```
Success Rate = (clean_handoffs / total_handoffs) × 100
Target: >= 90%
```

**Low Rate Indicates:**
- Ambiguous specs
- Missing edge cases
- Unclear contracts

### 4. Section Efficiency

How often 4 core sections suffice (vs needing optional).

```
Efficiency = (core_only_blueprints / total_blueprints) × 100
Target: >= 70%
```

**Low Rate Indicates:**
- Over-engineering simple problems
- Adding unnecessary complexity

---

## Quality Scoring Template

After each blueprint, log to `memory/metrics.md`:

```markdown
## Blueprint: {name}
Date: {YYYY-MM-DD}

### Completeness Score
| Component | Score | Notes |
|-----------|-------|-------|
| Signatures | ✓/✗ | |
| Preconditions | ✓/✗ | |
| Postconditions | ✓/✗ | |
| Invariants | ✓/✗ | |
| Dependencies | ✓/✗ | |
| Warnings | ✓/✗ | |
| Questions | ✓/✗ | |
| **Total** | {score}% | |

### Workflow Metrics
- Preview iterations: {count}
- Sections used: {core/optional}
- Handoff target: {agent}

### Feedback Received
{Any feedback from coding agent}
```

---

## Continuous Improvement

### Weekly Review

```
1. Calculate average completeness score
2. Identify lowest-scoring components
3. Review failed handoffs for patterns
4. Update knowledge base with new patterns
```

### Pattern Learning

When a design pattern works well, add to `memory/patterns.md`:

```markdown
## Pattern: {name}
Domain: {auth/data/file/etc}
Problem: {what it solves}
Solution:
  - Function: {signature}
  - Contract: {key contract points}
Success Criteria: {how to know it worked}
Reuse Count: {times used}
```

---

## Quality Gates

### Before Preview

```
□ Intent understood (ask if unclear)
□ Domain identified
□ Complexity estimated
□ Functions outlined (3+ for complex)
```

### Before Full Blueprint

```
□ Preview approved by user
□ All functions have signatures
□ Contracts are complete
□ Dependencies mapped
```

### Before Handoff

```
□ Target agent identified
□ Framework mappings provided
□ Open questions listed
□ File saved to output/blueprints/
```

---

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Over-specification | Too much detail, no flexibility | Use "implementation freedom zones" |
| Under-specification | Missing edge cases | Use contract checklist |
| Gold-plating | 8 sections when 4 suffice | Ask: "Is this needed?" |
| Assumption creep | Assuming without noting | Always mark assumptions |
| Stale preview | Generating full without approval | Always show preview first |

---

## Metrics Dashboard Template

For `memory/metrics.md`:

```markdown
# Blueprint Architect Metrics

## Summary (Last 30 days)
- Blueprints created: {count}
- Avg completeness: {score}%
- Preview acceptance: {rate}%
- Handoff success: {rate}%
- Section efficiency: {rate}%

## Recent Blueprints
| Date | Project | Score | Handoff | Feedback |
|------|---------|-------|---------|----------|
| {date} | {name} | {score}% | {agent} | {notes} |

## Improvement Areas
1. {area needing improvement}
2. {area needing improvement}

## Patterns Learned
- {new pattern discovered}
```
