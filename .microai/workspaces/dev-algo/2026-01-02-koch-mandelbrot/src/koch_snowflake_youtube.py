#!/usr/bin/env python3
"""
Koch Snowflake Animation - YouTube Ready
=========================================

Optimized fractal generator with high-quality video export.
Resolution: 1920x1080 @ 60fps, H.264 codec.

Author: Python Team (MicroAI)
Date: 2026-01-02
"""

from __future__ import annotations

import numpy as np
from numpy.typing import NDArray
from typing import Generator, Tuple
from functools import lru_cache
from dataclasses import dataclass
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.figure import Figure
from matplotlib.axes import Axes
import matplotlib.patches as mpatches

# =============================================================================
# CONFIGURATION
# =============================================================================

@dataclass(frozen=True)
class VideoConfig:
    """Video export configuration."""
    width: int = 1920
    height: int = 1080
    fps: int = 60
    dpi: int = 120
    bitrate: int = 8000  # kbps
    codec: str = "h264"
    output_file: str = "koch_snowflake_youtube.mp4"


@dataclass(frozen=True)
class AnimationConfig:
    """Animation parameters."""
    max_depth: int = 10
    frames_per_level: int = 15  # 0.25 second per level at 60fps (fast!)
    pause_frames: int = 0  # No pause - continuous flow
    transition_frames: int = 10  # Smooth morph between levels
    line_width: float = 0.8  # Thinner for high detail
    line_color: str = "#00D4FF"  # Cyan neon
    bg_color: str = "#0A0A1A"  # Dark blue-black
    title_color: str = "#FFFFFF"
    stats_color: str = "#FFD700"  # Gold


# =============================================================================
# PRECOMPUTED CONSTANTS
# =============================================================================

# Rotation matrix for 60 degrees (pi/3)
_COS_60 = 0.5
_SIN_60 = np.sqrt(3) / 2
ROT_60: NDArray[np.float64] = np.array([
    [_COS_60, -_SIN_60],
    [_SIN_60,  _COS_60]
], dtype=np.float64)


# =============================================================================
# OPTIMIZED KOCH ENGINE
# =============================================================================

def koch_points_generator(
    p1: NDArray[np.float64],
    p2: NDArray[np.float64],
    depth: int
) -> Generator[NDArray[np.float64], None, None]:
    """
    Generate Koch curve points using generator (memory-efficient).

    Instead of list concatenation, yields points one by one.
    This reduces memory from O(4^n) allocations to O(n) stack depth.

    Args:
        p1: Start point [x, y]
        p2: End point [x, y]
        depth: Recursion depth (0 = straight line)

    Yields:
        Points along the Koch curve
    """
    if depth <= 0:
        yield p1
        return

    # Vector from p1 to p2, divided by 3
    v = (p2 - p1) / 3.0

    # Key points
    pA = p1 + v           # 1/3 point
    pB = p1 + 2.0 * v     # 2/3 point
    pC = pA + ROT_60 @ v  # Peak of triangle

    # Recurse into 4 segments
    yield from koch_points_generator(p1, pA, depth - 1)
    yield from koch_points_generator(pA, pC, depth - 1)
    yield from koch_points_generator(pC, pB, depth - 1)
    yield from koch_points_generator(pB, p2, depth - 1)


@lru_cache(maxsize=16)
def koch_snowflake(depth: int) -> NDArray[np.float64]:
    """
    Generate complete Koch Snowflake at given depth.

    Results are cached for repeated access during animation.

    Args:
        depth: Recursion depth (0 = triangle, 6 = very detailed)

    Returns:
        Array of shape (N, 2) with all points

    Raises:
        ValueError: If depth is negative or > 10
    """
    if depth < 0:
        raise ValueError(f"depth must be non-negative, got {depth}")
    if depth > 12:
        raise ValueError(f"depth > 12 causes memory issues, got {depth}")

    # Equilateral triangle vertices (centered)
    h = np.sqrt(3) / 2
    center_y = h / 3  # Center the triangle vertically

    vertices = [
        np.array([0.0, -center_y], dtype=np.float64),
        np.array([1.0, -center_y], dtype=np.float64),
        np.array([0.5, h - center_y], dtype=np.float64),
    ]

    # Collect all points from three edges
    points: list[NDArray[np.float64]] = []

    for i in range(3):
        p1 = vertices[i]
        p2 = vertices[(i + 1) % 3]
        points.extend(koch_points_generator(p1, p2, depth))

    # Close the curve
    points.append(vertices[0])

    return np.array(points, dtype=np.float64)


# =============================================================================
# STATISTICS CALCULATOR
# =============================================================================

