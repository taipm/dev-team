#!/usr/bin/env python3
"""
Julia Set Morphing Animation - YouTube Ready (OPTIMIZED)
=========================================================

Uses Numba JIT compilation for 50-100x speedup.

Author: YouTube MathArt Team
Date: 2026-01-02
"""

import numpy as np
from numpy.typing import NDArray
from dataclasses import dataclass
from typing import Tuple
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.colors import LinearSegmentedColormap
from numba import jit, prange
import time


# ═══════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════

@dataclass
class VideoConfig:
    """Video export configuration."""
    width: int = 1280
    height: int = 720
    fps: int = 30
    duration: int = 90
    dpi: int = 100
    bitrate: int = 5000
    output_path: str = "/Volumes/OWC-taipm-ssd/Github/dev-team/.microai/workspaces/youtube-math-art/2026-01-02-julia-set/output/julia_set_morphing_720p.mp4"


@dataclass
class FractalConfig:
    """Julia Set parameters."""
    width: int = 1280              # Render width
    height: int = 720              # Render height
    max_iter: int = 150            # Reduced for speed, still looks good
    escape_radius: float = 4.0
    x_min: float = -1.8
    x_max: float = 1.8
    y_min: float = -1.0
    y_max: float = 1.0


# ═══════════════════════════════════════════════════════════════
# NUMBA-OPTIMIZED JULIA SET COMPUTATION
# ═══════════════════════════════════════════════════════════════

@jit(nopython=True, parallel=True, cache=True)
def compute_julia_numba(
    c_real: float,
    c_imag: float,
    width: int,
    height: int,
    x_min: float,
    x_max: float,
    y_min: float,
    y_max: float,
    max_iter: int,
    escape_radius: float
) -> NDArray[np.float64]:
    """
    Compute Julia Set using Numba JIT with parallel execution.
    50-100x faster than pure NumPy.
    """
    result = np.zeros((height, width), dtype=np.float64)

    dx = (x_max - x_min) / width
    dy = (y_max - y_min) / height
    escape_r2 = escape_radius * escape_radius

    for j in prange(height):
        y = y_min + j * dy
        for i in range(width):
            x = x_min + i * dx

            zr, zi = x, y
            iteration = 0

            while iteration < max_iter:
                zr2 = zr * zr
                zi2 = zi * zi

                if zr2 + zi2 > escape_r2:
                    # Smooth coloring
                    log_zn = np.log(zr2 + zi2) / 2
                    nu = np.log(log_zn / np.log(2)) / np.log(2)
                    result[j, i] = iteration + 1 - nu
                    break

                zi = 2 * zr * zi + c_imag
                zr = zr2 - zi2 + c_real
                iteration += 1

            if iteration == max_iter:
                result[j, i] = max_iter

    return result / max_iter


# ═══════════════════════════════════════════════════════════════
# COLORMAP
# ═══════════════════════════════════════════════════════════════

def create_colormap() -> LinearSegmentedColormap:
    """Create cosmic nebula colormap."""
    colors = [
        (0.00, '#0a0a12'),   # Deep space
        (0.05, '#0B3D91'),   # Deep blue
        (0.15, '#2EC4B6'),   # Cyan
        (0.35, '#4ECDC4'),   # Teal
        (0.50, '#F7C59F'),   # Warm cream
        (0.70, '#FF6B35'),   # Orange
        (0.85, '#FF006E'),   # Magenta
        (0.95, '#FF69B4'),   # Pink
        (1.00, '#FFFFFF'),   # White
    ]

    positions = [c[0] for c in colors]
    rgb_colors = []
    for _, hex_color in colors:
        h = hex_color.lstrip('#')
        rgb_colors.append(tuple(int(h[i:i+2], 16)/255 for i in (0, 2, 4)))

    cmap_dict = {'red': [], 'green': [], 'blue': []}
    for pos, rgb in zip(positions, rgb_colors):
        cmap_dict['red'].append((pos, rgb[0], rgb[0]))
        cmap_dict['green'].append((pos, rgb[1], rgb[1]))
        cmap_dict['blue'].append((pos, rgb[2], rgb[2]))

    return LinearSegmentedColormap('cosmic', cmap_dict)


# ═══════════════════════════════════════════════════════════════
# C PARAMETER PATH
# ═══════════════════════════════════════════════════════════════

def generate_c_path(total_frames: int) -> Tuple[NDArray, NDArray]:
    """Generate smooth path through interesting Julia sets."""
    t = np.linspace(0, 4 * np.pi, total_frames)

    # Smooth cardioid-like path
    r = 0.7885
    c_real = r * np.cos(t) * (1 + 0.1 * np.sin(3*t))
    c_imag = r * np.sin(t) * np.sin(t/2) * (1 + 0.1 * np.cos(2*t))

    return c_real.astype(np.float64), c_imag.astype(np.float64)


