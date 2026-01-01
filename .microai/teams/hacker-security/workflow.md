# Hacker-Security Team Workflow

> Adversarial security testing through offensive-defensive collaboration.

---

## Team Overview

```yaml
team_name: hacker-security
purpose: Comprehensive security assessment through red/blue team collaboration
language: vi
output_location: docs/hacker-security/

members:
  - role: White Hacker
    agent: agents/white-hacker.md
    icon: 🎭
    color: red
    mindset: offensive

  - role: Security Engineer
    agent: ../dev-security/agents/security-engineer.md
    icon: 🔒
    color: blue
    mindset: defensive
```

---

## Workflow Modes

### Mode 1: Pentest (Default)

```
PURPOSE: Find vulnerabilities and validate fixes

FLOW:
┌──────────────────────────────────────────────────────────────┐
│  [Target/Scope] → [Attack Surface] → [Exploit] → [Defend]   │
│                         ↑                           │        │
│                         └───────────────────────────┘        │
│                              (iterate until robust)          │
└──────────────────────────────────────────────────────────────┘

TURNS:
1. User provides target
2. White-Hacker identifies attack surface
3. White-Hacker demonstrates exploit
4. Security-Engineer validates + proposes fix
5. White-Hacker attempts bypass
6. Iterate until defense is robust
7. Generate combined report

OUTPUT: Pentest report với attack + defense
```

### Mode 2: Red-Team

```
PURPOSE: Full adversarial simulation

FLOW:
┌──────────────────────────────────────────────────────────────┐
│  [Red: Plan] → [Red: Attack] → [Blue: Detect?] → [Debrief]  │
│       ↓              ↓               ↓                       │
│    strategy      execution      response                     │
└──────────────────────────────────────────────────────────────┘

TURNS:
1. Red Team (Hacker) plans attack strategy
2. Red Team executes attack phase
3. Blue Team (Security) attempts detection
4. Red Team continues attack chain
5. Blue Team responds
6. Repeat through kill chain
7. Debrief: detection rate, missed attacks

OUTPUT: Red team report với detection analysis
```

### Mode 3: Threat-Hunt

```
PURPOSE: Collaborative gap analysis

FLOW:
┌──────────────────────────────────────────────────────────────┐
│  [Current Defenses] → [Gap Analysis] → [Prioritize Fixes]   │
│         ↓                    ↓                  ↓            │
│    Security-Eng         White-Hacker        Together         │
└──────────────────────────────────────────────────────────────┘

TURNS:
1. Security-Engineer presents defenses
2. White-Hacker analyzes for gaps
3. Collaborative discussion
4. Identify detection coverage
5. Prioritize improvements
6. Generate recommendations

OUTPUT: Threat hunt report với coverage map
```

---

## Turn Protocol

### Turn Structure

```yaml
each_turn:
  header: |
    ╔═══════════════════════════════════════════════════════════╗
    ║ Turn {n} | Mode: {mode} | Speaker: {agent}                ║
    ╚═══════════════════════════════════════════════════════════╝

  body:
    - Agent speaks in character
    - Technical content as needed
    - Clear handoff signal

  footer:
    - MUST call AskUserQuestion
    - Options: Continue, Intervene, Focus, Skip, End
```

### Turn Limits

| Mode | Max Turns | Reason |
|------|-----------|--------|
| Pentest | 12 | Iterate on findings |
| Red-Team | 15 | Full kill chain |
| Threat-Hunt | 10 | Focused analysis |

---

## Agent Interaction Rules

### White Hacker Speaking

```yaml
when_white_hacker_speaks:
  must:
    - Think offensively
    - Provide technical details
    - Show actual attack paths
    - Explain WHY attack works

  must_not:
    - Propose defensive fixes (that's Security's job)
    - Mix with defensive mindset
    - Skip technical details

  handoff_signals:
    - "Security-Engineer, có defense nào cho attack này?"
    - "Bạn validate severity thế nào?"
    - "Fix này có chặn được không?"
```

### Security Engineer Speaking

```yaml
when_security_engineer_speaks:
  must:
    - Validate finding severity
    - Propose concrete fixes
    - Think defense-in-depth
    - Consider business impact

  must_not:
    - Try to find new attacks (that's Hacker's job)
    - Dismiss findings without analysis
    - Propose impractical fixes

  handoff_signals:
    - "Shadow, thử bypass fix này xem?"
    - "Còn attack vector nào khác không?"
    - "Fix này có đủ robust không?"
```

---

## Output Templates

### Session Output Location

```
docs/hacker-security/
├── {YYYY-MM-DD}-pentest-{topic}.md
├── {YYYY-MM-DD}-redteam-{scenario}.md
└── {YYYY-MM-DD}-threathunt-{target}.md
```

### Report Templates

- Pentest: `templates/combined-report.md`
- Red-Team: `templates/redteam-report.md` (TODO)
- Threat-Hunt: `templates/threathunt-report.md` (TODO)

---

## Memory System

### Team Memory Location

```
.microai/agents/microai/teams/hacker-security/memory/
├── context.md      # Current engagement state
├── findings.md     # Cross-session findings (shared)
└── sessions.md     # Session history
```

### Memory Updates

```yaml
on_session_start:
  - Load context.md
  - Load recent findings.md

on_session_end:
  - Update context.md với session summary
  - Append new findings to findings.md
  - Log session to sessions.md
```

---

## Integration với Security-Engineer

Team này reuse Security-Engineer từ dev-security team:

```yaml
security_engineer:
  source: ../dev-security/agents/security-engineer.md
  knowledge: ../dev-security/knowledge/
  reuse:
    - OWASP Top 10 knowledge
    - Threat modeling (STRIDE)
    - Secure code review checklist
```

---

## Session Initialization Checklist

```
□ Mode detected from arguments
□ Both agents loaded
□ Team memory loaded
□ Welcome banner displayed
□ Target/scope collected via AskUserQuestion
□ Turn counter initialized
□ Ready for dialogue
```

---

## Quick Reference

### Start Commands

```bash
/microai:hacker-security-session              # Default pentest
/microai:hacker-security-session *pentest     # Explicit pentest
/microai:hacker-security-session *red-team    # Adversarial
/microai:hacker-security-session *threat-hunt # Gap analysis
```

### Observer Commands

| Command | Action |
|---------|--------|
| `@hacker: msg` | Inject as White Hacker |
| `@security: msg` | Inject as Security Engineer |
| `@guide: msg` | Facilitator note |
| `*focus: topic` | Change focus |
| `*skip` | Go to synthesis |
| `*exit` | End session |
