# Step 01: INIT

> Session initialization and workspace setup

---

## Step Info

```yaml
step: 1
name: init
title: "Session Initialization"
description: "Set up workspace, create directories, load configuration"

trigger: session.start
agent: none  # Orchestrator handles this

duration: "< 1 minute"
checkpoint: false
```

---

## Actions

### 1. Create Session Directory

```bash
# Session naming convention
SESSION_ID="AB-$(date +%Y-%m-%d)-$(basename "$INPUT" | tr ' ' '-')-001"
SESSION_DIR="output/audiobooks/$SESSION_ID"

# Create directory structure
mkdir -p "$SESSION_DIR"/{raw,structure,scripts,voice,audio,mastered,quality,covers,distribution,logs}
```

### 2. Directory Structure

```
$SESSION_DIR/
├── raw/                    # Step 2: Ingestion
│   ├── raw-content.txt
│   └── source-metadata.json
├── structure/              # Step 3: Structure
│   ├── chapters/
│   ├── table-of-contents.json
│   └── book-structure.json
├── scripts/                # Step 4: Adaptation
│   ├── chapter-{NNN}-script.yaml
│   └── prosody-plan.json
├── voice/                  # Step 4.5: Character Voice
│   ├── character-map.yaml
│   └── tagged-scripts/
├── audio/                  # Step 5: Production
│   ├── segments/
│   └── timestamps.json
├── mastered/               # Step 6: Engineering
│   ├── chapter-{NNN}.mp3
│   ├── full-audiobook.mp3
│   └── audio-report.json
├── quality/                # Step 7: Review
│   └── qc-report.json
├── covers/                 # Step 7.5: Cover
│   └── cover-*.jpg
├── distribution/           # Step 8: Metadata
│   ├── mp3/
│   ├── m4b/
│   └── platforms/
└── logs/
    ├── session.log
    └── errors.log
```

### 3. Load Configuration

```yaml
config:
  source:
    file: "$INPUT"
    type: auto-detect

  audio:
    format: mp3
    bitrate: 192
    sample_rate: 44100
    channels: mono
    target_lufs: -14

  voice:
    primary: vi-VN-HoaiMyNeural
    secondary: en-US-JennyNeural
    rate: "+10%"

  output:
    chapters: true
    full_audiobook: true
    m4b: true
```

### 4. Initialize Log

```bash
cat > "$SESSION_DIR/logs/session.log" << EOF
=== Audiobook Production Session ===
Session ID: $SESSION_ID
Started: $(date -Iseconds)
Input: $INPUT
Status: Initialized

[$(date +%H:%M:%S)] Step 01: INIT - Started
[$(date +%H:%M:%S)] Created session directory: $SESSION_DIR
[$(date +%H:%M:%S)] Step 01: INIT - Completed
EOF
```

---

## Output

```yaml
output:
  session_id: "$SESSION_ID"
  session_dir: "$SESSION_DIR"
  config: "$SESSION_DIR/config.yaml"
  log: "$SESSION_DIR/logs/session.log"
```

---

## Next Step

- **Step 02: INGESTION** - Content Ingestion Agent extracts text from input

---

## Error Handling

```yaml
errors:
  input_not_found:
    action: abort
    message: "Input file not found"

  permission_denied:
    action: abort
    message: "Cannot create session directory"

  disk_full:
    action: abort
    message: "Insufficient disk space"
```
