# Step 03: Dialogue Loop

## Objective
Turn-based discussion giữa Developer và Solution Architect với observer controls.

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
| Developer | Solution Architect |
| Solution Architect | Developer |

## Agent Response Patterns

### Solution Architect Response

#### When Developer presents requirements:
```markdown
**[Understanding]** — Tóm tắt requirements

Tôi hiểu cần {summary}. Constraints chính là {constraints}.

**[Design Proposal]** — Architecture approach:

Đề xuất architecture:
```
[Diagram or description]
```

**[Rationale]** — Why this approach:

- {Reason 1}
- {Reason 2}
- {Reason 3}

**[Trade-offs]** — Considerations:

| Approach | Pros | Cons |
|----------|------|------|
| This | {pro} | {con} |
| Alternative | {pro} | {con} |

**[Handoff]** — Chờ Developer:

"Dev thấy implementation complexity thế nào? Có concerns gì không?"
```

#### When reviewing Developer's design:
```markdown
**[Assessment]** — Overall evaluation

{Positive aspects first}

**[Concerns]** — Areas needing attention:

1. {Concern 1}: {explanation}
2. {Concern 2}: {explanation}

**[Recommendations]** — Suggestions:

- {Recommendation 1}
- {Recommendation 2}

**[Questions]** — Need clarification:

- {Question 1}
- {Question 2}

**[Handoff]** — Chờ Developer:

"Dev có thể elaborate về {specific area} không?"
```

### Developer Response

#### When Architect proposes design:
```markdown
**[Acknowledgment]** — Understanding the proposal

Tôi thấy approach này {assessment}.

**[Implementation View]** — From implementation perspective:

Complexity:
- {Component A}: {effort estimate}
- {Component B}: {effort estimate}

Challenges:
- {Challenge 1}
- {Challenge 2}

**[Concerns/Questions]** — Need to address:

- {Concern about scalability}
- {Question about integration}

**[Counter-proposal]** — Alternative consideration (if any):

{If Dev has different approach}

**[Handoff]** — Chờ Architect:

"Architect đồng ý với assessment này không? Có adjustments gì?"
```

#### When defending implementation approach:
```markdown
**[Context]** — Why this approach

{Background on implementation decisions}

**[Technical Details]** — How it works:

```
[Code or diagram]
```

**[Evidence]** — Supporting the approach:

- {Past experience}
- {Performance data}
- {Industry practice}

**[Trade-offs Acknowledged]** — What we accept:

- Accepting: {trade-off}
- Mitigating: {how}

**[Handoff]** — Chờ Architect:

"Architect có alternative recommendation không?"
```

## Observer Intervention Commands

| Command | Effect |
|---------|--------|
| `@arch: <msg>` | Inject as Solution Architect |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note (both see) |
| `*focus: <topic>` | Redirect discussion to topic |
| `*auto` | Switch to auto mode |
| `*manual` | Switch to manual mode |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Dialogue Modes

### Manual Mode (Default)
- AskUserQuestion after EVERY turn
- Observer decides when to proceed
- Full control over discussion

### Semi-Auto Mode
```
- Auto-continue for {n} turns
- Then pause for observer
- Good for letting natural flow develop
```

### Auto Mode
```
- Auto-continue until consensus or max turns
- Observer can interrupt anytime
- Good for quick iterations
```

## Consensus Detection

### Signs of Agreement
- Both agents acknowledge approach
- No outstanding concerns
- Ready to document decision

### Signs of Disagreement
- Repeated concerns without resolution
- Counter-proposals cycling
- Need observer intervention

## Checkpoint After Each Turn

```yaml
turn_{n}:
  speaker: "{agent}"
  summary: "{brief summary}"
  key_points:
    - "{point 1}"
    - "{point 2}"
  state:
    agreements: []
    open_issues: []
    next_speaker: "{agent}"
```

## Max Turns

- Design mode: 12 turns (then prompt synthesis)
- Review mode: 8 turns
- ADR mode: 10 turns

## AskUserQuestion Format

```javascript
AskUserQuestion({
  questions: [{
    question: "Turn {n} complete. {speaker} đã nói. Bạn muốn làm gì?",
    header: "Turn {n}",
    options: [
      { label: "Tiếp tục", description: "{other_agent} sẽ respond" },
      { label: "Can thiệp", description: "Nhập message @arch/@dev/@guide" },
      { label: "Skip to synthesis", description: "Nhảy đến tạo output" },
      { label: "Kết thúc session", description: "Dừng và lưu progress" }
    ],
    multiSelect: false
  }]
})
```

## Next Step

→ When ready, proceed to **step-04-output-synthesis.md**
