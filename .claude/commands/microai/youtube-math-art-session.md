# YouTube MathArt Team Session

Khởi động YouTube MathArt Team để tạo video fractal/mathematical visualization cho YouTube.

## Load Team

1. Read workflow: `.microai/teams/youtube-math-art-team/workflow.md`
2. Load agents từ `.microai/teams/youtube-math-art-team/agents/`
3. Load steps từ `.microai/teams/youtube-math-art-team/steps/`
4. Initialize session state

## Execute Workflow

Follow steps defined in workflow.md:
1. **Step 01**: Init - Load Kanban, select topic, create workspace
2. **Step 02**: Concept - 🎨 Designer creates visual concept
3. **Step 03**: Algorithm - 🧮 Developer writes animation code
4. **Step 04**: Preview - 🎬 Quick render for validation
5. **Step 05**: Review Loop - 🔍 Reviewer ↔ 🧮 Developer iteration
6. **Step 06**: Final Render - Parallel 720p + 1080p
7. **Step 07**: Quality Check - Validate output files
8. **Step 08**: Synthesis - Update Kanban, generate report

## Team Members

| Agent | Role | Icon | Focus |
|-------|------|------|-------|
| concept-designer | Concept Designer | 🎨 | Visual concept, colors |
| algorithm-dev | Algorithm Developer | 🧮 | Python/NumPy animation |
| render-engineer | Render Engineer | 🎬 | Video export, FFmpeg |
| quality-reviewer | Quality Reviewer | 🔍 | Validation, approval |

## Output Formats

| Format | Resolution | FPS | Duration | Use |
|--------|------------|-----|----------|-----|
| Standard | 720p | 30 | 90s | Required |
| Premium | 1080p | 60 | 90s | Optional |

## Observer Controls

| Command | Effect |
|---------|--------|
| `[Enter]` | Continue to next step |
| `*pause` | Pause for manual review |
| `*skip` | Skip current step |
| `*exit` | End session, save progress |
| `@concept: <msg>` | Inject to Concept Designer |
| `@algo: <msg>` | Inject to Algorithm Dev |
| `@render: <msg>` | Inject to Render Engineer |
| `@review: <msg>` | Inject to Quality Reviewer |
| `*auto` | Enable autonomous mode |
| `*720` | Render 720p only |
| `*1080` | Also render 1080p |
| `*board` | Show Kanban board |
| `*next` | Pick next topic from backlog |

## Examples

```bash
# Create specific topic
/microai:youtube-math-art-session Julia Set Morphing

# Auto-pick from Kanban
/microai:youtube-math-art-session *next

# With 1080p output
/microai:youtube-math-art-session Lorenz Attractor *1080

# Autonomous mode
/microai:youtube-math-art-session *auto *next
```

## Kanban Integration

- Reads from: `.claude/kanban/mathart-videos.yaml`
- Updates task status: Backlog → Rendered
- Suggests next topic based on priority

ARGUMENTS: $ARGUMENTS
