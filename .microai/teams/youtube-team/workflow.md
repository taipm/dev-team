# YouTube Team - Signal-Based Video Production Workflow

## Overview

YouTube Team là hệ thống multi-agent chuyên sản xuất video clip trình bày lời giải toán học một cách sinh động, sử dụng Manim animation engine (3Blue1Brown style).

## Signal Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      YOUTUBE TEAM VIDEO PRODUCTION                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  INPUT                                                                       │
│    │  [User submits math problem + preferences]                             │
│    │                                                                         │
│    ▼  signal: problem_received                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    CONTENT ANALYZER                                  │    │
│  │  • Analyze problem for video potential                              │    │
│  │  • Identify key visual moments (aha! points)                        │    │
│  │  • Determine video format (Shorts/Standard/Both)                    │    │
│  │  • Estimate duration                                                │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│    │                                                                         │
│    ▼  signal: analysis_complete                                             │
│    │                                                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    SCRIPT PLANNER                                    │    │
│  │  • Create video script with timing                                  │    │
│  │  • Plan visual cues for each step                                   │    │
│  │  • Design narrative arc (hook → build → reveal)                     │    │
│  │  • Map solution to animation scenes                                 │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│    │                                                                         │
│    ▼  signal: script_complete                                               │
│    │                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    YOUTUBE MAESTRO                                    │   │
│  │  • Review script                                                     │   │
│  │  • [CHECKPOINT 1] - User can approve/modify                         │   │
│  │  • Dispatch parallel creators                                        │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: script_approved → creators_dispatched                         │
│    │                                                                         │
│    ├───────────────────┬───────────────────┬───────────────────┐            │
│    │                   │                   │                   │            │
│    ▼                   ▼                   ▼                   │            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐                │            │
│  │ SOLUTION   │  │ ANIMATION  │  │ VOICEOVER  │   PARALLEL     │            │
│  │  WRITER    │  │  DESIGNER  │  │  WRITER    │   CREATION     │            │
│  │            │  │            │  │            │                │            │
│  │ Elegant    │  │ Manim      │  │ Engaging   │                │            │
│  │ math       │  │ scenes     │  │ narration  │                │            │
│  │ solution   │  │ code       │  │ script     │                │            │
│  └────────────┘  └────────────┘  └────────────┘                │            │
│    │                   │                   │                   │            │
│    ▼                   ▼                   ▼                   │            │
│  signal:           signal:            signal:                  │            │
│  solution_         animation_         voiceover_               │            │
│  complete          complete           complete                 │            │
│    │                   │                   │                   │            │
│    └───────────────────┴───────────────────┘                   │            │
│                        │                                        │            │
│                        ▼  sync: wait_all (min 2)                │            │
│                        │                                        │            │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    MANIM RENDERER                                    │   │
│  │  signal: assets_ready → render_started                              │   │
│  │                                                                      │   │
│  │  Quality Presets:                                                   │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐                │   │
│  │  │ Preview │  │ 1080p   │  │  4K     │  │ Shorts  │                │   │
│  │  │  -ql    │  │  -qh    │  │  -qk    │  │ 9:16    │                │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘                │   │
│  │                                                                      │   │
│  │  [CHECKPOINT 2] - Preview render result                             │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: render_complete                                               │
│    │                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    VIDEO COMPOSITOR                                  │   │
│  │  • Combine rendered scenes                                          │   │
│  │  • Add intro/outro                                                  │   │
│  │  • Apply transitions                                                │   │
│  │  • Add background music (optional)                                  │   │
│  │  • Insert text overlays & captions                                  │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: video_complete                                                │
│    │                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    THUMBNAIL CREATOR                                 │   │
│  │  • Extract key frame                                                │   │
│  │  • Add title text                                                   │   │
│  │  • Apply eye-catching styling                                       │   │
│  │  • Generate multiple variants                                       │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│    │                                                                         │
│    ▼  signal: thumbnail_complete                                            │
│    │                                                                         │
│  OUTPUT                                                                      │
│    ├─► video.mp4 (1080p or 4K)                                             │
│    ├─► thumbnail.png (1280x720)                                            │
│    └─► metadata.json (title, description, tags)                            │
│                                                                              │
│  signal: session_complete                                                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Signal Handlers

### On `problem_received`
```yaml
handler: start_analysis
actions:
  - validate: problem_text is not empty
  - log: "Starting video production for problem"
  - activate: content-analyzer
  - start_timer: analysis_timeout (60s)
```

### On `analysis_complete`
```yaml
handler: start_scripting
actions:
  - validate: video_format determined
  - store: analysis in session
  - activate: script-planner
  - pass: analysis results
  - start_timer: script_timeout (120s)
```

### On `script_complete`
```yaml
handler: review_script
actions:
  - store: script in session
  - emit: checkpoint_reached (CHECKPOINT_1)
  - await: user_approval or auto_continue (30s)
  - on_approved: emit script_approved
  - on_rejected: emit script_rejected
```

