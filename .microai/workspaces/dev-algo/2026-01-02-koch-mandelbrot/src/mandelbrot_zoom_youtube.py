#!/usr/bin/env python3
"""
Mandelbrot Zoom Animation - YouTube Viral Edition
==================================================

Deep zoom into the Mandelbrot set with smooth coloring.
Target: Seahorse Valley - one of the most beautiful regions.

Author: Python Team (MicroAI)
Date: 2026-01-02
"""

from __future__ import annotations

import numpy as np
from numpy.typing import NDArray
from dataclasses import dataclass
from typing import Tuple
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.colors import LinearSegmentedColormap
import colorsys
import math

# Numba JIT for 10-50x speedup
try:
    from numba import njit, prange
    NUMBA_AVAILABLE = True
    print("   [OK] Numba JIT enabled - expect 10-50x speedup!")
except ImportError:
    NUMBA_AVAILABLE = False
    print("   [WARN] Numba not installed. Run: pip install numba")

# =============================================================================
# CONFIGURATION
# =============================================================================

@dataclass(frozen=True)
class VideoConfig:
    """Video export configuration."""
    width: int = 1920
    height: int = 1080
    fps: int = 30
    dpi: int = 100
    bitrate: int = 12000
    codec: str = "h264"
    output_file: str = "mandelbrot_zoom_youtube.mp4"


@dataclass(frozen=True)
class MandelbrotConfig:
    """Mandelbrot rendering parameters."""
    # Zoom target - Seahorse Valley (beautiful spirals!)
    target_x: float = -0.743643887037151
    target_y: float = 0.131825904205330

    # Zoom parameters
    initial_width: float = 3.5  # Start view width
    zoom_factor: float = 0.92  # Each frame zooms by this factor
    total_frames: int = 300    # ~10 seconds at 30fps

    # Quality
    max_iter_start: int = 100   # Iterations at start
    max_iter_end: int = 1000    # Iterations at deep zoom

    # Resolution (render size, will be displayed at video size)
    render_width: int = 960
    render_height: int = 540


# =============================================================================
# CUSTOM COLORMAP - Vibrant fractal colors
# =============================================================================

def create_fractal_colormap() -> LinearSegmentedColormap:
    """Create a beautiful cyclic colormap for Mandelbrot."""
    # HSV-based smooth cycling
    colors = []
    n_colors = 256

    for i in range(n_colors):
        # Cycle through hues with varying saturation/value
        t = i / n_colors

        # Multiple color cycles for more variety
        hue = (t * 3) % 1.0  # 3 full hue cycles
        sat = 0.7 + 0.3 * np.sin(t * np.pi * 4)  # Varying saturation
        val = 0.5 + 0.5 * np.cos(t * np.pi * 2)  # Varying brightness

        rgb = colorsys.hsv_to_rgb(hue, sat, val)
        colors.append(rgb)

    return LinearSegmentedColormap.from_list('fractal', colors, N=256)


def create_fire_colormap() -> LinearSegmentedColormap:
    """Fire/lava style colormap - very YouTube viral."""
    colors = [
        (0.0, 0.0, 0.0),      # Black (inside set)
        (0.1, 0.0, 0.0),      # Dark red
        (0.5, 0.0, 0.0),      # Red
        (0.8, 0.2, 0.0),      # Orange-red
        (1.0, 0.5, 0.0),      # Orange
        (1.0, 0.8, 0.2),      # Yellow-orange
        (1.0, 1.0, 0.5),      # Light yellow
        (1.0, 1.0, 1.0),      # White (hot center)
        (0.5, 0.8, 1.0),      # Light blue
        (0.2, 0.4, 0.8),      # Blue
        (0.1, 0.1, 0.5),      # Dark blue
        (0.0, 0.0, 0.2),      # Very dark blue
        (0.0, 0.0, 0.0),      # Back to black
    ]
    return LinearSegmentedColormap.from_list('fire', colors, N=512)


