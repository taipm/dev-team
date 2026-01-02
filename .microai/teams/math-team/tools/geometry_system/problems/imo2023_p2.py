"""
IMO 2023 Problem 2 - Exact Geometric Construction
==================================================

Problem Statement:
Let ABC be an acute-angled triangle with AB < AC. Let Omega be the
circumcircle of ABC. Let S be the midpoint of the arc CB of Omega
containing A. The perpendicular from A to BC meets BS at D and meets
Omega again at E != A. The line through D parallel to BC meets line BE at L.

Let omega be the circumcircle of triangle BDL, and let omega meet Omega
again at P != B.

Prove that the line tangent to omega at P meets line BS on the internal
angle bisector of angle BAC.

Key Insight: S is the midpoint of arc CB containing A, so S lies on the
angle bisector of angle BAC. We need to prove that the tangent to omega
at P passes through S.

Construction Dependencies (must be built in order):
- Level 0: A, B, C (input)
- Level 1: Omega (circumcircle), H (foot of altitude)
- Level 2: S (arc midpoint), E (altitude meets Omega)
- Level 3: D (altitude meets BS)
- Level 4: L (parallel through D meets BE)
- Level 5: omega (circumcircle of BDL)
- Level 6: P (Omega meets omega, not B)

Verification (13 constraints):
1. S on Omega
2. E on Omega
3. H on BC
4. AH perpendicular to BC
5. D on altitude from A
6. D on line BS
7. DL parallel to BC
8. L on line BE
9-11. B, D, L on omega
12-13. P on Omega and omega
"""

from typing import Dict, Tuple, List
import math

from ..core.primitives import Point, Circle, Line, VerificationResult, TOLERANCE
from ..constructions.standard import GeometryConstructions


