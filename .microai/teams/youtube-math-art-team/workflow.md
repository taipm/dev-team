---
name: youtube-math-art-team
description: MathArt Video Production Team v2.0 - Tạo narrated educational videos với script + TTS + background music
model: opus
version: "2.0"
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
output_folder: ./.microai/teams/youtube-math-art-team/logs
language: vi
color: "#9B59B6"

# Checkpoint system - Session recovery
checkpoint:
  enabled: true
  storage_path: ./.microai/teams/youtube-math-art-team/checkpoints
  git_integration: false
  auto_checkpoint: true

# Inter-agent communication
communication:
  enabled: true
  bus_path: ./.microai/teams/youtube-math-art-team/communication
  message_timeout_ms: 5000
  max_retries: 3
  topics:
    - concept
    - algorithm
    - script
    - tts
    - audio
    - rendering
    - review
    - release

# Kanban tracking
kanban:
  enabled: true
  board_path: ./.microai/teams/youtube-math-art-team/kanban/board.yaml
  queue_path: ./.microai/teams/youtube-math-art-team/kanban/signal-queue.json
  sync_mode: semi_automatic
  signals:
    on_step_start: true
    on_step_complete: true
    on_agent_activate: true
  wip_enforcement: true
  commands:
    - "*board"
    - "*status"
    - "*metrics"

# Autonomous mode
autonomous:
  enabled: true
  level: balanced
  auto_approve:
    concept: true
    algorithm: true
    script: true
    tts: true
    render_preview: true
    render_final: false
  thresholds:
    max_render_time: 600  # 10 minutes
    max_iterations: 3

# Parallel execution
parallel:
  enabled: true
  max_workers: 4
  parallelizable_groups:
    - name: content_creation
      steps: [step-03-algorithm, step-04-script]
    - name: dual_language
      steps: [tts-vi, tts-en]
    - name: dual_format_render
      steps: [render-720p-vi, render-720p-en]
    - name: quality_check
      steps: [visual-check, audio-check]

# TTS Configuration
tts:
  engine: edge-tts
  voices:
    vi: vi-VN-NamMinhNeural
    en: en-US-GuyNeural
  rate: "-5%"
  style: educational_calm

# Audio Mixing
audio_mix:
  voice_level: 0dB
  music_level: -12dB
  ducking: true
  loudness_target: -14 LUFS
---

# YouTube MathArt Team Workflow v2.0

**Mục tiêu:** Điều phối team 7 agents để tạo **narrated educational videos** cho YouTube với script, TTS voice, và background music.

**Vai trò của bạn:** Bạn là Orchestrator Agent - điều phối workflow giữa các agents, từ concept đến video hoàn chỉnh với narration.

**Ngôn ngữ:** Cả Tiếng Việt và English (2 phiên bản video)

---

## VIDEO SPECIFICATIONS

### Format 1: Standard VI (Default)
```yaml
resolution: 1280x720 (720p)
fps: 30
duration: 90 seconds
codec: H.264
bitrate: 5000 kbps
audio: Vietnamese narration + background music
output: {topic}_720p_vi.mp4
```

### Format 2: Standard EN
```yaml
resolution: 1280x720 (720p)
fps: 30
duration: 90 seconds
codec: H.264
bitrate: 5000 kbps
audio: English narration + background music
output: {topic}_720p_en.mp4
```

### Format 3: YouTube Shorts (Optional)
```yaml
resolution: 1080x1920 (9:16 vertical)
fps: 30
duration: 30-60 seconds
codec: H.264
bitrate: 6000 kbps
output: {topic}_shorts_vi.mp4, {topic}_shorts_en.mp4
content: Best 30-60s segment từ main video
```

---

## TEAM MEMBERS (7 Agents)

| Agent | Role | Icon | Focus |
|-------|------|------|-------|
| concept-designer | Concept Designer | 🎨 | Chọn chủ đề, thiết kế visual, color palette |
| algorithm-dev | Algorithm Developer | 🧮 | Viết Python/NumPy code, tối ưu performance |
| **script-writer** | Script Writer | 📝 | Viết kịch bản narration VI + EN |
| **tts-voice** | TTS Voice | 🗣️ | Convert script → voice audio (edge-tts) |
| audio-composer | Audio Composer | 🎵 | Tạo nhạc nền + mix với voice (ducking) |
| render-engineer | Render Engineer | 🎬 | Export video, sync audio, quality control |
| quality-reviewer | Quality Reviewer | 🔍 | Kiểm tra visual, audio, timing, file output |

