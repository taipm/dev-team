# Step 03: Dialogue Loop

## Objective
Orchestrate turn-based dialogue giữa QA và Developer cho đến khi đạt được consensus về output.

## Dialogue Modes

### Mode Overview

| Mode | Behavior | Use Case |
|------|----------|----------|
| **manual** | Wait for observer sau mỗi turn | Default, full control |
| **auto** | Agents tự dialogue đến khi xong | Quick output generation |
| **semi-auto** | Auto nhưng pause tại decision points | Balanced approach |

### Mode Switching Commands

| Command | Effect |
|---------|--------|
| `*auto` | Switch to auto mode |
| `*manual` | Switch to manual mode |
| `*semi` | Switch to semi-auto mode |

---

## Main Loop

### Manual Mode Loop
```
WHILE (turn_count < max_turns) AND (NOT output_finalized):
    execute_turn()
    save_checkpoint()
    wait_for_observer()        # AskUserQuestion
    check_observer_intervention()
    determine_next_speaker()
    check_completion_signals()
```

### Auto Mode Loop
```
WHILE (turn_count < max_turns) AND (NOT output_finalized):
    execute_turn()
    save_checkpoint()
    display_turn_progress()

    IF should_pause():
        switch_to_manual()
        wait_for_observer()
    ELSE:
        determine_next_speaker()
        continue_immediately()
```

### Should Pause Conditions (Auto Mode)
```yaml
pause_conditions:
  - conflict_detected: true
    check: "contains('không đồng ý', 'nhưng tôi nghĩ', 'có vấn đề')"

  - major_decision: true
    check: "contains('severity', 'priority', 'approach')"

  - synthesis_phase: true
    check: "phase == 'synthesis'"

  - max_auto_turns: 12
    check: "turn_count >= max_auto_turns"
```

---

## Turn Templates by Mode

### Test Plan Mode - QA Response
```markdown
[Turn {n} - QA Engineer] 🔍

**[Assessment]**
{initial_reaction_to_feature}

**[Questions/Concerns]**
1. {question_about_scope}
2. {question_about_edge_cases}
3. {security_concern}

**[Test Scenarios Proposal]**
- Happy path: {scenario}
- Edge case: {scenario}
- Error handling: {scenario}

**[Risk Assessment]**
- High risk area: {area}
- Recommended focus: {focus}

[Dev, {handoff_question}]

───────────────────────────────────────────────────────────────
```

### Test Plan Mode - Dev Response
```markdown
[Turn {n} - Developer] 👨‍💻

**[Acknowledgment]**
{response_to_qa_questions}

**[Clarifications]**
1. {answer_1}
2. {answer_2}

**[Additional Context]**
- {technical_detail}
- {constraint}

**[Test Support]**
- Suggested test data: {data}
- Environment setup: {setup}

[QA, {handoff_question}]

───────────────────────────────────────────────────────────────
```

### Bug Triage Mode - Dev Response
```markdown
[Turn {n} - Developer] 👨‍💻

**[Analysis]**
{root_cause_analysis}

**[Questions]**
1. {clarifying_question}
2. {environment_question}

**[Severity Assessment]**
- Agree/Disagree with {severity}
- Reason: {reasoning}

**[Fix Approach]**
- Option A: {approach} - {trade_off}
- Option B: {approach} - {trade_off}

[QA, {handoff_question}]

───────────────────────────────────────────────────────────────
```

### Bug Triage Mode - QA Response
```markdown
[Turn {n} - QA Engineer] 🔍

**[Clarifications]**
{answers_to_dev_questions}

**[Severity Discussion]**
- {agreement_or_counter}
- Evidence: {evidence}

**[Priority Proposal]**
- Suggested: {priority}
- Reason: {business_impact}

**[Test Scenarios for Fix]**
1. {verification_scenario_1}
2. {verification_scenario_2}

[Dev, {handoff_question}]

───────────────────────────────────────────────────────────────
```

