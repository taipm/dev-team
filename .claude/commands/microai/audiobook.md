# Audiobook Production Team

Khởi động Audiobook Production Team - hệ thống multi-agent sản xuất audiobook tự động hoàn toàn.

## Input

$ARGUMENTS

## Team Configuration

```yaml
team: audiobook-production-team
location: .microai/teams/audiobook-production-team/
workflow: workflow.md
agents: 9
steps: 11
```

## Activation

Đọc và thực thi workflow từ:
`.microai/teams/audiobook-production-team/workflow.md`

## Features

- **Multi-source input**: PDF, EPUB, DOCX, Text, Web URL
- **Multi-genre**: Business, Fiction, Self-help, Technical
- **Multi-language**: Vietnamese + English
- **Multi-voice**: Character voice mapping for fiction
- **Multi-platform**: Audible/ACX, Spotify, YouTube, Local

## Pipeline Overview

```
INPUT → Ingestion → Structure → Adaptation → [Character Voice] →
Production → Engineering → Review → Cover Design → Metadata → EXPORT
```

## Usage Examples

```bash
# From PDF
/audiobook path/to/book.pdf

# From EPUB
/audiobook path/to/ebook.epub

# From Web URL
/audiobook https://example.com/article

# From text file
/audiobook path/to/content.txt
```

## Output

- MP3 chapters (tagged with ID3)
- M4B audiobook (with chapters)
- Cover art (multiple sizes)
- Platform packages (ACX, YouTube, Spotify)
- Comprehensive metadata

---

*Powered by MicroAI Audiobook Production Team v1.0*
