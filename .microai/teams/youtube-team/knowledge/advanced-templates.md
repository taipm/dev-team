# Advanced Manim Templates for Math Videos

## 1. Triangle Theorem Template

### 1.1 Complete Triangle with All Features
```python
from manim import *
import numpy as np

class TriangleTheorem(Scene):
    """Template cho các định lý về tam giác"""

    # Configuration
    VERTEX_BUFF = 0.25
    ANGLE_RADIUS = 0.35
    LABEL_SIZE = 32
    LINE_WIDTH = 2

    # Colors (3B1B style)
    ANGLE_COLORS = ["#FF6B6B", "#4ECDC4", "#FFE66D"]  # Red, Teal, Yellow
    HIGHLIGHT = "#FFFF00"
    CONSTRUCTION = "#1C758A"

    def setup_triangle(self, A, B, C):
        """Tạo tam giác với labels và angles"""
        self.A, self.B, self.C = A, B, C

        # Triangle
        self.triangle = Polygon(A, B, C, color=WHITE, stroke_width=self.LINE_WIDTH)

        # Centroid for label direction
        centroid = (A + B + C) / 3

        # Labels - hướng ra ngoài tam giác
        def label_direction(vertex):
            d = vertex - centroid
            return d / np.linalg.norm(d)

        self.label_A = MathTex("A", font_size=self.LABEL_SIZE).next_to(
            A, label_direction(A), buff=self.VERTEX_BUFF
        )
        self.label_B = MathTex("B", font_size=self.LABEL_SIZE).next_to(
            B, label_direction(B), buff=self.VERTEX_BUFF
        )
        self.label_C = MathTex("C", font_size=self.LABEL_SIZE).next_to(
            C, label_direction(C), buff=self.VERTEX_BUFF
        )
        self.labels = VGroup(self.label_A, self.label_B, self.label_C)

        # Colored angles
        self.angle_A = self.create_angle(A, B, C, self.ANGLE_COLORS[0])
        self.angle_B = self.create_angle(B, C, A, self.ANGLE_COLORS[1])
        self.angle_C = self.create_angle(C, A, B, self.ANGLE_COLORS[2])
        self.angles = VGroup(self.angle_A, self.angle_B, self.angle_C)

        # Greek labels for angles
        self.alpha = self.create_angle_label(A, B, C, r"\alpha", self.ANGLE_COLORS[0])
        self.beta = self.create_angle_label(B, C, A, r"\beta", self.ANGLE_COLORS[1])
        self.gamma = self.create_angle_label(C, A, B, r"\gamma", self.ANGLE_COLORS[2])
        self.angle_labels = VGroup(self.alpha, self.beta, self.gamma)

        # Full triangle group
        self.triangle_group = VGroup(
            self.triangle, self.labels, self.angles, self.angle_labels
        )

    def create_angle(self, vertex, p1, p2, color):
        """Tạo cung góc tại vertex"""
        line1 = Line(vertex, p1)
        line2 = Line(vertex, p2)
        return Angle(line1, line2, radius=self.ANGLE_RADIUS,
                    color=color, fill_opacity=0.3)

    def create_angle_label(self, vertex, p1, p2, label_text, color):
        """Tạo label cho góc, đặt trong góc"""
        v1 = (p1 - vertex) / np.linalg.norm(p1 - vertex)
        v2 = (p2 - vertex) / np.linalg.norm(p2 - vertex)
        bisector = v1 + v2
        bisector = bisector / np.linalg.norm(bisector)
        label_pos = vertex + 0.6 * bisector
        return MathTex(label_text, color=color, font_size=24).move_to(label_pos)

    def draw_altitude(self, from_vertex, to_side_start, to_side_end, color=None):
        """Vẽ đường cao từ vertex đến cạnh đối diện"""
        if color is None:
            color = self.CONSTRUCTION

        # Tìm chân đường cao
        foot = self.perpendicular_foot(from_vertex, to_side_start, to_side_end)

        altitude = Line(from_vertex, foot, color=color, stroke_width=1.5)
        right_angle = RightAngle(
            Line(foot, from_vertex),
            Line(foot, to_side_end),
            length=0.15,
            color=color
        )
        foot_dot = Dot(foot, color=color, radius=0.04)

        return VGroup(altitude, right_angle, foot_dot), foot

    def draw_median(self, from_vertex, opposite_start, opposite_end, color=None):
        """Vẽ đường trung tuyến"""
        if color is None:
            color = self.CONSTRUCTION

        midpoint = (opposite_start + opposite_end) / 2
        median = Line(from_vertex, midpoint, color=color, stroke_width=1.5)
        mid_dot = Dot(midpoint, color=color, radius=0.04)

        return VGroup(median, mid_dot), midpoint

    def draw_angle_bisector(self, vertex, p1, p2, length=2.5, color=None):
        """Vẽ đường phân giác"""
        if color is None:
            color = self.CONSTRUCTION

        v1 = (p1 - vertex) / np.linalg.norm(p1 - vertex)
        v2 = (p2 - vertex) / np.linalg.norm(p2 - vertex)
        bisector_dir = v1 + v2
        bisector_dir = bisector_dir / np.linalg.norm(bisector_dir)

        end_point = vertex + length * bisector_dir
        bisector = Line(vertex, end_point, color=color, stroke_width=1.5)

        return bisector

    def draw_circumcircle(self, color=BLUE):
        """Vẽ đường tròn ngoại tiếp"""
        O = self.circumcenter(self.A, self.B, self.C)
        R = np.linalg.norm(self.A - O)

        circle = Circle(radius=R, color=color, stroke_width=1.5).move_to(O)
        center = Dot(O, color=color, radius=0.05)
        label = MathTex("O", font_size=24).next_to(O, DOWN + LEFT, buff=0.1)

        return VGroup(circle, center, label), O, R

    def draw_incircle(self, color=GREEN):
        """Vẽ đường tròn nội tiếp"""
        I = self.incenter(self.A, self.B, self.C)
        r = self.inradius(self.A, self.B, self.C)

        circle = Circle(radius=r, color=color, stroke_width=1.5).move_to(I)
        center = Dot(I, color=color, radius=0.05)
        label = MathTex("I", font_size=24).next_to(I, UP + RIGHT, buff=0.1)

        return VGroup(circle, center, label), I, r

    def draw_parallel_through(self, point, line_start, line_end, length=6, color=None):
        """Vẽ đường thẳng song song qua point"""
        if color is None:
            color = self.CONSTRUCTION

        direction = line_end - line_start
        direction = direction / np.linalg.norm(direction)

        start = point - (length/2) * direction
        end = point + (length/2) * direction

        return Line(start, end, color=color, stroke_width=2)

    # Geometry calculation helpers
    @staticmethod
    def perpendicular_foot(P, A, B):
        AB = B - A
        AP = P - A
        t = np.dot(AP, AB) / np.dot(AB, AB)
        return A + t * AB

    @staticmethod
    def circumcenter(A, B, C):
        d = 2 * (A[0] * (B[1] - C[1]) + B[0] * (C[1] - A[1]) + C[0] * (A[1] - B[1]))
        ux = ((A[0]**2 + A[1]**2) * (B[1] - C[1]) +
              (B[0]**2 + B[1]**2) * (C[1] - A[1]) +
              (C[0]**2 + C[1]**2) * (A[1] - B[1])) / d
        uy = ((A[0]**2 + A[1]**2) * (C[0] - B[0]) +
              (B[0]**2 + B[1]**2) * (A[0] - C[0]) +
              (C[0]**2 + C[1]**2) * (B[0] - A[0])) / d
        return np.array([ux, uy, 0])

    @staticmethod
    def incenter(A, B, C):
        a = np.linalg.norm(C - B)
        b = np.linalg.norm(A - C)
        c = np.linalg.norm(B - A)
        return (a * A + b * B + c * C) / (a + b + c)

    @staticmethod
    def inradius(A, B, C):
        a = np.linalg.norm(C - B)
        b = np.linalg.norm(A - C)
        c = np.linalg.norm(B - A)
        p = (a + b + c) / 2
        S = np.sqrt(p * (p - a) * (p - b) * (p - c))
        return S / p

    @staticmethod
    def orthocenter(A, B, C):
        O = TriangleTheorem.circumcenter(A, B, C)
        return A + B + C - 2 * O


class TriangleAngleSumProof(TriangleTheorem):
    """Chứng minh tổng 3 góc tam giác = 180°"""

    def construct(self):
        # Setup
        A = np.array([0, 2, 0])
        B = np.array([-2.5, -1, 0])
        C = np.array([2.5, -1, 0])
        self.setup_triangle(A, B, C)

        # Scene 1: Introduction
        title = Text("Tổng ba góc trong tam giác", font_size=40)
        self.play(Write(title))
        self.wait(1)
        self.play(FadeOut(title))

        # Scene 2: Draw triangle
        self.play(Create(self.triangle), Write(self.labels), run_time=1.5)
        self.wait(0.5)
        self.play(
            Create(self.angles),
            Write(self.angle_labels),
            run_time=1.5
        )
        self.wait(1)

        # Scene 3: Parallel line insight
        insight = Text("Ý tưởng: Đường song song", font_size=32, color=YELLOW)
        insight.to_edge(UP)
        self.play(Write(insight))

        parallel = self.draw_parallel_through(A, B, C, length=7)
        self.play(Create(parallel))
        self.wait(1)

        # Scene 4: Alternate interior angles
        # Copy angles to parallel line
        alt_beta = self.angle_B.copy()
        alt_gamma = self.angle_C.copy()

        # Calculate positions on parallel line
        # Beta' at A (left side)
        alt_beta_target = Angle(
            Line(A, A + LEFT),
            Line(A, B),
            radius=0.35,
            color=self.ANGLE_COLORS[1],
            fill_opacity=0.3
        )
        # Gamma' at A (right side)
        alt_gamma_target = Angle(
            Line(A, C),
            Line(A, A + RIGHT),
            radius=0.35,
            color=self.ANGLE_COLORS[2],
            fill_opacity=0.3
        )

        self.play(
            Transform(alt_beta, alt_beta_target),
            Flash(self.angle_B.get_center(), color=self.ANGLE_COLORS[1])
        )
        beta_note = MathTex(r"\beta' = \beta", color=self.ANGLE_COLORS[1], font_size=24)
        beta_note.next_to(alt_beta_target, UP + LEFT)
        self.play(Write(beta_note))

        self.play(
            Transform(alt_gamma, alt_gamma_target),
            Flash(self.angle_C.get_center(), color=self.ANGLE_COLORS[2])
        )
        gamma_note = MathTex(r"\gamma' = \gamma", color=self.ANGLE_COLORS[2], font_size=24)
        gamma_note.next_to(alt_gamma_target, UP + RIGHT)
        self.play(Write(gamma_note))

        self.wait(1)

        # Scene 5: Straight angle revelation
        self.play(FadeOut(insight))

        reveal = Text("Ba góc tạo thành góc bẹt!", font_size=32, color=YELLOW)
        reveal.to_edge(UP)
        self.play(Write(reveal))

        # Highlight the straight angle
        brace = Brace(parallel, DOWN)
        conclusion = MathTex(
            r"\beta' + \alpha + \gamma' = 180°",
            font_size=36
        )
        conclusion[0][0:2].set_color(self.ANGLE_COLORS[1])
        conclusion[0][3:4].set_color(self.ANGLE_COLORS[0])
        conclusion[0][5:7].set_color(self.ANGLE_COLORS[2])
        conclusion.next_to(brace, DOWN)

        self.play(Create(brace), Write(conclusion))
        self.wait(1)

        # Scene 6: Final statement
        final = MathTex(
            r"\alpha + \beta + \gamma = 180°",
            font_size=48
        )
        final[0][0].set_color(self.ANGLE_COLORS[0])
        final[0][2].set_color(self.ANGLE_COLORS[1])
        final[0][4].set_color(self.ANGLE_COLORS[2])
        final.to_edge(DOWN)
        box = SurroundingRectangle(final, color=YELLOW, buff=0.2)

        self.play(Write(final), Create(box))

        # QED
        qed = Text("■", font_size=48, color=GREEN)
        qed.to_corner(DR)
        self.play(Write(qed))

        self.wait(3)
```

