# Team Workflow Template

Template chuẩn cho file `workflow.md` của team.

**Schema Reference:** `../../schemas/team-v1.0.schema.yaml`

---

## Template Selection

Chọn template phù hợp với loại team:

| Team Type | Template | Use Case |
|-----------|----------|----------|
| Pipeline | Full Template | Dev teams với multi-step workflow |
| Dialogue | Dialogue Template | 2 agents đối thoại |
| Thinking | Thinking Template | Collaborative analysis |

---

## FULL TEMPLATE (Pipeline Teams)

Sử dụng cho teams như `go-team`, `python-team`.

```yaml
---
name: {team_name}
description: AI Coding Team cho {domain} development - {brief purpose}
model: opus
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Task
output_folder: ./.microai/teams/{team_name}/logs
language: vi
color: "{hex_color}"

# Checkpoint system - Session recovery
checkpoint:
  enabled: true
  storage_path: ./.microai/teams/{team_name}/checkpoints
  git_integration: true
  auto_checkpoint: true

# Inter-agent communication
communication:
  enabled: true
  bus_path: ./.microai/teams/{team_name}/communication
  message_timeout_ms: 5000
  max_retries: 3
  topics:
    - requirements
    - architecture
    - code_change
    - testing
    - review
    - release

# Kanban tracking
kanban:
  enabled: true
  board_path: ./.microai/teams/{team_name}/kanban/board.yaml
  queue_path: ./.microai/teams/{team_name}/kanban/signal-queue.json
  sync_mode: semi_automatic
  signals:
    on_step_start: true
    on_step_complete: true
    on_agent_activate: true
  wip_enforcement: true
  commands:
    - "*board"
    - "*status"
    - "*metrics"

# Autonomous mode (optional)
autonomous:
  enabled: false
  level: balanced
  auto_approve:
    specs: true
    architecture: true
    code_changes: true
    security_low_medium: true
    security_high_critical: false
  thresholds:
    min_coverage: 80
    max_iterations: 3

# Parallel execution (optional)
parallel:
  enabled: false
  max_workers: 3
  parallelizable_groups:
    - name: quality_assurance
      steps: [step-05-testing, step-05b-security]
---

# {TEAM_NAME} Team Workflow

**Mục tiêu:** Điều phối team {N} agents để {main purpose}.

**Vai trò của bạn:** Bạn là Orchestrator Agent - điều phối workflow giữa các agents, phân tích yêu cầu user, đảm bảo handoff đúng thứ tự.

---

## TEAM MEMBERS

| Agent | Role | Icon | Focus |
|-------|------|------|-------|
| {agent_1_id} | {Role 1} | {emoji} | {focus areas} |
| {agent_2_id} | {Role 2} | {emoji} | {focus areas} |
| {agent_3_id} | {Role 3} | {emoji} | {focus areas} |
| ... | ... | ... | ... |

---

## WORKFLOW ARCHITECTURE

```
User Request
   ↓
┌─────────────────────────────────────────────────────────────┐
│ Step 01: Init - Load context, setup session                 │
├─────────────────────────────────────────────────────────────┤
│ Step 02: {Phase 1} - {Agent} {action}                       │
│    ═══════════════ [BREAKPOINT] ═══════════════            │
├─────────────────────────────────────────────────────────────┤
│ Step 03: {Phase 2} - {Agent} {action}                       │
│    ═══════════════ [BREAKPOINT] ═══════════════            │
├─────────────────────────────────────────────────────────────┤
│ Step 04: {Phase 3} - {Agent} {action}                       │
├─────────────────────────────────────────────────────────────┤
│ Step 05: {Phase 4} - {Agent} {action}                       │
├─────────────────────────────────────────────────────────────┤
│ Step 06: Review Loop (max 3 iterations)                     │
│    ┌──────────────────────────────────────────────────────┐ │
│    │ Reviewer → [Issues] → Fixer → Test → Reviewer        │ │
│    │ EXIT: All checks pass                                │ │
│    └──────────────────────────────────────────────────────┘ │
│    ═══════════════ [BREAKPOINT] ═══════════════            │
├─────────────────────────────────────────────────────────────┤
│ Step 07: {Final Phase} - {Agent} {action}                   │
├─────────────────────────────────────────────────────────────┤
│ Step 08: Synthesis - Final report and handoff               │
└─────────────────────────────────────────────────────────────┘
   ↓
