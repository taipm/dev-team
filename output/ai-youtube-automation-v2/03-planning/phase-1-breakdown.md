# Phase 1: Setup AI Stack

## Tổng quan
- **Thời gian**: Tuần 1-4 (Tháng 1)
- **Mục tiêu**: Cài đặt và cấu hình tất cả AI tools
- **Deliverables**: Pipeline hoạt động end-to-end

---

## Tuần 1: Đăng ký & Setup Tools

### Ngày 1-2: Accounts
| Task | Tool | Thời gian | Output |
|------|------|-----------|--------|
| Đăng ký ChatGPT | chat.openai.com | 15 phút | Account ready |
| Đăng ký Canva | canva.com | 10 phút | Account ready |
| Cài đặt CapCut | capcut.com | 20 phút | App installed |
| Test Edge-TTS | Terminal | 30 phút | Voice working |

### Ngày 3-4: Test Basic Functions
- [ ] ChatGPT: Test script generation
- [ ] Edge-TTS: Test Vietnamese voices
- [ ] CapCut: Import video thử
- [ ] Canva: Tạo thumbnail mẫu

### Ngày 5-7: Document Workflow
- [ ] Ghi lại các bước setup
- [ ] Tạo shortcuts/bookmarks
- [ ] Test full pipeline 1 video

---

## Tuần 2: Script Generator

### Tasks
| # | Task | Chi tiết | Est. |
|---|------|----------|------|
| 1 | Tạo prompt template | Script 500-800 từ | 2h |
| 2 | Test với 5 topics | Các chủ đề khác nhau | 3h |
| 3 | Refine prompt | Dựa trên kết quả test | 2h |
| 4 | Document best practices | Lưu vào prompt-library | 1h |

### Verification
- [ ] Script có hook mở đầu hấp dẫn
- [ ] Nội dung đủ 3-5 phút đọc
- [ ] Có call-to-action cuối

---

## Tuần 3: Edge-TTS Pipeline

### Setup Commands
```bash
# Install Edge-TTS
pip install edge-tts

# Test Vietnamese voice
edge-tts --text "Xin chào" --voice "vi-VN-NamMinhNeural" --write-media output.mp3

# Batch processing script
./batch-tts.sh scripts/*.txt
```

### Voice Options
| Voice | Giới tính | Style | Dùng cho |
|-------|-----------|-------|----------|
| vi-VN-NamMinhNeural | Nam | Formal | Kiến thức |
| vi-VN-HoaiMyNeural | Nữ | Friendly | Stories |

---

## Tuần 4: CapCut Workflow

### Template Setup
1. Tạo project template với:
   - Intro animation (5s)
   - Text overlay style
   - Background music track
   - Outro với subscribe CTA

2. Import presets:
   - Color correction
   - Text animations
   - Transitions

### Export Settings
- Resolution: 1080p
- FPS: 30
- Format: MP4
- Audio: AAC 192kbps

---

## Checklist hoàn thành Phase 1

- [ ] Tất cả accounts active
- [ ] Script generator hoạt động
- [ ] TTS pipeline test thành công
- [ ] CapCut template ready
- [ ] Test video đầu tiên published
- [ ] Documentation complete

---

## Rủi ro & Giải pháp

| Rủi ro | Xác suất | Giải pháp |
|--------|----------|-----------|
| ChatGPT limit 50 msg/day | Cao | Batch prompts, save responses |
| Edge-TTS voice không tự nhiên | Trung bình | Thêm nhạc nền, điều chỉnh speed |
| CapCut learning curve | Thấp | YouTube tutorials, presets |

---

**Next**: [Phase 2 - Content Pipeline](./phase-2-breakdown.md)
