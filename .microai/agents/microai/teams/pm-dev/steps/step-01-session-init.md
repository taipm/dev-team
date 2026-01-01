# Step 01: Session Initialization

## Objective
Khởi tạo session, detect mode, load agents và knowledge.

## Mode Detection

### Requirements Mode (default)
```yaml
triggers:
  - "*requirements" hoặc "*req"
  - Topic chứa: "requirement", "story", "feature", "user"
  - Default nếu không match mode khác
```

### Tech Spec Mode
```yaml
triggers:
  - "*tech-spec" hoặc "*spec"
  - Topic chứa: "spec", "technical", "design", "implement"
```

### Estimation Mode
```yaml
triggers:
  - "*estimation" hoặc "*estimate"
  - Topic chứa: "estimate", "timeline", "effort", "planning"
```

## Initialization Flow

```
1. Parse topic và detect mode
2. Generate session_id: pmdev-{YYYY-MM-DD}-{sequence}
3. Load agents: product-manager, developer
4. Load knowledge based on mode
5. Initialize checkpoint
6. Display welcome banner
7. Set turn_count = 0
```

## Welcome Banners

### Requirements Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              PM-DEV SESSION: REQUIREMENTS 📋                   ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Requirements Refinement                                 ║
║  Flow: PM presents → Dev clarifies → Refine → Document        ║
╚═══════════════════════════════════════════════════════════════╝
```

### Tech Spec Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              PM-DEV SESSION: TECH SPEC 📝                      ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Technical Specification                                 ║
║  Flow: Requirements → Design → Estimate → Document            ║
╚═══════════════════════════════════════════════════════════════╝
```

### Estimation Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              PM-DEV SESSION: ESTIMATION ⏱️                     ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                 ║
║  Mode: Effort Estimation                                       ║
║  Flow: Scope → Breakdown → Estimate → Confidence              ║
╚═══════════════════════════════════════════════════════════════╝
```

## Session State Initialization

```yaml
session:
  id: "pmdev-{date}-{seq}"
  mode: "{requirements|tech-spec|estimation}"
  topic: "{parsed_topic}"
  start_time: "{timestamp}"
  turn_count: 0
  current_speaker: null

agents:
  pm:
    loaded: true
    turns: 0
  developer:
    loaded: true
    turns: 0

knowledge:
  loaded: []
  pending: []

artifacts:
  stories: []
  specs: []
  estimates: []

checkpoint:
  path: "memory/checkpoints/{session_id}.yaml"
  created: "{timestamp}"
```

## Knowledge Auto-Loading

### Requirements Mode
- user-story-guide.md

### Tech Spec Mode
- technical-spec-guide.md
- estimation-techniques.md

### Estimation Mode
- estimation-techniques.md

## Next Step

→ Proceed to **step-02-topic-presentation.md**
