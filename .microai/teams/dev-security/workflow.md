# Dev-Security Team Workflow

## Overview

Dev-Security team simulation facilitates dialogue giữa **Developer** và **Security Engineer** để:
- Security code review
- Threat modeling (STRIDE)
- Vulnerability assessment

## Team Members

| Agent | Role | Focus |
|-------|------|-------|
| 🔒 Security Engineer | Security expert | Vulnerabilities, threats, OWASP |
| 👨‍💻 Developer | Implementation expert | Code fixes, security implementation |

## Session Modes

### Review Mode (default)
```
Purpose: Security-focused code review
Flow: Dev presents code → Security reviews → Findings → Fixes
Output: Security Review Report
```

### Threat Model Mode
```
Purpose: STRIDE-based threat modeling
Flow: Dev presents system → Security applies STRIDE → Mitigations
Output: Threat Model Document
```

### Vulnerability Mode
```
Purpose: Vulnerability assessment
Flow: Define scope → Assess → Findings → Remediation
Output: Vulnerability Assessment Report
```

## Workflow Steps

```
┌─────────────────────────────────────────────────────────────────┐
│                    Dev-Security Session Flow                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Session Init                                           │
│    ├── Detect mode (review/threat-model/vulnerability)          │
│    ├── Load agents và knowledge                                 │
│    └── Display welcome banner                                   │
│                                                                  │
│  Step 2: Scope Definition                                       │
│    ├── [review] Developer presents code/feature                 │
│    ├── [threat-model] Developer presents system                 │
│    └── [vulnerability] Security defines scope                   │
│                                                                  │
│  Step 3: Dialogue Loop                                          │
│    ├── Turn-based security analysis                             │
│    ├── Findings tracking                                        │
│    ├── Fix discussion                                           │
│    └── Observer controls                                        │
│                                                                  │
│  Step 4: Output Synthesis                                       │
│    ├── Generate security report                                 │
│    ├── Compile findings                                         │
│    └── Sign-off process                                         │
│                                                                  │
│  Step 5: Session Close                                          │
│    ├── Save to .microai/docs/teams/dev-security/logs/           │
│    ├── Update team memory                                       │
│    └── Display summary                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Knowledge Loading

### By Mode
| Mode | Auto-Load |
|------|-----------|
| review | secure-code-review, owasp-top-10 |
| threat-model | threat-modeling, owasp-top-10 |
| vulnerability | owasp-top-10, secure-code-review |

### By Keywords
- `injection`, `xss`, `authentication` → owasp-top-10
- `stride`, `threat`, `risk` → threat-modeling
- `review`, `code`, `vulnerability` → secure-code-review

## Observer Commands

| Command | Effect |
|---------|--------|
| `@security: <msg>` | Inject as Security Engineer |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Focus on specific area |
| `*owasp: <category>` | Focus on OWASP category |
| `*auto` | Auto-continue mode |
| `*manual` | Manual mode (default) |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Severity Levels

| Level | Description | Action |
|-------|-------------|--------|
| Critical | Remote code execution, auth bypass | Immediate fix |
| High | Significant data exposure, privilege escalation | Fix within 24h |
| Medium | Limited exposure, requires auth | Fix within sprint |
| Low | Minor issues, defense in depth | Backlog |
| Info | Best practices, hardening | Optional |

## Output Paths

```
.microai/docs/teams/dev-security/logs/
├── 2024-01-15-review-payment-api.md
├── 2024-01-15-threat-model-auth-system.md
└── 2024-01-15-vulnerability-user-portal.md
```

## Usage

### Start Session
```
/microai:dev-security-session review payment processing code
/microai:dev-security-session threat-model: authentication system
/microai:dev-security-session vulnerability assessment user portal
```

### Mode Triggers
- `*review` or default → Review Mode
- `*threat-model` or topic contains "threat", "stride" → Threat Model Mode
- `*vulnerability` or topic contains "assessment", "pentest" → Vulnerability Mode

## Memory System

- **context.md**: Active project state, statistics
- **learnings.md**: Vulnerability patterns discovered
- **sessions.md**: Session history summaries
- **checkpoints/**: Resume capability

## Best Practices

### For Effective Security Reviews
1. Provide code context and dependencies
2. List security measures already in place
3. Identify areas of concern
4. Be open to findings

### For Threat Modeling
1. Draw clear data flow diagrams
2. Identify all trust boundaries
3. List all entry points
4. Consider all STRIDE categories

### For Developers
1. Don't be defensive about findings
2. Ask clarifying questions
3. Propose practical fixes
4. Learn from patterns