---

## WORKFLOW ARCHITECTURE (v2.0)

```
User Request (topic từ Kanban hoặc manual)
   ↓
┌───────────────────────────────────────────────────────────────────┐
│ Step 01: Init - Load Kanban, select topic, setup workspace        │
├───────────────────────────────────────────────────────────────────┤
│ Step 02: Concept - 🎨 Designer creates visual concept             │
│    ═══════════════════ [BREAKPOINT] ═══════════════════          │
├───────────────────────────────────────────────────────────────────┤
│                         PARALLEL BLOCK                            │
│  ┌─────────────────────────┐   ┌─────────────────────────┐       │
│  │ Step 03: Algorithm      │   │ Step 04: Script         │       │
│  │ 🧮 Animation code       │   │ 📝 Narration VI + EN    │       │
│  └─────────────────────────┘   └─────────────────────────┘       │
│    ═══════════════════ [BREAKPOINT] ═══════════════════          │
├───────────────────────────────────────────────────────────────────┤
│ Step 05: TTS Voice - 🗣️ Generate voice audio (edge-tts)          │
│    ├── narration_vi.mp3 (NamMinhNeural)                          │
│    └── narration_en.mp3 (GuyNeural)                              │
├───────────────────────────────────────────────────────────────────┤
│ Step 06: Audio Mix - 🎵 Voice + Background Music                  │
│    ├── final_audio_vi.m4a (VI voice + ducked music)              │
│    └── final_audio_en.m4a (EN voice + ducked music)              │
├───────────────────────────────────────────────────────────────────┤
│ Step 07: Preview - 🎬 Quick render for validation                 │
├───────────────────────────────────────────────────────────────────┤
│ Step 08: Review Loop (max 3 iterations)                           │
│    ┌────────────────────────────────────────────────────────┐    │
│    │ 🔍 Reviewer → [Issues] → 🧮 Dev/📝 Script → Preview    │    │
│    │ EXIT: Visual + Audio + Narration quality approved      │    │
│    └────────────────────────────────────────────────────────┘    │
│    ═══════════════════ [BREAKPOINT] ═══════════════════          │
├───────────────────────────────────────────────────────────────────┤
│ Step 09: Final Render - 🎬 Parallel: VI + EN versions             │
│    ┌────────────────────┐    ┌────────────────────┐              │
│    │  720p Vietnamese   │    │  720p English      │  PARALLEL    │
│    │  + narration + BGM │    │  + narration + BGM │              │
│    └────────────────────┘    └────────────────────┘              │
│                                                                   │
│    Step 09b: Shorts (Optional)                                    │
│    ├── {topic}_shorts_vi.mp4 (45s vertical)                      │
│    └── {topic}_shorts_en.mp4 (45s vertical)                      │
├───────────────────────────────────────────────────────────────────┤
│ Step 10: Quality Check - 🔍 Verify all video + audio files        │
├───────────────────────────────────────────────────────────────────┤
│ Step 11: Synthesis - Update Kanban, generate report               │
└───────────────────────────────────────────────────────────────────┘
   ↓
Output:
  - {topic}_720p_vi.mp4 (Vietnamese narrated)
  - {topic}_720p_en.mp4 (English narrated)
  - {topic}_shorts_vi.mp4, {topic}_shorts_en.mp4
  - narration_vi.vtt, narration_en.vtt (subtitles)
  - Kanban updated
```

---

## CONFIGURATION

### Paths
```yaml
installed_path: "{project-root}/.microai/teams/youtube-math-art-team"
agents:
  concept: "{installed_path}/agents/concept-designer.md"
  algorithm: "{installed_path}/agents/algorithm-dev.md"
  script: "{installed_path}/agents/script-writer.md"
  tts: "{installed_path}/agents/tts-voice.md"
  audio: "{installed_path}/agents/audio-composer.md"
  render: "{installed_path}/agents/render-engineer.md"
  reviewer: "{installed_path}/agents/quality-reviewer.md"
templates:
  video_config: "{installed_path}/templates/video-config-template.py"
  animation: "{installed_path}/templates/animation-template.py"
  tts_generator: "{installed_path}/templates/tts-generator.py"
  shorts_generator: "{installed_path}/templates/shorts-generator.py"
workspace: ".microai/workspaces/youtube-math-art/{date}-{topic}"
kanban_board: ".claude/kanban/mathart-videos.yaml"
```

