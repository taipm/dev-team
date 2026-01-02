#!/usr/bin/env python3
"""
Ambient Audio Generator for Julia Set
======================================

Generates cosmic ambient soundscape matching Julia Set morphing visuals.
Style: Deep space, ethereal, evolving textures.

Author: YouTube MathArt Team - Audio Composer
"""

import numpy as np
from scipy.io import wavfile
from scipy import signal
import subprocess
from pathlib import Path


def generate_ambient_audio(
    duration: int = 90,
    sample_rate: int = 44100,
    output_path: str = "ambient_audio.wav"
) -> str:
    """
    Generate ambient cosmic soundscape.

    Features:
    - Deep drone bass
    - Ethereal pad layers
    - Subtle harmonic movement
    - Smooth fade in/out
    """
    print(f"🎵 Generating {duration}s ambient audio...")

    samples = int(sample_rate * duration)
    t = np.linspace(0, duration, samples)

    # Initialize audio
    audio = np.zeros(samples, dtype=np.float64)

    # === Layer 1: Deep Drone (A1 = 55Hz) ===
    print("  Layer 1: Deep drone...")
    base_freq = 55  # A1
    drone = np.sin(2 * np.pi * base_freq * t) * 0.15
    # Add subtle pitch modulation
    mod = np.sin(2 * np.pi * 0.03 * t) * 2  # Very slow pitch wobble
    drone += np.sin(2 * np.pi * (base_freq + mod) * t) * 0.1
    audio += drone

    # === Layer 2: Ethereal Pad (A2, E3, A3) ===
    print("  Layer 2: Ethereal pad...")
    pad_freqs = [110, 165, 220, 330]  # A minor chord
    for i, freq in enumerate(pad_freqs):
        # Each voice with different slow modulation
        mod_speed = 0.05 + i * 0.02
        amplitude = 0.08 / (i + 1)
        envelope = 0.5 + 0.5 * np.sin(2 * np.pi * mod_speed * t)
        voice = np.sin(2 * np.pi * freq * t) * amplitude * envelope
        audio += voice

    # === Layer 3: High Shimmer (harmonics) ===
    print("  Layer 3: High shimmer...")
    shimmer_freqs = [880, 1320, 1760]  # High harmonics
    for i, freq in enumerate(shimmer_freqs):
        # Very subtle, slowly evolving
        mod_speed = 0.02 + i * 0.01
        amplitude = 0.02 / (i + 1)
        envelope = 0.3 + 0.7 * np.sin(2 * np.pi * mod_speed * t + i)
        shimmer = np.sin(2 * np.pi * freq * t) * amplitude * envelope
        audio += shimmer

    # === Layer 4: Noise texture ===
    print("  Layer 4: Space texture...")
    noise = np.random.randn(samples) * 0.01
    # Lowpass filter for smooth texture
    b, a = signal.butter(4, 500 / (sample_rate / 2), 'low')
    noise_filtered = signal.filtfilt(b, a, noise)
    audio += noise_filtered * 0.5

    # === Layer 5: Slow sweep (movement) ===
    print("  Layer 5: Sweep movement...")
    sweep_freq = 110 + 55 * np.sin(2 * np.pi * 0.02 * t)  # Slow freq sweep
    sweep = np.sin(2 * np.pi * np.cumsum(sweep_freq) / sample_rate) * 0.05
    audio += sweep

    # === Master Processing ===
    print("  Processing...")

    # Fade in (5 seconds)
    fade_in_samples = int(5 * sample_rate)
    fade_in = np.linspace(0, 1, fade_in_samples) ** 2  # Quadratic fade
    audio[:fade_in_samples] *= fade_in

    # Fade out (5 seconds)
    fade_out_samples = int(5 * sample_rate)
    fade_out = np.linspace(1, 0, fade_out_samples) ** 2
    audio[-fade_out_samples:] *= fade_out

    # Normalize to -14 LUFS approximately (target: -0.3 peak)
    peak = np.max(np.abs(audio))
    audio = audio / peak * 0.3

    # Soft limiting
    audio = np.tanh(audio * 1.5) / 1.5

    # Convert to 16-bit stereo
    audio_16bit = (audio * 32767).astype(np.int16)
    stereo = np.column_stack((audio_16bit, audio_16bit))

    # Save WAV
    wavfile.write(output_path, sample_rate, stereo)
    print(f"  ✅ Saved: {output_path}")

    return output_path


def convert_to_m4a(wav_path: str, m4a_path: str) -> str:
    """Convert WAV to M4A with loudness normalization."""
    print(f"🔄 Converting to M4A with loudness normalization...")

    cmd = [
        "ffmpeg", "-y",
        "-i", wav_path,
        "-af", "loudnorm=I=-14:LRA=7:TP=-2",
        "-c:a", "aac",
        "-b:a", "128k",
        m4a_path
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode == 0:
        print(f"  ✅ Saved: {m4a_path}")
        # Remove temp WAV
        Path(wav_path).unlink()
        return m4a_path
    else:
        print(f"  ❌ Error: {result.stderr}")
        return wav_path


def main():
    output_dir = Path("/Volumes/OWC-taipm-ssd/Github/dev-team/.microai/workspaces/youtube-math-art/2026-01-02-julia-set/output")

    print("=" * 60)
    print("  JULIA SET - AMBIENT AUDIO GENERATION")
    print("=" * 60)

    # Generate WAV
    wav_path = str(output_dir / "ambient_temp.wav")
    generate_ambient_audio(duration=90, output_path=wav_path)

    # Convert to M4A
    m4a_path = str(output_dir / "background_music.m4a")
    convert_to_m4a(wav_path, m4a_path)

    print("\n" + "=" * 60)
    print("  AUDIO GENERATION COMPLETE!")
    print("=" * 60)


if __name__ == "__main__":
    main()
