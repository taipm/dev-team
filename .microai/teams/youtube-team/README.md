# YouTube Team

> Multi-agent team for producing high-quality animated math solution videos

## Overview

YouTube Team là hệ thống multi-agent chuyên sản xuất video clip trình bày lời giải toán học một cách sinh động, sử dụng Manim animation engine (3Blue1Brown style).

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      YOUTUBE TEAM                               │
│            Signal-Based Video Production System                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUT: Math Problem + Preferences                              │
│         ↓                                                       │
│  ┌─────────────┐    ┌──────────────┐                           │
│  │   CONTENT   │───▶│    SCRIPT    │                           │
│  │  ANALYZER   │    │   PLANNER    │                           │
│  └─────────────┘    └──────┬───────┘                           │
│                            │                                    │
│         ┌──────────────────┼──────────────────┐                │
│         ▼                  ▼                  ▼                │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐           │
│  │  SOLUTION  │    │ ANIMATION  │    │ VOICEOVER  │  PARALLEL │
│  │   WRITER   │    │  DESIGNER  │    │   WRITER   │           │
│  └─────┬──────┘    └─────┬──────┘    └─────┬──────┘           │
│        └─────────────────┼─────────────────┘                   │
│                          ▼                                      │
│                  ┌───────────────┐                             │
│                  │    MANIM      │                             │
│                  │   RENDERER    │                             │
│                  └───────┬───────┘                             │
│                          ▼                                      │
│                  ┌───────────────┐                             │
│                  │    VIDEO      │                             │
│                  │  COMPOSITOR   │                             │
│                  └───────┬───────┘                             │
│                          ▼                                      │
│                  ┌───────────────┐                             │
│                  │  THUMBNAIL    │                             │
│                  │   CREATOR     │                             │
│                  └───────────────┘                             │
│                          │                                      │
│  OUTPUT: Video (1080p/4K/Shorts) + Thumbnail                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Agents (10)

| Category | Agent | Model | Role |
|----------|-------|-------|------|
| Core | youtube-maestro | Opus | Orchestrator |
| Core | youtube-scribe | Haiku | Silent logger |
| Analyzer | content-analyzer | Sonnet | Problem analysis |
| Analyzer | script-planner | Sonnet | Script writing |
| Creator | solution-writer | Sonnet | Math solution |
| Creator | animation-designer | Sonnet | Manim code |
| Creator | voiceover-writer | Sonnet | Narration |
| Renderer | manim-renderer | Sonnet | Video render |
| Renderer | video-compositor | Sonnet | Post-production |
| Renderer | thumbnail-creator | Sonnet | Thumbnail design |

## Video Formats

| Format | Resolution | Aspect | Duration | Use Case |
|--------|------------|--------|----------|----------|
| Standard | 1920×1080 | 16:9 | 5-15 min | YouTube regular |
| Premium | 3840×2160 | 16:9 | 5-15 min | YouTube 4K |
| Shorts | 1080×1920 | 9:16 | ≤60s | YouTube Shorts |

## Quick Start

### 1. Invoke YouTube Team

```bash
# Using skill command
/microai:youtube-team "Chứng minh rằng trong tam giác, tổng ba góc bằng 180 độ"

# With preferences
/microai:youtube-team --format=shorts --style=entertaining "Bài toán thú vị về số nguyên tố"
```

### 2. Workflow Steps

1. **Analysis**: Content analyzer đánh giá bài toán
2. **Scripting**: Script planner tạo kịch bản chi tiết
3. **Creation** (parallel):
   - Solution writer viết lời giải
   - Animation designer tạo Manim code
   - Voiceover writer viết narration
4. **Rendering**: Manim renderer compile animations
5. **Composition**: Video compositor ghép nối
6. **Thumbnail**: Thumbnail creator tạo ảnh bìa

### 3. Checkpoints

- **Checkpoint 1**: Review script trước khi tạo content
- **Checkpoint 2**: Preview video trước khi render final
- **Checkpoint 3**: Review final output

## Signal Flow

```
problem_received → analysis_complete → script_complete
    → script_approved → creators_dispatched
    → [solution_complete, animation_complete, voiceover_complete]
    → assets_ready → render_started → render_complete
    → video_complete → thumbnail_complete → session_complete
```

## Integration with Math-Team

YouTube Team có thể nhận output từ Math-Team:

```yaml
workflow:
  1. math-team: Giải bài toán → best_solution
  2. youtube-team: Import solution → Tạo video
```

## Output Structure

```
output/{problem_id}/
├── video/
│   ├── final_1080p.mp4
│   ├── final_4k.mp4 (optional)
│   └── shorts.mp4 (optional)
├── thumbnail/
│   ├── thumbnail.png
│   └── variants/
├── assets/
│   ├── manim/
│   └── rendered/
└── metadata.json
```

## Requirements

- Python 3.8+
- Manim Community Edition
- FFmpeg
- LaTeX (optional, for equations)

## References

- [Manim Community Docs](https://docs.manim.community/)
- [3Blue1Brown Style Guide](./knowledge/3b1b-style-guide.md)
- [YouTube Specifications](./knowledge/youtube-specs.md)

---

*YouTube Team v1.0 - Part of MicroAI Agent System*
