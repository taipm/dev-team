"""
Video: Chứng minh tổng ba góc trong tam giác bằng 180 độ
Version: 2.0 - Áp dụng knowledge nâng cao
Style: 3Blue1Brown educational
Duration: ~3 minutes
"""

from manim import *
import numpy as np

# ========== CONFIGURATION ==========
# Colors (3B1B style)
ANGLE_RED = "#FF6B6B"
ANGLE_BLUE = "#4ECDC4"
ANGLE_YELLOW = "#FFE66D"
MATH_BLUE = "#1C758A"
HIGHLIGHT = "#FFFF00"
CONSTRUCTION = "#888888"

# Sizing
VERTEX_BUFF = 0.25
ANGLE_RADIUS = 0.4
LABEL_SIZE = 36
LINE_WIDTH = 2.5

# Timing
BEAT = 0.5
FAST = 0.5
NORMAL = 1.0
SLOW = 1.5
DRAMATIC = 2.5


# ========== GEOMETRY HELPERS ==========
def perpendicular_foot(P, A, B):
    """Chân đường vuông góc từ P đến AB"""
    AB = B - A
    AP = P - A
    t = np.dot(AP, AB) / np.dot(AB, AB)
    return A + t * AB


def get_label_direction(vertex, centroid):
    """Hướng label ra ngoài tam giác"""
    d = vertex - centroid
    return d / np.linalg.norm(d)


def angle_label_position(vertex, p1, p2, radius_factor=0.65):
    """Vị trí label góc nằm trong góc"""
    v1 = (p1 - vertex) / np.linalg.norm(p1 - vertex)
    v2 = (p2 - vertex) / np.linalg.norm(p2 - vertex)
    bisector = v1 + v2
    if np.linalg.norm(bisector) < 1e-6:
        bisector = np.array([v1[1], -v1[0], 0])
    bisector = bisector / np.linalg.norm(bisector)
    return vertex + radius_factor * bisector


# ========== SCENE 1: HOOK ==========
class Scene1_Hook(Scene):
    """Hook: Câu hỏi thú vị về tổng góc tam giác"""

    def construct(self):
        # Dramatic question
        question = Text("Tại sao...", font_size=56, color=WHITE)
        self.play(Write(question), run_time=SLOW)
        self.wait(BEAT)

        question2 = Text("mọi tam giác", font_size=48)
        question2.next_to(question, DOWN, buff=0.5)
        self.play(Write(question2), run_time=NORMAL)

        # Show various triangles appearing
        triangles = VGroup()
        positions = [
            [-4, 0.5, 0], [-1.5, 1.5, 0], [1.5, 0, 0],
            [4, 1, 0], [-2.5, -1.5, 0], [2, -1.5, 0]
        ]

        for pos in positions:
            # Random triangle shapes
            scale = 0.4 + 0.3 * np.random.random()
            angle = np.random.random() * PI
            p1 = np.array(pos) + scale * np.array([0, 1, 0])
            p2 = np.array(pos) + scale * np.array([
                -np.cos(angle), -0.5, 0
            ])
            p3 = np.array(pos) + scale * np.array([
                np.cos(angle), -0.3, 0
            ])
            tri = Polygon(p1, p2, p3, color=WHITE, stroke_width=1.5, fill_opacity=0.05)
            triangles.add(tri)

        self.play(
            LaggedStart(*[FadeIn(t, scale=0.5) for t in triangles], lag_ratio=0.15),
            run_time=SLOW
        )
        self.wait(BEAT)

        # The key question
        key_question = MathTex(
            r"\angle A + \angle B + \angle C = 180°",
            font_size=52
        )
        key_question.set_color(HIGHLIGHT)
        key_question.next_to(question2, DOWN, buff=0.8)

        box = SurroundingRectangle(key_question, color=HIGHLIGHT, buff=0.25, stroke_width=2)

        self.play(
            triangles.animate.set_opacity(0.2),
            run_time=FAST
        )
        self.play(
            Write(key_question),
            Create(box),
            run_time=SLOW
        )

        # Flash effect
        self.play(
            Flash(key_question.get_center(), color=HIGHLIGHT, line_length=0.4),
            run_time=FAST
        )

        self.wait(SLOW)

        # Transition
        self.play(
            FadeOut(VGroup(question, question2, triangles, key_question, box)),
            run_time=FAST
        )


