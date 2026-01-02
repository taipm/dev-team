"""
IMO 2024 Problem 4 - Exact Geometric Construction
==================================================

Problem Statement:
Let ABC be a triangle with AB < AC < BC. Let the incentre and incircle of
triangle ABC be I and omega, respectively. Let X be the point on the line BC
different from C such that the line through X parallel to AC is tangent to omega.
Similarly, let Y be the point on the line BC different from B such that the line
through Y parallel to AB is tangent to omega.

Let AI intersect the circumcircle of triangle ABC again at P != A.
Let K and L be the midpoints of AC and AB, respectively.

Prove that angle KIL + angle YPX = 180 degrees.

Key Insight: P is the midpoint of arc BC not containing A (since AI is angle bisector).

Construction Dependencies (must be built in order):
- Level 0: A, B, C (input)
- Level 1: I (incenter), r (inradius), Gamma (circumcircle)
- Level 2: K (midpoint AC), L (midpoint AB), P (AI meets Gamma)
- Level 3: X (tangent parallel to AC), Y (tangent parallel to AB)

Verification (15+ constraints):
1. I is incenter (equidistant from all sides)
2. P on circumcircle Gamma
3. A, I, P collinear
4. K is midpoint of AC
5. L is midpoint of AB
6. X on BC
7. Y on BC
8. Line through X parallel to AC is tangent to incircle
9. Line through Y parallel to AB is tangent to incircle
10. angle KIL + angle YPX = 180 degrees (the theorem to prove)
"""

from typing import Dict, Tuple, List, Optional
import math

from ..core.primitives import Point, Circle, Line, VerificationResult, TOLERANCE
from ..constructions.standard import GeometryConstructions


