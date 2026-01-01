# Step 03: Dialogue Loop

## Objective
Orchestrate turn-based dialogue giữa Solo Dev và EndUser cho đến khi đạt được agreement về User Story.

## Dialogue Modes

### Mode Overview

| Mode | Behavior | Use Case |
|------|----------|----------|
| **manual** | Wait for observer sau mỗi turn | Default, full control |
| **auto** | Agents tự dialogue đến khi xong | Quick story generation |
| **semi-auto** | Auto nhưng pause tại decision points | Balanced approach |

### Auto Mode Flow

```
╔═══════════════════════════════════════════════════════════════╗
║                    AUTO-DIALOGUE MODE 🤖                       ║
╠═══════════════════════════════════════════════════════════════╣
║  Agents will dialogue automatically.                           ║
║  Pause triggers:                                               ║
║    • Conflict detected between agents                         ║
║    • Major scope change proposed                              ║
║    • Before final story synthesis                             ║
║    • Max auto turns (15) reached                              ║
║                                                                ║
║  You can type *manual at any time to take control.            ║
╚═══════════════════════════════════════════════════════════════╝
```

### Mode Switching Commands

| Command | Effect |
|---------|--------|
| `*auto` | Switch to auto mode, start auto-dialogue |
| `*manual` | Switch to manual mode, pause after current turn |
| `*semi` | Switch to semi-auto mode |

---

## Main Loop

### Manual Mode Loop
```
WHILE (turn_count < max_turns) AND (NOT story_finalized):
    execute_turn()
    save_checkpoint()
    wait_for_observer()        # AskUserQuestion - wait for input
    check_observer_intervention()
    determine_next_speaker()
    check_completion_signals()
```

### Auto Mode Loop
```
WHILE (turn_count < max_turns) AND (NOT story_finalized):
    execute_turn()
    save_checkpoint()
    display_turn_progress()    # Show turn but don't wait

    IF should_pause():         # Check pause conditions
        switch_to_manual()
        wait_for_observer()
    ELSE:
        determine_next_speaker()
        check_completion_signals()
        continue_immediately()  # No wait, next turn
```

### Should Pause Conditions (Auto Mode)
```yaml
pause_conditions:
  - conflict_detected: true
    description: "Agents disagree on scope/approach"
    check: "contains('không đồng ý', 'nhưng tôi nghĩ', 'có vấn đề')"

  - scope_change: true
    description: "New major requirement introduced"
    check: "contains('thêm yêu cầu', 'cũng cần', 'bổ sung')"

  - synthesis_phase: true
    description: "About to propose final story"
    check: "phase == 'synthesis' AND contains('đề xuất User Story')"

  - max_auto_turns: 15
    description: "Safety limit for auto mode"
    check: "turn_count >= max_auto_turns"

  - explicit_question_to_observer: true
    description: "Agent asks observer directly"
    check: "contains('@observer', 'Observer, bạn nghĩ')"
```

---

## Auto Mode Turn Display

### Progress Display (Auto Mode)
```
┌─────────────────────────────────────────────────────────────────┐
│ 🤖 AUTO-DIALOGUE | Turn {n}/{max} | Phase: {phase}              │
├─────────────────────────────────────────────────────────────────┤
│ {speaker_icon} {speaker}:                                       │
│                                                                 │
│ {message_preview_first_100_chars}...                           │
│                                                                 │
│ [Auto-continuing to next turn...]                               │
└─────────────────────────────────────────────────────────────────┘
```

### Pause Notification
```
╔═══════════════════════════════════════════════════════════════╗
║ ⏸️  AUTO-DIALOGUE PAUSED                                       ║
╠═══════════════════════════════════════════════════════════════╣
║ Reason: {pause_reason}                                         ║
║ Turn: {n} | Phase: {phase}                                     ║
╠═══════════════════════════════════════════════════════════════╣
║ Options:                                                       ║
║   [Enter] - Continue in manual mode                           ║
║   *auto   - Resume auto mode                                   ║
║   *skip   - Skip to synthesis                                  ║
╚═══════════════════════════════════════════════════════════════╝
```

