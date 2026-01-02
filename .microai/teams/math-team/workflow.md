# Math Team - Signal-Based Workflow

## Signal Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           MATH TEAM WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  INPUT                                                                       │
│    │  [User submits math problem]                                           │
│    │                                                                         │
│    ▼  signal: problem_received                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    PROBLEM ANALYZER                                  │    │
│  │  • Classify problem type (algebra/geometry/calculus/...)            │    │
│  │  • Assess difficulty (THPT/university/Olympic)                      │    │
│  │  • Identify 2-3 solution approaches                                 │    │
│  │  • Map approaches to solvers                                        │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│    │                                                                         │
│    ▼  signal: analysis_complete                                             │
│    │  payload: {approaches: [{solver: X, name: Y}, ...], difficulty: Z}     │
│    │                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    MAESTRO (Orchestrator)                            │   │
│  │  • Receives analysis                                                 │   │
│  │  • Selects 2-3 approaches based on difficulty and preferences       │   │
│  │  • Dispatches to parallel solver pool                               │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: solvers_dispatched                                            │
│    │  payload: {assignments: [{solver: algebraic, approach: ...}, ...]}     │
│    │                                                                         │
│    ├───────────────────┬───────────────────┬───────────────────┐            │
│    │                   │                   │                   │            │
│    ▼                   ▼                   ▼                   │            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐                │            │
│  │ SOLVER A   │  │ SOLVER B   │  │ SOLVER C   │   PARALLEL     │            │
│  │ (approach1)│  │ (approach2)│  │ (approach3)│   EXECUTION    │            │
│  └────────────┘  └────────────┘  └────────────┘                │            │
│    │                   │                   │                   │            │
│    ▼                   ▼                   ▼                   │            │
│  signal:           signal:            signal:                  │            │
│  solution_         solution_          solution_                │            │
│  complete          complete           complete                 │            │
│    │                   │                   │                   │            │
│    └───────────────────┴───────────────────┘                   │            │
│                        │                                        │            │
│                        ▼  sync: wait_all                        │            │
│                        │                                        │            │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    SYNTHESIZER                                       │   │
│  │  • Compare all solutions                                            │   │
│  │  • Verify correctness                                               │   │
│  │  • Score elegance and simplicity                                    │   │
│  │  • Select best approach                                             │   │
│  │  • Create comparison notes (if multiple valid solutions)            │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: synthesis_complete                                            │
│    │  payload: {best_solution: {...}, all_ranked: [...]}                   │
│    │                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    LATEX EDITOR                                      │   │
│  │  • Format solution in LaTeX                                         │   │
│  │  • Apply selected style (detailed/concise/olympiad)                 │   │
│  │  • Include Vietnamese support via XeLaTeX                           │   │
│  │  • Compile to PDF                                                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: document_ready                                                │
│    │  payload: {pdf_path: "...", tex_path: "..."}                          │
│    │                                                                         │
│  OUTPUT                                                                      │
│    └─► PDF Document                                                         │
│        (detailed OR concise OR olympiad style)                              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Signal Handlers

### On `problem_received`
```yaml
handler: activate_analyzer
actions:
  - load_knowledge: techniques/polya-method.md
  - activate: problem-analyzer
  - start_timer: analysis_timeout (60s)
```

### On `analysis_complete`
```yaml
handler: dispatch_solvers
actions:
  - validate: approaches.length >= 1
  - select_solvers: max 3 based on approaches
  - emit: solvers_dispatched
  - start_timer: solver_timeout (180s each)
```

### On `solution_complete`
```yaml
handler: collect_solution
actions:
  - store: solution in session.solutions[]
  - check: all_dispatched_complete?
  - if_complete: emit all_solutions_ready
```

### On `all_solutions_ready`
```yaml
handler: activate_synthesizer
actions:
  - activate: math-synthesizer
  - pass: all collected solutions
  - start_timer: synthesis_timeout (120s)
```

### On `synthesis_complete`
```yaml
handler: generate_output
actions:
  - activate: latex-editor
  - pass: best_solution, user_style_preference
  - start_timer: latex_timeout (60s)
```

### On `document_ready`
```yaml
handler: complete_session
actions:
  - emit: session_complete
  - log: session metrics
  - cleanup: temporary files
  - return: pdf_path to user
```

## Parallel Solver Execution

```yaml
parallel_execution:
  max_workers: 3

  solver_selection:
    by_difficulty:
      thpt: [algebraic, geometric]
      university: [calculus, algebraic, geometric]
      competition: [combinatorics, number-theory, algebraic]
      olympiad: [number-theory, combinatorics]

  sync_strategy: wait_all
  timeout_per_solver: 180000  # 3 minutes

  on_timeout:
    action: proceed_with_completed
    min_solutions: 1

  on_all_fail:
    action: notify_user
    offer: manual_intervention
```

## Observer Checkpoints

```markdown
CHECKPOINT 1: After Analysis
- View: identified approaches
- Commands: [continue] [add-approach] [skip]

CHECKPOINT 2: After Solvers Complete
- View: all solutions
- Commands: [synthesize] [extend-time] [add-solver]

CHECKPOINT 3: After Synthesis
- View: final answer
- Commands: [generate-pdf] [change-style] [show-all]

CHECKPOINT 4: After PDF
- View: output files
- Commands: [regenerate] [save] [new-problem]
```

## Error Handling

| Error | Handler |
|-------|---------|
| Analysis failed | Notify user, offer retry with hints |
| Solver timeout | Proceed with completed solutions |
| All solvers fail | Escalate to user, offer different approaches |
| LaTeX compile fail | Retry with fallback engine, notify on persist |
