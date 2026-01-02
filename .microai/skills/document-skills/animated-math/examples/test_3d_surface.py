"""
Test: 3D Surface Animation
==========================
Animated 3D surface plots with camera rotation.
"""

from manim import *


class Surface3DBasic(ThreeDScene):
    """Basic 3D surface: z = sin(x) * cos(y)"""

    def construct(self):
        # 3D Axes
        axes = ThreeDAxes(
            x_range=[-3, 3, 1],
            y_range=[-3, 3, 1],
            z_range=[-1.5, 1.5, 0.5],
            x_length=6,
            y_length=6,
            z_length=4
        )

        # Surface: z = sin(x) * cos(y)
        surface = Surface(
            lambda u, v: axes.c2p(u, v, np.sin(u) * np.cos(v)),
            u_range=[-3, 3],
            v_range=[-3, 3],
            resolution=(30, 30)
        )
        surface.set_fill_by_value(
            axes=axes,
            colorscale=[(BLUE, -1), (GREEN, 0), (YELLOW, 1)],
            axis=2
        )

        # Labels
        title = Text("z = sin(x)·cos(y)", font_size=36)
        title.to_corner(UL)

        # Camera setup
        self.set_camera_orientation(phi=60 * DEGREES, theta=-45 * DEGREES)

        # Animations
        self.add_fixed_in_frame_mobjects(title)
        self.play(Write(title))
        self.play(Create(axes), run_time=1)
        self.play(Create(surface), run_time=2)

        # Rotate camera
        self.begin_ambient_camera_rotation(rate=0.3)
        self.wait(6)
        self.stop_ambient_camera_rotation()


class Paraboloid3D(ThreeDScene):
    """3D Paraboloid: z = x² + y²"""

    def construct(self):
        axes = ThreeDAxes(
            x_range=[-2, 2, 1],
            y_range=[-2, 2, 1],
            z_range=[0, 4, 1],
            x_length=5,
            y_length=5,
            z_length=4
        )

        # Paraboloid surface
        surface = Surface(
            lambda u, v: axes.c2p(u, v, u**2 + v**2),
            u_range=[-1.5, 1.5],
            v_range=[-1.5, 1.5],
            resolution=(25, 25)
        )
        surface.set_fill_by_value(
            axes=axes,
            colorscale=[(BLUE, 0), (PURPLE, 2), (RED, 4)],
            axis=2
        )

        # Formula
        formula = MathTex(r"z = x^2 + y^2", font_size=42)
        formula.to_corner(UL)

        self.set_camera_orientation(phi=70 * DEGREES, theta=-60 * DEGREES)

        self.add_fixed_in_frame_mobjects(formula)
        self.play(Write(formula))
        self.play(Create(axes), run_time=1)
        self.play(Create(surface), run_time=2)

        # Camera motion
        self.begin_ambient_camera_rotation(rate=0.25)
        self.wait(5)


class Saddle3D(ThreeDScene):
    """Saddle surface (hyperbolic paraboloid): z = x² - y²"""

    def construct(self):
        axes = ThreeDAxes(
            x_range=[-2, 2, 1],
            y_range=[-2, 2, 1],
            z_range=[-2, 2, 1],
            x_length=5,
            y_length=5,
            z_length=4
        )

        # Saddle surface
        surface = Surface(
            lambda u, v: axes.c2p(u, v, u**2 - v**2),
            u_range=[-1.5, 1.5],
            v_range=[-1.5, 1.5],
            resolution=(25, 25)
        )
        surface.set_fill_by_value(
            axes=axes,
            colorscale=[(BLUE, -2), (WHITE, 0), (RED, 2)],
            axis=2
        )

        # Formula
        formula = MathTex(r"z = x^2 - y^2", font_size=42)
        formula.to_corner(UL)

        subtitle = Text("(Mặt yên ngựa)", font_size=24)
        subtitle.next_to(formula, DOWN, aligned_edge=LEFT)

        self.set_camera_orientation(phi=65 * DEGREES, theta=-45 * DEGREES)

        self.add_fixed_in_frame_mobjects(formula, subtitle)
        self.play(Write(formula), Write(subtitle))
        self.play(Create(axes), run_time=1)
        self.play(Create(surface), run_time=2)

        self.begin_ambient_camera_rotation(rate=0.3)
        self.wait(5)