def create_electric_colormap() -> LinearSegmentedColormap:
    """Electric neon style - matches Koch snowflake aesthetic."""
    colors = [
        (0.00, (0.02, 0.02, 0.08)),   # Near black
        (0.10, (0.0, 0.2, 0.4)),      # Dark blue
        (0.25, (0.0, 0.5, 0.8)),      # Blue
        (0.40, (0.0, 0.8, 1.0)),      # Cyan
        (0.50, (0.0, 1.0, 0.8)),      # Cyan-green
        (0.60, (0.2, 1.0, 0.4)),      # Green
        (0.70, (0.8, 1.0, 0.0)),      # Yellow-green
        (0.80, (1.0, 0.8, 0.0)),      # Yellow
        (0.90, (1.0, 0.4, 0.2)),      # Orange
        (1.00, (1.0, 1.0, 1.0)),      # White
    ]
    positions = [c[0] for c in colors]
    color_values = [c[1] for c in colors]
    return LinearSegmentedColormap.from_list('electric', list(zip(positions, color_values)), N=512)


# =============================================================================
# MANDELBROT ENGINE - Optimized with Numba JIT (10-50x faster!)
# =============================================================================

if NUMBA_AVAILABLE:
    @njit(parallel=True, fastmath=True, cache=True)
    def _mandelbrot_numba(
        xmin: float, xmax: float,
        ymin: float, ymax: float,
        width: int, height: int,
        max_iter: int
    ) -> np.ndarray:
        """
        Numba JIT-compiled Mandelbrot with parallel execution.

        Optimizations:
        - parallel=True: Uses all CPU cores
        - fastmath=True: Faster floating point (slight precision trade-off)
        - cache=True: Caches compilation for faster startup
        - prange: Parallel range for outer loop
        - Manual real/imag operations (faster than complex type)
        """
        # Output array
        result = np.empty((height, width), dtype=np.float64)

        # Coordinate steps
        dx = (xmax - xmin) / width
        dy = (ymax - ymin) / height

        # Parallel loop over rows
        for j in prange(height):
            cy = ymin + j * dy
            for i in range(width):
                cx = xmin + i * dx

                # Mandelbrot iteration (manual real/imag - faster than complex)
                zx = 0.0
                zy = 0.0
                iteration = 0

                # Main iteration loop
                while iteration < max_iter:
                    zx2 = zx * zx
                    zy2 = zy * zy

                    # Check escape: |z|^2 > 4
                    if zx2 + zy2 > 4.0:
                        break

                    # z = z^2 + c (manual complex multiplication)
                    zy = 2.0 * zx * zy + cy
                    zx = zx2 - zy2 + cx
                    iteration += 1

                # Smooth coloring for escaped points
                if iteration < max_iter:
                    # |z| for smooth coloring
                    abs_z = math.sqrt(zx * zx + zy * zy)
                    # Smooth iteration count: i + 1 - log2(log2(|z|))
                    smooth = iteration + 1.0 - math.log2(math.log2(abs_z + 1e-10))
                    result[j, i] = smooth
                else:
                    # Inside the set
                    result[j, i] = max_iter

        return result


def mandelbrot_set(
    xmin: float, xmax: float,
    ymin: float, ymax: float,
    width: int, height: int,
    max_iter: int
) -> NDArray[np.float64]:
    """
    Compute Mandelbrot set with smooth coloring.

    Uses Numba JIT if available (10-50x faster), falls back to NumPy.
    """
    if NUMBA_AVAILABLE:
        return _mandelbrot_numba(xmin, xmax, ymin, ymax, width, height, max_iter)

    # Fallback: NumPy implementation (slower but works without Numba)
    x = np.linspace(xmin, xmax, width)
    y = np.linspace(ymin, ymax, height)
    X, Y = np.meshgrid(x, y)

    C = X + 1j * Y
    Z = np.zeros_like(C)
    M = np.zeros(C.shape, dtype=np.float64)
    mask = np.ones(C.shape, dtype=bool)

    for i in range(max_iter):
        Z[mask] = Z[mask] ** 2 + C[mask]
        escaped = mask & (np.abs(Z) > 2)
        M[escaped] = i + 1 - np.log2(np.log2(np.abs(Z[escaped]) + 1e-10))
        mask = mask & ~escaped

    M[mask] = max_iter
    return M


