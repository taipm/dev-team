# Safety Protocols

> Bảo vệ hệ thống khỏi bad mutations và đảm bảo recovery.

---

## Core Safety Rules

### Rule 1: Version Retention

```yaml
retention:
  min_versions: 5          # Always keep at least 5 versions
  elite_protection: true   # Never delete best-performing version
  archive_policy: "memory/archive/"  # Archive instead of hard delete
```

**Implementation**:
```python
def prune_versions(versions, keep=5):
    """Keep last N versions, protect elite."""

    # Sort by creation time (newest first)
    sorted_versions = sorted(versions, key=lambda v: v.created, reverse=True)

    # Find elite (best score ever)
    elite = max(versions, key=lambda v: v.score)

    # Keep recent + elite
    to_keep = set(sorted_versions[:keep])
    to_keep.add(elite)

    # Archive the rest
    for v in versions:
        if v not in to_keep:
            archive_version(v)

    return list(to_keep)
```

---

### Rule 2: Auto-Rollback Triggers

| Trigger | Condition | Action |
|---------|-----------|--------|
| Consecutive Failures | 2+ score drops in a row | Rollback to best |
| Severe Drop | Score drops >30% from best | Rollback to best |
| High Error Rate | Error rate >50% | Rollback to previous |
| User Override | User explicitly reverts | Rollback to specified |

**Implementation**:
```python
ROLLBACK_TRIGGERS = [
    {
        'name': 'consecutive_failures',
        'condition': lambda state: state.consecutive_failures >= 2,
        'action': 'rollback_to_best',
        'reason': 'Two or more consecutive score drops'
    },
    {
        'name': 'severe_drop',
        'condition': lambda state: state.current_score < state.best_score * 0.7,
        'action': 'rollback_to_best',
        'reason': 'Score dropped more than 30% from best'
    },
    {
        'name': 'high_error_rate',
        'condition': lambda state: state.error_rate > 0.5,
        'action': 'rollback_to_previous',
        'reason': 'Error rate exceeded 50%'
    }
]

def check_rollback_triggers(state):
    """Check if any rollback trigger is activated."""
    for trigger in ROLLBACK_TRIGGERS:
        if trigger['condition'](state):
            return trigger
    return None
```

---

### Rule 3: Mutation Limits

```yaml
mutation_limits:
  max_mutations_per_day: 10        # Prevent runaway evolution
  min_executions_between: 3        # Allow time to evaluate
  cooldown_after_rollback: 5       # Extra caution after rollback
  high_risk_daily_limit: 2         # Limit dangerous mutations
```

**High-risk strategies** (limited):
- `constraint_remove`
- `step_reorder` with major changes

---

### Rule 4: Stability Detection

Không mutate khi system đang stable:

```python
def is_stable(recent_scores, threshold=3):
    """Check if system is stable (no need to mutate)."""

    if len(recent_scores) < threshold:
        return False

    # Check if scores are consistently high
    avg = sum(recent_scores) / len(recent_scores)
    variance = sum((s - avg) ** 2 for s in recent_scores) / len(recent_scores)

    # Stable if high score and low variance
    return avg > 85 and variance < 5
```

---

## Rollback Procedures

### Rollback to Best

```python
def rollback_to_best():
    """Rollback to best-performing version."""

    # Find best version
    best = get_best_version()

    # Activate it
    set_current_version(best)

    # Reset failure counter
    reset_consecutive_failures()

    # Log
    log_rollback({
        'from': current_version,
        'to': best,
        'reason': 'consecutive_failures',
        'timestamp': now()
    })

    # Notify
    return f"Rolled back to {best.name} (score: {best.score})"
```

### Rollback to Previous

```python
def rollback_to_previous():
    """Rollback to immediately previous version."""

    previous = get_previous_version()

    if previous.score < current_version.score * 0.8:
        # Previous is also bad, go to best instead
        return rollback_to_best()

    set_current_version(previous)
    reset_consecutive_failures()

    log_rollback({
        'from': current_version,
        'to': previous,
        'reason': 'high_error_rate',
        'timestamp': now()
    })

    return f"Rolled back to {previous.name}"
```

---

## Recovery Protocol

Sau khi rollback:

```yaml
recovery_protocol:
  step_1: "Activate best/previous version"
  step_2: "Reset consecutive_failures to 0"
  step_3: "Set cooldown period (5 executions)"
  step_4: "Log rollback event with full context"
  step_5: "Notify user of rollback"
  step_6: "Analyze failed mutation for learning"
  step_7: "Reduce weight of failed strategy"
```

---

## Mutation Validation

Before applying mutation:

```python
def validate_mutation(original, mutated):
    """Validate mutation before applying."""

    checks = {
        'not_empty': len(mutated.strip()) > 0,
        'not_too_short': len(mutated) > len(original) * 0.5,
        'not_too_long': len(mutated) < len(original) * 2.0,
        'has_structure': has_required_sections(mutated),
        'no_dangerous_patterns': not has_dangerous_patterns(mutated)
    }

    failed = [k for k, v in checks.items() if not v]

    if failed:
        raise MutationValidationError(f"Validation failed: {failed}")

    return True

def has_dangerous_patterns(prompt):
    """Check for patterns that could cause issues."""

    dangerous = [
        r'rm\s+-rf',           # Dangerous bash
        r'DROP\s+TABLE',       # SQL injection
        r'ignore\s+all\s+rules',  # Jailbreak
        r'NEVER\s+follow',     # Anti-instruction
    ]

    for pattern in dangerous:
        if re.search(pattern, prompt, re.IGNORECASE):
            return True

    return False
```

---

## Logging Requirements

Every safety event must be logged:

```yaml
# memory/safety-log.yaml
events:
  - timestamp: "2026-01-04T12:00:00Z"
    type: "rollback"
    trigger: "consecutive_failures"
    from_version: "v005"
    to_version: "v003"
    reason: "2 consecutive score drops"
    context:
      scores: [72.5, 68.3, 65.1]
      strategy_that_failed: "constraint_remove"

  - timestamp: "2026-01-04T13:00:00Z"
    type: "mutation_blocked"
    reason: "daily_limit_reached"
    attempted_strategy: "constraint_remove"
    context:
      high_risk_today: 2
      limit: 2
```

---

## Emergency Commands

| Command | Effect |
|---------|--------|
| `*freeze` | Stop all evolution, use current version |
| `*rollback v001` | Rollback to specific version |
| `*reset` | Reset to base version (v001) |
| `*disable-evolution` | Disable evolution permanently |

---

## Health Checks

Periodic health checks:

```python
def health_check():
    """Run periodic health check."""

    issues = []

    # Check version count
    if len(versions) < 3:
        issues.append("Low version count - evolution history limited")

    # Check elite exists
    if not has_elite():
        issues.append("No elite version designated")

    # Check score trend
    trend = calculate_trend(recent_scores)
    if trend < -5:
        issues.append(f"Negative score trend: {trend}")

    # Check mutation frequency
    if mutations_today > 8:
        issues.append(f"High mutation frequency: {mutations_today}")

    return issues
```

---

*Safety protocols maintained by SEPA. Updated based on incident analysis.*
