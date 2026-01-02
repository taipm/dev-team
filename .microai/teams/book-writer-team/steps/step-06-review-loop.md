# Step 06: Review Loop

## Agent
🔎 **Reviewer Agent** - Technical & Quality Reviewer (leads loop)

## Trigger
Step 05 hoàn thành, editing complete

## Loop Configuration
```yaml
max_iterations: 3
exit_condition: all_quality_gates_pass
involved_agents:
  - reviewer-agent (lead)
  - writer-agent (fixes content)
  - editor-agent (polishes fixes)
```

## Actions

### 1. Activate Reviewer Agent
```
Load: ./agents/reviewer-agent.md
Load knowledge: ./knowledge/reviewer/review-checklist.md
Receive: Edited chapters from Step 05
Update state: current_agent = "reviewer"
```

### 2. Technical Review
```
For each chapter:
1. Verify technical accuracy
2. Check learning progression
3. Test code examples
4. Validate exercises
5. Check completeness
6. Score quality (0-100)
```

### 3. Quality Gate Evaluation
```
QUALITY GATES:
□ Technical Accuracy - All claims verified
□ Code Correctness - All examples work
□ Learning Progression - Logical flow
□ Completeness - All objectives covered
□ Exercise Quality - Solutions correct
□ Readability - Clear and engaging
```

### 4. Create Review Report

```
🔎 **REVIEW REPORT - Iteration {N}**

══════════════════════════════════════════════════════════════

OVERALL QUALITY SCORE: {0-100}
STATUS: {Pass / Needs Revision / Fail}

QUALITY GATES:
[✓] Technical Accuracy
[✓] Code Correctness
[?] Learning Progression - Minor gaps
[✓] Completeness
[✓] Exercise Quality
[✓] Readability

──────────────────────────────────────────────────────────────

CRITICAL ISSUES ({count}):

1. [CRITICAL] {Issue Title}
   Location: Chapter {N}, Section {X}
   Problem: {Description}
   Impact: {How this affects readers}
   Suggested Fix: {Recommendation}

──────────────────────────────────────────────────────────────

MAJOR ISSUES ({count}):
[...]

MINOR ISSUES ({count}):
[...]

──────────────────────────────────────────────────────────────

CODE VALIDATION:
| Example | Tested | Result | Notes |
|---------|--------|--------|-------|
| Ch1-Ex1 | ✓      | Pass   |       |
| Ch2-Ex3 | ✓      | Fail   | {err} |

══════════════════════════════════════════════════════════════
```

### 5. Review Loop Logic

```
IF critical_issues > 0 OR major_issues > 0:
    IF iteration_count < max_iterations:
        → Route to Writer Agent for fixes
        → Route fixed content to Editor Agent for polish
        → Return to Reviewer Agent (iteration++)
    ELSE:
        → Document unresolved issues
        → Present to observer for decision
ELSE:
    → All quality gates pass
    → Proceed to Step 07
```

### 6. BREAKPOINT (After Review)
```
═══════════════════════════════════════════════════════════════
                       [BREAKPOINT]
═══════════════════════════════════════════════════════════════

Review quality assessment above.

QUALITY SCORE: {score}/100
STATUS: {status}

ACTIONS:
- [Enter] - {Approve / Continue to next iteration}
- @reviewer: <feedback> - Add reviewer guidance
- @writer: <fix request> - Direct fix to writer
- *force-pass - Force pass quality gates
- *exit - End session

═══════════════════════════════════════════════════════════════
```

## Loop Iteration Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    REVIEW LOOP                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│    ┌─────────────┐                                         │
│    │  Reviewer   │ ──── Issues Found? ──────┐              │
│    │   Reviews   │                          │              │
│    └─────────────┘                          │              │
│          ↑                                  ↓              │
│          │                           ┌───────────┐         │
│          │                           │  Writer   │         │
│          │                           │   Fixes   │         │
│          │                           └─────┬─────┘         │
│          │                                 │               │
│          │                                 ↓               │
│          │                           ┌───────────┐         │
│          │                           │  Editor   │         │
│          └─────────────────────────── │ Polishes │         │
│                                       └───────────┘         │
│                                                             │
│    EXIT: All quality gates pass OR max iterations          │
└─────────────────────────────────────────────────────────────┘
```

## Communication
```yaml
publishes:
  topic: review
  message:
    type: review_complete
    data:
      quality_score: {0-100}
      status: "pass" | "needs_revision"
      issues: [{issue list}]
```

## Output
```yaml
outputs:
  review_report:
    path: "./docs/books/{book_name}/review-report.md"
    quality_score: {0-100}
    iterations: {count}
    status: "pass"

quality_metrics:
  review_pass: true
```

## Checkpoint
```
./checkpoints/step-06-review-{iteration}-{timestamp}.yaml
```

## Next Step
→ Step 07: Publishing (Publisher Agent)
