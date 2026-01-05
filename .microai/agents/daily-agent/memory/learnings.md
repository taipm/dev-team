# Patterns & Learnings

> Knowledge accumulated from experience. Grouped by category.

---

## Task Execution Patterns

### Pattern: Batch Research Before Content

**Observation**: Content quality improves when research is done first

**Solution**: Always run research tasks before content creation tasks

**Example**:
```yaml
execution_order:
  1. research  # Gather information first
  2. content   # Create content with research insights
  3. post      # Publish prepared content
  4. report    # Summarize all activities
```

---

## Integration Patterns

### Pattern: Confirm Before Publish

**Observation**: Publishing without confirmation can cause issues

**Solution**: Always ask for user confirmation before:
- Posting to Facebook
- Sending emails (future)
- Publishing videos

**Example**:
```
Before posting, display preview and ask:
"Post this to Facebook? [y/n]"
```

---

## Error Recovery Patterns

### Pattern: Save Progress On Failure

**Observation**: Long-running batches may fail mid-execution

**Solution**: Save partial results immediately, log errors, continue with other tasks

**Example**:
```yaml
on_error:
  - save_partial_results: true
  - log_error: memory/errors.log
  - continue_next_task: true
```

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| Batch Research Before Content | Execution | Daily run |
| Confirm Before Publish | Safety | Any publish action |
| Save Progress On Failure | Error | All batch operations |