def mandelbrot_smooth(
    center_x: float, center_y: float,
    view_width: float,
    width: int, height: int,
    max_iter: int
) -> NDArray[np.float64]:
    """
    Compute Mandelbrot centered on a point with given view width.
    """
    aspect = height / width
    view_height = view_width * aspect

    xmin = center_x - view_width / 2
    xmax = center_x + view_width / 2
    ymin = center_y - view_height / 2
    ymax = center_y + view_height / 2

    return mandelbrot_set(xmin, xmax, ymin, ymax, width, height, max_iter)


# =============================================================================
# ANIMATION RENDERER
# =============================================================================

class MandelbrotAnimator:
    """
    High-quality Mandelbrot zoom animator for YouTube.

    Features:
    - Smooth continuous zoom
    - Adaptive iteration count (more iterations as we zoom deeper)
    - Beautiful cyclic coloring
    - Info overlay showing zoom level
    """

    def __init__(
        self,
        video_config: VideoConfig | None = None,
        mandel_config: MandelbrotConfig | None = None,
    ) -> None:
        self.video_cfg = video_config or VideoConfig()
        self.mandel_cfg = mandel_config or MandelbrotConfig()

        # Create colormap
        self.cmap = create_electric_colormap()

        # Setup figure
        self._setup_figure()

    def _setup_figure(self) -> None:
        """Initialize matplotlib figure."""
        fig_width = self.video_cfg.width / self.video_cfg.dpi
        fig_height = self.video_cfg.height / self.video_cfg.dpi

        self.fig = plt.figure(
            figsize=(fig_width, fig_height),
            dpi=self.video_cfg.dpi,
            facecolor='black'
        )

        # Full-bleed image
        self.ax = self.fig.add_axes([0, 0, 1, 1])
        self.ax.axis('off')

        # Initialize with empty image
        self.im = self.ax.imshow(
            np.zeros((self.mandel_cfg.render_height, self.mandel_cfg.render_width)),
            cmap=self.cmap,
            aspect='auto',
            origin='lower'
        )

        # Title overlay
        self.title_text = self.ax.text(
            0.5, 0.96, 'MANDELBROT SET',
            transform=self.ax.transAxes,
            fontsize=24, fontweight='bold',
            color='white', alpha=0.9,
            ha='center', va='top',
            family='monospace'
        )

        # Zoom info
        self.zoom_text = self.ax.text(
            0.02, 0.04, '',
            transform=self.ax.transAxes,
            fontsize=12,
            color='white', alpha=0.8,
            ha='left', va='bottom',
            family='monospace'
        )

        # Coordinates info
        self.coord_text = self.ax.text(
            0.98, 0.04, '',
            transform=self.ax.transAxes,
            fontsize=10,
            color='white', alpha=0.6,
            ha='right', va='bottom',
            family='monospace'
        )

    def _get_view_width(self, frame: int) -> float:
        """Calculate view width for given frame (exponential zoom)."""
        return self.mandel_cfg.initial_width * (self.mandel_cfg.zoom_factor ** frame)

    def _get_max_iter(self, frame: int) -> int:
        """Adaptive iteration count - more iterations for deeper zoom."""
        progress = frame / self.mandel_cfg.total_frames
        # Exponential increase in iterations
        max_iter = int(
            self.mandel_cfg.max_iter_start +
            (self.mandel_cfg.max_iter_end - self.mandel_cfg.max_iter_start) * (progress ** 0.5)
        )
        return max_iter

    def _update_frame(self, frame: int) -> list:
        """Render frame for animation."""
        view_width = self._get_view_width(frame)
        max_iter = self._get_max_iter(frame)

        # Compute Mandelbrot
        M = mandelbrot_smooth(
            self.mandel_cfg.target_x,
            self.mandel_cfg.target_y,
            view_width,
            self.mandel_cfg.render_width,
            self.mandel_cfg.render_height,
            max_iter
        )

        # Normalize for coloring (log scale for better visualization)
        M_normalized = np.log1p(M) / np.log1p(max_iter)

        # Update image
        self.im.set_array(M_normalized)
        self.im.set_clim(0, 1)

        # Calculate zoom level
        zoom_level = self.mandel_cfg.initial_width / view_width

        # Update text overlays
        self.zoom_text.set_text(f'ZOOM: {zoom_level:.2e}x')
        self.coord_text.set_text(
            f'({self.mandel_cfg.target_x:.10f}, {self.mandel_cfg.target_y:.10f}i)'
        )

        # Progress indicator
        progress = (frame + 1) / self.mandel_cfg.total_frames * 100
        print(f'\r   Frame {frame+1}/{self.mandel_cfg.total_frames} ({progress:.1f}%) - Zoom: {zoom_level:.2e}x', end='')

        return [self.im, self.zoom_text, self.coord_text]

    def create_animation(self) -> FuncAnimation:
        """Create the matplotlib animation object."""
        anim = FuncAnimation(
            self.fig,
            self._update_frame,
            frames=self.mandel_cfg.total_frames,
            interval=1000 / self.video_cfg.fps,
            blit=True,
            repeat=False
        )
        return anim

    def export_video(self, filename: str | None = None) -> str:
        """Export animation to MP4 video."""
        output_file = filename or self.video_cfg.output_file

        # Calculate zoom depth
        final_zoom = self.mandel_cfg.initial_width / self._get_view_width(self.mandel_cfg.total_frames - 1)

        print("=" * 60)
        print("   MANDELBROT ZOOM - YouTube Animation Generator")
        print("=" * 60)
        print()
        print(f"   Target: Seahorse Valley")
        print(f"   Coordinates: ({self.mandel_cfg.target_x}, {self.mandel_cfg.target_y}i)")
        print(f"   Final zoom: {final_zoom:.2e}x")
        print()
        print(f"   Resolution: {self.video_cfg.width}x{self.video_cfg.height}")
        print(f"   FPS: {self.video_cfg.fps}")
        print(f"   Frames: {self.mandel_cfg.total_frames}")
        print(f"   Duration: {self.mandel_cfg.total_frames / self.video_cfg.fps:.1f} seconds")
        print()
        print("   Rendering...")
        print()

        # Create animation
        anim = self.create_animation()

        # Configure FFmpeg writer
        writer = FFMpegWriter(
            fps=self.video_cfg.fps,
            bitrate=self.video_cfg.bitrate,
            codec=self.video_cfg.codec,
            metadata={
                'title': 'Mandelbrot Set Deep Zoom',
                'artist': 'Python Team (MicroAI)',
                'comment': f'Zoom to {final_zoom:.2e}x into Seahorse Valley'
            },
            extra_args=[
                '-pix_fmt', 'yuv420p',
                '-preset', 'slow',
                '-crf', '18',
            ]
        )

        # Save video
        anim.save(output_file, writer=writer, dpi=self.video_cfg.dpi)

        print(f'\n\n   Video saved: {output_file}')
        print()
        print("   YouTube recommended settings:")
        print("   - Title: 'Mandelbrot Set Deep Zoom - Seahorse Valley'")
        print("   - Tags: mandelbrot, fractal, zoom, mathematics, infinity")
        print("   - Add relaxing music for viral potential!")

        return output_file

    def preview_frame(self, frame: int = 0) -> None:
        """Preview a single frame."""
        self._update_frame(frame)
        plt.show()


