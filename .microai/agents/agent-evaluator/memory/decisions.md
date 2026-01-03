# Agent Evaluator - Decisions Log

> Record of scoring decisions and rationale.

---

## Scoring Decisions

### Template

```yaml
decision:
  date: YYYY-MM-DD
  agent: agent-name
  dimension: dimension-name
  score_given: X/Y
  rationale: |
    Why this score was given
  evidence:
    - Evidence 1
    - Evidence 2
  alternatives_considered:
    - Alternative scoring with reason rejected
```

---

## Recent Decisions

*No decisions recorded yet*

---

## Scoring Precedents

### Edge Cases

| Case | Decision | Rationale |
|------|----------|-----------|
| Missing memory/ but has context.md in root | -1 point only | Partial compliance |
| No code examples but has diagrams | Accept as examples | Visual learning counts |
| Knowledge files >300 lines | Warning, not penalty | Quality over quantity |

### Interpretation Guidelines

1. **Ambiguous requirements** → Ask user, don't assume
2. **Partial compliance** → Give proportional points
3. **Extra features** → Don't penalize, but don't bonus either
4. **First-time agents** → Note learning curve, fair scoring

---

*Last updated: Never*
