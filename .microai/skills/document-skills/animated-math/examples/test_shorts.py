"""
Test: YouTube Shorts Animation (9:16 Vertical)
==============================================
"""

from manim import *

# Shorts config
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920


class DerivativeShort(Scene):
    """Quick derivative visualization for Shorts."""

    def construct(self):
        # Title (top)
        title = Text("Đạo hàm = Độ dốc", font_size=64, color=YELLOW)
        title.to_edge(UP, buff=0.8)

        # Axes (middle)
        axes = Axes(
            x_range=[-2, 2, 1],
            y_range=[-1, 4, 1],
            x_length=7,
            y_length=7,
            axis_config={"include_tip": True}
        ).shift(DOWN * 0.5)

        # f(x) = x²
        func = axes.plot(lambda x: x**2, color=BLUE)
        func_label = MathTex(r"f(x) = x^2", font_size=48, color=BLUE)
        func_label.next_to(title, DOWN, buff=0.5)

        # Moving tangent
        x_val = ValueTracker(-1.5)

        tangent = always_redraw(
            lambda: axes.get_secant_slope_group(
                x=x_val.get_value(),
                graph=func,
                dx=0.01,
                secant_line_length=3,
                secant_line_color=RED
            )
        )

        dot = always_redraw(
            lambda: Dot(
                axes.c2p(x_val.get_value(), x_val.get_value()**2),
                color=YELLOW,
                radius=0.12
            )
        )

        # Formula (bottom)
        formula = MathTex(r"f'(x) = 2x", font_size=56, color=GREEN)
        formula.to_edge(DOWN, buff=1)

        # Animations (fast for Shorts)
        self.play(Write(title), run_time=0.4)
        self.play(Write(func_label), run_time=0.3)
        self.play(Create(axes), Create(func), run_time=1)

        self.add(tangent, dot)
        self.play(x_val.animate.set_value(1.5), run_time=2.5)

        self.play(Write(formula), run_time=0.4)
        self.wait(0.5)


# Run: manim -qm test_shorts.py DerivativeShort