## 2. Circle Theorem Template

### 2.1 Circle with Inscribed Angle
```python
class CircleTheorem(Scene):
    """Template cho các định lý về đường tròn"""

    CIRCLE_COLOR = BLUE
    RADIUS_COLOR = "#1C758A"
    CHORD_COLOR = WHITE
    ANGLE_COLOR = YELLOW

    def setup_circle(self, center=ORIGIN, radius=2):
        """Tạo đường tròn cơ bản"""
        self.center = center
        self.radius = radius
        self.circle = Circle(radius=radius, color=self.CIRCLE_COLOR).move_to(center)
        self.center_dot = Dot(center, color=self.CIRCLE_COLOR, radius=0.05)
        self.center_label = MathTex("O", font_size=28).next_to(center, DL, buff=0.1)

    def point_on_circle(self, angle):
        """Điểm trên đường tròn tại góc angle (radians)"""
        return self.center + self.radius * np.array([
            np.cos(angle), np.sin(angle), 0
        ])

    def create_inscribed_angle(self, vertex_angle, arc_start_angle, arc_end_angle,
                               vertex_label="P", arc_labels=("A", "B")):
        """Tạo góc nội tiếp"""
        P = self.point_on_circle(vertex_angle)
        A = self.point_on_circle(arc_start_angle)
        B = self.point_on_circle(arc_end_angle)

        # Chords PA and PB
        chord_PA = Line(P, A, color=self.CHORD_COLOR)
        chord_PB = Line(P, B, color=self.CHORD_COLOR)

        # Inscribed angle
        angle = Angle(
            chord_PA, chord_PB,
            radius=0.3,
            color=self.ANGLE_COLOR,
            fill_opacity=0.3
        )

        # Labels
        label_P = MathTex(vertex_label, font_size=28).next_to(P, self.outward_direction(P), buff=0.15)
        label_A = MathTex(arc_labels[0], font_size=28).next_to(A, self.outward_direction(A), buff=0.15)
        label_B = MathTex(arc_labels[1], font_size=28).next_to(B, self.outward_direction(B), buff=0.15)

        return {
            "points": (P, A, B),
            "chords": VGroup(chord_PA, chord_PB),
            "angle": angle,
            "labels": VGroup(label_P, label_A, label_B),
            "dots": VGroup(Dot(P), Dot(A), Dot(B))
        }

    def create_central_angle(self, arc_start_angle, arc_end_angle, arc_labels=("A", "B")):
        """Tạo góc ở tâm"""
        A = self.point_on_circle(arc_start_angle)
        B = self.point_on_circle(arc_end_angle)

        # Radii OA and OB
        radius_OA = Line(self.center, A, color=self.RADIUS_COLOR)
        radius_OB = Line(self.center, B, color=self.RADIUS_COLOR)

        # Central angle
        angle = Angle(
            radius_OA, radius_OB,
            radius=0.4,
            color=RED,
            fill_opacity=0.3
        )

        # Labels
        label_A = MathTex(arc_labels[0], font_size=28).next_to(A, self.outward_direction(A), buff=0.15)
        label_B = MathTex(arc_labels[1], font_size=28).next_to(B, self.outward_direction(B), buff=0.15)

        return {
            "points": (A, B),
            "radii": VGroup(radius_OA, radius_OB),
            "angle": angle,
            "labels": VGroup(label_A, label_B),
            "dots": VGroup(Dot(A), Dot(B))
        }

    def create_arc(self, start_angle, end_angle, color=YELLOW, stroke_width=4):
        """Tạo cung trên đường tròn"""
        angle_span = end_angle - start_angle
        if angle_span < 0:
            angle_span += 2 * PI

        return Arc(
            radius=self.radius,
            start_angle=start_angle,
            angle=angle_span,
            arc_center=self.center,
            color=color,
            stroke_width=stroke_width
        )

    def outward_direction(self, point):
        """Hướng ra ngoài từ tâm qua point"""
        d = point - self.center
        return d / np.linalg.norm(d)


class InscribedAngleTheorem(CircleTheorem):
    """Định lý góc nội tiếp"""

    def construct(self):
        # Setup
        self.setup_circle(radius=2.5)

        # Title
        title = Text("Định lý góc nội tiếp", font_size=40)
        self.play(Write(title))
        self.wait(1)
        self.play(title.animate.to_edge(UP).scale(0.7))

        # Draw circle
        self.play(Create(self.circle), Create(self.center_dot), Write(self.center_label))
        self.wait(0.5)

        # Create inscribed angle
        inscribed = self.create_inscribed_angle(
            vertex_angle=PI/2,
            arc_start_angle=-PI/6,
            arc_end_angle=PI/6 + PI,
            vertex_label="P",
            arc_labels=("A", "B")
        )

        self.play(
            Create(inscribed["dots"]),
            Write(inscribed["labels"])
        )
        self.play(Create(inscribed["chords"]))
        self.play(Create(inscribed["angle"]))

        inscribed_label = MathTex(r"\angle APB", color=YELLOW, font_size=28)
        inscribed_label.next_to(inscribed["angle"], UP + LEFT)
        self.play(Write(inscribed_label))
        self.wait(1)

        # Create central angle
        central = self.create_central_angle(
            arc_start_angle=-PI/6,
            arc_end_angle=PI/6 + PI
        )

        self.play(Create(central["radii"]))
        self.play(Create(central["angle"]))

        central_label = MathTex(r"\angle AOB", color=RED, font_size=28)
        central_label.next_to(central["angle"], DOWN)
        self.play(Write(central_label))
        self.wait(1)

        # Highlight arc
        arc = self.create_arc(-PI/6, PI/6 + PI)
        self.play(Create(arc))
        self.wait(1)

        # Statement
        statement = MathTex(
            r"\angle APB = \frac{1}{2} \angle AOB",
            font_size=36
        )
        statement.to_edge(DOWN)
        box = SurroundingRectangle(statement, color=GREEN, buff=0.2)

        self.play(Write(statement), Create(box))
        self.wait(3)
```

