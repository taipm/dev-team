#!/usr/bin/env python3
"""
Create metadata CSV files for TTS training from transcripts.

Features:
- Split data into train/eval sets (90%/10%)
- Validate audio files exist
- Support custom speaker names
- Filter out problematic entries

Usage:
    python create_metadata.py --transcripts ./transcripts.txt --output ./dataset

Output:
    ./dataset/metadata_train.csv
    ./dataset/metadata_eval.csv
"""

import argparse
import csv
import random
from pathlib import Path
import os


def validate_transcript_line(line: str) -> tuple:
    """
    Validate and parse a transcript line.

    Expected format: filename.wav|text content

    Returns:
        (filename, text) or (None, None) if invalid
    """
    line = line.strip()

    if not line or line.startswith("#"):
        return None, None

    if "|" not in line:
        return None, None

    parts = line.split("|", 1)
    if len(parts) != 2:
        return None, None

    filename, text = parts
    filename = filename.strip()
    text = text.strip()

    # Validate filename
    if not filename.endswith(".wav"):
        return None, None

    # Validate text (not empty, reasonable length)
    if len(text) < 2:
        return None, None

    if len(text) > 1000:  # Truncate very long texts
        text = text[:1000]

    return filename, text


def create_metadata(transcripts_file: str, output_dir: str,
                    wavs_dir: str = None,
                    speaker_name: str = "MyVoice",
                    train_ratio: float = 0.9,
                    seed: int = 42):
    """
    Create train and eval metadata CSV files.

    Args:
        transcripts_file: Path to transcripts.txt
        output_dir: Output directory for CSV files
        wavs_dir: Directory containing WAV files (for validation)
        speaker_name: Speaker identifier
        train_ratio: Ratio of training data (default: 0.9)
        seed: Random seed for reproducibility
    """
    random.seed(seed)

    # Read and validate transcripts
    data = []
    skipped = 0

    print(f"Reading transcripts from: {transcripts_file}")

    with open(transcripts_file, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            filename, text = validate_transcript_line(line)

            if filename is None:
                if line.strip():  # Non-empty line that was skipped
                    skipped += 1
                continue

            # Validate WAV file exists (if wavs_dir provided)
            if wavs_dir:
                wav_path = Path(wavs_dir) / filename
                if not wav_path.exists():
                    print(f"  Warning: WAV not found: {filename}")
                    skipped += 1
                    continue

            data.append((f"wavs/{filename}", text, speaker_name))

    if not data:
        print("ERROR: No valid transcripts found!")
        return

    print(f"Valid entries: {len(data)}")
    print(f"Skipped entries: {skipped}")

    # Shuffle and split
    random.shuffle(data)
    split_idx = int(len(data) * train_ratio)
    train_data = data[:split_idx]
    eval_data = data[split_idx:]

    # Ensure at least 1 eval sample
    if len(eval_data) == 0 and len(train_data) > 1:
        eval_data = [train_data.pop()]

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Write CSV files
    for filename, dataset, desc in [
        ('metadata_train.csv', train_data, 'Training'),
        ('metadata_eval.csv', eval_data, 'Evaluation')
    ]:
        filepath = os.path.join(output_dir, filename)

        with open(filepath, 'w', encoding='utf-8', newline='') as f:
            writer = csv.writer(f, delimiter='|', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(['audio_file', 'text', 'speaker_name'])

            for row in dataset:
                writer.writerow(row)

        print(f"Created {filename}: {len(dataset)} samples")

    # Print summary
    print("-" * 50)
    print(f"Total samples: {len(data)}")
    print(f"Training: {len(train_data)} ({len(train_data)/len(data)*100:.1f}%)")
    print(f"Evaluation: {len(eval_data)} ({len(eval_data)/len(data)*100:.1f}%)")
    print(f"Output directory: {output_dir}")


def review_transcripts(transcripts_file: str, count: int = 20):
    """
    Display transcripts for review.

    Args:
        transcripts_file: Path to transcripts.txt
        count: Number of entries to display
    """
    print(f"Reviewing transcripts from: {transcripts_file}")
    print("=" * 60)

    with open(transcripts_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    print(f"Total lines: {len(lines)}\n")

    for i, line in enumerate(lines[:count]):
        filename, text = validate_transcript_line(line)
        if filename:
            print(f"{i+1}. {filename}")
            print(f"   {text[:80]}{'...' if len(text) > 80 else ''}")
            print()


def main():
    parser = argparse.ArgumentParser(
        description="Create metadata CSV files for TTS training"
    )
    parser.add_argument(
        "--transcripts", "-t",
        type=str,
        default="./transcripts.txt",
        help="Path to transcripts file"
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default="./dataset",
        help="Output directory for CSV files"
    )
    parser.add_argument(
        "--wavs", "-w",
        type=str,
        default=None,
        help="WAV files directory (for validation)"
    )
    parser.add_argument(
        "--speaker", "-s",
        type=str,
        default="MyVoice",
        help="Speaker name (default: MyVoice)"
    )
    parser.add_argument(
        "--train-ratio",
        type=float,
        default=0.9,
        help="Training data ratio (default: 0.9)"
    )
    parser.add_argument(
        "--review",
        action="store_true",
        help="Review transcripts instead of creating metadata"
    )
    parser.add_argument(
        "--review-count",
        type=int,
        default=20,
        help="Number of entries to review (default: 20)"
    )

    args = parser.parse_args()

    # Check if transcripts file exists
    if not os.path.exists(args.transcripts):
        print(f"ERROR: Transcripts file not found: {args.transcripts}")
        print("\nPlease run auto_transcribe.py first to generate transcripts.")
        return

    if args.review:
        review_transcripts(args.transcripts, args.review_count)
    else:
        # Auto-detect wavs directory if not specified
        wavs_dir = args.wavs
        if wavs_dir is None:
            possible_paths = [
                "./dataset/wavs",
                os.path.join(args.output, "wavs"),
                "./wavs"
            ]
            for path in possible_paths:
                if os.path.exists(path):
                    wavs_dir = path
                    break

        create_metadata(
            transcripts_file=args.transcripts,
            output_dir=args.output,
            wavs_dir=wavs_dir,
            speaker_name=args.speaker,
            train_ratio=args.train_ratio
        )


if __name__ == "__main__":
    main()
