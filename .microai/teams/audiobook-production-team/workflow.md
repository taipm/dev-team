# Audiobook Production Team - Workflow Orchestration v1.0

> "From Manuscript to Masterpiece, Fully Automated"
> Chuyển đổi bất kỳ văn bản nào thành audiobook chất lượng broadcast, tự động hoàn toàn.

---

## Team Definition

```yaml
team: audiobook-production-team
version: "1.0"
description: |
  AI-powered team tự động sản xuất audiobook chuyên nghiệp từ đa nguồn input.
  Từ manuscript đến audiobook hoàn chỉnh với multi-voice, chapter management,
  và broadcast-quality audio. Hỗ trợ xuất bản đa nền tảng.

model: opus
language: vi
icon: "🎧"
color: "#8B5CF6"

type: pipeline
complexity: full

output_location: "output/audiobooks/"
auto_save: true

# Language Configuration
language_config:
  primary: vi
  with_diacritics: true
  enforcement:
    communication: vi
    reports: vi
    internal: vi
    code_examples: en
    technical_terms: preserve
  exceptions:
    - Code snippets and technical commands
    - URLs, file paths, identifiers
    - Industry-standard terms (LUFS, dBTP, etc.)

# Checkpoint System
checkpoint:
  enabled: true
  storage_path: ./checkpoints/
  git_integration: false
  auto_checkpoint: true
  checkpoint_after:
    - step-02-ingestion
    - step-03-structure
    - step-04-adaptation
    - step-05-production
    - step-06-engineering
    - step-07-review

# Inter-Agent Communication
communication:
  enabled: true
  bus_path: ./communication/
  message_timeout_ms: 10000
  max_retries: 3
  topics:
    - session.init
    - session.complete
    - session.error
    - content.raw_text
    - content.source_metadata
    - structure.chapters
    - structure.toc
    - structure.genre
    - script.adapted
    - script.prosody
    - voice.character_map
    - voice.dialogue_tagged
    - audio.segments
    - audio.timestamps
    - audio.chapters_merged
    - audio.mastered
    - cover.generated
    - quality.approved
    - quality.rejected
    - quality.report
    - metadata.complete
    - metadata.distribution_ready

# Kanban Board
kanban:
  enabled: true
  board_path: ./kanban/board.yaml
  columns:
    - backlog
    - ingesting
    - structuring
    - scripting
    - voicing
    - producing
    - engineering
    - reviewing
    - designing
    - packaging
    - exporting
    - done
    - quarantine

# Processing Mode
processing:
  mode: sequential
  parallel_chapters: true
  behavior:
    - Complete one book fully before starting next
    - Chapters can be processed in parallel within a book
    - Clear memory between books
    - Archive session after each book

# AI Stack
ai_stack:
  llm_primary: claude-sonnet
  llm_secondary: ollama/qwen3:1.7b
  tts_primary: edge-tts
  tts_fallback: gtts
  image_gen: dalle-3
  audio_processing: ffmpeg

# Production Targets
targets:
  capacity:
    short_book: "2-3 hours processing for 4-hour audiobook"
    standard_book: "4-6 hours processing for 8-hour audiobook"
    long_book: "8-12 hours processing for 15+ hour audiobook"
  quality:
    audio: "broadcast-ready (-14 LUFS)"
    success_rate: "> 95%"
  formats:
    - mp3 (192kbps)
    - m4b (128kbps AAC with chapters)
    - wav (archive)
```

---

## Team Composition: 9 Agents

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   AUDIOBOOK PRODUCTION TEAM v1.0                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  INGESTION (1):    📥 Content Ingestion Agent                           │
│                    PDF, EPUB, Text, Web extraction                       │
│                                                                          │
│  ANALYSIS (1):     📚 Book Structure Agent                              │
│                    Chapter detection, TOC, genre classification          │
│                                                                          │
│  ADAPTATION (2):   ✍️ Script Adapter Agent                              │
│                    Text-to-speech optimization, prosody                  │
│                    🎭 Character Voice Agent (Fiction only)               │
│                    Character detection, voice assignment                 │
│                                                                          │
│  PRODUCTION (2):   🎤 Audio Producer Agent                              │
│                    TTS orchestration, multi-voice generation             │
│                    🎛️ Audio Engineer Agent                               │
│                    Mastering, normalization, chapter assembly            │
│                                                                          │
│  QUALITY (1):      ✅ Quality Reviewer Agent                            │
│                    QC validation, scoring, approval                      │
│                                                                          │
│  PACKAGING (2):    🎨 Cover Designer Agent                              │
│                    AI cover generation, multi-size                       │
│                    🏷️ Metadata Agent                                     │
│                    ID3 tags, chapters, multi-platform                    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Agent Summary

