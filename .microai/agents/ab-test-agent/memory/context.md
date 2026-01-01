# AB Test Agent - Context

> Current session state và active experiments.

---

## Session State

```yaml
current_session:
  id: null
  started: null
  mode: null  # design | analysis | review | calculate
  active_experiment: null
```

---

## Active Experiments

| Experiment ID | Name | Status | Metric | Started | Notes |
|---------------|------|--------|--------|---------|-------|
| - | - | - | - | - | - |

---

## Recent Sessions

| Date | Mode | Experiment | Outcome |
|------|------|------------|---------|
| - | - | - | - |

---

## Quick Reference

### Last Design
```yaml
experiment: null
hypothesis: null
primary_metric: null
sample_size: null
```

### Last Analysis
```yaml
experiment: null
result: null
decision: null
```

---

*Updated: Never*
