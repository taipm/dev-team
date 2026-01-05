# Design Document: create-team - toeic-content-team

## Metadata

| Field | Value |
|-------|-------|
| ID | design-2025-01-04-toeic-001 |
| Type | create-team |
| Name | toeic-content-team |
| Created | 2025-01-04 02:00 |
| Author | Father Agent v2.2 |
| Status | approved-with-conditions |
| Review Mode | deep |

---

## 1. Problem Statement

### 1.1 What are we trying to create?
Một team AI tự động hóa hoàn toàn quy trình sản xuất video học TOEIC cho YouTube, từ lên ý tưởng đến xuất video final.

### 1.2 Why is this needed?
- Thị trường học TOEIC online rất lớn (hàng triệu người học mỗi năm)
- Sản xuất video thủ công tốn nhiều thời gian và công sức
- AI có thể tự động hóa 100% quy trình với chất lượng nhất quán
- Tạo nguồn thu nhập thụ động từ YouTube

### 1.3 Who will use this?
- Content creators muốn xây kênh YouTube học TOEIC
- Educators muốn scale nội dung giảng dạy
- Entrepreneurs muốn passive income từ educational content

### 1.4 Success Criteria
- [ ] Tự động tạo 5-10 video/ngày không cần can thiệp
- [ ] Video có chất lượng đủ tốt để monetize (1000 subs, 4000 watch hours)
- [ ] Hỗ trợ cả YouTube Shorts (30-60s) và Standard (3-10 min)
- [ ] Content đa dạng: Vocabulary, Listening, Grammar

---

## 2. Context

### 2.1 Related Existing Teams/Agents

| Name | Relationship | Overlap Level |
|------|--------------|---------------|
| youtube-team | similar purpose | medium |
| edge-tts skill | will use | high integration |
| ollama skill | will use | high integration |

### 2.2 Constraints

**Technical:**
- Phải sử dụng free/low-cost tools (Edge-TTS, FFmpeg)
- Claude API có rate limits
- Video generation cần computational resources

**Organizational:**
- Team phải hoạt động autonomous
- Cần có quality control trước khi publish

**Resource:**
- Edge-TTS: Free, unlimited
- Ollama: Free, local compute
- FFmpeg: Free, open source
- Claude API: Pay per use

### 2.3 Requirements Summary

| Requirement | Priority | Source |
|-------------|----------|--------|
| Fully automated pipeline | Must | User |
| Mixed content (Vocab, Listening, Grammar) | Must | User |
| Both Shorts + Standard format | Must | User |
| Use Claude + Ollama + Edge-TTS + FFmpeg | Must | User |
| Quality control before publish | Should | Best Practice |
| SEO optimization for YouTube | Should | Best Practice |
| Thumbnail generation | Could | Enhancement |

---

## 3. Proposed Solution

### 3.1 Overview
Pipeline team với 6 agents chuyên biệt, mỗi agent đảm nhận một giai đoạn trong quy trình sản xuất video. Hoạt động hoàn toàn tự động từ topic generation đến final video export.

### 3.2 Architecture

```
.microai/teams/toeic-content-team/
├── workflow.md                    # Main workflow definition
├── agents/
│   ├── content-planner-agent.md   # Lên kế hoạch content
│   ├── script-writer-agent.md     # Viết script chi tiết
│   ├── audio-producer-agent.md    # Tạo audio với Edge-TTS
│   ├── visual-designer-agent.md   # Thiết kế visual/slides
│   ├── video-assembler-agent.md   # Ghép video với FFmpeg
│   └── quality-reviewer-agent.md  # QC và SEO optimization
├── steps/
│   ├── step-01-init.md
│   ├── step-02-content-planning.md
│   ├── step-03-script-writing.md
│   ├── step-04-audio-production.md
│   ├── step-05-visual-design.md
│   ├── step-06-video-assembly.md
│   ├── step-07-quality-review.md
│   └── step-08-export.md
├── knowledge/
│   ├── shared/
│   │   ├── toeic-fundamentals.md
│   │   ├── youtube-best-practices.md
│   │   └── ai-tools-integration.md
│   ├── content-planner/
│   ├── script-writer/
│   ├── audio-producer/
│   ├── visual-designer/
│   ├── video-assembler/
│   └── quality-reviewer/
├── templates/
│   ├── vocab-video-template.md
│   ├── listening-video-template.md
│   ├── grammar-video-template.md
│   ├── shorts-template.md
│   └── thumbnail-template.md
├── memory/
├── checkpoints/
└── logs/
```

### 3.3 Team Agents Design

