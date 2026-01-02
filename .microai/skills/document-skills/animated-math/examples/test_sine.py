"""
Test: Animated Sine Curve
=========================
Simple test to verify Manim installation and rendering.
"""

from manim import *


class SineCurveTest(Scene):
    """Simple sine curve animation for testing."""

    def construct(self):
        # Title
        title = Text("Đồ thị hàm sin(x)", font_size=48)
        title.to_edge(UP)

        # Axes
        axes = Axes(
            x_range=[-4, 4, 1],
            y_range=[-2, 2, 1],
            x_length=10,
            y_length=5,
            axis_config={"include_numbers": True}
        )

        # Sine graph
        graph = axes.plot(lambda x: np.sin(x), color=BLUE)
        label = MathTex(r"f(x) = \sin(x)", color=BLUE).next_to(axes, DOWN)

        # Animations
        self.play(Write(title), run_time=0.5)
        self.play(Create(axes), run_time=1)
        self.play(Create(graph), Write(label), run_time=2)
        self.wait(1)


# Run: manim -qm -p test_sine.py SineCurveTest
