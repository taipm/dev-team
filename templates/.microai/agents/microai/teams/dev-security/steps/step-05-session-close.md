# Step 05: Session Close

## Objective
Save report, update memory, và close session.

## Close Flow

```
1. Generate session summary
2. Save report to docs/security/logs/
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
║  Mode: {review/threat-model/vulnerability}                     ║
║  Topic: {topic}                                                 ║
║                                                                 ║
║  Statistics:                                                    ║
║    • Total turns: {turn_count}                                 ║
║    • Duration: {duration}                                       ║
║                                                                 ║
║  Findings:                                                      ║
║    • Critical: {count}                                         ║
║    • High: {count}                                             ║
║    • Medium: {count}                                           ║
║    • Low: {count}                                              ║
║                                                                 ║
║  Status:                                                        ║
║    • Fixed: {count}                                            ║
║    • Acknowledged: {count}                                     ║
║    • Pending: {count}                                          ║
║                                                                 ║
║  Output saved to:                                               ║
║    docs/security/logs/{filename}.md         ║
║                                                                 ║
║  Sign-off:                                                      ║
║    ✅ Security Engineer: Approved                               ║
║    ✅ Developer: Approved                                       ║
║                                                                 ║
╚═══════════════════════════════════════════════════════════════╝
```

## File Naming Convention

```
docs/security/logs/{YYYY-MM-DD}-{mode}-{topic-slug}.md

Examples:
- docs/security/logs/2024-01-15-review-payment-api.md
- docs/security/logs/2024-01-15-threat-model-auth-system.md
- docs/security/logs/2024-01-15-vulnerability-user-portal.md
```

## Output File Structure

```markdown
---
session_id: "{uuid}"
mode: "{mode}"
topic: "{topic}"
date: "{YYYY-MM-DD}"
participants:
  - security-engineer
  - developer
turns: {turn_count}
status: completed
findings_summary:
  critical: {count}
  high: {count}
  medium: {count}
  low: {count}
sign_offs:
  security: approved
  developer: approved
---

{report_content}

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
vulnerabilities_found: {+new_count}
vulnerabilities_fixed: {+fixed_count}
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
    - "docs/security/logs/{filename}.md"
  findings:
    critical: {count}
    high: {count}
    medium: {count}
    low: {count}
  fixed_count: {count}
```

### Update learnings.md (if applicable)
```yaml
# Add common vulnerability patterns discovered
- vulnerability_type: "{type}"
  found_in: "{context}"
  date: "{date}"
  lesson: "{what to watch for}"
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
## Security Review Complete

**Target:** {topic}
**Findings:** {total_count} ({critical} Critical, {high} High, {medium} Medium, {low} Low)

### Key Findings
1. {Most important finding}
2. {Second most important}

### Action Items
- [ ] {Immediate action 1}
- [ ] {Immediate action 2}

### Next Steps
1. Address Critical/High findings immediately
2. Schedule follow-up review after fixes
3. Consider security testing automation

---

Report saved to: `docs/security/logs/{filename}.md`

Thank you for using Dev-Security Team Simulation!
```

### If Session Incomplete
```markdown
## Session Incomplete

**Status:** {reason_for_incompletion}

### Progress Saved
- Turns completed: {turn_count}
- Findings so far: {count}
- Checkpoint: memory/checkpoints/{session_id}.yaml

### To Resume
Run: `*resume` in next session

### Partial Findings
{list of findings so far}

---

Session archived. You can resume later.
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
1. Report saved
2. Memory updated
3. Summary displayed
4. No pending actions
