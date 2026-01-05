#!/usr/bin/env python3
"""
Inference script for Vietnamese TTS using F5-TTS.

Features:
- Single text to speech
- Batch text to speech
- Interactive mode
- Support both pretrained and fine-tuned models

Usage:
    # Single text
    python inference.py --text "Xin chào, tôi là AI."

    # Batch from file
    python inference.py --batch ./texts.txt --output ./outputs

    # Interactive mode
    python inference.py --interactive

Requirements:
    pip install f5-tts soundfile
"""

import argparse
import sys
from pathlib import Path
import soundfile as sf


def check_dependencies():
    """Check if required dependencies are installed."""
    missing = []

    try:
        import torch
    except ImportError:
        missing.append("torch")

    try:
        import soundfile
    except ImportError:
        missing.append("soundfile")

    if missing:
        print("ERROR: Missing dependencies:")
        for dep in missing:
            print(f"  - {dep}")
        print("\nInstall with: pip install " + " ".join(missing))
        return False

    return True


def load_model(model_path: str = None, device: str = "cpu"):
    """
    Load F5-TTS model.

    Args:
        model_path: Path to fine-tuned model (None for pretrained)
        device: Device to use (cpu, mps, cuda)

    Returns:
        model: Loaded model
    """
    try:
        # Try to import F5-TTS
        from f5_tts.api import F5TTS

        print(f"Loading F5-TTS model...")
        print(f"Device: {device}")

        if model_path:
            print(f"Model path: {model_path}")
            model = F5TTS(ckpt_file=model_path, device=device)
        else:
            print("Using pretrained model (will download if needed)")
            model = F5TTS(device=device)

        print("Model loaded successfully!\n")
        return model

    except ImportError:
        print("ERROR: F5-TTS not installed.")
        print("\nInstall with:")
        print("  git clone https://github.com/nguyenthienhy/F5-TTS-Vietnamese.git")
        print("  cd F5-TTS-Vietnamese")
        print("  pip install -r requirements.txt")
        sys.exit(1)


def synthesize_text(model, text: str, output_path: str = None,
                    ref_audio: str = None, ref_text: str = None):
    """
    Synthesize speech from text.

    Args:
        model: F5-TTS model
        text: Text to synthesize
        output_path: Output WAV file path
        ref_audio: Reference audio for voice cloning
        ref_text: Reference text (transcript of ref_audio)

    Returns:
        audio: Generated audio numpy array
        sr: Sample rate
    """
    print(f"Generating: {text[:50]}{'...' if len(text) > 50 else ''}")

    try:
        # Generate speech
        if ref_audio and ref_text:
            # Voice cloning mode
            audio, sr, _ = model.infer(
                ref_file=ref_audio,
                ref_text=ref_text,
                gen_text=text,
                file_wave=output_path
            )
        else:
            # Standard mode (use model's default voice)
            audio, sr, _ = model.infer(
                gen_text=text,
                file_wave=output_path
            )

        if output_path:
            print(f"Saved to: {output_path}")

        return audio, sr

    except Exception as e:
        print(f"ERROR: {e}")
        return None, None


