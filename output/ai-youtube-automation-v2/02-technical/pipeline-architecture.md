# Kiến Trúc Pipeline Tự Động Hóa

> **Dự án:** AI YouTube Automation v2.0
> **Cập nhật:** 04/01/2026
> **Phiên bản:** 1.0

---

## Tổng Quan Pipeline

Pipeline tự động hóa hoàn chỉnh từ ý tưởng đến video publish, sử dụng 100% công cụ miễn phí.

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                           AI YOUTUBE AUTOMATION PIPELINE v2.0                               │
│                                   (Free Tier Only)                                          │
└─────────────────────────────────────────────────────────────────────────────────────────────┘

    ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
    │   PHASE 1    │     │   PHASE 2    │     │   PHASE 3    │     │   PHASE 4    │
    │   IDEATION   │────▶│   CONTENT    │────▶│  PRODUCTION  │────▶│  PUBLISHING  │
    │   & SCRIPT   │     │   CREATION   │     │   & EDITING  │     │   & SEO      │
    └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
         ~30 min              ~45 min              ~45 min              ~15 min

                         TỔNG THỜI GIAN: ~2 giờ/video
                    (So với 8-10 giờ làm thủ công truyền thống)
```

---

## Chi Tiết Từng Giai Đoạn

### PHASE 1: Ideation & Script (30 phút)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 1: IDEATION                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐            │
│   │   TREND     │        │   CHATGPT   │        │   SCRIPT    │            │
│   │  RESEARCH   │───────▶│    FREE     │───────▶│   OUTPUT    │            │
│   │             │        │             │        │             │            │
│   └─────────────┘        └─────────────┘        └─────────────┘            │
│        │                       │                      │                     │
│        ▼                       ▼                      ▼                     │
│   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐            │
│   │ - YouTube   │        │ - Ideas     │        │ - script.txt│            │
│   │   Trending  │        │   Generator │        │ - 1500-2000 │            │
│   │ - Google    │        │ - Script    │        │   words     │            │
│   │   Trends    │        │   Writer    │        │ - 8-10 min  │            │
│   │ - Niche     │        │ - Hook +    │        │   duration  │            │
│   │   Analysis  │        │   CTA       │        │             │            │
│   └─────────────┘        └─────────────┘        └─────────────┘            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Input:**
- Trending topics từ YouTube/Google Trends
- Niche keywords (Giáo dục/Kiến thức)
- Content calendar

**Process:**
1. Nghiên cứu trend (5 phút)
2. Prompt ChatGPT tạo ideas (5 phút)
3. Chọn topic phù hợp (5 phút)
4. ChatGPT viết script (15 phút)

**Output:**
- Script file (.txt)
- 1500-2000 từ
- Có Hook + CTA
- Timestamps outline

---

### PHASE 2: Content Creation (45 phút)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PHASE 2: CONTENT CREATION                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐                          ┌─────────────┐                 │
│   │   SCRIPT    │                          │   CANVA     │                 │
│   │   (.txt)    │                          │   FREE      │                 │
│   └──────┬──────┘                          └──────┬──────┘                 │
│          │                                        │                         │
│          ▼                                        ▼                         │
│   ┌─────────────┐                          ┌─────────────┐                 │
│   │  EDGE-TTS   │                          │  THUMBNAIL  │                 │
│   │   Python    │                          │  1280x720   │                 │
│   └──────┬──────┘                          └──────┬──────┘                 │
│          │                                        │                         │
│          ▼                                        ▼                         │
│   ┌─────────────┐        ┌─────────────┐   ┌─────────────┐                 │
│   │   AUDIO     │        │   PEXELS    │   │  thumb.png  │                 │
│   │   (.mp3)    │        │  PIXABAY    │   │             │                 │
│   │ vi-VN-Nam   │        │  Stock      │   └─────────────┘                 │
│   │ MinhNeural  │        │  Footage    │                                   │
│   └──────┬──────┘        └──────┬──────┘                                   │
│          │                      │                                           │
│          ▼                      ▼                                           │
│   ┌──────────────────────────────────┐                                     │
│   │         ASSETS FOLDER            │                                     │
│   │  - audio/voiceover.mp3           │                                     │
│   │  - footage/*.mp4                 │                                     │
│   │  - thumbnail/thumb.png           │                                     │
│   └──────────────────────────────────┘                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Input:**
- Script file từ Phase 1
- Thumbnail template (Canva)

**Process:**
1. Edge-TTS convert script to audio (10 phút)
2. Pexels/Pixabay tìm stock footage (20 phút)
3. Canva tạo thumbnail (15 phút)

**Output:**
- Audio file (.mp3) - Vietnamese voice
- Stock footage collection (5-10 clips)
- Thumbnail (.png) 1280x720

---

### PHASE 3: Production & Editing (45 phút)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       PHASE 3: PRODUCTION & EDITING                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌────────────────────────────────────────────────────────────────────┐   │
│   │                         CAPCUT DESKTOP                              │   │
│   ├────────────────────────────────────────────────────────────────────┤   │
│   │                                                                     │   │
│   │    TIMELINE                                                         │   │
│   │    ┌───────────────────────────────────────────────────────────┐   │   │
│   │    │ VIDEO  │ Clip1 │ Clip2 │ Clip3 │ Clip4 │ Clip5 │ ...     │   │   │
│   │    ├────────┴───────┴───────┴───────┴───────┴───────┴─────────┤   │   │
│   │    │ TEXT   │========= AUTO CAPTIONS (Vietnamese) ===========│   │   │
│   │    ├──────────────────────────────────────────────────────────┤   │   │
│   │    │ AUDIO  │============ VOICEOVER (Edge-TTS) ==============│   │   │
│   │    ├──────────────────────────────────────────────────────────┤   │   │
│   │    │ MUSIC  │========= BACKGROUND MUSIC (10-20%) ============│   │   │
│   │    └──────────────────────────────────────────────────────────┘   │   │
│   │                                                                     │   │
│   │    EFFECTS APPLIED:                                                 │   │
│   │    - Transitions: Fade/Dissolve (0.3-0.5s)                         │   │
│   │    - Color correction                                               │   │
│   │    - Speed ramping (optional)                                       │   │
│   │    - Zoom/Pan effects                                               │   │
│   │                                                                     │   │
│   └────────────────────────────────────────────────────────────────────┘   │
│                              │                                              │
│                              ▼                                              │
│   ┌────────────────────────────────────────────────────────────────────┐   │
│   │                         EXPORT SETTINGS                             │   │
│   │    Format: MP4  |  Resolution: 1080p  |  Bitrate: 15-20 Mbps       │   │
│   └────────────────────────────────────────────────────────────────────┘   │
│                              │                                              │
│                              ▼                                              │
│   ┌─────────────┐                                                          │
│   │  video.mp4  │                                                          │
│   │  8-10 min   │                                                          │
│   │  ~500MB     │                                                          │
│   └─────────────┘                                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Input:**
- Audio từ Phase 2
- Stock footage từ Phase 2
- Thumbnail từ Phase 2

**Process:**
1. Import assets vào CapCut (5 phút)
2. Đặt audio vào timeline (2 phút)
3. Cắt ghép footage theo audio (20 phút)
4. Auto captions + chỉnh sửa (10 phút)
5. Thêm transitions + effects (5 phút)
6. Export video (3 phút)

**Output:**
- Video hoàn chỉnh (.mp4)
- Resolution: 1080p
- Duration: 8-10 phút
- File size: ~500MB

---

### PHASE 4: Publishing & SEO (15 phút)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        PHASE 4: PUBLISHING & SEO                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐        ┌─────────────┐        ┌─────────────┐            │
│   │   VIDEO     │        │   CHATGPT   │        │  YOUTUBE    │            │
│   │   + THUMB   │───────▶│   SEO OPT   │───────▶│   STUDIO    │            │
│   └─────────────┘        └─────────────┘        └─────────────┘            │
│                                │                       │                    │
│                                ▼                       ▼                    │
│                          ┌─────────────┐        ┌─────────────┐            │
│                          │ - Title     │        │ - Upload    │            │
│                          │ - Descrip   │        │ - Schedule  │            │
│                          │ - Tags      │        │ - Publish   │            │
│                          │ - Hashtags  │        │             │            │
│                          └─────────────┘        └─────────────┘            │
│                                                        │                    │
│                                                        ▼                    │
│   ┌────────────────────────────────────────────────────────────────────┐   │
│   │                         POST-PUBLISH                                │   │
│   │                                                                     │   │
│   │    Hour 0-1:    Respond to early comments                          │   │
│   │    Hour 1-24:   Monitor initial performance                        │   │
│   │    Day 2-7:     Community engagement                               │   │
│   │    Week 2+:     Analytics review & optimization                    │   │
│   │                                                                     │   │
│   └────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Input:**
- Video từ Phase 3
- Thumbnail từ Phase 2
- Script summary

**Process:**
1. ChatGPT tạo SEO metadata (5 phút)
2. Upload video lên YouTube (5 phút)
3. Điền metadata + schedule (5 phút)

**Output:**
- Video published/scheduled
- SEO optimized metadata
- Thumbnail uploaded

---

## Luồng Dữ Liệu Tổng Thể

```
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW DIAGRAM                                        │
└──────────────────────────────────────────────────────────────────────────────────────┘

    INPUT                    PROCESS                         OUTPUT
    ─────                    ───────                         ──────

 ┌──────────┐
 │  TREND   │
 │  DATA    │──┐
 └──────────┘  │
               │     ┌──────────────┐      ┌──────────────┐
 ┌──────────┐  │     │              │      │              │
 │ CONTENT  │──┼────▶│   CHATGPT    │─────▶│   SCRIPT     │
 │ CALENDAR │  │     │              │      │   (.txt)     │
 └──────────┘  │     └──────────────┘      └──────┬───────┘
               │                                   │
 ┌──────────┐  │                                   │
 │ KEYWORDS │──┘                                   │
 └──────────┘                                      │
                                                   │
                     ┌─────────────────────────────┼─────────────────────────────┐
                     │                             │                             │
                     ▼                             ▼                             │
              ┌──────────────┐              ┌──────────────┐                     │
              │              │              │              │                     │
              │   EDGE-TTS   │              │    CANVA     │                     │
              │              │              │              │                     │
              └──────┬───────┘              └──────┬───────┘                     │
                     │                             │                             │
                     ▼                             ▼                             │
              ┌──────────────┐              ┌──────────────┐                     │
              │   AUDIO      │              │  THUMBNAIL   │                     │
              │   (.mp3)     │              │   (.png)     │                     │
              └──────┬───────┘              └──────┬───────┘                     │
                     │                             │                             │
                     │      ┌──────────────┐       │                             │
                     │      │   PEXELS/    │       │                             │
                     │      │   PIXABAY    │       │                             │
                     │      └──────┬───────┘       │                             │
                     │             │               │                             │
                     │             ▼               │                             │
                     │      ┌──────────────┐       │                             │
                     │      │   FOOTAGE    │       │                             │
                     │      │   (.mp4)     │       │                             │
                     │      └──────┬───────┘       │                             │
                     │             │               │                             │
                     └──────┬──────┴───────────────┘                             │
                            │                                                     │
                            ▼                                                     │
                     ┌──────────────┐                                            │
                     │              │                                            │
                     │    CAPCUT    │                                            │
                     │              │                                            │
                     └──────┬───────┘                                            │
                            │                                                     │
                            ▼                                                     │
                     ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
                     │    VIDEO     │      │   CHATGPT    │      │   YOUTUBE    │
                     │    (.mp4)    │─────▶│   SEO OPT    │─────▶│   STUDIO     │
                     └──────────────┘      └──────────────┘      └──────┬───────┘
                                                                        │
                                                                        ▼
                                                                 ┌──────────────┐
                                                                 │  PUBLISHED   │
                                                                 │    VIDEO     │
                                                                 └──────────────┘
