"""
Scene 06: Nature's Hidden Code
Duration: 120 seconds
Purpose: Show Fibonacci in nature - sunflower, honeybee, pinecone, DNA
"""

from manim import *
import numpy as np
from config import *

class Scene06_Nature(Scene):
    """
    Fibonacci in nature: sunflower, honeybee, pinecone, DNA

    Visual elements:
    1. Sunflower seed arrangement (55, 89 spirals)
    2. Honeybee family tree
    3. Pinecone spiral counting
    4. DNA measurements recap
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Title
        title = Text(
            "Ma so cua tu nhien",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=NATURE_GREEN
        ).to_edge(UP)

        self.play(Write(title), run_time=1)
        self.wait(0.5)

        # Section 1: Sunflower
        self.sunflower_section()

        # Section 2: Honeybee
        self.honeybee_section()

        # Section 3: Nature summary
        self.nature_summary()

    def sunflower_section(self):
        """Sunflower seed spiral visualization"""
        # Create phyllotaxis pattern
        n_seeds = 300
        seeds = VGroup()

        # Golden angle in radians
        golden_angle = PI * (3 - np.sqrt(5))  # ~137.5 degrees

        for i in range(n_seeds):
            r = np.sqrt(i) * 0.12
            theta = i * golden_angle
            x = r * np.cos(theta)
            y = r * np.sin(theta)

            # Color based on position
            if i % 2 == 0:
                color = GOLDEN_YELLOW
            else:
                color = WARM_ORANGE

            seed = Dot(
                point=[x, y, 0],
                radius=0.03 + 0.01 * (i / n_seeds),
                color=color,
                fill_opacity=0.9
            )
            seeds.add(seed)

        seeds.move_to(ORIGIN + DOWN*0.5)

        # Label
        sunflower_label = Text(
            "Hoa huong duong",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP, buff=1.5)

        # Count spirals text
        spiral_count = VGroup(
            MathTex(r"55", font_size=BODY_SIZE, color=FIBONACCI_BLUE),
            Text(" xoan oc", font=VN_FONT, font_size=LABEL_SIZE),
            Text(" + ", font_size=LABEL_SIZE),
            MathTex(r"89", font_size=BODY_SIZE, color=WARM_ORANGE),
            Text(" xoan oc", font=VN_FONT, font_size=LABEL_SIZE),
        ).arrange(RIGHT, buff=0.1).to_edge(DOWN)

        # Animation - grow from center
        self.play(Write(sunflower_label), run_time=0.5)
        self.play(
            LaggedStart(
                *[FadeIn(seed, scale=0.5) for seed in seeds],
                lag_ratio=0.01
            ),
            run_time=4
        )

        self.play(Write(spiral_count), run_time=1)
        self.wait(1)

        # Fade out
        self.play(
            FadeOut(seeds),
            FadeOut(sunflower_label),
            FadeOut(spiral_count),
            run_time=0.5
        )

    def honeybee_section(self):
        """Honeybee family tree showing Fibonacci"""
        # Label
        bee_label = Text(
            "Cay gia pha ong mat",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP, buff=1.5)

        # Create family tree
        tree = self.create_bee_tree()
        tree.move_to(ORIGIN + DOWN*0.5)

        # Fibonacci labels on right
        fib_labels = VGroup(
            MathTex("1", font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
            MathTex("1", font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
            MathTex("2", font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
            MathTex("3", font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
            MathTex("5", font_size=LABEL_SIZE, color=GOLDEN_YELLOW),
        ).arrange(DOWN, buff=0.5).to_edge(RIGHT)

        # Animation
        self.play(Write(bee_label), run_time=0.5)
        self.play(Create(tree), run_time=2)
        self.wait(0.5)

        self.play(
            LaggedStart(*[Write(l) for l in fib_labels], lag_ratio=0.3),
            run_time=2
        )
        self.wait(1)

        # Fade out
        self.play(
            FadeOut(tree),
            FadeOut(bee_label),
            FadeOut(fib_labels),
            run_time=0.5
        )

    def create_bee_tree(self):
        """Create honeybee ancestry tree"""
        # Male bee (drone) has only 1 parent (queen)
        # Female bee (queen) has 2 parents

        tree = VGroup()

        # Generation 0: 1 male bee
        gen0 = Circle(radius=0.25, color=FIBONACCI_BLUE, fill_opacity=0.5)
        gen0_label = Text("M", font_size=SMALL_SIZE).move_to(gen0)
        gen0_group = VGroup(gen0, gen0_label)

        # Generation 1: 1 female (mother)
        gen1 = Circle(radius=0.25, color=WARM_ORANGE, fill_opacity=0.5)
        gen1_label = Text("F", font_size=SMALL_SIZE).move_to(gen1)
        gen1_group = VGroup(gen1, gen1_label).shift(UP*1)

        # Generation 2: 2 (father + mother)
        gen2 = VGroup()
        for i, (t, c) in enumerate([("M", FIBONACCI_BLUE), ("F", WARM_ORANGE)]):
            bee = Circle(radius=0.2, color=c, fill_opacity=0.5)
            label = Text(t, font_size=18).move_to(bee)
            group = VGroup(bee, label).shift(LEFT*(1-i*2) + UP*2)
            gen2.add(group)

        # Generation 3: 3 (F's parents + M's mother)
        gen3 = VGroup()
        positions = [LEFT*2, ORIGIN, RIGHT*2]
        types = [("F", WARM_ORANGE), ("M", FIBONACCI_BLUE), ("F", WARM_ORANGE)]
        for pos, (t, c) in zip(positions, types):
            bee = Circle(radius=0.18, color=c, fill_opacity=0.5)
            label = Text(t, font_size=16).move_to(bee)
            group = VGroup(bee, label).shift(pos + UP*3)
            gen3.add(group)

        # Generation 4: 5
        gen4 = VGroup()
        for i in range(5):
            c = WARM_ORANGE if i % 2 == 0 else FIBONACCI_BLUE
            bee = Circle(radius=0.15, color=c, fill_opacity=0.5)
            bee.shift(LEFT*2 + RIGHT*i + UP*4)
            gen4.add(bee)

        # Lines connecting
        lines = VGroup()
        # Gen0 to Gen1
        lines.add(Line(gen0_group.get_top(), gen1_group.get_bottom(), color=GRAY, stroke_width=1))
        # Gen1 to Gen2
        for g2 in gen2:
            lines.add(Line(gen1_group.get_top(), g2.get_bottom(), color=GRAY, stroke_width=1))

        tree.add(gen0_group, gen1_group, gen2, gen3, gen4, lines)
        tree.scale(0.8)
        return tree

    def nature_summary(self):
        """Summary of Fibonacci in nature"""
        # Summary list
        items = [
            ("Hoa huong duong:", "55, 89 xoan oc", GOLDEN_YELLOW),
            ("Qua thong:", "8, 13 xoan oc", NATURE_GREEN),
            ("Canh hoa:", "3, 5, 8, 13, 21", SPIRAL_PURPLE),
            ("ADN:", "34, 21 Angstrom", FIBONACCI_BLUE),
        ]

        summary = VGroup()
        for name, value, color in items:
            row = VGroup(
                Text(name, font=VN_FONT, font_size=LABEL_SIZE, color=CREAM_WHITE),
                Text(value, font=VN_FONT, font_size=LABEL_SIZE, color=color)
            ).arrange(RIGHT, buff=0.3)
            summary.add(row)

        summary.arrange(DOWN, aligned_edge=LEFT, buff=0.4)
        summary.move_to(ORIGIN)

        # Title
        title = Text(
            "Fibonacci o khap noi!",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(UP, buff=1.5)

        # Animation
        self.play(Write(title), run_time=0.5)

        for row in summary:
            self.play(Write(row), run_time=0.6)
            self.wait(0.2)

        # Emphasis box
        box = SurroundingRectangle(summary, color=GOLDEN_YELLOW, buff=0.3)
        self.play(Create(box), run_time=0.5)

        self.wait(2)


class Scene06_Phyllotaxis(Scene):
    """
    Pure phyllotaxis animation showing seed arrangement
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        title = Text(
            "Phyllotaxis - Sap xep la cay",
            font=VN_FONT,
            font_size=BODY_SIZE,
            color=NATURE_GREEN
        ).to_edge(UP)

        self.play(Write(title), run_time=1)

        # Golden angle
        golden_angle = 137.5 * DEGREES

        # Create seeds one by one
        seeds = VGroup()
        n_seeds = 200

        for i in range(n_seeds):
            angle = i * golden_angle
            r = 0.12 * np.sqrt(i)

            x = r * np.cos(angle)
            y = r * np.sin(angle)

            # Color gradient
            hue = (i / n_seeds) * 0.15 + 0.08  # Yellow-orange range
            color = ManimColor.from_hsv((hue, 0.8, 1.0))

            seed = Dot(point=[x, y, 0], radius=0.04, color=color)
            seeds.add(seed)

        seeds.shift(DOWN*0.5)

        # Animate seeds appearing
        self.play(
            LaggedStart(
                *[GrowFromCenter(seed) for seed in seeds],
                lag_ratio=0.02
            ),
            run_time=5
        )

        # Show the angle
        angle_label = MathTex(
            r"\theta = 137.5° = 360°/\phi^2",
            font_size=LABEL_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(DOWN)

        self.play(Write(angle_label), run_time=1)
        self.wait(2)
