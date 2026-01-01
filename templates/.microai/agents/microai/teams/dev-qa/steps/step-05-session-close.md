# Step 05: Session Close

## Objective
Lưu output, update memory, và close session.

## Close Flow

```
1. Generate session summary
2. Save output document to docs/qa/logs/
3. Update team memory
4. Archive checkpoint
5. Display final summary
6. End session
```

## Session Summary Generation

```markdown
╔═══════════════════════════════════════════════════════════════╗
║                    SESSION COMPLETE ✅                         ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Session ID: {session_id}                                       ║
║  Mode: {testplan/bug/review}                                   ║
║  Topic: {topic}                                                 ║
║                                                                 ║
║  Statistics:                                                    ║
║    • Total turns: {turn_count}                                 ║
║    • Duration: {duration}                                       ║
║    • Dialogue mode: {manual/auto/semi-auto}                    ║
║                                                                 ║
║  Output:                                                        ║
║    • Type: {Test Plan/Bug Report/Review Report}                ║
║    • Saved to: logs/{filename}.md                              ║
║                                                                 ║
║  Key Decisions:                                                 ║
║    1. {decision_1}                                             ║
║    2. {decision_2}                                             ║
║                                                                 ║
║  Sign-off:                                                      ║
║    ✅ QA Engineer: Approved                                     ║
║    ✅ Developer: Approved                                       ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

## Save Output Document

### File Naming Convention
```
docs/qa/logs/{YYYY-MM-DD}-{mode}-{topic-slug}.md

Examples:
- docs/qa/logs/2024-01-15-testplan-user-authentication.md
- docs/qa/logs/2024-01-15-bug-login-safari-500-error.md
- docs/qa/logs/2024-01-15-review-pr-123-payment-refactor.md
```

### Output File Structure
```markdown
---
session_id: "{uuid}"
mode: "{mode}"
topic: "{topic}"
date: "{YYYY-MM-DD}"
participants:
  - qa-engineer
  - developer
turns: {turn_count}
status: completed
sign_offs:
  qa: approved
  dev: approved
---

{output_document_content}

---

## Session Transcript

{optional_full_dialogue_history}
```

## Update Team Memory

### Update context.md
```yaml
last_session: "{session_id}"
total_sessions: {+1}
{mode}_count: {+1}  # testplan/bug/review count
active_project: "{project_if_specified}"
```

### Update sessions.md
```yaml
- session_id: "{session_id}"
  date: "{date}"
  mode: "{mode}"
  topic: "{topic}"
  turns: {turn_count}
  outcome: "{summary}"
  artifacts:
    - "docs/qa/logs/{filename}.md"
  key_decisions:
    - "{decision_1}"
    - "{decision_2}"
```

### Update learnings.md (if applicable)
```yaml
# Add any new patterns discovered
- pattern: "{pattern_description}"
  discovered: "{date}"
  context: "{session_topic}"
```

## Archive Checkpoint

```
1. Move active checkpoint to checkpoints/
   checkpoint.yaml → checkpoints/{session_id}.yaml

2. Clear active checkpoint
```

## Final Display

### Success Summary
```markdown
## Session Output

**{Output Type}:** {title}

### Quick Summary
{2-3 sentence summary}

### Key Points
- {point_1}
- {point_2}
- {point_3}

### Next Steps
- [ ] {action_item_1}
- [ ] {action_item_2}

---

Output saved to: `docs/qa/logs/{filename}.md`

Thank you for using Dev-QA Team Simulation!
```

### If Session Incomplete
```markdown
## Session Incomplete

**Status:** {reason_for_incompletion}

### Progress Saved
- Turns completed: {turn_count}
- Phase reached: {phase}
- Checkpoint: checkpoints/{session_id}.yaml

### To Resume
Run: `*resume` in next session

### Partial Output
{partial_output_if_any}

---

Session archived. You can resume later.
```

## Memory Update Templates

### Test Plan Session
```yaml
# sessions.md entry
- type: test_plan
  feature: "{feature_name}"
  test_cases_created: {count}
  coverage_areas:
    - "{area_1}"
    - "{area_2}"
  risks_identified:
    - "{risk_1}"
```

### Bug Triage Session
```yaml
# sessions.md entry
- type: bug_triage
  bug_id: "{bug_id}"
  severity: "{severity}"
  priority: "{priority}"
  root_cause: "{root_cause_summary}"
  fix_approach: "{approach_summary}"
```

### Code Review Session
```yaml
# sessions.md entry
- type: code_review
  pr_reference: "{pr_ref}"
  qa_verdict: "{approved/changes_requested}"
  concerns_count: {count}
  testability_score: {score}/5
```

## Cleanup Tasks

```yaml
cleanup:
  - archive_checkpoint: true
  - clear_active_session: true
  - update_statistics: true
  - notify_completion: true
```

## End Session

Session officially ends after:
1. Output saved
2. Memory updated
3. Summary displayed
4. No pending actions
