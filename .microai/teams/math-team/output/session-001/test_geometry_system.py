#!/usr/bin/env python3
"""
Test Geometry System with Câu 5 Problem
========================================
Verify that all geometric constructions are correct.
"""

import sys
sys.path.insert(0, '/Users/taipm/GitHub/dev-team/.microai/teams/math-team/tools')

from geometry_system.core import Point, Circle
from geometry_system.constructions import GeometryConstructions
from geometry_system.solver import GeometryVerifier
from geometry_system.output import create_orthocenter_figure, TikZGenerator


def test_cau5_geometry():
    """
    Test with Câu 5 geometry problem:
    - Triangle ABC (AB < AC) inscribed in circle (O)
    - H is orthocenter
    - D, E, F are altitude feet
    - I is midpoint of BC
    - K is second intersection of AD with (O)
    """

    print("=" * 60)
    print("GEOMETRY SYSTEM TEST - CÂU 5")
    print("=" * 60)

    # === STEP 1: Define triangle ABC (AB < AC) ===
    # Choose coordinates that give AB < AC (scalene triangle)
    A = Point("A", 0.5, 3.8)
    B = Point("B", -1.5, 0.0)
    C = Point("C", 4.0, 0.0)

    print(f"\n1. Triangle vertices:")
    print(f"   A = ({A.x}, {A.y})")
    print(f"   B = ({B.x}, {B.y})")
    print(f"   C = ({C.x}, {C.y})")

    # Verify AB < AC
    AB = A.distance_to(B)
    AC = A.distance_to(C)
    print(f"   |AB| = {AB:.4f}, |AC| = {AC:.4f}")
    print(f"   AB < AC: {AB < AC}")

    # === STEP 2: Compute all derived points ===

    # Circumcircle
    O, R = GeometryConstructions.circumcircle(A, B, C)
    print(f"\n2. Circumcircle:")
    print(f"   O = ({O.x:.6f}, {O.y:.6f})")
    print(f"   R = {R:.6f}")

    # Orthocenter
    H = GeometryConstructions.orthocenter(A, B, C)
    print(f"\n3. Orthocenter:")
    print(f"   H = ({H.x:.6f}, {H.y:.6f})")

    # Altitude feet
    D = GeometryConstructions.altitude_foot(A, B, C, "D")
    E = GeometryConstructions.altitude_foot(B, A, C, "E")
    F = GeometryConstructions.altitude_foot(C, A, B, "F")
    print(f"\n4. Altitude feet:")
    print(f"   D = ({D.x:.6f}, {D.y:.6f})")
    print(f"   E = ({E.x:.6f}, {E.y:.6f})")
    print(f"   F = ({F.x:.6f}, {F.y:.6f})")

    # Midpoint I
    I = GeometryConstructions.midpoint(B, C, "I")
    print(f"\n5. Midpoint of BC:")
    print(f"   I = ({I.x:.6f}, {I.y:.6f})")

    # K = second intersection of AD with circumcircle
    K = GeometryConstructions.second_intersection_line_circle(A, D, O, R, "K")
    print(f"\n6. K (AD ∩ circumcircle):")
    print(f"   K = ({K.x:.6f}, {K.y:.6f})")

    # Nine-point circle
    N, r = GeometryConstructions.nine_point_circle(A, B, C)
    print(f"\n7. Nine-point circle:")
    print(f"   N = ({N.x:.6f}, {N.y:.6f})")
    print(f"   r = {r:.6f} (should be R/2 = {R/2:.6f})")

    # === STEP 3: VERIFICATION ===
    print("\n" + "=" * 60)
    print("VERIFICATION")
    print("=" * 60)

    circumcircle = Circle("Gamma", O, R)
    nine_point = Circle("omega", N, r)

    verifier = GeometryVerifier()

    # Verify points on circumcircle
    verifier.verify_points_on_circle([A, B, C, K], circumcircle)

    # Verify altitude feet
    verifier.verify_collinear(B, D, C)
    verifier.verify_collinear(A, E, C)
    verifier.verify_collinear(A, F, B)

    # Verify right angles
    verifier.verify_right_angle(D, A, C)
    verifier.verify_right_angle(E, B, A)
    verifier.verify_right_angle(F, C, B)

    # Verify nine-point circle
    verifier.verify_points_on_circle([D, E, F, I], nine_point)

    print(verifier.get_report())

    # === STEP 4: Generate TikZ ===
    print("\n" + "=" * 60)
    print("GENERATING TikZ CODE")
    print("=" * 60)

    tikz_code = create_orthocenter_figure(A, B, C, include_nine_point=True)

    # Create LaTeX document
    latex_doc = f"""\\documentclass[12pt,a4paper]{{article}}
\\usepackage{{tikz}}
\\usepackage{{fontspec}}
\\usepackage[vietnamese]{{babel}}
\\setmainfont{{Times New Roman}}
\\usepackage{{geometry}}
\\geometry{{margin=2cm}}
\\pagestyle{{empty}}

\\begin{{document}}

\\begin{{center}}
{{\\Large\\bfseries HÌNH VẼ CHÍNH XÁC - CÂU 5}}\\\\[0.5em]
{{\\normalsize Verified Geometry System}}
\\end{{center}}

\\begin{{figure}}[htbp]
\\centering
{tikz_code}
\\caption{{Tam giác $ABC$ với trực tâm $H$, đường tròn ngoại tiếp $(O)$, đường tròn 9 điểm}}
\\end{{figure}}

\\section*{{Kiểm chứng tọa độ}}

\\begin{{tabular}}{{|l|l|l|}}
\\hline
\\textbf{{Điểm}} & \\textbf{{Tọa độ}} & \\textbf{{Kiểm tra}} \\\\
\\hline
$A$ & $({A.x:.4f}, {A.y:.4f})$ & Định nghĩa \\\\
$B$ & $({B.x:.4f}, {B.y:.4f})$ & Định nghĩa \\\\
$C$ & $({C.x:.4f}, {C.y:.4f})$ & Định nghĩa \\\\
$O$ & $({O.x:.4f}, {O.y:.4f})$ & $|OA|=|OB|=|OC|=R$ \\\\
$H$ & $({H.x:.4f}, {H.y:.4f})$ & Giao của 3 đường cao \\\\
$D$ & $({D.x:.4f}, {D.y:.4f})$ & $D \\in BC$, $AD \\perp BC$ \\\\
$E$ & $({E.x:.4f}, {E.y:.4f})$ & $E \\in AC$, $BE \\perp AC$ \\\\
$F$ & $({F.x:.4f}, {F.y:.4f})$ & $F \\in AB$, $CF \\perp AB$ \\\\
$I$ & $({I.x:.4f}, {I.y:.4f})$ & Trung điểm $BC$ \\\\
$K$ & $({K.x:.4f}, {K.y:.4f})$ & $|OK|={O.distance_to(K):.4f}=R$ \\\\
$N$ & $({N.x:.4f}, {N.y:.4f})$ & Trung điểm $OH$ \\\\
\\hline
\\end{{tabular}}

\\vspace{{1em}}

\\textbf{{Bán kính:}}
\\begin{{itemize}}
    \\item Đường tròn ngoại tiếp: $R = {R:.6f}$
    \\item Đường tròn 9 điểm: $r = {r:.6f} = R/2$
\\end{{itemize}}

\\end{{document}}
"""

    # Save to file
    output_path = "/Users/taipm/GitHub/dev-team/.microai/teams/math-team/output/session-001/cau5_verified.tex"
    with open(output_path, 'w') as f:
        f.write(latex_doc)

    print(f"\nSaved LaTeX to: {output_path}")
    print("\nTikZ code preview:")
    print("-" * 40)
    print(tikz_code[:500] + "...")

    return verifier.is_all_passed()


if __name__ == "__main__":
    success = test_cau5_geometry()
    print("\n" + "=" * 60)
    if success:
        print("✓ ALL TESTS PASSED - Geometry is CORRECT")
    else:
        print("✗ SOME TESTS FAILED - Check errors above")
    print("=" * 60)
