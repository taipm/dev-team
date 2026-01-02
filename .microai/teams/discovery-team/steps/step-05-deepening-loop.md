# Step 05: Deepening Loop

## Trigger
- After Step 04 complete
- Analysis reviewed

## Agents
- 🎯 **Navigator** (lead)
- ❓ **Questioner** (support)

## Purpose
Decide whether to go deeper or proceed to synthesis.

## Actions

### 1. Navigator: Evaluate Deepening Need
```yaml
evaluate:
  # Check gaps
  gaps:
    high_priority: analysis.gaps.filter(priority == "HIGH")
    count: {N}

  # Check incomplete patterns
  incomplete_patterns:
    filter: patterns where confidence < HIGH
    count: {N}

  # Check user preference
  user_depth: session.depth
  current_iteration: session.deepening.iteration

  # Check limits
  max_reached: current_iteration >= 3

decision_matrix:
  if: max_reached
    decision: "STOP - max iterations reached"

  elif: high_priority_gaps > 0 AND depth >= 2
    decision: "DEEPEN"
    reason: "High priority gaps need addressing"

  elif: incomplete_patterns > 0 AND depth == 3
    decision: "DEEPEN"
    reason: "Patterns need more evidence"

  elif: user_requests_deep
    decision: "DEEPEN"
    reason: "User requested"

  else:
    decision: "PROCEED"
    reason: "Sufficient depth achieved"
```

### 2. If DEEPEN: Generate Follow-up Questions
```yaml
questioner_task:
  for each gap:
    generate:
      id: "derived-{sequence}"
      question: |
        Based on gap: {gap.description}
        Question: {generated question}
      parent: {original_question_id}
      depth: current_depth + 1
      evidence_required: {inferred from gap}
      search_hints: {inferred}

  for each incomplete_pattern:
    generate:
      id: "derived-{sequence}"
      question: |
        Pattern "{pattern.name}" needs verification.
        Question: Where else is this pattern used?
      parent: null
      depth: current_depth + 1
```

### 3. Navigator: Present Deepening Decision
```markdown
🎯 **Navigator**: Đánh giá độ sâu

**Current iteration:** {N}/3
**Current depth:** {level}

**Analysis:**
- High priority gaps: {N}
- Incomplete patterns: {N}
- Unanswered questions: {N}

**Decision:** {DEEPEN|PROCEED}
**Reason:** {reason}

{if DEEPEN}
**Derived questions to explore:**
| ID | Question | Based on |
|----|----------|----------|
| derived-001 | {question} | gap-001 |
| derived-002 | {question} | pat-002 |

[Enter] Proceed with deepening
*skip → Skip to synthesis
*select:{ids} → Select specific questions
{/if}

{if PROCEED}
**Ready for synthesis.**
All critical areas have sufficient evidence.

[Enter] Continue to synthesis
*deep → Force one more iteration
{/if}
```

### 4. If DEEPEN: Loop Back
```yaml
if: decision == "DEEPEN"
  actions:
    - Add derived questions to question_context
    - Increment iteration counter
    - Update current_context

  transition: → Step 03: Fact Gathering (for derived questions)

if: decision == "PROCEED"
  transition: → Step 06: Synthesis
```

## Loop Control

```yaml
deepening_loop:
  max_iterations: 3
  current_iteration: {N}

  exit_conditions:
    - max_iterations reached
    - no high priority gaps
    - user skips (*skip)
    - user forces proceed

  loop_back_to: Step 03

  state_preservation:
    - All previous facts retained
    - All previous analysis retained
    - Derived questions marked with parent
```

## Iteration Tracking

```markdown
🎯 **Navigator**: Deepening Progress

**Iteration {N}/3**

| Iteration | Questions | Facts | Gaps Filled |
|-----------|-----------|-------|-------------|
| 1 (initial) | 8 | 15 | - |
| 2 | 3 | 7 | 2 |
| 3 (current) | 2 | 4 | 1 |

**Cumulative:**
- Total questions: {N}
- Total facts: {N}
- Remaining gaps: {N}
```

## Output
```yaml
current_context:
  deepening:
    iteration: {N}
    max: 3
    decision: "{DEEPEN|PROCEED}"
    reason: "{reason}"

    history:
      - iteration: 1
        questions: 8
        facts: 15
      - iteration: 2
        questions: 3
        facts: 7
        derived_from: [gap-001, gap-002]

question_context:
  derived:
    - id: "derived-001"
      question: "{text}"
      parent: "{original_question_id}"
      iteration: {N}
```

## Transition
- If DEEPEN → Step 03: Fact Gathering
- If PROCEED → Step 06: Synthesis
