"""
Scene 09: Outro - End Card
Duration: 30 seconds
Purpose: Thank viewers, call to action, tease next video
"""

from manim import *
import numpy as np
from config import *

class Scene09_Outro(Scene):
    """
    Outro - End card

    Visual elements:
    1. Thank you message
    2. Subscribe button animation
    3. Fibonacci sequence fading
    4. Teaser for next video
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Background spiral (faint)
        bg_spiral = self.create_spiral()
        bg_spiral.scale(3).set_opacity(0.1).set_color(GOLDEN_YELLOW)
        self.add(bg_spiral)

        # Thank you message
        thanks = Text(
            "Cam on ban da xem!",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=CREAM_WHITE
        )

        self.play(Write(thanks), run_time=1.5)
        self.wait(1)

        # Move thanks up
        self.play(thanks.animate.shift(UP*2), run_time=0.5)

        # Subscribe CTA
        subscribe_box = RoundedRectangle(
            width=4,
            height=1,
            corner_radius=0.2,
            color=SOFT_RED,
            fill_opacity=0.9
        )
        subscribe_text = Text(
            "SUBSCRIBE",
            font_size=BODY_SIZE,
            color=CREAM_WHITE,
            weight=BOLD
        ).move_to(subscribe_box)
        subscribe_group = VGroup(subscribe_box, subscribe_text)

        bell_hint = Text(
            "Nhan chuong de theo doi",
            font=VN_FONT,
            font_size=LABEL_SIZE,
            color=GRAY
        ).next_to(subscribe_group, DOWN, buff=0.3)

        self.play(
            FadeIn(subscribe_group, shift=UP),
            run_time=0.8
        )
        self.play(
            subscribe_group.animate.scale(1.1),
            run_time=0.3
        )
        self.play(
            subscribe_group.animate.scale(1/1.1),
            run_time=0.2
        )
        self.play(Write(bell_hint), run_time=0.5)

        self.wait(1)

        # Move CTA down
        self.play(
            VGroup(subscribe_group, bell_hint).animate.shift(DOWN*0.5),
            run_time=0.5
        )

        # Fibonacci sequence flowing
        fib_seq = MathTex(
            r"1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89...",
            font_size=LABEL_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(DOWN, buff=0.8)

        self.play(Write(fib_seq), run_time=1.5)

        # Teaser for next video
        next_video = Text(
            "Video tiep theo: Bi an so nguyen to",
            font=VN_FONT,
            font_size=SMALL_SIZE,
            color=SPIRAL_PURPLE
        ).to_edge(UP, buff=0.5)

        self.play(FadeIn(next_video, shift=DOWN), run_time=0.8)

        self.wait(2)

        # Final fade
        self.play(
            *[FadeOut(mob) for mob in self.mobjects if mob != bg_spiral],
            run_time=1.5
        )

        # End with spiral
        self.play(
            bg_spiral.animate.set_opacity(0.3).scale(1.2),
            run_time=1
        )
        self.wait(1)

    def create_spiral(self):
        """Create golden spiral"""
        b = np.log(PHI) / (PI/2)
        spiral = ParametricFunction(
            lambda t: np.array([
                0.1 * np.exp(b * t) * np.cos(t),
                0.1 * np.exp(b * t) * np.sin(t),
                0
            ]),
            t_range=[-4*PI, 2*PI],
            color=GOLDEN_YELLOW,
            stroke_width=2
        )
        return spiral


class Scene09_EndCard(Scene):
    """
    Alternative end card with more visual elements
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Create end card layout
        # Left: Channel info
        # Right: Recommended videos

        # Channel logo placeholder
        logo_circle = Circle(
            radius=0.8,
            color=GOLDEN_YELLOW,
            fill_opacity=0.3
        ).shift(LEFT*4 + UP*1)
        logo_text = MathTex(r"\phi", font_size=72, color=GOLDEN_YELLOW).move_to(logo_circle)

        channel_name = Text(
            "Math & Nature",
            font_size=LABEL_SIZE,
            color=CREAM_WHITE
        ).next_to(logo_circle, DOWN)

        # Subscribe button
        sub_btn = RoundedRectangle(
            width=2.5, height=0.6,
            corner_radius=0.1,
            color=SOFT_RED,
            fill_opacity=1
        ).next_to(channel_name, DOWN, buff=0.3)
        sub_text = Text(
            "DANG KY",
            font_size=SMALL_SIZE,
            color=CREAM_WHITE
        ).move_to(sub_btn)

        left_group = VGroup(logo_circle, logo_text, channel_name, sub_btn, sub_text)

        # Right: Video recommendations
        rec1 = self.create_video_rec("So nguyen to", UP*1)
        rec2 = self.create_video_rec("So Pi", DOWN*1)

        right_group = VGroup(rec1, rec2).shift(RIGHT*3)

        # Animations
        self.play(
            FadeIn(left_group),
            FadeIn(right_group),
            run_time=1.5
        )

        # Pulse subscribe
        self.play(
            sub_btn.animate.scale(1.1),
            run_time=0.3
        )
        self.play(
            sub_btn.animate.scale(1/1.1),
            run_time=0.2
        )

        self.wait(3)

    def create_video_rec(self, title, position):
        """Create video recommendation thumbnail"""
        thumb = Rectangle(
            width=3, height=1.7,
            color=FIBONACCI_BLUE,
            fill_opacity=0.3
        ).move_to(position)

        title_text = Text(
            title,
            font=VN_FONT,
            font_size=SMALL_SIZE,
            color=CREAM_WHITE
        ).move_to(thumb)

        play_btn = Triangle(
            color=CREAM_WHITE,
            fill_opacity=0.8
        ).scale(0.3).move_to(thumb).rotate(-PI/2)

        return VGroup(thumb, title_text, play_btn)


class Scene09_FibonacciEnding(Scene):
    """
    Artistic ending with Fibonacci sequence animation
    """

    def construct(self):
        self.camera.background_color = DARK_BG

        # Fibonacci numbers appearing in spiral pattern
        fib = fibonacci(15)

        numbers = VGroup()
        golden_angle = 137.5 * DEGREES

        for i, f in enumerate(fib[:12]):
            angle = i * golden_angle
            r = 0.3 * (i + 1)

            num = MathTex(
                str(f),
                font_size=LABEL_SIZE + i*2,
                color=interpolate_color(
                    FIBONACCI_BLUE,
                    GOLDEN_YELLOW,
                    i / 11
                )
            )
            num.move_to([r * np.cos(angle), r * np.sin(angle), 0])
            numbers.add(num)

        # Animate numbers appearing in spiral
        self.play(
            LaggedStart(
                *[FadeIn(n, scale=0.5) for n in numbers],
                lag_ratio=0.15
            ),
            run_time=3
        )

        self.wait(1)

        # Spiral connecting them
        spiral = self.create_spiral()
        spiral.scale(1.5).set_stroke(width=1, opacity=0.5)

        self.play(Create(spiral), run_time=2)

        # Thank you
        thanks = Text(
            "Hen gap lai!",
            font=VN_FONT,
            font_size=TITLE_SIZE,
            color=GOLDEN_YELLOW
        ).to_edge(DOWN)

        self.play(Write(thanks), run_time=1)
        self.wait(2)

    def create_spiral(self):
        b = np.log(PHI) / (PI/2)
        return ParametricFunction(
            lambda t: np.array([
                0.08 * np.exp(b * t) * np.cos(t),
                0.08 * np.exp(b * t) * np.sin(t),
                0
            ]),
            t_range=[-2*PI, 3*PI],
            color=SPIRAL_PURPLE,
            stroke_width=2
        )
