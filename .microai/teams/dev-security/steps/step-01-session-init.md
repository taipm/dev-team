# Step 01: Session Initialization

## Objective
Khởi tạo session, detect mode, load agents và knowledge.

## Mode Detection

### Review Mode (default)
```yaml
triggers:
  - "*review"
  - Topic chứa: "review", "code", "check"
  - Default nếu không match mode khác
```

### Threat Model Mode
```yaml
triggers:
  - "*threat-model" hoặc "*threat"
  - Topic chứa: "threat", "model", "risk", "stride"
```

### Vulnerability Assessment Mode
```yaml
triggers:
  - "*vulnerability" hoặc "*vuln"
  - Topic chứa: "vulnerability", "pentest", "assessment", "owasp"
```

## Initialization Flow

```
1. Parse topic và detect mode
2. Generate session_id: sec-{YYYY-MM-DD}-{sequence}
3. Load agents: security-engineer, developer
4. Load knowledge based on mode
5. Initialize checkpoint
6. Display welcome banner
7. Set turn_count = 0
```

## Welcome Banners

### Review Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-SECURITY SESSION: CODE REVIEW 🔒              ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Security Code Review                                    ║
║  Flow: Dev presents → Security reviews → Findings → Fixes     ║
╚═══════════════════════════════════════════════════════════════╝
```

### Threat Model Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-SECURITY SESSION: THREAT MODEL 🎯             ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Threat Modeling (STRIDE)                                ║
║  Flow: DFD → Threats → Risk Assessment → Mitigations          ║
╚═══════════════════════════════════════════════════════════════╝
```

### Vulnerability Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-SECURITY SESSION: VULNERABILITY 🔍            ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Vulnerability Assessment                                ║
║  Flow: Scope → Assessment → Findings → Remediation            ║
╚═══════════════════════════════════════════════════════════════╝
```

## Session State Initialization

```yaml
session:
  id: "sec-{date}-{seq}"
  mode: "{review|threat-model|vulnerability}"
  topic: "{parsed_topic}"
  start_time: "{timestamp}"
  turn_count: 0
  current_speaker: null

agents:
  security:
    loaded: true
    turns: 0
  developer:
    loaded: true
    turns: 0

knowledge:
  loaded: []
  pending: []

findings:
  critical: 0
  high: 0
  medium: 0
  low: 0
  info: 0

checkpoint:
  path: "memory/checkpoints/{session_id}.yaml"
  created: "{timestamp}"
```

## Knowledge Auto-Loading

### Review Mode
- secure-code-review.md
- owasp-top-10.md

### Threat Model Mode
- threat-modeling.md
- owasp-top-10.md (for reference)

### Vulnerability Mode
- owasp-top-10.md
- secure-code-review.md

## Next Step

→ Proceed to **step-02-scope-definition.md**