# =============================================================================
# MAIN
# =============================================================================

def warmup_jit() -> None:
    """Warmup Numba JIT compilation before main render."""
    if NUMBA_AVAILABLE:
        print("   Warming up JIT compiler...")
        # Small test run to trigger compilation
        _ = mandelbrot_set(-2, 1, -1, 1, 64, 64, 50)
        print("   JIT compilation complete!")


def main() -> None:
    """Main entry point."""
    # Warmup JIT before timing
    warmup_jit()

    video_config = VideoConfig(
        width=1280,       # YouTube 720p standard
        height=720,
        fps=30,
        bitrate=8000,     # Good quality, reasonable size
        output_file="mandelbrot_zoom_youtube.mp4"
    )

    mandel_config = MandelbrotConfig(
        # Seahorse Valley - stunning spirals
        target_x=-0.743643887037151,
        target_y=0.131825904205330,
        initial_width=3.5,
        zoom_factor=0.97,      # Faster zoom (was 0.995) - ~3x faster
        total_frames=1800,     # 60 seconds at 30fps (good for YouTube)
        max_iter_start=100,
        max_iter_end=500,      # Reduced from 1000 - still beautiful
        render_width=960,      # Render at lower res, upscale in export
        render_height=540,
    )

    animator = MandelbrotAnimator(video_config, mandel_config)
    animator.export_video()


if __name__ == "__main__":
    main()