## 3. Graph/Function Template

### 3.1 Function Visualization
```python
class FunctionTemplate(Scene):
    """Template cho visualize hàm số"""

    def create_axes(self, x_range=(-5, 5), y_range=(-3, 3), **kwargs):
        """Tạo hệ trục tọa độ"""
        self.axes = Axes(
            x_range=[*x_range, 1],
            y_range=[*y_range, 1],
            x_length=10,
            y_length=6,
            axis_config={"include_tip": True, "include_numbers": True},
            **kwargs
        )
        self.x_label = self.axes.get_x_axis_label("x")
        self.y_label = self.axes.get_y_axis_label("y")
        return VGroup(self.axes, self.x_label, self.y_label)

    def plot_function(self, func, x_range=None, color=BLUE, **kwargs):
        """Vẽ đồ thị hàm số"""
        if x_range is None:
            x_range = self.axes.x_range[:2]
        return self.axes.plot(func, x_range=x_range, color=color, **kwargs)

    def create_point_on_graph(self, func, x_val, color=RED):
        """Tạo điểm trên đồ thị với coordinates"""
        point = self.axes.c2p(x_val, func(x_val))
        dot = Dot(point, color=color)
        coord = MathTex(f"({x_val}, {func(x_val):.2f})", font_size=24)
        coord.next_to(dot, UR, buff=0.1)
        return VGroup(dot, coord)

    def create_tangent_line(self, func, x_val, length=3, color=YELLOW):
        """Tạo tiếp tuyến tại điểm"""
        h = 0.0001
        slope = (func(x_val + h) - func(x_val - h)) / (2 * h)

        point = self.axes.c2p(x_val, func(x_val))

        # Direction of tangent
        dx = 1
        dy = slope

        start = point - length/2 * np.array([dx, dy, 0]) / np.linalg.norm([dx, dy])
        end = point + length/2 * np.array([dx, dy, 0]) / np.linalg.norm([dx, dy])

        return Line(start, end, color=color)

    def animate_tracing(self, graph, run_time=3):
        """Animate vẽ đồ thị"""
        return Create(graph, run_time=run_time)


class DerivativeVisualization(FunctionTemplate):
    """Visualize đạo hàm"""

    def construct(self):
        # Setup axes
        axes_group = self.create_axes(x_range=(-3, 3), y_range=(-1, 5))
        self.play(Create(axes_group))

        # Function f(x) = x^2
        def f(x):
            return x**2

        graph = self.plot_function(f, color=BLUE)
        label = MathTex("f(x) = x^2", font_size=32).to_corner(UR)

        self.play(self.animate_tracing(graph), Write(label))
        self.wait(1)

        # Moving tangent line
        x = ValueTracker(-2)

        tangent = always_redraw(lambda: self.create_tangent_line(f, x.get_value()))
        point = always_redraw(lambda: self.create_point_on_graph(f, x.get_value()))

        self.play(Create(tangent), Create(point))
        self.play(x.animate.set_value(2), run_time=4, rate_func=linear)

        self.wait(2)
```