| Step | Icon | Agent | Model | Focus |
|------|------|-------|-------|-------|
| 2 | 📥 | content-ingestion-agent | haiku | Multi-source extraction |
| 3 | 📚 | book-structure-agent | sonnet | Chapter detection, TOC |
| 4 | ✍️ | script-adapter-agent | sonnet | Text→speech optimization |
| 4.5 | 🎭 | character-voice-agent | sonnet | Fiction voice mapping |
| 5 | 🎤 | audio-producer-agent | haiku | TTS generation |
| 6 | 🎛️ | audio-engineer-agent | haiku | Mastering, merging |
| 7 | ✅ | quality-reviewer-agent | sonnet | QC validation |
| 7.5 | 🎨 | cover-designer-agent | sonnet | AI cover generation |
| 8 | 🏷️ | metadata-agent | haiku | Multi-platform distribution |

---

## 11-Step Production Pipeline

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      AUDIOBOOK PRODUCTION PIPELINE                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  INPUT: PDF / EPUB / Text / Web URL / AI-Generated                      │
│           │                                                              │
│           ▼                                                              │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 1: INIT                                                    │    │
│  │  • Create session directory                                      │    │
│  │  • Initialize communication channels                             │    │
│  │  • Load configuration                                            │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 2: INGESTION                    📥 Content Ingestion      │    │
│  │  • Detect input format                                          │    │
│  │  • Extract text content                                          │    │
│  │  • Clean and normalize                                           │    │
│  │  • Extract source metadata                                       │    │
│  │  [CHECKPOINT]                                                    │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 3: STRUCTURE                    📚 Book Structure         │    │
│  │  • Detect chapter boundaries                                     │    │
│  │  • Generate table of contents                                    │    │
│  │  • Classify genre                                                │    │
│  │  • Split into chapter files                                      │    │
│  │  [CHECKPOINT]                                                    │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 4: ADAPTATION                   ✍️ Script Adapter         │    │
│  │  • Expand abbreviations                                          │    │
│  │  • Convert numbers to words                                      │    │
│  │  • Add prosody hints                                             │    │
│  │  • Handle special characters                                     │    │
│  │  [CHECKPOINT]                                                    │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 4.5: CHARACTER VOICE            🎭 Character Voice        │    │
│  │  (Fiction only - skip for non-fiction)                          │    │
│  │  • Detect characters from dialogue                               │    │
│  │  • Assign unique voices                                          │    │
│  │  • Tag dialogue segments                                         │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 5: PRODUCTION                   🎤 Audio Producer         │    │
│  │  • Map text to voices                                            │    │
│  │  • Generate TTS segments                                         │    │
│  │  • Handle multi-voice switching                                  │    │
│  │  • Generate timestamps                                           │    │
│  │  [CHECKPOINT] [PARALLEL per chapter]                            │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 6: ENGINEERING                  🎛️ Audio Engineer         │    │
│  │  • Merge segments into chapters                                  │    │
│  │  • Normalize to -14 LUFS                                         │    │
│  │  • Remove long silences                                          │    │
│  │  • Apply fade in/out                                             │    │
│  │  • Merge chapters into full audiobook                            │    │
│  │  [CHECKPOINT]                                                    │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 7: REVIEW                       ✅ Quality Reviewer       │    │
│  │  • Verify audio specs (LUFS, sample rate)                        │    │
│  │  • Check for artifacts                                           │    │
│  │  • Validate chapter consistency                                  │    │
│  │  • Generate QC score                                             │    │
│  │  • Approve or reject                                             │    │
│  │  [CHECKPOINT]                                                    │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 7.5: COVER DESIGN               🎨 Cover Designer         │    │
│  │  • Generate AI cover (or use provided)                           │    │
│  │  • Create multiple sizes                                         │    │
│  │  • Optimize for platforms                                        │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 8: METADATA                     🏷️ Metadata Agent         │    │
│  │  • Generate description                                          │    │
│  │  • Create chapter markers                                        │    │
│  │  • Set ID3 tags                                                  │    │
│  │  • Prepare multi-platform metadata                               │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │  STEP 9: EXPORT                                                  │    │
│  │  • Package MP3 chapters                                          │    │
│  │  • Create M4B with chapters                                      │    │
│  │  • Generate distribution manifest                                │    │
│  │  • Archive session                                               │    │
│  └───────────────────────────┬─────────────────────────────────────┘    │
│                              ▼                                           │
│  OUTPUT:                                                                │
│  ├── {title}.mp3 (full audiobook)                                      │
│  ├── {title}.m4b (with chapters)                                       │
│  ├── chapters/ (individual MP3s)                                       │
│  ├── cover/ (multiple sizes)                                           │
│  └── metadata.json                                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Step Details

