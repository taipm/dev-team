"""
Scene 01: Hook - DNA and Fibonacci
Duration: 30 seconds
Purpose: Capture attention with DNA helix and Fibonacci measurements
"""

from manim import *
import numpy as np
from config import *

class Scene01_Hook(ThreeDScene):
    """
    Hook scene: DNA helix with Fibonacci measurements

    Visual elements:
    1. 3D DNA double helix rotating
    2. Measurement annotations showing 34A and 21A
    3. Ratio calculation: 34/21 = 1.619...
    4. Flash to golden ratio symbol
    """

    def construct(self):
        # Set background
        self.camera.background_color = DARK_BG

        # Camera setup for 3D
        self.set_camera_orientation(phi=70*DEGREES, theta=-45*DEGREES)

        # Create DNA helix structure
        helix = self.create_dna_helix()
        helix.scale(0.8)

        # Title text
        title = Text(
            "Fibonacci trong DNA",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP)

        # Measurement labels
        measure_34 = MathTex(
            r"34 \text{ \AA}",
            font_size=BODY_SIZE,
            color=FIBONACCI_BLUE
        ).shift(RIGHT*3 + UP*1.5)

        measure_21 = MathTex(
            r"21 \text{ \AA}",
            font_size=BODY_SIZE,
            color=WARM_ORANGE
        ).shift(RIGHT*3 + DOWN*0.5)

        # Ratio reveal
        ratio_tex = MathTex(
            r"\frac{34}{21} = 1.619...",
            font_size=BODY_SIZE,
            color=WHITE
        ).shift(DOWN*2.5)

        # Golden ratio symbol
        phi_symbol = MathTex(
            r"\approx \phi \text{ (Ti le vang!)}",
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).next_to(ratio_tex, RIGHT, buff=0.3)

        # Fibonacci sequence
        fib_seq = MathTex(
            r"1, 1, 2, 3, 5, 8, 13, 21, 34...",
            font_size=BODY_SIZE,
            color=SPIRAL_PURPLE
        ).to_edge(DOWN)

        # Animation sequence
        # 0:00-0:05 - Show DNA
        self.add_fixed_in_frame_mobjects(title)
        self.play(Create(helix), run_time=2)
        self.begin_ambient_camera_rotation(rate=0.1)
        self.wait(1)

        # 0:05-0:15 - Show measurements
        self.add_fixed_in_frame_mobjects(measure_34, measure_21)
        self.play(
            Write(measure_34),
            Write(measure_21),
            run_time=1.5
        )
        self.wait(2)

        # 0:15-0:22 - Show ratio
        self.stop_ambient_camera_rotation()
        self.add_fixed_in_frame_mobjects(ratio_tex)
        self.play(Write(ratio_tex), run_time=2)
        self.wait(1)

        # 0:22-0:27 - Reveal golden ratio
        self.add_fixed_in_frame_mobjects(phi_symbol)
        self.play(
            Write(phi_symbol),
            Flash(phi_symbol.get_center(), color=GOLDEN_YELLOW, flash_radius=0.8),
            run_time=1.5
        )
        self.wait(1)

        # 0:27-0:30 - Show Fibonacci sequence
        self.add_fixed_in_frame_mobjects(fib_seq)
        self.play(Write(fib_seq), run_time=1.5)
        self.wait(1)

    def create_dna_helix(self):
        """Create parametric DNA double helix"""
        # First strand
        helix1 = ParametricFunction(
            lambda t: np.array([
                np.cos(t),
                np.sin(t),
                t / 2
            ]),
            t_range=[-3*PI, 3*PI],
            color=FIBONACCI_BLUE,
            stroke_width=4
        )

        # Second strand (offset by PI)
        helix2 = ParametricFunction(
            lambda t: np.array([
                np.cos(t + PI),
                np.sin(t + PI),
                t / 2
            ]),
            t_range=[-3*PI, 3*PI],
            color=WARM_ORANGE,
            stroke_width=4
        )

        # Create base pair connections
        connections = VGroup()
        for t in np.linspace(-3*PI, 3*PI, 20):
            p1 = np.array([np.cos(t), np.sin(t), t/2])
            p2 = np.array([np.cos(t + PI), np.sin(t + PI), t/2])
            line = Line3D(p1, p2, color=NATURE_GREEN, thickness=0.02)
            connections.add(line)

        return VGroup(helix1, helix2, connections)


class Scene01_Hook_2D(Scene):
    """
    Alternative 2D version for simpler rendering
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # DNA representation (simplified 2D)
        dna_text = Text(
            "DNA",
            font_size=80,
            color=FIBONACCI_BLUE
        ).shift(LEFT*3)

        # Create stylized helix using sine waves
        helix_group = self.create_2d_helix()
        helix_group.shift(LEFT*0.5)

        # Measurements
        brace_height = Brace(
            Line(UP*2, DOWN*2).shift(RIGHT*2),
            direction=RIGHT,
            color=FIBONACCI_BLUE
        )
        height_label = MathTex(r"34 \text{ \AA}", font_size=BODY_SIZE).next_to(brace_height, RIGHT)

        brace_width = Brace(
            Line(LEFT*1, RIGHT*1).shift(DOWN*2.5),
            direction=DOWN,
            color=WARM_ORANGE
        )
        width_label = MathTex(r"21 \text{ \AA}", font_size=BODY_SIZE).next_to(brace_width, DOWN)

        # Ratio calculation
        ratio_group = VGroup(
            MathTex(r"\frac{34}{21}", font_size=48),
            MathTex(r"= 1.619...", font_size=48),
            MathTex(r"\approx \phi", font_size=56, color=GOLDEN_YELLOW)
        ).arrange(RIGHT, buff=0.3).shift(RIGHT*3)

        # Fibonacci sequence at bottom
        fib_seq = MathTex(
            r"1, 1, 2, 3, 5, 8, 13, \mathbf{21}, \mathbf{34}...",
            font_size=36,
            color=CREAM_WHITE
        ).to_edge(DOWN, buff=0.5)

        # Animations
        self.play(Write(dna_text), run_time=1)
        self.play(Create(helix_group), run_time=2)
        self.wait(1)

        self.play(
            GrowFromCenter(brace_height),
            Write(height_label),
            run_time=1
        )
        self.play(
            GrowFromCenter(brace_width),
            Write(width_label),
            run_time=1
        )
        self.wait(1)

        self.play(
            LaggedStart(*[Write(r) for r in ratio_group], lag_ratio=0.5),
            run_time=2
        )
        self.play(Circumscribe(ratio_group[-1], color=GOLDEN_YELLOW))
        self.wait(1)

        self.play(Write(fib_seq), run_time=1.5)
        self.wait(1)

    def create_2d_helix(self):
        """Create 2D representation of DNA helix"""
        wave1 = ParametricFunction(
            lambda t: np.array([t, 0.5*np.sin(2*t), 0]),
            t_range=[-2, 2],
            color=FIBONACCI_BLUE,
            stroke_width=4
        )
        wave2 = ParametricFunction(
            lambda t: np.array([t, 0.5*np.sin(2*t + PI), 0]),
            t_range=[-2, 2],
            color=WARM_ORANGE,
            stroke_width=4
        )

        # Connections
        connections = VGroup()
        for x in np.linspace(-2, 2, 10):
            y1 = 0.5*np.sin(2*x)
            y2 = 0.5*np.sin(2*x + PI)
            line = Line([x, y1, 0], [x, y2, 0], color=NATURE_GREEN, stroke_width=2)
            connections.add(line)

        return VGroup(wave1, wave2, connections)
