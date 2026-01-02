# Advanced Manim Techniques

> Kỹ thuật Manim nâng cao cho video toán học chất lượng cao

## 1. Hệ Thống Tọa Độ và Positioning

### 1.1 Coordinate System Fundamentals

```python
from manim import *

# Manim coordinate system:
# - Origin (0, 0, 0) is at center of screen
# - X: left (-) to right (+), range ~[-7.1, 7.1] for 16:9
# - Y: down (-) to up (+), range ~[-4, 4]
# - Z: into screen (-) to out of screen (+)

# Frame dimensions
FRAME_WIDTH = config.frame_width   # Default: 14.222...
FRAME_HEIGHT = config.frame_height # Default: 8

# Useful constants
LEFT_SIDE = LEFT * FRAME_WIDTH / 2
RIGHT_SIDE = RIGHT * FRAME_WIDTH / 2
TOP = UP * FRAME_HEIGHT / 2
BOTTOM = DOWN * FRAME_HEIGHT / 2
```

### 1.2 Relative Positioning

```python
class RelativePositioning(Scene):
    def construct(self):
        # Absolute positioning
        circle = Circle().move_to(np.array([2, 1, 0]))

        # Relative to another object
        square = Square().next_to(circle, RIGHT, buff=0.5)

        # Align with another object
        triangle = Triangle().align_to(circle, UP)  # Align tops

        # Position relative to screen edges
        text = Text("Hello").to_edge(UP, buff=0.5)

        # Corner positioning
        logo = Dot().to_corner(DR, buff=0.3)  # Down-Right

        # Shift (relative move)
        obj = Square()
        obj.shift(RIGHT * 2 + UP * 1)  # Move by vector

        # Center on point
        obj.move_to(ORIGIN)
```

### 1.3 Smart Positioning với Updaters

```python
class SmartPositioning(Scene):
    def construct(self):
        # Object A
        dot = Dot(color=YELLOW)

        # Object B always follows A
        label = Text("Point", font_size=24)
        label.add_updater(lambda m: m.next_to(dot, UP, buff=0.2))

        self.add(dot, label)
        self.play(dot.animate.shift(RIGHT * 3))
        self.play(dot.animate.shift(UP * 2))

        # Remove updater when done
        label.clear_updaters()
```

## 2. Tính Toán Hình Học Chính Xác

### 2.1 Triangle Calculations

```python
import numpy as np

def triangle_centroid(A, B, C):
    """Trọng tâm tam giác"""
    return (np.array(A) + np.array(B) + np.array(C)) / 3

def triangle_circumcenter(A, B, C):
    """Tâm đường tròn ngoại tiếp"""
    A, B, C = np.array(A), np.array(B), np.array(C)
    ax, ay = A[0], A[1]
    bx, by = B[0], B[1]
    cx, cy = C[0], C[1]

    D = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
    if abs(D) < 1e-10:
        return None  # Degenerate triangle

    ux = ((ax**2 + ay**2) * (by - cy) +
          (bx**2 + by**2) * (cy - ay) +
          (cx**2 + cy**2) * (ay - by)) / D
    uy = ((ax**2 + ay**2) * (cx - bx) +
          (bx**2 + by**2) * (ax - cx) +
          (cx**2 + cy**2) * (bx - ax)) / D

    return np.array([ux, uy, 0])

def triangle_incenter(A, B, C):
    """Tâm đường tròn nội tiếp"""
    A, B, C = np.array(A), np.array(B), np.array(C)
    a = np.linalg.norm(B - C)  # Side opposite to A
    b = np.linalg.norm(C - A)  # Side opposite to B
    c = np.linalg.norm(A - B)  # Side opposite to C

    return (a * A + b * B + c * C) / (a + b + c)

def triangle_orthocenter(A, B, C):
    """Trực tâm tam giác"""
    A, B, C = np.array(A), np.array(B), np.array(C)

    # H = A + B + C - 2*O (where O is circumcenter)
    O = triangle_circumcenter(A, B, C)
    if O is None:
        return None
    return A + B + C - 2 * O

def altitude_foot(vertex, line_start, line_end):
    """Chân đường cao từ vertex xuống đường thẳng"""
    vertex = np.array(vertex)
    line_start = np.array(line_start)
    line_end = np.array(line_end)

    line_vec = line_end - line_start
    point_vec = vertex - line_start

    t = np.dot(point_vec, line_vec) / np.dot(line_vec, line_vec)
    return line_start + t * line_vec
```

### 2.2 Circle Calculations

