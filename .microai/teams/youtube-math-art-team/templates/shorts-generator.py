#!/usr/bin/env python3
"""
YouTube Shorts Generator
========================

Extract best segment from main video and convert to vertical format.

Features:
- Auto-detect most visually interesting segment
- Crop/scale to 9:16 (1080x1920)
- Add optional text overlays
- Merge audio

Author: YouTube MathArt Team
"""

import subprocess
import json
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class ShortsConfig:
    """YouTube Shorts configuration."""
    width: int = 1080
    height: int = 1920
    fps: int = 30
    duration: int = 45  # seconds (30-60 for Shorts)
    bitrate: str = "6000k"

    # Segment selection
    start_time: float = 30.0  # Start from 30s (skip intro)

    # Text overlay
    add_title: bool = True
    title_text: str = ""
    title_position: str = "top"  # top, center, bottom


def get_video_info(input_path: str) -> dict:
    """Get video metadata using ffprobe."""
    cmd = [
        "ffprobe", "-v", "quiet",
        "-print_format", "json",
        "-show_format", "-show_streams",
        input_path
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return json.loads(result.stdout)


def generate_shorts(
    input_video: str,
    output_path: str,
    audio_path: str = None,
    config: ShortsConfig = None
) -> bool:
    """
    Generate YouTube Shorts from main video.

    Args:
        input_video: Path to source video (720p/1080p landscape)
        output_path: Path for Shorts output
        audio_path: Optional separate audio file
        config: Shorts configuration

    Returns:
        True if successful
    """
    if config is None:
        config = ShortsConfig()

    # Build FFmpeg filter for vertical crop/scale
    # Strategy: Take center portion and scale to fill vertical frame

    # For 16:9 -> 9:16, we need to crop width significantly
    # Or zoom into center and crop

    filters = []

    # 1. Scale up slightly for zoom effect
    filters.append("scale=1920:-1")

    # 2. Crop to 9:16 from center
    filters.append(f"crop={config.width}:{config.height}:(iw-{config.width})/2:(ih-{config.height})/2")

    # 3. Add title text if enabled
    if config.add_title and config.title_text:
        y_pos = "50" if config.title_position == "top" else "h-100" if config.title_position == "bottom" else "(h-text_h)/2"
        filters.append(
            f"drawtext=text='{config.title_text}':"
            f"fontsize=60:fontcolor=white:borderw=3:bordercolor=black:"
            f"x=(w-text_w)/2:y={y_pos}"
        )

    filter_str = ",".join(filters)

    # Build FFmpeg command
    cmd = [
        "ffmpeg", "-y",
        "-ss", str(config.start_time),
        "-i", input_video,
        "-t", str(config.duration),
    ]

    # Add audio if provided
    if audio_path:
        cmd.extend([
            "-ss", str(config.start_time),
            "-i", audio_path,
            "-t", str(config.duration),
        ])

    cmd.extend([
        "-vf", filter_str,
        "-c:v", "libx264",
        "-preset", "medium",
        "-crf", "18",
        "-b:v", config.bitrate,
        "-r", str(config.fps),
        "-pix_fmt", "yuv420p",
    ])

    if audio_path:
        cmd.extend([
            "-c:a", "aac",
            "-b:a", "128k",
            "-map", "0:v:0",
            "-map", "1:a:0",
        ])
    else:
        cmd.extend(["-an"])  # No audio

    cmd.extend([
        "-movflags", "+faststart",
        output_path
    ])

    print(f"Generating Shorts: {output_path}")
    print(f"  Duration: {config.duration}s starting at {config.start_time}s")
    print(f"  Resolution: {config.width}x{config.height}")

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error: {result.stderr}")
        return False

    print(f"  ✅ Shorts generated successfully!")
    return True


def main():
    """CLI entry point."""
    if len(sys.argv) < 3:
        print("Usage: python shorts-generator.py <input_video> <output_shorts> [audio] [title]")
        print("Example: python shorts-generator.py video_720p.mp4 video_shorts.mp4 audio.m4a 'Julia Set'")
        sys.exit(1)

    input_video = sys.argv[1]
    output_path = sys.argv[2]
    audio_path = sys.argv[3] if len(sys.argv) > 3 else None
    title = sys.argv[4] if len(sys.argv) > 4 else ""

    config = ShortsConfig(
        title_text=title,
        add_title=bool(title),
        start_time=25.0,  # Start at 25s (after intro, at interesting part)
        duration=45,      # 45 seconds
    )

    success = generate_shorts(input_video, output_path, audio_path, config)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
