"""
Geometry System - Problem-Specific Constructions
================================================
Pre-built constructions for competition problems.

Available:
- IMO2023P2Construction: IMO 2023 Problem 2 (13 constraints)
- IMO2024P4Construction: IMO 2024 Problem 4 (10 constraints)
"""

from .imo2023_p2 import IMO2023P2Construction
from .imo2024_p4 import IMO2024P4Construction

__all__ = ['IMO2023P2Construction', 'IMO2024P4Construction']
