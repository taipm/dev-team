# Manim Animation Patterns

## 1. Graph Animations

### Plot with Tracing Dot

```python
from manim import *

class TracingDot(Scene):
    def construct(self):
        axes = Axes(x_range=[-3, 3], y_range=[-2, 2])
        func = axes.plot(lambda x: np.sin(x), color=BLUE)

        # Dot that traces the curve
        dot = Dot(color=YELLOW)
        dot.move_to(axes.c2p(-3, np.sin(-3)))

        self.play(Create(axes), Create(func))
        self.play(MoveAlongPath(dot, func), run_time=4)
```

### Multiple Functions Comparison

```python
class MultipleFunctions(Scene):
    def construct(self):
        axes = Axes(x_range=[-4, 4], y_range=[-2, 2])

        sin_graph = axes.plot(np.sin, color=BLUE)
        cos_graph = axes.plot(np.cos, color=RED)

        sin_label = axes.get_graph_label(sin_graph, r"\sin(x)")
        cos_label = axes.get_graph_label(cos_graph, r"\cos(x)")

        self.play(Create(axes))
        self.play(Create(sin_graph), Write(sin_label))
        self.play(Create(cos_graph), Write(cos_label))
```

### Animated Function Parameter

```python
class ParameterAnimation(Scene):
    def construct(self):
        axes = Axes(x_range=[-4, 4], y_range=[-3, 3])

        # ValueTracker for parameter
        a = ValueTracker(1)

        # Graph that updates with parameter
        graph = always_redraw(
            lambda: axes.plot(
                lambda x: a.get_value() * np.sin(x),
                color=BLUE
            )
        )

        label = always_redraw(
            lambda: MathTex(
                f"f(x) = {a.get_value():.1f}\\sin(x)"
            ).to_corner(UL)
        )

        self.play(Create(axes), Create(graph), Write(label))
        self.play(a.animate.set_value(2), run_time=2)
        self.play(a.animate.set_value(0.5), run_time=2)
```

---

## 2. Calculus Visualizations

### Limit Visualization

```python
class LimitVisualization(Scene):
    def construct(self):
        axes = Axes(x_range=[-1, 5], y_range=[-1, 4])

        func = axes.plot(lambda x: (x**2 - 1)/(x - 1) if x != 1 else 2, color=BLUE)

        # Point approaching limit
        x_tracker = ValueTracker(0)

        dot = always_redraw(
            lambda: Dot(
                axes.c2p(x_tracker.get_value(), (x_tracker.get_value()**2 - 1)/(x_tracker.get_value() - 1) if x_tracker.get_value() != 1 else 2),
                color=YELLOW
            )
        )

        # Vertical line to show x position
        v_line = always_redraw(
            lambda: axes.get_vertical_line(
                axes.c2p(x_tracker.get_value(), 0),
                color=YELLOW
            )
        )

        self.play(Create(axes), Create(func))
        self.add(dot, v_line)
        self.play(x_tracker.animate.set_value(0.99), run_time=3)
```

### Riemann Sum

```python
class RiemannSum(Scene):
    def construct(self):
        axes = Axes(x_range=[0, 5], y_range=[0, 10])
        func = axes.plot(lambda x: 0.5 * x**2, color=BLUE)

        # Number of rectangles
        n = ValueTracker(4)

        rects = always_redraw(
            lambda: axes.get_riemann_rectangles(
                func,
                x_range=[1, 4],
                dx=3/n.get_value(),
                color=[BLUE, GREEN],
                fill_opacity=0.5
            )
        )

        self.play(Create(axes), Create(func))
        self.play(Create(rects))
        self.play(n.animate.set_value(20), run_time=4)
        self.play(n.animate.set_value(50), run_time=2)
```

### Tangent Line Animation

```python
class TangentLine(Scene):
    def construct(self):
        axes = Axes(x_range=[-3, 3], y_range=[-1, 9])
        func = axes.plot(lambda x: x**2, color=BLUE)

        x = ValueTracker(-2)

        tangent = always_redraw(
            lambda: axes.get_secant_slope_group(
                x=x.get_value(),
                graph=func,
                dx=0.01,
                secant_line_length=6,
                secant_line_color=RED
            )
        )

        dot = always_redraw(
            lambda: Dot(axes.c2p(x.get_value(), x.get_value()**2), color=YELLOW)
        )

        self.play(Create(axes), Create(func))
        self.add(tangent, dot)
        self.play(x.animate.set_value(2), run_time=5, rate_func=smooth)
```

---

## 3. Vector & Matrix

### Vector Field

```python
class VectorFieldScene(Scene):
    def construct(self):
        func = lambda pos: np.array([pos[1], -pos[0], 0])

        vector_field = ArrowVectorField(
            func,
            x_range=[-3, 3],
            y_range=[-3, 3]
        )

        self.play(Create(vector_field))
        self.wait()
```

### Matrix Transformation