def batch_synthesize(model, input_file: str, output_dir: str,
                     ref_audio: str = None, ref_text: str = None):
    """
    Batch synthesize from text file.

    Args:
        model: F5-TTS model
        input_file: Text file with one sentence per line
        output_dir: Output directory for WAV files
        ref_audio: Reference audio for voice cloning
        ref_text: Reference text
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Read texts
    with open(input_file, 'r', encoding='utf-8') as f:
        texts = [line.strip() for line in f if line.strip()]

    if not texts:
        print(f"No texts found in {input_file}")
        return

    print(f"Found {len(texts)} texts to synthesize")
    print(f"Output directory: {output_dir}")
    print("-" * 50)

    for i, text in enumerate(texts):
        output_file = output_path / f"output_{i+1:04d}.wav"
        synthesize_text(
            model, text,
            output_path=str(output_file),
            ref_audio=ref_audio,
            ref_text=ref_text
        )

    print("-" * 50)
    print(f"Done! Generated {len(texts)} audio files")


def interactive_mode(model, ref_audio: str = None, ref_text: str = None):
    """
    Interactive TTS mode.

    Args:
        model: F5-TTS model
        ref_audio: Reference audio for voice cloning
        ref_text: Reference text
    """
    print("=" * 50)
    print("Interactive Vietnamese TTS")
    print("=" * 50)
    print("Type text to synthesize, or commands:")
    print("  /save <filename>  - Save last audio")
    print("  /ref <audio> <text> - Set reference audio")
    print("  /quit             - Exit")
    print("-" * 50)

    last_audio = None
    last_sr = None

    while True:
        try:
            text = input("\nText: ").strip()

            if not text:
                continue

            if text.startswith("/"):
                parts = text.split(maxsplit=2)
                cmd = parts[0].lower()

                if cmd == "/quit" or cmd == "/exit":
                    print("Goodbye!")
                    break

                elif cmd == "/save":
                    if last_audio is None:
                        print("No audio to save yet")
                        continue

                    filename = parts[1] if len(parts) > 1 else "output.wav"
                    if not filename.endswith(".wav"):
                        filename += ".wav"

                    sf.write(filename, last_audio, last_sr)
                    print(f"Saved to: {filename}")

                elif cmd == "/ref":
                    if len(parts) < 3:
                        print("Usage: /ref <audio_file> <text>")
                        continue
                    ref_audio = parts[1]
                    ref_text = parts[2]
                    print(f"Reference audio: {ref_audio}")
                    print(f"Reference text: {ref_text}")

                else:
                    print(f"Unknown command: {cmd}")

            else:
                # Synthesize
                audio, sr = synthesize_text(
                    model, text,
                    ref_audio=ref_audio,
                    ref_text=ref_text
                )

                if audio is not None:
                    last_audio = audio
                    last_sr = sr
                    print("Generated! Use /save to save the audio")

        except KeyboardInterrupt:
            print("\n\nGoodbye!")
            break


def main():
    parser = argparse.ArgumentParser(
        description="Vietnamese TTS Inference with F5-TTS"
    )

    # Input options
    input_group = parser.add_mutually_exclusive_group()
    input_group.add_argument(
        "--text", "-t",
        type=str,
        help="Text to synthesize"
    )
    input_group.add_argument(
        "--batch", "-b",
        type=str,
        help="Text file for batch synthesis (one sentence per line)"
    )
    input_group.add_argument(
        "--interactive", "-i",
        action="store_true",
        help="Interactive mode"
    )

    # Output options
    parser.add_argument(
        "--output", "-o",
        type=str,
        default="./outputs",
        help="Output file/directory"
    )

    # Model options
    parser.add_argument(
        "--model", "-m",
        type=str,
        default=None,
        help="Path to fine-tuned model checkpoint"
    )
    parser.add_argument(
        "--device", "-d",
        type=str,
        default="cpu",
        choices=["cpu", "mps", "cuda"],
        help="Device to use (default: cpu)"
    )

    # Voice cloning options
    parser.add_argument(
        "--ref-audio",
        type=str,
        default=None,
        help="Reference audio file for voice cloning"
    )
    parser.add_argument(
        "--ref-text",
        type=str,
        default=None,
        help="Transcript of reference audio"
    )

    args = parser.parse_args()

    # Check dependencies
    if not check_dependencies():
        sys.exit(1)

    # Load model
    model = load_model(
        model_path=args.model,
        device=args.device
    )

    # Run based on mode
    if args.interactive:
        interactive_mode(
            model,
            ref_audio=args.ref_audio,
            ref_text=args.ref_text
        )

    elif args.batch:
        batch_synthesize(
            model,
            input_file=args.batch,
            output_dir=args.output,
            ref_audio=args.ref_audio,
            ref_text=args.ref_text
        )

    elif args.text:
        # Single text synthesis
        output_file = args.output
        if not output_file.endswith(".wav"):
            Path(output_file).mkdir(parents=True, exist_ok=True)
            output_file = str(Path(output_file) / "output.wav")

        synthesize_text(
            model,
            text=args.text,
            output_path=output_file,
            ref_audio=args.ref_audio,
            ref_text=args.ref_text
        )

    else:
        parser.print_help()
        print("\nExamples:")
        print('  python inference.py --text "Xin chào, tôi là AI."')
        print('  python inference.py --batch texts.txt --output outputs/')
        print('  python inference.py --interactive')


if __name__ == "__main__":
    main()