### Session State
```yaml
mathart_state:
  topic: ""
  date: "{{system_date}}"
  phase: "init"
  current_agent: null
  current_step: 1
  breakpoint_active: false

  config:
    render_720p: true
    render_1080p: false
    render_shorts: true
    languages: [vi, en]
    duration: 90
    max_iterations: 3
    tts_engine: edge-tts
    tts_voices:
      vi: vi-VN-NamMinhNeural
      en: en-US-GuyNeural

  iteration_count: 0

  outputs:
    concept_doc: null
    source_code: null
    script_vi: null
    script_en: null
    narration_vi: null
    narration_en: null
    background_music: null
    final_audio_vi: null
    final_audio_en: null
    preview_video: null
    final_720p_vi: null
    final_720p_en: null
    shorts_vi: null
    shorts_en: null
    subtitles_vi: null
    subtitles_en: null

  quality_metrics:
    visual_approved: false
    narration_approved: false
    timing_correct: false
    file_valid: false

  history: []
```

---

## MATHART CATEGORIES

Dựa trên Kanban board tại `.claude/kanban/mathart-videos.yaml`:

| Category | Examples | Difficulty |
|----------|----------|------------|
| Fractals | Koch, Mandelbrot, Julia, Sierpinski | Easy-Medium |
| Sacred Geometry | Flower of Life, Golden Spiral | Easy |
| Mathematical Curves | Lissajous, Rose Curves, Spirograph | Easy |
| Space-Filling | Hilbert, Peano, Gosper | Medium |
| 3D Objects | Klein Bottle, Möbius, Torus Knots | Hard |
| Number Viz | Pi Spiral, Prime Spiral, Collatz | Medium |
| Physics-Math | Double Pendulum, Lorenz, Wave | Medium |

---

## OBSERVER CONTROLS

### Basic Commands
| Command | Effect |
|---------|--------|
| `[Enter]` | Continue to next step/phase |
| `*pause` | Pause workflow for manual review |
| `*skip` | Skip current step |
| `*skip-to:<N>` | Jump to step N |
| `*exit` | End session, save progress |

### Agent Injection
| Command | Effect |
|---------|--------|
| `@concept: <msg>` | Inject to Concept Designer |
| `@algo: <msg>` | Inject to Algorithm Dev |
| `@render: <msg>` | Inject to Render Engineer |
| `@review: <msg>` | Inject to Quality Reviewer |

### Checkpoint Commands
| Command | Effect |
|---------|--------|
| `*checkpoints` | List all checkpoints |
| `*rollback:<N>` | Rollback to checkpoint N |

### Kanban Commands
| Command | Effect |
|---------|--------|
| `*board` | Show Kanban board |
| `*status` | Quick status |
| `*next` | Pick next topic from backlog |

### Render Commands
| Command | Effect |
|---------|--------|
| `*720` | Render 720p only |
| `*1080` | Also render 1080p |
| `*preview` | Quick preview (480p, 15fps) |

### Autonomous Mode
| Command | Effect |
|---------|--------|
| `*auto` | Enable autonomous mode |
| `*auto:off` | Disable autonomous mode |

---

## EXECUTION STEPS

### Step 1: Session Initialization
**Load:** `./steps/step-01-init.md`
**Actions:**
- Load Kanban board
- Select topic (from argument or `*next`)
- Create workspace directory
- Display welcome banner

### Step 2: Concept Design
**Load:** `./steps/step-02-concept.md`
**Agent:** 🎨 Concept Designer
**Actions:**
- Analyze topic for visual potential
- Design color palette
- Plan animation structure
- Create concept document
**BREAKPOINT:** User approves concept

### Step 3: Algorithm Development (PARALLEL with Step 4)
**Load:** `./steps/step-03-algorithm.md`
**Agent:** 🧮 Algorithm Developer
**Actions:**
- Write Python animation code
- Implement mathematical formulas
- Add video config (resolution, fps, duration)
- Optimize with Numba JIT
**BREAKPOINT:** User approves code

### Step 4: Script Writing (PARALLEL with Step 3)
**Load:** `./steps/step-04-script.md`
**Agent:** 📝 Script Writer
**Actions:**
- Analyze visual concept for narration
- Write Vietnamese script with timestamps
- Write English script with timestamps
- Mark sync points for visual transitions
**Output:** `script_vi.md`, `script_en.md`, `script_vi.txt`, `script_en.txt`

