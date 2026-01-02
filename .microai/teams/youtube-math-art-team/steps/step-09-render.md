# Step 06: Final Render

## Purpose
🎬 Render Engineer produces final video(s) với full quality.

## Agent
**render-engineer** (🎬)

## Trigger
Step 05 completed với quality approved.

## Parallel Execution

Nếu `parallel.enabled: true` và user requests 1080p:

```
┌────────────────────────────────────────────────────────────┐
│                    PARALLEL RENDER                          │
│                                                             │
│   ┌─────────────────┐        ┌─────────────────┐           │
│   │   720p @ 30fps  │        │  1080p @ 60fps  │           │
│   │   (required)    │        │   (optional)    │           │
│   │                 │        │                 │           │
│   │  Worker 1       │        │  Worker 2       │           │
│   └────────┬────────┘        └────────┬────────┘           │
│            │                          │                     │
│            ▼                          ▼                     │
│       {topic}_720p.mp4          {topic}_1080p.mp4          │
│                                                             │
│   sync: wait_all                                            │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

## Actions

### 1. Load Agent
```
Load: ./agents/render-engineer.md
```

### 2. Prepare Final Configs

#### 720p Standard (Required)
```python
VideoConfig(
    width=1280,
    height=720,
    fps=30,
    duration=90,
    dpi=100,
    bitrate=5000,
    output_path="{workspace}/output/{topic}_720p.mp4"
)
```

#### 1080p Premium (Optional)
```python
VideoConfig(
    width=1920,
    height=1080,
    fps=60,
    duration=90,
    dpi=120,
    bitrate=8000,
    output_path="{workspace}/output/{topic}_1080p.mp4"
)
```

### 3. Execute Render(s)

#### Sequential (default)
```bash
cd "$WORKSPACE"
python3 src/{topic}_animation.py
```

#### Parallel (if enabled)
```bash
# Worker 1: 720p
python3 src/{topic}_animation.py --resolution 720p &
PID1=$!

# Worker 2: 1080p
python3 src/{topic}_animation.py --resolution 1080p &
PID2=$!

# Wait for both
wait $PID1 $PID2
```

### 4. Monitor Progress
```
🎬 FINAL RENDER IN PROGRESS

720p @ 30fps:
├── Frames: {current}/{total}
├── Progress: {percent}%
├── ETA: {time}
└── Status: Rendering...

1080p @ 60fps: (if enabled)
├── Frames: {current}/{total}
├── Progress: {percent}%
├── ETA: {time}
└── Status: Rendering...
```

### 5. Validate Outputs
```bash
# Validate 720p
ffprobe -v error \
  -show_entries format=duration,size \
  -show_entries stream=width,height,r_frame_rate,codec_name \
  -of default=noprint_wrappers=1 \
  "{workspace}/output/{topic}_720p.mp4"

# Expected:
# codec_name=h264
# width=1280
# height=720
# r_frame_rate=30/1
# duration=90.000000
```

### 6. Generate Thumbnail
```bash
# Extract frame at 45s (middle of video)
ffmpeg -i "{workspace}/output/{topic}_720p.mp4" \
  -ss 45 -vframes 1 -q:v 2 \
  "{workspace}/output/thumbnail.png"
```

### 7. Log Completion
```
🎬 FINAL RENDER COMPLETE

Files generated:
├── {topic}_720p.mp4 ({size}MB)
├── {topic}_1080p.mp4 ({size}MB) [if enabled]
└── thumbnail.png

Total render time: {time}
```

### 8. Create Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-06-render.yaml
```

## Timeout Handling

Nếu render exceeds `autonomous.thresholds.max_render_time` (10 min):
- Log warning
- Continue waiting (không cancel)
- Notify user of delay

## Transition
→ Step 07: Quality Check

## Error Handling
- Render crashed: Capture error, attempt retry with lower settings
- Out of disk space: Alert user, cleanup temp files
- FFmpeg error: Check codec availability, fallback settings
