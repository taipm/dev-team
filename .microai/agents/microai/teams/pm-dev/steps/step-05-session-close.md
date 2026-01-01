# Step 05: Session Close

## Objective
Save output, update memory, và close session.

## Close Flow

```
1. Generate session summary
2. Save output document to .microai/docs/teams/pm-dev/logs/
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
║  Mode: {requirements/tech-spec/estimation}                     ║
║  Topic: {topic}                                                 ║
║                                                                 ║
║  Statistics:                                                    ║
║    • Total turns: {turn_count}                                 ║
║    • Duration: {duration}                                       ║
║                                                                 ║
║  Output:                                                        ║
║    • Type: {User Stories/Tech Spec/Estimation Report}          ║
║    • Stories: {count}                                          ║
║    • Estimate: {total if applicable}                           ║
║                                                                 ║
║  Saved to:                                                      ║
║    .microai/docs/teams/pm-dev/logs/{filename}.md               ║
║                                                                 ║
║  Sign-off:                                                      ║
║    ✅ Product Manager: Approved                                 ║
║    ✅ Developer: Approved                                       ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

## File Naming Convention

```
.microai/docs/teams/pm-dev/logs/{YYYY-MM-DD}-{mode}-{topic-slug}.md

Examples:
- .microai/docs/teams/pm-dev/logs/2024-01-15-requirements-user-notifications.md
- .microai/docs/teams/pm-dev/logs/2024-01-15-tech-spec-payment-gateway.md
- .microai/docs/teams/pm-dev/logs/2024-01-15-estimation-dashboard-redesign.md
```

## Output File Structure

```markdown
---
session_id: "{uuid}"
mode: "{mode}"
topic: "{topic}"
date: "{YYYY-MM-DD}"
participants:
  - product-manager
  - developer
turns: {turn_count}
status: completed
stories_count: {count}
total_estimate: "{estimate if applicable}"
sign_offs:
  pm: approved
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
{mode}_count: {+1}
stories_refined: {+new_count}
specs_created: {+1 if tech-spec}
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
    - ".microai/docs/teams/pm-dev/logs/{filename}.md"
  stories:
    - "{US-1}"
    - "{US-2}"
  estimates:
    total: "{estimate}"
    confidence: "{level}"
```

### Update learnings.md (if applicable)
```yaml
# Add any new patterns discovered
- pattern: "{pattern_description}"
  discovered: "{date}"
  context: "{session_topic}"
  insight: "{what we learned}"
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

### Key Outcomes
- {outcome_1}
- {outcome_2}

### Stories/Estimates
{list of stories or total estimate}

### Next Steps
- [ ] {action_item_1}
- [ ] {action_item_2}

---

Output saved to: `.microai/docs/teams/pm-dev/logs/{filename}.md`

Thank you for using PM-Dev Team Simulation!
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

### Requirements Session
```yaml
- type: requirements
  feature: "{feature_name}"
  stories_created: {count}
  stories_list:
    - "US-1: {title}"
    - "US-2: {title}"
  questions_resolved: {count}
```

### Tech Spec Session
```yaml
- type: tech_spec
  feature: "{feature_name}"
  approach: "{summary}"
  estimate: "{total}"
  confidence: "{level}"
  milestones: {count}
```

### Estimation Session
```yaml
- type: estimation
  feature: "{feature_name}"
  stories_estimated: {count}
  total_estimate: "{days/points}"
  confidence: "{level}"
  risks_identified: {count}
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
