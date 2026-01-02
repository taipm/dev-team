"""
Scene 07: Binet's Formula - The Mind-Blowing Formula
Duration: 90 seconds
Purpose: Mathematical "magic trick" - closed form formula
"""

from manim import *
import numpy as np
from config import *

class Scene07_Binet(Scene):
    """
    Binet's Formula - The mathematical magic

    Visual elements:
    1. Present the "magic" formula
    2. Step-by-step demonstration with F(10)
    3. Verification animation
    4. The "magic" of irrational to integer
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Cong thuc ky dieu cua Binet",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=SPIRAL_PURPLE
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Part 1: Introduce the formula
        self.introduce_formula()

        # Part 2: Demonstrate with example
        self.demonstrate_formula()

        self.wait(2)

    def introduce_formula(self):
        """Introduce Binet's formula with drama"""
        # Question
        question = Text(
            "Tim so Fibonacci thu 100 ma khong can tinh 99 so truoc?",
            font=VN_FONT,
            font_size=LABEL_SIZE,
            color=CREAM_WHITE
        ).shift(UP*1)

        self.play(Write(question), run_time=2)
        self.wait(1)

        # The formula (dramatic reveal)
        formula = MathTex(
            r"F_n = \frac{\phi^n - \psi^n}{\sqrt{5}}",
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        )

        self.play(
            FadeOut(question),
            Write(formula),
            run_time=2
        )

        # Dramatic effect
        self.play(
            Circumscribe(formula, color=SPIRAL_PURPLE, fade_out=True),
            run_time=1.5
        )

        # Where definitions
        where_phi = MathTex(
            r"\phi = \frac{1+\sqrt{5}}{2} \approx 1.618",
            font_size=LABEL_SIZE,
            color=GOLDEN_YELLOW
        ).shift(DOWN*1.5 + LEFT*2.5)

        where_psi = MathTex(
            r"\psi = \frac{1-\sqrt{5}}{2} \approx -0.618",
            font_size=LABEL_SIZE,
            color=FIBONACCI_BLUE
        ).shift(DOWN*1.5 + RIGHT*2.5)

        self.play(
            Write(where_phi),
            Write(where_psi),
            run_time=1.5
        )
        self.wait(1)

        # Move formula up
        self.play(
            formula.animate.to_edge(UP, buff=1.5).scale(0.8),
            FadeOut(where_phi),
            FadeOut(where_psi),
            run_time=1
        )

    def demonstrate_formula(self):
        """Demonstrate the formula with F(10)"""
        # Title
        demo_title = Text(
            "Thu voi n = 10:",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).shift(UP*0.5)

        self.play(Write(demo_title), run_time=0.5)

        # Step by step calculation
        steps = VGroup(
            MathTex(
                r"F_{10} = \frac{\phi^{10} - \psi^{10}}{\sqrt{5}}",
                font_size=LABEL_SIZE
            ),
            MathTex(
                r"= \frac{(1.618...)^{10} - (-0.618...)^{10}}{\sqrt{5}}",
                font_size=LABEL_SIZE
            ),
            MathTex(
                r"= \frac{122.9919... - 0.0081...}{2.2360...}",
                font_size=LABEL_SIZE
            ),
            MathTex(
                r"= \frac{122.9837...}{2.2360...}",
                font_size=LABEL_SIZE
            ),
        ).arrange(DOWN, buff=0.4, aligned_edge=LEFT).shift(DOWN*0.8)

        # Show steps
        for step in steps:
            self.play(Write(step), run_time=1)
            self.wait(0.5)

        # Result with emphasis
        result = MathTex(
            r"= 55",
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        ).next_to(steps, DOWN, buff=0.5)

        self.play(
            Write(result),
            Flash(result.get_center(), color=GOLDEN_YELLOW, flash_radius=0.8),
            run_time=1.5
        )

        # Verification
        verify = Text(
            "Kiem tra: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55",
            font=VN_FONT,
            font_size=SMALL_SIZE,
            color=NATURE_GREEN
        ).to_edge(DOWN, buff=0.5)

        verify_tick = MathTex(
            r"\checkmark",
            font_size=BODY_SIZE,
            color=NATURE_GREEN
        ).next_to(verify, RIGHT)

        self.play(Write(verify), run_time=1)
        self.play(Write(verify_tick), run_time=0.5)

        self.wait(1)

        # The magic explanation
        self.play(FadeOut(VGroup(steps, demo_title, result, verify, verify_tick)), run_time=0.5)

        magic_text = VGroup(
            Text("Dieu ky dieu:", font=VN_FONT, font_size=BODY_SIZE, color=CREAM_WHITE),
            Text("So vo ty + Can bac hai", font=VN_FONT, font_size=LABEL_SIZE, color=SPIRAL_PURPLE),
            MathTex(r"\rightarrow", font_size=LABEL_SIZE),
            Text("So nguyen hoan hao!", font=VN_FONT, font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
        ).arrange(DOWN, buff=0.3)

        self.play(
            LaggedStart(*[Write(m) for m in magic_text], lag_ratio=0.5),
            run_time=2
        )

        box = SurroundingRectangle(magic_text, color=GOLDEN_YELLOW)
        self.play(Create(box), run_time=0.5)


class Scene07_BinetDerivation(Scene):
    """
    Show why Binet's formula works (optional advanced scene)
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        title = Text(
            "Tai sao cong thuc Binet dung?",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=SPIRAL_PURPLE
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Characteristic equation
        char_eq = MathTex(
            r"x^2 = x + 1",
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).shift(UP*1)

        char_eq_label = Text(
            "Phuong trinh dac trung",
            font=VN_FONT,
            font_size=SMALL_SIZE,
            color=GRAY
        ).next_to(char_eq, DOWN, buff=0.2)

        self.play(Write(char_eq), Write(char_eq_label), run_time=1.5)
        self.wait(1)

        # Solutions
        solutions = MathTex(
            r"x = \frac{1 \pm \sqrt{5}}{2} = \phi, \psi",
            font_size=LABEL_SIZE
        ).shift(DOWN*0.5)

        self.play(Write(solutions), run_time=1.5)
        self.wait(1)

        # General solution
        general = MathTex(
            r"F_n = A\phi^n + B\psi^n",
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).shift(DOWN*2)

        self.play(Write(general), run_time=1)
        self.wait(1)

        # Use initial conditions
        conditions = Text(
            "Dung F(0)=0, F(1)=1 de tim A, B",
            font=VN_FONT,
            font_size=SMALL_SIZE,
            color=GRAY
        ).to_edge(DOWN)

        self.play(Write(conditions), run_time=1)
        self.wait(2)