# ========== SCENE 2: SETUP TRIANGLE ==========
class Scene2_Setup(Scene):
    """Setup: Vẽ tam giác ABC với 3 góc màu khác nhau"""

    def construct(self):
        # Triangle vertices - well-proportioned
        A = np.array([0, 2.2, 0])
        B = np.array([-2.8, -1.2, 0])
        C = np.array([2.8, -1.2, 0])
        centroid = (A + B + C) / 3

        # Create triangle with smooth animation
        triangle = Polygon(A, B, C, color=WHITE, stroke_width=LINE_WIDTH)

        # Animate drawing each side
        side_AB = Line(A, B, color=WHITE, stroke_width=LINE_WIDTH)
        side_BC = Line(B, C, color=WHITE, stroke_width=LINE_WIDTH)
        side_CA = Line(C, A, color=WHITE, stroke_width=LINE_WIDTH)

        self.play(Create(side_AB), run_time=NORMAL)
        self.play(Create(side_BC), run_time=NORMAL)
        self.play(Create(side_CA), run_time=NORMAL)
        self.wait(BEAT)

        # Labels with proper positioning
        label_A = MathTex("A", font_size=LABEL_SIZE)
        label_B = MathTex("B", font_size=LABEL_SIZE)
        label_C = MathTex("C", font_size=LABEL_SIZE)

        label_A.next_to(A, get_label_direction(A, centroid), buff=VERTEX_BUFF)
        label_B.next_to(B, get_label_direction(B, centroid), buff=VERTEX_BUFF)
        label_C.next_to(C, get_label_direction(C, centroid), buff=VERTEX_BUFF)

        self.play(
            Write(label_A), Write(label_B), Write(label_C),
            run_time=NORMAL
        )
        self.wait(BEAT)

        # Colored angles with proper Angle objects
        angle_A = Angle(
            Line(A, B), Line(A, C),
            radius=ANGLE_RADIUS,
            color=ANGLE_RED,
            fill_opacity=0.4,
            stroke_width=2
        )
        angle_B = Angle(
            Line(B, C), Line(B, A),
            radius=ANGLE_RADIUS,
            color=ANGLE_BLUE,
            fill_opacity=0.4,
            stroke_width=2
        )
        angle_C = Angle(
            Line(C, A), Line(C, B),
            radius=ANGLE_RADIUS,
            color=ANGLE_YELLOW,
            fill_opacity=0.4,
            stroke_width=2
        )

        # Greek labels positioned correctly inside angles
        alpha = MathTex(r"\alpha", color=ANGLE_RED, font_size=28)
        alpha.move_to(angle_label_position(A, B, C))

        beta = MathTex(r"\beta", color=ANGLE_BLUE, font_size=28)
        beta.move_to(angle_label_position(B, C, A))

        gamma = MathTex(r"\gamma", color=ANGLE_YELLOW, font_size=28)
        gamma.move_to(angle_label_position(C, A, B))

        # Animate angles one by one with emphasis
        self.play(Create(angle_A), Write(alpha), run_time=NORMAL)
        self.play(Flash(A, color=ANGLE_RED, line_length=0.2), run_time=FAST)

        self.play(Create(angle_B), Write(beta), run_time=NORMAL)
        self.play(Flash(B, color=ANGLE_BLUE, line_length=0.2), run_time=FAST)

        self.play(Create(angle_C), Write(gamma), run_time=NORMAL)
        self.play(Flash(C, color=ANGLE_YELLOW, line_length=0.2), run_time=FAST)

        self.wait(BEAT)

        # Goal statement at bottom
        goal = MathTex(
            r"\alpha", "+", r"\beta", "+", r"\gamma", "=", "?",
            font_size=44
        )
        goal[0].set_color(ANGLE_RED)
        goal[2].set_color(ANGLE_BLUE)
        goal[4].set_color(ANGLE_YELLOW)
        goal[6].set_color(HIGHLIGHT)
        goal.to_edge(DOWN, buff=0.6)

        self.play(Write(goal), run_time=NORMAL)
        self.wait(SLOW)

        # Fade for transition
        self.play(
            FadeOut(VGroup(
                side_AB, side_BC, side_CA,
                label_A, label_B, label_C,
                angle_A, angle_B, angle_C,
                alpha, beta, gamma, goal
            )),
            run_time=FAST
        )


