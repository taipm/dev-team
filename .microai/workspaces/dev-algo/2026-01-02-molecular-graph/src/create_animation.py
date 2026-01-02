"""
Create animated GIF of molecular force-directed layout.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.patches import Circle
from molecular_graph import (
    MolecularGraph, ForceDirectedLayout, MoleculeBuilder,
    BondType, LayoutConfig
)


def create_animated_demo(output_path: str = '../output/molecular_animation.gif'):
    """Create animated GIF showing layout convergence."""

    # Use caffeine for more interesting visualization
    molecule = MoleculeBuilder.caffeine()

    # Randomize initial positions for dramatic effect
    for atom in molecule.atoms.values():
        atom.position = np.random.uniform(-200, 200, 2)

    layout = ForceDirectedLayout(molecule)

    # Setup figure
    fig, ax = plt.subplots(figsize=(8, 8))
    fig.patch.set_facecolor('#1a1a2e')
    ax.set_facecolor('#1a1a2e')
    ax.set_aspect('equal')
    ax.axis('off')

    # Store artists
    bond_lines = []
    atom_circles = {}
    atom_labels = {}

    # Create bonds
    for bond in molecule.bonds:
        if bond.bond_type == BondType.SINGLE:
            line, = ax.plot([], [], color='#888888', linewidth=3, zorder=1)
            bond_lines.append((bond, [line]))
        else:
            lines = []
            for _ in range(bond.order):
                line, = ax.plot([], [], color='#888888', linewidth=2, zorder=1)
                lines.append(line)
            bond_lines.append((bond, lines))

    # Create atoms
    for atom_id, atom in molecule.atoms.items():
        circle = Circle(
            atom.position,
            radius=atom.radius * 25,
            facecolor=atom.color,
            edgecolor='white',
            linewidth=2,
            zorder=2
        )
        ax.add_patch(circle)
        atom_circles[atom_id] = circle

        label = ax.text(
            atom.position[0], atom.position[1],
            atom.element,
            ha='center', va='center',
            fontsize=10, fontweight='bold',
            color='black' if atom.element not in ['C'] else 'white',
            zorder=3
        )
        atom_labels[atom_id] = label

    # Info text
    info_text = ax.text(
        0.02, 0.98, '',
        transform=ax.transAxes,
        color='#00ff00', fontsize=11,
        verticalalignment='top',
        fontfamily='monospace'
    )

    title = ax.set_title(
        'Caffeine (C₈H₁₀N₄O₂) - Force-Directed Layout',
        color='white', fontsize=14, pad=15
    )

    def update(frame):
        # Run multiple physics steps per frame for faster convergence
        for _ in range(3):
            if not layout.converged:
                energy = layout.step()

        # Update bonds
        for bond, lines in bond_lines:
            atom1 = molecule.atoms[bond.atom1_id]
            atom2 = molecule.atoms[bond.atom2_id]
            p1, p2 = atom1.position, atom2.position

            if len(lines) == 1:
                lines[0].set_data([p1[0], p2[0]], [p1[1], p2[1]])
            else:
                direction = p2 - p1
                perp = np.array([-direction[1], direction[0]])
                norm = np.linalg.norm(perp)
                if norm > 1e-6:
                    perp = perp / norm * 4

                for i, line in enumerate(lines):
                    offset = perp * (i - (len(lines) - 1) / 2)
                    line.set_data(
                        [p1[0] + offset[0], p2[0] + offset[0]],
                        [p1[1] + offset[1], p2[1] + offset[1]]
                    )

        # Update atoms
        for atom_id, circle in atom_circles.items():
            atom = molecule.atoms[atom_id]
            circle.center = atom.position

        for atom_id, label in atom_labels.items():
            atom = molecule.atoms[atom_id]
            label.set_position(atom.position)

        # Auto-scale
        positions = np.array([a.position for a in molecule.atoms.values()])
        margin = 80
        ax.set_xlim(positions[:, 0].min() - margin, positions[:, 0].max() + margin)
        ax.set_ylim(positions[:, 1].min() - margin, positions[:, 1].max() + margin)

        # Update info
        status = "✓ CONVERGED" if layout.converged else "Computing..."
        info_text.set_text(
            f'Frame: {frame}\n'
            f'Iteration: {layout.iteration}\n'
            f'Status: {status}'
        )

        return list(atom_circles.values()) + [info_text]

    print("Creating animation...")
    anim = FuncAnimation(
        fig, update,
        frames=150,
        interval=50,
        blit=False,
        repeat=False
    )

    print(f"Saving to {output_path}...")
    anim.save(output_path, writer='pillow', fps=20, dpi=100)
    print("Done!")

    plt.close()


def create_comparison_animation(output_path: str = '../output/molecules_comparison.gif'):
    """Create side-by-side comparison of different molecules."""

    molecules = [
        ('H₂O', MoleculeBuilder.water()),
        ('CH₄', MoleculeBuilder.methane()),
        ('C₂H₅OH', MoleculeBuilder.ethanol()),
        ('C₆H₆', MoleculeBuilder.benzene()),
    ]

    # Randomize positions
    for name, mol in molecules:
        for atom in mol.atoms.values():
            atom.position = np.random.uniform(-150, 150, 2)

    layouts = [(name, mol, ForceDirectedLayout(mol)) for name, mol, in molecules]

    fig, axes = plt.subplots(2, 2, figsize=(10, 10))
    fig.patch.set_facecolor('#1a1a2e')
    axes = axes.flatten()

    all_artists = []

    for idx, ((name, molecule, layout), ax) in enumerate(zip(layouts, axes)):
        ax.set_facecolor('#1a1a2e')
        ax.set_aspect('equal')
        ax.axis('off')
        ax.set_title(name, color='white', fontsize=14, pad=10)

        bond_lines = []
        atom_circles = {}

        for bond in molecule.bonds:
            line, = ax.plot([], [], color='#888888', linewidth=2, zorder=1)
            bond_lines.append((bond, line))

        for atom_id, atom in molecule.atoms.items():
            circle = Circle(
                atom.position,
                radius=atom.radius * 22,
                facecolor=atom.color,
                edgecolor='white',
                linewidth=1.5,
                zorder=2
            )
            ax.add_patch(circle)
            atom_circles[atom_id] = circle

        all_artists.append({
            'molecule': molecule,
            'layout': layout,
            'ax': ax,
            'bonds': bond_lines,
            'atoms': atom_circles,
        })

    fig.suptitle('Force-Directed Molecular Layout', color='white', fontsize=16, y=0.95)

    def update(frame):
        for data in all_artists:
            molecule = data['molecule']
            layout = data['layout']
            ax = data['ax']

            for _ in range(2):
                if not layout.converged:
                    layout.step()

            for bond, line in data['bonds']:
                p1 = molecule.atoms[bond.atom1_id].position
                p2 = molecule.atoms[bond.atom2_id].position
                line.set_data([p1[0], p2[0]], [p1[1], p2[1]])

            for atom_id, circle in data['atoms'].items():
                circle.center = molecule.atoms[atom_id].position

            positions = np.array([a.position for a in molecule.atoms.values()])
            margin = 60
            ax.set_xlim(positions[:, 0].min() - margin, positions[:, 0].max() + margin)
            ax.set_ylim(positions[:, 1].min() - margin, positions[:, 1].max() + margin)

        return []

    print("Creating comparison animation...")
    anim = FuncAnimation(fig, update, frames=100, interval=50, blit=False)

    print(f"Saving to {output_path}...")
    anim.save(output_path, writer='pillow', fps=20, dpi=100)
    print("Done!")

    plt.close()


if __name__ == '__main__':
    create_animated_demo()
    create_comparison_animation()
