#!/usr/bin/env python3
"""
Double Pendulum Chaos Animation
YouTube-ready: 90s, 720p, 30fps

Demonstrates chaotic behavior - multiple pendulums with nearly identical
initial conditions diverge dramatically over time (butterfly effect).

Author: Dev-Algo Team
Date: 2026-01-02
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.collections import LineCollection
from dataclasses import dataclass
from typing import List, Tuple
import colorsys

# ═══════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════

@dataclass
class Config:
    # Video settings
    duration: int = 90          # seconds
    fps: int = 30
    width: int = 1280
    height: int = 720
    dpi: int = 100

    # Physics
    g: float = 9.81             # gravity
    L1: float = 1.0             # length of first arm
    L2: float = 1.0             # length of second arm
    m1: float = 1.0             # mass of first bob
    m2: float = 1.0             # mass of second bob

    # Simulation
    dt: float = 0.002           # physics timestep (small for accuracy)
    steps_per_frame: int = 17   # physics steps per animation frame

    # Pendulums
    num_pendulums: int = 9
    initial_angle1: float = np.pi * 0.75    # ~135 degrees
    initial_angle2: float = np.pi * 0.5     # ~90 degrees
    angle_spread: float = 0.0001            # tiny difference to show chaos

    # Trail
    trail_length: int = 500     # points in trail
    trail_fade: bool = True

    # Output
    output_path: str = "/Volumes/OWC-taipm-ssd/Github/dev-team/.microai/workspaces/dev-algo/2026-01-02-double-pendulum/output/double_pendulum_chaos.mp4"


# ═══════════════════════════════════════════════════════════════
# Physics Engine
# ═══════════════════════════════════════════════════════════════

class DoublePendulum:
    """Double pendulum with RK4 integration."""

    def __init__(self, theta1: float, theta2: float, config: Config):
        self.config = config
        # State: [theta1, omega1, theta2, omega2]
        self.state = np.array([theta1, 0.0, theta2, 0.0])
        self.trail: List[Tuple[float, float]] = []

    def derivatives(self, state: np.ndarray) -> np.ndarray:
        """Compute derivatives for double pendulum equations of motion."""
        theta1, omega1, theta2, omega2 = state
        c = self.config

        delta = theta2 - theta1
        cos_d = np.cos(delta)
        sin_d = np.sin(delta)

        # Denominators
        den1 = (c.m1 + c.m2) * c.L1 - c.m2 * c.L1 * cos_d**2
        den2 = (c.L2 / c.L1) * den1

        # Angular accelerations
        alpha1 = (c.m2 * c.L1 * omega1**2 * sin_d * cos_d +
                  c.m2 * c.g * np.sin(theta2) * cos_d +
                  c.m2 * c.L2 * omega2**2 * sin_d -
                  (c.m1 + c.m2) * c.g * np.sin(theta1)) / den1

        alpha2 = (-c.m2 * c.L2 * omega2**2 * sin_d * cos_d +
                  (c.m1 + c.m2) * c.g * np.sin(theta1) * cos_d -
                  (c.m1 + c.m2) * c.L1 * omega1**2 * sin_d -
                  (c.m1 + c.m2) * c.g * np.sin(theta2)) / den2

        return np.array([omega1, alpha1, omega2, alpha2])

    def step(self, dt: float) -> None:
        """RK4 integration step."""
        k1 = self.derivatives(self.state)
        k2 = self.derivatives(self.state + 0.5 * dt * k1)
        k3 = self.derivatives(self.state + 0.5 * dt * k2)
        k4 = self.derivatives(self.state + dt * k3)

        self.state += (dt / 6.0) * (k1 + 2*k2 + 2*k3 + k4)

        # Update trail
        x2, y2 = self.get_positions()[1]
        self.trail.append((x2, y2))
        if len(self.trail) > self.config.trail_length:
            self.trail.pop(0)

    def get_positions(self) -> Tuple[Tuple[float, float], Tuple[float, float]]:
        """Get (x, y) positions of both bobs."""
        theta1, _, theta2, _ = self.state
        c = self.config

        x1 = c.L1 * np.sin(theta1)
        y1 = -c.L1 * np.cos(theta1)

        x2 = x1 + c.L2 * np.sin(theta2)
        y2 = y1 - c.L2 * np.cos(theta2)

        return (x1, y1), (x2, y2)


# ═══════════════════════════════════════════════════════════════
# Animation
# ═══════════════════════════════════════════════════════════════

def generate_colors(n: int) -> List[Tuple[float, float, float]]:
    """Generate n visually distinct colors."""
    colors = []
    for i in range(n):
        hue = i / n
        rgb = colorsys.hsv_to_rgb(hue, 0.9, 0.95)
        colors.append(rgb)
    return colors


def create_animation(config: Config):
    """Create the double pendulum chaos animation."""

    # Setup figure with dark theme
    plt.style.use('dark_background')
    fig, ax = plt.subplots(figsize=(config.width/config.dpi, config.height/config.dpi),
                           dpi=config.dpi)
    fig.patch.set_facecolor('#0a0a0f')
    ax.set_facecolor('#0a0a0f')

    # Set axis limits
    limit = (config.L1 + config.L2) * 1.2
    ax.set_xlim(-limit, limit)
    ax.set_ylim(-limit * 1.1, limit * 0.5)
    ax.set_aspect('equal')
    ax.axis('off')

    # Title
    title = ax.text(0.5, 0.95, 'DOUBLE PENDULUM CHAOS', transform=ax.transAxes,
                    fontsize=24, fontweight='bold', color='white',
                    ha='center', va='top', fontfamily='monospace')

    # Subtitle
    subtitle = ax.text(0.5, 0.89, f'{config.num_pendulums} pendulums with initial difference: {config.angle_spread:.0e} rad',
                       transform=ax.transAxes, fontsize=12, color='#888888',
                       ha='center', va='top', fontfamily='monospace')

    # Time display
    time_text = ax.text(0.02, 0.02, '', transform=ax.transAxes,
                        fontsize=14, color='#00ff88', fontfamily='monospace')

    # Divergence indicator
    diverge_text = ax.text(0.98, 0.02, '', transform=ax.transAxes,
                           fontsize=12, color='#ff6644', ha='right',
                           fontfamily='monospace')

    # Initialize pendulums with tiny differences
    colors = generate_colors(config.num_pendulums)
    pendulums: List[DoublePendulum] = []

    for i in range(config.num_pendulums):
        offset = (i - config.num_pendulums // 2) * config.angle_spread
        theta1 = config.initial_angle1 + offset
        theta2 = config.initial_angle2
        pendulums.append(DoublePendulum(theta1, theta2, config))

    # Graphics elements
    trail_collections = []
    arm_lines = []
    bob_circles = []

    for i, (pendulum, color) in enumerate(zip(pendulums, colors)):
        # Trail (as LineCollection for fading effect)
        trail_col = LineCollection([], colors=[], linewidths=2, alpha=0.8)
        ax.add_collection(trail_col)
        trail_collections.append(trail_col)

        # Arms
        line, = ax.plot([], [], '-', color=color, linewidth=2, alpha=0.6)
        arm_lines.append(line)

        # Bobs (only show for a few pendulums to reduce clutter)
        if i < 3 or i >= config.num_pendulums - 1:
            bob1 = plt.Circle((0, 0), 0.05, color=color, alpha=0.8)
            bob2 = plt.Circle((0, 0), 0.07, color=color, alpha=0.9)
            ax.add_patch(bob1)
            ax.add_patch(bob2)
            bob_circles.append((bob1, bob2, i))

    # Pivot point
    pivot = plt.Circle((0, 0), 0.03, color='white', zorder=10)
    ax.add_patch(pivot)

    total_frames = config.duration * config.fps
    simulation_time = 0.0

    def init():
        for trail_col in trail_collections:
            trail_col.set_segments([])
        for line in arm_lines:
            line.set_data([], [])
        time_text.set_text('')
        diverge_text.set_text('')
        return trail_collections + arm_lines + [time_text, diverge_text]

    def animate(frame):
        nonlocal simulation_time

        # Physics steps
        for _ in range(config.steps_per_frame):
            for pendulum in pendulums:
                pendulum.step(config.dt)
            simulation_time += config.dt

        # Update graphics
        max_dist = 0.0
        ref_pos = pendulums[0].get_positions()[1]

        for i, (pendulum, color, trail_col, arm_line) in enumerate(
            zip(pendulums, colors, trail_collections, arm_lines)):

            (x1, y1), (x2, y2) = pendulum.get_positions()

            # Calculate divergence from reference
            dist = np.sqrt((x2 - ref_pos[0])**2 + (y2 - ref_pos[1])**2)
            max_dist = max(max_dist, dist)

            # Update arms
            arm_line.set_data([0, x1, x2], [0, y1, y2])

            # Update trail with fading colors
            if len(pendulum.trail) > 1:
                points = np.array(pendulum.trail).reshape(-1, 1, 2)
                segments = np.concatenate([points[:-1], points[1:]], axis=1)

                # Create fading colors
                n_seg = len(segments)
                alphas = np.linspace(0.1, 0.9, n_seg) if config.trail_fade else np.ones(n_seg) * 0.8
                trail_colors = [(color[0], color[1], color[2], a) for a in alphas]

                trail_col.set_segments(segments)
                trail_col.set_colors(trail_colors)

        # Update bob positions
        for bob1, bob2, idx in bob_circles:
            (x1, y1), (x2, y2) = pendulums[idx].get_positions()
            bob1.center = (x1, y1)
            bob2.center = (x2, y2)

        # Update text
        time_text.set_text(f't = {simulation_time:.1f}s')

        # Divergence indicator
        if max_dist > 0.01:
            diverge_text.set_text(f'Max divergence: {max_dist:.3f}')
            diverge_text.set_color('#ff6644' if max_dist > 0.5 else '#ffaa44')
        else:
            diverge_text.set_text('Synchronized')
            diverge_text.set_color('#44ff88')

        # Progress
        if frame % 100 == 0:
            pct = 100 * frame / total_frames
            print(f"  Frame {frame}/{total_frames} ({pct:.1f}%) - t={simulation_time:.1f}s, divergence={max_dist:.4f}")

        return trail_collections + arm_lines + [time_text, diverge_text]

    return fig, init, animate, total_frames


def main():
    config = Config()

    print("=" * 60)
    print("  DOUBLE PENDULUM CHAOS - YouTube Animation")
    print("=" * 60)
    print(f"  Duration: {config.duration}s @ {config.fps}fps")
    print(f"  Resolution: {config.width}x{config.height}")
    print(f"  Pendulums: {config.num_pendulums}")
    print(f"  Initial difference: {config.angle_spread:.0e} rad")
    print(f"  Output: {config.output_path}")
    print("=" * 60)

    print("\n[1/2] Creating animation...")
    fig, init, animate, total_frames = create_animation(config)

    print(f"\n[2/2] Rendering {total_frames} frames...")
    anim = FuncAnimation(fig, animate, init_func=init,
                         frames=total_frames, blit=True, interval=1000/config.fps)

    writer = FFMpegWriter(fps=config.fps, bitrate=5000,
                          codec='libx264',
                          extra_args=['-pix_fmt', 'yuv420p',
                                      '-preset', 'medium',
                                      '-crf', '18'])

    anim.save(config.output_path, writer=writer, dpi=config.dpi)
    plt.close(fig)

    print("\n" + "=" * 60)
    print("  RENDER COMPLETE!")
    print(f"  Output: {config.output_path}")
    print("=" * 60)


if __name__ == "__main__":
    main()
