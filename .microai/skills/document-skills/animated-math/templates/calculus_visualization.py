"""
Calculus Visualization Templates
================================
Templates for derivative, integral, and limit visualizations.

Usage:
    manim -qh calculus_visualization.py DerivativeVisualization
    manim -qh calculus_visualization.py IntegralVisualization
    manim -qh calculus_visualization.py LimitVisualization
"""

from manim import *


class DerivativeVisualization(Scene):
    """
    Visualize derivative as slope of tangent line.
    Shows tangent line moving along curve.
    """

    def construct(self):
        # ===== CONFIGURATION =====
        func = lambda x: x**2
        func_derivative = lambda x: 2*x
        x_range = [-3, 3]
        y_range = [-1, 9]

        # ===== SETUP =====
        axes = Axes(
            x_range=[x_range[0], x_range[1], 1],
            y_range=[y_range[0], y_range[1], 1],
            x_length=10,
            y_length=6,
            axis_config={"include_numbers": True}
        )

        # Function graph
        graph = axes.plot(func, color=BLUE)
        graph_label = MathTex(r"f(x) = x^2").to_corner(UL)

        # Moving x value
        x_tracker = ValueTracker(-2)

        # Tangent line (always redraws)
        tangent = always_redraw(
            lambda: axes.get_secant_slope_group(
                x=x_tracker.get_value(),
                graph=graph,
                dx=0.01,
                secant_line_length=5,
                secant_line_color=RED
            )
        )

        # Point on curve
        dot = always_redraw(
            lambda: Dot(
                axes.c2p(x_tracker.get_value(), func(x_tracker.get_value())),
                color=YELLOW
            )
        )

        # Slope value display
        slope_text = always_redraw(
            lambda: MathTex(
                f"f'({x_tracker.get_value():.1f}) = {func_derivative(x_tracker.get_value()):.1f}"
            ).to_corner(UR)
        )

        # ===== ANIMATIONS =====
        self.play(Create(axes), Write(graph_label))
        self.play(Create(graph), run_time=2)

        self.add(tangent, dot)
        self.play(Write(slope_text))

        # Move tangent along curve
        self.play(x_tracker.animate.set_value(2), run_time=5, rate_func=smooth)

        self.wait(2)


class IntegralVisualization(Scene):
    """
    Visualize integral as area under curve.
    Shows Riemann sum converging to integral.
    """

    def construct(self):
        # ===== CONFIGURATION =====
        func = lambda x: 0.5 * x**2
        x_range = [0, 5]
        integral_range = [1, 4]

        # ===== SETUP =====
        axes = Axes(
            x_range=[x_range[0], x_range[1], 1],
            y_range=[0, 10, 2],
            x_length=10,
            y_length=6,
            axis_config={"include_numbers": True}
        )

        graph = axes.plot(func, color=BLUE)
        graph_label = MathTex(r"f(x) = \frac{x^2}{2}").to_corner(UL)

        # Number of rectangles tracker
        n_tracker = ValueTracker(4)

        # Riemann rectangles (always redraws)
        rects = always_redraw(
            lambda: axes.get_riemann_rectangles(
                graph,
                x_range=integral_range,
                dx=(integral_range[1] - integral_range[0]) / n_tracker.get_value(),
                color=[BLUE, GREEN],
                fill_opacity=0.5
            )
        )

        # Rectangle count display
        n_text = always_redraw(
            lambda: MathTex(
                f"n = {int(n_tracker.get_value())}"
            ).to_corner(UR)
        )

        # Integral formula
        integral_label = MathTex(
            r"\int_1^4 \frac{x^2}{2} dx = \frac{x^3}{6}\Big|_1^4 = \frac{63}{6} = 10.5"
        ).to_edge(DOWN)

        # ===== ANIMATIONS =====
        self.play(Create(axes), Write(graph_label))
        self.play(Create(graph), run_time=1.5)

        self.play(Create(rects), Write(n_text))

        # Increase number of rectangles
        self.play(n_tracker.animate.set_value(10), run_time=2)
        self.play(n_tracker.animate.set_value(30), run_time=2)
        self.play(n_tracker.animate.set_value(100), run_time=2)

        # Show exact integral
        self.play(Write(integral_label))

        self.wait(2)