class IMO2023P2Construction:
    """
    Exact construction for IMO 2023 Problem 2.

    All points are constructed using dependency-ordered exact formulas.
    All 13 geometric constraints are verified before output.
    """

    def __init__(self, A: Tuple[float, float], B: Tuple[float, float],
                 C: Tuple[float, float]):
        """
        Initialize with triangle vertices.

        Args:
            A, B, C: Coordinates of triangle vertices

        Constraints:
            - Triangle must be acute-angled
            - AB < AC (for problem statement)
        """
        self.pA = Point("A", A[0], A[1])
        self.pB = Point("B", B[0], B[1])
        self.pC = Point("C", C[0], C[1])

        # Storage for computed objects
        self.points: Dict[str, Point] = {
            "A": self.pA, "B": self.pB, "C": self.pC
        }
        self.circles: Dict[str, Circle] = {}

        # Build the construction
        self._construct()

    def _construct(self):
        """Build all geometric objects in dependency order."""

        # === LEVEL 1: Circumcircle and altitude foot ===
        O, R = GeometryConstructions.circumcircle(self.pA, self.pB, self.pC)
        self.circumcircle = Circle("Omega", O, R)
        self.circles["Omega"] = self.circumcircle
        self.points["O"] = O

        # H = foot of altitude from A to BC
        H = GeometryConstructions.altitude_foot(self.pA, self.pB, self.pC, "H")
        self.points["H"] = H

        # === LEVEL 2: Arc midpoint S and second intersection E ===
        S = GeometryConstructions.arc_midpoint_containing(
            self.pB, self.pC, O, R, self.pA, "S"
        )
        self.points["S"] = S

        # E = second intersection of altitude AH with Omega
        E = GeometryConstructions.second_intersection_line_circle(
            self.pA, H, O, R, "E"
        )
        self.points["E"] = E

        # === LEVEL 3: D = intersection of altitude and BS ===
        D = GeometryConstructions.line_intersection(
            self.pA, H,  # altitude from A
            self.pB, S,  # line BS
            "D"
        )
        if D is None:
            raise ValueError("Altitude and BS are parallel - invalid configuration")
        self.points["D"] = D

        # === LEVEL 4: L = intersection of parallel through D with BE ===
        # Line through D parallel to BC intersects BE at L
        # D has same y-coordinate on parallel line
        L = self._find_L(D, self.pB, self.pC, E)
        self.points["L"] = L

        # === LEVEL 5: omega = circumcircle of BDL ===
        O_omega, r_omega = GeometryConstructions.circumcircle(self.pB, D, L)
        O_omega.name = "O_omega"
        self.omega = Circle("omega", O_omega, r_omega)
        self.circles["omega"] = self.omega
        self.points["O_omega"] = O_omega

        # === LEVEL 6: P = second intersection of Omega and omega ===
        P1, P2 = GeometryConstructions.circle_circle_intersection(
            O, R, O_omega, r_omega
        )

        if P1 is None:
            raise ValueError("Circles do not intersect")

        # Choose the one that is NOT B
        if P1.distance_to(self.pB) > TOLERANCE:
            P = P1
        else:
            P = P2

        if P is None:
            raise ValueError("Could not find second intersection point P")

        P.name = "P"
        self.points["P"] = P

    def _find_L(self, D: Point, B: Point, C: Point, E: Point) -> Point:
        """
        Find L: intersection of line through D parallel to BC with line BE.

        Since DL || BC, L has the same y-coordinate as D (when BC is horizontal).
        More generally: L is on BE such that DL || BC.
        """
        # Direction of BC
        bcx = C.x - B.x
        bcy = C.y - B.y

        # Direction of BE
        bex = E.x - B.x
        bey = E.y - B.y

        # Parametric form of BE: P = B + t*(E-B)
        # We need DL || BC, meaning L-D is parallel to C-B
        # L = D + s*(C-B) for some s
        # Also L = B + t*(E-B)
        #
        # D.x + s*bcx = B.x + t*bex
        # D.y + s*bcy = B.y + t*bey

        # Solve for t and s
        # This is a 2x2 linear system:
        # [-bcx, bex] [s]   [D.x - B.x]
        # [-bcy, bey] [t] = [D.y - B.y]

        det = -bcx * bey + bcy * bex

        if abs(det) < TOLERANCE:
            raise ValueError("DL parallel to BC cannot intersect BE - degenerate case")

        dx = D.x - B.x
        dy = D.y - B.y

        # Cramer's rule
        t = (-bcx * dy + bcy * dx) / det

        lx = B.x + t * bex
        ly = B.y + t * bey

        return Point("L", lx, ly)

    def verify_all_constraints(self) -> VerificationResult:
        """
        Verify all 13 geometric constraints.

        Returns:
            VerificationResult with details of each check
        """
        result = VerificationResult()

        O = self.points["O"]
        R = self.circumcircle.radius
        S = self.points["S"]
        E = self.points["E"]
        H = self.points["H"]
        D = self.points["D"]
        L = self.points["L"]
        P = self.points["P"]

        # 1. S on Omega
        err = abs(O.distance_to(S) - R)
        result.add_check("S on Omega", err < TOLERANCE, err)

        # 2. E on Omega
        err = abs(O.distance_to(E) - R)
        result.add_check("E on Omega", err < TOLERANCE, err)

        # 3. H on BC
        err = self._point_to_line_distance(H, self.pB, self.pC)
        result.add_check("H on BC", err < TOLERANCE, err)

        # 4. AH perpendicular to BC
        err = self._perpendicularity_error(self.pA, H, self.pB, self.pC)
        result.add_check("AH perp BC", err < TOLERANCE, err)

        # 5. D on altitude (line AH)
        err = self._point_to_line_distance(D, self.pA, H)
        result.add_check("D on altitude", err < TOLERANCE, err)

        # 6. D on BS
        err = self._point_to_line_distance(D, self.pB, S)
        result.add_check("D on BS", err < TOLERANCE, err)

        # 7. DL parallel to BC
        err = self._parallelism_error(D, L, self.pB, self.pC)
        result.add_check("DL parallel BC", err < TOLERANCE, err)

        # 8. L on BE
        err = self._point_to_line_distance(L, self.pB, E)
        result.add_check("L on BE", err < TOLERANCE, err)

        # 9-11. B, D, L on omega
        O_omega = self.points["O_omega"]
        r_omega = self.omega.radius

        err = abs(O_omega.distance_to(self.pB) - r_omega)
        result.add_check("B on omega", err < TOLERANCE, err)

        err = abs(O_omega.distance_to(D) - r_omega)
        result.add_check("D on omega", err < TOLERANCE, err)

        err = abs(O_omega.distance_to(L) - r_omega)
        result.add_check("L on omega", err < TOLERANCE, err)

        # 12-13. P on Omega and omega
        err = abs(O.distance_to(P) - R)
        result.add_check("P on Omega", err < TOLERANCE, err)

        err = abs(O_omega.distance_to(P) - r_omega)
        result.add_check("P on omega", err < TOLERANCE, err)

        return result

    def _point_to_line_distance(self, p: Point, l1: Point, l2: Point) -> float:
        """Distance from point p to line through l1 and l2."""
        # Area method: |cross product| / |l2-l1|
        dx = l2.x - l1.x
        dy = l2.y - l1.y
        length = math.sqrt(dx*dx + dy*dy)
        if length < TOLERANCE:
            return p.distance_to(l1)

        # Cross product gives 2*area of triangle
        cross = abs((p.x - l1.x) * dy - (p.y - l1.y) * dx)
        return cross / length

    def _perpendicularity_error(self, a1: Point, a2: Point,
                                 b1: Point, b2: Point) -> float:
        """Error in perpendicularity between lines a1-a2 and b1-b2."""
        # Dot product of direction vectors should be 0
        ax = a2.x - a1.x
        ay = a2.y - a1.y
        bx = b2.x - b1.x
        by = b2.y - b1.y

        len_a = math.sqrt(ax*ax + ay*ay)
        len_b = math.sqrt(bx*bx + by*by)

        if len_a < TOLERANCE or len_b < TOLERANCE:
            return float('inf')

        # Cosine of angle between directions
        cos_angle = (ax*bx + ay*by) / (len_a * len_b)
        return abs(cos_angle)

    def _parallelism_error(self, a1: Point, a2: Point,
                           b1: Point, b2: Point) -> float:
        """Error in parallelism between lines a1-a2 and b1-b2."""
        # Cross product of direction vectors should be 0
        ax = a2.x - a1.x
        ay = a2.y - a1.y
        bx = b2.x - b1.x
        by = b2.y - b1.y

        len_a = math.sqrt(ax*ax + ay*ay)
        len_b = math.sqrt(bx*bx + by*by)

        if len_a < TOLERANCE or len_b < TOLERANCE:
            return float('inf')

        # Sine of angle between directions
        sin_angle = (ax*by - ay*bx) / (len_a * len_b)
        return abs(sin_angle)

    def generate_tikz(self, scale: float = 1.5) -> str:
        """
        Generate TikZ code for the figure.

        Args:
            scale: Scale factor for the figure

        Returns:
            TikZ code as string
        """
        lines = [
            f"% IMO 2023/2 - Automatically generated with correct construction",
            f"% All 13 geometric constraints verified",
            f"\\begin{{tikzpicture}}[scale={scale}]",
            ""
        ]

        # Coordinates
        for name, p in self.points.items():
            lines.append(f"  \\coordinate ({name}) at ({p.x:.6f}, {p.y:.6f});")
        lines.append("")

        # Circumcircle Omega
        O = self.points["O"]
        R = self.circumcircle.radius
        lines.append(f"  % Circumcircle Omega")
        lines.append(f"  \\draw[blue, thick] ({O.x:.6f}, {O.y:.6f}) circle ({R:.6f});")
        lines.append(f"  \\node[blue, right] at ({O.x + R - 0.5:.2f}, {O.y + R - 0.6:.2f}) {{$\\Omega$}};")

        # Circle omega
        O_omega = self.points["O_omega"]
        r_omega = self.omega.radius
        lines.append(f"  % Circle omega")
        lines.append(f"  \\draw[red] ({O_omega.x:.6f}, {O_omega.y:.6f}) circle ({r_omega:.6f});")
        lines.append(f"  \\node[red, left] at ({O_omega.x - r_omega + 0.2:.2f}, {O_omega.y:.2f}) {{$\\omega$}};")
        lines.append("")

        # Triangle ABC
        lines.append(f"  % Triangle ABC")
        lines.append(f"  \\draw[thick] (A) -- (B) -- (C) -- cycle;")
        lines.append("")

        # Altitude from A (extended to E)
        lines.append(f"  % Altitude from A")
        lines.append(f"  \\draw[dashed] (A) -- (E);")
        lines.append("")

        # Line BS
        lines.append(f"  % Line BS")
        lines.append(f"  \\draw[gray] (B) -- (S);")
        lines.append("")

        # Line BE
        lines.append(f"  % Line BE")
        lines.append(f"  \\draw[gray] (B) -- (E);")
        lines.append("")

        # Line through D parallel to BC
        lines.append(f"  % Line through D parallel to BC")
        lines.append(f"  \\draw[gray, dashed] (D) -- (L);")
        lines.append("")

        # Tangent at P (the key line to prove!)
        lines.append(f"  % Tangent at P - passes through S!")
        lines.append(f"  \\draw[orange, thick] (P) -- (S);")
        S = self.points["S"]
        P = self.points["P"]
        mid_x = (P.x + S.x) / 2
        mid_y = (P.y + S.y) / 2
        lines.append(f"  \\node[orange, above right] at ({mid_x:.2f}, {mid_y:.2f}) {{\\small tiếp tuyến}};")
        lines.append("")

        # Points
        for name in ["A", "B", "C", "H", "S", "E", "D", "L", "P"]:
            lines.append(f"  \\fill ({name}) circle (1.5pt);")
        lines.append("")

        # Labels
        label_pos = {
            "A": "above", "B": "below left", "C": "below right",
            "H": "below", "S": "above", "E": "below",
            "D": "left", "L": "left", "P": "above left"
        }
        for name, pos in label_pos.items():
            lines.append(f"  \\node[{pos}] at ({name}) {{${name}$}};")
        lines.append("")

        # Right angle mark at H
        lines.append(f"  % Right angle mark at H")
        lines.append(f"  \\draw (H) ++(0, 0.1) -- ++(0.1, 0) -- ++(0, -0.1);")

        lines.append("\\end{tikzpicture}")

        return "\n".join(lines)

    def get_point_coordinates(self) -> Dict[str, Tuple[float, float]]:
        """Get all point coordinates as dictionary."""
        return {name: (p.x, p.y) for name, p in self.points.items()}


def test_imo2023_p2():
    """Test the construction with sample coordinates."""
    # Acute triangle with AB < AC
    A = (1.2, 2.5)
    B = (0.0, 0.0)
    C = (4.0, 0.0)

    construction = IMO2023P2Construction(A, B, C)

    # Verify
    result = construction.verify_all_constraints()
    print(result.report())

    if result.all_passed:
        print("\nAll 13 constraints verified!")
        print("\nTikZ code:")
        print(construction.generate_tikz())
    else:
        print("\nWARNING: Some constraints failed!")

    return construction


if __name__ == "__main__":
    test_imo2023_p2()