Final Output
```

---

## CONFIGURATION

### Paths
```yaml
installed_path: "{project-root}/.microai/teams/{team_name}"
agents:
  {role_1}: "{installed_path}/agents/{role_1}-agent.md"
  {role_2}: "{installed_path}/agents/{role_2}-agent.md"
  ...
templates:
  {type}: "{installed_path}/templates/{type}-template.md"
output_path: "./docs/{team_name}/{date}-{topic}.md"
```

### Session State
```yaml
{team_name}_state:
  topic: ""
  date: "{{system_date}}"
  phase: "init"
  current_agent: null
  current_step: 1
  breakpoint_active: false

  config:
    max_iterations: 3
    min_coverage: 80

  iteration_count: 0

  outputs:
    {output_1}: null
    {output_2}: null

  quality_metrics:
    {metric_1}: false
    {metric_2}: 0

  history: []
```

---

## OBSERVER CONTROLS

### Basic Commands
| Command | Effect |
|---------|--------|
| `[Enter]` | Continue to next step/phase |
| `*pause` | Pause workflow for manual review |
| `*skip` | Skip current step |
| `*skip-to:<N>` | Jump to step N |
| `*exit` | End session, save progress |

### Agent Injection
| Command | Effect |
|---------|--------|
| `@{agent}: <msg>` | Inject message to agent |

### Checkpoint Commands
| Command | Effect |
|---------|--------|
| `*checkpoints` | List all checkpoints |
| `*rollback:<N>` | Rollback to checkpoint N |

### Kanban Commands
| Command | Effect |
|---------|--------|
| `*board` | Show kanban board |
| `*status` | Quick status |
| `*metrics` | Show metrics |

### Autonomous Mode
| Command | Effect |
|---------|--------|
| `*auto` | Enable autonomous mode |
| `*auto:off` | Disable autonomous mode |

---

## EXECUTION STEPS

### Step 1: Session Initialization
**Load:** `./steps/step-01-init.md`
**Actions:** ...

### Step 2: {Phase 1}
**Load:** `./steps/step-02-{phase}.md`
**Agent:** {Agent}
**Actions:** ...
**BREAKPOINT:** ...

[Continue for all steps...]

---

## ERROR HANDLING

### {Error Type 1}
- {How to handle}

### Max Iterations Reached
- Document current state
- Present options to observer

---

## EXIT CONDITIONS

### Normal Exit
- All steps completed
- All metrics pass
- Session log saved

### Early Exit (*exit)
- Save current progress
- Document incomplete items
```

---

## DIALOGUE TEMPLATE (2-Agent Teams)

Sử dụng cho teams như `dev-qa`, `pm-dev`.

```yaml
---
name: {team_name}
description: Dialogue team giữa {Agent 1} và {Agent 2} cho {purpose}
model: opus
tools:
  - Read
  - Write
output_folder: ./.microai/teams/{team_name}/logs
language: vi
color: "{hex_color}"

checkpoint:
  enabled: true
  storage_path: ./.microai/teams/{team_name}/checkpoints

communication:
  enabled: true
  topics:
    - dialogue
    - consensus
---

# {TEAM_NAME} Team Workflow

## Team Members

| Agent | Role | Icon |
|-------|------|------|
| {agent_1} | {Role 1} | {emoji} |
| {agent_2} | {Role 2} | {emoji} |

## Session Modes

| Mode | Trigger | First Speaker | Output |
|------|---------|---------------|--------|
| {mode_1} | {keywords} | {agent} | {output_type} |
| {mode_2} | {keywords} | {agent} | {output_type} |

## Workflow

1. Session Init
2. Topic Presentation
3. Dialogue Loop (until consensus)
4. Output Synthesis
5. Session Close

## Observer Controls

| Command | Action |
|---------|--------|
| `[Enter]` | Continue |
| `@{agent1}: <msg>` | Inject as Agent 1 |
| `@{agent2}: <msg>` | Inject as Agent 2 |
| `*skip` | Skip to synthesis |
| `*exit` | End session |
| `*auto` | Auto mode |
```

---

## Validation Checklist

Khi tạo team workflow:

- [ ] Frontmatter có đủ required fields (name, description, model, tools)
- [ ] Color là hex format (#XXXXXX)
- [ ] Checkpoint config đầy đủ
- [ ] Communication topics phù hợp với workflow
- [ ] Team members table có icon và focus
- [ ] Workflow diagram rõ ràng với breakpoints
- [ ] Observer controls đầy đủ
- [ ] Error handling được document
- [ ] Exit conditions rõ ràng