# ═══════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════

def main():
    video = VideoConfig()
    fractal = FractalConfig()

    total_frames = video.duration * video.fps

    print("=" * 60)
    print("  JULIA SET MORPHING - YouTube Animation (OPTIMIZED)")
    print("=" * 60)
    print(f"  Resolution: {video.width}x{video.height}")
    print(f"  Duration: {video.duration}s @ {video.fps}fps")
    print(f"  Frames: {total_frames}")
    print(f"  Max iterations: {fractal.max_iter}")
    print(f"  Optimization: Numba JIT + Parallel")
    print(f"  Output: {video.output_path}")
    print("=" * 60)

    # Generate c path
    c_real_path, c_imag_path = generate_c_path(total_frames)

    # Warm up Numba (first call compiles)
    print("\n[1/3] Compiling Numba kernels...")
    start = time.time()
    _ = compute_julia_numba(
        0.0, 0.0, fractal.width, fractal.height,
        fractal.x_min, fractal.x_max, fractal.y_min, fractal.y_max,
        fractal.max_iter, fractal.escape_radius
    )
    print(f"  Compiled in {time.time()-start:.2f}s")

    # Benchmark
    print("\n[2/3] Benchmarking...")
    start = time.time()
    for i in range(10):
        _ = compute_julia_numba(
            c_real_path[i], c_imag_path[i],
            fractal.width, fractal.height,
            fractal.x_min, fractal.x_max, fractal.y_min, fractal.y_max,
            fractal.max_iter, fractal.escape_radius
        )
    avg_time = (time.time() - start) / 10
    est_total = avg_time * total_frames / 60
    print(f"  Avg frame time: {avg_time*1000:.1f}ms")
    print(f"  Estimated render: {est_total:.1f} minutes")

    # Setup figure
    print("\n[3/3] Rendering...")
    plt.style.use('dark_background')
    fig, ax = plt.subplots(
        figsize=(video.width/video.dpi, video.height/video.dpi),
        dpi=video.dpi
    )
    fig.patch.set_facecolor('#0a0a12')
    ax.set_facecolor('#0a0a12')
    ax.axis('off')
    fig.subplots_adjust(left=0, right=1, top=1, bottom=0)

    cmap = create_colormap()

    # Initial frame
    initial = compute_julia_numba(
        c_real_path[0], c_imag_path[0],
        fractal.width, fractal.height,
        fractal.x_min, fractal.x_max, fractal.y_min, fractal.y_max,
        fractal.max_iter, fractal.escape_radius
    )
    im = ax.imshow(initial, cmap=cmap, aspect='auto',
                   extent=[fractal.x_min, fractal.x_max, fractal.y_min, fractal.y_max],
                   interpolation='bilinear')

    # Title
    title = ax.text(0.5, 0.95, 'JULIA SET MORPHING', transform=ax.transAxes,
                    fontsize=18, fontweight='bold', color='white',
                    ha='center', va='top', fontfamily='monospace', alpha=0.9)

    # c display
    c_text = ax.text(0.02, 0.02, '', transform=ax.transAxes,
                     fontsize=9, color='#2EC4B6', fontfamily='monospace', alpha=0.8)

    render_start = time.time()

    def animate(frame: int):
        data = compute_julia_numba(
            c_real_path[frame], c_imag_path[frame],
            fractal.width, fractal.height,
            fractal.x_min, fractal.x_max, fractal.y_min, fractal.y_max,
            fractal.max_iter, fractal.escape_radius
        )
        im.set_array(data)
        c_text.set_text(f'c = {c_real_path[frame]:.4f} + {c_imag_path[frame]:.4f}i')

        if frame % 100 == 0:
            elapsed = time.time() - render_start
            fps_actual = (frame + 1) / elapsed if elapsed > 0 else 0
            eta = (total_frames - frame) / fps_actual / 60 if fps_actual > 0 else 0
            print(f"  Frame {frame}/{total_frames} ({100*frame/total_frames:.1f}%) - "
                  f"{fps_actual:.1f} fps - ETA: {eta:.1f}min")

        return [im, c_text]

    anim = FuncAnimation(fig, animate, frames=total_frames,
                         interval=1000/video.fps, blit=True)

    writer = FFMpegWriter(
        fps=video.fps, bitrate=video.bitrate, codec='libx264',
        extra_args=['-pix_fmt', 'yuv420p', '-preset', 'medium', '-crf', '18']
    )

    anim.save(video.output_path, writer=writer, dpi=video.dpi)
    plt.close(fig)

    total_time = time.time() - render_start
    print("\n" + "=" * 60)
    print("  RENDER COMPLETE!")
    print(f"  Time: {total_time/60:.1f} minutes")
    print(f"  Avg FPS: {total_frames/total_time:.1f}")
    print(f"  Output: {video.output_path}")
    print("=" * 60)


if __name__ == "__main__":
    main()
