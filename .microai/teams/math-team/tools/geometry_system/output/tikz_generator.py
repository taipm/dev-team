"""
Geometry System - TikZ Generator
================================
Generate verified TikZ code from geometric constructions.
"""

from typing import List, Tuple, Optional, Dict
from ..core.primitives import Point, Circle, Line, TOLERANCE


class TikZStyle:
    """Styling configuration for TikZ output."""

    # Colors
    CIRCUMCIRCLE = "blue!70"
    NINE_POINT = "purple!70"
    TRIANGLE = "red!70!black"
    ALTITUDE = "cyan!70!black"
    ORTHIC = "green!50!black"

    # Point styles
    VERTEX = "fill=red!70!black, circle, inner sep=2pt"
    ALTITUDE_FOOT = "fill=orange, circle, inner sep=1.5pt"
    CENTER = "fill=blue!70, circle, inner sep=1.5pt"
    SPECIAL = "fill=purple, circle, inner sep=1.5pt"


class TikZGenerator:
    """Generate TikZ code with verified geometry."""

    def __init__(self, scale: float = 1.2):
        self.scale = scale
        self.lines: List[str] = []

    def begin(self, title: str = None):
        """Start TikZ picture."""
        self.lines = []
        self.lines.append(f"\\begin{{tikzpicture}}[scale={self.scale}]")
        if title:
            self.lines.append(f"  % {title}")
        self.lines.append("")

    def end(self) -> str:
        """End TikZ picture and return code."""
        self.lines.append("\\end{tikzpicture}")
        return "\n".join(self.lines)

    def add_comment(self, comment: str):
        """Add a comment line."""
        self.lines.append(f"  % {comment}")

    def add_circle(self, circle: Circle, style: str = "thick",
                   color: str = "blue", dashed: bool = False):
        """Add a circle to the figure."""
        dash = ", dashed" if dashed else ""
        self.lines.append(
            f"  \\draw[{color}, {style}{dash}] "
            f"({circle.center.x:.6f}, {circle.center.y:.6f}) "
            f"circle ({circle.radius:.6f});"
        )

    def add_segment(self, p1: Point, p2: Point, style: str = "thick",
                    color: str = "black", dashed: bool = False):
        """Add a line segment."""
        dash = ", dashed" if dashed else ""
        self.lines.append(
            f"  \\draw[{color}, {style}{dash}] "
            f"({p1.x:.6f}, {p1.y:.6f}) -- ({p2.x:.6f}, {p2.y:.6f});"
        )

    def add_triangle(self, A: Point, B: Point, C: Point,
                     style: str = "very thick", color: str = "red!70!black"):
        """Add a triangle."""
        self.lines.append(
            f"  \\draw[{color}, {style}] "
            f"({A.x:.6f}, {A.y:.6f}) -- "
            f"({B.x:.6f}, {B.y:.6f}) -- "
            f"({C.x:.6f}, {C.y:.6f}) -- cycle;"
        )

    def add_point(self, point: Point, style: str = None,
                  label_pos: str = None, color: str = "black"):
        """Add a point with label."""
        if style is None:
            style = f"fill={color}, circle, inner sep=1.5pt"

        if label_pos is None:
            label_pos = self._auto_label_position(point)

        self.lines.append(
            f"  \\node[{style}, label={label_pos}:${point.name}$] "
            f"at ({point.x:.6f}, {point.y:.6f}) {{}};"
        )

    def add_right_angle_mark(self, vertex: Point, p1: Point, p2: Point,
                             size: float = 0.15):
        """Add a right angle mark at vertex."""
        # Direction vectors
        import math
        dx1, dy1 = p1.x - vertex.x, p1.y - vertex.y
        dx2, dy2 = p2.x - vertex.x, p2.y - vertex.y

        # Normalize
        len1 = math.sqrt(dx1*dx1 + dy1*dy1)
        len2 = math.sqrt(dx2*dx2 + dy2*dy2)

        if len1 < TOLERANCE or len2 < TOLERANCE:
            return

        dx1, dy1 = dx1/len1 * size, dy1/len1 * size
        dx2, dy2 = dx2/len2 * size, dy2/len2 * size

        # Corner points of the right angle mark
        corner1_x = vertex.x + dx1
        corner1_y = vertex.y + dy1
        corner2_x = vertex.x + dx2
        corner2_y = vertex.y + dy2
        corner3_x = vertex.x + dx1 + dx2
        corner3_y = vertex.y + dy1 + dy2

        self.lines.append(
            f"  \\draw[thin] ({corner1_x:.6f}, {corner1_y:.6f}) -- "
            f"({corner3_x:.6f}, {corner3_y:.6f}) -- "
            f"({corner2_x:.6f}, {corner2_y:.6f});"
        )

    def _auto_label_position(self, point: Point) -> str:
        """Determine best label position based on point location."""
        # Simple heuristic based on quadrant
        if point.y > 2:
            return "above"
        elif point.y < -1:
            return "below"
        elif point.x > 2:
            return "right"
        elif point.x < -1:
            return "left"
        else:
            return "above right"

    def generate_latex_document(self, tikz_code: str) -> str:
        """Wrap TikZ in complete LaTeX document."""
        return f"""\\documentclass[12pt,a4paper]{{article}}
\\usepackage{{tikz}}
\\usepackage{{geometry}}
\\geometry{{margin=2cm}}
\\pagestyle{{empty}}

\\begin{{document}}

\\begin{{center}}
{{\\Large\\bfseries Hình vẽ chính xác - Verified Geometry}}
\\end{{center}}

\\begin{{figure}}[htbp]
\\centering
{tikz_code}
\\end{{figure}}

\\end{{document}}
"""


