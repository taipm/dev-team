#!/usr/bin/env python3
"""
TTS Generator for MathArt Videos
=================================

Generate voice narration using edge-tts (Microsoft Azure TTS).
Produces both Vietnamese and English versions with subtitles.

Author: YouTube MathArt Team - TTS Voice Agent
"""

import asyncio
import sys
from pathlib import Path

try:
    import edge_tts
except ImportError:
    print("Installing edge-tts...")
    import subprocess
    subprocess.run([sys.executable, "-m", "pip", "install", "edge-tts"], check=True)
    import edge_tts


# Voice configurations
VOICES = {
    "vi": {
        "id": "vi-VN-NamMinhNeural",
        "name": "Nam Minh",
        "rate": "-5%",
        "pitch": "+0Hz"
    },
    "en": {
        "id": "en-US-GuyNeural",
        "name": "Guy",
        "rate": "-3%",
        "pitch": "+0Hz"
    }
}


async def generate_tts(
    text: str,
    voice_id: str,
    output_audio: str,
    output_subtitles: str = None,
    rate: str = "+0%",
    pitch: str = "+0Hz"
) -> bool:
    """
    Generate TTS audio and subtitles.
    
    Args:
        text: Text to convert to speech
        voice_id: Edge TTS voice ID
        output_audio: Path for audio output (mp3)
        output_subtitles: Path for subtitles output (vtt)
        rate: Speech rate adjustment (e.g., "-5%", "+10%")
        pitch: Pitch adjustment (e.g., "-2Hz", "+5Hz")
    
    Returns:
        True if successful
    """
    try:
        communicate = edge_tts.Communicate(
            text,
            voice_id,
            rate=rate,
            pitch=pitch
        )
        
        if output_subtitles:
            await communicate.save(output_audio)
            # Generate subtitles separately
            submaker = edge_tts.SubMaker()
            async for chunk in communicate.stream():
                if chunk["type"] == "WordBoundary":
                    submaker.feed(chunk)
            
            with open(output_subtitles, "w", encoding="utf-8") as f:
                f.write(submaker.get_srt())
        else:
            await communicate.save(output_audio)
        
        return True
    except Exception as e:
        print(f"Error: {e}")
        return False


async def generate_both_languages(
    script_vi_path: str,
    script_en_path: str,
    output_dir: str
) -> dict:
    """
    Generate TTS for both Vietnamese and English.
    
    Args:
        script_vi_path: Path to Vietnamese script file
        script_en_path: Path to English script file
        output_dir: Directory for output files
    
    Returns:
        Dictionary with output file paths
    """
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    results = {}
    
    # Read scripts
    with open(script_vi_path, 'r', encoding='utf-8') as f:
        text_vi = f.read().strip()
    
    with open(script_en_path, 'r', encoding='utf-8') as f:
        text_en = f.read().strip()
    
    # Generate Vietnamese
    print(f"🗣️ Generating Vietnamese narration...")
    vi_config = VOICES["vi"]
    vi_audio = output_dir / "narration_vi.mp3"
    vi_subs = output_dir / "narration_vi.vtt"
    
    success_vi = await generate_tts(
        text_vi,
        vi_config["id"],
        str(vi_audio),
        str(vi_subs),
        vi_config["rate"],
        vi_config["pitch"]
    )
    
    if success_vi:
        results["narration_vi"] = str(vi_audio)
        results["subtitles_vi"] = str(vi_subs)
        print(f"  ✅ {vi_audio}")
    
    # Generate English
    print(f"🗣️ Generating English narration...")
    en_config = VOICES["en"]
    en_audio = output_dir / "narration_en.mp3"
    en_subs = output_dir / "narration_en.vtt"
    
    success_en = await generate_tts(
        text_en,
        en_config["id"],
        str(en_audio),
        str(en_subs),
        en_config["rate"],
        en_config["pitch"]
    )
    
    if success_en:
        results["narration_en"] = str(en_audio)
        results["subtitles_en"] = str(en_subs)
        print(f"  ✅ {en_audio}")
    
    return results


def main():
    """CLI entry point."""
    if len(sys.argv) < 4:
        print("Usage: python tts-generator.py <script_vi.txt> <script_en.txt> <output_dir>")
        print("Example: python tts-generator.py script_vi.txt script_en.txt ./output")
        sys.exit(1)
    
    script_vi = sys.argv[1]
    script_en = sys.argv[2]
    output_dir = sys.argv[3]
    
    print("=" * 60)
    print("  MATHART TTS GENERATOR")
    print("=" * 60)
    
    results = asyncio.run(generate_both_languages(script_vi, script_en, output_dir))
    
    print("\n" + "=" * 60)
    print("  TTS GENERATION COMPLETE")
    print("=" * 60)
    print(f"  Files generated: {len(results)}")
    for key, path in results.items():
        print(f"  - {key}: {path}")


if __name__ == "__main__":
    main()
