# /audiobook - Audiobook Production Team

> Sản xuất audiobook tự động hoàn toàn từ đa nguồn input

---

## Command Info

```yaml
name: audiobook
version: "1.0"
team: audiobook-production-team
description: |
  Khởi động Audiobook Production Team - hệ thống multi-agent
  sản xuất audiobook chuyên nghiệp từ PDF, EPUB, Text, hoặc Web.
```

---

## Usage

```bash
# Từ file PDF
/audiobook path/to/book.pdf

# Từ EPUB
/audiobook path/to/ebook.epub

# Từ URL
/audiobook https://example.com/article

# Từ text file
/audiobook path/to/content.txt
```

---

## Arguments

| Argument | Description | Required |
|----------|-------------|----------|
| `source` | Path to file or URL | Yes |

---

## Workflow

```
Step 1: INIT         - Session setup
Step 2: INGESTION    - Extract content
Step 3: STRUCTURE    - Analyze chapters, genre
Step 4: ADAPTATION   - Text → speech script
Step 4.5: CHARACTER  - Voice mapping (fiction)
Step 5: PRODUCTION   - TTS generation
Step 6: ENGINEERING  - Audio mastering
Step 7: REVIEW       - Quality validation
Step 7.5: COVER      - Cover art generation
Step 8: METADATA     - Tagging & packaging
Step 9: EXPORT       - Final delivery
```

---

## Agents

| Icon | Agent | Role |
|------|-------|------|
| 📥 | Content Ingestion | Multi-source extraction |
| 📚 | Book Structure | Chapter detection, TOC |
| ✍️ | Script Adapter | Text→speech conversion |
| 🎭 | Character Voice | Fiction voice mapping |
| 🎤 | Audio Producer | TTS orchestration |
| 🎛️ | Audio Engineer | Mastering, merging |
| ✅ | Quality Reviewer | QC validation |
| 🎨 | Cover Designer | AI cover generation |
| 🏷️ | Metadata Agent | Distribution packaging |

---

## Output

```
distribution/
├── mp3/               # Tagged MP3 chapters
├── m4b/               # M4B with chapters
├── metadata/          # JSON metadata
└── platforms/
    ├── acx/           # Audible package
    ├── youtube/       # YouTube package
    ├── spotify/       # Podcast package
    └── local/         # Local archive
```

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Format | MP3 192kbps / M4B 128kbps |
| Sample Rate | 44100 Hz |
| Channels | Mono |
| Loudness | -14 LUFS |
| True Peak | -1.5 dBTP |

---

## Supported Input

| Format | Extension | Tool |
|--------|-----------|------|
| PDF | .pdf | pdftotext |
| EPUB | .epub | ebook-convert |
| DOCX | .docx | pandoc |
| Text | .txt, .md | direct |
| Web | http(s):// | readability |

---

## Dependencies

```yaml
required:
  - ffmpeg
  - edge-tts
  - pdftotext (poppler-utils)

optional:
  - ebook-convert (Calibre)
  - pandoc
  - jq
```

---

## Example Session

```bash
$ /audiobook ~/Documents/lean-startup.pdf

=== Audiobook Production Team ===
Session ID: AB-2026-01-04-lean-startup-001

[14:00:00] Step 01: INIT - Started
[14:00:01] Step 01: INIT - Completed

[14:00:01] Step 02: INGESTION - Started
[14:02:30] Extracted 75,000 words from PDF
[14:02:30] Step 02: INGESTION - Completed ✓

[14:02:30] Step 03: STRUCTURE - Started
[14:05:00] Detected 14 chapters, genre: business
[14:05:00] Step 03: STRUCTURE - Completed ✓

... (continues through all steps)

[15:30:00] Step 09: EXPORT - Completed ✓

=== SESSION COMPLETE ===
Duration: 8:20:00
Score: 92/100 (Grade A)
Output: output/audiobooks/AB-2026-01-04-lean-startup-001/
```

---

*Powered by MicroAI Audiobook Production Team v1.0*
