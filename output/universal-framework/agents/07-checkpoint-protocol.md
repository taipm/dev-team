# CHECKPOINT & SAVE PROTOCOL

> Quy trình bắt buộc lưu kết quả sau mỗi giai đoạn quan trọng.

---

## CORE PRINCIPLE

```
EVERY SIGNIFICANT WORK MUST BE PERSISTED

"Nếu không được lưu, coi như chưa làm"
```

**Lý do:**
1. **Traceability** - Có thể trace lại quyết định
2. **Resumability** - Có thể resume nếu bị interrupt
3. **Auditability** - Có thể review và học từ quá khứ
4. **Collaboration** - Người khác có thể tiếp tục

---

## CHECKPOINT TRIGGERS

### Mandatory Checkpoints (PHẢI save)

| Trigger | What to Save | Location |
|---------|--------------|----------|
| Phase complete | Phase output YAML | `{project}/phases/` |
| Task complete | Task result | `{project}/tasks/` |
| Decision made | Decision record | `{project}/decisions/` |
| Error/Block | Error log | `{project}/logs/` |
| Session end | Session summary | `{project}/sessions/` |

### Optional Checkpoints (NÊN save)

| Trigger | What to Save | Location |
|---------|--------------|----------|
| Every 30 mins | Progress snapshot | `{project}/snapshots/` |
| Before risky action | Rollback point | `{project}/rollback/` |
| Insight discovered | Insight record | `{project}/insights/` |

---

## DIRECTORY STRUCTURE

```
{project_name}/
├── README.md                    # Project overview
├── config.yaml                  # Project configuration
│
├── phases/                      # Phase outputs (mandatory)
│   ├── 00-define/
│   │   ├── okr.yaml            # OKR definition
│   │   └── sol-estimate.yaml   # Speed of Light
│   ├── 01-decompose/
│   │   ├── tasks.yaml          # All atomic tasks
│   │   └── dependencies.yaml   # Dependency graph
│   ├── 02-prioritize/
│   │   ├── priority-matrix.yaml
│   │   └── mvp-scope.yaml
│   ├── 03-sequence/
│   │   ├── execution-plan.yaml
│   │   └── timeline.yaml
│   ├── 04-execute/
│   │   └── progress.yaml       # Updated continuously
│   └── 05-review/
│       ├── metrics.yaml
│       └── learnings.yaml
│
├── tasks/                       # Individual task results
│   ├── TASK-001/
│   │   ├── input.yaml
│   │   ├── output/             # Actual deliverables
│   │   └── result.yaml         # Execution result
│   ├── TASK-002/
│   └── ...
│
├── decisions/                   # Decision records
│   ├── DEC-001-tech-stack.yaml
│   └── DEC-002-scope-change.yaml
│
├── logs/                        # Execution logs
│   ├── execution.log
│   ├── errors.log
│   └── blocked.log
│
├── sessions/                    # Session summaries
│   ├── 2026-01-04-session-1.md
│   └── 2026-01-05-session-2.md
│
├── snapshots/                   # Progress snapshots
│   ├── snapshot-2026-01-04-1400.yaml
│   └── snapshot-2026-01-04-1600.yaml
│
└── deliverables/               # Final outputs
    ├── src/                    # Code (if applicable)
    ├── docs/                   # Documentation
    └── assets/                 # Other assets
```

---

## SAVE PROTOCOLS BY PHASE

### Phase 0: DEFINE - Save Protocol

```yaml
# After DEFINER completes, MUST save:

save_checkpoint:
  phase: "00-define"

  files:
    - path: "phases/00-define/okr.yaml"
      content: |
        objective: "{objective}"
        key_results:
          - id: KR1
            description: "{kr1}"
            target: {target}
            deadline: "{date}"
          - id: KR2
            ...
          - id: KR3
            ...

    - path: "phases/00-define/sol-estimate.yaml"
      content: |
        speed_of_light:
          value: {hours}
          unit: "hours"
          breakdown:
            - item: "{item1}"
              hours: {h1}
            - item: "{item2}"
              hours: {h2}
          assumptions:
            - "{assumption1}"
            - "{assumption2}"

    - path: "phases/00-define/phase-complete.yaml"
      content: |
        phase: "define"
        status: "complete"
        completed_at: "{timestamp}"
        duration_minutes: {duration}
        next_phase: "decompose"

  verify:
    - "okr.yaml exists and valid"
    - "sol-estimate.yaml exists"
    - "phase-complete.yaml logged"
```