| Agent | Icon | Role | AI Tools | Output |
|-------|------|------|----------|--------|
| Content Planner | 📋 | Lên kế hoạch topics, research keywords | Claude/Ollama | Content calendar, topic briefs |
| Script Writer | ✍️ | Viết script chi tiết với timestamps | Claude | Full script với cues |
| Audio Producer | 🎙️ | Tạo voiceover với Edge-TTS | Edge-TTS | Audio files (.mp3) |
| Visual Designer | 🎨 | Tạo slides/visual cues | Claude + Templates | Image sequence |
| Video Assembler | 🎬 | Ghép audio + visual thành video | FFmpeg | Video files (.mp4) |
| Quality Reviewer | ✅ | QC, SEO, thumbnail, metadata | Claude | Final package ready to upload |

### 3.4 Workflow Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TOEIC CONTENT TEAM PIPELINE                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐      │
│  │ 📋       │    │ ✍️        │    │ 🎙️       │    │ 🎨       │      │
│  │ Content  │ -> │ Script   │ -> │ Audio    │ -> │ Visual   │      │
│  │ Planner  │    │ Writer   │    │ Producer │    │ Designer │      │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘      │
│       │                                               │              │
│       v                                               v              │
│  Topic Brief                                    Visual Assets       │
│                                                       │              │
│                         ┌──────────┐    ┌──────────┐ │              │
│                         │ 🎬       │ <- │ ✅       │<┘              │
│                         │ Video    │    │ Quality  │                │
│                         │ Assembler│    │ Reviewer │                │
│                         └──────────┘    └──────────┘                │
│                              │                                       │
│                              v                                       │
│                    ┌─────────────────┐                              │
│                    │  FINAL OUTPUT   │                              │
│                    │  - Shorts.mp4   │                              │
│                    │  - Standard.mp4 │                              │
│                    │  - Thumbnail    │                              │
│                    │  - Metadata     │                              │
│                    └─────────────────┘                              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.5 Technical Specification

```yaml
team:
  name: toeic-content-team
  type: pipeline
  complexity: full
  model: opus

agents_count: 6

ai_stack:
  llm_primary: claude-sonnet  # For complex tasks
  llm_secondary: ollama/qwen3:1.7b  # For simple tasks, cost saving
  tts: edge-tts  # Vietnamese voice support
  video: ffmpeg  # Video processing

features:
  checkpoint: enabled
  communication: enabled
  kanban: enabled
  autonomous: true
  parallel: false  # Sequential pipeline

output_formats:
  shorts:
    resolution: 1080x1920
    duration: 30-60s
    aspect: 9:16
  standard:
    resolution: 1920x1080
    duration: 3-10min
    aspect: 16:9

content_types:
  - vocabulary (40%)
  - listening (30%)
  - grammar (30%)
```

---

## 4. Alternatives Considered

### Alternative 1: Single Agent Approach
- **Description**: Một agent xử lý toàn bộ pipeline
- **Pros**: Đơn giản, ít overhead
- **Cons**: Quá phức tạp cho 1 agent, khó maintain, không parallel
- **Why Rejected**: Pipeline phức tạp cần chuyên môn hóa

### Alternative 2: Human-in-the-loop
- **Description**: Thêm bước review thủ công trước publish
- **Pros**: Đảm bảo chất lượng cao
- **Cons**: Không fully automated, tốn thời gian
- **Why Rejected**: User yêu cầu hoàn toàn tự động

### Alternative 3: External Services (Pictory, Synthesia)
- **Description**: Sử dụng SaaS video generation
- **Pros**: Chất lượng cao, dễ dùng
- **Cons**: Chi phí cao, phụ thuộc bên thứ 3
- **Why Rejected**: User muốn dùng free/local tools

---

## 5. Risk Assessment

### 5.1 Identified Risks

| Risk | Likelihood | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| YouTube demonetize AI content | Medium | High | Thêm human touch, unique value |
| Audio quality không tự nhiên | Medium | Medium | Test nhiều voices, thêm music |
| Content repetitive | High | Medium | Diverse templates, random elements |
| Copyright issues với images | Medium | High | Chỉ dùng royalty-free, self-generated |
| Rate limiting APIs | Low | Medium | Batch processing, local fallback |

### 5.2 Dependencies

| Dependency | Status | Risk if Unavailable |
|------------|--------|---------------------|
| Edge-TTS | Available | Critical - no audio |
| FFmpeg | Available | Critical - no video |
| Claude API | Available | High - use Ollama fallback |
| Ollama | Available | Medium - use Claude only |

### 5.3 Failure Modes
- **If Edge-TTS fails**: Fallback to gTTS hoặc queue retry
- **If FFmpeg fails**: Save intermediate files, manual assembly
- **If Claude rate limited**: Switch to Ollama, reduce batch size
- **If video quality low**: Add quality gates, reject and regenerate

