#!/usr/bin/env python3
"""
Auto-transcribe Vietnamese audio files using faster-whisper.

faster-whisper is 4x faster than OpenAI Whisper on CPU/M1.

Features:
- Vietnamese language support
- Batch processing
- Progress tracking
- Skip short/silent files

Usage:
    python auto_transcribe.py --input ./dataset/wavs --output ./transcripts.txt

Requirements:
    pip install faster-whisper
"""

import argparse
from pathlib import Path
import sys

try:
    from faster_whisper import WhisperModel
    USE_FASTER_WHISPER = True
except ImportError:
    USE_FASTER_WHISPER = False
    print("faster-whisper not found, falling back to openai-whisper")
    try:
        import whisper
    except ImportError:
        print("ERROR: Please install whisper: pip install faster-whisper or pip install openai-whisper")
        sys.exit(1)


def transcribe_with_faster_whisper(wav_dir: str, output_file: str,
                                    model_size: str = "medium",
                                    language: str = "vi"):
    """
    Transcribe using faster-whisper (recommended for M1).

    Args:
        wav_dir: Directory containing WAV files
        output_file: Output file path for transcripts
        model_size: Model size (tiny, base, small, medium, large-v3)
        language: Language code (vi for Vietnamese)
    """
    print(f"Loading faster-whisper model: {model_size}...")
    print("(First run will download the model, please wait...)\n")

    # Use int8 quantization for M1 Mac (faster, less memory)
    model = WhisperModel(
        model_size,
        device="cpu",
        compute_type="int8"  # int8 for M1, float16 for GPU
    )

    wav_files = sorted(Path(wav_dir).glob("*.wav"))
    total = len(wav_files)

    if total == 0:
        print(f"No WAV files found in {wav_dir}")
        return

    print(f"Found {total} WAV files to transcribe")
    print(f"Output: {output_file}")
    print("-" * 50)

    transcribed = 0
    skipped = 0

    with open(output_file, 'w', encoding='utf-8') as f:
        for i, wav_path in enumerate(wav_files):
            print(f"[{i+1}/{total}] {wav_path.name}...", end=" ", flush=True)

            try:
                segments, info = model.transcribe(
                    str(wav_path),
                    language=language,
                    beam_size=5,
                    vad_filter=True,  # Voice Activity Detection
                    vad_parameters=dict(
                        min_silence_duration_ms=500
                    )
                )

                # Collect all segments
                text_parts = []
                for segment in segments:
                    text_parts.append(segment.text.strip())

                text = " ".join(text_parts).strip()

                # Skip empty or very short transcripts
                if len(text) < 3:
                    print("skipped (empty/too short)")
                    skipped += 1
                    continue

                # Write to file
                f.write(f"{wav_path.name}|{text}\n")
                f.flush()  # Ensure data is written

                # Truncate for display
                display_text = text[:60] + "..." if len(text) > 60 else text
                print(f"{display_text}")
                transcribed += 1

            except Exception as e:
                print(f"error: {e}")
                skipped += 1

    print("-" * 50)
    print(f"Done! Transcribed: {transcribed}, Skipped: {skipped}")
    print(f"Transcripts saved to: {output_file}")


def transcribe_with_openai_whisper(wav_dir: str, output_file: str,
                                    model_size: str = "medium",
                                    language: str = "vi"):
    """
    Fallback transcription using OpenAI Whisper.

    Args:
        wav_dir: Directory containing WAV files
        output_file: Output file path for transcripts
        model_size: Model size (tiny, base, small, medium, large)
        language: Language code (vi for Vietnamese)
    """
    print(f"Loading OpenAI Whisper model: {model_size}...")
    print("(First run will download the model, please wait...)\n")

    model = whisper.load_model(model_size)

    wav_files = sorted(Path(wav_dir).glob("*.wav"))
    total = len(wav_files)

    if total == 0:
        print(f"No WAV files found in {wav_dir}")
        return

    print(f"Found {total} WAV files to transcribe")
    print(f"Output: {output_file}")
    print("-" * 50)

    transcribed = 0
    skipped = 0

    with open(output_file, 'w', encoding='utf-8') as f:
        for i, wav_path in enumerate(wav_files):
            print(f"[{i+1}/{total}] {wav_path.name}...", end=" ", flush=True)

            try:
                result = model.transcribe(
                    str(wav_path),
                    language=language,
                    task="transcribe",
                    verbose=False
                )

                text = result["text"].strip()

                # Skip empty or very short transcripts
                if len(text) < 3:
                    print("skipped (empty/too short)")
                    skipped += 1
                    continue

                # Write to file
                f.write(f"{wav_path.name}|{text}\n")
                f.flush()

                # Truncate for display
                display_text = text[:60] + "..." if len(text) > 60 else text
                print(f"{display_text}")
                transcribed += 1

            except Exception as e:
                print(f"error: {e}")
                skipped += 1

    print("-" * 50)
    print(f"Done! Transcribed: {transcribed}, Skipped: {skipped}")
    print(f"Transcripts saved to: {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description="Auto-transcribe Vietnamese audio files"
    )
    parser.add_argument(
        "--input", "-i",
        type=str,
        default="./dataset/wavs",
        help="Directory containing WAV files"
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default="./transcripts.txt",
        help="Output file for transcripts"
    )
    parser.add_argument(
        "--model", "-m",
        type=str,
        default="medium",
        choices=["tiny", "base", "small", "medium", "large", "large-v3"],
        help="Whisper model size (default: medium)"
    )
    parser.add_argument(
        "--language", "-l",
        type=str,
        default="vi",
        help="Language code (default: vi for Vietnamese)"
    )
    parser.add_argument(
        "--use-openai",
        action="store_true",
        help="Force use OpenAI Whisper instead of faster-whisper"
    )

    args = parser.parse_args()

    print("=" * 50)
    print("Vietnamese Audio Transcription")
    print("=" * 50)

    # Estimate time
    model_times = {
        "tiny": "~4 min/hour",
        "base": "~6 min/hour",
        "small": "~8 min/hour",
        "medium": "~15 min/hour",
        "large": "~30 min/hour",
        "large-v3": "~30 min/hour"
    }
    print(f"Model: {args.model} (estimated: {model_times.get(args.model, 'unknown')} on M1)")
    print()

    if USE_FASTER_WHISPER and not args.use_openai:
        transcribe_with_faster_whisper(
            wav_dir=args.input,
            output_file=args.output,
            model_size=args.model,
            language=args.language
        )
    else:
        transcribe_with_openai_whisper(
            wav_dir=args.input,
            output_file=args.output,
            model_size=args.model,
            language=args.language
        )


if __name__ == "__main__":
    main()
