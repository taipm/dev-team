# Step 05: Session Close

## Objective
Save output, update memory, và close session.

## Close Flow

```
1. Generate session summary
2. Save output document to docs/architect/logs/
3. Update team memory
4. Archive checkpoint
5. Display final summary
6. End session
```

## Session Summary Banner

```
╔═══════════════════════════════════════════════════════════════╗
║                    SESSION COMPLETE ✅                         ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Session ID: {session_id}                                       ║
║  Mode: {design/review/adr}                                     ║
║  Topic: {topic}                                                 ║
║                                                                 ║
║  Statistics:                                                    ║
║    • Total turns: {turn_count}                                 ║
║    • Duration: {duration}                                       ║
║    • Dialogue mode: {manual/auto/semi-auto}                    ║
║                                                                 ║
║  Output:                                                        ║
║    • Type: {ADR/Review Report}                                 ║
║    • Saved to: docs/architect/logs/{file}   ║
║                                                                 ║
║  Key Decisions:                                                 ║
║    1. {decision_1}                                             ║
║    2. {decision_2}                                             ║
║                                                                 ║
║  Sign-off:                                                      ║
║    ✅ Solution Architect: Approved                              ║
║    ✅ Developer: Approved                                       ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

## File Naming Convention

```
docs/architect/logs/{YYYY-MM-DD}-{mode}-{topic-slug}.md

Examples:
- docs/architect/logs/2024-01-15-design-order-processing.md
- docs/architect/logs/2024-01-15-review-payment-service.md
- docs/architect/logs/2024-01-15-adr-database-selection.md
```

## Output File Structure

```markdown
---
session_id: "{uuid}"
mode: "{mode}"
topic: "{topic}"
date: "{YYYY-MM-DD}"
participants:
  - solution-architect
  - developer
turns: {turn_count}
status: completed
sign_offs:
  architect: approved
  developer: approved
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
{mode}_count: {+1}  # design/review/adr count
adrs_created: {+1 if ADR created}
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
    - "docs/architect/logs/{filename}.md"
  key_decisions:
    - "{decision_1}"
    - "{decision_2}"
  patterns_applied:
    - "{pattern_1}"
```

### Update learnings.md (if applicable)
```yaml
# Add any new patterns discovered
- pattern: "{pattern_description}"
  discovered: "{date}"
  context: "{session_topic}"
  applied_by: "architect" | "developer"
```

## Archive Checkpoint

```
1. Move active checkpoint to checkpoints/
   checkpoint.yaml → checkpoints/{session_id}.yaml

2. Clear active checkpoint
```

## Final Display

### Quick Summary
```markdown
## Session Output

**{Output Type}:** {title}

### Quick Summary
{2-3 sentence summary}

### Key Decisions
- {decision_1}
- {decision_2}

### Action Items
- [ ] {action_item_1}
- [ ] {action_item_2}

---

Output saved to: `docs/architect/logs/{filename}.md`

Thank you for using Dev-Architect Team Simulation!
```

### If Session Incomplete
```markdown
## Session Incomplete

**Status:** {reason_for_incompletion}

### Progress Saved
- Turns completed: {turn_count}
- Phase reached: {phase}
- Checkpoint: memory/checkpoints/{session_id}.yaml

### To Resume
Run: `*resume` in next session

### Partial Output
{partial_output_if_any}

---

Session archived. You can resume later.
```

## Memory Update Templates

### Design Session
```yaml
- type: design
  topic: "{feature/system_name}"
  adr_created: "ADR-{number}"
  architecture_style: "{style}"
  key_components:
    - "{component_1}"
    - "{component_2}"
  patterns_used:
    - "{pattern_1}"
```

### Review Session
```yaml
- type: review
  topic: "{system_reviewed}"
  verdict: "{approved/needs_revision}"
  concerns_count: {count}
  recommendations_count: {count}
  action_items: {count}
```

### ADR Session
```yaml
- type: adr
  adr_id: "ADR-{number}"
  title: "{title}"
  decision: "{chosen_option}"
  alternatives_considered: {count}
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