## 4. Proof Animation Template

### 4.1 Step-by-Step Proof
```python
class ProofTemplate(Scene):
    """Template cho chứng minh từng bước"""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.proof_steps = []
        self.current_step = 0

    def add_step(self, text, equation=None, visual=None):
        """Thêm một bước chứng minh"""
        self.proof_steps.append({
            "text": text,
            "equation": equation,
            "visual": visual
        })

    def animate_step(self, index, text_position=None, eq_position=None):
        """Animate một bước chứng minh"""
        step = self.proof_steps[index]

        animations = []

        if step["text"]:
            text = Text(step["text"], font_size=28)
            if text_position:
                text.move_to(text_position)
            else:
                text.to_edge(UP)
            animations.append(Write(text))

        if step["equation"]:
            eq = MathTex(step["equation"], font_size=36)
            if eq_position:
                eq.move_to(eq_position)
            else:
                eq.center()
            animations.append(Write(eq))

        if step["visual"]:
            animations.append(Create(step["visual"]))

        return AnimationGroup(*animations)

    def proof_flow(self, steps_config):
        """
        Run through proof steps với transitions

        steps_config: list of {
            "text": str,
            "equation": str,
            "visual": Mobject,
            "highlight": Mobject (optional),
            "wait": float (optional)
        }
        """
        prev_elements = VGroup()

        for i, config in enumerate(steps_config):
            # Fade out previous
            if len(prev_elements) > 0:
                self.play(
                    prev_elements.animate.set_opacity(0.3).shift(0.5*UP),
                    run_time=0.5
                )

            current_elements = VGroup()

            # Step number
            step_num = Text(f"Bước {i+1}:", font_size=24, color=YELLOW)
            step_num.to_edge(LEFT).shift(2*UP)
            current_elements.add(step_num)
            self.play(Write(step_num), run_time=0.3)

            # Text
            if config.get("text"):
                text = Text(config["text"], font_size=28)
                text.next_to(step_num, RIGHT)
                current_elements.add(text)
                self.play(Write(text))

            # Equation
            if config.get("equation"):
                eq = MathTex(config["equation"], font_size=36)
                eq.center()
                current_elements.add(eq)
                self.play(Write(eq))

            # Visual
            if config.get("visual"):
                current_elements.add(config["visual"])
                self.play(Create(config["visual"]))

            # Highlight
            if config.get("highlight"):
                self.play(Flash(config["highlight"].get_center()))

            # Wait
            wait_time = config.get("wait", 1)
            self.wait(wait_time)

            prev_elements = current_elements
```

