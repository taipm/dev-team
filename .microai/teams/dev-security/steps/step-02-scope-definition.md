# Step 02: Scope Definition

## Objective
Define scope of security review/assessment based on session mode.

## First Speaker by Mode

| Mode | First Speaker | Presentation Type |
|------|---------------|-------------------|
| review | Developer | Code/Feature to review |
| threat-model | Developer | System/Feature overview |
| vulnerability | Security Engineer | Assessment scope |

## Presentation Templates

### Review Mode - Developer Presents

```markdown
**[Feature/Code Overview]** — What we're reviewing

Feature: {feature_name}
Files involved:
- {file1.py}: {purpose}
- {file2.py}: {purpose}

**[Security Measures Taken]** — What I've implemented:

- Input validation: {description}
- Authentication: {description}
- Authorization: {description}
- Data protection: {description}

**[Areas of Concern]** — What I want reviewed:

1. {Concern 1}: {why concerned}
2. {Concern 2}: {why concerned}

**[Context]** — Additional info:

- Data sensitivity: {level}
- User base: {who accesses this}
- External dependencies: {list}

**[Handoff]** — Chờ Security:

"Security có thể review và identify vulnerabilities không?"
```

### Threat Model Mode - Developer Presents

```markdown
**[System Overview]** — What we're threat modeling

System: {system_name}
Purpose: {what it does}

**[Architecture]** — High-level design:

```
[DFD or architecture diagram]
```

**[Assets]** — What we're protecting:

1. {Asset 1}: Sensitivity {level}
2. {Asset 2}: Sensitivity {level}

**[Entry Points]** — How users interact:

1. {Entry point 1}: {authentication required?}
2. {Entry point 2}: {authentication required?}

**[Trust Boundaries]** — Security perimeters:

1. {Boundary 1}: {what it separates}
2. {Boundary 2}: {what it separates}

**[Handoff]** — Chờ Security:

"Security có thể apply STRIDE analysis không?"
```

### Vulnerability Mode - Security Presents

```markdown
**[Assessment Scope]** — What we're assessing

Target: {target_system}
Type: {web app/API/infrastructure}

**[Assessment Objectives]** — Goals:

1. {Objective 1}
2. {Objective 2}

**[Testing Approach]** — Methodology:

- [ ] OWASP Top 10 coverage
- [ ] Authentication/Authorization
- [ ] Input validation
- [ ] Data protection
- [ ] Business logic

**[Out of Scope]** — Not testing:

- {Out of scope 1}
- {Out of scope 2}

**[Handoff]** — Chờ Developer:

"Dev có thể cung cấp access và context không?"
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
    question: "Turn 1 complete. {speaker} đã present scope. Bạn muốn làm gì?",
    header: "Turn 1",
    options: [
      { label: "Tiếp tục", description: "{other_agent} sẽ respond" },
      { label: "Can thiệp", description: "Nhập message @security/@dev/@guide" },
      { label: "Skip to synthesis", description: "Nhảy đến tạo report" },
      { label: "Kết thúc session", description: "Dừng và lưu progress" }
    ],
    multiSelect: false
  }]
})
```

## Next Step

→ Proceed to **step-03-dialogue-loop.md**