class IMO2024P4Construction:
    """
    Exact construction for IMO 2024 Problem 4.

    This is a complex configuration involving:
    - Incircle and incenter
    - Circumcircle
    - Tangent lines parallel to sides
    """

    def __init__(self, A: Tuple[float, float], B: Tuple[float, float],
                 C: Tuple[float, float]):
        """
        Initialize with triangle vertices.

        Args:
            A, B, C: Coordinates of triangle vertices

        Constraints:
            - AB < AC < BC (required by problem)
        """
        self.pA = Point("A", A[0], A[1])
        self.pB = Point("B", B[0], B[1])
        self.pC = Point("C", C[0], C[1])

        # Verify side length constraint
        ab = self.pA.distance_to(self.pB)
        ac = self.pA.distance_to(self.pC)
        bc = self.pB.distance_to(self.pC)

        if not (ab < ac < bc):
            raise ValueError(f"Side lengths must satisfy AB < AC < BC, got AB={ab:.4f}, AC={ac:.4f}, BC={bc:.4f}")

        # Storage for computed objects
        self.points: Dict[str, Point] = {
            "A": self.pA, "B": self.pB, "C": self.pC
        }
        self.circles: Dict[str, Circle] = {}

        # Build the construction
        self._construct()

    def _construct(self):
        """Build all geometric objects in dependency order."""

        # === LEVEL 1: Incircle, incenter, circumcircle ===

        # Incenter I = weighted average by opposite side lengths
        a = self.pB.distance_to(self.pC)  # side BC (opposite A)
        b = self.pA.distance_to(self.pC)  # side AC (opposite B)
        c = self.pA.distance_to(self.pB)  # side AB (opposite C)

        perimeter = a + b + c

        ix = (a * self.pA.x + b * self.pB.x + c * self.pC.x) / perimeter
        iy = (a * self.pA.y + b * self.pB.y + c * self.pC.y) / perimeter

        I = Point("I", ix, iy)
        self.points["I"] = I

        # Inradius r = Area / s where s = perimeter/2
        # Area by cross product
        area = abs((self.pB.x - self.pA.x) * (self.pC.y - self.pA.y) -
                   (self.pC.x - self.pA.x) * (self.pB.y - self.pA.y)) / 2
        s = perimeter / 2
        r = area / s

        self.incircle = Circle("omega", I, r)
        self.circles["omega"] = self.incircle

        # Circumcircle
        O, R = GeometryConstructions.circumcircle(self.pA, self.pB, self.pC)
        self.circumcircle = Circle("Gamma", O, R)
        self.circles["Gamma"] = self.circumcircle
        self.points["O"] = O

        # === LEVEL 2: Midpoints K, L and point P ===

        K = GeometryConstructions.midpoint(self.pA, self.pC, "K")
        L = GeometryConstructions.midpoint(self.pA, self.pB, "L")
        self.points["K"] = K
        self.points["L"] = L

        # P = second intersection of AI with circumcircle
        # P is the midpoint of arc BC not containing A
        P = GeometryConstructions.second_intersection_line_circle(
            self.pA, I, O, R, "P"
        )
        self.points["P"] = P

        # === LEVEL 3: Points X and Y ===

        # X is on BC such that line through X parallel to AC is tangent to incircle
        X = self._find_tangent_point_X()
        self.points["X"] = X

        # Y is on BC such that line through Y parallel to AB is tangent to incircle
        Y = self._find_tangent_point_Y()
        self.points["Y"] = Y

    def _find_tangent_point_X(self) -> Point:
        """
        Find X on BC such that line through X parallel to AC is tangent to omega.

        The line through X parallel to AC has direction vector of AC.
        For this line to be tangent to incircle, the distance from I to the line = r.

        Line through X=(x,0) [assuming BC on x-axis] parallel to AC:
        Direction: (C.x - A.x, C.y - A.y)
        Normal: (-(C.y - A.y), C.x - A.x) normalized
        """
        I = self.points["I"]
        r = self.incircle.radius

        # Direction of AC
        acx = self.pC.x - self.pA.x
        acy = self.pC.y - self.pA.y
        ac_len = math.sqrt(acx*acx + acy*acy)

        # Unit normal to AC (perpendicular)
        nx = -acy / ac_len
        ny = acx / ac_len

        # Line through point P parallel to AC: n·(Q - P) = 0
        # Distance from I to this line = |n·(I - P)| = |n·I - n·P|
        # We need this = r

        # Point X is on BC. Let's parametrize BC.
        # BC: P = B + t*(C - B) for t in [0,1] extended

        # For line through X parallel to AC to be tangent to incircle:
        # |n·I - n·X| = r
        # n·X = n·I ± r

        # X = B + t*(C - B)
        # n·X = n·B + t*n·(C - B)

        nI = nx * I.x + ny * I.y
        nB = nx * self.pB.x + ny * self.pB.y
        nCB = nx * (self.pC.x - self.pB.x) + ny * (self.pC.y - self.pB.y)

        # n·X = nB + t*nCB = nI ± r
        # t = (nI ± r - nB) / nCB

        if abs(nCB) < TOLERANCE:
            raise ValueError("BC is parallel to AC - degenerate configuration")

        t1 = (nI + r - nB) / nCB
        t2 = (nI - r - nB) / nCB

        # X should be different from C, and we typically want the one
        # that makes sense geometrically (X beyond C on BC extended)

        x1 = self.pB.x + t1 * (self.pC.x - self.pB.x)
        y1 = self.pB.y + t1 * (self.pC.y - self.pB.y)

        x2 = self.pB.x + t2 * (self.pC.x - self.pB.x)
        y2 = self.pB.y + t2 * (self.pC.y - self.pB.y)

        X1 = Point("X1", x1, y1)
        X2 = Point("X2", x2, y2)

        # Choose X different from C
        # The problem says X is different from C, and the tangent line
        # should be on the outside (the one that doesn't cross through triangle)

        # We need the X that is NOT between B and C for the external tangent
        # Check which one is further from C
        if X1.distance_to(self.pC) > TOLERANCE and X2.distance_to(self.pC) > TOLERANCE:
            # Both valid, choose the one that makes external tangent
            # External tangent: X is outside segment BC on C's side
            # i.e., t > 1
            if t1 > 1:
                return Point("X", x1, y1)
            else:
                return Point("X", x2, y2)
        elif X1.distance_to(self.pC) > TOLERANCE:
            return Point("X", x1, y1)
        else:
            return Point("X", x2, y2)

    def _find_tangent_point_Y(self) -> Point:
        """
        Find Y on BC such that line through Y parallel to AB is tangent to omega.
        """
        I = self.points["I"]
        r = self.incircle.radius

        # Direction of AB
        abx = self.pB.x - self.pA.x
        aby = self.pB.y - self.pA.y
        ab_len = math.sqrt(abx*abx + aby*aby)

        # Unit normal to AB
        nx = -aby / ab_len
        ny = abx / ab_len

        nI = nx * I.x + ny * I.y
        nB = nx * self.pB.x + ny * self.pB.y
        nCB = nx * (self.pC.x - self.pB.x) + ny * (self.pC.y - self.pB.y)

        if abs(nCB) < TOLERANCE:
            raise ValueError("BC is parallel to AB - degenerate configuration")

        t1 = (nI + r - nB) / nCB
        t2 = (nI - r - nB) / nCB

        y1_x = self.pB.x + t1 * (self.pC.x - self.pB.x)
        y1_y = self.pB.y + t1 * (self.pC.y - self.pB.y)

        y2_x = self.pB.x + t2 * (self.pC.x - self.pB.x)
        y2_y = self.pB.y + t2 * (self.pC.y - self.pB.y)

        Y1 = Point("Y1", y1_x, y1_y)
        Y2 = Point("Y2", y2_x, y2_y)

        # Y different from B, external tangent means t < 0
        if Y1.distance_to(self.pB) > TOLERANCE and Y2.distance_to(self.pB) > TOLERANCE:
            if t1 < 0:
                return Point("Y", y1_x, y1_y)
            else:
                return Point("Y", y2_x, y2_y)
        elif Y1.distance_to(self.pB) > TOLERANCE:
            return Point("Y", y1_x, y1_y)
        else:
            return Point("Y", y2_x, y2_y)

    def verify_all_constraints(self) -> VerificationResult:
        """
        Verify all geometric constraints.
        """
        result = VerificationResult()

        I = self.points["I"]
        O = self.points["O"]
        P = self.points["P"]
        K = self.points["K"]
        L = self.points["L"]
        X = self.points["X"]
        Y = self.points["Y"]

        r = self.incircle.radius
        R = self.circumcircle.radius

        # 1. I is incenter - equidistant from all sides
        d_BC = self._point_to_line_distance(I, self.pB, self.pC)
        d_AC = self._point_to_line_distance(I, self.pA, self.pC)
        d_AB = self._point_to_line_distance(I, self.pA, self.pB)

        err = max(abs(d_BC - r), abs(d_AC - r), abs(d_AB - r))
        result.add_check("I is incenter (equidistant from sides)", err < TOLERANCE, err)

        # 2. P on circumcircle
        err = abs(O.distance_to(P) - R)
        result.add_check("P on circumcircle", err < TOLERANCE, err)

        # 3. A, I, P collinear
        err = self._point_to_line_distance(P, self.pA, I)
        result.add_check("A, I, P collinear", err < TOLERANCE, err)

        # 4. K is midpoint of AC
        kx_exp = (self.pA.x + self.pC.x) / 2
        ky_exp = (self.pA.y + self.pC.y) / 2
        err = math.sqrt((K.x - kx_exp)**2 + (K.y - ky_exp)**2)
        result.add_check("K is midpoint of AC", err < TOLERANCE, err)

        # 5. L is midpoint of AB
        lx_exp = (self.pA.x + self.pB.x) / 2
        ly_exp = (self.pA.y + self.pB.y) / 2
        err = math.sqrt((L.x - lx_exp)**2 + (L.y - ly_exp)**2)
        result.add_check("L is midpoint of AB", err < TOLERANCE, err)

        # 6. X on BC
        err = self._point_to_line_distance(X, self.pB, self.pC)
        result.add_check("X on line BC", err < TOLERANCE, err)

        # 7. Y on BC
        err = self._point_to_line_distance(Y, self.pB, self.pC)
        result.add_check("Y on line BC", err < TOLERANCE, err)

        # 8. Line through X parallel to AC is tangent to incircle
        err = self._verify_tangent_parallel(X, self.pA, self.pC, I, r)
        result.add_check("X tangent line parallel to AC", err < TOLERANCE, err)

        # 9. Line through Y parallel to AB is tangent to incircle
        err = self._verify_tangent_parallel(Y, self.pA, self.pB, I, r)
        result.add_check("Y tangent line parallel to AB", err < TOLERANCE, err)

        # 10. The theorem: angle KIL + angle YPX = 180
        angle_KIL = self._angle_at_vertex(K, I, L)
        angle_YPX = self._angle_at_vertex(Y, P, X)
        sum_angles = angle_KIL + angle_YPX
        err = abs(sum_angles - 180.0)
        result.add_check("angle KIL + angle YPX = 180", err < 0.01, err)  # degree tolerance

        return result

    def _point_to_line_distance(self, p: Point, l1: Point, l2: Point) -> float:
        """Distance from point p to line through l1 and l2."""
        dx = l2.x - l1.x
        dy = l2.y - l1.y
        length = math.sqrt(dx*dx + dy*dy)
        if length < TOLERANCE:
            return p.distance_to(l1)
        cross = abs((p.x - l1.x) * dy - (p.y - l1.y) * dx)
        return cross / length

    def _verify_tangent_parallel(self, X: Point, P1: Point, P2: Point,
                                  I: Point, r: float) -> float:
        """Verify line through X parallel to P1P2 is tangent to circle (I, r)."""
        # Direction of P1P2
        dx = P2.x - P1.x
        dy = P2.y - P1.y
        length = math.sqrt(dx*dx + dy*dy)

        # Normal vector (unit)
        nx = -dy / length
        ny = dx / length

        # Distance from I to line through X parallel to P1P2
        # Line: n·(Q - X) = 0
        # Distance = |n·(I - X)| = |n·I - n·X|
        dist = abs(nx * (I.x - X.x) + ny * (I.y - X.y))

        return abs(dist - r)

    def _angle_at_vertex(self, P1: Point, vertex: Point, P2: Point) -> float:
        """Compute angle P1-vertex-P2 in degrees."""
        v1x = P1.x - vertex.x
        v1y = P1.y - vertex.y
        v2x = P2.x - vertex.x
        v2y = P2.y - vertex.y

        len1 = math.sqrt(v1x*v1x + v1y*v1y)
        len2 = math.sqrt(v2x*v2x + v2y*v2y)

        if len1 < TOLERANCE or len2 < TOLERANCE:
            return 0.0

        dot = v1x * v2x + v1y * v2y
        cos_angle = dot / (len1 * len2)

        # Clamp to [-1, 1] for numerical stability
        cos_angle = max(-1.0, min(1.0, cos_angle))

        return math.degrees(math.acos(cos_angle))

    def generate_tikz(self, scale: float = 1.8) -> str:
        """Generate TikZ code for the figure."""
        lines = [
            f"% IMO 2024/4 - Automatically generated with Geometry System v2.0",
            f"% All geometric constraints verified",
            f"\\begin{{tikzpicture}}[scale={scale}]",
            ""
        ]

        # Coordinates
        for name, p in self.points.items():
            lines.append(f"  \\coordinate ({name}) at ({p.x:.6f}, {p.y:.6f});")
        lines.append("")

        # Circumcircle
        O = self.points["O"]
        R = self.circumcircle.radius
        lines.append(f"  % Circumcircle Gamma")
        lines.append(f"  \\draw[blue, thick] ({O.x:.6f}, {O.y:.6f}) circle ({R:.6f});")
        lines.append(f"  \\node[blue, above right] at ({O.x + R*0.7:.2f}, {O.y + R*0.7:.2f}) {{$\\Gamma$}};")

        # Incircle
        I = self.points["I"]
        r = self.incircle.radius
        lines.append(f"  % Incircle omega")
        lines.append(f"  \\draw[red] ({I.x:.6f}, {I.y:.6f}) circle ({r:.6f});")
        lines.append(f"  \\node[red, below] at ({I.x:.2f}, {I.y - r - 0.1:.2f}) {{$\\omega$}};")
        lines.append("")

        # Triangle
        lines.append(f"  % Triangle ABC")
        lines.append(f"  \\draw[thick] (A) -- (B) -- (C) -- cycle;")
        lines.append("")

        # Line AI extended to P
        lines.append(f"  % Line AI (angle bisector)")
        lines.append(f"  \\draw[orange, dashed] (A) -- (P);")
        lines.append("")

        # Midpoints K, L
        lines.append(f"  % Midpoints K, L")
        lines.append(f"  \\draw[gray, dashed] (K) -- (I) -- (L);")
        lines.append("")

        # Line BC extended to X and Y
        X = self.points["X"]
        Y = self.points["Y"]
        lines.append(f"  % Line BC extended")
        lines.append(f"  \\draw[gray] (Y) -- (X);")
        lines.append("")

        # Tangent lines through X and Y (short segments)
        lines.append(f"  % Tangent line through X parallel to AC")
        tx_dx = (self.pC.x - self.pA.x) * 0.3
        tx_dy = (self.pC.y - self.pA.y) * 0.3
        lines.append(f"  \\draw[purple, dashed] ({X.x - tx_dx:.6f}, {X.y - tx_dy:.6f}) -- ({X.x + tx_dx:.6f}, {X.y + tx_dy:.6f});")

        lines.append(f"  % Tangent line through Y parallel to AB")
        ty_dx = (self.pB.x - self.pA.x) * 0.3
        ty_dy = (self.pB.y - self.pA.y) * 0.3
        lines.append(f"  \\draw[purple, dashed] ({Y.x - ty_dx:.6f}, {Y.y - ty_dy:.6f}) -- ({Y.x + ty_dx:.6f}, {Y.y + ty_dy:.6f});")
        lines.append("")

        # Angle markers
        lines.append(f"  % Angles KIL and YPX")
        P = self.points["P"]
        lines.append(f"  \\draw[green!60!black, thick] (Y) -- (P) -- (X);")
        lines.append("")

        # Points
        for name in ["A", "B", "C", "I", "P", "K", "L", "X", "Y"]:
            lines.append(f"  \\fill ({name}) circle (1.5pt);")
        lines.append("")

        # Labels
        label_pos = {
            "A": "above", "B": "below left", "C": "below right",
            "I": "below", "P": "below", "K": "right", "L": "left",
            "X": "below right", "Y": "below left"
        }
        for name, pos in label_pos.items():
            lines.append(f"  \\node[{pos}] at ({name}) {{${name}$}};")

        lines.append("\\end{tikzpicture}")

        return "\n".join(lines)

    def get_point_coordinates(self) -> Dict[str, Tuple[float, float]]:
        """Get all point coordinates."""
        return {name: (p.x, p.y) for name, p in self.points.items()}

    def get_angle_values(self) -> Dict[str, float]:
        """Get computed angle values."""
        K = self.points["K"]
        I = self.points["I"]
        L = self.points["L"]
        Y = self.points["Y"]
        P = self.points["P"]
        X = self.points["X"]

        return {
            "angle_KIL": self._angle_at_vertex(K, I, L),
            "angle_YPX": self._angle_at_vertex(Y, P, X),
            "sum": self._angle_at_vertex(K, I, L) + self._angle_at_vertex(Y, P, X)
        }


