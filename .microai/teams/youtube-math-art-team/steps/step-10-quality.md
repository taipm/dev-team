# Step 07: Quality Check

## Purpose
🔍 Final validation của output files.

## Agent
**quality-reviewer** (🔍)

## Trigger
Step 06 completed với files rendered.

## Actions

### 1. Load Agent
```
Load: ./agents/quality-reviewer.md
```

### 2. Validate All Outputs

```bash
# List generated files
ls -la "$WORKSPACE/output/"
```

### 3. Check Each Video

#### 720p Validation
```bash
ffprobe -v error \
  -show_entries format=duration,size,bit_rate \
  -show_entries stream=width,height,r_frame_rate,codec_name \
  -of json \
  "{workspace}/output/{topic}_720p.mp4"
```

Expected:
```json
{
  "streams": [{
    "codec_name": "h264",
    "width": 1280,
    "height": 720,
    "r_frame_rate": "30/1"
  }],
  "format": {
    "duration": "90.000000",
    "size": "<50000000",
    "bit_rate": "~5000000"
  }
}
```

#### 1080p Validation (if exists)
```bash
ffprobe -v error \
  -show_entries format=duration,size,bit_rate \
  -show_entries stream=width,height,r_frame_rate,codec_name \
  -of json \
  "{workspace}/output/{topic}_1080p.mp4"
```

Expected:
```json
{
  "streams": [{
    "codec_name": "h264",
    "width": 1920,
    "height": 1080,
    "r_frame_rate": "60/1"
  }],
  "format": {
    "duration": "90.000000",
    "size": "<100000000",
    "bit_rate": "~8000000"
  }
}
```

#### Thumbnail Validation
```bash
file "{workspace}/output/thumbnail.png"
# Expected: PNG image data, 1280 x 720
```

### 4. Generate Quality Report

```markdown
## 🔍 FINAL QUALITY REPORT

### Files Validated

| File | Size | Duration | Resolution | FPS | Codec | Status |
|------|------|----------|------------|-----|-------|--------|
| {topic}_720p.mp4 | {size}MB | 90s | 1280x720 | 30 | H.264 | ✅ |
| {topic}_1080p.mp4 | {size}MB | 90s | 1920x1080 | 60 | H.264 | ✅ |
| thumbnail.png | {size}KB | - | 1280x720 | - | PNG | ✅ |

### Validation Summary

Technical:
- [ ] All files exist
- [ ] Duration = 90s (±1s)
- [ ] Codec = H.264
- [ ] Resolution matches spec
- [ ] File size reasonable

YouTube Ready:
- [ ] -movflags +faststart (streaming)
- [ ] yuv420p pixel format
- [ ] Thumbnail generated

### Final Verdict
{PASSED / FAILED}
```

### 5. Handle Failures

Nếu validation fails:
- Identify issue
- Return to Step 06 for re-render
- Or escalate to user

### 6. Log Approval

```
✅ QUALITY CHECK PASSED

All files validated successfully.
Ready for Kanban update.

Proceeding to Step 08...
```

## Transition
→ Step 08: Synthesis

## Error Handling
- File missing: Re-render
- Duration wrong: Check frame count in code
- Codec wrong: Check FFMpegWriter settings
- Size too large: Increase CRF, reduce bitrate
