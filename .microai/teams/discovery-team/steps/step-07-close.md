# Step 07: Session Close

## Trigger
- After Step 06 complete
- All outputs generated

## Agents
- 🎯 **Navigator** (lead)
- 📝 **Chronicler** (support)

## Actions

### 1. Navigator: Generate Session Summary
```yaml
compile:
  duration: end_time - start_time
  questions_answered: count(answered)
  facts_extracted: count(facts)
  patterns_found: count(patterns)
  relationships_mapped: count(relationships)
  gaps_remaining: count(gaps)
  deepening_iterations: count
```

### 2. Navigator: Display Final Summary
```markdown
╔═══════════════════════════════════════════════════════════════════════╗
║                    SESSION COMPLETE                                    ║
╠═══════════════════════════════════════════════════════════════════════╣
║  Session ID: {id}                                                      ║
║  Duration: {time}                                                      ║
║  Scope: {scope}                                                        ║
║  Depth: {level}                                                        ║
╠═══════════════════════════════════════════════════════════════════════╣
║  METRICS                                                               ║
║  ├── Questions answered: {N}/{total}                                   ║
║  ├── Facts extracted: {N}                                              ║
║  ├── Patterns identified: {N}                                          ║
║  ├── Relationships mapped: {N}                                         ║
║  ├── Deepening iterations: {N}                                         ║
║  └── Gaps remaining: {N}                                               ║
╠═══════════════════════════════════════════════════════════════════════╣
║  OUTPUTS                                                               ║
║  ├── Report: outputs/reports/{date}-discovery-report.md               ║
║  ├── Graph: outputs/graphs/{date}-knowledge-graph.md                  ║
║  └── Q&A DB: outputs/qa-database/{date}-qa-entries.yaml              ║
╠═══════════════════════════════════════════════════════════════════════╣
║  KEY FINDINGS                                                          ║
║  1. {Finding 1}                                                        ║
║  2. {Finding 2}                                                        ║
║  3. {Finding 3}                                                        ║
╠═══════════════════════════════════════════════════════════════════════╣
║  OPEN QUESTIONS (for next session)                                     ║
║  • {Open question 1}                                                   ║
║  • {Open question 2}                                                   ║
╠═══════════════════════════════════════════════════════════════════════╣
║  RECOMMENDED NEXT STEPS                                                ║
║  1. {Action 1}                                                         ║
║  2. {Action 2}                                                         ║
╚═══════════════════════════════════════════════════════════════════════╝

Context saved. Run `/discovery` to continue exploration.
```

### 3. Chronicler: Archive Session
```yaml
archive_session:
  # Create session log
  log_file:
    path: logs/{date}-{session_id}-session.md
    content:
      - Session metadata
      - Timeline of events
      - Commands used
      - Decisions made

  # Archive checkpoints
  archive_checkpoints:
    from: memory/checkpoints/
    to: logs/archives/{session_id}/checkpoints/

  # Clean temporary files
  cleanup:
    - Clear memory/current-context.md
    - Clear memory/code-context.md (already archived)
```

### 4. Navigator: Offer Post-Session Options
```markdown
🎯 **Navigator**: Session archived

**What would you like to do?**

| Command | Action |
|---------|--------|
| *open report | Open generated report |
| *open graph | View knowledge graph |
| *open qa | Browse Q&A database |
| *history | View session history |
| *continue | Start new session immediately |
| [Enter] | Exit |

Thank you for using Discovery Team!
```

## Session Log Format

```markdown
# Discovery Session Log

## Session Info
- **ID:** {uuid}
- **Date:** {date}
- **Duration:** {duration}
- **Scope:** {scope}
- **Depth:** {level}

## Timeline

| Time | Event | Details |
|------|-------|---------|
| 00:00 | Session start | Scope: {scope} |
| 00:02 | Questions selected | {N} questions |
| 00:15 | Fact gathering complete | {N} facts |
| 00:20 | Analysis complete | {N} patterns |
| 00:25 | Deepening iteration 1 | {N} derived questions |
| 00:35 | Synthesis complete | Outputs generated |
| 00:36 | Session close | Success |

## Commands Used
- `/discovery`
- `*deep` (at step 4)
- `[Enter]` x 5

## Decisions Made
1. Selected {N} questions from bank
2. Deepened exploration on {topic}
3. Skipped {question} due to no evidence

## Outputs
- Report: {path}
- Graph: {path}
- Q&A: {path}

## Notes
{Any observer notes or comments}
```

## Output
```yaml
session:
  status: "complete"
  archived: true
  log_path: logs/{date}-{session_id}-session.md

next_session:
  suggested_scope: "{based on gaps}"
  open_questions: [{list}]
  recommended_depth: {level}
```

## Exit
Session complete. Control returns to user.