### Phase 1: DECOMPOSE - Save Protocol

```yaml
save_checkpoint:
  phase: "01-decompose"

  files:
    - path: "phases/01-decompose/tasks.yaml"
      content: |
        tasks:
          - id: "TASK-001"
            name: "{name}"
            type: "{type}"
            estimated_hours: {hours}
            input: {...}
            output: {...}
            verify: {...}
          - id: "TASK-002"
            ...

        summary:
          total_tasks: {n}
          total_hours: {h}

    - path: "phases/01-decompose/dependencies.yaml"
      content: |
        dependency_graph:
          nodes: ["{task_ids}"]
          edges:
            - from: "TASK-001"
              to: "TASK-002"
              reason: "{reason}"
          entry_points: ["{no_dependency_tasks}"]
          exit_points: ["{no_dependent_tasks}"]

    - path: "phases/01-decompose/phase-complete.yaml"
      content: |
        phase: "decompose"
        status: "complete"
        completed_at: "{timestamp}"
        tasks_created: {n}

  verify:
    - "All tasks have id, name, input, output, verify"
    - "All tasks ≤ 2 hours"
    - "No circular dependencies"
```

### Phase 2: PRIORITIZE - Save Protocol

```yaml
save_checkpoint:
  phase: "02-prioritize"

  files:
    - path: "phases/02-prioritize/priority-matrix.yaml"
      content: |
        prioritized_tasks:
          must_do:
            - task_id: "TASK-001"
              impact: 5
              effort: 2
              priority_score: 2.5
            ...
          should_do: [...]
          could_do: [...]
          eliminate: [...]

    - path: "phases/02-prioritize/mvp-scope.yaml"
      content: |
        mvp:
          tasks: ["{mvp_task_ids}"]
          estimated_hours: {h}
          krs_covered:
            - kr_id: "KR1"
              coverage: "full" | "partial" | "core"
          rationale: "{why_these_tasks}"

  verify:
    - "Every task has priority score"
    - "MVP defined"
    - "80/20 split visible"
```

### Phase 3: SEQUENCE - Save Protocol

```yaml
save_checkpoint:
  phase: "03-sequence"

  files:
    - path: "phases/03-sequence/execution-plan.yaml"
      content: |
        execution_plan:
          sequence:
            - step: 1
              tasks: ["TASK-001"]
              parallel: false
              start_hour: 0
              end_hour: 1.5
            - step: 2
              tasks: ["TASK-002", "TASK-003"]
              parallel: true
              ...
          critical_path:
            tasks: ["{critical_task_ids}"]
            duration: {hours}

    - path: "phases/03-sequence/timeline.yaml"
      content: |
        timeline:
          total_hours: {h}
          milestones:
            - name: "MVP Complete"
              after_step: {n}
              hour: {h}
            - name: "Full Complete"
              after_step: {n}
              hour: {h}

  verify:
    - "All tasks in sequence"
    - "Dependencies respected"
    - "Critical path identified"
```

### Phase 4: EXECUTE - Save Protocol (Per Task)

```yaml
save_checkpoint:
  phase: "04-execute"
  trigger: "after_each_task"

  files:
    # Task-specific result
    - path: "tasks/{TASK_ID}/result.yaml"
      content: |
        task_id: "{TASK_ID}"
        status: "COMPLETED" | "FAILED" | "BLOCKED"
        started_at: "{timestamp}"
        completed_at: "{timestamp}"
        actual_hours: {h}

        output:
          deliverable: "{description}"
          location: "{path_to_output}"

        verification:
          criteria_passed: [{list}]
          criteria_failed: [{list}]

        quality:
          score: {0-100}

        notes: "{observations}"

    # Task deliverables
    - path: "tasks/{TASK_ID}/output/"
      content: "{actual deliverable files}"

    # Update overall progress
    - path: "phases/04-execute/progress.yaml"
      content: |
        progress:
          total_tasks: {n}
          completed: {n}
          in_progress: {n}
          blocked: {n}
          failed: {n}

          completion_rate: {%}
          current_step: {n}

          last_updated: "{timestamp}"

  verify:
    - "Task result saved"
    - "Deliverable saved to output/"
    - "Progress.yaml updated"
```

