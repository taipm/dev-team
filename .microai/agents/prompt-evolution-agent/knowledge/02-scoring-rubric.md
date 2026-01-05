# Scoring Rubric

> Formula để tính fitness score từ automatic signals. Không cần human input.

---

## Scoring Formula

```
Score = 0.35 * tool_success_rate
      + 0.25 * output_quality
      + 0.20 * efficiency
      + 0.15 * (1 - error_rate)
      + 0.05 * structure_score

Final Score = round(Score * 100, 2)  # 0-100 scale
```

---

## Signal Definitions

### 1. Tool Success Rate (35%)

**Source**: Hook logs (post-execution.sh)

**Formula**:
```
tool_success_rate = successful_tool_calls / total_tool_calls
```

**Measurement**:
- `successful`: exit_code == 0 AND no error in output
- `failed`: exit_code != 0 OR error pattern detected

**Example**:
```yaml
execution:
  tools:
    Read: {calls: 5, success: 5}
    Write: {calls: 2, success: 2}
    Bash: {calls: 3, success: 2}  # 1 failed
  total: 10
  successful: 9
  rate: 0.90  # 90%
```

---

### 2. Output Quality (25%)

**Source**: Output analysis (automatic)

**Formula**:
```
output_quality = (completeness + accuracy) / 2
```

**Completeness** (0-1):
- Có answer cho question: +0.3
- Có code nếu là coding task: +0.3
- Có explanation: +0.2
- Có next steps/recommendations: +0.2

**Accuracy** (0-1):
- Syntax valid (code compiles/parses): +0.4
- No obvious errors: +0.3
- Follows instructions: +0.3

**Heuristics**:
```python
def score_completeness(output, task_type):
    score = 0.0

    if has_direct_answer(output):
        score += 0.3

    if task_type == "coding" and has_code_block(output):
        score += 0.3

    if has_explanation(output):
        score += 0.2

    if has_next_steps(output):
        score += 0.2

    return score

def score_accuracy(output):
    score = 0.0

    if not has_syntax_errors(output):
        score += 0.4

    if not has_obvious_errors(output):
        score += 0.3

    if follows_format(output):
        score += 0.3

    return score
```

---

### 3. Efficiency (20%)

**Source**: Execution time, tool count

**Formula**:
```
efficiency = 1 - (actual_time / max_expected_time)
           = 1 - (tool_count / max_expected_tools)
```

**Normalization**:
```yaml
max_expected:
  simple_task:
    time: 30s
    tools: 5
  medium_task:
    time: 120s
    tools: 15
  complex_task:
    time: 300s
    tools: 30
```

**Example**:
```yaml
execution:
  task_complexity: "medium"
  actual_time: 60s
  max_time: 120s
  efficiency: 0.50  # 50%

  # Alternative: tool-based
  actual_tools: 8
  max_tools: 15
  efficiency: 0.47  # 47%
```

---

### 4. Error Rate (15%)

**Source**: Error count in execution

**Formula**:
```
error_rate = min(1.0, error_count / 10)
score_component = 1 - error_rate
```

**Error types**:
- Tool execution errors (exit_code != 0)
- Retry attempts
- Exception/error patterns in output
- User corrections

**Capping**: Max 10 errors = 0 score for this component

**Example**:
```yaml
execution:
  errors:
    - {type: "tool_fail", tool: "Bash", count: 2}
    - {type: "retry", count: 1}
  total_errors: 3
  error_rate: 0.30
  score_component: 0.70  # (1 - 0.30)
```

---

### 5. Structure Score (5%)

**Source**: Output format analysis

**Formula**:
```
structure_score = (has_headers * 0.4)
                + (has_lists * 0.3)
                + (has_code_blocks * 0.3)
```

**Checks**:
```python
def score_structure(output):
    score = 0.0

    # Check for markdown headers
    if re.search(r'^#+\s', output, re.MULTILINE):
        score += 0.4

    # Check for lists (bullet or numbered)
    if re.search(r'^[\-\*\d\.]\s', output, re.MULTILINE):
        score += 0.3

    # Check for code blocks
    if re.search(r'```', output):
        score += 0.3

    return score
```

---

## Score Interpretation

| Score Range | Grade | Interpretation |
|-------------|-------|----------------|
| 90-100 | A+ | Excellent - rare mutation needed |
| 80-89 | A | Very good - minor improvements |
| 70-79 | B | Good - room for improvement |
| 60-69 | C | Average - mutation recommended |
| 50-59 | D | Below average - mutation required |
| <50 | F | Poor - consider rollback |

---

## Score Aggregation

When scoring across multiple executions:

```python
def aggregate_scores(executions):
    """Aggregate scores from multiple executions."""

    # Remove outliers (top/bottom 10%)
    scores = [e.score for e in executions]
    trimmed = remove_outliers(scores, 0.1)

    # Weighted average (recent executions matter more)
    weights = [1.0, 0.9, 0.8, 0.7, 0.6][:len(trimmed)]
    weighted_sum = sum(s * w for s, w in zip(trimmed, weights))
    total_weight = sum(weights[:len(trimmed)])

    return weighted_sum / total_weight
```

---

## Score Comparison

For evolution decisions:

```python
def should_apply_mutation(old_score, new_score):
    """Decide if mutation should be applied."""

    delta = new_score - old_score

    # Clear improvement
    if delta > 5:
        return True, "significant_improvement"

    # Marginal improvement (accept with exploration bonus)
    if delta > 0:
        return True, "marginal_improvement"

    # Slight regression (may accept for exploration)
    if delta > -3:
        return random.random() < 0.2, "exploration"

    # Clear regression
    return False, "regression"
```

---

## Automatic Signal Collection

```bash
#!/bin/bash
# Extract signals from execution log

# Tool success
TOTAL_TOOLS=$(jq -s 'length' executions.jsonl)
SUCCESSFUL=$(jq -s '[.[] | select(.exit == "0")] | length' executions.jsonl)
TOOL_SUCCESS=$(echo "scale=2; $SUCCESSFUL / $TOTAL_TOOLS" | bc)

# Error count
ERRORS=$(jq -s '[.[] | select(.exit != "0")] | length' executions.jsonl)

# Output structure
HAS_HEADERS=$(grep -c "^#" output.md || echo 0)
HAS_LISTS=$(grep -c "^[-*]" output.md || echo 0)
HAS_CODE=$(grep -c '```' output.md || echo 0)

# Efficiency (time-based)
START_TIME=$(head -1 executions.jsonl | jq -r '.ts')
END_TIME=$(tail -1 executions.jsonl | jq -r '.ts')
# Calculate duration...
```

---

*Scoring rubric maintained by SEPA. Updated based on metric effectiveness.*
