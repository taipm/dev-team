# Decision Log

## AI YouTube Automation v2 - Nhật Ký Quyết Định

**Version:** 1.0
**Ngày tạo:** 2026-01-04
**Mục đích:** Ghi chép và theo dõi các quyết định quan trọng trong dự án

---

## Hướng Dẫn Sử Dụng

### Khi nào cần ghi Decision Log?
- Thay đổi công cụ/tool
- Thay đổi quy trình/workflow
- Quyết định về content strategy
- Thay đổi technical setup
- Bất kỳ quyết định nào ảnh hưởng đến output hoặc team

### Cách sử dụng:
1. Copy template Decision Entry
2. Điền đầy đủ thông tin
3. Thêm vào phần Decision Entries (mới nhất ở trên)
4. Update Summary Table

---

## Decision Entry Template

```markdown
### DEC-[XXX]: [Tiêu đề quyết định ngắn gọn]

**Ngày:** YYYY-MM-DD
**Người quyết định:** [Tên]
**Stakeholders:** [Người liên quan]
**Trạng thái:** [ ] Proposed | [ ] Approved | [ ] Implemented | [ ] Superseded

#### Bối cảnh (Context)
[Mô tả tình huống dẫn đến cần đưa ra quyết định này]

#### Vấn đề (Problem Statement)
[Vấn đề cụ thể cần giải quyết]

#### Các phương án (Options Considered)

| Option | Mô tả | Ưu điểm | Nhược điểm |
|--------|-------|---------|------------|
| A | | | |
| B | | | |
| C | | | |

#### Quyết định (Decision)
[Phương án được chọn và lý do]

#### Hệ quả (Consequences)
- **Positive:** [Lợi ích]
- **Negative:** [Trade-offs]
- **Risks:** [Rủi ro]

#### Action Items
| Task | Người thực hiện | Deadline | Status |
|------|-----------------|----------|--------|
| | | | [ ] |
| | | | [ ] |

#### Review Date
[Ngày xem xét lại quyết định này: YYYY-MM-DD]

---
```

---

## Summary Table

| ID | Ngày | Tiêu đề | Trạng thái | Owner |
|----|------|---------|------------|-------|
| DEC-001 | 2026-01-04 | Chọn Edge-TTS làm TTS engine chính | Implemented | [TBD] |
| DEC-002 | 2026-01-04 | Sử dụng CapCut thay vì DaVinci Resolve | Implemented | [TBD] |
| DEC-003 | 2026-01-04 | Target video length 8-12 phút | Approved | [TBD] |
| | | | | |

---

## Decision Entries

### DEC-003: Target Video Length 8-12 Phút

**Ngày:** 2026-01-04
**Người quyết định:** [TBD]
**Stakeholders:** Content Team
**Trạng thái:** [x] Approved | [ ] Implemented

#### Bối cảnh (Context)
Cần xác định độ dài video tiêu chuẩn để tối ưu hóa giữa engagement, watch time, và production effort.

#### Vấn đề (Problem Statement)
Video quá ngắn không đủ depth, video quá dài mất retention. Cần tìm sweet spot cho niche của kênh.

#### Các phương án (Options Considered)

| Option | Mô tả | Ưu điểm | Nhược điểm |
|--------|-------|---------|------------|
| A | Short-form (1-3 phút) | Quick production, TikTok repurpose | Ít ad revenue, khó cover topic sâu |
| B | Medium (8-12 phút) | Good watch time, đủ depth | Cần nhiều content hơn |
| C | Long-form (15-20 phút) | High watch time, authority | Khó giữ retention, production lâu |

#### Quyết định (Decision)
Chọn **Option B: Medium 8-12 phút** vì:
1. Đủ dài để insert mid-roll ads
2. Phù hợp với attention span của target audience
3. Balance giữa production time và content depth
4. Data từ competitor analysis cho thấy videos 8-12 phút perform tốt nhất trong niche

#### Hệ quả (Consequences)
- **Positive:** Đủ thời gian cover topic, monetization tốt
- **Negative:** Cần script khoảng 1500-2000 từ mỗi video
- **Risks:** Nếu niche thay đổi, có thể cần adjust

#### Action Items
| Task | Người thực hiện | Deadline | Status |
|------|-----------------|----------|--------|
| Update script template với target word count | Content Lead | 2026-01-10 | [ ] |
| Adjust production timeline | Production | 2026-01-10 | [ ] |

#### Review Date
2026-04-04 (sau 3 tháng để evaluate performance)

---

### DEC-002: Sử Dụng CapCut Thay Vì DaVinci Resolve

**Ngày:** 2026-01-04
**Người quyết định:** [TBD]
**Stakeholders:** Production Team
**Trạng thái:** [x] Implemented

#### Bối cảnh (Context)
Cần chọn video editing software chính cho production pipeline. Team có mixed skill levels.

#### Vấn đề (Problem Statement)
Cần tool đủ powerful cho professional output nhưng learning curve không quá cao để onboard team members nhanh.

#### Các phương án (Options Considered)