### Code Review Mode - QA Response
```markdown
[Turn {n} - QA Engineer] 🔍

**[Review Findings]**

✅ **Good:**
- {positive_1}
- {positive_2}

⚠️ **Concerns:**
1. {concern_1} - {file:line}
   - Issue: {description}
   - Suggestion: {fix}

2. {concern_2} - {file:line}
   - Issue: {description}
   - Suggestion: {fix}

**[Testability Assessment]**
- Mockable: {yes/no}
- Coverage: {assessment}

**[Test Recommendations]**
- Add test for: {scenario}
- Edge case: {case}

[Dev, {handoff_question}]

───────────────────────────────────────────────────────────────
```

---

## Observer Intervention Handling

### Parse Observer Input
```yaml
input_patterns:
  - pattern: "^$|^\\s*$"              # Empty/Enter
    action: "continue"
  - pattern: "^@qa:\\s*(.+)$"
    action: "inject_as_qa"
  - pattern: "^@dev:\\s*(.+)$"
    action: "inject_as_dev"
  - pattern: "^@guide:\\s*(.+)$"
    action: "facilitator_note"
  - pattern: "^\\*skip$"
    action: "skip_to_synthesis"
  - pattern: "^\\*exit$"
    action: "end_session"
  - pattern: "^\\*auto$"
    action: "switch_to_auto_mode"
  - pattern: "^\\*manual$"
    action: "switch_to_manual_mode"
```

### Intervention Templates

**@qa injection:**
```
[Turn {n} - QA Engineer] 🔍 (Observer Override)

{injected_message}

───────────────────────────────────────────────────────────────
```

**@dev injection:**
```
[Turn {n} - Developer] 👨‍💻 (Observer Override)

{injected_message}

───────────────────────────────────────────────────────────────
```

**@guide note:**
```
[Facilitator Note] 📋

{guide_message}

Agents, please address this point in your next turn.

───────────────────────────────────────────────────────────────
```

---

## Phase Transitions

```yaml
phase_transitions:
  presentation_to_discussion:
    trigger: "First response from other agent"
    action: "phase = 'discussion'"

  discussion_to_negotiation:
    trigger: "Disagreement on severity/priority/approach"
    action: "phase = 'negotiation'"

  negotiation_to_synthesis:
    trigger: "Agreement reached, ready to create output"
    action: "phase = 'synthesis'"

  synthesis_to_complete:
    trigger: "Both agents sign off"
    action: "output_finalized = true"
```

---

## Completion Signals

### Test Plan Mode
- QA: "Test scenarios này cover đủ rồi"
- Dev: "Đồng ý với test plan này"

### Bug Triage Mode
- QA: "Agree với fix approach"
- Dev: "Confirm severity và timeline"

### Code Review Mode
- QA: "QA approved với conditions"
- Dev: "Will address all feedback"

---

## Checkpoint System

### Auto-Checkpoint After Each Turn

```yaml
checkpoint:
  session_id: "{uuid}"
  step: "step-03-dialogue-loop"
  turn: {n}
  timestamp: "{ISO_timestamp}"
  phase: "{current_phase}"
  current_speaker: "{speaker}"
  dialogue_history: [...]
  key_decisions: [...]
  can_resume: true
```

---

## Max Turns Warning

At turn 10:
```
[Facilitator Warning] ⚠️

Đã turn 10/15. Nên focus vào finalizing:
- Test Plan mode: Confirm test scenarios
- Bug mode: Agree on severity + fix approach
- Review mode: Finalize feedback

───────────────────────────────────────────────────────────────
```

At turn 15 (max):
```
[Facilitator] ⏱️

Đã đạt giới hạn 15 turns. Chuyển sang Output Synthesis.
Output sẽ dựa trên consensus hiện tại.

───────────────────────────────────────────────────────────────
```

---

## Transition

→ When output_finalized OR turn_count >= 15:
   Proceed to Step 04: Output Synthesis