def create_orthocenter_figure(A: Point, B: Point, C: Point,
                               include_nine_point: bool = True) -> str:
    """
    Create a complete orthocenter configuration figure.

    Includes: circumcircle, orthocenter, altitude feet, nine-point circle.
    All points are VERIFIED before output.
    """
    from ..constructions import GeometryConstructions
    from ..solver import GeometryVerifier

    # === CONSTRUCTIONS (with exact formulas) ===

    # Circumcircle
    O, R = GeometryConstructions.circumcircle(A, B, C)
    circumcircle = Circle("Gamma", O, R)

    # Orthocenter
    H = GeometryConstructions.orthocenter(A, B, C)

    # Altitude feet
    D = GeometryConstructions.altitude_foot(A, B, C, "D")
    E = GeometryConstructions.altitude_foot(B, A, C, "E")
    F = GeometryConstructions.altitude_foot(C, A, B, "F")

    # Midpoint of BC
    I = GeometryConstructions.midpoint(B, C, "I")

    # K = second intersection of AD with circumcircle
    K = GeometryConstructions.second_intersection_line_circle(A, D, O, R, "K")

    # Nine-point circle
    N, r = GeometryConstructions.nine_point_circle(A, B, C)
    nine_point = Circle("omega", N, r)

    # === VERIFICATION ===
    verifier = GeometryVerifier()

    # Verify circumcircle
    verifier.verify_points_on_circle([A, B, C, K], circumcircle)

    # Verify altitude feet on sides
    verifier.verify_collinear(B, D, C)
    verifier.verify_collinear(A, E, C)
    verifier.verify_collinear(A, F, B)

    # Verify right angles
    verifier.verify_right_angle(D, A, C)  # AD ⊥ BC at D
    verifier.verify_right_angle(E, B, A)  # BE ⊥ AC at E
    verifier.verify_right_angle(F, C, B)  # CF ⊥ AB at F

    # Verify nine-point circle
    if include_nine_point:
        verifier.verify_points_on_circle([D, E, F, I], nine_point)

    print(verifier.get_report())

    if not verifier.is_all_passed():
        raise ValueError("Geometry verification failed!")

    # === GENERATE TikZ ===
    gen = TikZGenerator(scale=1.2)
    gen.begin("Triangle with orthocenter - VERIFIED")

    # Circumcircle
    gen.add_comment("Circumcircle")
    gen.add_circle(circumcircle, color=TikZStyle.CIRCUMCIRCLE)

    # Nine-point circle
    if include_nine_point:
        gen.add_comment("Nine-point circle")
        gen.add_circle(nine_point, color=TikZStyle.NINE_POINT, dashed=True)

    # Triangle
    gen.add_comment("Triangle ABC")
    gen.add_triangle(A, B, C, color=TikZStyle.TRIANGLE)

    # Altitudes
    gen.add_comment("Altitudes")
    gen.add_segment(A, D, color=TikZStyle.ALTITUDE)
    gen.add_segment(B, E, color=TikZStyle.ALTITUDE)
    gen.add_segment(C, F, color=TikZStyle.ALTITUDE)

    # Extension AD to K
    gen.add_segment(D, K, color=TikZStyle.ALTITUDE, dashed=True)

    # Orthic triangle
    gen.add_comment("Orthic triangle DEF")
    gen.add_segment(D, E, color=TikZStyle.ORTHIC)
    gen.add_segment(E, F, color=TikZStyle.ORTHIC)
    gen.add_segment(F, D, color=TikZStyle.ORTHIC)

    # Right angle marks
    gen.add_comment("Right angle marks")
    gen.add_right_angle_mark(D, A, C)
    gen.add_right_angle_mark(E, B, A)
    gen.add_right_angle_mark(F, C, B)

    # Points
    gen.add_comment("Points")
    gen.add_point(A, style=TikZStyle.VERTEX, label_pos="above")
    gen.add_point(B, style=TikZStyle.VERTEX, label_pos="below left")
    gen.add_point(C, style=TikZStyle.VERTEX, label_pos="below right")

    gen.add_point(D, style=TikZStyle.ALTITUDE_FOOT, label_pos="below")
    gen.add_point(E, style=TikZStyle.ALTITUDE_FOOT, label_pos="right")
    gen.add_point(F, style=TikZStyle.ALTITUDE_FOOT, label_pos="left")

    gen.add_point(H, style=TikZStyle.CENTER, label_pos="above right")
    gen.add_point(I, style="fill=black, circle, inner sep=1.5pt", label_pos="below")
    gen.add_point(K, style=TikZStyle.CENTER, label_pos="below")

    gen.add_point(O, style="draw=blue!70, fill=white, circle, inner sep=1.5pt",
                  label_pos="right")

    if include_nine_point:
        gen.add_point(N, style="draw=purple!70, fill=white, circle, inner sep=1pt",
                      label_pos="left")

    return gen.end()