### Step 1: INIT

```yaml
step: 1
name: init
trigger: session_start
checkpoint: false

actions:
  - Generate session ID: AB-{YYYY-MM-DD}-{book-slug}-{SEQ}
  - Create session directory structure
  - Initialize communication channels
  - Load team configuration
  - Validate input source exists

outputs:
  - session-config.yaml
  - Directory structure ready

next: step-02-ingestion
```

### Step 2: INGESTION

```yaml
step: 2
name: ingestion
agent: content-ingestion-agent
trigger: init.complete
checkpoint: true

inputs:
  - Source file (PDF/EPUB/TXT/DOCX)
  - Or source URL

actions:
  - Detect input format
  - Extract text content
  - Clean OCR artifacts (if PDF)
  - Fix encoding issues
  - Extract embedded metadata

outputs:
  - raw/raw-content.txt
  - raw/source-metadata.json
  - raw/images/ (if any)

publishes:
  - content.raw_text
  - content.source_metadata

error_handling:
  on_failure: manual_input_fallback
  max_retries: 3

next: step-03-structure
```

### Step 3: STRUCTURE

```yaml
step: 3
name: structure
agent: book-structure-agent
trigger: ingestion.complete
checkpoint: true

subscribes:
  - content.raw_text
  - content.source_metadata

actions:
  - Detect chapter boundaries
  - Generate table of contents
  - Estimate chapter durations
  - Classify genre (business/fiction/education/technical)
  - Identify front/back matter
  - Split into chapter files

outputs:
  - structure/chapters/chapter-{NNN}.md
  - structure/table-of-contents.json
  - structure/book-structure.json

publishes:
  - structure.chapters
  - structure.toc
  - structure.genre

next: step-04-adaptation
```

### Step 4: ADAPTATION

```yaml
step: 4
name: adaptation
agent: script-adapter-agent
trigger: structure.complete
checkpoint: true

subscribes:
  - structure.chapters
  - structure.genre

actions:
  - Expand abbreviations (Mr. → Mister)
  - Convert numbers to spoken form
  - Handle special characters
  - Add prosody hints (pauses, emphasis)
  - Mark paragraph boundaries
  - Tag language segments (Vi/En)

outputs:
  - scripts/chapter-{NNN}-script.yaml
  - scripts/prosody-plan.json

publishes:
  - script.adapted
  - script.prosody

next: step-04.5-character-voice (if fiction) OR step-05-production
```

### Step 4.5: CHARACTER VOICE (Fiction Only)

```yaml
step: 4.5
name: character-voice
agent: character-voice-agent
trigger: adaptation.complete
condition: structure.genre == "fiction"
checkpoint: false

subscribes:
  - script.adapted
  - structure.genre

actions:
  - Detect character names from dialogue
  - Infer character gender/age
  - Assign unique voices to characters
  - Tag dialogue with speaker
  - Handle narrator vs character speech

outputs:
  - voice/character-map.yaml
  - voice/tagged-scripts/chapter-{NNN}-tagged.yaml

publishes:
  - voice.character_map
  - voice.dialogue_tagged

next: step-05-production
```