```python
def circle_from_3_points(P1, P2, P3):
    """Đường tròn qua 3 điểm"""
    center = triangle_circumcenter(P1, P2, P3)
    if center is None:
        return None, None
    radius = np.linalg.norm(np.array(P1) - center)
    return center, radius

def point_on_circle(center, radius, angle):
    """Điểm trên đường tròn tại góc angle (radians)"""
    center = np.array(center)
    return center + radius * np.array([np.cos(angle), np.sin(angle), 0])

def tangent_point(center, radius, external_point):
    """Tiếp điểm từ điểm ngoài đường tròn"""
    center = np.array(center)
    external = np.array(external_point)

    d = np.linalg.norm(external - center)
    if d <= radius:
        return None  # Point is inside or on circle

    # Tangent length
    tangent_length = np.sqrt(d**2 - radius**2)

    # Angle to tangent points
    angle_to_external = np.arctan2(external[1] - center[1],
                                    external[0] - center[0])
    angle_offset = np.arccos(radius / d)

    # Two tangent points
    t1 = point_on_circle(center, radius, angle_to_external + angle_offset)
    t2 = point_on_circle(center, radius, angle_to_external - angle_offset)

    return t1, t2
```

### 2.3 Line and Intersection

```python
def line_intersection(p1, p2, p3, p4):
    """Giao điểm 2 đường thẳng (p1-p2) và (p3-p4)"""
    p1, p2 = np.array(p1), np.array(p2)
    p3, p4 = np.array(p3), np.array(p4)

    x1, y1 = p1[0], p1[1]
    x2, y2 = p2[0], p2[1]
    x3, y3 = p3[0], p3[1]
    x4, y4 = p4[0], p4[1]

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if abs(denom) < 1e-10:
        return None  # Parallel lines

    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom

    x = x1 + t * (x2 - x1)
    y = y1 + t * (y2 - y1)

    return np.array([x, y, 0])

def perpendicular_bisector(p1, p2):
    """Đường trung trực của đoạn p1-p2"""
    p1, p2 = np.array(p1), np.array(p2)
    midpoint = (p1 + p2) / 2
    direction = p2 - p1
    perpendicular = np.array([-direction[1], direction[0], 0])
    perpendicular = perpendicular / np.linalg.norm(perpendicular)

    return midpoint, perpendicular

def angle_bisector_point(A, B, C, distance=1):
    """Điểm trên tia phân giác góc ABC, cách B một khoảng distance"""
    A, B, C = np.array(A), np.array(B), np.array(C)

    # Unit vectors
    BA = (A - B) / np.linalg.norm(A - B)
    BC = (C - B) / np.linalg.norm(C - B)

    # Bisector direction
    bisector = BA + BC
    bisector = bisector / np.linalg.norm(bisector)

    return B + distance * bisector
```

## 3. Quan Hệ Đối Tượng (Object Relationships)

### 3.1 Always Updaters

```python
class ObjectRelationships(Scene):
    def construct(self):
        # Parent-child relationship
        circle = Circle(radius=1, color=BLUE)
        dot = Dot(color=RED)

        # Dot always at top of circle
        dot.add_updater(lambda m: m.move_to(circle.get_top()))

        self.add(circle, dot)
        self.play(circle.animate.shift(RIGHT * 2))
        self.play(circle.animate.scale(2))
        # Dot follows automatically!

        # Line always connects two objects
        obj1 = Dot(LEFT * 2, color=YELLOW)
        obj2 = Dot(RIGHT * 2, color=GREEN)

        connecting_line = always_redraw(
            lambda: Line(obj1.get_center(), obj2.get_center(), color=WHITE)
        )

        self.add(obj1, obj2, connecting_line)
        self.play(obj1.animate.shift(UP * 2))
        self.play(obj2.animate.shift(DOWN * 2))
```

### 3.2 Dynamic Geometry

```python
class DynamicTriangle(Scene):
    def construct(self):
        # Movable vertices
        A = Dot(np.array([0, 2, 0]), color=RED)
        B = Dot(np.array([-2, -1, 0]), color=GREEN)
        C = Dot(np.array([2, -1, 0]), color=BLUE)

        # Triangle that updates with vertices
        triangle = always_redraw(
            lambda: Polygon(
                A.get_center(), B.get_center(), C.get_center(),
                color=WHITE, fill_opacity=0.2
            )
        )

        # Circumcircle that updates
        def get_circumcircle():
            center = triangle_circumcenter(
                A.get_center(), B.get_center(), C.get_center()
            )
            if center is None:
                return VGroup()  # Empty if degenerate
            radius = np.linalg.norm(A.get_center() - center)
            circle = Circle(radius=radius, color=YELLOW)
            circle.move_to(center)
            return circle

        circumcircle = always_redraw(get_circumcircle)

        # Labels that follow vertices
        label_A = always_redraw(
            lambda: Text("A", font_size=24).next_to(A, UP, buff=0.1)
        )
        label_B = always_redraw(
            lambda: Text("B", font_size=24).next_to(B, DL, buff=0.1)
        )
        label_C = always_redraw(
            lambda: Text("C", font_size=24).next_to(C, DR, buff=0.1)
        )

        self.add(triangle, circumcircle, A, B, C, label_A, label_B, label_C)

        # Move vertices - everything updates!
        self.play(A.animate.shift(UP * 0.5 + RIGHT * 0.5))
        self.play(B.animate.shift(LEFT * 0.5))
        self.play(C.animate.shift(DOWN * 0.5))
```

