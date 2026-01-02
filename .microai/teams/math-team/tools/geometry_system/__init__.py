"""
Geometry Drawing System
=======================

A constraint-based geometry system for creating mathematically correct figures.

Architecture:
- core/primitives.py: Point, Line, Circle classes with verification
- constructions/standard.py: Exact geometric constructions
- output/tikz_generator.py: TikZ code generation
- problems/: Problem-specific constructions (IMO, etc.)

Design Philosophy:
1. Constraint Satisfaction > Coordinate Assignment
2. Verification at Every Step
3. Exact Formulas from First Principles
4. Dependency-Ordered Construction

New in v2.0:
- arc_midpoint_containing: Find arc midpoint on correct side
- circle_circle_intersection: Two-circle intersection
- parallel_line_through: Parallel line construction
- IMO2023P2Construction: Full IMO 2023/2 construction with 13 constraints
"""

from .core import Point, Line, Circle, Segment, VerificationResult, TOLERANCE
from .constructions import GeometryConstructions
from .problems import IMO2023P2Construction

__version__ = "2.0.0"

__all__ = [
    'Point', 'Line', 'Circle', 'Segment',
    'VerificationResult', 'TOLERANCE',
    'GeometryConstructions',
    'IMO2023P2Construction',
]
