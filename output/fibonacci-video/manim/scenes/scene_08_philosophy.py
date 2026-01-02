"""
Scene 08: Philosophical Conclusion - Cosmic Zoom
Duration: 60 seconds
Purpose: Reflect on the beauty and universality of Fibonacci
"""

from manim import *
import numpy as np
from config import *

class Scene08_Philosophy(Scene):
    """
    Philosophical reflection - cosmic zoom out

    Visual elements:
    1. Zoom from atom to galaxy
    2. Fibonacci pattern at each scale
    3. Unity of mathematics and nature
    4. Galileo quote
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Part 1: Scale journey
        self.scale_journey()

        # Part 2: Philosophical reflection
        self.philosophical_reflection()

        self.wait(2)

    def scale_journey(self):
        """Show Fibonacci across scales"""
        # Central spiral that will transform
        spiral = self.create_spiral()
        spiral.scale(0.3)

        # Scale labels and their names
        scales = [
            ("ADN", 0.3, FIBONACCI_BLUE),
            ("Te bao", 0.5, NATURE_GREEN),
            ("Sinh vat", 0.8, WARM_ORANGE),
            ("Trai Dat", 1.2, SPIRAL_PURPLE),
            ("Vu tru", 2.0, GOLDEN_YELLOW),
        ]

        self.play(FadeIn(spiral), run_time=1)

        for i, (name, scale, color) in enumerate(scales):
            # Scale label
            label = Text(
                name,
                font=VN_FONT,
                font_size=BODY_SIZE,
                color=color
            ).to_edge(DOWN)

            # Scale the spiral
            self.play(
                spiral.animate.scale(scale / spiral.width * 2).set_color(color),
                Write(label),
                run_time=1.2
            )
            self.wait(0.5)
            self.play(FadeOut(label), run_time=0.3)

        self.play(FadeOut(spiral), run_time=0.5)

    def philosophical_reflection(self):
        """Display philosophical quote and reflection"""
        # Galileo quote
        quote = Text(
            '"Vu tru duoc viet bang ngon ngu toan hoc."',
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=CREAM_WHITE,
            slant=ITALIC
        )

        author = Text(
            "- Galileo Galilei",
            font=VN_FONT,
            font_size=LABEL_SIZE,
            color=GRAY
        ).next_to(quote, DOWN, buff=0.3)

        quote_group = VGroup(quote, author)

        self.play(Write(quote), run_time=2)
        self.play(Write(author), run_time=1)
        self.wait(2)

        # Final reflection
        self.play(
            quote_group.animate.shift(UP*2).scale(0.8),
            run_time=1
        )

        reflection = Text(
            "Va Fibonacci la mot trong nhung\ncau tuyet dep nhat.",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).shift(DOWN*0.5)

        self.play(Write(reflection), run_time=2)

        # Fibonacci spiral background
        bg_spiral = self.create_spiral()
        bg_spiral.scale(2).set_opacity(0.2).set_color(GOLDEN_YELLOW)

        self.play(
            FadeIn(bg_spiral),
            run_time=2
        )

    def create_spiral(self):
        """Create golden spiral"""
        b = np.log(PHI) / (PI/2)
        spiral = ParametricFunction(
            lambda t: np.array([
                0.1 * np.exp(b * t) * np.cos(t),
                0.1 * np.exp(b * t) * np.sin(t),
                0
            ]),
            t_range=[-3*PI, 2*PI],
            color=GOLDEN_YELLOW,
            stroke_width=3
        )
        return spiral


class Scene08_UniversalPattern(Scene):
    """
    Alternative scene showing the universal pattern
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Central Fibonacci sequence
        sequence = MathTex(
            r"1, 1, 2, 3, 5, 8, 13, 21, 34, 55...",
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        )

        self.play(Write(sequence), run_time=2)
        self.wait(1)

        # Radiate connections to different scales
        connections = [
            ("ADN", UP*2 + LEFT*3),
            ("Hoa", UP*2 + RIGHT*3),
            ("Vo oc", DOWN*2 + LEFT*3),
            ("Thien ha", DOWN*2 + RIGHT*3),
        ]

        for name, pos in connections:
            label = Text(
                name,
                font=VN_FONT,
                font_size=LABEL_SIZE,
                color=SPIRAL_PURPLE
            ).move_to(pos)

            arrow = Arrow(
                sequence.get_center(),
                label.get_center(),
                color=FIBONACCI_BLUE,
                stroke_width=2
            )

            self.play(
                Create(arrow),
                Write(label),
                run_time=0.6
            )

        self.wait(1)

        # Encompassing circle
        circle = Circle(
            radius=3.5,
            color=GOLDEN_YELLOW,
            stroke_width=3
        )

        self.play(Create(circle), run_time=1.5)

        # Unity label
        unity = Text(
            "Mot quy luat - Van ve dep",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).to_edge(DOWN)

        self.play(Write(unity), run_time=1)
        self.wait(2)


class Scene08_CosmicZoom(Scene):
    """
    Visual cosmic zoom effect
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Create nested spirals representing different scales
        spirals = VGroup()
        colors = [FIBONACCI_BLUE, NATURE_GREEN, WARM_ORANGE, SPIRAL_PURPLE, GOLDEN_YELLOW]

        for i, color in enumerate(colors):
            b = np.log(PHI) / (PI/2)
            spiral = ParametricFunction(
                lambda t, scale=0.05 * (i + 1): np.array([
                    scale * np.exp(b * t) * np.cos(t),
                    scale * np.exp(b * t) * np.sin(t),
                    0
                ]),
                t_range=[-2*PI, 2*PI],
                color=color,
                stroke_width=2
            )
            spirals.add(spiral)

        # Animate spirals appearing
        self.play(
            LaggedStart(
                *[Create(s) for s in spirals],
                lag_ratio=0.5
            ),
            run_time=4
        )

        self.wait(1)

        # Zoom out effect
        self.play(
            spirals.animate.scale(0.5).set_opacity(0.5),
            run_time=2
        )

        # Final message
        message = Text(
            "Tu nho den lon,\nFibonacci o khap noi.",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).shift(DOWN*2)

        self.play(Write(message), run_time=2)
        self.wait(2)
