# Step 08: Synthesis

## Purpose
Update Kanban, generate report, complete session.

## Trigger
Step 07 completed với quality passed.

## Actions

### 1. Update Kanban Board

Read current Kanban:
```bash
cat .claude/kanban/mathart-videos.yaml
```

Update task status:
```yaml
# Change from:
- id: {MA-XXX}
  status: "Backlog"

# To:
- id: {MA-XXX}
  status: "Rendered"
  source_file: "{workspace}/src/{topic}_animation.py"
  output_file: "{workspace}/output/{topic}_720p.mp4"
  completed_at: "{date}"
```

Update metrics:
```yaml
metrics:
  by_status:
    backlog: {n-1}
    rendered: {n+1}
```

### 2. Generate Session Report

```markdown
# MathArt Session Report

## Session Info
- **Topic**: {topic}
- **Date**: {date}
- **Duration**: {session_duration}
- **Kanban ID**: {MA-XXX}

## Team Activity

| Agent | Actions | Time |
|-------|---------|------|
| 🎨 Concept | Created visual concept | {time} |
| 🧮 Algorithm | Implemented animation | {time} |
| 🎬 Render | Rendered videos | {time} |
| 🔍 Reviewer | Validated quality | {time} |

## Iterations
- Total iterations: {n}
- Issues fixed: {list}

## Output Files

| File | Size | Specs |
|------|------|-------|
| {topic}_720p.mp4 | {size}MB | 1280x720, 30fps, 90s |
| {topic}_1080p.mp4 | {size}MB | 1920x1080, 60fps, 90s |
| thumbnail.png | {size}KB | 1280x720 |

## Quality Metrics
- Visual rating: {n}/10
- Technical validation: PASSED
- YouTube ready: YES

## Workspace
```
{workspace}/
├── src/{topic}_animation.py
├── output/
│   ├── {topic}_720p.mp4
│   ├── {topic}_1080p.mp4
│   └── thumbnail.png
└── docs/
    ├── concept.md
    └── session-report.md
```

## Next Steps
- Publish to YouTube
- Or pick next topic: {suggestion}
```

### 3. Save Report
```bash
echo "{report}" > "$WORKSPACE/docs/session-report.md"
```

### 4. Update Workspace README
```bash
cat > "$WORKSPACE/README.md" << EOF
# MathArt: {Topic}

**Date:** {date}
**Status:** Rendered
**Kanban ID:** {MA-XXX}

## Files
- Source: src/{topic}_animation.py
- Video: output/{topic}_720p.mp4
- Thumbnail: output/thumbnail.png

## Usage
\`\`\`bash
python3 src/{topic}_animation.py
\`\`\`
EOF
```

### 5. Display Session Summary

```
╔═══════════════════════════════════════════════════════════════╗
║                 SESSION COMPLETE ✅                            ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Kanban: {MA-XXX} → Rendered                                   ║
╠═══════════════════════════════════════════════════════════════╣
║  Output Files:                                                 ║
║  ├── {topic}_720p.mp4 ({size}MB)                               ║
║  ├── {topic}_1080p.mp4 ({size}MB)                              ║
║  └── thumbnail.png                                             ║
╠═══════════════════════════════════════════════════════════════╣
║  Session Stats:                                                ║
║  ├── Duration: {time}                                          ║
║  ├── Iterations: {n}                                           ║
║  └── Quality: {rating}/10                                      ║
╠═══════════════════════════════════════════════════════════════╣
║  Workspace: {workspace}                                        ║
╠═══════════════════════════════════════════════════════════════╣
║  Next suggested topic: {next_topic}                            ║
║  Run: /microai:youtube-math-art-session {next_topic}           ║
╚═══════════════════════════════════════════════════════════════╝
```

### 6. Suggest Next Topic

Query Kanban for next high-priority backlog item:
```yaml
# Find first item with:
status: "Backlog"
priority: "high"
viral_potential: "very-high"
```

### 7. Save Final Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-08-complete.yaml
```

### 8. Cleanup (Optional)
- Remove preview.mp4
- Remove temporary files

## Session End

Session hoàn thành. User có thể:
- Open video: `open {workspace}/output/{topic}_720p.mp4`
- Start new session: `/microai:youtube-math-art-session {next_topic}`
- View Kanban: `*board`

## Logs
Session log saved to:
```
.microai/teams/youtube-math-art-team/logs/{date}-{topic}.md
```