class Sphere3D(ThreeDScene):
    """3D Sphere with parametric surface"""

    def construct(self):
        axes = ThreeDAxes(
            x_range=[-2, 2],
            y_range=[-2, 2],
            z_range=[-2, 2],
            x_length=5,
            y_length=5,
            z_length=5
        )

        # Sphere using parametric form
        # x = r*sin(phi)*cos(theta)
        # y = r*sin(phi)*sin(theta)
        # z = r*cos(phi)
        r = 1.5
        sphere = Surface(
            lambda u, v: axes.c2p(
                r * np.sin(u) * np.cos(v),
                r * np.sin(u) * np.sin(v),
                r * np.cos(u)
            ),
            u_range=[0, PI],
            v_range=[0, TAU],
            resolution=(30, 40)
        )
        sphere.set_color_by_gradient(BLUE, TEAL, GREEN)

        # Formula
        formula = MathTex(r"x^2 + y^2 + z^2 = r^2", font_size=36)
        formula.to_corner(UL)

        self.set_camera_orientation(phi=70 * DEGREES, theta=-45 * DEGREES)

        self.add_fixed_in_frame_mobjects(formula)
        self.play(Write(formula))
        self.play(Create(axes), run_time=1)
        self.play(Create(sphere), run_time=2)

        self.begin_ambient_camera_rotation(rate=0.2)
        self.wait(6)


class Helix3D(ThreeDScene):
    """3D Helix (đường xoắn ốc)"""

    def construct(self):
        axes = ThreeDAxes(
            x_range=[-2, 2],
            y_range=[-2, 2],
            z_range=[0, 6],
            x_length=4,
            y_length=4,
            z_length=6
        )

        # Helix: x=cos(t), y=sin(t), z=t/2
        helix = ParametricFunction(
            lambda t: axes.c2p(np.cos(t), np.sin(t), t / 2),
            t_range=[0, 4 * PI],
            color=YELLOW
        ).set_stroke(width=4)

        # Title
        title = Text("Đường xoắn ốc (Helix)", font_size=36)
        title.to_corner(UL)

        formula = MathTex(
            r"\vec{r}(t) = (\cos t, \sin t, \frac{t}{2})",
            font_size=32
        )
        formula.next_to(title, DOWN, aligned_edge=LEFT)

        self.set_camera_orientation(phi=70 * DEGREES, theta=-60 * DEGREES)

        self.add_fixed_in_frame_mobjects(title, formula)
        self.play(Write(title), Write(formula))
        self.play(Create(axes), run_time=1)
        self.play(Create(helix), run_time=3)

        self.begin_ambient_camera_rotation(rate=0.25)
        self.wait(5)


class AnimatedSurface(ThreeDScene):
    """Surface with animated parameter"""

    def construct(self):
        axes = ThreeDAxes(
            x_range=[-3, 3],
            y_range=[-3, 3],
            z_range=[-2, 2],
            x_length=6,
            y_length=6,
            z_length=4
        )

        # Amplitude tracker
        amp = ValueTracker(0.5)

        # Surface that updates with amplitude
        surface = always_redraw(
            lambda: Surface(
                lambda u, v: axes.c2p(
                    u, v,
                    amp.get_value() * np.sin(u) * np.cos(v)
                ),
                u_range=[-3, 3],
                v_range=[-3, 3],
                resolution=(25, 25)
            ).set_fill_by_value(
                axes=axes,
                colorscale=[(BLUE, -2), (GREEN, 0), (YELLOW, 2)],
                axis=2
            )
        )

        # Label showing current amplitude
        label = always_redraw(
            lambda: MathTex(
                f"z = {amp.get_value():.1f}" + r"\cdot\sin(x)\cos(y)",
                font_size=36
            ).to_corner(UL)
        )

        self.set_camera_orientation(phi=60 * DEGREES, theta=-45 * DEGREES)

        self.add_fixed_in_frame_mobjects(label)
        self.play(Create(axes), run_time=1)
        self.add(surface)
        self.wait(0.5)

        # Animate amplitude change
        self.begin_ambient_camera_rotation(rate=0.15)
        self.play(amp.animate.set_value(1.5), run_time=2)
        self.play(amp.animate.set_value(0.3), run_time=2)
        self.play(amp.animate.set_value(1.0), run_time=1)
        self.wait(2)


# Run commands:
# manim -qm -p test_3d_surface.py Surface3DBasic
# manim -qm -p test_3d_surface.py Paraboloid3D
# manim -qm -p test_3d_surface.py Saddle3D
# manim -qm -p test_3d_surface.py Sphere3D
# manim -qm -p test_3d_surface.py Helix3D
# manim -qm -p test_3d_surface.py AnimatedSurface