| Option | Mô tả | Ưu điểm | Nhược điểm |
|--------|-------|---------|------------|
| A | DaVinci Resolve | Pro-grade, free, powerful color | Steep learning curve, heavy |
| B | CapCut | Easy, auto-captions, templates | Less pro features |
| C | Adobe Premiere | Industry standard, extensive | Expensive, complex |
| D | Final Cut Pro | Fast, optimized for Mac | Mac only, cost |

#### Quyết định (Decision)
Chọn **Option B: CapCut** vì:
1. Auto-captions tiếng Việt excellent - saves 50% captioning time
2. Built-in templates speed up production
3. Free với đủ features cần thiết
4. Team có thể học trong 1-2 ngày
5. Export quality đạt yêu cầu YouTube 1080p

#### Hệ quả (Consequences)
- **Positive:** Fast onboarding, consistent output, cost effective
- **Negative:** Giới hạn với advanced effects, color grading basic
- **Risks:** Nếu cần cinematic quality sau này, có thể phải migrate

#### Action Items
| Task | Người thực hiện | Deadline | Status |
|------|-----------------|----------|--------|
| Create CapCut project template | Production Lead | 2026-01-07 | [x] |
| Document keyboard shortcuts | Production | 2026-01-08 | [x] |
| Train team on CapCut | Production Lead | 2026-01-10 | [x] |

#### Review Date
2026-07-04 (sau 6 tháng)

---

### DEC-001: Chọn Edge-TTS Làm TTS Engine Chính

**Ngày:** 2026-01-04
**Người quyết định:** [TBD]
**Stakeholders:** Tech Team, Content Team
**Trạng thái:** [x] Implemented

#### Bối cảnh (Context)
Cần text-to-speech solution cho voiceover videos. Yêu cầu: tiếng Việt tự nhiên, cost-effective, easy to automate.

#### Vấn đề (Problem Statement)
Thuê voice actor tốn thời gian và chi phí cao. Cần TTS solution có thể scale.

#### Các phương án (Options Considered)

| Option | Mô tả | Ưu điểm | Nhược điểm |
|--------|-------|---------|------------|
| A | Edge-TTS (Microsoft) | Free, natural voices, Vietnamese support | Cần internet, limited control |
| B | Google Cloud TTS | High quality, many languages | Paid ($4/1M chars), setup complex |
| C | ElevenLabs | Most natural, voice cloning | Expensive ($5-22/mo), limited Vietnamese |
| D | Human Voice Actor | Most natural, unique | Slow turnaround, costly ($50-200/video) |

#### Quyết định (Decision)
Chọn **Option A: Edge-TTS** vì:
1. Completely free - critical cho early stage
2. Vietnamese voices (HoaiMyNeural, NamMinhNeural) đủ natural
3. Easy CLI integration cho automation
4. Consistent quality và availability
5. Có thể upgrade lên paid service sau nếu cần

#### Hệ quả (Consequences)
- **Positive:** Zero cost, scriptable, fast turnaround
- **Negative:** Không có emotion variation, limited voice selection
- **Risks:** Microsoft có thể thay đổi policy; cần backup plan

#### Action Items
| Task | Người thực hiện | Deadline | Status |
|------|-----------------|----------|--------|
| Setup Edge-TTS on all machines | Tech Lead | 2026-01-05 | [x] |
| Create bash script for batch processing | Tech Lead | 2026-01-06 | [x] |
| Document optimal settings | Tech Lead | 2026-01-07 | [x] |

#### Review Date
2026-04-04 (sau 3 tháng để evaluate quality feedback từ audience)

---

## Pending Decisions

### Các quyết định đang chờ xử lý:

| ID | Tiêu đề | Deadline | Status |
|----|---------|----------|--------|
| DEC-004 | Monetization strategy (AdSense vs Sponsorship focus) | 2026-02-01 | Pending research |
| DEC-005 | Content pillars và series structure | 2026-01-15 | Under discussion |
| DEC-006 | Upload frequency (3x vs 5x per week) | 2026-01-20 | Need data |

---

## Superseded Decisions

| ID | Tiêu đề | Superseded By | Date |
|----|---------|---------------|------|
| | | | |

---

## Decision Review Schedule

| Quarter | Review Date | Decisions to Review |
|---------|-------------|---------------------|
| Q1 2026 | 2026-04-01 | DEC-001, DEC-003 |
| Q2 2026 | 2026-07-01 | DEC-002 |
| Q3 2026 | 2026-10-01 | All active decisions |
| Q4 2026 | 2027-01-01 | Annual review |

---

## Appendix: Decision Categories

### Category Tags
- `#tool` - Tool/Software selection
- `#process` - Process/Workflow changes
- `#content` - Content strategy
- `#technical` - Technical setup
- `#business` - Business/Monetization
- `#team` - Team structure/roles

### Impact Levels
- **High:** Affects entire production pipeline
- **Medium:** Affects specific phase/team
- **Low:** Minor optimization

### Urgency Levels
- **Critical:** Must decide within 24 hours
- **High:** Within 1 week
- **Normal:** Within 2 weeks
- **Low:** Can wait for next planning cycle

---

**Version History:**
| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-01-04 | Initial creation with template and sample entries | SOP Agent |
