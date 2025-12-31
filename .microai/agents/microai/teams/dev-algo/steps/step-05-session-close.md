# Step 05: Session Close

## Purpose
Save session artifacts, update team memory, and display session summary.

## Close Process

### Step 5.1: Save Output Document

```yaml
output_file:
  path: ".microai/docs/teams/dev-algo/logs/{date}-{mode}-{topic_slug}.md"
  format: markdown
  encoding: utf-8
```

Filename convention:
- `2024-12-31-solve-two-sum.md`
- `2024-12-31-review-binary-search.md`
- `2024-12-31-interview-dp-practice.md`

### Step 5.2: Update Session History

Append to `memory/sessions.md`:

```markdown
## {date} - {mode}: {topic}

**Session ID**: {id}
**Duration**: {duration}
**Turns**: {turn_count}
**Outcome**: {outcome}

### Summary
{brief summary}

### Key Learnings
- {learning 1}
- {learning 2}

### Output
[{filename}](../logs/{filename})

---
```

### Step 5.3: Update Learnings

If new patterns discovered, append to `memory/learnings.md`:

```markdown
## Pattern: {pattern_name}

**Discovered**: {date}
**Problem**: {problem_title}
**Key Insight**: {insight}

### When to Use
{conditions}

### Template
```{language}
{code template}
```

---
```

### Step 5.4: Update Statistics

Update `memory/context.md` statistics:

```yaml
statistics:
  total_sessions: +1
  by_mode:
    {mode}: +1
  problems_solved: +1 (if solved)
  patterns_used:
    {pattern}: +1
```

### Step 5.5: Clean Up

- Archive checkpoints (keep last 5 sessions)
- Clear current session state

## Session Summary Display

```
╔═══════════════════════════════════════════════════════════════╗
║                    SESSION COMPLETE 🎉                         ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  Session ID:  {id}                                            ║
║  Mode:        {mode}                                          ║
║  Topic:       {topic}                                         ║
║  Duration:    {duration}                                      ║
║  Turns:       {turn_count}                                    ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  OUTCOME                                                       ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  Problem:     {problem_title}                                 ║
║  Pattern:     {pattern_used}                                  ║
║  Complexity:  Time O({time}) | Space O({space})               ║
║  Verdict:     {verdict}                                       ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  TEAM PERFORMANCE                                              ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  👨‍💻 Developer:    {turns} turns, implemented {status}        ║
║  🧙 Algo-Master:   {turns} turns, classified as {pattern}     ║
║  🔍 Reviewer:      {turns} turns, verdict: {verdict}          ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  OUTPUT                                                        ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  📄 Saved to: {output_path}                                   ║
║                                                                ║
╚═══════════════════════════════════════════════════════════════╝

Thank you for using Dev-Algo Team!

To start a new session:
  /microai:dev-algo-session {topic}
```

## Quick Stats Update

After each session, update quick reference in context.md:

```yaml
quick_stats:
  last_session: "{date} - {mode}: {topic}"
  streak: {consecutive_sessions}
  favorite_pattern: "{most_used_pattern}"
  success_rate: "{solved}/{total}"
```

## Memory Retention

### Keep Forever
- Output documents (logs/)
- Learnings (memory/learnings.md)
- Session summaries (memory/sessions.md)

### Keep Last 5 Sessions
- Detailed checkpoints

### Clear on Close
- Current session state in context.md

## Error Handling

If session ends unexpectedly:
1. Attempt to save current state
2. Mark session as "incomplete"
3. Keep checkpoints for potential resume
4. Log error in sessions.md

```markdown
## {date} - {mode}: {topic} [INCOMPLETE]

**Session ID**: {id}
**Status**: Ended unexpectedly
**Reason**: {error}
**Checkpoint**: {last_checkpoint}

Resume command: /microai:dev-algo-session --resume {session_id}
```

## Success Message

Final output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Session saved successfully!
📄 Output: .microai/docs/teams/dev-algo/logs/{filename}
📊 Stats updated in memory/context.md

Happy coding! 🚀
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
