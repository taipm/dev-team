# Step 03: Dialogue Loop

## Objective
Turn-based discussion giữa Product Manager và Developer với observer controls.

## Turn Execution Protocol

### Each Turn MUST Follow This Pattern:

```
1. Display turn header:
   ╔═══════════════════════════════════════════════════════════════╗
   ║ Turn {n} | Mode: {mode} | Speaker: {agent}                    ║
   ╚═══════════════════════════════════════════════════════════════╝

2. Agent speaks (in-character, ONE agent only)

3. IMMEDIATELY use AskUserQuestion tool:
   - "Tiếp tục" → Next agent responds
   - "Can thiệp" → Observer types message
   - "Skip to synthesis" → Jump to output creation
   - "Kết thúc session" → End and save
```

## Speaker Rotation

| Previous Speaker | Next Speaker |
|-----------------|--------------|
| Product Manager | Developer |
| Developer | Product Manager |

## Agent Response Patterns

### Developer Response

#### When receiving requirements:
```markdown
**[Understanding]** — Tóm tắt requirement

{Paraphrase to confirm understanding}

**[Clarifying Questions]** — Cần biết thêm:

1. {Question about user flow}
2. {Question about edge cases}
3. {Question about priority}

**[Initial Assessment]** — Technical view:

- Feasibility: {assessment}
- Complexity: {Low/Medium/High}
- Concerns: {list}

**[Suggestions]** — Đề xuất:

- {Alternative approach if any}
- {Scope adjustment if needed}

**[Handoff]** — Chờ PM:

"[PM có thể clarify {specific questions}?]"
```

#### When providing estimates:
```markdown
**[Breakdown]** — Component analysis:

| Component | Effort | Confidence |
|-----------|--------|------------|
| {comp 1} | {days} | {H/M/L} |
| {comp 2} | {days} | {H/M/L} |
| **Total** | **{days}** | **{overall}** |

**[Assumptions]** — Estimate based on:

- {Assumption 1}
- {Assumption 2}

**[Risks]** — What could affect estimate:

- {Risk 1}: {impact}
- {Risk 2}: {impact}

**[Alternatives]** — If timeline is tight:

Option A: {full scope} - {effort}
Option B: {reduced scope} - {effort}

**[Handoff]** — Chờ PM:

"[PM chấp nhận estimate này không? Có cần adjust scope?]"
```

### Product Manager Response

#### When answering questions:
```markdown
**[Clarifications]** — Trả lời questions:

Q1: {question}
A: {answer with context}

Q2: {question}
A: {answer with context}

**[Updated Requirements]** — Refined scope:

- {Clarified requirement 1}
- {Clarified requirement 2}

**[Priority Confirmation]** — Must-haves vs nice-to-haves:

Must: {list}
Nice-to-have: {list}

**[Handoff]** — Chờ Developer:

"[Clear hơn chưa? Còn questions gì?]"
```

#### When receiving estimates:
```markdown
**[Acknowledgment]** — Understanding the estimate

{Reaction to estimate}

**[Scope Discussion]** — Trade-offs:

- If {timeline} is fixed: {what to cut}
- If {scope} is fixed: {timeline adjustment}

**[Decision]** — Direction:

{Chosen approach and rationale}

**[Next Steps]** — Moving forward:

1. {Action item 1}
2. {Action item 2}

**[Handoff]** — Chờ Developer:

"[Dev đồng ý với approach này không?]"
```

## Observer Intervention Commands

| Command | Effect |
|---------|--------|
| `@pm: <msg>` | Inject as Product Manager |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Focus on specific area |
| `*auto` | Switch to auto mode |
| `*manual` | Switch to manual mode |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Dialogue Modes

### Manual Mode (Default)
- AskUserQuestion after EVERY turn
- Full control over discussion

### Semi-Auto Mode
- Auto-continue for {n} turns
- Good for natural flow

### Auto Mode
- Auto-continue until consensus
- Observer can interrupt anytime

## Progress Tracking

### Requirements Mode
```yaml
stories_discussed: 0
questions_resolved: 0
scope_agreed: false
```

### Tech Spec Mode
```yaml
approach_agreed: false
estimates_provided: false
risks_identified: false
```

### Estimation Mode
```yaml
stories_estimated: 0
total_estimate: null
confidence: null
```

## Max Turns

- Requirements mode: 10 turns
- Tech Spec mode: 12 turns
- Estimation mode: 8 turns

## AskUserQuestion Format

```javascript
AskUserQuestion({
  questions: [{
    question: "Turn {n} complete. {speaker} đã nói. Bạn muốn làm gì?",
    header: "Turn {n}",
    options: [
      { label: "Tiếp tục", description: "{other_agent} sẽ respond" },
      { label: "Can thiệp", description: "Nhập message @pm/@dev/@guide" },
      { label: "Skip to synthesis", description: "Nhảy đến tạo output" },
      { label: "Kết thúc session", description: "Dừng và lưu progress" }
    ],
    multiSelect: false
  }]
})
```

## Next Step

→ When ready, proceed to **step-04-output-synthesis.md**
