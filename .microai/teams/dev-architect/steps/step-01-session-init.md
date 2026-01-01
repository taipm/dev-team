# Step 01: Session Initialization

## Objective
Khởi tạo session, detect mode, load agents và knowledge.

## Mode Detection

### Design Mode (default)
```yaml
triggers:
  - "*design"
  - Topic chứa: "design", "architect", "build", "create", "new"
  - Default nếu không match mode khác
```

### Review Mode
```yaml
triggers:
  - "*review"
  - Topic chứa: "review", "evaluate", "assess", "check"
```

### ADR Mode
```yaml
triggers:
  - "*adr"
  - Topic chứa: "adr", "decision", "document", "record"
```

## Initialization Flow

```
1. Parse topic và detect mode
2. Generate session_id: arch-{YYYY-MM-DD}-{sequence}
3. Load agents: solution-architect, developer
4. Load knowledge based on mode
5. Initialize checkpoint
6. Display welcome banner
7. Set turn_count = 0
```

## Welcome Banners

### Design Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-ARCHITECT SESSION: DESIGN 🏗️                 ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Mode: System Design                                           ║
║  Flow: Dev presents → Arch proposes → Discuss → ADR           ║
╚═══════════════════════════════════════════════════════════════╝
```

### Review Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-ARCHITECT SESSION: REVIEW 🔍                  ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Mode: Architecture Review                                     ║
║  Flow: Dev presents → Arch reviews → Feedback → Sign-off      ║
╚═══════════════════════════════════════════════════════════════╝
```

### ADR Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-ARCHITECT SESSION: ADR 📝                     ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Mode: Architecture Decision Record                            ║
║  Flow: Context → Options → Discuss → Document Decision        ║
╚═══════════════════════════════════════════════════════════════╝
```

## Session State Initialization

```yaml
session:
  id: "arch-{date}-{seq}"
  mode: "{design|review|adr}"
  topic: "{parsed_topic}"
  start_time: "{timestamp}"
  turn_count: 0
  current_speaker: null

agents:
  architect:
    loaded: true
    turns: 0
  developer:
    loaded: true
    turns: 0

knowledge:
  loaded: []
  pending: []

checkpoint:
  path: "memory/checkpoints/{session_id}.yaml"
  created: "{timestamp}"
```

## Knowledge Auto-Loading

### Design Mode
- architecture-patterns.md
- adr-guide.md

### Review Mode
- system-design-checklist.md
- adr-guide.md

### ADR Mode
- adr-guide.md
- architecture-patterns.md (context)

## Next Step

→ Proceed to **step-02-topic-presentation.md**
