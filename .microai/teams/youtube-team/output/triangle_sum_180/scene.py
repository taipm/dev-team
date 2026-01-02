"""
Video: Chứng minh tổng ba góc trong tam giác bằng 180 độ
Style: 3Blue1Brown educational
Duration: ~3 minutes
"""

from manim import *
import numpy as np

# Custom colors (3B1B style)
ANGLE_RED = "#FF6B6B"
ANGLE_BLUE = "#4ECDC4"
ANGLE_YELLOW = "#FFE66D"
MATH_BLUE = "#1C758A"


class Scene1_Intro(Scene):
    """Hook: Tại sao mọi tam giác đều có tổng góc = 180°?"""

    def construct(self):
        # Title
        title = Text("Một bí ẩn của hình học", font_size=48)
        self.play(Write(title))
        self.wait(1)
        self.play(FadeOut(title))

        # Show multiple triangles
        triangles = VGroup()
        positions = [[-4, 1, 0], [-1, 2, 0], [2, 0, 0], [4, 1.5, 0], [-2, -1, 0], [1, -1.5, 0]]

        for i, pos in enumerate(positions):
            # Random triangle
            scale = 0.5 + 0.3 * np.random.random()
            tri = Polygon(
                pos + np.array([0, scale, 0]),
                pos + np.array([-scale, -0.5*scale, 0]),
                pos + np.array([scale, -0.3*scale, 0]),
                color=WHITE,
                fill_opacity=0.1
            )
            triangles.add(tri)

        self.play(LaggedStart(*[Create(t) for t in triangles], lag_ratio=0.2))
        self.wait(0.5)

        # Question
        question = MathTex(r"\angle A + \angle B + \angle C = 180°", font_size=60)
        question.set_color(YELLOW)
        box = SurroundingRectangle(question, color=YELLOW, buff=0.3)

        self.play(
            triangles.animate.set_opacity(0.3),
            Write(question),
            Create(box)
        )
        self.wait(2)

        # Clear for next scene
        self.play(FadeOut(VGroup(triangles, question, box)))


class Scene2_Setup(Scene):
    """Setup: Vẽ tam giác ABC với 3 góc màu khác nhau"""

    def construct(self):
        # Triangle vertices
        A = np.array([0, 2, 0])
        B = np.array([-2.5, -1, 0])
        C = np.array([2.5, -1, 0])

        # Create triangle
        triangle = Polygon(A, B, C, color=WHITE, stroke_width=3)

        # Labels
        label_A = MathTex("A", font_size=36).next_to(A, UP)
        label_B = MathTex("B", font_size=36).next_to(B, LEFT)
        label_C = MathTex("C", font_size=36).next_to(C, RIGHT)
        labels = VGroup(label_A, label_B, label_C)

        self.play(Create(triangle), Write(labels))
        self.wait(1)

        # Color the angles
        angle_A = Angle(
            Line(A, B), Line(A, C),
            radius=0.4, color=ANGLE_RED, fill_opacity=0.5
        )
        angle_B = Angle(
            Line(B, C), Line(B, A),
            radius=0.4, color=ANGLE_BLUE, fill_opacity=0.5
        )
        angle_C = Angle(
            Line(C, A), Line(C, B),
            radius=0.4, color=ANGLE_YELLOW, fill_opacity=0.5
        )

        # Angle labels
        alpha = MathTex(r"\alpha", color=ANGLE_RED, font_size=28).move_to(A + np.array([0, -0.7, 0]))
        beta = MathTex(r"\beta", color=ANGLE_BLUE, font_size=28).move_to(B + np.array([0.6, 0.3, 0]))
        gamma = MathTex(r"\gamma", color=ANGLE_YELLOW, font_size=28).move_to(C + np.array([-0.6, 0.3, 0]))

        self.play(
            Create(angle_A), Write(alpha),
            Create(angle_B), Write(beta),
            Create(angle_C), Write(gamma),
            run_time=2
        )

        # Goal statement
        goal = MathTex(
            r"\alpha", "+", r"\beta", "+", r"\gamma", "=", "180°",
            font_size=48
        )
        goal[0].set_color(ANGLE_RED)
        goal[2].set_color(ANGLE_BLUE)
        goal[4].set_color(ANGLE_YELLOW)
        goal.to_edge(DOWN, buff=0.5)

        self.play(Write(goal))
        self.wait(2)

        # Store for next scene
        self.triangle_group = VGroup(triangle, labels, angle_A, angle_B, angle_C, alpha, beta, gamma, goal)


