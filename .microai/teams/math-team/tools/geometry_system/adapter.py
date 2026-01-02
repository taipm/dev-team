"""
Geometry System Adapter for Math Team
=====================================
Bridge between Math Team signals and Geometry System.

This adapter:
1. Receives geometry problem data from solvers
2. Constructs the figure using exact formulas
3. Verifies all constraints
4. Returns TikZ code for LaTeX Editor
"""

from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass
from enum import Enum

from .core import Point, Circle, Line, VerificationResult, TOLERANCE
from .constructions import GeometryConstructions
from .solver import GeometryVerifier
from .output import TikZGenerator, TikZStyle


class FigureType(Enum):
    """Types of geometry figures supported."""
    TRIANGLE_BASIC = "triangle_basic"
    TRIANGLE_CIRCUMCIRCLE = "triangle_circumcircle"
    TRIANGLE_ORTHOCENTER = "triangle_orthocenter"
    TRIANGLE_NINE_POINT = "triangle_nine_point"
    TRIANGLE_FULL = "triangle_full"  # All of the above
    CYCLIC_QUADRILATERAL = "cyclic_quadrilateral"
    CUSTOM = "custom"


@dataclass
class GeometryRequest:
    """Request to generate a geometry figure."""
    figure_type: FigureType
    vertices: Dict[str, Tuple[float, float]]  # name -> (x, y)
    options: Dict[str, Any] = None

    # Optional: specific points to highlight
    highlight_points: List[str] = None

    # Optional: additional constructions
    show_altitudes: bool = True
    show_circumcircle: bool = True
    show_nine_point_circle: bool = True
    show_orthic_triangle: bool = True
    show_right_angles: bool = True


@dataclass
class GeometryResponse:
    """Response from geometry system."""
    success: bool
    tikz_code: str
    verification_report: str
    points: Dict[str, Tuple[float, float]]  # All computed points
    errors: List[str] = None


