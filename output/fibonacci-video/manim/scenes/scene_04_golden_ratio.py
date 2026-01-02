"""
Scene 04: Golden Ratio Convergence
Duration: 90 seconds
Purpose: Show how Fibonacci ratios converge to phi
"""

from manim import *
import numpy as np
from config import *

class Scene04_GoldenRatio(Scene):
    """
    Golden ratio convergence: F(n+1)/F(n) -> phi

    Visual elements:
    1. Ratio calculations displayed
    2. Number line with convergence
    3. Phi symbol reveal
    4. Mathematical formula for phi
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Ti le Vang",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Create number line
        self.show_convergence()

        # Reveal phi formula
        self.reveal_phi_formula()

        self.wait(2)

    def show_convergence(self):
        """Show ratios converging on number line"""
        # Fibonacci numbers
        fib = fibonacci(15)
        ratios = [fib[i+1]/fib[i] for i in range(len(fib)-1)]

        # Number line
        number_line = NumberLine(
            x_range=[1, 2.5, 0.5],
            length=10,
            include_numbers=True,
            numbers_to_include=[1, 1.5, 2, 2.5],
            font_size=LABEL_SIZE
        ).shift(DOWN*0.5)

        # Phi marker
        phi_val = PHI
        phi_dot = Dot(
            number_line.n2p(phi_val),
            color=GOLDEN_YELLOW,
            radius=0.12
        )
        phi_label = MathTex(
            r"\phi",
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).next_to(phi_dot, UP)

        # Phi line
        phi_line = DashedLine(
            number_line.n2p(phi_val) + UP*1.5,
            number_line.n2p(phi_val) + DOWN*0.2,
            color=GOLDEN_YELLOW,
            stroke_width=2
        )

        # Show number line
        self.play(Create(number_line), run_time=1.5)
        self.play(
            Create(phi_line),
            FadeIn(phi_dot),
            Write(phi_label),
            run_time=1
        )
        self.wait(0.5)

        # Ratio display area
        ratio_display = VGroup()

        # Moving dot
        moving_dot = Dot(color=FIBONACCI_BLUE, radius=0.1)

        # Animate ratios converging
        for i, ratio in enumerate(ratios[:10]):
            # Calculation text
            calc = MathTex(
                f"\\frac{{{fib[i+1]}}}{{{fib[i]}}} = {ratio:.6f}",
                font_size=LABEL_SIZE
            ).to_edge(LEFT, buff=1).shift(UP*2)

            # Position dot on number line
            dot_pos = number_line.n2p(ratio)

            if i == 0:
                moving_dot.move_to(dot_pos)
                self.play(
                    Write(calc),
                    FadeIn(moving_dot),
                    run_time=0.8
                )
            else:
                new_calc = MathTex(
                    f"\\frac{{{fib[i+1]}}}{{{fib[i]}}} = {ratio:.6f}",
                    font_size=LABEL_SIZE
                ).to_edge(LEFT, buff=1).shift(UP*2)

                # Trace line
                trace = Line(
                    moving_dot.get_center(),
                    dot_pos,
                    color=FIBONACCI_BLUE,
                    stroke_width=2,
                    stroke_opacity=0.5
                )

                self.play(
                    Transform(calc, new_calc),
                    Create(trace),
                    moving_dot.animate.move_to(dot_pos),
                    run_time=0.5
                )

            self.wait(0.2)

        # Show how close we are
        distance_text = MathTex(
            r"\rightarrow 1.6180339...",
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).next_to(ratio_display, DOWN) if ratio_display else None

        # Convergence animation
        self.play(
            moving_dot.animate.move_to(phi_dot.get_center()),
            Flash(phi_dot.get_center(), color=GOLDEN_YELLOW),
            run_time=1
        )

    def reveal_phi_formula(self):
        """Show the formula for golden ratio"""
        # Clear previous elements
        self.play(*[FadeOut(mob) for mob in self.mobjects], run_time=0.5)

        # Phi definition
        phi_def = MathTex(
            r"\phi = \frac{1 + \sqrt{5}}{2}",
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        )

        # Approximate value
        phi_approx = MathTex(
            r"\approx 1.6180339887...",
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).next_to(phi_def, DOWN, buff=0.5)

        # Property
        phi_property = MathTex(
            r"\phi^2 = \phi + 1",
            font_size=BODY_SIZE,
            color=SPIRAL_PURPLE
        ).next_to(phi_approx, DOWN, buff=0.5)

        # Golden rectangle visual
        rect = self.create_golden_rectangle().scale(0.8).shift(DOWN*2)

        # Animations
        self.play(Write(phi_def), run_time=2)
        self.wait(0.5)

        self.play(Write(phi_approx), run_time=1)
        self.wait(0.5)

        self.play(Write(phi_property), run_time=1)
        self.wait(0.5)

        self.play(FadeIn(rect), run_time=1.5)

        # Highlight the beautiful property
        box = SurroundingRectangle(phi_property, color=SPIRAL_PURPLE)
        self.play(Create(box), run_time=0.5)

    def create_golden_rectangle(self):
        """Create a visual golden rectangle with nested squares"""
        # Main rectangle
        width = 3
        height = width / PHI

        rect = Rectangle(
            width=width,
            height=height,
            color=GOLDEN_YELLOW,
            stroke_width=3
        )

        # Square inside
        square = Square(
            side_length=height,
            color=FIBONACCI_BLUE,
            stroke_width=2
        ).align_to(rect, LEFT).align_to(rect, DOWN)

        # Remaining rectangle
        remaining_width = width - height
        remaining = Rectangle(
            width=remaining_width,
            height=height,
            color=WARM_ORANGE,
            stroke_width=2
        ).align_to(rect, RIGHT).align_to(rect, DOWN)

        # Labels
        label_phi = MathTex(r"\phi", font_size=SMALL_SIZE).next_to(rect, UP)
        label_1 = MathTex("1", font_size=SMALL_SIZE).next_to(square, LEFT)

        return VGroup(rect, square, remaining, label_phi, label_1)
