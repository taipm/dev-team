"""
Scene 03: The Pattern Emerges - F(n) = F(n-1) + F(n-2)
Duration: 90 seconds
Purpose: Reveal the recurrence relation
"""

from manim import *
import numpy as np
from config import *

class Scene03_Pattern(Scene):
    """
    Pattern emergence: F(n) = F(n-1) + F(n-2)

    Visual elements:
    1. Number sequence with colored boxes
    2. Arrows showing addition pattern
    3. Recurrence formula reveal
    4. Interactive demonstration
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Quy luat an giau",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=CREAM_WHITE
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Create Fibonacci boxes
        fib_numbers = [1, 1, 2, 3, 5, 8, 13, 21, 34]
        boxes = self.create_fib_boxes(fib_numbers)
        boxes.to_edge(UP, buff=2)

        # Show boxes appearing
        self.play(
            LaggedStart(
                *[FadeIn(box, shift=UP) for box in boxes],
                lag_ratio=0.15
            ),
            run_time=2
        )
        self.wait(1)

        # Show addition pattern
        self.show_addition_pattern(boxes, fib_numbers)

        # Reveal formula
        self.reveal_formula()

        self.wait(2)

    def create_fib_boxes(self, numbers):
        """Create numbered boxes for Fibonacci sequence"""
        boxes = VGroup()

        for i, num in enumerate(numbers):
            # Box
            box = Square(
                side_length=0.9,
                color=FIBONACCI_BLUE,
                stroke_width=2
            )

            # Number inside
            num_text = MathTex(
                str(num),
                font_size=LABEL_SIZE,
                color=CREAM_WHITE
            )

            # Index below
            index_text = MathTex(
                f"F_{{{i+1}}}",
                font_size=SMALL_SIZE,
                color=GRAY
            ).next_to(box, DOWN, buff=0.1)

            box_group = VGroup(box, num_text, index_text)
            boxes.add(box_group)

        boxes.arrange(RIGHT, buff=0.15)
        return boxes

    def show_addition_pattern(self, boxes, numbers):
        """Animate the addition pattern"""
        # Question text
        question = Text(
            "Moi so = ?",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).shift(DOWN*0.5)

        self.play(Write(question), run_time=1)
        self.wait(1)

        # Show arrows for first few additions
        for i in range(2, min(7, len(boxes))):
            # Get the three boxes involved
            box1 = boxes[i-2]
            box2 = boxes[i-1]
            box3 = boxes[i]

            # Create arrows
            arrow1 = CurvedArrow(
                box1[0].get_bottom(),
                box3[0].get_top(),
                color=FIBONACCI_BLUE,
                angle=-TAU/6
            )
            arrow2 = CurvedArrow(
                box2[0].get_bottom(),
                box3[0].get_top(),
                color=WARM_ORANGE,
                angle=-TAU/8
            )

            # Plus sign
            plus = MathTex("+", font_size=LABEL_SIZE, color=CREAM_WHITE)
            plus.move_to((box1[0].get_center() + box2[0].get_center()) / 2 + DOWN*0.3)

            # Highlight boxes
            self.play(
                box1[0].animate.set_fill(FIBONACCI_BLUE, opacity=0.5),
                box2[0].animate.set_fill(WARM_ORANGE, opacity=0.5),
                Create(arrow1),
                Create(arrow2),
                Write(plus),
                run_time=0.7
            )

            # Result highlight
            self.play(
                box3[0].animate.set_fill(GOLDEN_YELLOW, opacity=0.6),
                Flash(box3[0].get_center(), color=GOLDEN_YELLOW, flash_radius=0.5),
                run_time=0.5
            )

            # Show calculation
            calc = MathTex(
                f"{numbers[i-2]} + {numbers[i-1]} = {numbers[i]}",
                font_size=SMALL_SIZE,
                color=CREAM_WHITE
            ).shift(DOWN*2)

            self.play(Write(calc), run_time=0.5)
            self.wait(0.3)

            # Reset
            self.play(
                box1[0].animate.set_fill(opacity=0),
                box2[0].animate.set_fill(opacity=0),
                box3[0].animate.set_fill(opacity=0),
                FadeOut(arrow1),
                FadeOut(arrow2),
                FadeOut(plus),
                FadeOut(calc),
                run_time=0.3
            )

        self.play(FadeOut(question))

    def reveal_formula(self):
        """Reveal the recurrence formula"""
        # Formula
        formula = MathTex(
            r"F_n = F_{n-1} + F_{n-2}",
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        ).shift(DOWN*1.5)

        # Words
        explanation = Text(
            "Moi so = tong 2 so truoc",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).next_to(formula, DOWN, buff=0.5)

        # Box around formula
        formula_box = SurroundingRectangle(
            formula,
            color=GOLDEN_YELLOW,
            buff=0.3,
            stroke_width=3
        )

        # Animation
        self.play(Write(formula), run_time=2)
        self.play(Create(formula_box), run_time=1)
        self.play(Write(explanation), run_time=1.5)

        # Emphasize
        self.play(
            Indicate(formula, color=GOLDEN_YELLOW, scale_factor=1.1),
            run_time=1
        )


class Scene03_Pattern_Visual(Scene):
    """
    More visual version with growing sequence animation
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Start with just two 1s
        nums = [1, 1]
        display = VGroup()

        for n in nums:
            circle = Circle(
                radius=0.4,
                color=FIBONACCI_BLUE,
                fill_opacity=0.3
            )
            text = MathTex(str(n), font_size=BODY_SIZE)
            display.add(VGroup(circle, text))

        display.arrange(RIGHT, buff=0.5)
        self.play(FadeIn(display), run_time=1)

        # Grow the sequence
        for i in range(7):
            new_num = nums[-1] + nums[-2]
            nums.append(new_num)

            # New circle
            new_circle = Circle(
                radius=0.4,
                color=GOLDEN_YELLOW,
                fill_opacity=0.3
            )
            new_text = MathTex(str(new_num), font_size=BODY_SIZE)
            new_group = VGroup(new_circle, new_text)

            # Position
            new_group.next_to(display, RIGHT, buff=0.5)

            # Arrow from last two
            arrow = Arrow(
                display[-2:].get_center() + DOWN*0.5,
                new_group.get_center() + DOWN*0.5,
                color=NATURE_GREEN,
                stroke_width=2
            )

            self.play(
                GrowFromCenter(new_group),
                Create(arrow),
                run_time=0.6
            )

            display.add(new_group)

            # Rescale if too wide
            if display.width > 12:
                self.play(display.animate.scale(0.85).center(), run_time=0.3)

            self.play(FadeOut(arrow), run_time=0.2)

        self.wait(2)