class LimitVisualization(Scene):
    """
    Visualize limit as x approaches a value.
    """

    def construct(self):
        # ===== CONFIGURATION =====
        # f(x) = (x² - 1)/(x - 1) = x + 1 for x ≠ 1
        func = lambda x: (x**2 - 1)/(x - 1) if abs(x - 1) > 0.001 else 2

        # ===== SETUP =====
        axes = Axes(
            x_range=[-1, 4, 1],
            y_range=[-1, 5, 1],
            x_length=10,
            y_length=6,
            axis_config={"include_numbers": True}
        )

        # Graph with hole at x = 1
        graph = axes.plot(func, x_range=[-0.5, 0.99], color=BLUE)
        graph2 = axes.plot(func, x_range=[1.01, 3.5], color=BLUE)

        # Hole at x = 1
        hole = Circle(radius=0.08, color=BLUE).move_to(axes.c2p(1, 2))

        # Limit point (filled)
        limit_point = Dot(axes.c2p(1, 2), color=YELLOW)

        # Approaching dot
        x_tracker = ValueTracker(0)

        approaching_dot = always_redraw(
            lambda: Dot(
                axes.c2p(x_tracker.get_value(), func(x_tracker.get_value())),
                color=RED
            )
        )

        # Labels
        func_label = MathTex(
            r"f(x) = \frac{x^2 - 1}{x - 1}"
        ).to_corner(UL)

        limit_label = MathTex(
            r"\lim_{x \to 1} f(x) = 2"
        ).to_corner(UR)

        # Vertical line at x = 1
        v_line = DashedLine(
            axes.c2p(1, 0),
            axes.c2p(1, 2),
            color=GREY
        )

        # ===== ANIMATIONS =====
        self.play(Create(axes), Write(func_label))
        self.play(Create(graph), Create(graph2), Create(hole))

        self.add(approaching_dot)
        self.play(Create(v_line))

        # Approach from left
        self.play(x_tracker.animate.set_value(0.99), run_time=3)

        # Show limit
        self.play(Create(limit_point), Write(limit_label))

        self.wait(2)


class TaylorSeriesVisualization(Scene):
    """
    Visualize Taylor series approximation.
    """

    def construct(self):
        # ===== CONFIGURATION =====
        func = np.sin

        # Taylor series terms for sin(x)
        taylor_terms = [
            lambda x: x,
            lambda x: x - x**3/6,
            lambda x: x - x**3/6 + x**5/120,
            lambda x: x - x**3/6 + x**5/120 - x**7/5040,
        ]

        colors = [RED, ORANGE, YELLOW, GREEN]

        # ===== SETUP =====
        axes = Axes(
            x_range=[-4, 4, 1],
            y_range=[-2, 2, 0.5],
            x_length=10,
            y_length=6
        )

        # Original function
        original = axes.plot(func, color=BLUE)
        original_label = MathTex(r"f(x) = \sin(x)").to_corner(UL)

        self.play(Create(axes), Write(original_label))
        self.play(Create(original))

        # Add Taylor approximations one by one
        labels = [
            r"T_1(x) = x",
            r"T_3(x) = x - \frac{x^3}{6}",
            r"T_5(x) = x - \frac{x^3}{6} + \frac{x^5}{120}",
            r"T_7(x)"
        ]

        current_approx = None
        for i, (taylor, color, label) in enumerate(zip(taylor_terms, colors, labels)):
            approx = axes.plot(taylor, color=color)
            approx_label = MathTex(label, font_size=36).next_to(original_label, DOWN)

            if current_approx:
                self.play(
                    Transform(current_approx, approx),
                    Transform(current_label, approx_label)
                )
            else:
                current_approx = approx
                current_label = approx_label
                self.play(Create(current_approx), Write(current_label))

            self.wait(1)

        self.wait(2)


# Run with:
# manim -qh calculus_visualization.py DerivativeVisualization
# manim -qh calculus_visualization.py IntegralVisualization
# manim -qh calculus_visualization.py LimitVisualization
# manim -qh calculus_visualization.py TaylorSeriesVisualization