### Step 5: PRODUCTION

```yaml
step: 5
name: production
agent: audio-producer-agent
trigger: adaptation.complete OR character-voice.complete
checkpoint: true
parallel: per_chapter

subscribes:
  - script.adapted
  - script.prosody
  - voice.character_map (if fiction)
  - voice.dialogue_tagged (if fiction)

actions:
  - Map text segments to voices
  - Generate TTS for each segment (edge-tts)
  - Handle multi-voice switching
  - Apply prosody from script
  - Generate timestamp mapping

outputs:
  - audio/segments/chapter-{NNN}/segment-{NNNN}.mp3
  - audio/timestamps.json

publishes:
  - audio.segments
  - audio.timestamps

error_handling:
  on_failure: gtts_fallback
  max_retries: 3
  quarantine: per_segment

next: step-06-engineering
```

### Step 6: ENGINEERING

```yaml
step: 6
name: engineering
agent: audio-engineer-agent
trigger: production.complete
checkpoint: true

subscribes:
  - audio.segments
  - audio.timestamps
  - structure.chapters

actions:
  - Merge segments into chapter audio
  - Normalize volume to -14 LUFS
  - Remove long silences (>2s)
  - Apply fade in (0.5s) / fade out (1.0s)
  - Add chapter markers
  - Merge chapters into full audiobook

outputs:
  - mastered/chapter-{NNN}.mp3
  - mastered/full-audiobook.mp3
  - mastered/audio-report.json

publishes:
  - audio.chapters_merged
  - audio.mastered

next: step-07-review
```

### Step 7: REVIEW

```yaml
step: 7
name: review
agent: quality-reviewer-agent
trigger: engineering.complete
checkpoint: true

subscribes:
  - audio.chapters_merged
  - audio.mastered
  - structure.toc

actions:
  - Verify audio specs (LUFS, sample rate, bitrate)
  - Check for clipping, artifacts
  - Validate chapter consistency
  - Spot-check pronunciation
  - Generate QC score
  - Make approval decision

outputs:
  - qc/qc-report.json
  - qc/issues.md (if any)

publishes:
  - quality.approved OR quality.rejected
  - quality.report

on_reject:
  action: quarantine
  notify: observer
  allow_manual_override: true

next: step-07.5-cover-design (if approved)
```

### Step 7.5: COVER DESIGN

```yaml
step: 7.5
name: cover-design
agent: cover-designer-agent
trigger: review.approved
checkpoint: false

subscribes:
  - structure.toc
  - content.source_metadata

actions:
  - Generate cover prompt from book info
  - Create AI-generated cover (or use provided)
  - Generate multiple sizes:
    - 3000x3000 (high-res)
    - 2400x2400 (Audible)
    - 1400x1400 (standard)
    - 500x500 (thumbnail)
  - Optimize for different platforms

outputs:
  - cover/cover-3000x3000.jpg
  - cover/cover-2400x2400.jpg
  - cover/cover-1400x1400.jpg
  - cover/cover-thumbnail.jpg

publishes:
  - cover.generated

next: step-08-metadata
```

### Step 8: METADATA

```yaml
step: 8
name: metadata
agent: metadata-agent
trigger: cover-design.complete
checkpoint: false

subscribes:
  - quality.approved
  - structure.toc
  - content.source_metadata
  - cover.generated

actions:
  - Generate audiobook description
  - Create chapter markers for M4B
  - Set ID3 tags for MP3
  - Prepare platform-specific metadata:
    - Audible ACX specs
    - Spotify podcast format
    - YouTube Music format
    - Google Play format
  - Create distribution manifest

outputs:
  - final/metadata.json
  - final/chapters.json
  - final/id3-tags.json
  - final/distribution-manifest.json

publishes:
  - metadata.complete
  - metadata.distribution_ready

next: step-09-export
```

### Step 9: EXPORT

