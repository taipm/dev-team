"""
Molecular Graph Visualization with Force-Directed Layout
=========================================================
Algorithm: Fruchterman-Reingold with Barnes-Hut optimization + Molecular Constraints

Author: Dev-Algo Team Session
Date: 2026-01-02
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.patches import Circle, FancyBboxPatch
from matplotlib.lines import Line2D
from dataclasses import dataclass, field
from typing import List, Dict, Tuple, Optional, Set
from enum import Enum
import math
from collections import defaultdict


# =============================================================================
# CONSTANTS & CONFIGURATION
# =============================================================================

class BondType(Enum):
    SINGLE = 1
    DOUBLE = 2
    TRIPLE = 3


# Element properties: (color, radius, max_bonds)
ELEMENT_PROPERTIES = {
    'H':  ('#FFFFFF', 0.3, 1),   # White, small
    'C':  ('#404040', 0.5, 4),   # Dark gray
    'N':  ('#3050F8', 0.5, 3),   # Blue
    'O':  ('#FF0D0D', 0.5, 2),   # Red
    'S':  ('#FFFF30', 0.6, 2),   # Yellow
    'P':  ('#FF8000', 0.6, 3),   # Orange
    'F':  ('#90E050', 0.4, 1),   # Light green
    'Cl': ('#1FF01F', 0.6, 1),   # Green
    'Br': ('#A62929', 0.7, 1),   # Brown
    'I':  ('#940094', 0.8, 1),   # Purple
}

# Force-directed layout parameters
class LayoutConfig:
    IDEAL_BOND_LENGTH = 80.0      # pixels
    K_REPULSION = 15000.0         # repulsion strength
    K_SPRING = 0.08               # spring constant for bonds
    K_ANGLE = 0.02                # angle constraint strength
    DAMPING = 0.85                # velocity damping
    DT = 0.3                      # time step
    CONVERGENCE_THRESHOLD = 0.5   # max velocity for convergence
    MAX_COORD = 2000.0            # position clamp to prevent explosion
    ENERGY_WINDOW = 10            # frames for early convergence check
    ENERGY_THRESHOLD = 0.1        # energy variance threshold

    # Barnes-Hut
    BH_THETA = 0.7                # Barnes-Hut threshold

    # Ideal angles by hybridization
    ANGLES = {
        'sp3': 109.5,   # tetrahedral
        'sp2': 120.0,   # trigonal planar
        'sp':  180.0,   # linear
    }


# =============================================================================
# DATA STRUCTURES
# =============================================================================

@dataclass
class Atom:
    id: int
    element: str
    position: np.ndarray = field(default_factory=lambda: np.zeros(2))
    velocity: np.ndarray = field(default_factory=lambda: np.zeros(2))
    force: np.ndarray = field(default_factory=lambda: np.zeros(2))
    fixed: bool = False

    @property
    def color(self) -> str:
        return ELEMENT_PROPERTIES.get(self.element, ('#808080', 0.5, 4))[0]

    @property
    def radius(self) -> float:
        return ELEMENT_PROPERTIES.get(self.element, ('#808080', 0.5, 4))[1]

    @property
    def max_bonds(self) -> int:
        return ELEMENT_PROPERTIES.get(self.element, ('#808080', 0.5, 4))[2]


@dataclass
class Bond:
    atom1_id: int
    atom2_id: int
    bond_type: BondType = BondType.SINGLE

    @property
    def order(self) -> int:
        return self.bond_type.value


# =============================================================================
# QUADTREE FOR BARNES-HUT OPTIMIZATION
# =============================================================================

class QuadTreeNode:
    """Quadtree node for Barnes-Hut approximation."""

    def __init__(self, x: float, y: float, width: float, height: float):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.center_of_mass = np.zeros(2)
        self.total_mass = 0.0
        self.atom: Optional[Atom] = None
        self.children: List[Optional['QuadTreeNode']] = [None, None, None, None]
        self.is_leaf = True

    def contains(self, pos: np.ndarray) -> bool:
        return (self.x <= pos[0] < self.x + self.width and
                self.y <= pos[1] < self.y + self.height)

    def get_quadrant(self, pos: np.ndarray) -> int:
        mid_x = self.x + self.width / 2
        mid_y = self.y + self.height / 2

        if pos[0] < mid_x:
            return 0 if pos[1] < mid_y else 2
        else:
            return 1 if pos[1] < mid_y else 3

    def subdivide(self):
        hw, hh = self.width / 2, self.height / 2
        self.children[0] = QuadTreeNode(self.x, self.y, hw, hh)
        self.children[1] = QuadTreeNode(self.x + hw, self.y, hw, hh)
        self.children[2] = QuadTreeNode(self.x, self.y + hh, hw, hh)
        self.children[3] = QuadTreeNode(self.x + hw, self.y + hh, hw, hh)
        self.is_leaf = False

    def insert(self, atom: Atom):
        if not self.contains(atom.position):
            return

        if self.is_leaf and self.atom is None:
            self.atom = atom
            self.center_of_mass = atom.position.copy()
            self.total_mass = 1.0
            return

        if self.is_leaf and self.atom is not None:
            self.subdivide()
            old_atom = self.atom
            self.atom = None
            quad = self.get_quadrant(old_atom.position)
            self.children[quad].insert(old_atom)

        quad = self.get_quadrant(atom.position)
        if self.children[quad] is not None:
            self.children[quad].insert(atom)

        # Update center of mass
        self.total_mass += 1.0
        self.center_of_mass = (
            (self.center_of_mass * (self.total_mass - 1) + atom.position) /
            self.total_mass
        )

    def calculate_force(self, atom: Atom, theta: float = 0.7) -> np.ndarray:
        """Calculate repulsive force using Barnes-Hut approximation."""
        if self.total_mass == 0:
            return np.zeros(2)

        diff = atom.position - self.center_of_mass
        dist = np.linalg.norm(diff)

        if dist < 1e-6:
            return np.zeros(2)

        # If leaf node with single atom (not self)
        if self.is_leaf and self.atom is not None:
            if self.atom.id == atom.id:
                return np.zeros(2)
            return LayoutConfig.K_REPULSION * diff / (dist ** 3)

        # Barnes-Hut criterion: s/d < theta
        s = max(self.width, self.height)
        if s / dist < theta:
            # Treat as single mass
            return LayoutConfig.K_REPULSION * self.total_mass * diff / (dist ** 3)

        # Recurse into children
        force = np.zeros(2)
        for child in self.children:
            if child is not None:
                force += child.calculate_force(atom, theta)
        return force


class QuadTree:
    """Quadtree for efficient force calculations."""

    def __init__(self, atoms: List[Atom], padding: float = 100):
        if not atoms:
            self.root = None
            return

        # Calculate bounding box
        positions = np.array([a.position for a in atoms])
        min_pos = positions.min(axis=0) - padding
        max_pos = positions.max(axis=0) + padding
        size = max(max_pos[0] - min_pos[0], max_pos[1] - min_pos[1])

        self.root = QuadTreeNode(min_pos[0], min_pos[1], size, size)

        for atom in atoms:
            self.root.insert(atom)

    def calculate_repulsion(self, atom: Atom) -> np.ndarray:
        if self.root is None:
            return np.zeros(2)
        return self.root.calculate_force(atom, LayoutConfig.BH_THETA)


# =============================================================================
# MOLECULAR GRAPH
# =============================================================================

class MolecularGraph:
    """Molecular graph with force-directed layout."""

    def __init__(self):
        self.atoms: Dict[int, Atom] = {}
        self.bonds: List[Bond] = []
        self.adjacency: Dict[int, List[int]] = defaultdict(list)
        self.rings: List[Set[int]] = []
        self._next_id = 0

    def add_atom(self, element: str, position: Optional[np.ndarray] = None) -> int:
        """Add atom and return its ID."""
        atom_id = self._next_id
        self._next_id += 1

        if position is None:
            # Random initial position
            position = np.random.uniform(-100, 100, 2)

        self.atoms[atom_id] = Atom(
            id=atom_id,
            element=element,
            position=position.copy()
        )
        return atom_id

    def add_bond(self, atom1_id: int, atom2_id: int,
                 bond_type: BondType = BondType.SINGLE) -> bool:
        """Add bond between two atoms. Returns False if invalid."""
        # Validate: no self-loops
        if atom1_id == atom2_id:
            return False

        # Validate: atoms must exist
        if atom1_id not in self.atoms or atom2_id not in self.atoms:
            return False

        # Validate: no duplicate bonds
        for bond in self.bonds:
            if (bond.atom1_id == atom1_id and bond.atom2_id == atom2_id) or \
               (bond.atom1_id == atom2_id and bond.atom2_id == atom1_id):
                return False

        self.bonds.append(Bond(atom1_id, atom2_id, bond_type))
        self.adjacency[atom1_id].append(atom2_id)
        self.adjacency[atom2_id].append(atom1_id)
        return True

    def detect_rings(self, max_size: int = 8):
        """Detect ring systems using DFS."""
        self.rings = []
        visited = set()

        def dfs_rings(start: int, current: int, path: List[int], depth: int):
            if depth > max_size:
                return

            for neighbor in self.adjacency[current]:
                if neighbor == start and len(path) >= 3:
                    self.rings.append(set(path))
                elif neighbor not in path[1:]:  # Avoid immediate backtrack
                    dfs_rings(start, neighbor, path + [neighbor], depth + 1)

        for atom_id in self.atoms:
            if atom_id not in visited:
                dfs_rings(atom_id, atom_id, [atom_id], 0)
                visited.add(atom_id)

        # Remove duplicate rings
        unique_rings = []
        for ring in self.rings:
            if ring not in unique_rings:
                unique_rings.append(ring)
        self.rings = unique_rings

    def get_hybridization(self, atom_id: int) -> str:
        """Determine hybridization based on bonding."""
        atom = self.atoms[atom_id]
        bond_count = len(self.adjacency[atom_id])

        # Count double/triple bonds
        multiple_bonds = 0
        for bond in self.bonds:
            if atom_id in (bond.atom1_id, bond.atom2_id):
                if bond.bond_type != BondType.SINGLE:
                    multiple_bonds += 1

        if atom.element == 'C':
            if multiple_bonds >= 2 or bond_count == 2:
                return 'sp'
            elif multiple_bonds == 1 or bond_count == 3:
                return 'sp2'
            else:
                return 'sp3'

        return 'sp3'  # Default

    def get_ideal_angle(self, atom_id: int) -> float:
        """Get ideal bond angle for atom."""
        hybridization = self.get_hybridization(atom_id)
        return LayoutConfig.ANGLES.get(hybridization, 109.5)


# =============================================================================
# FORCE-DIRECTED LAYOUT ENGINE
# =============================================================================

class ForceDirectedLayout:
    """Force-directed layout with molecular constraints."""

    def __init__(self, molecule: MolecularGraph, use_barnes_hut: bool = True):
        self.molecule = molecule
        self.use_barnes_hut = use_barnes_hut
        self.iteration = 0
        self.converged = False
        self.energy_history = []

    def calculate_spring_force(self, atom1: Atom, atom2: Atom,
                                bond_order: int = 1) -> np.ndarray:
        """Calculate spring force between bonded atoms."""
        diff = atom2.position - atom1.position
        dist = np.linalg.norm(diff)

        if dist < 1e-6:
            # Atoms overlapping - let repulsion handle separation
            return np.zeros(2)

        # Ideal length decreases slightly for multiple bonds
        ideal_length = LayoutConfig.IDEAL_BOND_LENGTH * (1 - 0.1 * (bond_order - 1))

        # Hooke's law
        force_magnitude = LayoutConfig.K_SPRING * (dist - ideal_length)
        return force_magnitude * diff / dist

    def calculate_angle_force(self, center_id: int) -> Dict[int, np.ndarray]:
        """Calculate forces to maintain ideal bond angles."""
        forces = defaultdict(lambda: np.zeros(2))
        neighbors = self.molecule.adjacency[center_id]

        if len(neighbors) < 2:
            return forces

        center = self.molecule.atoms[center_id]
        ideal_angle = math.radians(self.molecule.get_ideal_angle(center_id))

        # For each pair of neighbors, apply angle force
        for i in range(len(neighbors)):
            for j in range(i + 1, len(neighbors)):
                n1 = self.molecule.atoms[neighbors[i]]
                n2 = self.molecule.atoms[neighbors[j]]

                v1 = n1.position - center.position
                v2 = n2.position - center.position

                d1 = np.linalg.norm(v1)
                d2 = np.linalg.norm(v2)

                if d1 < 1e-6 or d2 < 1e-6:
                    continue

                # Current angle
                cos_angle = np.clip(np.dot(v1, v2) / (d1 * d2), -1, 1)
                current_angle = math.acos(cos_angle)

                # Angle difference
                angle_diff = current_angle - ideal_angle

                # Perpendicular forces to adjust angle
                perp1 = np.array([-v1[1], v1[0]]) / d1
                perp2 = np.array([-v2[1], v2[0]]) / d2

                force_mag = LayoutConfig.K_ANGLE * angle_diff

                forces[neighbors[i]] += force_mag * perp1
                forces[neighbors[j]] -= force_mag * perp2

        return forces

    def calculate_repulsion_naive(self, atom: Atom) -> np.ndarray:
        """Naive O(n) repulsion calculation."""
        force = np.zeros(2)

        for other in self.molecule.atoms.values():
            if other.id == atom.id:
                continue

            diff = atom.position - other.position
            dist = np.linalg.norm(diff)

            if dist < 1e-6:
                # Small nudge to separate overlapping atoms
                force += np.random.uniform(-1, 1, 2) * 10
            else:
                force += LayoutConfig.K_REPULSION * diff / (dist ** 3)

        return force

    def step(self) -> float:
        """Perform one iteration of force-directed layout. Returns total kinetic energy."""
        atoms = list(self.molecule.atoms.values())

        # Reset forces
        for atom in atoms:
            atom.force = np.zeros(2)

        # Build quadtree for Barnes-Hut
        if self.use_barnes_hut and len(atoms) > 10:
            quadtree = QuadTree(atoms)
        else:
            quadtree = None

        # Calculate repulsion forces
        for atom in atoms:
            if atom.fixed:
                continue

            if quadtree:
                atom.force += quadtree.calculate_repulsion(atom)
            else:
                atom.force += self.calculate_repulsion_naive(atom)

        # Calculate spring forces (attraction for bonds)
        for bond in self.molecule.bonds:
            atom1 = self.molecule.atoms[bond.atom1_id]
            atom2 = self.molecule.atoms[bond.atom2_id]

            spring_force = self.calculate_spring_force(atom1, atom2, bond.order)

            if not atom1.fixed:
                atom1.force += spring_force
            if not atom2.fixed:
                atom2.force -= spring_force

        # Calculate angle forces
        for atom_id in self.molecule.atoms:
            angle_forces = self.calculate_angle_force(atom_id)
            for neighbor_id, force in angle_forces.items():
                if not self.molecule.atoms[neighbor_id].fixed:
                    self.molecule.atoms[neighbor_id].force += force

        # Update velocities and positions (Verlet integration)
        total_energy = 0.0
        max_velocity = 0.0

        for atom in atoms:
            if atom.fixed:
                continue

            # Limit force magnitude to prevent explosions
            force_mag = np.linalg.norm(atom.force)
            if force_mag > 1000:
                atom.force = atom.force / force_mag * 1000

            # Update velocity with damping
            atom.velocity = atom.velocity * LayoutConfig.DAMPING + atom.force * LayoutConfig.DT

            # Update position
            atom.position += atom.velocity * LayoutConfig.DT

            # Clamp position to prevent explosion
            atom.position = np.clip(
                atom.position,
                -LayoutConfig.MAX_COORD,
                LayoutConfig.MAX_COORD
            )

            # Track energy and max velocity
            velocity_mag = np.linalg.norm(atom.velocity)
            total_energy += 0.5 * velocity_mag ** 2
            max_velocity = max(max_velocity, velocity_mag)

        self.iteration += 1
        self.energy_history.append(total_energy)

        # Check convergence - velocity based
        if max_velocity < LayoutConfig.CONVERGENCE_THRESHOLD:
            self.converged = True

        # Early convergence - energy stability based
        if len(self.energy_history) >= LayoutConfig.ENERGY_WINDOW:
            recent = self.energy_history[-LayoutConfig.ENERGY_WINDOW:]
            if max(recent) - min(recent) < LayoutConfig.ENERGY_THRESHOLD:
                self.converged = True

        return total_energy

    def run(self, max_iterations: int = 500) -> int:
        """Run layout until convergence or max iterations."""
        for i in range(max_iterations):
            self.step()
            if self.converged:
                break
        return self.iteration


# =============================================================================
# MOLECULE BUILDER
# =============================================================================

class MoleculeBuilder:
    """Helper class to build common molecules."""

    @staticmethod
    def water() -> MolecularGraph:
        """H2O - Water molecule."""
        mol = MolecularGraph()
        o = mol.add_atom('O', np.array([0.0, 0.0]))
        h1 = mol.add_atom('H', np.array([-50.0, 50.0]))
        h2 = mol.add_atom('H', np.array([50.0, 50.0]))
        mol.add_bond(o, h1)
        mol.add_bond(o, h2)
        return mol

    @staticmethod
    def methane() -> MolecularGraph:
        """CH4 - Methane molecule."""
        mol = MolecularGraph()
        c = mol.add_atom('C', np.array([0.0, 0.0]))
        h1 = mol.add_atom('H', np.array([60.0, 0.0]))
        h2 = mol.add_atom('H', np.array([-60.0, 0.0]))
        h3 = mol.add_atom('H', np.array([0.0, 60.0]))
        h4 = mol.add_atom('H', np.array([0.0, -60.0]))
        mol.add_bond(c, h1)
        mol.add_bond(c, h2)
        mol.add_bond(c, h3)
        mol.add_bond(c, h4)
        return mol

    @staticmethod
    def ethanol() -> MolecularGraph:
        """C2H5OH - Ethanol molecule."""
        mol = MolecularGraph()
        # Carbon backbone
        c1 = mol.add_atom('C', np.array([0.0, 0.0]))
        c2 = mol.add_atom('C', np.array([80.0, 0.0]))
        o = mol.add_atom('O', np.array([160.0, 0.0]))

        # Hydrogens on C1 (CH3)
        h1 = mol.add_atom('H', np.array([-40.0, -40.0]))
        h2 = mol.add_atom('H', np.array([-40.0, 40.0]))
        h3 = mol.add_atom('H', np.array([-60.0, 0.0]))

        # Hydrogens on C2 (CH2)
        h4 = mol.add_atom('H', np.array([80.0, -60.0]))
        h5 = mol.add_atom('H', np.array([80.0, 60.0]))

        # Hydrogen on O (OH)
        h6 = mol.add_atom('H', np.array([200.0, 40.0]))

        # Bonds
        mol.add_bond(c1, c2)
        mol.add_bond(c2, o)
        mol.add_bond(c1, h1)
        mol.add_bond(c1, h2)
        mol.add_bond(c1, h3)
        mol.add_bond(c2, h4)
        mol.add_bond(c2, h5)
        mol.add_bond(o, h6)

        return mol

    @staticmethod
    def benzene() -> MolecularGraph:
        """C6H6 - Benzene ring."""
        mol = MolecularGraph()

        # Create hexagonal carbon ring
        carbons = []
        hydrogens = []
        radius = 80.0

        for i in range(6):
            angle = i * math.pi / 3 - math.pi / 2
            x = radius * math.cos(angle)
            y = radius * math.sin(angle)
            c = mol.add_atom('C', np.array([x, y]))
            carbons.append(c)

            # Hydrogen pointing outward
            hx = (radius + 50) * math.cos(angle)
            hy = (radius + 50) * math.sin(angle)
            h = mol.add_atom('H', np.array([hx, hy]))
            hydrogens.append(h)

        # C-C bonds (alternating single and double for resonance representation)
        for i in range(6):
            next_i = (i + 1) % 6
            bond_type = BondType.DOUBLE if i % 2 == 0 else BondType.SINGLE
            mol.add_bond(carbons[i], carbons[next_i], bond_type)

        # C-H bonds
        for c, h in zip(carbons, hydrogens):
            mol.add_bond(c, h)

        mol.detect_rings()
        return mol

    @staticmethod
    def caffeine() -> MolecularGraph:
        """C8H10N4O2 - Caffeine molecule (simplified 2D)."""
        mol = MolecularGraph()

        # Purine ring system (fused 5+6 rings)
        # 6-membered ring
        n1 = mol.add_atom('N', np.array([0.0, 0.0]))
        c2 = mol.add_atom('C', np.array([70.0, 40.0]))
        n3 = mol.add_atom('N', np.array([140.0, 0.0]))
        c4 = mol.add_atom('C', np.array([140.0, -80.0]))
        c5 = mol.add_atom('C', np.array([70.0, -120.0]))
        c6 = mol.add_atom('C', np.array([0.0, -80.0]))

        # 5-membered ring (fused)
        n7 = mol.add_atom('N', np.array([90.0, -180.0]))
        c8 = mol.add_atom('C', np.array([160.0, -160.0]))
        n9 = mol.add_atom('N', np.array([180.0, -100.0]))

        # Oxygen atoms
        o2 = mol.add_atom('O', np.array([70.0, 100.0]))
        o6 = mol.add_atom('O', np.array([-60.0, -100.0]))

        # Methyl groups (simplified as single C)
        ch3_1 = mol.add_atom('C', np.array([-60.0, 40.0]))
        ch3_3 = mol.add_atom('C', np.array([200.0, 40.0]))
        ch3_7 = mol.add_atom('C', np.array([80.0, -240.0]))

        # Bonds for 6-membered ring
        mol.add_bond(n1, c2)
        mol.add_bond(c2, n3)
        mol.add_bond(n3, c4)
        mol.add_bond(c4, c5)
        mol.add_bond(c5, c6)
        mol.add_bond(c6, n1)

        # Bonds for 5-membered ring
        mol.add_bond(c5, n7)
        mol.add_bond(n7, c8)
        mol.add_bond(c8, n9)
        mol.add_bond(n9, c4)

        # Carbonyl bonds
        mol.add_bond(c2, o2, BondType.DOUBLE)
        mol.add_bond(c6, o6, BondType.DOUBLE)

        # Methyl group bonds
        mol.add_bond(n1, ch3_1)
        mol.add_bond(n3, ch3_3)
        mol.add_bond(n7, ch3_7)

        mol.detect_rings()
        return mol


# =============================================================================
# VISUALIZATION & ANIMATION
# =============================================================================

class MolecularVisualizer:
    """Matplotlib-based molecular visualizer with animation."""

    def __init__(self, molecule: MolecularGraph, figsize: Tuple[int, int] = (10, 10)):
        self.molecule = molecule
        self.layout = ForceDirectedLayout(molecule)
        self.fig, self.ax = plt.subplots(figsize=figsize)
        self.atom_artists = {}
        self.bond_artists = []
        self.label_artists = {}
        self.animation = None
        self.frame_count = 0

    def setup_plot(self):
        """Initialize plot elements."""
        self.ax.set_aspect('equal')
        self.ax.set_facecolor('#1a1a2e')
        self.fig.patch.set_facecolor('#1a1a2e')
        self.ax.axis('off')

        # Create bond lines
        for bond in self.molecule.bonds:
            atom1 = self.molecule.atoms[bond.atom1_id]
            atom2 = self.molecule.atoms[bond.atom2_id]

            if bond.bond_type == BondType.SINGLE:
                line, = self.ax.plot([], [], color='#888888', linewidth=3, zorder=1)
                self.bond_artists.append((bond, [line]))
            elif bond.bond_type == BondType.DOUBLE:
                line1, = self.ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                line2, = self.ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                self.bond_artists.append((bond, [line1, line2]))
            elif bond.bond_type == BondType.TRIPLE:
                line1, = self.ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                line2, = self.ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                line3, = self.ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                self.bond_artists.append((bond, [line1, line2, line3]))

        # Create atom circles
        for atom_id, atom in self.molecule.atoms.items():
            circle = Circle(
                atom.position,
                radius=atom.radius * 25,
                facecolor=atom.color,
                edgecolor='white',
                linewidth=2,
                zorder=2
            )
            self.ax.add_patch(circle)
            self.atom_artists[atom_id] = circle

            # Add element label
            label = self.ax.text(
                atom.position[0], atom.position[1],
                atom.element,
                ha='center', va='center',
                fontsize=10, fontweight='bold',
                color='black' if atom.element != 'C' else 'white',
                zorder=3
            )
            self.label_artists[atom_id] = label

        # Add title and info
        self.title = self.ax.set_title(
            'Molecular Force-Directed Layout',
            color='white', fontsize=14, pad=20
        )
        self.info_text = self.ax.text(
            0.02, 0.98, '',
            transform=self.ax.transAxes,
            color='#00ff00', fontsize=10,
            verticalalignment='top',
            fontfamily='monospace'
        )

    def update_positions(self):
        """Update visual elements based on atom positions."""
        # Update bonds
        for bond, lines in self.bond_artists:
            atom1 = self.molecule.atoms[bond.atom1_id]
            atom2 = self.molecule.atoms[bond.atom2_id]

            p1 = atom1.position
            p2 = atom2.position

            if len(lines) == 1:
                lines[0].set_data([p1[0], p2[0]], [p1[1], p2[1]])
            else:
                # Multiple bonds - offset perpendicular
                direction = p2 - p1
                perp = np.array([-direction[1], direction[0]])
                perp = perp / (np.linalg.norm(perp) + 1e-6) * 4

                for i, line in enumerate(lines):
                    offset = perp * (i - (len(lines) - 1) / 2)
                    line.set_data(
                        [p1[0] + offset[0], p2[0] + offset[0]],
                        [p1[1] + offset[1], p2[1] + offset[1]]
                    )

        # Update atoms
        for atom_id, circle in self.atom_artists.items():
            atom = self.molecule.atoms[atom_id]
            circle.center = atom.position

        # Update labels
        for atom_id, label in self.label_artists.items():
            atom = self.molecule.atoms[atom_id]
            label.set_position(atom.position)

        # Auto-scale view
        positions = np.array([a.position for a in self.molecule.atoms.values()])
        if len(positions) > 0:
            margin = 100
            self.ax.set_xlim(positions[:, 0].min() - margin, positions[:, 0].max() + margin)
            self.ax.set_ylim(positions[:, 1].min() - margin, positions[:, 1].max() + margin)

    def animate(self, frame):
        """Animation frame update function."""
        if not self.layout.converged:
            energy = self.layout.step()
            self.update_positions()

            self.info_text.set_text(
                f'Iteration: {self.layout.iteration}\n'
                f'Energy: {energy:.2f}\n'
                f'Converged: {"Yes" if self.layout.converged else "No"}'
            )

        self.frame_count += 1
        return list(self.atom_artists.values()) + [self.info_text]

    def run_animation(self, frames: int = 300, interval: int = 30, save_path: Optional[str] = None):
        """Run the animation."""
        self.setup_plot()
        self.update_positions()

        self.animation = FuncAnimation(
            self.fig, self.animate,
            frames=frames, interval=interval,
            blit=False, repeat=False
        )

        if save_path:
            print(f"Saving animation to {save_path}...")
            self.animation.save(save_path, writer='pillow', fps=30, dpi=100)
            print("Animation saved!")

        plt.show()

    def show_static(self, iterations: int = 200):
        """Show static result after running layout."""
        print(f"Running layout for up to {iterations} iterations...")
        actual_iters = self.layout.run(iterations)
        print(f"Layout converged after {actual_iters} iterations")

        self.setup_plot()
        self.update_positions()

        self.info_text.set_text(
            f'Iterations: {actual_iters}\n'
            f'Converged: {"Yes" if self.layout.converged else "No"}'
        )

        plt.tight_layout()
        plt.show()


# =============================================================================
# DEMO
# =============================================================================

def demo_single_molecule(molecule_name: str = 'benzene'):
    """Demo a single molecule."""
    builders = {
        'water': MoleculeBuilder.water,
        'methane': MoleculeBuilder.methane,
        'ethanol': MoleculeBuilder.ethanol,
        'benzene': MoleculeBuilder.benzene,
        'caffeine': MoleculeBuilder.caffeine,
    }

    if molecule_name not in builders:
        print(f"Unknown molecule. Available: {list(builders.keys())}")
        return

    molecule = builders[molecule_name]()
    print(f"\n{'='*50}")
    print(f"Molecule: {molecule_name.upper()}")
    print(f"Atoms: {len(molecule.atoms)}")
    print(f"Bonds: {len(molecule.bonds)}")
    print(f"Rings: {len(molecule.rings)}")
    print(f"{'='*50}\n")

    viz = MolecularVisualizer(molecule)
    viz.run_animation(frames=200, interval=30)


def demo_all_molecules(save_gif: bool = False):
    """Demo all available molecules in a grid."""
    molecules = {
        'H₂O (Water)': MoleculeBuilder.water(),
        'CH₄ (Methane)': MoleculeBuilder.methane(),
        'C₂H₅OH (Ethanol)': MoleculeBuilder.ethanol(),
        'C₆H₆ (Benzene)': MoleculeBuilder.benzene(),
        'Caffeine': MoleculeBuilder.caffeine(),
    }

    fig, axes = plt.subplots(2, 3, figsize=(15, 10))
    fig.patch.set_facecolor('#1a1a2e')
    axes = axes.flatten()

    for idx, (name, molecule) in enumerate(molecules.items()):
        ax = axes[idx]
        ax.set_facecolor('#1a1a2e')
        ax.set_aspect('equal')
        ax.axis('off')
        ax.set_title(name, color='white', fontsize=12, pad=10)

        # Run layout
        layout = ForceDirectedLayout(molecule)
        layout.run(200)

        # Draw bonds
        for bond in molecule.bonds:
            atom1 = molecule.atoms[bond.atom1_id]
            atom2 = molecule.atoms[bond.atom2_id]
            p1, p2 = atom1.position, atom2.position

            if bond.bond_type == BondType.SINGLE:
                ax.plot([p1[0], p2[0]], [p1[1], p2[1]],
                       color='#888888', linewidth=2, zorder=1)
            else:
                direction = p2 - p1
                perp = np.array([-direction[1], direction[0]])
                perp = perp / (np.linalg.norm(perp) + 1e-6) * 3
                for i in range(bond.order):
                    offset = perp * (i - (bond.order - 1) / 2)
                    ax.plot([p1[0] + offset[0], p2[0] + offset[0]],
                           [p1[1] + offset[1], p2[1] + offset[1]],
                           color='#888888', linewidth=1.5, zorder=1)

        # Draw atoms
        for atom in molecule.atoms.values():
            circle = Circle(
                atom.position,
                radius=atom.radius * 20,
                facecolor=atom.color,
                edgecolor='white',
                linewidth=1.5,
                zorder=2
            )
            ax.add_patch(circle)
            ax.text(atom.position[0], atom.position[1], atom.element,
                   ha='center', va='center', fontsize=8, fontweight='bold',
                   color='black' if atom.element != 'C' else 'white', zorder=3)

        # Auto-scale
        positions = np.array([a.position for a in molecule.atoms.values()])
        margin = 60
        ax.set_xlim(positions[:, 0].min() - margin, positions[:, 0].max() + margin)
        ax.set_ylim(positions[:, 1].min() - margin, positions[:, 1].max() + margin)

    # Hide empty subplot
    axes[5].set_visible(False)

    plt.suptitle('Molecular Force-Directed Layout Demo',
                 color='white', fontsize=16, y=0.98)
    plt.tight_layout()

    if save_gif:
        plt.savefig('molecules_static.png', dpi=150, facecolor='#1a1a2e')
        print("Saved to molecules_static.png")

    plt.show()


if __name__ == '__main__':
    import sys

    if len(sys.argv) > 1:
        if sys.argv[1] == 'all':
            demo_all_molecules(save_gif='--save' in sys.argv)
        else:
            demo_single_molecule(sys.argv[1])
    else:
        print("Molecular Graph Visualization Demo")
        print("=" * 40)
        print("Usage:")
        print("  python molecular_graph.py <molecule>")
        print("  python molecular_graph.py all [--save]")
        print()
        print("Available molecules:")
        print("  water, methane, ethanol, benzene, caffeine")
        print()
        print("Running default demo (benzene)...")
        demo_single_molecule('benzene')
