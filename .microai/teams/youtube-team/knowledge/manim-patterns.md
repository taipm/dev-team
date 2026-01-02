# Manim Patterns for Math Videos

> Common patterns và best practices khi code Manim animations

## Setup Patterns

### Standard Scene
```python
from manim import *

class MyScene(Scene):
    def construct(self):
        # 1. Create objects
        # 2. Initial animations
        # 3. Main content
        # 4. Conclusion
        pass
```

### 3D Scene
```python
from manim import *

class My3DScene(ThreeDScene):
    def construct(self):
        self.set_camera_orientation(phi=60*DEGREES, theta=-45*DEGREES)
        # Content here
```

### Config for Shorts
```python
from manim import *

# Set before class definition
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920
```

## Geometry Patterns

### Triangle with Labels
```python
def create_labeled_triangle(A, B, C):
    """Create triangle with vertex labels"""
    triangle = Polygon(A, B, C, color=WHITE)
    labels = VGroup(
        MathTex("A").next_to(A, UP),
        MathTex("B").next_to(B, DL),
        MathTex("C").next_to(C, DR)
    )
    return VGroup(triangle, labels)
```

### Circumcircle
```python
def get_circumcircle(A, B, C):
    """Calculate and create circumcircle"""
    # Circumcenter calculation
    D = 2 * (A[0] * (B[1] - C[1]) + B[0] * (C[1] - A[1]) + C[0] * (A[1] - B[1]))
    ux = ((A[0]**2 + A[1]**2) * (B[1] - C[1]) +
          (B[0]**2 + B[1]**2) * (C[1] - A[1]) +
          (C[0]**2 + C[1]**2) * (A[1] - B[1])) / D
    uy = ((A[0]**2 + A[1]**2) * (C[0] - B[0]) +
          (B[0]**2 + B[1]**2) * (A[0] - C[0]) +
          (C[0]**2 + C[1]**2) * (B[0] - A[0])) / D
    center = np.array([ux, uy, 0])
    radius = np.linalg.norm(A - center)
    return Circle(radius=radius, color=BLUE).move_to(center), center
```

### Right Angle Mark
```python
def right_angle_mark(p1, vertex, p2, size=0.3):
    """Draw right angle mark at vertex"""
    v1 = (p1 - vertex) / np.linalg.norm(p1 - vertex) * size
    v2 = (p2 - vertex) / np.linalg.norm(p2 - vertex) * size
    return Polygon(
        vertex + v1,
        vertex + v1 + v2,
        vertex + v2,
        color=WHITE,
        fill_opacity=0
    )
```

## Graph Patterns

### Function with Axes
```python
def create_function_plot(func, x_range=[-4, 4], color=BLUE):
    """Standard function plot setup"""
    axes = Axes(
        x_range=[x_range[0], x_range[1], 1],
        y_range=[-4, 4, 1],
        axis_config={"include_numbers": True}
    )
    graph = axes.plot(func, color=color)
    return axes, graph
```

### Animated Function Drawing
```python
def animate_function(self, axes, func, color=BLUE):
    """Animate drawing a function"""
    graph = axes.plot(func, color=color)
    self.play(Create(axes), run_time=2)
    self.play(Create(graph), run_time=3)
    return graph
```

### Tangent Line
```python
def get_tangent_line(axes, func, x, length=4):
    """Get tangent line at x with derivative"""
    from scipy.misc import derivative
    y = func(x)
    slope = derivative(func, x, dx=1e-8)

    start = axes.c2p(x - length/2, y - slope * length/2)
    end = axes.c2p(x + length/2, y + slope * length/2)

    return Line(start, end, color=RED)
```

## Equation Patterns

### Step-by-Step Transform
```python
def equation_steps(self, equations):
    """Animate through equation transformations"""
    current = MathTex(equations[0]).to_edge(UP)
    self.play(Write(current))

    for next_eq in equations[1:]:
        next_tex = MathTex(next_eq).to_edge(UP)
        self.play(TransformMatchingTex(current, next_tex))
        self.wait(1)
        current = next_tex
```

### Highlight Parts
```python
def highlight_equation_part(self, tex, indices, color=YELLOW):
    """Highlight specific parts of equation"""
    highlights = [tex[i].copy().set_color(color) for i in indices]
    self.play(*[Indicate(h) for h in highlights])
```

### Equation with Box
```python
def boxed_equation(content, color=YELLOW):
    """Create boxed equation for emphasis"""
    tex = MathTex(content)
    box = SurroundingRectangle(tex, color=color, buff=0.2)
    return VGroup(tex, box)
```

## Animation Patterns

### Reveal Sequence
```python
def reveal_sequence(self, objects, lag_ratio=0.2):
    """Reveal objects with staggered timing"""
    self.play(LaggedStart(
        *[FadeIn(obj, shift=UP) for obj in objects],
        lag_ratio=lag_ratio
    ))
```

### Transform with Trail
```python
def transform_with_trace(self, obj, path, color=YELLOW):
    """Transform object and leave a trace"""
    trace = TracedPath(obj.get_center, stroke_color=color)
    self.add(trace)
    self.play(MoveAlongPath(obj, path))
```

### Emphasis Flash
```python
def emphasize(self, obj, color=YELLOW):
    """Strong emphasis animation"""
    self.play(
        Flash(obj.get_center(), color=color),
        Indicate(obj, color=color)
    )
```

## Text Patterns

### Title with Underline
```python
def create_title(text, font_size=48):
    """Create title with underline"""
    title = Text(text, font_size=font_size)
    underline = Line(
        title.get_left() + DOWN*0.2,
        title.get_right() + DOWN*0.2,
        color=YELLOW
    )
    return VGroup(title, underline).to_edge(UP)
```

### Bullet Points
```python
def bullet_list(items, spacing=0.8):
    """Create animated bullet list"""
    bullets = VGroup()
    for i, item in enumerate(items):
        bullet = VGroup(
            Dot(color=YELLOW),
            Text(item, font_size=32)
        ).arrange(RIGHT, buff=0.3)
        bullet.shift(DOWN * i * spacing)
        bullets.add(bullet)
    return bullets.to_edge(LEFT, buff=1)
```

## Utility Functions

### Vietnamese Text
```python
def vn_text(content, **kwargs):
    """Vietnamese text with proper font"""
    return Text(content, font="Be Vietnam Pro", **kwargs)

def vn_title(content):
    """Vietnamese title"""
    return vn_text(content, font_size=48, weight=BOLD)
```

### Consistent Colors
```python
# Color constants
MATH_BLUE = "#1C758A"
HIGHLIGHT = "#FFFF00"
ACCENT = "#FF8C00"
SUCCESS = "#83C167"
ERROR = "#FC6255"
```

### Safe Point Access
```python
def safe_point(arr):
    """Ensure point is 3D numpy array"""
    if isinstance(arr, (list, tuple)):
        arr = np.array(arr)
    if len(arr) == 2:
        arr = np.array([arr[0], arr[1], 0])
    return arr
```

## Quality Checklist

- [ ] Animations are smooth (no jarring cuts)
- [ ] Text is readable at target resolution
- [ ] Colors have good contrast
- [ ] Key moments have appropriate timing
- [ ] No unnecessary complexity
- [ ] Vietnamese displays correctly