```python
class MatrixTransform(Scene):
    def construct(self):
        plane = NumberPlane()
        vector = Arrow(ORIGIN, [2, 1, 0], buff=0, color=YELLOW)

        matrix = [[2, 1], [1, 2]]
        matrix_tex = Matrix(matrix).to_corner(UL)

        self.play(Create(plane), Create(vector))
        self.play(Write(matrix_tex))
        self.play(
            ApplyMatrix(matrix, plane),
            ApplyMatrix(matrix, vector),
            run_time=3
        )
```

---

## 4. 3D Animations

### Rotating Surface

```python
class RotatingSurface(ThreeDScene):
    def construct(self):
        axes = ThreeDAxes()

        surface = Surface(
            lambda u, v: axes.c2p(
                u * np.cos(v),
                u * np.sin(v),
                u**2
            ),
            u_range=[0, 2],
            v_range=[0, TAU],
            resolution=(20, 40)
        )
        surface.set_color_by_gradient(BLUE, GREEN)

        self.set_camera_orientation(phi=60*DEGREES, theta=-45*DEGREES)
        self.play(Create(axes), Create(surface))
        self.begin_ambient_camera_rotation(rate=0.3)
        self.wait(6)
```

### Parametric Curve 3D

```python
class ParametricCurve3D(ThreeDScene):
    def construct(self):
        axes = ThreeDAxes()

        helix = ParametricFunction(
            lambda t: axes.c2p(
                np.cos(t),
                np.sin(t),
                t / 4
            ),
            t_range=[0, 4*PI],
            color=BLUE
        )

        self.set_camera_orientation(phi=75*DEGREES, theta=30*DEGREES)
        self.play(Create(axes), Create(helix), run_time=3)
        self.begin_ambient_camera_rotation(rate=0.2)
        self.wait(5)
```

---

## 5. Text & Formula Animations

### Equation Transform

```python
class EquationTransform(Scene):
    def construct(self):
        eq1 = MathTex(r"x^2 + 2x + 1")
        eq2 = MathTex(r"(x + 1)^2")

        self.play(Write(eq1))
        self.wait()
        self.play(TransformMatchingTex(eq1, eq2))
        self.wait()
```

### Step-by-Step Solution

```python
class StepByStep(Scene):
    def construct(self):
        steps = VGroup(
            MathTex(r"\int x^2 dx"),
            MathTex(r"= \frac{x^{2+1}}{2+1} + C"),
            MathTex(r"= \frac{x^3}{3} + C")
        ).arrange(DOWN, aligned_edge=LEFT)

        for step in steps:
            self.play(Write(step))
            self.wait(0.5)
```

---

## 6. YouTube Shorts Patterns

### Vertical Layout

```python
# Config cho 9:16
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920

class ShortPattern(Scene):
    def construct(self):
        # Top: Title
        title = Text("Math Trick!", font_size=72)
        title.to_edge(UP, buff=0.5)

        # Middle: Content
        axes = Axes(
            x_range=[-2, 2],
            y_range=[-1, 4],
            x_length=7,
            y_length=8
        )

        # Bottom: Formula
        formula = MathTex(r"(a+b)^2 = a^2 + 2ab + b^2", font_size=48)
        formula.to_edge(DOWN, buff=0.5)

        self.play(Write(title), run_time=0.5)
        self.play(Create(axes), run_time=1)
        self.play(Write(formula), run_time=0.5)
        self.wait(1)
```

### Quick Reveal Pattern

```python
class QuickReveal(Scene):
    def construct(self):
        question = Text("What is 25 × 25?", font_size=60)
        answer = MathTex("625", font_size=120, color=YELLOW)

        self.play(Write(question), run_time=0.5)
        self.wait(2)
        self.play(
            question.animate.shift(UP*2),
            run_time=0.3
        )
        self.play(Write(answer), run_time=0.3)
        self.wait(1)
```

---

## 7. Utility Patterns

### Progress Indicator

```python
class WithProgress(Scene):
    def construct(self):
        # Progress bar at bottom
        progress = Rectangle(
            width=12, height=0.1,
            color=GREY, fill_opacity=0.3
        ).to_edge(DOWN, buff=0.2)

        progress_fill = Rectangle(
            width=0, height=0.1,
            color=BLUE, fill_opacity=1
        ).align_to(progress, LEFT).to_edge(DOWN, buff=0.2)

        self.add(progress)

        # Your content here
        content = Circle()
        self.play(
            Create(content),
            progress_fill.animate.set_width(12, stretch=True, about_edge=LEFT),
            run_time=3
        )
```

### Highlight Box

```python
class Highlight(Scene):
    def construct(self):
        equation = MathTex(r"E = mc^2")

        box = SurroundingRectangle(equation, color=YELLOW, buff=0.2)

        self.play(Write(equation))
        self.play(Create(box))
        self.play(
            box.animate.set_color(RED),
            rate_func=there_and_back,
            run_time=0.5
        )
```

---

*Manim Patterns Reference - Animated Math Skill*
