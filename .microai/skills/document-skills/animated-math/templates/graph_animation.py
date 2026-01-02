"""
Graph Animation Template
========================
Template for creating animated function graphs.

Usage:
    manim -qh graph_animation.py FunctionGraphAnimation
    manim -qk graph_animation.py FunctionGraphAnimation  # 4K
"""

from manim import *


class FunctionGraphAnimation(Scene):
    """
    Animated function graph with tracing dot.

    Customize:
    - func: The function to plot
    - x_range, y_range: Axis ranges
    - colors: Graph and dot colors
    - labels: Function label
    """

    def construct(self):
        # ===== CONFIGURATION =====
        func = lambda x: np.sin(x)  # Change this function
        x_range = [-4, 4, 1]
        y_range = [-2, 2, 0.5]
        graph_color = BLUE
        dot_color = YELLOW
        label_text = r"f(x) = \sin(x)"

        # ===== AXES =====
        axes = Axes(
            x_range=x_range,
            y_range=y_range,
            x_length=10,
            y_length=6,
            axis_config={
                "include_numbers": True,
                "include_tip": True,
            }
        )

        # ===== GRAPH =====
        graph = axes.plot(func, color=graph_color)

        # ===== LABEL =====
        label = MathTex(label_text).to_corner(UL)

        # ===== TRACING DOT =====
        dot = Dot(color=dot_color)
        dot.move_to(axes.c2p(x_range[0], func(x_range[0])))

        # ===== ANIMATIONS =====
        # 1. Create axes
        self.play(Create(axes), run_time=1.5)

        # 2. Draw graph with tracing dot
        self.play(
            Create(graph),
            MoveAlongPath(dot, graph),
            Write(label),
            run_time=3
        )

        # 3. Hold final frame
        self.wait(2)


class MultipleGraphs(Scene):
    """Compare multiple functions on same axes."""

    def construct(self):
        # ===== CONFIGURATION =====
        functions = [
            (lambda x: np.sin(x), BLUE, r"\sin(x)"),
            (lambda x: np.cos(x), RED, r"\cos(x)"),
            (lambda x: np.tan(x) if abs(np.cos(x)) > 0.1 else 0, GREEN, r"\tan(x)"),
        ]

        # ===== AXES =====
        axes = Axes(
            x_range=[-4, 4, 1],
            y_range=[-2, 2, 0.5],
            x_length=10,
            y_length=6,
        )

        self.play(Create(axes))

        # ===== PLOT EACH FUNCTION =====
        legend = VGroup()
        for func, color, label_text in functions:
            graph = axes.plot(func, color=color)
            label = MathTex(label_text, color=color)
            legend.add(label)

            self.play(Create(graph), run_time=1.5)

        # ===== LEGEND =====
        legend.arrange(DOWN, aligned_edge=LEFT).to_corner(UR)
        self.play(Write(legend))

        self.wait(2)


class AnimatedParameter(Scene):
    """Animate a function parameter (e.g., amplitude)."""

    def construct(self):
        axes = Axes(x_range=[-4, 4], y_range=[-3, 3])

        # Parameter tracker
        a = ValueTracker(1)

        # Graph that updates with parameter
        graph = always_redraw(
            lambda: axes.plot(
                lambda x: a.get_value() * np.sin(x),
                color=BLUE
            )
        )

        # Label showing current parameter value
        label = always_redraw(
            lambda: MathTex(
                f"f(x) = {a.get_value():.1f}\\sin(x)"
            ).to_corner(UL)
        )

        self.play(Create(axes), Create(graph), Write(label))

        # Animate parameter changes
        self.play(a.animate.set_value(2), run_time=2)
        self.play(a.animate.set_value(0.5), run_time=2)
        self.play(a.animate.set_value(1), run_time=1)

        self.wait()


# Run with: manim -qh graph_animation.py FunctionGraphAnimation
