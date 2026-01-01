# Step 01: Session Initialization

## Objective
Khởi tạo dev-qa session với mode phù hợp và load agents cần thiết.

## Mode Detection

### Auto-Detect từ Topic

```yaml
mode_detection:
  testplan:
    triggers:
      - keyword: "*testplan"
      - pattern: "test.*feature"
      - pattern: "create.*test"
      - pattern: "plan.*testing"
      - default: true  # Default mode nếu không match others

  bug:
    triggers:
      - keyword: "*bug"
      - pattern: "bug:.*"
      - pattern: "issue:.*"
      - pattern: "error.*"
      - pattern: "fail.*"
      - pattern: "broken.*"

  review:
    triggers:
      - keyword: "*review"
      - pattern: "review:.*"
      - pattern: "PR.*"
      - pattern: "pull request.*"
      - pattern: "code.*review"
```

### Manual Mode Override
User có thể force mode bằng prefix:
- `*testplan: [topic]` → Test Plan mode
- `*bug: [topic]` → Bug Triage mode
- `*review: [topic]` → Code Review mode

## Initialization Flow

```
1. Parse topic và detect mode
2. Load agent personas:
   - qa-engineer.md
   - developer.md
3. Load relevant knowledge (based on mode)
4. Load team memory (context.md)
5. Initialize session state
6. Display welcome banner
7. Set initial speaker based on mode
```

## Session State

```yaml
session:
  id: "{uuid}"
  mode: "testplan" | "bug" | "review"
  topic: "{topic}"
  started_at: "{ISO_timestamp}"
  turn_count: 0
  phase: "init"
  current_speaker: null
  dialogue_mode: "manual"  # manual | auto | semi-auto
  dialogue_history: []
  key_decisions: []
  artifacts: []
```

## Welcome Banners

### Test Plan Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-QA SESSION: TEST PLANNING 📋                  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Topic: {topic}                                                 ║
║  Mode: Test Plan Creation                                       ║
║                                                                 ║
║  Flow:                                                          ║
║    1. Dev presents feature/requirements                        ║
║    2. QA asks about scope, risks, edge cases                   ║
║    3. Together create test scenarios                           ║
║    4. Output: Test Plan with Test Cases                        ║
║                                                                 ║
║  Observer Controls:                                             ║
║    [Enter] continue | @qa/@dev: inject | *skip/*exit           ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

### Bug Triage Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-QA SESSION: BUG TRIAGE 🐛                     ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Topic: {topic}                                                 ║
║  Mode: Bug Triage                                               ║
║                                                                 ║
║  Flow:                                                          ║
║    1. QA presents bug report                                   ║
║    2. Dev analyzes and asks questions                          ║
║    3. Agree on severity, priority, fix approach                ║
║    4. Output: Bug Report with Fix Plan                         ║
║                                                                 ║
║  Observer Controls:                                             ║
║    [Enter] continue | @qa/@dev: inject | *skip/*exit           ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

### Code Review Mode
```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-QA SESSION: CODE REVIEW 🔍                    ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Topic: {topic}                                                 ║
║  Mode: Code Review + QA                                         ║
║                                                                 ║
║  Flow:                                                          ║
║    1. Dev presents code changes                                ║
║    2. QA reviews from testability perspective                  ║
║    3. Discuss edge cases, error handling, coverage             ║
║    4. Output: Review Report with QA Sign-off                   ║
║                                                                 ║
║  Observer Controls:                                             ║
║    [Enter] continue | @qa/@dev: inject | *skip/*exit           ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

## Initial Speaker by Mode

| Mode | First Speaker | Reason |
|------|---------------|--------|
| testplan | Developer | Dev presents feature to test |
| bug | QA Engineer | QA presents bug report |
| review | Developer | Dev presents code changes |

## Knowledge Loading by Mode

```yaml
mode_knowledge:
  testplan:
    load: ["01-testing-strategies.md"]
    on_demand: ["03-testability-review.md"]

  bug:
    load: ["02-bug-reporting-guide.md"]
    on_demand: ["01-testing-strategies.md"]

  review:
    load: ["03-testability-review.md"]
    on_demand: ["01-testing-strategies.md", "02-bug-reporting-guide.md"]
```

## Checkpoint Creation

After init, create first checkpoint:

```yaml
checkpoint:
  session_id: "{uuid}"
  step: "step-01-session-init"
  timestamp: "{ISO_timestamp}"
  state:
    mode: "{mode}"
    topic: "{topic}"
    agents_loaded: true
    knowledge_loaded: true
    ready_for_dialogue: true
```

## Transition

→ After welcome banner displayed:
  - If mode = testplan → Step 02 với Dev as first speaker
  - If mode = bug → Step 02 với QA as first speaker
  - If mode = review → Step 02 với Dev as first speaker