class Scene3_KeyInsight(Scene):
    """Key Insight: Đường thẳng song song và góc so le trong"""

    def construct(self):
        # Triangle vertices
        A = np.array([0, 1.5, 0])
        B = np.array([-2.5, -1.5, 0])
        C = np.array([2.5, -1.5, 0])

        # Create triangle
        triangle = Polygon(A, B, C, color=WHITE, stroke_width=3)

        # Labels
        label_A = MathTex("A", font_size=36).next_to(A, UP)
        label_B = MathTex("B", font_size=36).next_to(B, LEFT)
        label_C = MathTex("C", font_size=36).next_to(C, RIGHT)

        # Colored angles at vertices
        angle_A = Angle(
            Line(A, B), Line(A, C),
            radius=0.35, color=ANGLE_RED, fill_opacity=0.5
        )
        angle_B = Angle(
            Line(B, C), Line(B, A),
            radius=0.35, color=ANGLE_BLUE, fill_opacity=0.5
        )
        angle_C = Angle(
            Line(C, A), Line(C, B),
            radius=0.35, color=ANGLE_YELLOW, fill_opacity=0.5
        )

        triangle_group = VGroup(triangle, label_A, label_B, label_C, angle_A, angle_B, angle_C)
        self.play(Create(triangle_group))
        self.wait(1)

        # Key insight text
        insight = Text("Ý tưởng then chốt:", font_size=36, color=YELLOW)
        insight.to_edge(UP)
        self.play(Write(insight))
        self.wait(0.5)

        # Draw parallel line through A
        parallel_line = Line(
            A + np.array([-3.5, 0, 0]),
            A + np.array([3.5, 0, 0]),
            color=MATH_BLUE, stroke_width=2
        )

        parallel_text = Text("Đường thẳng song song với BC", font_size=24, color=MATH_BLUE)
        parallel_text.next_to(parallel_line, UP, buff=0.2)

        self.play(Create(parallel_line), Write(parallel_text))
        self.wait(1)

        # Show alternate interior angles
        # Angle at A (left side) = Angle B (alternate interior)
        alt_angle_B = Angle(
            Line(A, A + np.array([-1, 0, 0])),
            Line(A, B),
            radius=0.35, color=ANGLE_BLUE, fill_opacity=0.5
        )

        # Angle at A (right side) = Angle C (alternate interior)
        alt_angle_C = Angle(
            Line(A, C),
            Line(A, A + np.array([1, 0, 0])),
            radius=0.35, color=ANGLE_YELLOW, fill_opacity=0.5
        )

        # Highlight alternate angles
        self.play(
            Flash(angle_B.get_center(), color=ANGLE_BLUE),
            Flash(alt_angle_B.get_center(), color=ANGLE_BLUE),
        )
        self.play(Create(alt_angle_B))

        equal_1 = MathTex(r"\beta' = \beta", color=ANGLE_BLUE, font_size=28)
        equal_1.next_to(alt_angle_B, LEFT, buff=0.5)
        self.play(Write(equal_1))
        self.wait(1)

        self.play(
            Flash(angle_C.get_center(), color=ANGLE_YELLOW),
            Flash(alt_angle_C.get_center(), color=ANGLE_YELLOW),
        )
        self.play(Create(alt_angle_C))

        equal_2 = MathTex(r"\gamma' = \gamma", color=ANGLE_YELLOW, font_size=28)
        equal_2.next_to(alt_angle_C, RIGHT, buff=0.5)
        self.play(Write(equal_2))
        self.wait(2)

        # Store for revelation
        self.all_objects = VGroup(
            triangle_group, parallel_line, parallel_text, insight,
            alt_angle_B, alt_angle_C, equal_1, equal_2
        )