def calculate_stats(depth: int) -> Tuple[int, float, float]:
    """
    Calculate Koch Snowflake statistics at given depth.

    Args:
        depth: Current iteration level

    Returns:
        Tuple of (num_segments, segment_length, total_perimeter)
        Assuming initial side length = 1
    """
    num_segments = 3 * (4 ** depth)
    segment_length = (1/3) ** depth
    total_perimeter = 3 * ((4/3) ** depth)

    return num_segments, segment_length, total_perimeter


# =============================================================================
# ANIMATION RENDERER
# =============================================================================

class KochAnimator:
    """
    High-quality Koch Snowflake animator for YouTube.

    Features:
    - 1920x1080 resolution
    - 60 FPS smooth animation
    - Dark theme with neon colors
    - Statistics overlay
    - Smooth transitions between levels
    """

    def __init__(
        self,
        video_config: VideoConfig | None = None,
        anim_config: AnimationConfig | None = None,
    ) -> None:
        self.video_cfg = video_config or VideoConfig()
        self.anim_cfg = anim_config or AnimationConfig()

        # Pre-generate all snowflake levels
        self._snowflakes: dict[int, NDArray[np.float64]] = {}
        for d in range(self.anim_cfg.max_depth + 1):
            self._snowflakes[d] = koch_snowflake(d)

        # Setup figure
        self.fig: Figure
        self.ax_main: Axes
        self.ax_stats: Axes
        self._setup_figure()

        # Animation state
        self._current_frame = 0
        self._line = None
        self._stats_text = None

    def _setup_figure(self) -> None:
        """Initialize matplotlib figure with dark theme."""
        # Calculate figure size from resolution and DPI
        fig_width = self.video_cfg.width / self.video_cfg.dpi
        fig_height = self.video_cfg.height / self.video_cfg.dpi

        # Create figure with dark background
        self.fig = plt.figure(
            figsize=(fig_width, fig_height),
            dpi=self.video_cfg.dpi,
            facecolor=self.anim_cfg.bg_color
        )

        # Main snowflake axes (left 75%)
        self.ax_main = self.fig.add_axes([0.05, 0.1, 0.65, 0.8])
        self.ax_main.set_facecolor(self.anim_cfg.bg_color)
        self.ax_main.set_aspect('equal')
        self.ax_main.axis('off')

        # Set view limits
        self.ax_main.set_xlim(-0.15, 1.15)
        self.ax_main.set_ylim(-0.4, 0.75)

        # Stats panel (right 25%)
        self.ax_stats = self.fig.add_axes([0.72, 0.1, 0.26, 0.8])
        self.ax_stats.set_facecolor(self.anim_cfg.bg_color)
        self.ax_stats.axis('off')

        # Title
        self.fig.suptitle(
            'Koch Snowflake',
            fontsize=28,
            fontweight='bold',
            color=self.anim_cfg.title_color,
            y=0.95
        )

    def _get_level_for_frame(self, frame: int) -> Tuple[int, int, float]:
        """
        Determine which depth levels to show and transition progress.

        Returns:
            (level_from, level_to, t) where t is interpolation 0-1
            When t=0: show level_from, when t=1: show level_to
        """
        frames_per_cycle = self.anim_cfg.frames_per_level + self.anim_cfg.transition_frames

        cycle = frame // frames_per_cycle
        frame_in_cycle = frame % frames_per_cycle

        level_from = min(cycle, self.anim_cfg.max_depth)
        level_to = min(cycle + 1, self.anim_cfg.max_depth)

        if frame_in_cycle < self.anim_cfg.frames_per_level:
            # Static display of current level
            return level_from, level_from, 0.0
        else:
            # Transition to next level
            transition_progress = (frame_in_cycle - self.anim_cfg.frames_per_level) / self.anim_cfg.transition_frames
            # Smooth easing (ease-in-out)
            t = 0.5 - 0.5 * np.cos(np.pi * transition_progress)
            return level_from, level_to, t

    def _update_frame(self, frame: int) -> list:
        """Update animation for given frame with smooth morphing."""
        level_from, level_to, t = self._get_level_for_frame(frame)

        # Clear previous drawings
        self.ax_main.clear()
        self.ax_stats.clear()

        # Redraw settings
        self.ax_main.set_facecolor(self.anim_cfg.bg_color)
        self.ax_main.axis('off')
        self.ax_main.set_xlim(-0.15, 1.15)
        self.ax_main.set_ylim(-0.4, 0.75)

        self.ax_stats.set_facecolor(self.anim_cfg.bg_color)
        self.ax_stats.axis('off')

        # Get points for current level(s)
        points_from = self._snowflakes[level_from]
        points_to = self._snowflakes[level_to]

        # Glow layers (outer to inner)
        glow_layers = [
            (6.0, 0.08, '#00D4FF'),   # Outer glow
            (4.0, 0.15, '#00D4FF'),   # Mid glow
            (2.5, 0.25, '#00D4FF'),   # Inner glow
        ]

        # During transition, crossfade between levels
        if t > 0 and level_from != level_to:
            # Fade out old level
            alpha_from = 1.0 - t
            for lw, a, color in glow_layers:
                self.ax_main.plot(
                    points_from[:, 0], points_from[:, 1],
                    color=color, linewidth=lw,
                    alpha=a * alpha_from,
                    solid_capstyle='round', solid_joinstyle='round'
                )
            self.ax_main.plot(
                points_from[:, 0], points_from[:, 1],
                color=self.anim_cfg.line_color,
                linewidth=self.anim_cfg.line_width,
                alpha=alpha_from,
                solid_capstyle='round', solid_joinstyle='round'
            )

            # Fade in new level
            alpha_to = t
            for lw, a, color in glow_layers:
                self.ax_main.plot(
                    points_to[:, 0], points_to[:, 1],
                    color=color, linewidth=lw,
                    alpha=a * alpha_to,
                    solid_capstyle='round', solid_joinstyle='round'
                )
            self._line, = self.ax_main.plot(
                points_to[:, 0], points_to[:, 1],
                color=self.anim_cfg.line_color,
                linewidth=self.anim_cfg.line_width,
                alpha=alpha_to,
                solid_capstyle='round', solid_joinstyle='round'
            )
            display_level = level_to if t > 0.5 else level_from
        else:
            # Static display
            for lw, a, color in glow_layers:
                self.ax_main.plot(
                    points_from[:, 0], points_from[:, 1],
                    color=color, linewidth=lw, alpha=a,
                    solid_capstyle='round', solid_joinstyle='round'
                )
            self._line, = self.ax_main.plot(
                points_from[:, 0], points_from[:, 1],
                color=self.anim_cfg.line_color,
                linewidth=self.anim_cfg.line_width,
                alpha=1.0,
                solid_capstyle='round', solid_joinstyle='round'
            )
            display_level = level_from

        # Draw iteration badge on main plot (subtle)
        self.ax_main.text(
            0.5, -0.32,
            f'Iteration {display_level}',
            fontsize=16,
            fontweight='normal',
            color='#666666',
            ha='center',
            va='center',
            transform=self.ax_main.transData
        )

        # Draw statistics panel
        self._draw_stats_panel(display_level)

        return [self._line]

    def _draw_stats_panel(self, level: int) -> None:
        """Draw statistics information panel with clean layout."""
        num_segments, seg_length, perimeter = calculate_stats(level)

        # Stats panel with proper vertical spacing
        y = 0.92

        # Title
        self.ax_stats.text(
            0.5, y, "STATISTICS",
            fontsize=18, fontweight='bold',
            color=self.anim_cfg.stats_color,
            transform=self.ax_stats.transAxes,
            ha='center', va='top'
        )
        y -= 0.12

        # Current iteration - large display
        self.ax_stats.text(
            0.5, y, f"n = {level}",
            fontsize=32, fontweight='bold',
            color=self.anim_cfg.line_color,
            transform=self.ax_stats.transAxes,
            ha='center', va='top'
        )
        y -= 0.14

        # Stats items
        stats_items = [
            ("Segments", f"{num_segments:,}"),
            ("Seg. Length", f"{seg_length:.6f}"),
            ("Perimeter", f"{perimeter:.4f}"),
        ]

        for label, value in stats_items:
            self.ax_stats.text(
                0.05, y, label,
                fontsize=12, color='#888888',
                transform=self.ax_stats.transAxes,
                ha='left', va='top'
            )
            self.ax_stats.text(
                0.95, y, value,
                fontsize=14, fontweight='bold',
                color=self.anim_cfg.title_color,
                transform=self.ax_stats.transAxes,
                ha='right', va='top'
            )
            y -= 0.08

        y -= 0.06

        # Formulas section
        self.ax_stats.text(
            0.5, y, "FORMULAS",
            fontsize=14, fontweight='bold',
            color=self.anim_cfg.stats_color,
            transform=self.ax_stats.transAxes,
            ha='center', va='top'
        )
        y -= 0.10

        formulas = [
            r"$N_n = 3 \times 4^n$",
            r"$L_n = s \times (1/3)^n$",
            r"$P_n = 3s \times (4/3)^n$",
        ]

        for formula in formulas:
            self.ax_stats.text(
                0.5, y, formula,
                fontsize=13,
                color=self.anim_cfg.title_color,
                transform=self.ax_stats.transAxes,
                ha='center', va='top'
            )
            y -= 0.07

        y -= 0.04

        # Limit info
        self.ax_stats.text(
            0.5, y, r"As $n \to \infty$:",
            fontsize=11, style='italic',
            color='#888888',
            transform=self.ax_stats.transAxes,
            ha='center', va='top'
        )
        y -= 0.06
        self.ax_stats.text(
            0.5, y, r"$P \to \infty$  |  $A = \frac{2\sqrt{3}}{5}s^2$",
            fontsize=11,
            color='#AAAAAA',
            transform=self.ax_stats.transAxes,
            ha='center', va='top'
        )

    def _calculate_total_frames(self) -> int:
        """Calculate total frames for the animation."""
        frames_per_cycle = self.anim_cfg.frames_per_level + self.anim_cfg.transition_frames
        # All levels + final hold
        return frames_per_cycle * self.anim_cfg.max_depth + self.anim_cfg.frames_per_level

    def create_animation(self) -> FuncAnimation:
        """Create the matplotlib animation object."""
        total_frames = self._calculate_total_frames()

        anim = FuncAnimation(
            self.fig,
            self._update_frame,
            frames=total_frames,
            interval=1000 / self.video_cfg.fps,  # Convert fps to interval
            blit=False,  # Can't blit with axis changes
            repeat=True
        )

        return anim

    def export_video(self, filename: str | None = None) -> str:
        """
        Export animation to MP4 video.

        Args:
            filename: Output filename (default from config)

        Returns:
            Path to saved video file
        """
        output_file = filename or self.video_cfg.output_file

        print(f"🎬 Starting video export: {output_file}")
        print(f"   Resolution: {self.video_cfg.width}x{self.video_cfg.height}")
        print(f"   FPS: {self.video_cfg.fps}")
        print(f"   Codec: {self.video_cfg.codec}")
        print(f"   Bitrate: {self.video_cfg.bitrate} kbps")

        # Create animation
        anim = self.create_animation()
        total_frames = self._calculate_total_frames()
        duration = total_frames / self.video_cfg.fps

        print(f"   Total frames: {total_frames}")
        print(f"   Duration: {duration:.1f} seconds")
        print()

        # Configure FFmpeg writer
        writer = FFMpegWriter(
            fps=self.video_cfg.fps,
            bitrate=self.video_cfg.bitrate,
            codec=self.video_cfg.codec,
            metadata={
                'title': 'Koch Snowflake Animation',
                'artist': 'Python Team (MicroAI)',
                'comment': 'Fractal geometry visualization'
            },
            extra_args=[
                '-pix_fmt', 'yuv420p',  # Compatibility for most players
                '-preset', 'slow',       # Better compression
                '-crf', '18',           # High quality
            ]
        )

        # Save video with progress
        print("🔄 Rendering frames...")
        anim.save(
            output_file,
            writer=writer,
            dpi=self.video_cfg.dpi,
            progress_callback=lambda i, n: print(f"\r   Progress: {i+1}/{n} ({100*(i+1)/n:.1f}%)", end='')
        )

        print(f"\n\n✅ Video saved: {output_file}")
        return output_file

    def preview(self) -> None:
        """Show interactive preview (without saving)."""
        anim = self.create_animation()
        plt.show()


