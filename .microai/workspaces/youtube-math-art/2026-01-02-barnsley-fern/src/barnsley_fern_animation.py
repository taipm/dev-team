#!/usr/bin/env python3
"""
Barnsley Fern Animation for YouTube
====================================

Generates a growth animation of the Barnsley Fern fractal.
Optimized with Numba JIT for fast rendering.

Author: YouTube MathArt Team - Algorithm Developer
"""

import numpy as np
from numba import jit, prange
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.colors import LinearSegmentedColormap
from pathlib import Path

# Video configuration
CONFIG = {
    "width": 1280,
    "height": 720,
    "fps": 30,
    "duration": 90,
    "dpi": 100,
    "output_dir": Path("/Volumes/OWC-taipm-ssd/Github/dev-team/.microai/workspaces/youtube-math-art/2026-01-02-barnsley-fern/output")
}

# IFS transformation probabilities
PROBS = np.array([0.01, 0.85, 0.07, 0.07])
CUM_PROBS = np.cumsum(PROBS)


@jit(nopython=True, cache=True)
def barnsley_transform(x: float, y: float, r: float) -> tuple:
    """
    Apply one of 4 Barnsley Fern transformations based on random value.
    
    Args:
        x, y: Current point coordinates
        r: Random value [0, 1) for transformation selection
    
    Returns:
        New (x, y) coordinates
    """
    if r < 0.01:
        # f1: Stem (1%)
        return 0.0, 0.16 * y
    elif r < 0.86:
        # f2: Main leaflet (85%)
        return 0.85 * x + 0.04 * y, -0.04 * x + 0.85 * y + 1.6
    elif r < 0.93:
        # f3: Left leaflet (7%)
        return 0.2 * x - 0.26 * y, 0.23 * x + 0.22 * y + 1.6
    else:
        # f4: Right leaflet (7%)
        return -0.15 * x + 0.28 * y, 0.26 * x + 0.24 * y + 0.44


@jit(nopython=True, parallel=True, cache=True)
def generate_fern_points(n_points: int, seed: int = 42) -> tuple:
    """
    Generate Barnsley Fern points using IFS.
    
    Args:
        n_points: Number of points to generate
        seed: Random seed for reproducibility
    
    Returns:
        Arrays of x and y coordinates
    """
    np.random.seed(seed)
    
    x_points = np.zeros(n_points, dtype=np.float64)
    y_points = np.zeros(n_points, dtype=np.float64)
    
    x, y = 0.0, 0.0
    randoms = np.random.random(n_points)
    
    for i in range(n_points):
        x, y = barnsley_transform(x, y, randoms[i])
        x_points[i] = x
        y_points[i] = y
    
    return x_points, y_points


def create_fern_colormap():
    """Create custom green gradient colormap."""
    colors = [
        (0.11, 0.37, 0.11),   # Dark forest green
        (0.18, 0.56, 0.18),   # Medium green
        (0.29, 0.73, 0.29),   # Fresh green
        (0.49, 0.87, 0.49),   # Light green
    ]
    return LinearSegmentedColormap.from_list("fern", colors, N=256)


def create_animation():
    """Create the Barnsley Fern growth animation."""
    print("=" * 60)
    print("  BARNSLEY FERN - ANIMATION GENERATION")
    print("=" * 60)
    
    total_frames = CONFIG["fps"] * CONFIG["duration"]
    max_points = 500000
    points_per_frame = max_points // total_frames
    
    print(f"  Resolution: {CONFIG['width']}x{CONFIG['height']}")
    print(f"  Duration: {CONFIG['duration']}s @ {CONFIG['fps']}fps")
    print(f"  Total frames: {total_frames}")
    print(f"  Max points: {max_points:,}")
    
    # Pre-generate all points
    print("\n  Generating fern points...")
    x_all, y_all = generate_fern_points(max_points, seed=42)
    print(f"  ✓ Generated {max_points:,} points")
    
    # Normalize for display
    x_min, x_max = x_all.min(), x_all.max()
    y_min, y_max = y_all.min(), y_all.max()
    
    # Setup figure
    fig_width = CONFIG["width"] / CONFIG["dpi"]
    fig_height = CONFIG["height"] / CONFIG["dpi"]
    fig, ax = plt.subplots(figsize=(fig_width, fig_height), dpi=CONFIG["dpi"])
    fig.patch.set_facecolor('#0a0a12')
    ax.set_facecolor('#0a0a12')
    ax.set_xlim(x_min - 0.5, x_max + 0.5)
    ax.set_ylim(y_min - 0.5, y_max + 0.5)
    ax.set_aspect('equal')
    ax.axis('off')
    
    # Color map
    cmap = create_fern_colormap()
    
    # Scatter plot (will be updated)
    scatter = ax.scatter([], [], c=[], cmap=cmap, s=0.3, alpha=0.7)
    
    # Title (fades in first 2 seconds)
    title = ax.text(0.5, 0.95, "Barnsley Fern", transform=ax.transAxes,
                    fontsize=24, color='white', alpha=0,
                    ha='center', va='top', fontweight='bold',
                    fontfamily='sans-serif')
    
    def init():
        scatter.set_offsets(np.c_[[], []])
        return scatter, title
    
    def animate(frame):
        # Calculate how many points to show
        progress = frame / total_frames
        
        # Growth curve: slow start, accelerate, slow end
        # Using smoothstep for natural growth
        t = progress
        growth = t * t * (3 - 2 * t)  # Smoothstep
        
        n_points = int(growth * max_points)
        n_points = max(100, min(n_points, max_points))
        
        # Update scatter
        x_show = x_all[:n_points]
        y_show = y_all[:n_points]
        scatter.set_offsets(np.c_[x_show, y_show])
        scatter.set_array(y_show)  # Color by height
        
        # Title fade in (first 60 frames = 2 seconds)
        if frame < 60:
            title.set_alpha(frame / 60)
        elif frame > total_frames - 90:  # Fade out last 3 seconds
            title.set_alpha((total_frames - frame) / 90)
        else:
            title.set_alpha(1.0)
        
        # Progress indicator
        if frame % 100 == 0:
            pct = (frame / total_frames) * 100
            print(f"  Frame {frame}/{total_frames} ({pct:.1f}%) - {n_points:,} points")
        
        return scatter, title
    
    # Create animation
    print("\n  Creating animation...")
    anim = FuncAnimation(
        fig, animate, init_func=init,
        frames=total_frames, interval=1000/CONFIG["fps"],
        blit=True
    )
    
    # Save video (no audio - will be added later)
    output_path = CONFIG["output_dir"] / "barnsley_fern_720p_raw.mp4"
    CONFIG["output_dir"].mkdir(parents=True, exist_ok=True)
    
    print(f"\n  Rendering to {output_path}...")
    writer = FFMpegWriter(
        fps=CONFIG["fps"],
        codec='libx264',
        bitrate=5000,
        extra_args=['-pix_fmt', 'yuv420p', '-preset', 'medium']
    )
    
    anim.save(str(output_path), writer=writer, dpi=CONFIG["dpi"])
    plt.close(fig)
    
    print(f"\n  ✅ Video saved: {output_path}")
    print("=" * 60)
    
    return str(output_path)


if __name__ == "__main__":
    output = create_animation()
    print(f"\nOutput: {output}")