## 5. Video Intro/Outro Template

### 5.1 Standard Intro
```python
class VideoIntro(Scene):
    """Template cho intro video"""

    def construct(self):
        # Background particles or subtle animation
        particles = VGroup(*[
            Dot(
                np.random.uniform(-7, 7) * RIGHT +
                np.random.uniform(-4, 4) * UP,
                radius=0.02,
                color=BLUE_E
            )
            for _ in range(50)
        ])
        particles.set_opacity(0.3)
        self.add(particles)

        # Main title
        title = Text("TOÁN HỌC TRỰC QUAN", font_size=48, weight=BOLD)
        subtitle = Text("Khám phá vẻ đẹp của toán học", font_size=28, color=GRAY)
        subtitle.next_to(title, DOWN)

        title_group = VGroup(title, subtitle)
        title_group.center()

        # Animation
        self.play(
            Write(title, run_time=2),
            rate_func=smooth
        )
        self.play(
            FadeIn(subtitle, shift=UP),
            run_time=1
        )

        # Logo or channel name
        logo = Text("MathVisualized", font_size=20, color=GRAY)
        logo.to_corner(DR)
        self.play(FadeIn(logo))

        self.wait(1)

        # Transition out
        self.play(
            FadeOut(title_group),
            FadeOut(logo),
            FadeOut(particles),
            run_time=0.8
        )


class VideoOutro(Scene):
    """Template cho outro video"""

    def construct(self):
        # Thanks message
        thanks = Text("Cảm ơn đã xem!", font_size=48)
        self.play(Write(thanks))
        self.wait(1)

        # Call to action
        cta = VGroup(
            Text("👍 Like", font_size=28),
            Text("🔔 Subscribe", font_size=28),
            Text("💬 Comment", font_size=28),
        ).arrange(RIGHT, buff=1)
        cta.next_to(thanks, DOWN, buff=1)

        self.play(
            LaggedStart(*[FadeIn(item, shift=UP) for item in cta],
                       lag_ratio=0.2)
        )
        self.wait(2)

        # End card placeholder
        end_card = Rectangle(width=4, height=2.5, color=WHITE, stroke_width=2)
        end_card_text = Text("Video tiếp theo", font_size=20)
        end_card_text.move_to(end_card)
        end_card_group = VGroup(end_card, end_card_text)
        end_card_group.to_corner(DR, buff=0.5)

        self.play(FadeIn(end_card_group))
        self.wait(3)
```

## 6. Usage Example

```python
# File: my_video.py
from templates import TriangleTheorem, CircleTheorem, VideoIntro, VideoOutro

class MyMathVideo(Scene):
    def construct(self):
        # Intro
        intro = VideoIntro()
        intro.construct()

        # Main content using templates
        theorem = TriangleAngleSumProof()
        theorem.construct()

        # Outro
        outro = VideoOutro()
        outro.construct()
```
