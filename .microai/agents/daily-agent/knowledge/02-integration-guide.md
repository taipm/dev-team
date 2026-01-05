# Integration Guide

How to integrate with sub-agents and teams.

---

## Deep Research Team

### Location
`../../teams/deep-research/`

### Trigger Method
Use Task tool with Explore or Plan subagent type:

```
Task tool:
- prompt: "Research {topic} on arxiv, find top 5 papers, analyze and create digest"
- subagent_type: "Explore"
```

### Input Format
```yaml
topic: "{research_topic}"
max_papers: 5
categories: ["cs.AI", "cs.LG"]
```

### Output Mapping
- Digest saved to: `output/daily/{date}/research/digest.md`
- Papers saved to: `output/daily/{date}/research/papers/`

### Error Handling
- Timeout: 10 minutes max
- On failure: Save partial results, log error, continue

---

## FB Post Agent

### Location
`../fb-post-agent/`

### Trigger Method
Direct invocation via Skill tool:

```
Skill tool:
- skill: "microai:fb-post"
- args: "*post {content}"
```

Or via Task tool for complex posts:

```
Task tool:
- prompt: "Use fb-post-agent to post: {content}"
- subagent_type: "general-purpose"
```

### Input Format
```yaml
content: "{post_content}"
type: "text|link|image"
hashtags: ["tag1", "tag2"]
```

### Requirements
- Environment: FB_PAGE_TOKEN, FB_PAGE_ID must be set
- Confirmation: Always ask before posting

### Output Mapping
- Post record: `output/daily/{date}/facebook/posts/{timestamp}.md`
- Drafts: `output/daily/{date}/facebook/drafts/`

### Error Handling
- Auth error: Check token, suggest refresh
- Rate limit: Wait and retry with backoff
- Content policy: Save as draft, notify user

---

## YouTube Team

### Location
`../../teams/youtube-team/`

### Trigger Method
```
Skill tool:
- skill: "microai:youtube-team"
- args: "{problem_description}"
```

### Input Format
```yaml
problem: "{math_problem_or_topic}"
format: "shorts|standard"
style: "educational|entertaining"
```

### Output Mapping
- Videos: `output/daily/{date}/youtube/{video_id}/`
- Thumbnails: `output/daily/{date}/youtube/{video_id}/thumbnail.png`

### Notes
- Long process: 10-30 minutes
- Uses Manim for animations
- Requires ffmpeg installed

---

## Kanban Agent

### Location
`../kanban-agent/`

### Board Path
`./kanban/board.yaml`

### Trigger Method
```
Skill tool:
- skill: "microai:kanban"
- args: "{command}"

Commands:
- show: Display board
- add {title}: Add task to backlog
- start {task-id}: Move to in_progress
- done {task-id}: Mark completed
- metrics: Show performance metrics
```

### Integration Protocol

**On task start:**
```
1. Check WIP limit (max 3)
2. Move task from backlog to in_progress
3. Set started_at timestamp
4. Assign to "daily-agent"
```

**On task complete:**
```
1. Move task to done
2. Set completed_at timestamp
3. Calculate cycle time
4. Update stats
```

### Sync Schedule
- On daily-agent activation: Sync from main board
- On task completion: Sync to main board
- On session end: Full sync

---

## Gmail Integration (Future)

### Status
`enabled: false`

### Planned Features
1. **read_inbox**: Read and summarize emails
2. **send_email**: Send scheduled emails
3. **email_to_task**: Convert emails to tasks

### Setup Requirements
- OAuth2 credentials
- Gmail API enabled
- Scopes: gmail.readonly, gmail.send

### Implementation Notes
- Will use MCP server or direct API calls
- Token refresh handling needed
- Rate limits: 250 quota units/user/second

---

## Integration Best Practices

### 1. Always Check Status First
Before calling any integration, verify it's available:
```
Read integration status from context.md
If error state, notify user before proceeding
```

### 2. Handle Errors Gracefully
```yaml
on_error:
  - log_error: true
  - save_partial: true
  - continue_others: true
  - notify_user: true
```

### 3. Respect Rate Limits
| Integration | Rate Limit | Handling |
|-------------|------------|----------|
| fb-post | 200 calls/hour | Exponential backoff |
| deep-research | Depends on arxiv | Add delays |
| youtube-team | Local only | N/A |
| kanban | No limit | N/A |

### 4. Maintain Context
After each integration call:
```
1. Update context.md with result
2. Log important decisions
3. Add learnings if applicable
4. Update daily-stats.yaml
```

---

## Quick Reference

| Integration | Trigger | Confirmation | Timeout |
|-------------|---------|--------------|---------|
| deep-research | Task tool | No | 10 min |
| fb-post | Skill/Task | Yes | 1 min |
| youtube-team | Skill | No | 30 min |
| kanban | Skill | No | N/A |
| gmail | Future | Varies | TBD |
