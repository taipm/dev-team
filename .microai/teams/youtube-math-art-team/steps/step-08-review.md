# Step 05: Review Loop

## Purpose
🔍 Quality Reviewer + 🧮 Developer iterate để đạt quality.

## Agents
- **quality-reviewer** (🔍) - Primary
- **algorithm-dev** (🧮) - For fixes

## Trigger
Step 04 completed với preview rendered.

## Actions

### 1. Load Reviewer
```
Load: ./agents/quality-reviewer.md
```

### 2. Review Preview

Reviewer checks:

```markdown
## 🔍 PREVIEW REVIEW

### Technical Validation
```bash
ffprobe -v error -show_entries format=duration,size \
  -show_entries stream=width,height,codec_name \
  -of json "{workspace}/output/preview.mp4"
```

### Visual Assessment
| Aspect | Rating | Notes |
|--------|--------|-------|
| Color accuracy | {1-10} | {notes} |
| Animation smoothness | {1-10} | {notes} |
| Mathematical correctness | {1-10} | {notes} |
| Visual appeal | {1-10} | {notes} |
| Timing/pacing | {1-10} | {notes} |

### Issues Found
| Priority | Issue | Fix Required |
|----------|-------|--------------|
| {P} | {issue} | {fix} |

### Verdict
{APPROVED / NEEDS_FIX}
```

### 3. If NEEDS_FIX

#### 3a. Developer Fixes
```
Load: ./agents/algorithm-dev.md
```

Developer receives issues và fixes:
- Update code
- Re-run preview render
- Submit for re-review

#### 3b. Increment Iteration
```yaml
iteration_count: {n+1}
max_iterations: 3
```

#### 3c. Check Max Iterations
Nếu `iteration_count >= max_iterations`:
- Warn user
- Ask: continue or accept current state?

### 4. If APPROVED

```
✅ QUALITY APPROVED

Overall Rating: {average}/10
Ready for final render.

Proceeding to Step 06...
```

### 5. Create Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-05-review-{iteration}.yaml
```

## BREAKPOINT (After Approval)

```
═══════════════════════════════════════════════════════════════
                    [BREAKPOINT] FINAL RENDER
═══════════════════════════════════════════════════════════════
Preview approved. Ready for final render.

Render options:
  *720  - Render 720p only (faster)
  *1080 - Also render 1080p (parallel)
  [Enter] - Use default (720p only)

Options:
  [Enter] - Continue với default
  *1080 - Enable 1080p render
  *exit - Save và exit
═══════════════════════════════════════════════════════════════
```

## Review Loop Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      REVIEW LOOP                             │
│                                                              │
│   🔍 Reviewer ──review──▶ APPROVED ──────────▶ Step 06      │
│        │                                                     │
│        ▼                                                     │
│   NEEDS_FIX                                                  │
│        │                                                     │
│        ▼                                                     │
│   🧮 Developer ──fix──▶ 🎬 Preview ──▶ 🔍 Reviewer          │
│        │                                                     │
│        ▼                                                     │
│   iteration++ (max 3)                                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Transition
→ Step 06: Final Render

## Error Handling
- Max iterations reached: Ask user decision
- Critical issue found: Pause, notify user
- Reviewer và Dev disagree: Escalate to user