### 3.3 Constraint-Based Relationships

```python
class ConstrainedObjects(Scene):
    def construct(self):
        # Point constrained to a path
        path = Circle(radius=2, color=GRAY)

        # Tracker for position on path
        t = ValueTracker(0)

        # Point that moves along path
        dot = always_redraw(
            lambda: Dot(
                path.point_from_proportion(t.get_value() % 1),
                color=YELLOW
            )
        )

        # Tangent line at point
        tangent = always_redraw(
            lambda: TangentLine(
                path,
                t.get_value() % 1,
                length=2,
                color=RED
            )
        )

        self.add(path, dot, tangent)
        self.play(t.animate.set_value(1), run_time=4, rate_func=linear)
```

## 4. Angle Visualization

### 4.1 Proper Angle Display

```python
class ProperAngles(Scene):
    def construct(self):
        A = np.array([0, 2, 0])
        B = np.array([-2, -1, 0])
        C = np.array([2, -1, 0])

        triangle = Polygon(A, B, C, color=WHITE)

        # Angle at A (between rays AB and AC)
        angle_A = Angle(
            Line(A, B), Line(A, C),
            radius=0.4,
            other_angle=False,  # Choose which angle
            color=RED,
            fill_opacity=0.3
        )

        # Angle at B
        angle_B = Angle(
            Line(B, A), Line(B, C),
            radius=0.4,
            color=BLUE,
            fill_opacity=0.3
        )

        # Right angle mark
        def right_angle_mark(p1, vertex, p2, size=0.2):
            v1 = (np.array(p1) - np.array(vertex))
            v1 = v1 / np.linalg.norm(v1) * size
            v2 = (np.array(p2) - np.array(vertex))
            v2 = v2 / np.linalg.norm(v2) * size

            return Polygon(
                vertex + v1,
                vertex + v1 + v2,
                vertex + v2,
                vertex,
                stroke_width=2,
                color=WHITE,
                fill_opacity=0
            )

        self.add(triangle, angle_A, angle_B)
```

### 4.2 Arc Angle with Label

```python
def angle_with_label(line1, line2, label_text, radius=0.5, color=WHITE):
    """Create angle arc with label"""
    angle = Angle(line1, line2, radius=radius, color=color, fill_opacity=0.2)

    # Calculate label position (at middle of arc, slightly outside)
    angle_value = angle.get_value()
    mid_angle = (line1.get_angle() + line2.get_angle()) / 2

    label_pos = line1.get_start() + (radius + 0.3) * np.array([
        np.cos(mid_angle), np.sin(mid_angle), 0
    ])

    label = MathTex(label_text, font_size=28, color=color)
    label.move_to(label_pos)

    return VGroup(angle, label)
```

## 5. Color và Style Guidelines

### 5.1 Professional Color Palette

```python
# 3Blue1Brown inspired palette
COLORS = {
    # Primary
    'blue': "#1C758A",
    'yellow': "#FFFF00",
    'green': "#83C167",

    # Secondary
    'red': "#FC6255",
    'purple': "#9A72AC",
    'orange': "#FF8C00",
    'teal': "#4ECDC4",

    # Neutrals
    'dark_bg': "#1C1C1C",
    'light_gray': "#888888",
    'white': "#FFFFFF",

    # Semantic
    'highlight': "#FFFF00",
    'positive': "#83C167",
    'negative': "#FC6255",
    'neutral': "#1C758A",
}

# For angles in triangles
ANGLE_COLORS = {
    'alpha': "#FF6B6B",   # Red
    'beta': "#4ECDC4",    # Teal
    'gamma': "#FFE66D",   # Yellow
}
```

### 5.2 Consistent Styling

```python
class StyleConfig:
    # Line styles
    MAIN_STROKE = 3
    SECONDARY_STROKE = 2
    HELPER_STROKE = 1
    DASHED_STROKE = {"stroke_width": 2, "dash_length": 0.1}

    # Fill opacities
    LIGHT_FILL = 0.2
    MEDIUM_FILL = 0.4
    SOLID_FILL = 0.8

    # Font sizes
    TITLE_SIZE = 48
    SUBTITLE_SIZE = 36
    BODY_SIZE = 28
    LABEL_SIZE = 24
    SMALL_SIZE = 20

    # Buffers
    TIGHT_BUFF = 0.1
    SMALL_BUFF = 0.2
    MED_BUFF = 0.5
    LARGE_BUFF = 1.0
```

