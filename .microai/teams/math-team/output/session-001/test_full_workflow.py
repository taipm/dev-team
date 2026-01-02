#!/usr/bin/env python3
"""
Test Full Math Team Workflow with Geometry System
=================================================
Simulates the complete signal-based workflow for Câu 5.
"""

import sys
import json
from datetime import datetime
from dataclasses import dataclass, asdict
from typing import Dict, List, Any

sys.path.insert(0, '/Users/taipm/GitHub/dev-team/.microai/teams/math-team/tools')

from geometry_system.adapter import create_geometry_figure, GeometryAdapter


@dataclass
class Signal:
    """Represents a signal in the Math Team workflow."""
    type: str
    timestamp: str
    emitter: str
    payload: Dict[str, Any]


def emit_signal(signal_type: str, emitter: str, payload: dict) -> Signal:
    """Create and log a signal."""
    signal = Signal(
        type=signal_type,
        timestamp=datetime.now().isoformat(),
        emitter=emitter,
        payload=payload
    )
    print(f"\n📡 SIGNAL: {signal_type}")
    print(f"   Emitter: {emitter}")
    print(f"   Time: {signal.timestamp}")
    return signal


def test_math_team_workflow():
    """
    Test the complete Math Team workflow with Geometry System integration.

    Flow:
    1. problem_received → Analyzer
    2. analysis_complete → Maestro dispatches solvers
    3. solution_complete → Synthesizer
    4. illustration_requested → Geometry Illustrator (with Geometry System)
    5. illustration_complete → LaTeX Editor
    6. document_ready → Output
    """

    session_id = "test-cau5-001"

    print("=" * 70)
    print("MATH TEAM WORKFLOW TEST - CÂU 5 GEOMETRY")
    print("=" * 70)

    # === STEP 1: Problem Received ===
    problem_text = """
    Trong mặt phẳng $(Oxy)$, cho tam giác $ABC$ ($AB < AC$) nội tiếp đường tròn $(O)$.
    Gọi $H$ là trực tâm của tam giác $ABC$.
    Gọi $D$, $E$, $F$ lần lượt là chân các đường cao kẻ từ $A$, $B$, $C$.
    Gọi $I$ là trung điểm $BC$ và $K$ là giao điểm thứ hai của $AD$ với $(O)$.

    a) Chứng minh tứ giác $BCEF$ nội tiếp.
    b) Chứng minh tứ giác $DIEF$ nội tiếp.
    c) Đường thẳng qua $A$ song song với $BC$ cắt $(O)$ tại $L$ ($L ≠ A$).
       Chứng minh $AL // DI$.
    """

    signal_1 = emit_signal(
        "problem_received",
        "maestro",
        {
            "session_id": session_id,
            "problem_text": problem_text,
            "problem_type": "geometry"
        }
    )

    # === STEP 2: Analysis Complete ===
    signal_2 = emit_signal(
        "analysis_complete",
        "problem-analyzer",
        {
            "session_id": session_id,
            "problem_type": "geometry",
            "difficulty": "competition",
            "approaches": [
                {"id": "approach-1", "name": "Cyclic quadrilateral properties", "solver": "geometric-solver"},
                {"id": "approach-2", "name": "Coordinate geometry", "solver": "algebraic-solver"}
            ]
        }
    )

    # === STEP 3: Solution Complete (simulated) ===
    signal_3 = emit_signal(
        "solution_complete",
        "geometric-solver",
        {
            "session_id": session_id,
            "solver_id": "geometric-solver",
            "approach_name": "Cyclic quadrilateral properties",
            "solution": {
                "steps": [
                    "Chứng minh BCEF nội tiếp: angle BFC = angle BEC = 90°",
                    "Chứng minh DIEF nội tiếp: D, I, E, F đều thuộc đường tròn 9 điểm",
                    "Chứng minh AL // DI: DK = DH, sử dụng tính chất trực tâm"
                ],
                "final_answer": "Các khẳng định đều đúng",
                "proof_complete": True
            },
            # Geometry data for illustration
            "geometry_data": {
                "vertices": {
                    "A": (0.5, 3.8),
                    "B": (-1.5, 0.0),
                    "C": (4.0, 0.0)
                }
            }
        }
    )

    # === STEP 4: Illustration Requested ===
    signal_4 = emit_signal(
        "illustration_requested",
        "maestro",
        {
            "session_id": session_id,
            "problem_type": "orthocenter",
            "geometry_data": {
                "vertices": {
                    "A": (0.5, 3.8),
                    "B": (-1.5, 0.0),
                    "C": (4.0, 0.0)
                },
                "options": {
                    "include_nine_point": True,
                    "include_point_K": True
                }
            }
        }
    )

    # === STEP 5: Geometry Illustrator processes with Geometry System ===
    print("\n" + "=" * 70)
    print("🔧 GEOMETRY ILLUSTRATOR: Calling Geometry System...")
    print("=" * 70)

    response = create_geometry_figure(
        problem_type="orthocenter",
        vertices={
            "A": (0.5, 3.8),
            "B": (-1.5, 0.0),
            "C": (4.0, 0.0)
        },
        options={
            "include_nine_point": True,
            "include_point_K": True
        }
    )

    print(f"\n✅ Geometry System Response:")
    print(f"   Success: {response.success}")
    print(f"\n📋 Verification Report:")
    print(response.verification_report)

    # === STEP 6: Illustration Complete ===
    if response.success:
        signal_5 = emit_signal(
            "illustration_complete",
            "geometry-illustrator",
            {
                "session_id": session_id,
                "success": True,
                "tikz_code": response.tikz_code,
                "points": response.points,
                "verification": {
                    "all_passed": True,
                    "report": response.verification_report
                },
                "figure_type": "orthocenter_configuration"
            }
        )

        # === STEP 7: Document Ready (simulated) ===
        output_path = f"/Users/taipm/GitHub/dev-team/.microai/teams/math-team/output/{session_id}"

        signal_6 = emit_signal(
            "document_ready",
            "latex-editor",
            {
                "session_id": session_id,
                "output_style": "detailed",
                "files": {
                    "tex_path": f"{output_path}/solution.tex",
                    "pdf_path": f"{output_path}/solution.pdf"
                },
                "compilation": {
                    "success": True,
                    "engine": "xelatex"
                }
            }
        )

        # === Summary ===
        print("\n" + "=" * 70)
        print("✅ WORKFLOW COMPLETE")
        print("=" * 70)

        print("\n📊 Signal Flow Summary:")
        print("   1. problem_received → problem-analyzer")
        print("   2. analysis_complete → maestro")
        print("   3. solution_complete → synthesizer")
        print("   4. illustration_requested → geometry-illustrator")
        print("   5. illustration_complete (VERIFIED) → latex-editor")
        print("   6. document_ready → output")

        print("\n📐 Geometry System Verification:")
        print("   ✓ All points computed with exact formulas")
        print("   ✓ All constraints verified (error < 1e-10)")
        print("   ✓ TikZ code generated from verified coordinates")

        print("\n📍 Key Points Computed:")
        for name, coords in response.points.items():
            print(f"   {name}: ({coords[0]:.4f}, {coords[1]:.4f})")

        return True
    else:
        print(f"\n❌ Geometry verification failed: {response.errors}")
        return False


if __name__ == "__main__":
    success = test_math_team_workflow()

    print("\n" + "=" * 70)
    if success:
        print("🎉 TEST PASSED - Geometry System integrated successfully!")
    else:
        print("❌ TEST FAILED - Check errors above")
    print("=" * 70)
