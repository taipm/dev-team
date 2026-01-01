# Step 03: Dialogue Loop

## Objective
Turn-based discussion giữa Developer và Security Engineer với observer controls.

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
   - "Skip to synthesis" → Jump to report
   - "Kết thúc session" → End and save
```

## Speaker Rotation

| Previous Speaker | Next Speaker |
|-----------------|--------------|
| Developer | Security Engineer |
| Security Engineer | Developer |

## Agent Response Patterns

### Security Engineer Response

#### When reviewing code:
```markdown
**[Initial Assessment]** — Overview

{High-level security posture assessment}

**[Findings]** — Vulnerabilities identified:

| # | Finding | Severity | Category |
|---|---------|----------|----------|
| 1 | {finding} | {Critical/High/Med/Low} | {OWASP category} |

**[Finding Details]** — Per finding:

### Finding 1: {title}
- **Severity**: {level}
- **Location**: {file:line}
- **Issue**: {description}
- **Risk**: {what could happen}
- **Attack Vector**: {how to exploit}
- **Fix**: {recommended fix}

**[Positive Observations]** — What's done well:

- {Positive 1}
- {Positive 2}

**[Handoff]** — Chờ Developer:

"[Dev có thể address findings này không?]"
```

#### When doing threat modeling:
```markdown
**[STRIDE Analysis]** — Threats identified:

### Spoofing
- [ ] {Threat 1}: {risk level}
- Mitigation: {approach}

### Tampering
- [ ] {Threat 1}: {risk level}
- Mitigation: {approach}

[... continue for R, I, D, E ...]

**[Risk Matrix]** — Prioritization:

| Threat | Likelihood | Impact | Risk |
|--------|------------|--------|------|
| {threat} | {H/M/L} | {H/M/L} | {score} |

**[Handoff]** — Chờ Developer:

"[Dev thấy mitigations feasible không?]"
```

### Developer Response

#### When addressing findings:
```markdown
**[Acknowledgment]** — Understanding the findings

Tôi hiểu concern về {issue}. {Context if needed}.

**[Response Per Finding]** —

### Finding 1: {title}
- **Status**: {Accepted/Disputed/Need clarification}
- **Current state**: {what's in place}
- **Proposed fix**: {approach}
- **Timeline**: {estimate}
- **Questions**: {if any}

**[Implementation Plan]** — For accepted findings:

```
[Code fix or approach]
```

**[Trade-offs]** — Considerations:

- User experience impact: {assessment}
- Performance impact: {assessment}
- Timeline impact: {assessment}

**[Handoff]** — Chờ Security:

"[Fix này adequate không? Còn concerns gì?]"
```

#### When providing context for threat model:
```markdown
**[Implementation Details]** — How it's built

{Technical details relevant to security}

**[Existing Controls]** — Security measures in place:

- {Control 1}: {description}
- {Control 2}: {description}

**[Constraints]** — Limitations:

- {Constraint 1}
- {Constraint 2}

**[Questions]** — Need clarification:

- {Question about threat}
- {Question about mitigation}

**[Handoff]** — Chờ Security:

"[Security có additional threats cần consider không?]"
```

## Observer Intervention Commands

| Command | Effect |
|---------|--------|
| `@security: <msg>` | Inject as Security Engineer |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Focus on specific area |
| `*owasp: <category>` | Focus on OWASP category |
| `*auto` | Switch to auto mode |
| `*manual` | Switch to manual mode |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Findings Tracking

### Per Turn Update
```yaml
findings:
  - id: F1
    title: "{title}"
    severity: "{Critical/High/Medium/Low}"
    category: "{OWASP category}"
    status: "{open/acknowledged/fixed/disputed}"
    turn_found: {n}
    turn_resolved: {n or null}
```

## Dialogue Modes

### Manual Mode (Default)
- AskUserQuestion after EVERY turn
- Full control over discussion

### Semi-Auto Mode
- Auto-continue for {n} turns
- Good for letting discussion develop

### Auto Mode
- Auto-continue until all findings addressed
- Observer can interrupt anytime

## Max Turns

- Review mode: 10 turns
- Threat-model mode: 12 turns
- Vulnerability mode: 10 turns

## AskUserQuestion Format

```javascript
AskUserQuestion({
  questions: [{
    question: "Turn {n} complete. {speaker} đã nói. Findings: {count}. Bạn muốn làm gì?",
    header: "Turn {n}",
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

→ When ready, proceed to **step-04-output-synthesis.md**
