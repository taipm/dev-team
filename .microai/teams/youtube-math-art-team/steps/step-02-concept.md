# Step 02: Concept Design

## Purpose
🎨 Concept Designer tạo visual concept cho animation.

## Agent
**concept-designer** (🎨)

## Trigger
Step 01 completed với topic xác định.

## Actions

### 1. Load Agent
```
Load: ./agents/concept-designer.md
```

### 2. Analyze Topic
Agent phân tích topic:
- Loại mathematical concept (fractal, chaos, curve, etc.)
- Visual potential
- Complexity level
- Viral potential

### 3. Design Visual Concept

Agent output concept document:

```markdown
## 🎨 CONCEPT: {Topic Name}

### Overview
{Brief description of the mathematical concept}

### Visual Theme
{Theme description - neon, organic, geometric, etc.}

### Color Palette
```python
COLORS = {
    'background': '#0a0a0f',
    'primary': '{hex}',      # {description}
    'secondary': '{hex}',    # {description}
    'accent': '{hex}',       # {description}
    'glow': '{hex}',         # {description}
}
```

### Animation Structure (90s)
| Phase | Time | Description | Visual |
|-------|------|-------------|--------|
| Intro | 0-5s | {desc} | {visual} |
| Build 1 | 5-25s | {desc} | {visual} |
| Build 2 | 25-50s | {desc} | {visual} |
| Climax | 50-80s | {desc} | {visual} |
| Outro | 80-90s | {desc} | {visual} |

### Technical Requirements
- Estimated complexity: {low/medium/high}
- Key algorithms: {list}
- Special effects: {list}

### Viral Assessment
- Hook factor: {rating}/10
- Visual appeal: {rating}/10
- Uniqueness: {rating}/10
```

### 4. Save Concept Document
```bash
# Save to workspace
echo "{concept_content}" > "$WORKSPACE/docs/concept.md"
```

### 5. Create Checkpoint
```
checkpoints/session-{timestamp}/checkpoint-02-concept.yaml
```

## BREAKPOINT

```
═══════════════════════════════════════════════════════════════
                    [BREAKPOINT] CONCEPT REVIEW
═══════════════════════════════════════════════════════════════
Concept document created at: {path}

Options:
  [Enter] - Approve và continue to Algorithm
  @concept: <feedback> - Request changes
  *skip - Skip to algorithm với default concept
  *exit - Save và exit
═══════════════════════════════════════════════════════════════
```

## Autonomous Mode
Nếu `autonomous.auto_approve.concept: true`:
- Auto-approve sau 5 seconds
- Log approval reason

## Transition
→ Step 03: Algorithm Development

## Error Handling
- Nếu topic quá mơ hồ: Ask user for clarification
- Nếu concept không đủ detail: Request more specifics
