"""
Geometry System - Verification Framework
========================================
Verify that all geometric constraints are satisfied.
"""

from typing import List, Tuple
from ..core.primitives import Point, Circle, Line, VerificationResult, TOLERANCE


class GeometryVerifier:
    """
    Verify geometric constraints.

    Checks:
    1. Points on circles: |PO| = R
    2. Points on lines: ax + by + c = 0
    3. Perpendicularity: dot product = 0
    4. Nine-point circle passes through all 9 points
    """

    def __init__(self, tolerance: float = TOLERANCE):
        self.tolerance = tolerance
        self.result = VerificationResult()

    def verify_point_on_circle(self, point: Point, circle: Circle) -> bool:
        """Verify that point lies on circle."""
        error = abs(circle.point_distance_error(point))
        passed = error < self.tolerance

        self.result.add_check(
            f"{point.name} on circle {circle.name}",
            passed,
            error
        )
        return passed

    def verify_points_on_circle(self, points: List[Point], circle: Circle) -> bool:
        """Verify multiple points lie on circle."""
        all_passed = True
        for p in points:
            if not self.verify_point_on_circle(p, circle):
                all_passed = False
        return all_passed

    def verify_point_on_line(self, point: Point, line: Line) -> bool:
        """Verify that point lies on line."""
        error = abs(line.point_distance(point))
        passed = error < self.tolerance

        self.result.add_check(
            f"{point.name} on line {line.name}",
            passed,
            error
        )
        return passed

    def verify_perpendicular(self, line1: Line, line2: Line) -> bool:
        """Verify two lines are perpendicular."""
        # Perpendicular if normal vectors are perpendicular
        # n1 · n2 = 0
        dot = line1.a * line2.a + line1.b * line2.b
        error = abs(dot)
        passed = error < self.tolerance

        self.result.add_check(
            f"{line1.name} ⊥ {line2.name}",
            passed,
            error
        )
        return passed

    def verify_collinear(self, p1: Point, p2: Point, p3: Point) -> bool:
        """Verify three points are collinear."""
        # Area of triangle = 0 for collinear points
        area = abs((p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y)) / 2
        passed = area < self.tolerance

        self.result.add_check(
            f"{p1.name}, {p2.name}, {p3.name} collinear",
            passed,
            area
        )
        return passed

    def verify_right_angle(self, vertex: Point, p1: Point, p2: Point) -> bool:
        """Verify angle P1-Vertex-P2 is 90 degrees."""
        # Vectors from vertex to p1 and p2
        v1x, v1y = p1.x - vertex.x, p1.y - vertex.y
        v2x, v2y = p2.x - vertex.x, p2.y - vertex.y

        # Dot product should be 0 for perpendicular
        dot = v1x * v2x + v1y * v2y

        # Normalize by vector lengths for meaningful error
        len1 = (v1x*v1x + v1y*v1y) ** 0.5
        len2 = (v2x*v2x + v2y*v2y) ** 0.5

        if len1 < self.tolerance or len2 < self.tolerance:
            self.result.add_check(
                f"Right angle at {vertex.name}",
                False,
                float('inf')
            )
            return False

        # Cosine of angle
        cos_angle = dot / (len1 * len2)
        error = abs(cos_angle)  # Should be 0 for 90 degrees
        passed = error < self.tolerance

        self.result.add_check(
            f"Right angle at {vertex.name} ({p1.name}-{vertex.name}-{p2.name})",
            passed,
            error
        )
        return passed

    def verify_distance(self, p1: Point, p2: Point, expected: float) -> bool:
        """Verify distance between two points."""
        actual = p1.distance_to(p2)
        error = abs(actual - expected)
        passed = error < self.tolerance

        self.result.add_check(
            f"|{p1.name}{p2.name}| = {expected:.6f}",
            passed,
            error
        )
        return passed

    def verify_equal_distances(self, center: Point, points: List[Point]) -> bool:
        """Verify all points are equidistant from center."""
        if len(points) < 2:
            return True

        distances = [center.distance_to(p) for p in points]
        avg_dist = sum(distances) / len(distances)

        all_passed = True
        for p, d in zip(points, distances):
            error = abs(d - avg_dist)
            passed = error < self.tolerance

            self.result.add_check(
                f"|{center.name}{p.name}| = {avg_dist:.6f}",
                passed,
                error
            )
            if not passed:
                all_passed = False

        return all_passed

    def get_report(self) -> str:
        """Get verification report."""
        return self.result.report()

    def is_all_passed(self) -> bool:
        """Check if all verifications passed."""
        return self.result.all_passed