### Auto Complete Summary
```
╔═══════════════════════════════════════════════════════════════╗
║ ✅ AUTO-DIALOGUE COMPLETE                                      ║
╠═══════════════════════════════════════════════════════════════╣
║ Total turns: {n}                                               ║
║ Decisions made: {count}                                        ║
║ Status: Ready for story synthesis                              ║
╠═══════════════════════════════════════════════════════════════╣
║ Review the dialogue? (Full transcript below)                   ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## Checkpoint System

### Auto-Checkpoint (Every Turn)

After each turn, save checkpoint to enable resume:

```yaml
checkpoint:
  file: "../memory/checkpoint.yaml"
  auto_save: true
  save_after: "each_turn"
```

**Checkpoint Data Structure:**
```yaml
checkpoint:
  session_id: "{uuid}"
  timestamp: "{ISO_timestamp}"
  subject: "{subject}"
  turn_count: {n}
  phase: "{current_phase}"
  current_speaker: "{speaker}"
  dialogue_history: [...]
  key_decisions: [...]
  open_questions: [...]
  can_resume: true
```

### Resume Command (*resume)

Add to observer commands:
```
*resume  → Resume from last checkpoint
```

**Resume Flow:**
```
1. Check if checkpoint exists
2. Load checkpoint data
3. Display resume message:

╔══════════════════════════════════════════════════════════════╗
║                  RESUMING SESSION 🔄                          ║
╠══════════════════════════════════════════════════════════════╣
║  Subject: {subject}                                           ║
║  Last checkpoint: {timestamp}                                 ║
║  Turn: {turn_count} | Phase: {phase}                         ║
╚══════════════════════════════════════════════════════════════╝

Last exchange:
───────────────────────────────────────────────────────────────
{last_turn_speaker}: {last_turn_message_summary}
───────────────────────────────────────────────────────────────

Continuing from where we left off...

4. Set state from checkpoint
5. Continue dialogue loop
```

### Checkpoint Cleanup

After session completes successfully:
```yaml
cleanup:
  - archive: checkpoint → "./memory/checkpoints/{date}-{subject}.yaml"
  - clear: active checkpoint
```

## Turn Execution

### Solo Dev Turn Template
```
[Turn {n} - Solo Dev] 👨‍💻

{response_to_previous}

{main_content}:
- Questions to clarify, OR
- Options to propose, OR
- Summary to confirm

{handoff}:
- "[Chờ câu trả lời của bạn...]"
- "[Bạn chọn option nào?]"
- "[Xác nhận để tiếp tục?]"