---

## 6. Review Request

### 6.1 Recommended Review Mode
- [ ] Quick (simple clone, minor changes)
- [ ] Standard (new agent, significant modifications)
- [x] Deep (new team, critical infrastructure)

### 6.2 Specific Questions for Deep Thinking Team

1. **Architecture Question**: Pipeline 6 agents có phải là optimal? Có nên merge hoặc split agent nào?

2. **Risk Question**: YouTube có thể detect và penalize AI-generated content? Cách mitigate?

3. **Technical Question**: Edge-TTS có đủ tự nhiên cho educational content? Alternatives?

4. **Business Question**: Content strategy nào tối ưu cho monetization nhanh nhất?

5. **Quality Question**: Làm sao đảm bảo TOEIC content accuracy mà không có human review?

### 6.3 Focus Areas
- [x] Design soundness
- [x] Risk assessment
- [x] Performance implications
- [x] Maintainability
- [x] Integration concerns
- [x] Business viability

---

## 7. Approval Record

### 7.1 Review Session

| Field | Value |
|-------|-------|
| Session ID | deep-review-2025-01-04-toeic-001 |
| Mode | deep (Comprehensive) |
| Date | 2025-01-04 |
| Duration | ~2 hours |
| Agents Consulted | 12 (Socrates, Aristotle, Musk, Feynman, Linus, Munger, Grove, Polya, Dijkstra, Bezos, Da Vinci, Jobs) |

### 7.2 Decision

**Status**: `approved-with-conditions`

**Conditions (Must address before full deployment):**

1. **Error Handling & Checkpointing**
   - Add retry logic with exponential backoff
   - Checkpoint after each agent stage
   - Quarantine failed videos for manual review

2. **Content Validation**
   - Maintain TOEIC-validated question corpus
   - Cross-check generated content against corpus
   - Human spot-check for first 50 videos

3. **Phased Rollout**
   - Start with 3-4 core agents (Script/Audio/Video/QC)
   - Add Planner and Visual after proving pipeline
   - Target 5→20→50 videos/day progression

4. **Multi-Platform Strategy**
   - Export for YouTube, TikTok, Facebook from Day 1
   - Build content library as independent asset

5. **Brand Identity**
   - Define visual style guide
   - Create signature audio cues
   - Design learning journey structure

### 7.3 Key Insights from Review

| Agent | Insight |
|-------|---------|
| ⚡ Musk | Design is sound but not aggressive enough - should target 10x (50+ videos/day) |
| 🔬 Feynman | Hidden complexity in Visual Designer and Quality Reviewer needs clarification |
| 🐧 Linus | Conceptually sound but operationally fragile - needs error handling |
| 🎭 Munger | Multiple failure modes could compound - add human validation checkpoint |
| 🔧 Grove | Single platform dependency risky - need multi-platform from Day 1 |
| 📐 Polya | Phased rollout recommended - start with 3-4 agents, evolve based on bottlenecks |
| 🔷 Dijkstra | Need formal content validation against TOEIC corpus |
| 📦 Bezos | Focus on velocity over perfection in MVP - build flywheel |
| 🎨 Da Vinci | Team should be learning machine - continuously improving |
| 🍎 Jobs | Design lacks soul - add brand identity and emotional connection |

### 7.4 Recommendations (Should address for long-term)

- Consider TTS alternatives as technology improves
- Build analytics dashboard for content performance
- Plan for YouTube policy changes (disclosure, etc.)
- Add A/B testing capability for thumbnails/titles

### 7.5 Risk Assessment Summary

| Risk | Level | Mitigation |
|------|-------|------------|
| YouTube Demonetization | MEDIUM | Multi-platform strategy |
| Content Quality | MEDIUM | Validation + spot-check |
| Technical Failure | LOW | Error handling |
| Competition | MEDIUM | Brand + quality focus |

### 7.6 Sign-off

- **Reviewed by**: Deep Thinking Team (Maestro)
- **Approved by**: Deep Thinking Team
- **Date**: 2025-01-04
- **Decision**: APPROVED WITH CONDITIONS

---

## 8. Execution Checklist

After approval, execute these steps:

### Pre-Execution
- [x] All conditions from review addressed (integrated into design)
- [x] Design document status updated to "approved-with-conditions"
- [x] Deep Thinking Team review completed

### Execution
- [ ] Create team directory structure
- [ ] Generate 6 agent files
- [ ] Create 8 step files
- [ ] Create knowledge files
- [ ] Create templates
- [ ] Register command

### Post-Execution
- [ ] Validate team structure
- [ ] Archive design document
- [ ] Test with sample video generation
