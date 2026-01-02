# Step 04: Preview Render

## Purpose
🎬 Render Engineer tạo quick preview để validate animation.

## Agent
**render-engineer** (🎬)

## Trigger
Step 03 completed với code approved.

## Actions

### 1. Load Agent
```
Load: ./agents/render-engineer.md
```

### 2. Modify Config for Preview
```python
# Temporary preview settings
VideoConfig(
    width=854,
    height=480,
    fps=15,
    duration=90,
    bitrate=1500,
    output_path="{workspace}/output/preview.mp4"
)
```

### 3. Execute Preview Render
```bash
cd "$WORKSPACE"

# Modify script for preview settings
# Run with reduced quality
python3 src/{topic}_animation.py --preview
```

Hoặc nếu script không hỗ trợ --preview:
```bash
# Create temporary preview script
# with modified VideoConfig
python3 src/{topic}_animation_preview.py
```

### 4. Validate Preview
```bash
ffprobe -v error \
  -show_entries format=duration \
  -show_entries stream=width,height \
  -of default=noprint_wrappers=1 \
  "$WORKSPACE/output/preview.mp4"
```

Expected output:
```
width=854
height=480
duration=90.000000
```

### 5. Log Preview Status
```
🎬 PREVIEW RENDER COMPLETE
├── File: {path}
├── Size: {size} MB
├── Duration: {duration}s
├── Resolution: 480p @ 15fps
└── Render time: {time}

Preview ready for review.
```

## Autonomous Mode
Nếu `autonomous.auto_approve.render_preview: true`:
- Nếu validation pass → auto continue
- Nếu fail → pause for human review

## Transition
→ Step 05: Review Loop

## Error Handling
- Render failed: Check error, fix code
- Duration wrong: Adjust frame count
- File not created: Check disk space, paths