# =============================================================================
# MAIN ENTRY POINT
# =============================================================================

def main() -> None:
    """Main entry point for Koch Snowflake animation."""
    print("=" * 60)
    print("   KOCH SNOWFLAKE - YouTube Animation Generator")
    print("=" * 60)
    print()

    # Configuration - YouTube standard 1m30s
    video_config = VideoConfig(
        width=1280,        # YouTube 720p
        height=720,
        fps=30,
        bitrate=8000,
        output_file="koch_snowflake_youtube.mp4"
    )

    anim_config = AnimationConfig(
        max_depth=6,           # n=0 to n=6 (clean progression)
        frames_per_level=300,  # 10 seconds per level
        transition_frames=100, # 3.3 second smooth morph
        line_color="#00D4FF",  # Neon cyan
        bg_color="#0A0A1A",    # Dark background
    )

    # Create animator
    animator = KochAnimator(video_config, anim_config)

    # Export video
    animator.export_video()

    print()
    print("🎉 Done! Your YouTube-ready video is ready.")
    print("   Upload to YouTube with these recommended settings:")
    print("   - Title: 'Koch Snowflake Fractal Animation'")
    print("   - Tags: fractal, mathematics, geometry, koch, snowflake")
    print("   - Category: Education or Science & Technology")


if __name__ == "__main__":
    main()
