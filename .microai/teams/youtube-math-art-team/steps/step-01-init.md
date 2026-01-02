# Step 01: Session Initialization

## Purpose
Initialize MathArt session: load Kanban, select topic, create workspace.

## Trigger
Session start với topic từ argument hoặc `*next` command.

## Actions

### 1. Display Welcome Banner
```
╔═══════════════════════════════════════════════════════════════╗
║           YOUTUBE MATHART TEAM SESSION                         ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Date: {date}                                                  ║
║  Mode: {autonomous/manual}                                     ║
╠═══════════════════════════════════════════════════════════════╣
║  Team:                                                         ║
║    🎨 Concept Designer    🧮 Algorithm Developer               ║
║    🎬 Render Engineer     🔍 Quality Reviewer                  ║
╠═══════════════════════════════════════════════════════════════╣
║  Output Formats:                                               ║
║    ├── 720p @ 30fps, 90s (Standard)                            ║
║    └── 1080p @ 60fps, 90s (Premium - optional)                 ║
╠═══════════════════════════════════════════════════════════════╣
║  Commands: *pause *skip *exit *auto *720 *1080 *board          ║
╚═══════════════════════════════════════════════════════════════╝
```

### 2. Load Kanban Board
```bash
# Read Kanban
cat .claude/kanban/mathart-videos.yaml
```

Nếu topic là `*next`:
- Tìm task đầu tiên với status: "Backlog" và priority: "high"
- Hoặc user chọn từ danh sách

### 3. Create Workspace
```bash
WORKSPACE=".microai/workspaces/youtube-math-art/$(date +%Y-%m-%d)-{topic_slug}"

mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/output"
mkdir -p "$WORKSPACE/docs"
```

### 4. Initialize Session State
```yaml
mathart_state:
  topic: "{topic}"
  date: "{date}"
  phase: "init"
  workspace: "{workspace_path}"

  config:
    render_720p: true
    render_1080p: false
    duration: 90

  kanban:
    task_id: "{MA-XXX}"
    original_status: "Backlog"
```

### 5. Create Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-01-init.yaml
```

## Transition
→ Step 02: Concept Design

## Observer Notes
- Nếu topic không rõ, hỏi user chọn từ Kanban
- Nếu `*auto` mode, tự động pick high-priority task