# ========== SCENE 3: KEY INSIGHT ==========
class Scene3_KeyInsight(Scene):
    """Key Insight: Đường thẳng song song và góc so le trong"""

    def construct(self):
        # Triangle setup (same as before)
        A = np.array([0, 1.5, 0])
        B = np.array([-2.8, -1.5, 0])
        C = np.array([2.8, -1.5, 0])
        centroid = (A + B + C) / 3

        # Create full triangle
        triangle = Polygon(A, B, C, color=WHITE, stroke_width=LINE_WIDTH)

        # Labels
        label_A = MathTex("A", font_size=LABEL_SIZE).next_to(
            A, get_label_direction(A, centroid), buff=VERTEX_BUFF
        )
        label_B = MathTex("B", font_size=LABEL_SIZE).next_to(
            B, get_label_direction(B, centroid), buff=VERTEX_BUFF
        )
        label_C = MathTex("C", font_size=LABEL_SIZE).next_to(
            C, get_label_direction(C, centroid), buff=VERTEX_BUFF
        )

        # Angles
        angle_A = Angle(
            Line(A, B), Line(A, C),
            radius=0.35, color=ANGLE_RED, fill_opacity=0.4
        )
        angle_B = Angle(
            Line(B, C), Line(B, A),
            radius=0.35, color=ANGLE_BLUE, fill_opacity=0.4
        )
        angle_C = Angle(
            Line(C, A), Line(C, B),
            radius=0.35, color=ANGLE_YELLOW, fill_opacity=0.4
        )

        triangle_group = VGroup(
            triangle, label_A, label_B, label_C,
            angle_A, angle_B, angle_C
        )

        self.play(FadeIn(triangle_group), run_time=NORMAL)
        self.wait(BEAT)

        # Key insight text
        insight = Text("Ý tưởng then chốt:", font_size=32, color=HIGHLIGHT)
        insight.to_edge(UP, buff=0.4)
        self.play(Write(insight), run_time=NORMAL)

        insight2 = Text("Vẽ đường song song với BC qua A", font_size=28, color=MATH_BLUE)
        insight2.next_to(insight, DOWN, buff=0.3)
        self.play(Write(insight2), run_time=NORMAL)
        self.wait(BEAT)

        # Draw parallel line through A
        direction = (C - B) / np.linalg.norm(C - B)
        parallel_start = A - 3.5 * direction
        parallel_end = A + 3.5 * direction

        parallel_line = Line(
            parallel_start, parallel_end,
            color=MATH_BLUE, stroke_width=2.5
        )

        # Parallel marks
        mark1 = VGroup(
            Line(ORIGIN + 0.1*UP + 0.05*RIGHT, ORIGIN - 0.1*UP - 0.05*RIGHT),
            Line(ORIGIN + 0.1*UP - 0.05*RIGHT, ORIGIN - 0.1*UP + 0.05*RIGHT)
        ).set_color(MATH_BLUE).scale(0.8)
        mark1.move_to((B + C) / 2)
        mark2 = mark1.copy().move_to(A)

        self.play(Create(parallel_line), run_time=SLOW)
        self.play(FadeIn(mark1), FadeIn(mark2), run_time=FAST)
        self.wait(BEAT)

        # Show alternate interior angles - Beta
        alt_angle_B = Angle(
            Line(A, parallel_start),
            Line(A, B),
            radius=0.35,
            color=ANGLE_BLUE,
            fill_opacity=0.4
        )

        # Highlight connection
        self.play(
            Indicate(angle_B, color=ANGLE_BLUE, scale_factor=1.3),
            run_time=NORMAL
        )
        self.play(
            Create(alt_angle_B),
            run_time=NORMAL
        )

        # Label for alternate angle
        beta_alt_label = MathTex(r"\beta'", color=ANGLE_BLUE, font_size=26)
        beta_alt_pos = angle_label_position(A, parallel_start, B, radius_factor=0.7)
        beta_alt_label.move_to(beta_alt_pos)
        self.play(Write(beta_alt_label), run_time=FAST)

        # Explanation
        equal_beta = MathTex(r"\beta' = \beta", color=ANGLE_BLUE, font_size=28)
        equal_beta.next_to(parallel_line, UP, buff=0.3).shift(2*LEFT)
        reason_beta = Text("(góc so le trong)", font_size=20, color=GRAY)
        reason_beta.next_to(equal_beta, RIGHT, buff=0.2)

        self.play(Write(equal_beta), Write(reason_beta), run_time=NORMAL)
        self.wait(BEAT)

        # Show alternate interior angles - Gamma
        alt_angle_C = Angle(
            Line(A, C),
            Line(A, parallel_end),
            radius=0.35,
            color=ANGLE_YELLOW,
            fill_opacity=0.4
        )

        self.play(
            Indicate(angle_C, color=ANGLE_YELLOW, scale_factor=1.3),
            run_time=NORMAL
        )
        self.play(
            Create(alt_angle_C),
            run_time=NORMAL
        )

        gamma_alt_label = MathTex(r"\gamma'", color=ANGLE_YELLOW, font_size=26)
        gamma_alt_pos = angle_label_position(A, C, parallel_end, radius_factor=0.7)
        gamma_alt_label.move_to(gamma_alt_pos)
        self.play(Write(gamma_alt_label), run_time=FAST)

        equal_gamma = MathTex(r"\gamma' = \gamma", color=ANGLE_YELLOW, font_size=28)
        equal_gamma.next_to(parallel_line, UP, buff=0.3).shift(2*RIGHT)
        reason_gamma = Text("(góc so le trong)", font_size=20, color=GRAY)
        reason_gamma.next_to(equal_gamma, RIGHT, buff=0.2)

        self.play(Write(equal_gamma), Write(reason_gamma), run_time=NORMAL)

        self.wait(SLOW)

        # Fade for next scene
        self.play(
            FadeOut(VGroup(
                triangle_group, parallel_line, mark1, mark2,
                insight, insight2,
                alt_angle_B, alt_angle_C, beta_alt_label, gamma_alt_label,
                equal_beta, reason_beta, equal_gamma, reason_gamma
            )),
            run_time=FAST
        )