class GeometryAdapter:
    """
    Adapter to integrate Geometry System with Math Team workflow.

    Usage:
        adapter = GeometryAdapter()
        response = adapter.create_orthocenter_figure(
            A=(0.5, 3.8), B=(-1.5, 0), C=(4.0, 0)
        )
        if response.success:
            tikz_code = response.tikz_code
    """

    def __init__(self, scale: float = 1.2):
        self.scale = scale
        self.verifier = None
        self.points = {}
        self.circles = {}

    def create_orthocenter_figure(
        self,
        A: Tuple[float, float],
        B: Tuple[float, float],
        C: Tuple[float, float],
        include_nine_point: bool = True,
        include_point_K: bool = True,
        extra_points: Dict[str, str] = None
    ) -> GeometryResponse:
        """
        Create complete orthocenter configuration figure.

        Args:
            A, B, C: Coordinates of triangle vertices
            include_nine_point: Whether to draw nine-point circle
            include_point_K: Whether to compute K (AD ∩ circumcircle)
            extra_points: Additional points to compute {"S": "nine_point_DI", ...}

        Returns:
            GeometryResponse with TikZ code and verification
        """
        try:
            # Create points
            pA = Point("A", A[0], A[1])
            pB = Point("B", B[0], B[1])
            pC = Point("C", C[0], C[1])

            self.points = {"A": pA, "B": pB, "C": pC}

            # === CONSTRUCTIONS ===

            # Circumcircle
            O, R = GeometryConstructions.circumcircle(pA, pB, pC)
            circumcircle = Circle("Gamma", O, R)
            self.points["O"] = O
            self.circles["circumcircle"] = circumcircle

            # Orthocenter
            H = GeometryConstructions.orthocenter(pA, pB, pC)
            self.points["H"] = H

            # Altitude feet
            D = GeometryConstructions.altitude_foot(pA, pB, pC, "D")
            E = GeometryConstructions.altitude_foot(pB, pA, pC, "E")
            F = GeometryConstructions.altitude_foot(pC, pA, pB, "F")
            self.points.update({"D": D, "E": E, "F": F})

            # Midpoint of BC
            I = GeometryConstructions.midpoint(pB, pC, "I")
            self.points["I"] = I

            # K = second intersection of AD with circumcircle
            if include_point_K:
                K = GeometryConstructions.second_intersection_line_circle(
                    pA, D, O, R, "K"
                )
                self.points["K"] = K

            # Nine-point circle
            if include_nine_point:
                N, r = GeometryConstructions.nine_point_circle(pA, pB, pC)
                nine_point = Circle("omega", N, r)
                self.points["N"] = N
                self.circles["nine_point"] = nine_point

            # === VERIFICATION ===
            self.verifier = GeometryVerifier()

            # Verify circumcircle
            points_on_circum = [pA, pB, pC]
            if include_point_K:
                points_on_circum.append(self.points["K"])
            self.verifier.verify_points_on_circle(points_on_circum, circumcircle)

            # Verify collinearity of altitude feet
            self.verifier.verify_collinear(pB, D, pC)
            self.verifier.verify_collinear(pA, E, pC)
            self.verifier.verify_collinear(pA, F, pB)

            # Verify right angles
            self.verifier.verify_right_angle(D, pA, pC)
            self.verifier.verify_right_angle(E, pB, pA)
            self.verifier.verify_right_angle(F, pC, pB)

            # Verify nine-point circle
            if include_nine_point:
                self.verifier.verify_points_on_circle(
                    [D, E, F, I],
                    self.circles["nine_point"]
                )

            if not self.verifier.is_all_passed():
                return GeometryResponse(
                    success=False,
                    tikz_code="",
                    verification_report=self.verifier.get_report(),
                    points={},
                    errors=["Verification failed"]
                )

            # === GENERATE TikZ ===
            tikz_code = self._generate_tikz(
                include_nine_point=include_nine_point,
                include_point_K=include_point_K
            )

            # Convert points to dict of tuples
            points_dict = {
                name: (p.x, p.y) for name, p in self.points.items()
            }

            return GeometryResponse(
                success=True,
                tikz_code=tikz_code,
                verification_report=self.verifier.get_report(),
                points=points_dict
            )

        except Exception as e:
            return GeometryResponse(
                success=False,
                tikz_code="",
                verification_report="",
                points={},
                errors=[str(e)]
            )

    def _generate_tikz(
        self,
        include_nine_point: bool = True,
        include_point_K: bool = True
    ) -> str:
        """Generate TikZ code from computed geometry."""

        gen = TikZGenerator(scale=self.scale)
        gen.begin("Triangle with orthocenter - VERIFIED by Geometry System")

        pA = self.points["A"]
        pB = self.points["B"]
        pC = self.points["C"]

        # Circumcircle
        gen.add_comment("Circumcircle (O)")
        gen.add_circle(self.circles["circumcircle"], color="blue!70")

        # Nine-point circle
        if include_nine_point and "nine_point" in self.circles:
            gen.add_comment("Nine-point circle")
            gen.add_circle(self.circles["nine_point"],
                          color="purple!70", dashed=True)

        # Triangle
        gen.add_comment("Triangle ABC")
        gen.add_triangle(pA, pB, pC, color="red!70!black")

        # Altitudes
        gen.add_comment("Altitudes")
        gen.add_segment(pA, self.points["D"], color="cyan!70!black")
        gen.add_segment(pB, self.points["E"], color="cyan!70!black")
        gen.add_segment(pC, self.points["F"], color="cyan!70!black")

        # Extension to K
        if include_point_K and "K" in self.points:
            gen.add_segment(self.points["D"], self.points["K"],
                           color="cyan!70!black", dashed=True)

        # Orthic triangle
        gen.add_comment("Orthic triangle DEF")
        gen.add_segment(self.points["D"], self.points["E"],
                       color="green!50!black")
        gen.add_segment(self.points["E"], self.points["F"],
                       color="green!50!black")
        gen.add_segment(self.points["F"], self.points["D"],
                       color="green!50!black")

        # Right angle marks
        gen.add_comment("Right angle marks")
        gen.add_right_angle_mark(self.points["D"], pA, pC)
        gen.add_right_angle_mark(self.points["E"], pB, pA)
        gen.add_right_angle_mark(self.points["F"], pC, pB)

        # Points
        gen.add_comment("Vertices")
        gen.add_point(pA, style=TikZStyle.VERTEX, label_pos="above")
        gen.add_point(pB, style=TikZStyle.VERTEX, label_pos="below left")
        gen.add_point(pC, style=TikZStyle.VERTEX, label_pos="below right")

        gen.add_comment("Altitude feet")
        gen.add_point(self.points["D"], style=TikZStyle.ALTITUDE_FOOT,
                     label_pos="below")
        gen.add_point(self.points["E"], style=TikZStyle.ALTITUDE_FOOT,
                     label_pos="right")
        gen.add_point(self.points["F"], style=TikZStyle.ALTITUDE_FOOT,
                     label_pos="left")

        gen.add_comment("Special points")
        gen.add_point(self.points["H"], style=TikZStyle.CENTER,
                     label_pos="above right")
        gen.add_point(self.points["I"],
                     style="fill=black, circle, inner sep=1.5pt",
                     label_pos="below")

        if include_point_K and "K" in self.points:
            gen.add_point(self.points["K"], style=TikZStyle.CENTER,
                         label_pos="below")

        gen.add_comment("Centers")
        gen.add_point(self.points["O"],
                     style="draw=blue!70, fill=white, circle, inner sep=1.5pt",
                     label_pos="right")

        if include_nine_point and "N" in self.points:
            gen.add_point(self.points["N"],
                         style="draw=purple!70, fill=white, circle, inner sep=1pt",
                         label_pos="left")

        return gen.end()

    def get_point_coordinates(self) -> Dict[str, Tuple[float, float]]:
        """Get all computed point coordinates."""
        return {name: (p.x, p.y) for name, p in self.points.items()}

    def get_latex_table(self) -> str:
        """Generate LaTeX table of point coordinates."""
        lines = [
            "\\begin{tabular}{|l|l|l|}",
            "\\hline",
            "\\textbf{Điểm} & \\textbf{Tọa độ} & \\textbf{Vai trò} \\\\",
            "\\hline"
        ]

        roles = {
            "A": "Đỉnh tam giác",
            "B": "Đỉnh tam giác",
            "C": "Đỉnh tam giác",
            "O": "Tâm đường tròn ngoại tiếp",
            "H": "Trực tâm",
            "D": "Chân đường cao từ A",
            "E": "Chân đường cao từ B",
            "F": "Chân đường cao từ C",
            "I": "Trung điểm BC",
            "K": "Giao điểm AD với (O)",
            "N": "Tâm đường tròn 9 điểm"
        }

        for name, point in self.points.items():
            role = roles.get(name, "")
            lines.append(
                f"${name}$ & $({point.x:.4f}, {point.y:.4f})$ & {role} \\\\"
            )

        lines.extend(["\\hline", "\\end{tabular}"])
        return "\n".join(lines)


# Convenience function for Math Team integration
def create_geometry_figure(
    problem_type: str,
    vertices: Dict[str, Tuple[float, float]],
    options: Dict[str, Any] = None
) -> GeometryResponse:
    """
    Main entry point for Math Team to create geometry figures.

    Args:
        problem_type: Type of geometry problem
        vertices: Dictionary of vertex coordinates
        options: Additional options

    Returns:
        GeometryResponse with TikZ code

    Example:
        response = create_geometry_figure(
            problem_type="orthocenter",
            vertices={"A": (0.5, 3.8), "B": (-1.5, 0), "C": (4.0, 0)},
            options={"include_nine_point": True}
        )
    """
    adapter = GeometryAdapter()

    if problem_type in ["orthocenter", "nine_point", "triangle_full"]:
        return adapter.create_orthocenter_figure(
            A=vertices["A"],
            B=vertices["B"],
            C=vertices["C"],
            include_nine_point=options.get("include_nine_point", True) if options else True,
            include_point_K=options.get("include_point_K", True) if options else True
        )

    # Add more problem types as needed
    return GeometryResponse(
        success=False,
        tikz_code="",
        verification_report="",
        points={},
        errors=[f"Unknown problem type: {problem_type}"]
    )