### Step 5: TTS Voice Generation
**Load:** `./steps/step-05-tts.md`
**Agent:** 🗣️ TTS Voice
**Actions:**
- Generate Vietnamese voice (NamMinhNeural)
- Generate English voice (GuyNeural)
- Create subtitle files (VTT)
- Validate duration matches script
**Output:** `narration_vi.mp3`, `narration_en.mp3`, `*.vtt`

### Step 6: Audio Mixing
**Load:** `./steps/step-06-audio-mix.md`
**Agent:** 🎵 Audio Composer
**Actions:**
- Generate background ambient music
- Mix voice + music with ducking
- Normalize to -14 LUFS
- Create VI and EN audio tracks
**Output:** `final_audio_vi.m4a`, `final_audio_en.m4a`

### Step 7: Preview Render
**Load:** `./steps/step-07-preview.md`
**Agent:** 🎬 Render Engineer
**Actions:**
- Quick render at 480p, 15fps
- Validate animation works
- Check audio sync with video

### Step 8: Review Loop
**Load:** `./steps/step-08-review.md`
**Agent:** 🔍 Quality Reviewer + 🧮 Developer + 📝 Script Writer
**Actions:**
- Review visual quality
- Review narration quality
- Check audio/visual sync
- Suggest improvements
- Fix issues
**EXIT:** All quality metrics approved OR max iterations
**BREAKPOINT:** Before final render

### Step 9: Final Render
**Load:** `./steps/step-09-render.md`
**Agent:** 🎬 Render Engineer
**Actions:**
- Render 720p Vietnamese (video + final_audio_vi)
- Render 720p English (video + final_audio_en)
- Generate thumbnail from key frame
**PARALLEL:** VI and EN renders run simultaneously

### Step 9b: Shorts Generation (Optional)
**Load:** `./steps/step-09b-shorts.md`
**Agent:** 🎬 Render Engineer
**Actions:**
- Extract best 45s segment
- Crop to 9:16 vertical
- Create shorts_vi and shorts_en

### Step 10: Quality Check
**Load:** `./steps/step-10-quality.md`
**Agent:** 🔍 Quality Reviewer
**Actions:**
- Verify all files exist and are valid
- Check duration matches spec
- Validate audio/video sync
- Verify subtitle timing

### Step 11: Synthesis
**Load:** `./steps/step-11-synthesis.md`
**Actions:**
- Update Kanban: Backlog → Rendered
- Generate session report
- Display output summary
- Suggest next topic

---

## ERROR HANDLING

### Render Timeout
- Cancel render after 10 minutes
- Reduce resolution/fps
- Notify user

### Algorithm Error
- Capture traceback
- Developer reviews and fixes
- Max 3 fix attempts

### File Validation Failed
- Re-render with different settings
- Check disk space
- Notify user

---

## EXIT CONDITIONS

### Normal Exit
- All steps completed
- Video files generated and validated
- Kanban updated
- Session log saved

### Early Exit (*exit)
- Save current progress to checkpoint
- Document incomplete items
- Keep generated files

---

## OUTPUT STRUCTURE

```
.microai/workspaces/youtube-math-art/{date}-{topic}/
├── src/
│   ├── {topic}_animation.py       # Animation source code
│   └── generate_audio.py          # Audio generation script
├── output/
│   ├── {topic}_720p_vi.mp4        # Vietnamese narrated video
│   ├── {topic}_720p_en.mp4        # English narrated video
│   ├── {topic}_shorts_vi.mp4      # Vietnamese Shorts (optional)
│   ├── {topic}_shorts_en.mp4      # English Shorts (optional)
│   ├── script_vi.txt              # Vietnamese script (TTS input)
│   ├── script_en.txt              # English script (TTS input)
│   ├── narration_vi.mp3           # Vietnamese voice audio
│   ├── narration_en.mp3           # English voice audio
│   ├── narration_vi.vtt           # Vietnamese subtitles
│   ├── narration_en.vtt           # English subtitles
│   ├── background_music.m4a       # Ambient background music
│   ├── final_audio_vi.m4a         # Mixed: voice + music (VI)
│   ├── final_audio_en.m4a         # Mixed: voice + music (EN)
│   └── thumbnail.png              # Key frame
├── docs/
│   ├── concept.md                 # Concept document
│   ├── script_vi.md               # Vietnamese script (full)
│   ├── script_en.md               # English script (full)
│   └── session-report.md          # Final report
└── README.md                      # Workspace description
```
