"""
Scene 02: Origin Story - Leonardo Fibonacci and the Rabbit Problem
Duration: 120 seconds
Purpose: Tell the origin story of Fibonacci sequence
"""

from manim import *
import numpy as np
from config import *

class Scene02_Origin(Scene):
    """
    Origin story: Leonardo Fibonacci and rabbit problem

    Visual elements:
    1. Title and year (1202, Medieval Italy)
    2. Rabbit breeding diagram
    3. Month-by-month population growth
    4. Number sequence emergence: 1, 1, 2, 3, 5, 8...
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Part 1: Introduction (0:30-0:50)
        self.intro_section()

        # Part 2: Rabbit Problem (0:50-1:30)
        self.rabbit_problem_section()

        # Part 3: Sequence Reveal (1:30-2:30)
        self.sequence_reveal_section()

    def intro_section(self):
        """Introduction to Fibonacci"""
        # Title
        title = Text(
            "Leonardo xứ Pisa",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=CREAM_WHITE
        )

        subtitle = Text(
            '"Fibonacci"',
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW,
            slant=ITALIC
        ).next_to(title, DOWN, buff=0.3)

        year = Text(
            "1202",
            font_size=72,
            color=SPIRAL_PURPLE
        ).next_to(subtitle, DOWN, buff=0.5)

        title_group = VGroup(title, subtitle, year)

        # Animation
        self.play(Write(title), run_time=1.5)
        self.play(Write(subtitle), run_time=1)
        self.play(Write(year), run_time=1)
        self.wait(2)

        self.play(
            title_group.animate.scale(0.5).to_corner(UL),
            run_time=1
        )

    def rabbit_problem_section(self):
        """The famous rabbit breeding problem"""
        # Problem statement
        problem_text = Text(
            "Bai toan nuoi tho:",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=CREAM_WHITE
        ).to_edge(UP, buff=1)

        # Create rabbit breeding diagram
        diagram = self.create_rabbit_diagram()
        diagram.scale(0.7).shift(DOWN*0.5)

        # Animation
        self.play(Write(problem_text), run_time=1)
        self.wait(1)

        # Show diagram month by month
        months = diagram[0]  # VGroup of month rows
        for i, month in enumerate(months):
            if i < 6:
                self.play(FadeIn(month, shift=RIGHT), run_time=0.8)
                self.wait(0.3)

        self.wait(2)

        # Keep diagram visible but smaller
        self.play(
            FadeOut(problem_text),
            diagram.animate.scale(0.6).to_edge(LEFT),
            run_time=1
        )

    def sequence_reveal_section(self):
        """Reveal the Fibonacci sequence"""
        # Count the rabbits
        counts = [1, 1, 2, 3, 5, 8, 13, 21]
        count_group = VGroup()

        for i, count in enumerate(counts):
            count_text = MathTex(
                str(count),
                font_size=TITLE_SIZE,
                color=GOLDEN_YELLOW if i < 6 else CREAM_WHITE
            )
            count_group.add(count_text)

        count_group.arrange(RIGHT, buff=0.5).shift(RIGHT*2)

        # Show counts one by one
        for i, count_mob in enumerate(count_group[:6]):
            self.play(Write(count_mob), run_time=0.5)
            self.wait(0.3)

        # Pattern discovery
        pattern_text = Text(
            "Day so Fibonacci!",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).next_to(count_group, DOWN, buff=0.8)

        self.play(
            Write(count_group[6:]),
            run_time=1
        )
        self.wait(0.5)

        # Reveal pattern
        self.play(
            Write(pattern_text),
            Circumscribe(count_group, color=GOLDEN_YELLOW),
            run_time=1.5
        )

        # Full sequence
        full_seq = MathTex(
            r"1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89...",
            font_size=BODY_SIZE
        ).to_edge(DOWN)

        self.play(
            Transform(count_group, full_seq),
            FadeOut(pattern_text),
            run_time=1.5
        )
        self.wait(2)

    def create_rabbit_diagram(self):
        """Create visual rabbit breeding diagram"""
        months = VGroup()
        rabbit_counts = [1, 1, 2, 3, 5, 8]

        for i, count in enumerate(rabbit_counts):
            # Month label
            month_label = Text(
                f"Thang {i+1}:",
                font=VN_FONT,
                font_size=SMALL_SIZE,
                color=FIBONACCI_BLUE
            )

            # Rabbit icons (simplified as circles)
            rabbits = VGroup()
            for j in range(min(count, 8)):
                # Adult rabbit (larger)
                if j < (count // 2 if i > 0 else 1):
                    rabbit = Circle(
                        radius=0.15,
                        fill_opacity=1,
                        fill_color=WARM_ORANGE,
                        color=WARM_ORANGE
                    )
                # Baby rabbit (smaller)
                else:
                    rabbit = Circle(
                        radius=0.1,
                        fill_opacity=0.7,
                        fill_color=NATURE_GREEN,
                        color=NATURE_GREEN
                    )
                rabbits.add(rabbit)

            if count > 8:
                dots = Text("...", font_size=SMALL_SIZE)
                rabbits.add(dots)

            rabbits.arrange(RIGHT, buff=0.1)

            # Count
            count_text = MathTex(
                f"= {count}",
                font_size=LABEL_SIZE,
                color=GOLDEN_YELLOW
            )

            row = VGroup(month_label, rabbits, count_text).arrange(RIGHT, buff=0.5)
            months.add(row)

        months.arrange(DOWN, aligned_edge=LEFT, buff=0.3)
        return VGroup(months)


class Scene02_Origin_Extended(Scene):
    """
    Extended version with more details about Fibonacci's life
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Map of Mediterranean (conceptual)
        title = Text(
            "Liber Abaci (1202)",
            font_size=48,
            color=GOLDEN_YELLOW
        ).to_edge(UP)

        # Book representation
        book = Rectangle(
            width=3, height=4,
            color=WARM_ORANGE,
            fill_opacity=0.3
        )
        book_title = Text(
            "Liber\nAbaci",
            font_size=LABEL_SIZE,
            color=CREAM_WHITE
        ).move_to(book)
        book_group = VGroup(book, book_title).shift(LEFT*3)

        # Key contributions
        contributions = VGroup(
            Text("1. Gioi thieu so Hindu-Arabic", font_size=SMALL_SIZE),
            Text("2. Bai toan nuoi tho", font_size=SMALL_SIZE, color=GOLDEN_YELLOW),
            Text("3. Ung dung thuong mai", font_size=SMALL_SIZE),
        ).arrange(DOWN, aligned_edge=LEFT).shift(RIGHT*2)

        # Animation
        self.play(Write(title), run_time=1)
        self.play(FadeIn(book_group), run_time=1)
        self.wait(1)

        for contrib in contributions:
            self.play(Write(contrib), run_time=0.8)
            self.wait(0.5)

        self.wait(2)
