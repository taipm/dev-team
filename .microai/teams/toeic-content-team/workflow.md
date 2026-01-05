# TOEIC Content Team - Workflow

```yaml
name: toeic-content-team
description: AI-powered team tự động sản xuất video học TOEIC cho YouTube
version: "1.0"
model: opus
color: "#FF6B35"

type: pipeline
complexity: full

features:
  checkpoint:
    enabled: true
    auto_save: after_each_agent
    recovery: from_last_checkpoint
  communication:
    enabled: true
    mode: file-based
    topics: [content, script, audio, visual, video, quality]
  kanban:
    enabled: true
    columns: [backlog, planning, writing, producing, reviewing, done]
  autonomous: true
  parallel: false

ai_stack:
  llm_primary: claude-sonnet
  llm_secondary: ollama/qwen3:1.7b
  tts: edge-tts
  video: ffmpeg

error_handling:
  retry_policy:
    max_retries: 3
    backoff: exponential
    base_delay: 5s
  on_failure: quarantine_and_continue
  quarantine_dir: ./quarantine/

output_formats:
  shorts:
    resolution: 1080x1920
    duration: 30-60s
    aspect: "9:16"
    fps: 30
  standard:
    resolution: 1920x1080
    duration: 3-10min
    aspect: "16:9"
    fps: 30

content_types:
  vocabulary: 40%
  listening: 30%
  grammar: 30%

targets:
  phase1: 5 videos/day
  phase2: 20 videos/day
  phase3: 50 videos/day

platforms:
  - youtube
  - tiktok
  - facebook
```

---

## Team Members

| Icon | Agent | Focus | Model | Step |
|------|-------|-------|-------|------|
| 🎯 | **UX Designer** | User research, A/B testing, design optimization | Claude | 1.5 |
| 📋 | Content Planner | Topic research, content calendar, SEO keywords | Claude/Ollama | 2 |
| ✍️ | Script Writer | Script với timestamps, cues, structure | Claude | 3 |
| 🏷️ | Language Tagger | Phân loại EN/VI cho mixed content | Rules-based | 3.5 |
| 🎙️ | Audio Producer | Voiceover generation với Edge-TTS | Edge-TTS | 4 |
| 🎨 | Visual Designer | Slides, graphics, visual assets | Claude + Templates | 5 |
| 🎬 | Video Assembler | Video assembly với FFmpeg | FFmpeg | 6 |
| ✅ | Quality Reviewer | QC, SEO optimization, metadata | Claude | 7 |

---

## Workflow Architecture

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                    TOEIC CONTENT PRODUCTION PIPELINE                       ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║   STEP 1: INIT                                                             ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  • Load session config                                            │    ║
║   │  • Initialize checkpoints                                         │    ║
║   │  • Setup communication channels                                   │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓                                       ║
║   STEP 1.5: UX RESEARCH & OPTIMIZATION                                     ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🎯 UX Designer                                                   │    ║
║   │  • Analyze previous video performance (analytics)                 │    ║
║   │  • Review A/B test results                                        │    ║
║   │  • Update design recommendations                                  │    ║
║   │  • Provide UX insights to team                                    │    ║
║   │  → OUTPUT: UX insights, template recommendations                  │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓                                       ║
║   STEP 2: CONTENT PLANNING                                                 ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  📋 Content Planner                                               │    ║
║   │  • Research trending TOEIC topics                                 │    ║
║   │  • Generate content calendar                                      │    ║
║   │  • SEO keyword research                                           │    ║
║   │  → OUTPUT: Topic briefs, keywords                                 │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓ [CHECKPOINT]                          ║
║   STEP 3: SCRIPT WRITING                                                   ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  ✍️ Script Writer                                                  │    ║
║   │  • Generate full script with timestamps                           │    ║
║   │  • Add visual cues and transitions                                │    ║
║   │  • Include TOEIC-validated content                                │    ║
║   │  → OUTPUT: Complete script file                                   │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓ [CHECKPOINT]                          ║
║   STEP 3.5: LANGUAGE TAGGING                                               ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🏷️ Language Tagger                                               │    ║
║   │  • Parse script segments for EN/VI content                        │    ║
║   │  • Tag each token with language (en/vi)                           │    ║
║   │  • Handle mixed sentences, collocations, IPA                      │    ║
║   │  → OUTPUT: Tagged tokens with lang attribute                      │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓                                       ║
║   STEP 4: AUDIO PRODUCTION                                                 ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🎙️ Audio Producer                                                │    ║
║   │  • Map tokens to correct TTS voice (EN→Jenny, VI→HoaiMy)          │    ║
║   │  • Generate voiceover with Edge-TTS                               │    ║
║   │  • Add background music                                           │    ║
║   │  • Process audio levels                                           │    ║
║   │  → OUTPUT: Audio files (.mp3)                                     │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓ [CHECKPOINT]                          ║
║   STEP 5: VISUAL DESIGN                                                    ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🎨 Visual Designer                                               │    ║
║   │  • Generate slide sequence                                        │    ║
║   │  • Create visual assets                                           │    ║
║   │  • Prepare thumbnail concepts                                     │    ║
║   │  → OUTPUT: Image sequence, thumbnail                              │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓ [CHECKPOINT]                          ║
║   STEP 6: VIDEO ASSEMBLY                                                   ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🎬 Video Assembler                                               │    ║
║   │  • Combine audio + visuals with FFmpeg                            │    ║
║   │  • Generate Shorts version (9:16)                                 │    ║
║   │  • Generate Standard version (16:9)                               │    ║
║   │  → OUTPUT: Video files (.mp4)                                     │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓ [CHECKPOINT]                          ║
║   STEP 7: QUALITY REVIEW                                                   ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  ✅ Quality Reviewer                                              │    ║
║   │  • Content accuracy check                                         │    ║
║   │  • SEO optimization                                               │    ║
║   │  • Generate metadata (title, description, tags)                   │    ║
║   │  → OUTPUT: QC report, metadata                                    │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓                                       ║
║   STEP 8: EXPORT                                                           ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  • Package final deliverables                                     │    ║
║   │  • Export for multiple platforms                                  │    ║
║   │  • Update content library                                         │    ║
║   │  • Archive session                                                │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                    ↓                                       ║
║   ┌──────────────────────────────────────────────────────────────────┐    ║
║   │  🔄 FEEDBACK LOOP (Continuous)                                    │    ║
║   │                                                                   │    ║
║   │  Analytics → 🎯 UX Designer → Insights → Next Session             │    ║
║   │                                                                   │    ║
║   │  • Collect performance metrics after publish                      │    ║
║   │  • Feed data back to UX Designer                                  │    ║
║   │  • Continuous design optimization                                 │    ║
║   └──────────────────────────────────────────────────────────────────┘    ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

