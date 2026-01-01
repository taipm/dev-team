# Step 02: Topic Presentation

## Objective
First speaker presents the topic based on session mode.

## First Speaker by Mode

| Mode | First Speaker | Presentation Type |
|------|---------------|-------------------|
| design | Developer | Requirements/Problem statement |
| review | Developer | Architecture/Design to review |
| adr | Solution Architect | Decision context |

## Presentation Templates

### Design Mode - Developer Presents

```markdown
**[Context]** — Background và motivation

Chúng ta cần {build/design/implement} {what} để {why}.

**[Requirements]** — What we need:

Functional:
- {Requirement 1}
- {Requirement 2}
- {Requirement 3}

Non-Functional:
- Performance: {targets}
- Scalability: {expectations}
- Security: {requirements}

**[Constraints]** — Limitations to consider:

- Timeline: {deadline}
- Budget: {if applicable}
- Tech stack: {existing constraints}
- Team: {size, skills}

**[Current State]** — Where we are now:

{Description of current system if applicable}

**[Handoff]** — Chờ Architect:

"Architect có initial thoughts về approach không?"
```

### Review Mode - Developer Presents

```markdown
**[Architecture Overview]** — High-level design

{Description or diagram reference}

**[Key Components]** — Main building blocks:

1. {Component A}: {responsibility}
2. {Component B}: {responsibility}
3. {Component C}: {responsibility}

**[Design Decisions]** — Choices already made:

- {Decision 1}: {rationale}
- {Decision 2}: {rationale}

**[Areas of Concern]** — What I want feedback on:

1. {Concern 1}
2. {Concern 2}

**[Handoff]** — Chờ Architect:

"Architect review được không? Đặc biệt quan tâm đến {specific area}."
```

### ADR Mode - Architect Presents

```markdown
**[Decision Context]** — Why we need to decide

{Background on the issue requiring a decision}

**[Decision Drivers]** — Factors influencing the decision:

- {Driver 1}
- {Driver 2}
- {Driver 3}

**[Options Identified]** — Potential approaches:

1. **Option A**: {description}
2. **Option B**: {description}
3. **Option C**: {description}

**[Initial Assessment]** — Preliminary thoughts:

{Architect's initial analysis}

**[Handoff]** — Chờ Developer:

"Dev có insights về implementation complexity của các options không?"
```

## Turn Header Format

```
╔═══════════════════════════════════════════════════════════════╗
║ Turn 1 | Mode: {mode} | Speaker: {agent}                      ║
╚═══════════════════════════════════════════════════════════════╝
```

## AskUserQuestion After Turn 1

```javascript
AskUserQuestion({
  questions: [{
    question: "Turn 1 complete. {speaker} đã present. Bạn muốn làm gì?",
    header: "Turn 1",
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

→ Proceed to **step-03-dialogue-loop.md**
