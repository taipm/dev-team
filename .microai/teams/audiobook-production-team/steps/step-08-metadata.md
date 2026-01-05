# Step 08: METADATA

> Embed tags and package for distribution

---

## Step Info

```yaml
step: 8
name: metadata
title: "Metadata & Packaging"
description: "Embed ID3 tags, create M4B with chapters, package for all platforms"

trigger: step.07.5.complete
agent: metadata-agent

duration: "5-15 minutes"
checkpoint: false
```

---

## Responsible Agent

**Metadata Agent** (`🏷️`)
- Embeds ID3 tags in MP3s
- Creates M4B with chapters
- Generates platform packages
- Prepares distribution assets

---

## Input

```yaml
input:
  from_steps: [step-07-review, step-07.5-cover-design]
  files:
    - mastered/chapter-{NNN}.mp3
    - mastered/full-audiobook.mp3
    - covers/cover-*.jpg
    - structure/table-of-contents.json
    - structure/book-structure.json

  subscribe:
    - quality.approved
    - cover.assets
    - structure.toc
```

---

## Process

### 1. ID3 Tag Embedding

```yaml
tags:
  title: "{book_title}"
  artist: "{author}"
  album_artist: "{narrator}"
  album: "{title} (Audiobook)"
  track: "{chapter_num}/{total_chapters}"
  genre: "Audiobook"
  year: "{publication_year}"
  cover: embedded
```

### 2. M4B Creation

```yaml
m4b:
  format: AAC 128kbps
  chapters:
    - source: table-of-contents.json
    - format: FFMETADATA1
  cover: embedded
  metadata: embedded
```

### 3. Platform Packages

```yaml
platforms:
  acx:
    files: [mp3s, cover-2400, metadata]
    requirements: ACX specs

  youtube:
    files: [full-audiobook, timestamps, description]
    requirements: video description format

  spotify:
    files: [episodes, rss, cover-3000]
    requirements: podcast format

  local:
    files: [mp3s, m4b, metadata, covers]
    requirements: complete archive
```

---

## Output

```yaml
output:
  files:
    - distribution/mp3/chapter-{NNN}.mp3  # Tagged
    - distribution/m4b/audiobook.m4b
    - distribution/metadata/audiobook-metadata.json
    - distribution/platforms/acx/
    - distribution/platforms/youtube/
    - distribution/platforms/spotify/
    - distribution/platforms/local/

  publish:
    - topic: metadata.complete
    - topic: distribution.ready
```

---

## Metadata Format

```json
{
  "audiobook_id": "AB-2026-01-04-...",
  "core": {
    "title": "...",
    "author": "...",
    "narrator": "...",
    "language": "..."
  },
  "content": {
    "genre": "...",
    "categories": [],
    "description": "..."
  },
  "technical": {
    "format": "MP3/M4B",
    "total_chapters": 14,
    "total_duration": "8:20:00",
    "bitrate": "192 kbps"
  },
  "chapters": [],
  "assets": {
    "covers": {},
    "audio_files": []
  },
  "platforms": {
    "acx": { "ready": true },
    "youtube": { "ready": true },
    "spotify": { "ready": true },
    "local": { "ready": true }
  }
}
```

---

## Success Criteria

```yaml
success:
  - all_mp3s_tagged: true
  - m4b_chapters_working: true
  - cover_embedded: true
  - all_platforms_packaged: true
  - metadata_valid: true
```

---

## Error Handling

```yaml
errors:
  tagging_failure:
    action: retry_without_cover
    fallback: copy_untagged

  m4b_creation_failed:
    action: provide_mp3_only
    note: "M4B unavailable"

  missing_metadata:
    action: use_defaults
```

---

## Next Step

- **Step 09: EXPORT** - Final export and session archival
