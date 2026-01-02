# 3Blue1Brown Style Guide

> Hướng dẫn tạo video toán học theo phong cách Grant Sanderson

## Core Philosophy

### 1. Visual First
- Mọi concept đều có visual representation
- Equations xuất hiện từ geometric transformations
- Animation giúp hiểu, không chỉ để đẹp

### 2. Intuition Over Rigor
- Xây dựng intuition trước
- Rigor sau khi đã hiểu
- "Why" quan trọng hơn "what"

### 3. Build Towards Discovery
- Không spoil kết quả ngay
- Dẫn dắt viewer tự khám phá
- "Aha moments" là đỉnh cao

## Narrative Structure

### The Hook (0-30 seconds)
```
Pattern:
1. Surprising statement or question
2. Visual teaser
3. Promise of insight

Examples:
- "What if I told you that all triangles are actually the same?"
- "There's a hidden pattern in every prime number..."
- "This simple shape contains an entire branch of mathematics"
```

### The Setup (30s - 2 min)
```
Pattern:
1. Clear problem statement
2. Visual representation
3. Why should we care?

Keys:
- No jargon yet
- Make it relatable
- Set up the mystery
```

### The Exploration (2-6 min)
```
Pattern:
1. Try obvious approaches
2. Show where they fail or get messy
3. Hint at something deeper

Keys:
- Build tension
- Let viewer think along
- Foreshadow the insight
```

### The Insight (6-10 min)
```
Pattern:
1. Pause before reveal
2. Show the key transformation
3. Watch understanding click

Keys:
- Dramatic timing
- Smooth animation transition
- "Do you see it?"
```

### The Resolution (10-12 min)
```
Pattern:
1. Complete the proof/solution
2. Show elegance of the approach
3. Connect to bigger picture

Keys:
- Satisfying conclusion
- Generalization hints
- Leave something to ponder
```

## Visual Language

### Color Palette
```yaml
primary:
  blue: "#1C758A"      # Main objects
  yellow: "#FFFF00"    # Highlights
  green: "#83C167"     # Positive/success

secondary:
  red: "#FC6255"       # Negative/danger
  purple: "#9A72AC"    # Special/magic
  orange: "#FF8C00"    # Attention

background:
  dark: "#1C1C1C"      # Standard background
  light: "#FFFFFF"     # Emphasis areas
```

### Typography
```yaml
math:
  font: "Computer Modern"
  size: "Large, readable"
  color: "White on dark"

labels:
  font: "Helvetica Neue"
  size: "Medium"
  color: "Match object color"

titles:
  font: "Bold sans-serif"
  size: "Very large"
  duration: "3-5 seconds"
```

### Animation Timing
```yaml
fast:
  duration: 0.3s
  use: "Quick reveals, snappy transforms"

standard:
  duration: 1.0s
  use: "Most animations"

slow:
  duration: 2.0s
  use: "Key insights, complex transforms"

very_slow:
  duration: 3.0s+
  use: "Let understanding sink in"
```

## Common Patterns

### Transformation Reveal
```python
# Before: messy form
eq1 = MathTex(r"x^2 + 2xy + y^2")

# After: elegant form
eq2 = MathTex(r"(x + y)^2")

# Magic moment
self.play(TransformMatchingTex(eq1, eq2))
self.wait(2)  # Let it sink in
```

### Geometric Discovery
```python
# Start simple
triangle = Triangle()
self.play(Create(triangle))

# Add element that reveals pattern
circumcircle = Circle().move_to(triangle.get_center())
self.play(Create(circumcircle))

# Highlight the insight
self.play(Flash(triangle.get_vertices()[0]))
```

### Building Complexity
```python
# Start with one
dot = Dot()
self.play(Create(dot))

# Multiply with purpose
dots = VGroup(*[Dot() for _ in range(10)])
self.play(LaggedStart(*[Create(d) for d in dots]))

# Show pattern
self.play(dots.animate.arrange_in_grid())
```

## Narration Guidelines

### Tone
- Curious, not lecturing
- "We" not "I" or "you"
- Wonder at the math
- Conversational pacing

### Phrases
```
Good:
- "But here's where it gets interesting..."
- "Watch what happens when we..."
- "Do you see the pattern?"
- "And this is the beautiful part..."

Avoid:
- "Obviously..."
- "It's easy to see that..."
- "You should know that..."
- "Remember this formula..."
```

### Pacing
```
Statement → [pause] → Visual → [let sink in] → Next thought

Don't rush through insights
Silence during key animations
Let viewer's brain catch up
```

## Technical Excellence

### Resolution
- Minimum 1080p for YouTube
- 4K for premium content
- 60fps for smooth animation

### Audio
- Clear voiceover
- Subtle background music (if any)
- No distracting sounds

### Thumbnails
- Bold, simple
- One key visual
- Readable at small size
- Hint at the mystery

## Reference Videos

Study these for style:
1. "But what is the Fourier Transform?"
2. "The essence of calculus"
3. "Visualizing quaternions"
4. "How to count to 1000 on two hands"

---

*Style guide based on 3Blue1Brown/Grant Sanderson's work*