## Observer Controls

| Command | Effect |
|---------|--------|
| `*status` | Show current step and progress |
| `*skip` | Skip to next step |
| `*retry` | Retry current step |
| `*checkpoint` | Force checkpoint save |
| `*rollback:{step}` | Rollback to specific step |
| `*batch:{n}` | Set batch size to n videos |
| `*pause` | Pause pipeline |
| `*resume` | Resume pipeline |
| `*abort` | Abort current video, continue pipeline |
| `*exit` | Save and exit session |

---

## Error Handling

### Retry Logic

```yaml
retry_policy:
  edge_tts_failure:
    max_retries: 3
    fallback: gtts
  ffmpeg_failure:
    max_retries: 2
    fallback: save_intermediate
  claude_rate_limit:
    max_retries: 5
    backoff: exponential
    fallback: ollama
  quality_check_failure:
    action: quarantine
    notify: true
```

### Quarantine Process

Videos that fail quality checks are:
1. Moved to `./quarantine/` directory
2. Logged with failure reason
3. Available for manual review
4. Can be reprocessed with `*reprocess:{video_id}`

---

## Output Structure

```
output/toeic-videos/
├── {date}/
│   ├── vocab-001/
│   │   ├── shorts.mp4
│   │   ├── standard.mp4
│   │   ├── thumbnail.png
│   │   ├── metadata.json
│   │   ├── script.md
│   │   └── assets/
│   ├── listening-001/
│   └── grammar-001/
└── library/
    ├── vocabulary/
    ├── listening/
    └── grammar/
```

---

## Session Lifecycle

1. **Init**: Load config, setup directories, initialize agents
2. **Planning**: Content Planner creates batch of topics
3. **Production Loop**: For each topic:
   - Script → Audio → Visual → Video → QC
   - Checkpoint after each step
   - Retry on failure, quarantine if persistent
4. **Export**: Package deliverables for all platforms
5. **Summary**: Generate session report, update metrics
6. **Archive**: Save session data, clean up temp files

---

## Metrics Tracking

| Metric | Target |
|--------|--------|
| Videos/Day | Phase 1: 5, Phase 2: 20, Phase 3: 50 |
| Success Rate | > 95% |
| Avg Production Time | < 5 min/video |
| Quality Score | > 8/10 |
| Platform Exports | YouTube + TikTok + Facebook |

---

## Integration Points

- **Language Tagger Agent**: `/microai:language-tagger` for EN/VI classification
- **Edge-TTS Skill**: `/microai:edge-tts` for voiceover generation
- **Ollama Skill**: `/microai:ollama` for cost-effective LLM tasks
- **FFmpeg**: Direct bash integration for video processing
- **Output**: Exportable to YouTube, TikTok, Facebook

### Voice Mapping (enforced by Language Tagger)

| Language Tag | TTS Voice | Use For |
|--------------|-----------|---------|
| `en` | en-US-JennyNeural | English words, collocations, IPA, sentences |
| `vi` | vi-VN-HoaiMyNeural | Vietnamese explanations, instructions |

---

## Design Review Reference

This team was approved with conditions by Deep Thinking Team:
- Session ID: `deep-review-2025-01-04-toeic-001`
- Mode: Deep (Comprehensive)
- Status: `approved-with-conditions`
- Design Doc: `.microai/agents/father-agent/designs/toeic-content-team-design.md`
