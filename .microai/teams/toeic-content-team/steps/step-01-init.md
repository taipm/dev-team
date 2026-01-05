# Step 01: Session Initialization

```yaml
step: 1
name: init
description: Khởi tạo session và chuẩn bị resources
trigger: session_start
next: step-02-content-planning
```

---

## Purpose

Khởi tạo một production session mới, setup directories, và chuẩn bị tất cả resources cần thiết.

---

## Actions

### 1. Parse Session Parameters

```yaml
parameters:
  batch_size: {number, default: 5}
  content_mix:
    vocabulary: {percentage, default: 40}
    listening: {percentage, default: 30}
    grammar: {percentage, default: 30}
  formats:
    shorts: {boolean, default: true}
    standard: {boolean, default: true}
  target_platform: {youtube|tiktok|both, default: youtube}
```

### 2. Create Session Directory

```
output/toeic-videos/{date}-{session_id}/
├── planning/
├── scripts/
├── audio/
├── visuals/
├── videos/
├── metadata/
├── quarantine/
└── logs/
```

### 3. Initialize Checkpoints

```yaml
checkpoints:
  enabled: true
  interval: after_each_agent
  location: ./checkpoints/
```

### 4. Setup Communication Channels

```yaml
channels:
  - content.topic_brief
  - content.keywords
  - script.complete
  - script.visual_cues
  - audio.voiceover
  - audio.timestamps
  - visual.slides
  - visual.thumbnail
  - video.shorts
  - video.standard
  - quality.approved
  - quality.rejected
```

### 5. Load Shared Knowledge

- Load TOEIC fundamentals
- Load YouTube best practices
- Load AI tools integration guides

### 6. Validate Dependencies

```bash
# Check required tools
edge-tts --version
ffmpeg -version
```

---

## Output

```yaml
session:
  id: {generated_uuid}
  date: {current_date}
  batch_size: {n}
  status: initialized
  directories: created
  checkpoints: enabled
  communication: ready
```

---

## Handoff

→ **Step 02: Content Planning** với Content Planner Agent

---

## Display

```
╔═══════════════════════════════════════════════════════════════════════╗
║                 TOEIC CONTENT TEAM - SESSION INIT                      ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║   Session ID: {session_id}                                             ║
║   Date: {date}                                                         ║
║                                                                        ║
║   Configuration:                                                       ║
║   ├── Batch Size: {batch_size} videos                                 ║
║   ├── Content Mix: Vocab {v}% | Listen {l}% | Grammar {g}%           ║
║   ├── Formats: {shorts_status} Shorts | {standard_status} Standard    ║
║   └── Platform: {platform}                                            ║
║                                                                        ║
║   Status:                                                              ║
║   ├── Directories: ✓ Created                                          ║
║   ├── Checkpoints: ✓ Enabled                                          ║
║   ├── Communication: ✓ Ready                                          ║
║   └── Dependencies: ✓ Validated                                       ║
║                                                                        ║
║   Ready to proceed with Content Planning...                           ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```