```yaml
step: 9
name: export
trigger: metadata.complete
checkpoint: false

actions:
  - Package MP3 chapters
  - Create M4B with chapters (ffmpeg + mp4chaps)
  - Copy cover to final/
  - Generate session summary
  - Archive session data
  - Clean up temporary files

outputs:
  - final/{title}.mp3
  - final/{title}.m4b
  - final/chapters/
  - final/cover/
  - final/metadata.json
  - session-summary.json

notification:
  message: "✅ Audiobook complete: {title}"
  include:
    - Duration
    - Quality score
    - Output paths
```

---

## Error Handling

```yaml
error_handling:
  global:
    max_session_retries: 1
    timeout_per_step: 30m
    log_level: info

  retry_policy:
    default:
      max_retries: 3
      backoff: exponential
      base_delay: 5s

  agent_failures:
    content-ingestion:
      on_failure: request_manual_input
      fallback: none

    book-structure:
      on_failure: single_chapter_mode
      fallback: treat_as_one_chapter

    script-adapter:
      on_failure: skip_adaptation
      fallback: use_raw_text

    character-voice:
      on_failure: skip_character_voices
      fallback: single_narrator_mode

    audio-producer:
      on_failure: try_gtts
      fallback: gtts
      quarantine: per_segment

    audio-engineer:
      on_failure: skip_mastering
      fallback: use_raw_segments

    quality-reviewer:
      on_failure: manual_review
      fallback: require_observer_approval

    cover-designer:
      on_failure: request_user_cover
      fallback: use_placeholder

    metadata-agent:
      on_failure: minimal_metadata
      fallback: generate_basic_metadata

  quarantine:
    directory: ./quarantine/
    actions:
      - log_failure_reason
      - save_intermediate_files
      - notify_observer
      - allow_manual_retry
```

---

## Observer Commands

### Session Control

| Command | Action |
|---------|--------|
| `[Enter]` | Continue to next step |
| `*pause` | Pause session |
| `*resume` | Resume paused session |
| `*status` | Show current step and progress |
| `*skip` | Skip current step |
| `*restart` | Restart current step |
| `*rollback:{step}` | Rollback to specific step |
| `*exit` | Save and exit |

### Agent Injection

| Command | Action |
|---------|--------|
| `@ingestion "{note}"` | Add note to ingestion |
| `@structure "{note}"` | Add note to structure |
| `@script "{note}"` | Add note to script |
| `@audio "{note}"` | Add note to audio |
| `@quality "{action}"` | Override QC decision |

### Mode Control

| Command | Action |
|---------|--------|
| `*auto` | Fully automatic mode |
| `*manual` | Pause after each step |
| `*verbose` | Show detailed output |
| `*quiet` | Minimal output |

### Quality Override

| Command | Action |
|---------|--------|
| `*approve` | Force approve current output |
| `*reject` | Force reject and quarantine |
| `*reprocess:{chapter}` | Reprocess specific chapter |

---

## Output Directory Structure

```
output/audiobooks/{date}-{book-slug}/
├── raw/
│   ├── raw-content.txt
│   ├── source-metadata.json
│   └── images/
├── structure/
│   ├── chapters/
│   │   ├── chapter-001.md
│   │   ├── chapter-002.md
│   │   └── ...
│   ├── table-of-contents.json
│   └── book-structure.json
├── scripts/
│   ├── chapter-001-script.yaml
│   ├── chapter-002-script.yaml
│   └── prosody-plan.json
├── voice/                          # Fiction only
│   ├── character-map.yaml
│   └── tagged-scripts/
├── audio/
│   ├── segments/
│   │   ├── chapter-001/
│   │   └── chapter-002/
│   └── timestamps.json
├── mastered/
│   ├── chapter-001.mp3
│   ├── chapter-002.mp3
│   ├── full-audiobook.mp3
│   └── audio-report.json
├── cover/
│   ├── cover-3000x3000.jpg
│   ├── cover-2400x2400.jpg
│   ├── cover-1400x1400.jpg
│   └── cover-thumbnail.jpg
├── qc/
│   ├── qc-report.json
│   └── issues.md
├── final/
│   ├── {title}.mp3
│   ├── {title}.m4b
│   ├── chapters/
│   ├── cover/
│   ├── metadata.json
│   └── distribution-manifest.json
├── logs/
│   └── session.log
├── quarantine/                     # Failed items
└── session-summary.json
```