### On `script_approved`
```yaml
handler: dispatch_creators
actions:
  - emit: creators_dispatched
  - activate_parallel:
      - solution-writer
      - animation-designer
      - voiceover-writer
  - start_timer: creator_timeout (300s each)
```

### On `solution_complete`, `animation_complete`, `voiceover_complete`
```yaml
handler: collect_assets
actions:
  - store: asset in session.assets
  - check: all_creators_complete OR (min_assets >= 2 AND timeout)
  - if_ready: emit assets_ready
```

### On `assets_ready`
```yaml
handler: start_rendering
actions:
  - select: quality_preset based on user preference
  - activate: manim-renderer
  - emit: render_started
  - start_timer: render_timeout (600s)
```

### On `render_complete`
```yaml
handler: start_composition
actions:
  - validate: video_files exist
  - activate: video-compositor
  - pass: rendered videos + voiceover
```

### On `video_complete`
```yaml
handler: create_thumbnail
actions:
  - store: final video path
  - activate: thumbnail-creator
  - pass: video_path, key_frame
```

### On `thumbnail_complete`
```yaml
handler: complete_session
actions:
  - emit: session_complete
  - log: production_metrics
  - cleanup: temp files
  - return:
      video_path: "..."
      thumbnail_path: "..."
      metadata: {...}
```

## Parallel Creator Execution

```yaml
parallel_execution:
  max_workers: 3

  creators:
    solution-writer:
      priority: high
      required: true
    animation-designer:
      priority: high
      required: true
    voiceover-writer:
      priority: medium
      required: false

  sync_strategy: wait_all
  timeout_per_creator: 300000  # 5 minutes
  min_required: 2  # At least solution + animation

  on_timeout:
    action: proceed_with_completed
    fallback: generate_minimal_video

  on_partial_failure:
    voiceover_missing: "Use text overlays instead"
    animation_missing: "Use static diagrams"
```

## Quality Presets

| Preset | Resolution | FPS | Manim Flag | Duration | Use Case |
|--------|------------|-----|------------|----------|----------|
| Preview | 854×480 | 15 | `-ql` | Any | Quick check |
| Standard | 1920×1080 | 60 | `-qh` | 5-15 min | YouTube regular |
| Premium | 3840×2160 | 60 | `-qk` | 5-15 min | YouTube 4K |
| Shorts | 1080×1920 | 60 | `-qh -r 1080,1920` | ≤60s | YouTube Shorts |

## Checkpoints (User Interaction)

```markdown
CHECKPOINT 1: After Script Planning
- Preview: Video script with timing marks
- Options: [approve] [modify] [change-style] [cancel]
- Auto-continue: 30 seconds if no response

CHECKPOINT 2: After Rendering (optional)
- Preview: Low-quality preview video
- Options: [proceed] [re-render] [adjust-animation]
- Show: Estimated final render time

CHECKPOINT 3: Final Review
- Preview: Complete video + thumbnail
- Options: [export] [regenerate-thumbnail] [re-edit]
- Metadata: Title, description, tags suggestions
```

## Video Styles

### Educational (Default)
- Pace: Moderate, allows thinking time
- Narration: Clear explanations
- Visuals: Step-by-step animations
- Best for: Complex proofs, university-level problems

### Entertaining (3B1B Style)
- Pace: Dynamic, builds tension
- Narration: Storytelling approach
- Visuals: Smooth transitions, visual metaphors
- Best for: Surprising results, elegant solutions

### Quick (Shorts Optimized)
- Pace: Fast, hook in first 3 seconds
- Narration: Punchy, minimal
- Visuals: Bold colors, large text
- Best for: Simple tricks, quick insights

## Error Handling

| Error | Handler | Recovery |
|-------|---------|----------|
| Analysis timeout | Notify user | Offer manual problem classification |
| Script rejected | Re-plan | User provides feedback |
| Creator timeout | Proceed partial | Use available assets |
| Render failed | Retry | Lower quality or fix scene |
| Composition failed | Retry | Skip problematic transitions |

## Output Structure

```
output/
├── {problem_id}/
│   ├── video/
│   │   ├── preview.mp4          # Low-quality preview
│   │   ├── final_1080p.mp4      # Standard quality
│   │   ├── final_4k.mp4         # Premium quality (optional)
│   │   └── shorts.mp4           # Vertical format (optional)
│   ├── thumbnail/
│   │   ├── thumbnail.png        # Main thumbnail
│   │   └── variants/            # Alternative thumbnails
│   ├── assets/
│   │   ├── manim/               # Manim source code
│   │   ├── rendered/            # Rendered scene files
│   │   └── audio/               # Voiceover files (if any)
│   └── metadata.json            # Video metadata
```

## Integration with Math-Team

YouTube Team có thể sử dụng output từ Math-Team:

```yaml
integration:
  math_team:
    signal: solution_ready
    action: import_solution
    mapping:
      best_solution → solution_steps
      latex_content → animation_input
      comparison_notes → bonus_content
```

Workflow tích hợp:
1. Math-Team giải bài toán
2. YouTube-Team nhận solution
3. Chuyển đổi thành video script
4. Tạo animation từ LaTeX content
5. Render video cuối cùng
