# Step 02: Topic Presentation

## Objective
First speaker presents the topic based on session mode.

## First Speaker by Mode

| Mode | First Speaker | Presentation Type |
|------|---------------|-------------------|
| requirements | Product Manager | Feature/User need |
| tech-spec | Product Manager | Requirements summary |
| estimation | Product Manager | Scope for estimation |

## Presentation Templates

### Requirements Mode - PM Presents

```markdown
**[Business Context]** — Why this feature

{Background and motivation}
User research/feedback: {insights}
Business goal: {measurable outcome}

**[User Need]** — The problem we're solving

{Description of user problem}

**[Proposed Solution]** — High-level approach

As a {user type},
I want to {goal},
So that {benefit}.

**[Success Criteria]** — How we know it's working

- {Metric 1}
- {Metric 2}

**[Constraints]** — Known limitations

- Timeline: {deadline if any}
- Dependencies: {list}
- Technical: {known constraints}

**[Handoff]** — Chờ Developer:

"Dev có questions gì về requirement này?"
```

### Tech Spec Mode - PM Presents

```markdown
**[Requirements Summary]** — What we're building

User Stories:
- US-1: {story}
- US-2: {story}

**[Acceptance Criteria]** — Definition of done

- [ ] {AC 1}
- [ ] {AC 2}

**[Priority]** — MoSCoW breakdown

- Must have: {list}
- Should have: {list}
- Could have: {list}
- Won't have: {list}

**[Non-Functional Requirements]** — Quality attributes

- Performance: {requirements}
- Security: {requirements}
- Scalability: {requirements}

**[Questions for Dev]** — Need technical input on

1. {Technical question 1}
2. {Technical question 2}

**[Handoff]** — Chờ Developer:

"Dev có thể propose technical approach không?"
```

### Estimation Mode - PM Presents

```markdown
**[Scope Overview]** — What we're estimating

Feature: {feature_name}
User Stories: {count}

**[Detailed Scope]** — Breakdown

1. {Story 1}: {brief description}
2. {Story 2}: {brief description}
3. {Story 3}: {brief description}

**[Known Complexity]** — Risk areas

- {Complex area 1}
- {Complex area 2}

**[Dependencies]** — External factors

- {Dependency 1}
- {Dependency 2}

**[Timeline Context]** — Business constraints

- Target: {date if any}
- Flexibility: {description}

**[Handoff]** — Chờ Developer:

"Dev có thể break down và estimate không?"
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
      { label: "Can thiệp", description: "Nhập message @pm/@dev/@guide" },
      { label: "Skip to synthesis", description: "Nhảy đến tạo output" },
      { label: "Kết thúc session", description: "Dừng và lưu progress" }
    ],
    multiSelect: false
  }]
})
```

## Next Step

→ Proceed to **step-03-dialogue-loop.md**