class Scene4_Revelation(Scene):
    """Revelation: 3 góc xếp thành góc bẹt 180°"""

    def construct(self):
        # Recreate the setup
        A = np.array([0, 0.5, 0])

        # Parallel line
        parallel_line = Line(
            np.array([-4, 0.5, 0]),
            np.array([4, 0.5, 0]),
            color=MATH_BLUE, stroke_width=3
        )

        # Three angles as colored arcs with fill
        blue_arc = AnnularSector(
            inner_radius=0,
            outer_radius=0.8,
            start_angle=PI,
            angle=PI/4,
            color=ANGLE_BLUE,
            fill_opacity=0.5
        ).move_to(A)

        red_arc = AnnularSector(
            inner_radius=0,
            outer_radius=0.8,
            start_angle=3*PI/4,
            angle=PI/2,
            color=ANGLE_RED,
            fill_opacity=0.5
        ).move_to(A)

        yellow_arc = AnnularSector(
            inner_radius=0,
            outer_radius=0.8,
            start_angle=PI/4,
            angle=PI/4,
            color=ANGLE_YELLOW,
            fill_opacity=0.5
        ).move_to(A)

        # Labels
        beta_label = Text("β", font_size=28, color=ANGLE_BLUE)
        beta_label.next_to(blue_arc, UP + LEFT, buff=0.1)

        alpha_label = Text("α", font_size=28, color=ANGLE_RED)
        alpha_label.next_to(red_arc, UP, buff=0.1)

        gamma_label = Text("γ", font_size=28, color=ANGLE_YELLOW)
        gamma_label.next_to(yellow_arc, UP + RIGHT, buff=0.1)

        # Start animation
        title = Text("Và bây giờ... điều kỳ diệu!", font_size=40, color=YELLOW)
        title.to_edge(UP)
        self.play(Write(title))
        self.wait(1)

        self.play(Create(parallel_line))
        self.play(
            FadeIn(blue_arc, shift=DOWN),
            FadeIn(red_arc, shift=DOWN),
            FadeIn(yellow_arc, shift=DOWN),
        )
        self.play(Write(VGroup(beta_label, alpha_label, gamma_label)))
        self.wait(1)

        # The revelation - they form a straight angle!
        brace = Brace(parallel_line, DOWN, buff=0.3)
        brace_text = Text("β + α + γ = 180°", font_size=36)
        brace_text.next_to(brace, DOWN)

        self.play(
            FadeIn(brace),
            Write(brace_text),
            Flash(A, color=WHITE, line_length=0.5),
            run_time=2
        )

        # Celebration
        result_box = SurroundingRectangle(brace_text, color=YELLOW, buff=0.2)
        self.play(Create(result_box))

        # QED
        qed = Text("■", font_size=48, color=GREEN)
        qed.to_corner(DR)
        self.play(Write(qed))

        self.wait(3)


class Scene5_Conclusion(Scene):
    """Conclusion: Tổng kết và mở rộng"""

    def construct(self):
        # Final statement
        title = Text("Định lý tổng các góc trong tam giác", font_size=36)
        title.to_edge(UP)

        theorem = Text("Trong mọi tam giác: ∠A + ∠B + ∠C = 180°", font_size=32)
        box = SurroundingRectangle(theorem, color=MATH_BLUE, buff=0.3)
        theorem_group = VGroup(theorem, box)

        self.play(Write(title))
        self.play(Create(theorem_group))
        self.wait(1)

        # Show multiple triangles with 180° highlighted
        triangles = VGroup()
        texts = VGroup()

        positions = [[-3, -1.5, 0], [0, -1.5, 0], [3, -1.5, 0]]

        for pos in positions:
            tri = Polygon(
                pos + np.array([0, 1, 0]),
                pos + np.array([-0.8, -0.5, 0]),
                pos + np.array([0.8, -0.5, 0]),
                color=WHITE,
                fill_opacity=0.1
            )
            text = Text("180°", font_size=24, color=YELLOW)
            text.move_to(pos + np.array([0, 0.2, 0]))
            triangles.add(tri)
            texts.add(text)

        self.play(LaggedStart(*[Create(t) for t in triangles], lag_ratio=0.3))
        self.play(LaggedStart(*[Write(t) for t in texts], lag_ratio=0.3))

        self.wait(2)

        # End message
        end_text = Text(
            "Một trong những định lý đẹp nhất của hình học",
            font_size=28,
            color=GRAY
        )
        end_text.to_edge(DOWN, buff=0.5)
        self.play(Write(end_text))

        self.wait(3)


# Main scene combining all
class TriangleAngleSum(Scene):
    """Full video: Chứng minh tổng ba góc tam giác = 180°"""

    def construct(self):
        # This would combine all scenes
        # For production, render each scene separately and composite
        pass
