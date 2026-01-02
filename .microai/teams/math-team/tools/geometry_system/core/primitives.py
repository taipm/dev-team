"""
Geometry System - Core Primitives
=================================
Mathematical primitives with exact computations.

Design Principles (from Deep Thinking Analysis):
1. Objects represent relationships, not just coordinates
2. Verification built-in at every level
3. Clear separation: construction vs rendering
"""

from dataclasses import dataclass, field
from typing import Optional, Tuple, List
import math

# Numerical tolerance for floating-point comparisons
TOLERANCE = 1e-10


@dataclass
class Point:
    """A point in 2D Euclidean space."""
    name: str
    x: float
    y: float

    def distance_to(self, other: 'Point') -> float:
        """Euclidean distance to another point."""
        return math.sqrt((self.x - other.x)**2 + (self.y - other.y)**2)

    def __repr__(self) -> str:
        return f"Point({self.name}, {self.x:.6f}, {self.y:.6f})"


@dataclass
class Circle:
    """A circle defined by center and radius."""
    name: str
    center: Point
    radius: float

    def contains_point(self, p: Point, tolerance: float = TOLERANCE) -> bool:
        """Check if point lies on circle (within tolerance)."""
        dist = self.center.distance_to(p)
        return abs(dist - self.radius) < tolerance

    def point_distance_error(self, p: Point) -> float:
        """Return signed error: distance from p to circle."""
        return self.center.distance_to(p) - self.radius

    def __repr__(self) -> str:
        return f"Circle({self.name}, center={self.center.name}, r={self.radius:.6f})"


@dataclass
class Line:
    """
    A line in 2D, represented in general form: ax + by + c = 0
    where (a,b) is the normal vector (normalized: a² + b² = 1)
    """
    name: str
    a: float  # coefficient of x
    b: float  # coefficient of y
    c: float  # constant term

    @classmethod
    def from_two_points(cls, name: str, p1: Point, p2: Point) -> 'Line':
        """Create line through two points."""
        dx = p2.x - p1.x
        dy = p2.y - p1.y

        # Normal vector is perpendicular to direction
        a, b = -dy, dx

        # Normalize
        norm = math.sqrt(a*a + b*b)
        if norm < TOLERANCE:
            raise ValueError(f"Points {p1.name} and {p2.name} are the same")
        a, b = a/norm, b/norm

        # c = -(ax₁ + by₁)
        c = -(a * p1.x + b * p1.y)

        return cls(name, a, b, c)

    @classmethod
    def perpendicular_through(cls, name: str, point: Point, line: 'Line') -> 'Line':
        """Create line perpendicular to given line, passing through point."""
        # Perpendicular has normal vector (b, -a) if original has (a, b)
        a, b = line.b, -line.a
        c = -(a * point.x + b * point.y)
        return cls(name, a, b, c)

    def contains_point(self, p: Point, tolerance: float = TOLERANCE) -> bool:
        """Check if point lies on line."""
        return abs(self.a * p.x + self.b * p.y + self.c) < tolerance

    def point_distance(self, p: Point) -> float:
        """Signed distance from point to line."""
        return self.a * p.x + self.b * p.y + self.c

    def __repr__(self) -> str:
        return f"Line({self.name}: {self.a:.4f}x + {self.b:.4f}y + {self.c:.4f} = 0)"


@dataclass
class Segment:
    """A line segment between two points."""
    name: str
    p1: Point
    p2: Point

    @property
    def length(self) -> float:
        return self.p1.distance_to(self.p2)

    @property
    def midpoint(self) -> Tuple[float, float]:
        return ((self.p1.x + self.p2.x) / 2, (self.p1.y + self.p2.y) / 2)


class VerificationResult:
    """Result of verifying geometric constraints."""

    def __init__(self):
        self.checks: List[Tuple[str, bool, float]] = []  # (description, passed, error)

    def add_check(self, description: str, passed: bool, error: float = 0.0):
        self.checks.append((description, passed, error))

    @property
    def all_passed(self) -> bool:
        return all(passed for _, passed, _ in self.checks)

    def report(self) -> str:
        lines = ["=== VERIFICATION REPORT ==="]
        for desc, passed, error in self.checks:
            status = "✓" if passed else "✗"
            lines.append(f"  {status} {desc}: error = {error:.2e}")

        overall = "ALL PASSED" if self.all_passed else "SOME FAILED"
        lines.append(f"\nResult: {overall}")
        return "\n".join(lines)
