# Learning Patterns

> Continuous learning system cho Taipm Agent.
> Improve routing accuracy và user satisfaction over time.

---

## Learning Framework

```
OBSERVE → PATTERN → VALIDATE → APPLY → MEASURE
    │         │          │         │        │
    │         │          │         │        └─→ Track metrics
    │         │          │         └─→ Update routing rules
    │         │          └─→ Confirm with user (if needed)
    │         └─→ Identify patterns from data
    └─→ Collect interaction data
```

---

## What We Learn

### 1. Routing Patterns

**Data collected:**
```yaml
routing_event:
  timestamp: {datetime}
  input: "{user input}"
  detected_intent: "{intent}"
  routed_to: "{agent/team}"
  confidence: {0-100}
  outcome: success | partial | failed | redirected
  user_feedback: positive | neutral | negative | none
  correction: "{if user corrected routing}"
```

**Patterns detected:**
- Which intents consistently route to which agents
- Ambiguous intents that need clarification
- User corrections that indicate routing errors
- Time-of-day patterns (certain tasks at certain times)

### 2. User Behavior Patterns

**Data collected:**
```yaml
session_event:
  timestamp: {datetime}
  duration: {minutes}
  tasks_completed: {count}
  agents_used: ["{list}"]
  satisfaction_signals: ["{signals}"]
```

**Patterns detected:**
- Preferred working hours
- Session length preferences
- Agent preferences by task type
- Context switching patterns

### 3. Preference Evolution

**Data collected:**
```yaml
preference_event:
  timestamp: {datetime}
  type: explicit | inferred
  category: "{preference category}"
  old_value: "{previous}"
  new_value: "{new}"
  trigger: "{what caused the change}"
```

**Patterns detected:**
- Evolving communication style
- Changing domain focus
- Proactivity tolerance changes

---

## Learning Algorithms

### Routing Confidence Adjustment

```python
# Pseudo-algorithm for confidence adjustment

def adjust_confidence(pattern, outcome, feedback):
    if outcome == "success" and feedback in ["positive", "none"]:
        pattern.confidence += 5  # Strengthen
        pattern.success_count += 1

    elif outcome == "failed" or feedback == "negative":
        pattern.confidence -= 10  # Weaken
        pattern.failure_count += 1

    elif outcome == "redirected":
        pattern.confidence -= 15  # Significant error
        learn_from_correction(pattern)

    # Cap confidence
    pattern.confidence = max(0, min(100, pattern.confidence))

    # Mark for review if unstable
    if pattern.confidence < 50:
        flag_for_review(pattern)
```

### Pattern Detection

```python
# Pseudo-algorithm for pattern detection

def detect_patterns(events, min_occurrences=3):
    patterns = {}

    for event in events:
        key = extract_pattern_key(event)
        patterns[key] = patterns.get(key, [])
        patterns[key].append(event)

    confirmed_patterns = []
    for key, occurrences in patterns.items():
        if len(occurrences) >= min_occurrences:
            if is_consistent(occurrences):
                confirmed_patterns.append({
                    'pattern': key,
                    'confidence': calculate_confidence(occurrences),
                    'suggested_action': derive_action(occurrences)
                })

    return confirmed_patterns
```

---

## Pattern Categories

### High-Confidence Patterns (Auto-Apply)

Patterns with >90% success rate over 10+ occurrences:

```yaml
auto_apply_patterns:
  - pattern: "URL + audiobook"
    route: audiobook-production-team
    confidence: 98
    occurrences: 25
    success_rate: 100%

  - pattern: "Go + review"
    route: go-review-linus-agent
    confidence: 95
    occurrences: 15
    success_rate: 93%
```

### Medium-Confidence Patterns (Suggest)

Patterns with 70-90% success rate:

```yaml
suggest_patterns:
  - pattern: "URL + video"
    route: youtube-team
    confidence: 82
    occurrences: 8
    success_rate: 75%
    note: "Sometimes user wants audiobook, clarify if ambiguous"
```

### Low-Confidence Patterns (Clarify)

Patterns with <70% success rate:

```yaml
clarify_patterns:
  - pattern: "review" (alone)
    possible_routes: [go-review, deep-thinking, dev-qa]
    note: "Always ask for domain context"
```

---

## Learning Triggers

### Immediate Learning

Apply immediately when:
- User explicitly corrects routing
- User states preference
- Task fails due to wrong routing

```yaml
immediate_learning:
  trigger: "User correction"
  action: |
    1. Update routing rule
    2. Decrease confidence of wrong pattern
    3. Increase confidence of correct pattern
    4. Log for review
```

### Batch Learning

Process periodically (daily):
- Analyze day's interactions
- Detect new patterns
- Calculate updated confidences
- Generate learning report

```yaml
batch_learning:
  schedule: "daily at 23:00"
  action: |
    1. Aggregate day's events
    2. Run pattern detection
    3. Calculate metrics
    4. Update routing rules
    5. Generate insights
    6. Save to learning.md
```

### Threshold Learning

Trigger when thresholds crossed:
- Pattern reaches N occurrences
- Success rate drops below X%
- New pattern emerges

---

## Learning Storage

### memory/learning.md Structure

```markdown
# Learning Log

## Confirmed Patterns
| Pattern | Route | Confidence | Last Updated |
|---------|-------|------------|--------------|
| URL + audio | audiobook-team | 98 | 2026-01-04 |

## Pending Validation
| Pattern | Suggested Route | Occurrences | Awaiting |
|---------|-----------------|-------------|----------|
| idea + FB | fb-post-agent | 2 | 1 more occurrence |

## Recent Corrections
| Date | Input | Wrong Route | Correct Route | Learning |
|------|-------|-------------|---------------|----------|

## Metrics (Last 7 Days)
| Metric | Value | Trend |
|--------|-------|-------|
| Routing Accuracy | 92% | ↑ |
| User Corrections | 3 | ↓ |
| New Patterns | 2 | - |
```

---

## Feedback Collection

### Implicit Feedback

Signals that indicate satisfaction/dissatisfaction:

```yaml
positive_signals:
  - Task completed without correction
  - User continues with same agent
  - User says "thanks", "good", "hay"
  - Session continues productively

negative_signals:
  - User redirects mid-task
  - User says "không phải", "sai rồi"
  - User re-asks with different phrasing
  - Task abandoned
```

### Explicit Feedback

Direct feedback collection:

```yaml
explicit_feedback:
  when: "After significant task completion"
  question: "Routing có đúng không? (y/n/feedback)"
  frequency: "Not every task, avoid fatigue"
```

---

## Anti-Patterns (Avoid)

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Over-learning | Change too fast | Require min occurrences |
| Confirmation bias | Only remember successes | Track failures equally |
| Stale patterns | Old patterns not updated | Decay old data |
| Over-fitting | Too specific patterns | Generalize patterns |

---

## Learning Metrics Dashboard

```yaml
metrics:
  routing:
    accuracy_7d: 92%
    accuracy_30d: 89%
    corrections_7d: 3
    new_patterns_7d: 2

  user_satisfaction:
    positive_signals: 45
    negative_signals: 5
    explicit_feedback_score: 4.2/5

  system_health:
    patterns_total: 35
    patterns_high_confidence: 20
    patterns_needs_review: 5
```

---

*Learning system maintained by Taipm Agent. Auto-updated daily.*
