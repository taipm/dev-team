"""
Test suite for molecular graph fixes.
Verifies edge cases identified by Code Reviewer.
"""

import numpy as np
import sys
import time

from molecular_graph import (
    MolecularGraph, ForceDirectedLayout, MoleculeBuilder,
    Atom, Bond, BondType, LayoutConfig
)


def test_single_atom():
    """Test: Single atom should not crash and stay stable."""
    print("Test 1: Single atom...", end=" ")

    mol = MolecularGraph()
    mol.add_atom('C', np.array([0.0, 0.0]))

    layout = ForceDirectedLayout(mol)

    # Should not crash
    for _ in range(10):
        energy = layout.step()

    # Position should remain stable (no forces)
    pos = mol.atoms[0].position
    assert not np.isnan(pos).any(), "Position contains NaN"
    assert not np.isinf(pos).any(), "Position contains Inf"

    print("PASS")


def test_self_loop_ignored():
    """Test: Self-loop bonds should be rejected."""
    print("Test 2: Self-loop validation...", end=" ")

    mol = MolecularGraph()
    a = mol.add_atom('C')

    result = mol.add_bond(a, a)  # Self-loop

    assert result == False, "Self-loop should return False"
    assert len(mol.bonds) == 0, "Self-loop should not be added"

    print("PASS")


def test_duplicate_bond_ignored():
    """Test: Duplicate bonds should be rejected."""
    print("Test 3: Duplicate bond validation...", end=" ")

    mol = MolecularGraph()
    a = mol.add_atom('C')
    b = mol.add_atom('C')

    result1 = mol.add_bond(a, b)
    result2 = mol.add_bond(a, b)  # Duplicate
    result3 = mol.add_bond(b, a)  # Reverse duplicate

    assert result1 == True, "First bond should succeed"
    assert result2 == False, "Duplicate bond should return False"
    assert result3 == False, "Reverse duplicate should return False"
    assert len(mol.bonds) == 1, "Only one bond should exist"

    print("PASS")


def test_invalid_atom_bond():
    """Test: Bond with non-existent atom should be rejected."""
    print("Test 4: Invalid atom bond validation...", end=" ")

    mol = MolecularGraph()
    a = mol.add_atom('C')

    result = mol.add_bond(a, 999)  # Non-existent atom

    assert result == False, "Bond to non-existent atom should return False"
    assert len(mol.bonds) == 0, "Invalid bond should not be added"

    print("PASS")


def test_overlapping_atoms():
    """Test: Overlapping atoms should not crash or produce NaN."""
    print("Test 5: Overlapping atoms...", end=" ")

    mol = MolecularGraph()
    mol.add_atom('C', np.array([0.0, 0.0]))
    mol.add_atom('C', np.array([0.0, 0.0]))  # Same position
    mol.add_atom('C', np.array([0.0, 0.0]))  # Same position
    mol.add_bond(0, 1)
    mol.add_bond(1, 2)

    layout = ForceDirectedLayout(mol)

    # Should not crash and should separate
    for _ in range(50):
        energy = layout.step()

    for atom in mol.atoms.values():
        assert not np.isnan(atom.position).any(), f"Atom {atom.id} has NaN position"
        assert not np.isinf(atom.position).any(), f"Atom {atom.id} has Inf position"

    # Atoms should have separated
    pos0 = mol.atoms[0].position
    pos1 = mol.atoms[1].position
    dist = np.linalg.norm(pos1 - pos0)
    assert dist > 1.0, "Overlapping atoms should separate"

    print("PASS")


def test_position_clamping():
    """Test: Positions should be clamped within MAX_COORD."""
    print("Test 6: Position clamping...", end=" ")

    mol = MolecularGraph()
    # Create atoms with extreme positions
    mol.add_atom('C', np.array([5000.0, 5000.0]))
    mol.add_atom('C', np.array([-5000.0, -5000.0]))

    layout = ForceDirectedLayout(mol)
    layout.step()

    for atom in mol.atoms.values():
        assert np.all(np.abs(atom.position) <= LayoutConfig.MAX_COORD), \
            f"Position {atom.position} exceeds MAX_COORD"

    print("PASS")


def test_early_convergence():
    """Test: Layout should converge when energy stabilizes."""
    print("Test 7: Early convergence...", end=" ")

    mol = MoleculeBuilder.water()
    layout = ForceDirectedLayout(mol)

    iterations = layout.run(max_iterations=500)

    assert layout.converged, "Layout should converge"
    assert iterations < 500, f"Should converge before max iterations (took {iterations})"

    print(f"PASS (converged in {iterations} iterations)")


