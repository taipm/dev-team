"""
YouTube Shorts Template (9:16 Vertical)
=======================================
Template for creating vertical math animations for YouTube Shorts.

Usage:
    manim -qh -r 1080,1920 shorts_template.py MathShort
    manim -qk -r 2160,3840 shorts_template.py MathShort  # 4K Shorts
"""

from manim import *

# ===== SHORTS CONFIG =====
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920


class MathShort(Scene):
    """
    Basic YouTube Shorts template with:
    - Title at top
    - Math content in middle
    - Formula at bottom

    Duration: ~15-30 seconds (optimal for Shorts)
    """

    def construct(self):
        # ===== TITLE (TOP) =====
        title = Text(
            "Đạo hàm là gì?",
            font_size=72,
            color=WHITE
        ).to_edge(UP, buff=0.8)

        # ===== AXES (MIDDLE) =====
        axes = Axes(
            x_range=[-2, 2, 1],
            y_range=[-1, 4, 1],
            x_length=7,
            y_length=7,
            axis_config={"include_tip": True}
        ).shift(DOWN * 0.5)

        # ===== GRAPH =====
        func = axes.plot(lambda x: x**2, color=BLUE)

        # ===== TANGENT LINE =====
        x_val = ValueTracker(-1.5)

        tangent = always_redraw(
            lambda: axes.get_secant_slope_group(
                x=x_val.get_value(),
                graph=func,
                dx=0.01,
                secant_line_length=4,
                secant_line_color=RED
            )
        )

        dot = always_redraw(
            lambda: Dot(
                axes.c2p(x_val.get_value(), x_val.get_value()**2),
                color=YELLOW,
                radius=0.15
            )
        )

        # ===== FORMULA (BOTTOM) =====
        formula = MathTex(
            r"f'(x) = 2x",
            font_size=64,
            color=YELLOW
        ).to_edge(DOWN, buff=1)

        # ===== ANIMATIONS (Fast for Shorts) =====
        # Hook: Title immediately
        self.play(Write(title), run_time=0.5)

        # Build up
        self.play(Create(axes), run_time=0.8)
        self.play(Create(func), run_time=1)

        # Add tangent
        self.add(tangent, dot)

        # Animate tangent moving
        self.play(x_val.animate.set_value(1.5), run_time=3)

        # Reveal formula
        self.play(Write(formula), run_time=0.5)

        # Hold for viewers to read
        self.wait(1.5)


class QuickMathTrick(Scene):
    """Quick math trick reveal (perfect for Shorts)."""

    def construct(self):
        # ===== QUESTION =====
        question = Text(
            "25 × 25 = ?",
            font_size=80
        )

        # ===== TRICK EXPLANATION =====
        trick = VGroup(
            MathTex(r"25 \times 25", font_size=60),
            MathTex(r"= 25 \times (20 + 5)", font_size=50),
            MathTex(r"= 500 + 125", font_size=50),
            MathTex(r"= 625", font_size=80, color=YELLOW)
        ).arrange(DOWN, buff=0.5)

        # ===== ANIMATIONS =====
        self.play(Write(question), run_time=0.5)
        self.wait(1.5)

        self.play(question.animate.to_edge(UP, buff=1), run_time=0.3)

        for step in trick:
            self.play(Write(step), run_time=0.4)
            self.wait(0.3)

        # Highlight answer
        box = SurroundingRectangle(trick[-1], color=YELLOW, buff=0.2)
        self.play(Create(box), run_time=0.3)

        self.wait(1)


class FormulaReveal(Scene):
    """Step-by-step formula derivation for Shorts."""

    def construct(self):
        # ===== TITLE =====
        title = Text(
            "Công thức tích phân",
            font_size=60
        ).to_edge(UP, buff=0.8)

        # ===== STEPS =====
        steps = VGroup(
            MathTex(r"\int x^n \, dx", font_size=56),
            MathTex(r"= \frac{x^{n+1}}{n+1}", font_size=56),
            MathTex(r"+ C", font_size=56, color=RED)
        )

        # Position steps
        steps[0].shift(UP * 2)
        steps[1].next_to(steps[0], DOWN, buff=0.8)
        steps[2].next_to(steps[1], RIGHT, buff=0.2)

        # ===== EXAMPLE =====
        example_title = Text("Ví dụ:", font_size=48).shift(DOWN * 1)
        example = MathTex(
            r"\int x^2 \, dx = \frac{x^3}{3} + C",
            font_size=52,
            color=BLUE
        ).next_to(example_title, DOWN, buff=0.5)

        # ===== ANIMATIONS =====
        self.play(Write(title), run_time=0.4)

        for step in steps:
            self.play(Write(step), run_time=0.5)
            self.wait(0.3)

        self.play(Write(example_title), run_time=0.3)
        self.play(Write(example), run_time=0.6)

        self.wait(1.5)


# Run with:
# manim -qh -r 1080,1920 shorts_template.py MathShort
# manim -qh -r 1080,1920 shorts_template.py QuickMathTrick
# manim -qh -r 1080,1920 shorts_template.py FormulaReveal
