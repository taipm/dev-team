# Mutation Strategies

> 8 operators để mutate prompts. Mỗi strategy có risk level và use case riêng.

---

## Strategy Catalog

### 1. instruction_rephrase (LOW Risk)

**Description**: Diễn đạt lại instructions mà không thay đổi ý nghĩa.

**When to use**:
- Default strategy khi không có signal rõ ràng
- Score ổn định, cần minor improvements

**Mutation prompt**:
```
Rephrase the following instruction to be clearer and more actionable.
Keep the same meaning but improve clarity.

Original: {instruction}
Rephrased:
```

**Example**:
- Before: "You should analyze the code"
- After: "Analyze the code structure, identify patterns, and report findings"

---

### 2. step_reorder (MEDIUM Risk)

**Description**: Thay đổi thứ tự các bước trong reasoning chain.

**When to use**:
- Low efficiency scores
- Tasks taking longer than expected
- Redundant work detected

**Mutation prompt**:
```
Reorder these steps to be more efficient.
Consider dependencies and remove redundant steps.

Steps:
{steps}

Optimized order:
```

**Example**:
- Before: "1. Read file 2. Search codebase 3. Read file again"
- After: "1. Search codebase 2. Read relevant files once"

---

### 3. constraint_add (LOW Risk)

**Description**: Thêm constraint hoặc rule mới.

**When to use**:
- High error rates
- Inconsistent outputs
- Missing safety checks

**Mutation prompt**:
```
Add a constraint to prevent the following issue:
Issue: {detected_issue}

Current prompt section:
{section}

Add constraint:
```

**Example**:
- Issue: "Agent deletes files without confirmation"
- Constraint: "NEVER delete files without explicit user confirmation"

---

### 4. constraint_remove (HIGH Risk)

**Description**: Loại bỏ constraint đang gây over-constrain.

**When to use**:
- Output quá restrictive
- Valid actions bị blocked
- User phải override thường xuyên

**Mutation prompt**:
```
This constraint may be too restrictive:
{constraint}

Evidence:
- User overrides: {override_count}
- Blocked valid actions: {blocked_actions}

Should this constraint be removed or relaxed?
```

**Safety**: Require 5+ occurrences before considering removal.

---

### 5. example_inject (LOW Risk)

**Description**: Thêm concrete example vào prompt.

**When to use**:
- Low output quality
- Format inconsistency
- New task types

**Mutation prompt**:
```
Add an example to clarify this instruction:
{instruction}

Based on successful execution:
{successful_output}

Example to add:
```

**Example**:
```markdown
When analyzing code, format output like this:

**File**: path/to/file.py
**Issues Found**:
1. Line 42: Unused import
2. Line 78: Missing error handling
```

---

### 6. emphasis_shift (MEDIUM Risk)

**Description**: Thay đổi mức độ emphasis (MUST vs SHOULD vs MAY).

**When to use**:
- Inconsistent behavior
- Some rules ignored
- Over-compliance on optional items

**Mutation prompt**:
```
Adjust emphasis levels based on importance:

Current: {text_with_emphasis}

Rules:
- Critical (always): Use MUST, ALWAYS, NEVER
- Important (usually): Use SHOULD, PREFER
- Optional: Use MAY, CONSIDER, OPTIONALLY

Adjusted:
```

**Example**:
- Before: "You should validate input"
- After: "You MUST validate all user input"

---

### 7. format_change (MEDIUM Risk)

**Description**: Thay đổi output format requirements.

**When to use**:
- Low structure scores
- User reformats output often
- Readability issues

**Mutation prompt**:
```
Improve the output format specification:

Current format:
{current_format}

Issues detected:
{format_issues}

Improved format:
```

**Example**:
- Before: "List the findings"
- After: "Present findings in a table with columns: Issue | Severity | Location | Fix"

---

### 8. persona_adjust (LOW Risk)

**Description**: Điều chỉnh communication style.

**When to use**:
- User feedback on tone
- Response length issues
- Domain mismatch

**Mutation prompt**:
```
Adjust the persona based on feedback:

Current persona:
{persona}

Feedback signals:
{feedback}

Adjusted persona:
```

**Example**:
- Before: "Professional and detailed"
- After: "Professional, concise, action-oriented - prefer bullet points over paragraphs"

---

## Strategy Selection Algorithm

```python
def select_strategy(metrics, history):
    """Select mutation strategy based on metrics and history."""

    # Priority rules based on signals
    if metrics.error_rate > 0.3:
        return "constraint_add"  # Fix errors first

    if metrics.efficiency < 0.5:
        return "step_reorder"  # Improve efficiency

    if metrics.output_quality < 0.6:
        return "example_inject"  # Improve quality

    if metrics.structure_score < 0.5:
        return "format_change"  # Fix format

    # Default: weighted random based on history
    weights = calculate_strategy_weights(history)
    return weighted_random_choice(weights)

def calculate_strategy_weights(history):
    """Weight strategies by past performance."""
    weights = {}

    for strategy in STRATEGIES:
        perf = history.get(strategy, {})
        uses = perf.get('uses', 0)
        improvements = perf.get('improvements', 0)
        avg_delta = perf.get('avg_delta', 0)

        weight = 1.0

        # Boost successful strategies
        if improvements > 0:
            weight *= (1 + avg_delta / 100)

        # Penalize failing strategies
        if avg_delta < 0:
            weight *= 0.5

        # Explore unused strategies
        if uses == 0:
            weight *= 1.5

        weights[strategy] = max(0.1, weight)

    return weights
```

---

## Risk Assessment

| Risk Level | Description | Safeguards |
|------------|-------------|------------|
| LOW | Minor changes, unlikely to break | Apply immediately |
| MEDIUM | Noticeable changes, may affect behavior | Monitor next 2 executions |
| HIGH | Significant changes, may cause issues | Require 5+ supporting signals |

---

## Mutation Logging

Every mutation is logged:

```yaml
mutation_log:
  timestamp: "2026-01-04T12:00:00Z"
  from_version: "v003"
  to_version: "v004"
  strategy: "constraint_add"
  trigger_signal: "error_rate: 0.35"
  change_summary: "Added input validation constraint"
  parent_score: 72.5
  expected_improvement: "Reduce errors by 30%"
```

---

*Strategies maintained by SEPA. Auto-selected based on execution signals.*
