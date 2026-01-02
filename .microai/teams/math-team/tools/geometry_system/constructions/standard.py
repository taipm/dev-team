"""
Geometry System - Standard Constructions
========================================
Exact geometric constructions using mathematical formulas.

Each construction:
1. Takes geometric objects as input
2. Returns new objects with EXACT coordinates
3. Uses formulas derived from first principles
"""

import math
from typing import Tuple, Optional
from ..core.primitives import Point, Line, Circle, TOLERANCE


class GeometryConstructions:
    """
    Standard geometric constructions with exact formulas.

    All formulas are derived from mathematical definitions,
    not approximations or iterative methods.
    """

    @staticmethod
    def midpoint(p1: Point, p2: Point, name: str = "M") -> Point:
        """
        Midpoint of segment P1P2.

        Formula: M = (P1 + P2) / 2
        """
        return Point(name, (p1.x + p2.x) / 2, (p1.y + p2.y) / 2)

    @staticmethod
    def circumcircle(A: Point, B: Point, C: Point) -> Tuple[Point, float]:
        """
        Circumcircle of triangle ABC.

        Returns: (center O, radius R)

        Formula derived from:
        O is equidistant from A, B, C
        => O lies on perpendicular bisectors of AB and BC
        """
        ax, ay = A.x, A.y
        bx, by = B.x, B.y
        cx, cy = C.x, C.y

        # Check for collinearity
        d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
        if abs(d) < TOLERANCE:
            raise ValueError("Points A, B, C are collinear - no circumcircle exists")

        # Circumcenter coordinates (exact formula)
        ux = ((ax*ax + ay*ay) * (by - cy) +
              (bx*bx + by*by) * (cy - ay) +
              (cx*cx + cy*cy) * (ay - by)) / d

        uy = ((ax*ax + ay*ay) * (cx - bx) +
              (bx*bx + by*by) * (ax - cx) +
              (cx*cx + cy*cy) * (bx - ax)) / d

        center = Point("O", ux, uy)
        radius = math.sqrt((ax - ux)**2 + (ay - uy)**2)

        return center, radius

    @staticmethod
    def orthocenter(A: Point, B: Point, C: Point) -> Point:
        """
        Orthocenter of triangle ABC.

        The orthocenter H is the intersection of altitudes.

        Formula derived from:
        - Altitude from A is perpendicular to BC
        - Altitude from B is perpendicular to AC
        - Solve the linear system
        """
        ax, ay = A.x, A.y
        bx, by = B.x, B.y
        cx, cy = C.x, C.y

        # Direction of BC: (cx - bx, cy - by)
        # Altitude from A has direction perpendicular to BC: (cy - by, -(cx - bx))
        # Line through A with this direction: parametric form

        # Line 1 (altitude from A): (cx-bx)(x-ax) + (cy-by)(y-ay) = 0
        # Line 2 (altitude from B): (cx-ax)(x-bx) + (cy-ay)(y-by) = 0

        a1, b1 = cx - bx, cy - by
        c1 = a1 * ax + b1 * ay

        a2, b2 = cx - ax, cy - ay
        c2 = a2 * bx + b2 * by

        det = a1 * b2 - a2 * b1
        if abs(det) < TOLERANCE:
            raise ValueError("Cannot compute orthocenter - degenerate triangle")

        hx = (c1 * b2 - c2 * b1) / det
        hy = (a1 * c2 - a2 * c1) / det

        return Point("H", hx, hy)

    @staticmethod
    def altitude_foot(vertex: Point, side_p1: Point, side_p2: Point,
                      name: str = "D") -> Point:
        """
        Foot of altitude from vertex to line through side_p1 and side_p2.

        Formula: orthogonal projection of vertex onto line.
        """
        vx, vy = vertex.x, vertex.y
        p1x, p1y = side_p1.x, side_p1.y
        p2x, p2y = side_p2.x, side_p2.y

        # Direction vector of the side
        dx, dy = p2x - p1x, p2y - p1y
        length_sq = dx*dx + dy*dy

        if length_sq < TOLERANCE:
            raise ValueError("Side endpoints are the same point")

        # Parameter t for projection point
        # P = P1 + t * (P2 - P1), where P is the foot
        t = ((vx - p1x) * dx + (vy - p1y) * dy) / length_sq

        foot_x = p1x + t * dx
        foot_y = p1y + t * dy

        return Point(name, foot_x, foot_y)

    @staticmethod
    def nine_point_circle(A: Point, B: Point, C: Point) -> Tuple[Point, float]:
        """
        Nine-point circle of triangle ABC.

        The nine-point circle passes through:
        1. Midpoints of sides (3 points)
        2. Feet of altitudes (3 points)
        3. Midpoints from vertices to orthocenter (3 points)

        Properties:
        - Center N is midpoint of segment OH (circumcenter to orthocenter)
        - Radius = R/2 (half of circumradius)
        """
        # Get circumcircle
        O, R = GeometryConstructions.circumcircle(A, B, C)

        # Get orthocenter
        H = GeometryConstructions.orthocenter(A, B, C)

        # Nine-point center is midpoint of OH
        nx = (O.x + H.x) / 2
        ny = (O.y + H.y) / 2
        N = Point("N", nx, ny)

        # Nine-point radius is R/2
        r = R / 2

        return N, r

    @staticmethod
    def line_intersection(L1_p1: Point, L1_p2: Point,
                          L2_p1: Point, L2_p2: Point,
                          name: str = "P") -> Optional[Point]:
        """
        Intersection of two lines.

        Returns None if lines are parallel.
        """
        x1, y1 = L1_p1.x, L1_p1.y
        x2, y2 = L1_p2.x, L1_p2.y
        x3, y3 = L2_p1.x, L2_p1.y
        x4, y4 = L2_p2.x, L2_p2.y

        denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

        if abs(denom) < TOLERANCE:
            return None  # Parallel lines

        t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom

        ix = x1 + t * (x2 - x1)
        iy = y1 + t * (y2 - y1)

        return Point(name, ix, iy)

    @staticmethod
    def line_circle_intersection(line_p1: Point, line_p2: Point,
                                  circle_center: Point, radius: float) -> Tuple[Optional[Point], Optional[Point]]:
        """
        Intersection of line (through line_p1 and line_p2) with circle.

        Returns: (point1, point2) or (point1, None) if tangent, or (None, None) if no intersection
        """
        # Translate so circle center is at origin
        p1x = line_p1.x - circle_center.x
        p1y = line_p1.y - circle_center.y
        p2x = line_p2.x - circle_center.x
        p2y = line_p2.y - circle_center.y

        # Line direction
        dx = p2x - p1x
        dy = p2y - p1y

        # Quadratic coefficients for |P1 + t*D|² = r²
        a = dx*dx + dy*dy
        b = 2 * (p1x * dx + p1y * dy)
        c = p1x*p1x + p1y*p1y - radius*radius

        discriminant = b*b - 4*a*c

        if discriminant < -TOLERANCE:
            return None, None  # No intersection

        if abs(discriminant) < TOLERANCE:
            # Tangent - one point
            t = -b / (2*a)
            x = line_p1.x + t * (line_p2.x - line_p1.x)
            y = line_p1.y + t * (line_p2.y - line_p1.y)
            return Point("K1", x, y), None

        # Two intersection points
        sqrt_disc = math.sqrt(discriminant)
        t1 = (-b - sqrt_disc) / (2*a)
        t2 = (-b + sqrt_disc) / (2*a)

        x1 = line_p1.x + t1 * (line_p2.x - line_p1.x)
        y1 = line_p1.y + t1 * (line_p2.y - line_p1.y)

        x2 = line_p1.x + t2 * (line_p2.x - line_p1.x)
        y2 = line_p1.y + t2 * (line_p2.y - line_p1.y)

        return Point("K1", x1, y1), Point("K2", x2, y2)

    @staticmethod
    def second_intersection_line_circle(known_point: Point,
                                         other_point: Point,
                                         circle_center: Point,
                                         radius: float,
                                         name: str = "K") -> Point:
        """
        Find the second intersection of a line with a circle,
        given that we already know one intersection point.

        This is useful for finding K = second intersection of AD with circumcircle,
        when we know A is already on the circle.
        """
        p1, p2 = GeometryConstructions.line_circle_intersection(
            known_point, other_point, circle_center, radius
        )

        if p1 is None:
            raise ValueError("Line does not intersect circle")

        # Return the point that is NOT the known_point
        if p1 is not None and known_point.distance_to(p1) > TOLERANCE:
            p1.name = name
            return p1
        elif p2 is not None:
            p2.name = name
            return p2
        else:
            raise ValueError("Could not find second intersection")

    @staticmethod
    def centroid(A: Point, B: Point, C: Point) -> Point:
        """
        Centroid of triangle ABC.

        Formula: G = (A + B + C) / 3
        """
        return Point("G",
                     (A.x + B.x + C.x) / 3,
                     (A.y + B.y + C.y) / 3)

    @staticmethod
    def arc_midpoint_containing(B: Point, C: Point,
                                 center: Point, radius: float,
                                 reference_point: Point,
                                 name: str = "S") -> Point:
        """
        Find midpoint of arc BC on circle that contains the reference point.

        The arc midpoint lies on:
        1. The perpendicular bisector of BC
        2. The circle

        We choose the intersection on the same side of BC as the reference point.

        Args:
            B, C: Endpoints of the arc
            center, radius: Circle definition
            reference_point: Point determining which arc (e.g., point A for arc containing A)
            name: Name for the result point

        Returns:
            Point at the arc midpoint
        """
        # Midpoint of BC
        mx = (B.x + C.x) / 2
        my = (B.y + C.y) / 2

        # Direction perpendicular to BC (along the perpendicular bisector)
        bcx = C.x - B.x
        bcy = C.y - B.y

        # Perpendicular direction (normalized)
        perp_len = math.sqrt(bcx*bcx + bcy*bcy)
        if perp_len < TOLERANCE:
            raise ValueError("B and C are the same point")

        perpx = -bcy / perp_len
        perpy = bcx / perp_len

        # Find where perpendicular bisector intersects circle
        # Parametric: P = M + t * perp
        # |P - O|² = R²
        # |M + t*perp - O|² = R²

        wx = mx - center.x
        wy = my - center.y

        # Quadratic: t² + 2t(w·perp) + |w|² - R² = 0
        a = 1  # |perp|² = 1
        b = 2 * (wx * perpx + wy * perpy)
        c = wx*wx + wy*wy - radius*radius

        disc = b*b - 4*a*c
        if disc < -TOLERANCE:
            raise ValueError("Perpendicular bisector doesn't intersect circle")

        disc = max(0, disc)  # Handle numerical issues
        sqrt_disc = math.sqrt(disc)

        t1 = (-b + sqrt_disc) / (2*a)
        t2 = (-b - sqrt_disc) / (2*a)

        # Two candidate points
        s1x = mx + t1 * perpx
        s1y = my + t1 * perpy

        s2x = mx + t2 * perpx
        s2y = my + t2 * perpy

        # Choose the one on the same side of BC as the reference point
        def same_side(px, py, qx, qy, l1x, l1y, l2x, l2y) -> bool:
            """Check if P and Q are on the same side of line L1-L2."""
            dx = l2x - l1x
            dy = l2y - l1y
            cross1 = dx * (py - l1y) - dy * (px - l1x)
            cross2 = dx * (qy - l1y) - dy * (qx - l1x)
            return cross1 * cross2 > 0

        if same_side(s1x, s1y, reference_point.x, reference_point.y, B.x, B.y, C.x, C.y):
            return Point(name, s1x, s1y)
        else:
            return Point(name, s2x, s2y)

    @staticmethod
    def circle_circle_intersection(c1_center: Point, c1_radius: float,
                                    c2_center: Point, c2_radius: float,
                                    prefer_point: Point = None) -> Tuple[Optional[Point], Optional[Point]]:
        """
        Find intersection points of two circles.

        Args:
            c1_center, c1_radius: First circle
            c2_center, c2_radius: Second circle
            prefer_point: If given, order results so first point is closer to this

        Returns:
            (P1, P2) intersection points, or (P1, None) if tangent, or (None, None) if no intersection
        """
        # Distance between centers
        dx = c2_center.x - c1_center.x
        dy = c2_center.y - c1_center.y
        d = math.sqrt(dx*dx + dy*dy)

        if d < TOLERANCE:
            return None, None  # Concentric circles

        # Check for intersection
        if d > c1_radius + c2_radius + TOLERANCE:
            return None, None  # Too far apart
        if d < abs(c1_radius - c2_radius) - TOLERANCE:
            return None, None  # One inside the other

        # Distance from c1_center to the line connecting intersections
        # Using formula: a = (r1² - r2² + d²) / (2d)
        a = (c1_radius*c1_radius - c2_radius*c2_radius + d*d) / (2*d)

        # Height of intersection points from that line
        h_sq = c1_radius*c1_radius - a*a
        if h_sq < -TOLERANCE:
            return None, None
        h = math.sqrt(max(0, h_sq))

        # Point on line between centers, distance a from c1
        px = c1_center.x + a * dx / d
        py = c1_center.y + a * dy / d

        if h < TOLERANCE:
            # Tangent - one point
            return Point("P", px, py), None

        # Two intersection points
        # Perpendicular direction
        perp_x = -dy / d
        perp_y = dx / d

        p1 = Point("P1", px + h * perp_x, py + h * perp_y)
        p2 = Point("P2", px - h * perp_x, py - h * perp_y)

        # Order by preference
        if prefer_point is not None:
            d1 = prefer_point.distance_to(p1)
            d2 = prefer_point.distance_to(p2)
            if d2 < d1:
                p1, p2 = p2, p1

        return p1, p2

    @staticmethod
    def parallel_line_through(point: Point, line_p1: Point, line_p2: Point) -> Tuple[float, float, float]:
        """
        Create line through point parallel to line(p1, p2).

        Returns coefficients (a, b, c) for line ax + by + c = 0.
        """
        # Direction of original line
        dx = line_p2.x - line_p1.x
        dy = line_p2.y - line_p1.y

        # Normal vector (perpendicular to direction)
        a, b = -dy, dx

        # Normalize
        norm = math.sqrt(a*a + b*b)
        if norm < TOLERANCE:
            raise ValueError("Line endpoints are the same")
        a, b = a/norm, b/norm

        # c = -(ax + by) where (x,y) is the through point
        c = -(a * point.x + b * point.y)

        return a, b, c

    @staticmethod
    def point_on_line_at_y(line_p1: Point, line_p2: Point,
                           y_value: float, name: str = "P") -> Optional[Point]:
        """
        Find point on line with given y-coordinate.

        Returns None if line is horizontal.
        """
        dy = line_p2.y - line_p1.y

        if abs(dy) < TOLERANCE:
            return None  # Horizontal line

        # Parametric: P = P1 + t*(P2-P1)
        # y = y1 + t*(y2-y1) = y_value
        t = (y_value - line_p1.y) / dy

        x = line_p1.x + t * (line_p2.x - line_p1.x)

        return Point(name, x, y_value)

    @staticmethod
    def circumcircle_from_three_points(A: Point, B: Point, C: Point,
                                        name: str = "O") -> Tuple[Point, float]:
        """
        Alias for circumcircle, returning named center.
        """
        center, radius = GeometryConstructions.circumcircle(A, B, C)
        center.name = name
        return center, radius