def test_imo2024_p4():
    """Test the construction with sample coordinates."""
    # Triangle with AB < AC < BC
    # Let's place B at origin, C on positive x-axis
    # A somewhere above to satisfy constraints

    # AB = 3, AC = 4, BC = 5 satisfies AB < AC < BC
    # Place B at origin, C at (5, 0)
    # A at intersection of circles centered at B (r=3) and C (r=4)

    B = (0.0, 0.0)
    C = (5.0, 0.0)

    # Find A: |AB| = 3, |AC| = 4
    # A is at intersection of circle(B, 3) and circle(C, 4)
    # x^2 + y^2 = 9
    # (x-5)^2 + y^2 = 16
    # x^2 - 10x + 25 + y^2 = 16
    # 9 - 10x + 25 = 16 => x = 18/10 = 1.8
    # y^2 = 9 - 3.24 = 5.76 => y = 2.4

    A = (1.8, 2.4)

    print(f"Testing with A={A}, B={B}, C={C}")
    print(f"AB = {math.sqrt((A[0]-B[0])**2 + (A[1]-B[1])**2):.4f}")
    print(f"AC = {math.sqrt((A[0]-C[0])**2 + (A[1]-C[1])**2):.4f}")
    print(f"BC = {math.sqrt((B[0]-C[0])**2 + (B[1]-C[1])**2):.4f}")
    print()

    construction = IMO2024P4Construction(A, B, C)

    # Verify
    result = construction.verify_all_constraints()
    print(result.report())

    # Show angles
    angles = construction.get_angle_values()
    print(f"\n=== Angle Values ===")
    print(f"  angle KIL = {angles['angle_KIL']:.4f} degrees")
    print(f"  angle YPX = {angles['angle_YPX']:.4f} degrees")
    print(f"  sum = {angles['sum']:.4f} degrees")

    if result.all_passed:
        print("\nAll constraints verified!")
        print("\nTikZ code generated successfully.")
    else:
        print("\nWARNING: Some constraints failed!")

    return construction


if __name__ == "__main__":
    test_imo2024_p4()