## 6. Animation Timing và Pacing

### 6.1 Timing Constants

```python
class Timing:
    # Animation durations
    INSTANT = 0.2
    FAST = 0.5
    NORMAL = 1.0
    SLOW = 2.0
    VERY_SLOW = 3.0

    # Wait durations
    BEAT = 0.5          # Short pause
    BREATH = 1.0        # Normal pause
    THINK = 2.0         # Let sink in
    DRAMATIC = 3.0      # Before revelation

    # Rate functions
    SMOOTH = smooth
    LINEAR = linear
    EASE_IN = rate_functions.ease_in_quad
    EASE_OUT = rate_functions.ease_out_quad
    EASE_IN_OUT = rate_functions.ease_in_out_quad
    THERE_AND_BACK = there_and_back
```

### 6.2 Pacing Patterns

```python
class GoodPacing(Scene):
    def construct(self):
        # PATTERN 1: Introduce → Pause → Explain
        obj = Circle()
        self.play(Create(obj), run_time=Timing.NORMAL)
        self.wait(Timing.BREATH)  # Let viewer see it

        label = Text("Circle")
        self.play(Write(label), run_time=Timing.FAST)
        self.wait(Timing.BEAT)

        # PATTERN 2: Build tension → Dramatic pause → Reveal
        self.wait(Timing.THINK)  # Build anticipation

        result = Text("Result!", color=YELLOW)
        self.play(
            FadeIn(result, scale=1.5),
            Flash(result.get_center()),
            run_time=Timing.SLOW
        )
        self.wait(Timing.DRAMATIC)  # Let it sink in

        # PATTERN 3: Quick sequence for routine steps
        steps = [Square(), Triangle(), Pentagon()]
        self.play(
            LaggedStart(*[Create(s) for s in steps], lag_ratio=0.3),
            run_time=Timing.NORMAL
        )
```

## 7. Text và Mathematical Notation

### 7.1 Vietnamese Text Best Practices

```python
class VietnameseText(Scene):
    def construct(self):
        # Use Text() for Vietnamese (not Tex)
        title = Text(
            "Định lý tổng các góc trong tam giác",
            font="Be Vietnam Pro",  # Good Vietnamese font
            font_size=40
        )

        # For mixed math and Vietnamese
        statement = VGroup(
            Text("Trong tam giác ABC: ", font_size=28),
            MathTex(r"\angle A + \angle B + \angle C = 180°", font_size=32)
        ).arrange(RIGHT)

        # Avoid MathTex for Vietnamese text
        # BAD:  MathTex(r"\text{Định lý}")  # May fail
        # GOOD: Text("Định lý")
```

### 7.2 Equation Transformations

```python
class EquationTransforms(Scene):
    def construct(self):
        # Step-by-step equation
        eq1 = MathTex(r"x^2 - 5x + 6 = 0")
        eq2 = MathTex(r"(x-2)(x-3) = 0")
        eq3 = MathTex(r"x = 2 \text{ or } x = 3")

        # Align equations
        eq1.move_to(ORIGIN)
        eq2.move_to(ORIGIN)
        eq3.move_to(ORIGIN)

        self.play(Write(eq1))
        self.wait(1)

        # Transform with matching parts
        self.play(TransformMatchingTex(eq1, eq2))
        self.wait(1)

        self.play(TransformMatchingTex(eq2, eq3))
        self.wait(1)

        # Highlight specific parts
        self.play(
            eq3[0][2].animate.set_color(YELLOW),  # The "2"
            eq3[0][8].animate.set_color(YELLOW),  # The "3"
        )
```

## 8. Common Mistakes to Avoid

```python
# ❌ WRONG: Hardcoded positions
dot.move_to(np.array([2.5, 1.3, 0]))  # Magic numbers

# ✅ RIGHT: Relative positioning
dot.next_to(reference_object, RIGHT, buff=0.5)

# ❌ WRONG: Not updating related objects
circle.shift(RIGHT)
label.shift(RIGHT)  # Manual, error-prone

# ✅ RIGHT: Use updaters
label.add_updater(lambda m: m.next_to(circle, UP))
circle.shift(RIGHT)  # Label follows automatically

# ❌ WRONG: Inconsistent styling
line1 = Line(A, B, stroke_width=2)
line2 = Line(B, C, stroke_width=3)  # Different width!

# ✅ RIGHT: Use constants
STROKE = 2
line1 = Line(A, B, stroke_width=STROKE)
line2 = Line(B, C, stroke_width=STROKE)

# ❌ WRONG: No pauses
self.play(Create(obj1))
self.play(Create(obj2))
self.play(Create(obj3))  # Too fast!

# ✅ RIGHT: Allow breathing room
self.play(Create(obj1))
self.wait(0.5)
self.play(Create(obj2))
self.wait(0.5)
self.play(Create(obj3))
```