───────────────────────────────────────────────────────────────
Turn {n} | Phase: {phase} | Speaker: Solo Dev
[Enter] continue | @dev/@user/@guide: inject | *skip/*exit
>
```

### EndUser Turn Template
```
[Turn {n} - EndUser] 👤

{direct_answer_or_statement}

{context_or_examples}

{handoff}:
- "[Bạn nghĩ sao?]"
- "[Còn câu hỏi gì không?]"
- "[Tiếp tục đi!]"

───────────────────────────────────────────────────────────────
Turn {n} | Phase: {phase} | Speaker: EndUser
[Enter] continue | @dev/@user/@guide: inject | *skip/*exit
>
```

## Observer Intervention Handling

### Parse Observer Input
```yaml
input_patterns:
  - pattern: "^$|^\\s*$"              # Empty/Enter
    action: "continue"
  - pattern: "^@dev:\\s*(.+)$"
    action: "inject_as_dev"
    capture: "message"
  - pattern: "^@user:\\s*(.+)$"
    action: "inject_as_enduser"
    capture: "message"
  - pattern: "^@guide:\\s*(.+)$"
    action: "facilitator_note"
    capture: "message"
  - pattern: "^\\*skip$"
    action: "skip_to_synthesis"
  - pattern: "^\\*exit$"
    action: "end_session"
  - pattern: "^\\*pause$"
    action: "pause_dialogue"
  - pattern: "^\\*restart$"
    action: "restart_session"
  - pattern: "^\\*resume$"
    action: "resume_from_checkpoint"
  - pattern: "^\\*save$"
    action: "force_save_checkpoint"
  - pattern: "^\\*auto$"
    action: "switch_to_auto_mode"
  - pattern: "^\\*manual$"
    action: "switch_to_manual_mode"
  - pattern: "^\\*semi$"
    action: "switch_to_semi_auto_mode"
```

### Intervention Response Templates

**@dev injection:**
```
[Turn {n} - Solo Dev] 👨‍💻 (Observer Override)

{injected_message}

───────────────────────────────────────────────────────────────
```

**@user injection:**
```
[Turn {n} - EndUser] 👤 (Observer Override)

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

## Speaker Determination Logic

```yaml
next_speaker_rules:
  - condition: "question_asked"
    next: "other_agent"

  - condition: "options_proposed"
    next: "other_agent"

  - condition: "summary_presented"
    next: "other_agent"

  - condition: "explicit_handoff"
    next: "named_agent"

  - condition: "facilitator_intervention"
    next: "addressed_agent"

  - condition: "story_proposed"
    next: "enduser"  # For review
```

## Phase Transition Logic

```yaml
phase_transitions:
  requirements_to_clarification:
    trigger: "Solo Dev asks first clarifying question"
    action: "phase = 'clarification'"

  clarification_to_negotiation:
    trigger: "All major questions answered, discussing scope/trade-offs"
    action: "phase = 'negotiation'"

  negotiation_to_synthesis:
    trigger: "Agreement reached, Solo Dev says 'Let me summarize...'"
    action: "phase = 'synthesis'"

  synthesis_to_complete:
    trigger: "EndUser says 'I agree' or 'Sign off'"
    action: "story_finalized = true"
```

## Completion Signals

### From Solo Dev
- "Tôi đề xuất User Story sau..."
- "Đây là AC tôi đề xuất..."
- "Tóm tắt để sign off..."

### From EndUser
- "Tôi đồng ý với story này"
- "Sign off"
- "Looks good, proceed"
- "Accepted"

## State Tracking Per Turn

```yaml
turn_record:
  turn: {number}
  speaker: "solo-dev" | "enduser" | "observer"
  speaker_icon: "👨‍💻" | "👤" | "👁️"
  message: "{content}"
  timestamp: "{ISO_timestamp}"
  phase: "{current_phase}"
  intervention: false | true
  key_points_extracted: []
  decisions_made: []
  questions_raised: []
  questions_answered: []
```

## Max Turns Warning

At turn 15:
```
[Facilitator Warning] ⚠️

Chúng ta đã ở turn 15/20. Nếu cần thêm thời gian,
hãy focus vào finalizing scope và acceptance criteria.

Gợi ý: Solo Dev có thể summarize current understanding
và propose User Story với những gì đã thống nhất.

───────────────────────────────────────────────────────────────
```

At turn 20 (max):
```
[Facilitator] ⏱️

Đã đạt giới hạn 20 turns. Session sẽ chuyển sang
Story Synthesis với progress hiện tại.

Nếu chưa có agreement đầy đủ, story sẽ được mark
là "Draft - Needs Review".

───────────────────────────────────────────────────────────────
```

## Transition
→ When story_finalized OR turn_count >= 20:
   Proceed to Step 04: Story Synthesis

## State After Completion
```yaml
stepsCompleted: ["step-01-session-init", "step-02-requirements", "step-03-dialogue-loop"]
phase: "synthesis"
story_finalized: true | false
turn_count: {final_count}
dialogue_history: [{...turns...}]
```