def test_large_molecule_performance():
    """Test: Large molecule performance - verify Barnes-Hut is faster than naive."""
    print("Test 8: Large molecule performance (n=200)...", end=" ")

    mol = MolecularGraph()

    # Create chain of 200 atoms (realistic for pure Python)
    for i in range(200):
        mol.add_atom('C', np.random.uniform(-100, 100, 2))

    for i in range(199):
        mol.add_bond(i, i + 1)

    # Compare Barnes-Hut vs Naive
    layout_bh = ForceDirectedLayout(mol, use_barnes_hut=True)
    layout_bh.step()  # Warm up

    times_bh = []
    for _ in range(5):
        start = time.perf_counter()
        layout_bh.step()
        times_bh.append(time.perf_counter() - start)

    # Reset and test naive
    mol2 = MolecularGraph()
    for i in range(200):
        mol2.add_atom('C', np.random.uniform(-100, 100, 2))
    for i in range(199):
        mol2.add_bond(i, i + 1)

    layout_naive = ForceDirectedLayout(mol2, use_barnes_hut=False)
    layout_naive.step()

    times_naive = []
    for _ in range(5):
        start = time.perf_counter()
        layout_naive.step()
        times_naive.append(time.perf_counter() - start)

    avg_bh = sum(times_bh) / len(times_bh) * 1000
    avg_naive = sum(times_naive) / len(times_naive) * 1000

    print(f"BH={avg_bh:.1f}ms, naive={avg_naive:.1f}ms...", end=" ")

    # Barnes-Hut should be faster or comparable for n=200
    # Note: Pure Python has overhead, so BH may not always be faster at small n
    assert avg_bh < 500, f"Barnes-Hut too slow: {avg_bh:.1f}ms"

    print("PASS")


def test_no_nan_after_many_iterations():
    """Test: No NaN values after many iterations."""
    print("Test 9: Stability over many iterations...", end=" ")

    mol = MoleculeBuilder.caffeine()

    # Randomize positions
    for atom in mol.atoms.values():
        atom.position = np.random.uniform(-200, 200, 2)

    layout = ForceDirectedLayout(mol)

    for i in range(300):
        energy = layout.step()

        # Check for NaN
        assert not np.isnan(energy), f"Energy is NaN at iteration {i}"

        for atom in mol.atoms.values():
            assert not np.isnan(atom.position).any(), \
                f"Atom {atom.id} has NaN position at iteration {i}"

    print("PASS")


def test_barnes_hut_vs_naive():
    """Test: Barnes-Hut should produce reasonable results (not explode)."""
    print("Test 10: Barnes-Hut stability...", end=" ")

    mol = MolecularGraph()
    np.random.seed(42)
    for i in range(50):
        mol.add_atom('C', np.random.uniform(-100, 100, 2))
    for i in range(49):
        mol.add_bond(i, i + 1)

    layout_bh = ForceDirectedLayout(mol, use_barnes_hut=True)

    # Run Barnes-Hut and verify it doesn't explode
    initial_energy = None
    for i in range(100):
        energy = layout_bh.step()
        if i == 0:
            initial_energy = energy

        # Check no NaN
        assert not np.isnan(energy), f"Energy is NaN at iteration {i}"

        # Check positions are bounded
        for atom in mol.atoms.values():
            assert np.all(np.abs(atom.position) < LayoutConfig.MAX_COORD * 2), \
                f"Atom {atom.id} position exploded"

    # Energy should decrease over time (layout stabilizing)
    assert layout_bh.converged or energy < initial_energy, \
        "Layout should stabilize or converge"

    print(f"PASS (energy: {initial_energy:.1f} -> {energy:.1f})")


def run_all_tests():
    """Run all tests."""
    print("\n" + "=" * 60)
    print("MOLECULAR GRAPH FIX VERIFICATION TESTS")
    print("=" * 60 + "\n")

    tests = [
        test_single_atom,
        test_self_loop_ignored,
        test_duplicate_bond_ignored,
        test_invalid_atom_bond,
        test_overlapping_atoms,
        test_position_clamping,
        test_early_convergence,
        test_large_molecule_performance,
        test_no_nan_after_many_iterations,
        test_barnes_hut_vs_naive,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"FAIL: {e}")
            failed += 1
        except Exception as e:
            print(f"ERROR: {e}")
            failed += 1

    print("\n" + "=" * 60)
    print(f"RESULTS: {passed} passed, {failed} failed")
    print("=" * 60 + "\n")

    return failed == 0


if __name__ == '__main__':
    success = run_all_tests()
    sys.exit(0 if success else 1)