# ========== SCENE 4: REVELATION ==========
class Scene4_Revelation(Scene):
    """Revelation: 3 góc xếp thành góc bẹt 180°"""

    def construct(self):
        # Title
        title = Text("Và bây giờ... điều kỳ diệu!", font_size=40, color=HIGHLIGHT)
        title.to_edge(UP, buff=0.5)
        self.play(Write(title), run_time=NORMAL)
        self.wait(BEAT)

        # Point A and parallel line
        A = np.array([0, 0.5, 0])
        parallel_line = Line(
            np.array([-5, 0.5, 0]),
            np.array([5, 0.5, 0]),
            color=MATH_BLUE, stroke_width=3
        )

        self.play(Create(parallel_line), run_time=NORMAL)

        # Three colored sectors representing the angles
        # Using proper angle divisions that sum to PI (180°)
        angle_alpha = PI * 0.4  # ~72°
        angle_beta = PI * 0.35  # ~63°
        angle_gamma = PI * 0.25  # ~45°

        # Blue arc (beta') - left side
        beta_arc = AnnularSector(
            inner_radius=0,
            outer_radius=1.0,
            start_angle=PI,
            angle=angle_beta,
            color=ANGLE_BLUE,
            fill_opacity=0.5,
            stroke_width=2
        ).move_to(A)

        # Red arc (alpha) - middle
        alpha_arc = AnnularSector(
            inner_radius=0,
            outer_radius=1.0,
            start_angle=PI - angle_beta,
            angle=-angle_alpha,
            color=ANGLE_RED,
            fill_opacity=0.5,
            stroke_width=2
        ).move_to(A)

        # Yellow arc (gamma') - right side
        gamma_arc = AnnularSector(
            inner_radius=0,
            outer_radius=1.0,
            start_angle=angle_gamma,
            angle=-angle_gamma,
            color=ANGLE_YELLOW,
            fill_opacity=0.5,
            stroke_width=2
        ).move_to(A)

        # Labels
        beta_label = MathTex(r"\beta'", font_size=28, color=ANGLE_BLUE)
        beta_label.move_to(A + 1.3 * np.array([
            np.cos(PI + angle_beta/2),
            np.sin(PI + angle_beta/2),
            0
        ]))

        alpha_label = MathTex(r"\alpha", font_size=28, color=ANGLE_RED)
        alpha_label.move_to(A + 1.3 * UP)

        gamma_label = MathTex(r"\gamma'", font_size=28, color=ANGLE_YELLOW)
        gamma_label.move_to(A + 1.3 * np.array([
            np.cos(angle_gamma/2),
            np.sin(angle_gamma/2),
            0
        ]))

        # Animate arcs appearing
        self.play(
            FadeIn(beta_arc, shift=0.3*DOWN),
            Write(beta_label),
            run_time=NORMAL
        )
        self.play(
            FadeIn(alpha_arc, shift=0.3*DOWN),
            Write(alpha_label),
            run_time=NORMAL
        )
        self.play(
            FadeIn(gamma_arc, shift=0.3*DOWN),
            Write(gamma_label),
            run_time=NORMAL
        )

        self.wait(BEAT)

        # The revelation - they form a straight angle!
        self.play(FadeOut(title), run_time=FAST)

        reveal_text = Text("Ba góc tạo thành một góc bẹt!", font_size=36, color=HIGHLIGHT)
        reveal_text.to_edge(UP, buff=0.5)
        self.play(Write(reveal_text), run_time=NORMAL)

        # Brace under the line
        brace = Brace(
            Line(A + 1.2*LEFT, A + 1.2*RIGHT),
            DOWN, buff=0.2
        )

        # The equation
        conclusion = MathTex(
            r"\beta'", "+", r"\alpha", "+", r"\gamma'", "=", "180°",
            font_size=40
        )
        conclusion[0].set_color(ANGLE_BLUE)
        conclusion[2].set_color(ANGLE_RED)
        conclusion[4].set_color(ANGLE_YELLOW)
        conclusion.next_to(brace, DOWN, buff=0.3)

        self.play(
            FadeIn(brace),
            Write(conclusion),
            run_time=SLOW
        )

        # Flash for emphasis
        self.play(
            Flash(A, color=WHITE, line_length=0.5, num_lines=12),
            run_time=NORMAL
        )

        self.wait(BEAT)

        # Transform to final form
        final = MathTex(
            r"\beta", "+", r"\alpha", "+", r"\gamma", "=", "180°",
            font_size=44
        )
        final[0].set_color(ANGLE_BLUE)
        final[2].set_color(ANGLE_RED)
        final[4].set_color(ANGLE_YELLOW)
        final.next_to(brace, DOWN, buff=0.3)

        reason = Text("(vì β' = β và γ' = γ)", font_size=24, color=GRAY)
        reason.next_to(final, DOWN, buff=0.2)

        self.play(
            Transform(conclusion, final),
            Write(reason),
            run_time=NORMAL
        )

        # Celebration box
        result_box = SurroundingRectangle(
            conclusion, color=HIGHLIGHT, buff=0.2, stroke_width=3
        )
        self.play(Create(result_box), run_time=NORMAL)

        # QED symbol
        qed = Text("∎", font_size=48, color=GREEN)
        qed.to_corner(DR, buff=0.5)
        self.play(Write(qed), run_time=FAST)

        self.wait(DRAMATIC)


