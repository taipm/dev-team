"""
Scene 05: Spirals - From Math to Art
Duration: 90 seconds
Purpose: Build the Fibonacci spiral step by step
"""

from manim import *
import numpy as np
from config import *

class Scene05_Spirals(Scene):
    """
    Fibonacci spiral construction

    Visual elements:
    1. Build Fibonacci squares
    2. Draw quarter circles (arcs)
    3. Complete golden spiral
    4. Compare to nature
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Xoan oc Fibonacci",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=SPIRAL_PURPLE
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Build the spiral
        self.build_fibonacci_squares()

        self.wait(2)

    def build_fibonacci_squares(self):
        """Build squares and spiral step by step"""
        # Fibonacci sizes
        fib_sizes = [1, 1, 2, 3, 5, 8]
        scale_factor = 0.35

        # Colors for each square
        colors = [FIBONACCI_BLUE, NATURE_GREEN, WARM_ORANGE, SPIRAL_PURPLE, GOLDEN_YELLOW, SOFT_RED]

        # Initialize position tracking
        squares = VGroup()
        arcs = VGroup()

        # Position and direction tracking
        current_pos = ORIGIN
        directions = [RIGHT, UP, LEFT, DOWN]  # Spiral outward

        # Build each square
        for i, size in enumerate(fib_sizes):
            scaled_size = size * scale_factor

            # Create square
            square = Square(
                side_length=scaled_size,
                color=colors[i % len(colors)],
                fill_opacity=0.2,
                stroke_width=2
            )

            # Calculate position based on previous squares
            if i == 0:
                square.move_to(ORIGIN)
            elif i == 1:
                square.next_to(squares[0], RIGHT, buff=0)
            elif i == 2:
                square.next_to(VGroup(squares[0], squares[1]), UP, buff=0)
                square.align_to(squares[0], LEFT)
            elif i == 3:
                square.next_to(squares[2], LEFT, buff=0)
                square.align_to(squares[2], UP)
            elif i == 4:
                square.next_to(squares[3], DOWN, buff=0)
                square.align_to(squares[3], LEFT)
            elif i == 5:
                square.next_to(squares[4], RIGHT, buff=0)
                square.align_to(squares[4], DOWN)

            # Size label
            label = MathTex(
                str(size),
                font_size=SMALL_SIZE,
                color=CREAM_WHITE
            ).move_to(square)

            square_group = VGroup(square, label)
            squares.add(square_group)

            # Create arc for spiral
            arc = self.create_arc_for_square(square, i)
            arcs.add(arc)

        # Center the entire construction
        full_group = VGroup(squares, arcs)
        full_group.move_to(ORIGIN + DOWN*0.5)

        # Animation: build squares one by one with arcs
        for i in range(len(fib_sizes)):
            # Show square
            self.play(
                FadeIn(squares[i][0], shift=directions[i % 4] * 0.3),
                Write(squares[i][1]),
                run_time=0.8
            )
            self.wait(0.2)

            # Draw arc
            self.play(Create(arcs[i]), run_time=0.6)
            self.wait(0.2)

        self.wait(1)

        # Highlight the spiral
        spiral = arcs.copy()
        spiral.set_color(GOLDEN_YELLOW)
        spiral.set_stroke(width=4)

        self.play(
            Create(spiral),
            run_time=2
        )

        # Label
        spiral_label = Text(
            "Xoan oc Vang",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(DOWN)

        self.play(Write(spiral_label), run_time=1)

    def create_arc_for_square(self, square, index):
        """Create quarter circle arc for a square"""
        size = square.width

        # Arc start angles based on direction
        start_angles = [0, PI/2, PI, 3*PI/2]
        start_angle = start_angles[index % 4]

        # Arc center is at one corner of the square
        corners = [
            square.get_corner(DL),  # 0
            square.get_corner(DR),  # 1
            square.get_corner(UR),  # 2
            square.get_corner(UL),  # 3
        ]
        arc_center = corners[index % 4]

        arc = Arc(
            radius=size,
            start_angle=start_angle,
            angle=PI/2,
            arc_center=arc_center,
            color=SPIRAL_PURPLE,
            stroke_width=3
        )

        return arc


class Scene05_GoldenSpiral(Scene):
    """
    True Golden Spiral using parametric equation
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Xoan oc Logarit Vang",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Create true golden spiral (logarithmic)
        # r = a * e^(b*theta), where b = ln(phi) / (pi/2)
        b = np.log(PHI) / (PI/2)

        spiral = ParametricFunction(
            lambda t: np.array([
                0.1 * np.exp(b * t) * np.cos(t),
                0.1 * np.exp(b * t) * np.sin(t),
                0
            ]),
            t_range=[-4*PI, 2*PI],
            color=GOLDEN_YELLOW,
            stroke_width=3
        )

        # Draw the spiral
        self.play(Create(spiral), run_time=4, rate_func=linear)
        self.wait(1)

        # Formula
        formula = MathTex(
            r"r = a \cdot e^{b\theta}",
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).to_edge(DOWN)

        self.play(Write(formula), run_time=1)
        self.wait(2)


class Scene05_NatureComparison(Scene):
    """
    Compare Fibonacci spiral to natural examples
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Spiral on left
        spiral = self.create_fibonacci_spiral().scale(0.8).shift(LEFT*3)

        # Nature examples on right (text placeholders)
        examples = VGroup(
            Text("Vo oc", font=VN_FONT, font_size=LABEL_SIZE),
            Text("Thien ha", font=VN_FONT, font_size=LABEL_SIZE),
            Text("Bao", font=VN_FONT, font_size=LABEL_SIZE),
        ).arrange(DOWN, buff=0.5).shift(RIGHT*3)

        # Animation
        self.play(Create(spiral), run_time=2)
        self.wait(0.5)

        for example in examples:
            self.play(Write(example), run_time=0.5)
            self.wait(0.3)

        # Connection lines
        for example in examples:
            arrow = Arrow(
                spiral.get_right(),
                example.get_left(),
                color=GOLDEN_YELLOW,
                stroke_width=2
            )
            self.play(Create(arrow), run_time=0.3)

        self.wait(2)

    def create_fibonacci_spiral(self):
        """Create simplified Fibonacci spiral"""
        b = np.log(PHI) / (PI/2)
        spiral = ParametricFunction(
            lambda t: np.array([
                0.15 * np.exp(b * t) * np.cos(t),
                0.15 * np.exp(b * t) * np.sin(t),
                0
            ]),
            t_range=[-3*PI, 1.5*PI],
            color=SPIRAL_PURPLE,
            stroke_width=4
        )
        return spiral
