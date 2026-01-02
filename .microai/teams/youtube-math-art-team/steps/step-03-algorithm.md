# Step 03: Algorithm Development

## Purpose
🧮 Algorithm Developer viết Python code cho animation.

## Agent
**algorithm-dev** (🧮)

## Trigger
Step 02 completed với concept approved.

## Actions

### 1. Load Agent
```
Load: ./agents/algorithm-dev.md
```

### 2. Read Concept
```bash
cat "$WORKSPACE/docs/concept.md"
```

### 3. Implement Animation

Agent creates Python script following template:

```python
#!/usr/bin/env python3
"""
{Topic} Animation - YouTube Ready
"""

import numpy as np
from dataclasses import dataclass
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter

@dataclass
class VideoConfig:
    width: int = 1280
    height: int = 720
    fps: int = 30
    duration: int = 90
    dpi: int = 100
    bitrate: int = 5000
    output_path: str = "{workspace}/output/{topic}_720p.mp4"

@dataclass
class ColorConfig:
    background: str = '{from_concept}'
    primary: str = '{from_concept}'
    secondary: str = '{from_concept}'
    accent: str = '{from_concept}'

# Mathematical implementation
def compute_{topic}(...):
    """Core mathematical computation."""
    pass

# Animation
def create_animation(config, colors):
    """Setup figure and elements."""
    pass

def animate(frame, ...):
    """Update function for each frame."""
    pass

def main():
    config = VideoConfig()
    colors = ColorConfig()

    # Create animation
    fig, ... = create_animation(config, colors)

    total_frames = config.duration * config.fps
    anim = FuncAnimation(fig, animate, frames=total_frames, ...)

    # Export
    writer = FFMpegWriter(fps=config.fps, bitrate=config.bitrate, ...)
    anim.save(config.output_path, writer=writer)

if __name__ == "__main__":
    main()
```

### 4. Save Source Code
```bash
# Save to workspace
echo "{code}" > "$WORKSPACE/src/{topic}_animation.py"
```

### 5. Validate Syntax
```bash
python3 -m py_compile "$WORKSPACE/src/{topic}_animation.py"
```

### 6. Create Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-03-algorithm.yaml
```

## BREAKPOINT

```
═══════════════════════════════════════════════════════════════
                    [BREAKPOINT] CODE REVIEW
═══════════════════════════════════════════════════════════════
Source code created at: {path}

Quick validation:
  ✅ Syntax valid
  ✅ Config matches concept
  ✅ Output path correct

Options:
  [Enter] - Approve và continue to Preview
  @algo: <feedback> - Request changes
  *skip - Skip to preview
  *exit - Save và exit
═══════════════════════════════════════════════════════════════
```

## Autonomous Mode
Nếu `autonomous.auto_approve.algorithm: true`:
- Auto-approve nếu syntax valid
- Log approval

## Transition
→ Step 04: Preview Render

## Error Handling
- Syntax error: Fix và retry
- Missing concept elements: Ask concept-designer to clarify
- Performance concerns: Optimize before preview