# ========== SCENE 5: CONCLUSION ==========
class Scene5_Conclusion(Scene):
    """Conclusion: Tổng kết và ý nghĩa"""

    def construct(self):
        # Final theorem statement
        title = Text("Định lý Tổng Các Góc Trong Tam Giác", font_size=36, color=MATH_BLUE)
        title.to_edge(UP, buff=0.6)

        theorem_text = Text(
            "Trong mọi tam giác, tổng ba góc luôn bằng 180°",
            font_size=30
        )
        theorem_math = MathTex(
            r"\angle A + \angle B + \angle C = 180°",
            font_size=42
        )
        theorem_box = SurroundingRectangle(
            VGroup(theorem_text, theorem_math).arrange(DOWN, buff=0.3),
            color=MATH_BLUE, buff=0.4, stroke_width=2
        )
        theorem_group = VGroup(theorem_text, theorem_math, theorem_box)
        theorem_group.center().shift(0.5*UP)

        self.play(Write(title), run_time=NORMAL)
        self.play(
            Write(theorem_text),
            Write(theorem_math),
            Create(theorem_box),
            run_time=SLOW
        )
        self.wait(NORMAL)

        # Show multiple triangles with 180° labeled
        self.play(
            theorem_group.animate.scale(0.7).to_edge(UP, buff=0.3),
            title.animate.scale(0.8).to_edge(UP, buff=0.1),
            run_time=NORMAL
        )

        # Three example triangles
        triangles_group = VGroup()

        # Equilateral
        t1_A = np.array([-4, -0.5, 0]) + np.array([0, 1, 0])
        t1_B = np.array([-4, -0.5, 0]) + np.array([-0.866, -0.5, 0])
        t1_C = np.array([-4, -0.5, 0]) + np.array([0.866, -0.5, 0])
        tri1 = Polygon(t1_A, t1_B, t1_C, color=WHITE, fill_opacity=0.1, stroke_width=2)
        label1 = Text("60° + 60° + 60°", font_size=20)
        label1.next_to(tri1, DOWN, buff=0.2)
        result1 = Text("= 180°", font_size=20, color=HIGHLIGHT)
        result1.next_to(label1, DOWN, buff=0.1)
        triangles_group.add(VGroup(tri1, label1, result1))

        # Right triangle
        t2_A = np.array([0, 0.5, 0])
        t2_B = np.array([-1, -1, 0])
        t2_C = np.array([1, -1, 0])
        tri2 = Polygon(t2_A, t2_B, t2_C, color=WHITE, fill_opacity=0.1, stroke_width=2)
        label2 = Text("90° + 45° + 45°", font_size=20)
        label2.next_to(tri2, DOWN, buff=0.2)
        result2 = Text("= 180°", font_size=20, color=HIGHLIGHT)
        result2.next_to(label2, DOWN, buff=0.1)
        triangles_group.add(VGroup(tri2, label2, result2))

        # Obtuse triangle
        t3_A = np.array([4, 0.8, 0])
        t3_B = np.array([2.5, -1, 0])
        t3_C = np.array([5, -1, 0])
        tri3 = Polygon(t3_A, t3_B, t3_C, color=WHITE, fill_opacity=0.1, stroke_width=2)
        label3 = Text("120° + 30° + 30°", font_size=20)
        label3.next_to(tri3, DOWN, buff=0.2)
        result3 = Text("= 180°", font_size=20, color=HIGHLIGHT)
        result3.next_to(label3, DOWN, buff=0.1)
        triangles_group.add(VGroup(tri3, label3, result3))

        # Animate triangles
        self.play(
            LaggedStart(*[
                AnimationGroup(
                    Create(group[0]),
                    Write(group[1]),
                    Write(group[2])
                )
                for group in triangles_group
            ], lag_ratio=0.4),
            run_time=SLOW
        )

        self.wait(NORMAL)

        # Final message
        end_text = Text(
            "Một trong những định lý đẹp nhất của hình học phẳng",
            font_size=26,
            color=GRAY
        )
        end_text.to_edge(DOWN, buff=0.4)
        self.play(Write(end_text), run_time=NORMAL)

        self.wait(DRAMATIC)

        # Fade out everything
        self.play(
            *[FadeOut(mob) for mob in self.mobjects],
            run_time=NORMAL
        )

        # End card
        thanks = Text("Cảm ơn đã xem!", font_size=48, color=WHITE)
        self.play(Write(thanks), run_time=NORMAL)
        self.wait(SLOW)


# ========== COMBINED SCENE (for single render) ==========
class TriangleAngleSumComplete(Scene):
    """Full video: Kết hợp tất cả scenes"""

    def construct(self):
        # Render từng scene riêng và ghép bằng ffmpeg
        pass
