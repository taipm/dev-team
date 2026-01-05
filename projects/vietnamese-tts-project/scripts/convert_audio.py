#!/usr/bin/env python3
"""
Convert MP3 files to WAV format with proper preprocessing for TTS training.

Features:
- Resampling to 24kHz (optimal for F5-TTS)
- Mono conversion
- Loudness normalization to -23 LUFS
- Silence trimming (optional)

Usage:
    python convert_audio.py --input ./mp3_files --output ./dataset/wavs
"""

import argparse
import librosa
import numpy as np
from scipy.io import wavfile
import pyloudnorm as pyln
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed
import warnings

warnings.filterwarnings("ignore")


def process_single_file(args):
    """Process a single audio file."""
    filepath, output_dir, target_sr, trim_silence = args

    try:
        # Load audio
        audio, sr = librosa.load(str(filepath), sr=target_sr, mono=True)

        # Trim silence from beginning and end (optional)
        if trim_silence:
            audio, _ = librosa.effects.trim(audio, top_db=20)

        # Skip if too short (less than 0.5 seconds)
        if len(audio) < target_sr * 0.5:
            return filepath.name, "skipped (too short)"

        # Normalize loudness to -23 LUFS
        meter = pyln.Meter(target_sr)
        loudness = meter.integrated_loudness(audio)

        # Handle silent audio
        if np.isinf(loudness):
            return filepath.name, "skipped (silent)"

        audio = pyln.normalize.loudness(audio, loudness, -23.0)

        # Clip to prevent distortion
        audio = np.clip(audio, -1.0, 1.0)

        # Convert to int16
        audio_int16 = (audio * 32767).astype(np.int16)

        # Save as WAV
        output_path = output_dir / filepath.with_suffix('.wav').name
        wavfile.write(str(output_path), target_sr, audio_int16)

        duration = len(audio) / target_sr
        return filepath.name, f"converted ({duration:.1f}s)"

    except Exception as e:
        return filepath.name, f"error: {str(e)}"


def convert_audio_files(input_dir: str, output_dir: str,
                        target_sr: int = 24000,
                        trim_silence: bool = True,
                        workers: int = 4):
    """
    Convert all MP3 files in input directory to WAV format.

    Args:
        input_dir: Directory containing MP3 files
        output_dir: Directory to save WAV files
        target_sr: Target sample rate (default: 24000 for F5-TTS)
        trim_silence: Whether to trim silence from audio
        workers: Number of parallel workers
    """
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Find all MP3 files
    mp3_files = list(input_path.glob("*.mp3"))

    if not mp3_files:
        print(f"No MP3 files found in {input_dir}")
        return

    print(f"Found {len(mp3_files)} MP3 files")
    print(f"Output directory: {output_dir}")
    print(f"Target sample rate: {target_sr} Hz")
    print(f"Trim silence: {trim_silence}")
    print("-" * 50)

    # Prepare arguments for parallel processing
    args_list = [(f, output_path, target_sr, trim_silence) for f in mp3_files]

    # Process files
    converted = 0
    skipped = 0
    errors = 0

    with ProcessPoolExecutor(max_workers=workers) as executor:
        futures = {executor.submit(process_single_file, args): args[0]
                   for args in args_list}

        for i, future in enumerate(as_completed(futures)):
            filename, status = future.result()

            if "converted" in status:
                converted += 1
                print(f"[{i+1}/{len(mp3_files)}] {filename} - {status}")
            elif "skipped" in status:
                skipped += 1
                print(f"[{i+1}/{len(mp3_files)}] {filename} - {status}")
            else:
                errors += 1
                print(f"[{i+1}/{len(mp3_files)}] {filename} - {status}")

    print("-" * 50)
    print(f"Done! Converted: {converted}, Skipped: {skipped}, Errors: {errors}")
    print(f"WAV files saved to: {output_dir}")


def main():
    parser = argparse.ArgumentParser(
        description="Convert MP3 files to WAV for TTS training"
    )
    parser.add_argument(
        "--input", "-i",
        type=str,
        default="./mp3_files",
        help="Input directory containing MP3 files"
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default="./dataset/wavs",
        help="Output directory for WAV files"
    )
    parser.add_argument(
        "--sample-rate", "-sr",
        type=int,
        default=24000,
        help="Target sample rate (default: 24000)"
    )
    parser.add_argument(
        "--no-trim",
        action="store_true",
        help="Don't trim silence from audio"
    )
    parser.add_argument(
        "--workers", "-w",
        type=int,
        default=4,
        help="Number of parallel workers (default: 4)"
    )

    args = parser.parse_args()

    convert_audio_files(
        input_dir=args.input,
        output_dir=args.output,
        target_sr=args.sample_rate,
        trim_silence=not args.no_trim,
        workers=args.workers
    )


if __name__ == "__main__":
    main()