```

---

## Cấu Trúc Thư Mục Dự Án

```
youtube-automation/
│
├── 01-scripts/                    # Script từ ChatGPT
│   ├── raw/                       # Script gốc
│   │   ├── 2026-01-01_topic.txt
│   │   └── ...
│   └── processed/                 # Script đã chỉnh sửa
│       └── ...
│
├── 02-audio/                      # Voice-over từ Edge-TTS
│   ├── 2026-01-01_topic.mp3
│   └── ...
│
├── 03-footage/                    # Stock footage từ Pexels/Pixabay
│   ├── productivity/
│   ├── success/
│   ├── nature/
│   ├── technology/
│   └── transitions/
│
├── 04-thumbnails/                 # Thumbnails từ Canva
│   ├── 2026-01-01_topic.png
│   └── ...
│
├── 05-exports/                    # Video hoàn chỉnh
│   ├── 2026-01-01_topic.mp4
│   └── ...
│
├── 06-seo/                        # SEO metadata
│   ├── 2026-01-01_topic.yaml
│   └── ...
│
├── templates/                     # Templates và prompts
│   ├── chatgpt-prompts/
│   │   ├── script-generator.txt
│   │   ├── seo-optimizer.txt
│   │   └── ideas-generator.txt
│   └── canva-templates/
│       └── thumbnail-links.txt
│
└── tools/                         # Scripts tự động
    ├── batch_tts.py               # Batch Edge-TTS
    ├── organize_footage.py        # Tổ chức footage
    └── seo_generator.py           # SEO automation