### Phase 5: REVIEW - Save Protocol

```yaml
save_checkpoint:
  phase: "05-review"

  files:
    - path: "phases/05-review/metrics.yaml"
      content: |
        metrics:
          time:
            speed_of_light: {h}
            actual: {h}
            sol_ratio: {ratio}
          quality:
            completion_rate: {%}
            rework_rate: {%}
            avg_quality_score: {score}
          efficiency:
            estimation_accuracy: {%}

    - path: "phases/05-review/learnings.yaml"
      content: |
        learnings:
          what_worked: [...]
          what_didnt: [...]
          patterns: [...]
          recommendations: [...]

    - path: "phases/05-review/final-report.md"
      content: |
        # Project Report: {project_name}

        ## Executive Summary
        ...

        ## KR Achievement
        ...

        ## Metrics
        ...

        ## Learnings
        ...

        ## Next Steps
        ...
```

---

## SAVE COMMANDS

### For Agents (Include in every agent prompt)

```markdown
## MANDATORY: Save Protocol

After completing your work, you MUST:

1. **Save your output** to the designated location
2. **Update progress.yaml** if in execute phase
3. **Log completion** to phase-complete.yaml

Use this format:

\```
CHECKPOINT: {phase_name}
STATUS: complete
OUTPUT_SAVED: {file_path}
TIMESTAMP: {ISO timestamp}
\```

DO NOT proceed to next phase until checkpoint is confirmed.
```

### For Orchestrator

```yaml
orchestrator_save_rules:
  before_phase:
    - verify previous phase checkpoint exists
    - load previous phase outputs

  after_phase:
    - verify all required files saved
    - validate file contents
    - log phase completion
    - emit checkpoint_complete event

  on_error:
    - save error to logs/errors.log
    - save current state to snapshots/
    - mark phase as "incomplete" with error details

  on_interrupt:
    - save current progress immediately
    - create resumption point
    - log "INTERRUPTED" status
```

---

## RESUMPTION PROTOCOL

### How to Resume from Checkpoint

```yaml
resume_protocol:
  steps:
    1. Find latest checkpoint:
       - Check phases/ for phase-complete.yaml files
       - Find last completed phase

    2. Load state:
       - Read all outputs from completed phases
       - Read progress.yaml if in execute phase

    3. Identify resume point:
       - If mid-phase: continue from last task
       - If between phases: start next phase

    4. Validate state:
       - Verify all referenced files exist
       - Verify data integrity

    5. Resume execution:
       - Load context from saved state
       - Continue from identified point

  example:
    # Find where we left off
    last_checkpoint: "phases/02-prioritize/phase-complete.yaml"
    resume_from: "Phase 3: SEQUENCE"

    # Load context
    load_files:
      - "phases/00-define/okr.yaml"
      - "phases/01-decompose/tasks.yaml"
      - "phases/02-prioritize/mvp-scope.yaml"

    # Continue
    next_action: "Run SEQUENCER agent with loaded context"
```

---

## QUICK REFERENCE: Save Triggers

```
┌─────────────────────────────────────────────────────────────┐
│                    WHEN TO SAVE                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ Phase complete      → phases/{phase}/phase-complete.yaml│
│  ✅ Task complete       → tasks/{TASK_ID}/result.yaml       │
│  ✅ Decision made       → decisions/DEC-{n}-{topic}.yaml    │
│  ✅ Error occurred      → logs/errors.log                   │
│  ✅ Session ending      → sessions/{date}-session.md        │
│  ✅ Every 30 minutes    → snapshots/snapshot-{timestamp}.yaml│
│  ✅ Before risky action → rollback/pre-{action}.yaml        │
│                                                             │
│  ❌ NEVER skip saving phase outputs                         │
│  ❌ NEVER proceed without verifying save                    │
│  ❌ NEVER overwrite without backup                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## VALIDATION CHECKLIST

Before marking any phase complete:

```
□ Output file exists at correct path?
□ Output file has valid YAML/JSON syntax?
□ All required fields present?
□ Timestamps recorded?
□ Previous phase outputs still intact?
□ Progress.yaml updated (if applicable)?
□ Checkpoint logged?
```

---

*"Không save = Không làm. Save thường xuyên = Không bao giờ mất công."*