---

## Quality Standards

### Audio Specifications

```yaml
audio_specs:
  format:
    mp3:
      bitrate: 192kbps CBR
      sample_rate: 44100
      channels: mono
    m4b:
      codec: aac
      bitrate: 128kbps
      sample_rate: 44100
      channels: mono

  loudness:
    target_lufs: -14
    range: "-16 to -12 LUFS"
    true_peak: -1.5 dBTP

  silence:
    max_inter_sentence: 1.5s
    max_inter_paragraph: 3.0s
    chapter_gap: 2.0s
    remove_threshold: 2.0s

  fades:
    fade_in: 0.5s
    fade_out: 1.0s
    crossfade: 0.3s

  noise:
    floor: -60 dB
    max_background: -40 dB
```

### QC Scoring Rubric

```yaml
scoring:
  categories:
    technical: 40%
      - lufs_compliance: 15
      - sample_rate_correct: 10
      - no_clipping: 10
      - no_artifacts: 5

    content: 35%
      - pronunciation_accurate: 15
      - pacing_natural: 10
      - chapter_continuity: 10

    production: 25%
      - silence_handling: 10
      - fade_transitions: 5
      - chapter_markers: 5
      - metadata_complete: 5

  grades:
    A: 90-100 (Publish immediately)
    B: 80-89 (Publish with notes)
    C: 60-79 (Review and fix)
    F: 0-59 (Quarantine)
```

---

## Voice Configuration

### Vietnamese Voices

| Voice ID | Gender | Style | Use Case |
|----------|--------|-------|----------|
| vi-VN-HoaiMyNeural | Female | Warm, friendly | Default narrator |
| vi-VN-NamMinhNeural | Male | Professional | Male narrator |

### English Voices

| Voice ID | Gender | Style | Use Case |
|----------|--------|-------|----------|
| en-US-JennyNeural | Female | Clear, neutral | Female characters |
| en-US-GuyNeural | Male | Professional | Male characters |
| en-US-AriaNeural | Female | Expressive | Alternative female |
| en-US-ChristopherNeural | Male | Deep | Alternative male |

---

## Platform Distribution

```yaml
platforms:
  local:
    formats: [mp3, m4b]
    enabled: true

  audible_acx:
    enabled: true
    requirements:
      audio:
        - 192kbps CBR MP3
        - -23 to -18 LUFS (RMS)
        - Peak: -3dB max
        - Sample: 44.1kHz mono
      cover:
        - 2400x2400 JPEG
        - RGB color
      metadata:
        - Title, author, narrator
        - Chapter markers

  spotify_podcast:
    enabled: true
    requirements:
      - RSS feed format
      - Episode chapters
      - Cover: 3000x3000

  youtube_music:
    enabled: true
    requirements:
      - Chapter markers in description
      - Thumbnail: 1280x720

  google_play:
    enabled: true
    requirements:
      - M4B with chapters
      - Metadata JSON
```

---

## Session Commands

### Start Session

```bash
# Via slash command
/audiobook-session

# With input file
/audiobook-session --input book.pdf

# With URL
/audiobook-session --url https://example.com/article
```

### Session Parameters

```yaml
parameters:
  input:
    description: "Source file or URL"
    required: true

  title:
    description: "Override book title"
    required: false

  author:
    description: "Override author name"
    required: false

  narrator_voice:
    description: "Main narrator voice"
    default: vi-VN-HoaiMyNeural
    options:
      - vi-VN-HoaiMyNeural
      - vi-VN-NamMinhNeural
      - en-US-JennyNeural
      - en-US-GuyNeural

  genre:
    description: "Override genre detection"
    options:
      - business
      - fiction
      - education
      - technical
      - auto

  output_formats:
    description: "Output formats to generate"
    default: [mp3, m4b]
    options:
      - mp3
      - m4b
      - wav
```

---

## Memory System

```
memory/
├── context.md           # Current session state
├── decisions.md         # Important decisions made
├── learnings.md         # Learnings accumulated
└── blockers.md          # Known blockers
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial release with 9 agents, 11-step pipeline |

---

*Audiobook Production Team v1.0 - From Manuscript to Masterpiece*
