"""
Video Configuration Templates for YouTube MathArt
"""

from dataclasses import dataclass


@dataclass
class VideoConfig720p:
    """Standard 720p configuration for YouTube."""
    width: int = 1280
    height: int = 720
    fps: int = 30
    duration: int = 90
    dpi: int = 100
    bitrate: int = 5000
    codec: str = 'libx264'
    pixel_format: str = 'yuv420p'
    preset: str = 'medium'
    crf: int = 18


@dataclass
class VideoConfig1080p:
    """Premium 1080p configuration for YouTube."""
    width: int = 1920
    height: int = 1080
    fps: int = 60
    duration: int = 90
    dpi: int = 120
    bitrate: int = 8000
    codec: str = 'libx264'
    pixel_format: str = 'yuv420p'
    preset: str = 'slow'
    crf: int = 17


@dataclass
class VideoConfigPreview:
    """Quick preview configuration."""
    width: int = 854
    height: int = 480
    fps: int = 15
    duration: int = 90
    dpi: int = 72
    bitrate: int = 1500
    codec: str = 'libx264'
    pixel_format: str = 'yuv420p'
    preset: str = 'ultrafast'
    crf: int = 28


def get_ffmpeg_args(config) -> list:
    """Generate FFmpeg extra_args from config."""
    return [
        '-pix_fmt', config.pixel_format,
        '-preset', config.preset,
        '-crf', str(config.crf),
        '-movflags', '+faststart'
    ]