```

---

## Workflow Tự Động Hóa

### Batch Processing Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         BATCH PROCESSING (10 videos/week)                   │
└─────────────────────────────────────────────────────────────────────────────┘

   DAY 1 (Sunday)              DAY 2-3                    DAY 4-5
   ──────────────              ───────                    ───────

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   BATCH IDEAS    │     │   BATCH AUDIO    │     │   BATCH VIDEO    │
│   & SCRIPTS      │────▶│   GENERATION     │────▶│   EDITING        │
│   (10 scripts)   │     │   (10 audios)    │     │   (10 videos)    │
└──────────────────┘     └──────────────────┘     └──────────────────┘
     3 hours                  2 hours                  8 hours


   DAY 6                       DAY 7                   WEEK LOOP
   ─────                       ─────                   ─────────

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   BATCH          │     │   SCHEDULE       │     │   REPEAT         │
│   THUMBNAILS     │────▶│   UPLOADS        │────▶│   WEEKLY         │
│   (10 thumbs)    │     │   (10 videos)    │     │                  │
└──────────────────┘     └──────────────────┘     └──────────────────┘
     2 hours                  2 hours

                    TOTAL: ~17 hours/week for 10 videos
                    = 1.7 hours/video (vs 8-10 hours manual)
```

---

## Metrics & Monitoring

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PERFORMANCE DASHBOARD                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   PRODUCTION METRICS                  YOUTUBE METRICS                       │
│   ──────────────────                  ───────────────                       │
│                                                                             │
│   Videos/Week:     [ 10 ]             Views/Video:      [    0 ]           │
│   Time/Video:      [1.7h]             Watch Time:       [    0 ]           │
│   Scripts/Day:     [  2 ]             CTR:              [   0%]           │
│   Backlog:         [  5 ]             Subscribers:      [    0 ]           │
│                                                                             │
│   TOOL HEALTH                         GOALS PROGRESS                        │
│   ───────────                         ──────────────                        │
│                                                                             │
│   ChatGPT:    [OK]  50/50 msg         Subs:      [░░░░░░░░░░]    0/1000    │
│   Edge-TTS:   [OK]  Unlimited         Hours:     [░░░░░░░░░░]    0/4000    │
│   CapCut:     [OK]  Cloud: 500MB      Videos:    [░░░░░░░░░░]    0/60      │
│   Canva:      [OK]  Storage: 3GB      Revenue:   [░░░░░░░░░░]   $0/$500   │
│   Pexels:     [OK]  API: Active                                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Tối Ưu Hóa Pipeline

### Bottleneck Analysis

| Giai đoạn | Thời gian | Bottleneck | Giải pháp |
|-----------|-----------|------------|-----------|
| Script | 30 min | ChatGPT limit | Batch prompts, templates |
| Audio | 15 min | Processing | Python batch script |
| Footage | 20 min | Tìm kiếm | Pre-downloaded library |
| Editing | 45 min | Manual work | Templates, presets |
| Upload | 15 min | Manual | Schedule feature |

### Automation Opportunities

```
CURRENT STATE                        FUTURE STATE
─────────────                        ────────────

Manual script input     ────▶        Scheduled prompts
Manual audio gen        ────▶        Batch script automation
Manual footage search   ────▶        Pre-organized library
Manual editing          ────▶        CapCut templates
Manual upload           ────▶        YouTube API automation
```

---

**Tài liệu liên quan:**
- [Tool Setup Guides](./tool-setup-guides.md)
- [Phase 1 Breakdown](../03-planning/phase-1-breakdown.md)
- [Phase 2 Breakdown](../03-planning/phase-2-breakdown.md)
- [OPPM](../01-oppm/oppm.md)
