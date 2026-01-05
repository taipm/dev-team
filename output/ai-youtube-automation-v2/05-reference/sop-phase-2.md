# SOP Phase 2: Content Pipeline

## AI YouTube Automation v2 - Quy Trình Sản Xuất Nội Dung

**Version:** 1.0
**Ngày tạo:** 2026-01-04
**Người phụ trách:** [Tên]
**Thời gian mỗi video:** 2-4 giờ

---

## 1. Mục Tiêu

Thiết lập quy trình sản xuất video YouTube hoàn chỉnh từ ý tưởng đến xuất bản, đảm bảo:
- Chất lượng nội dung nhất quán
- Tối ưu thời gian sản xuất
- Khả năng scale lên nhiều video/tuần

---

## 2. Prerequisites (Điều Kiện Tiên Quyết)

### 2.1 Hoàn Thành Phase 1
- [ ] ChatGPT đã cấu hình Custom Instructions
- [ ] Edge-TTS đã cài đặt và test thành công
- [ ] CapCut đã có project template
- [ ] Canva đã có brand kit và thumbnail template

### 2.2 Chuẩn Bị Content Calendar
- [ ] Danh sách 10-20 ý tưởng video
- [ ] Keyword research cho từng chủ đề
- [ ] Competitor analysis hoàn tất

### 2.3 Assets Sẵn Sàng
- [ ] Stock footage/images (Pexels, Pixabay)
- [ ] Background music (YouTube Audio Library)
- [ ] Sound effects (Freesound)
- [ ] Logo và branding elements

---

## 3. Quy Trình Sản Xuất Video

### STAGE 1: Research & Ideation (30 phút)

#### Bước 1.1: Xác Định Chủ Đề
1. Mở Content Calendar
2. Chọn chủ đề tiếp theo trong danh sách
3. Ghi lại:
   - [ ] Tiêu đề dự kiến
   - [ ] Target keyword chính
   - [ ] 3-5 keywords phụ
   - [ ] Target audience segment

#### Bước 1.2: Research Competitor
1. Search keyword trên YouTube
2. Xem top 5 video cùng chủ đề
3. Ghi chú:
   - [ ] Điểm mạnh của competitor
   - [ ] Gap/thiếu sót có thể khai thác
   - [ ] Hook hiệu quả họ sử dụng
   - [ ] Video length trung bình

#### Bước 1.3: Outline Video
1. Xác định structure:
   ```
   - Hook (0:00 - 0:30)
   - Intro (0:30 - 1:00)
   - Main Content (1:00 - X:00)
     - Point 1
     - Point 2
     - Point 3
   - Summary (X:00 - X:30)
   - CTA (X:30 - End)
   ```
2. Ước tính thời lượng từng phần
3. Xác định visual cần cho mỗi section

**Checkpoint:**
- [ ] Outline đã hoàn thành
- [ ] Keywords đã xác định
- [ ] Competitor research done

---

### STAGE 2: Script Writing với ChatGPT (45 phút)

#### Bước 2.1: Tạo Prompt Template

```markdown
# Prompt Template cho ChatGPT

Bạn là scriptwriter chuyên nghiệp cho YouTube. Viết script video với thông tin sau:

**Chủ đề:** [Điền chủ đề]
**Keyword chính:** [Điền keyword]
**Độ dài:** [X] phút
**Tone:** [Giáo dục/Giải trí/Truyền cảm hứng]
**Target audience:** [Mô tả audience]

**Yêu cầu:**
1. Hook mở đầu gây tò mò trong 30 giây đầu
2. Sử dụng câu ngắn, dễ nghe khi đọc thành audio
3. Có transition phrases giữa các phần
4. Kết thúc với CTA rõ ràng (subscribe, like, comment)
5. Viết bằng tiếng Việt có dấu, tự nhiên

**Format output:**
- [HOOK] - 30 giây
- [INTRO] - 30 giây
- [SECTION 1: Tên section] - X phút
- [SECTION 2: Tên section] - X phút
- [SUMMARY]
- [CTA]
```

#### Bước 2.2: Generate Script
1. Copy prompt template vào ChatGPT
2. Điền thông tin cụ thể
3. Submit và đợi response
4. Review script đầu tiên

#### Bước 2.3: Refine Script
1. Yêu cầu chỉnh sửa nếu cần:
   ```
   Hãy chỉnh lại:
   - Hook cần gây shock hơn
   - Section 2 quá dài, rút gọn còn 2 phút
   - Thêm 1-2 câu hỏi rhetorical
   ```
2. Lặp lại 2-3 lần đến khi hài lòng

#### Bước 2.4: Final Review
1. Đọc to script để kiểm tra flow
2. Đánh dấu từ khó phát âm
3. Thêm ghi chú cho visual
4. Save script vào folder project

**Script Format Cuối:**
```markdown
# [Tiêu Đề Video]
Keyword: [keyword]
Duration: [X] phút
Date: [YYYY-MM-DD]

---

[HOOK - 0:00-0:30]
[Visual: Ảnh/Video shock]
"Bạn có biết rằng [fact gây sốc]? Trong video này..."

[INTRO - 0:30-1:00]
[Visual: Logo animation]
"Xin chào, tôi là [Tên]..."

[SECTION 1 - 1:00-3:00]
[Visual: Infographic]
"Đầu tiên, hãy nói về..."

...
```

**Checkpoint:**
- [ ] Script hoàn chỉnh với timestamps
- [ ] Đã đọc to và check flow
- [ ] Visual notes đã thêm
- [ ] File đã save

---

### STAGE 3: Voiceover với Edge-TTS (30 phút)

#### Bước 3.1: Chuẩn Bị Text
1. Copy phần narration từ script (bỏ visual notes)
2. Chia thành các đoạn nhỏ (<500 từ mỗi đoạn)
3. Save từng đoạn vào file .txt riêng:
   ```
   section_1.txt
   section_2.txt
   section_3.txt
   ```

#### Bước 3.2: Generate Audio

```bash
# Script tự động generate tất cả sections
#!/bin/bash

VOICE="vi-VN-HoaiMyNeural"
RATE="+5%"  # Tốc độ nói (điều chỉnh theo preference)

# Generate từng section
for file in section_*.txt; do
    output="${file%.txt}.mp3"
    edge-tts --voice $VOICE --rate $RATE --file $file --write-media $output
    echo "Generated: $output"
done

# Hoặc chạy từng lệnh:
edge-tts --voice vi-VN-HoaiMyNeural --rate "+5%" --file section_1.txt --write-media section_1.mp3
edge-tts --voice vi-VN-HoaiMyNeural --rate "+5%" --file section_2.txt --write-media section_2.mp3
```

#### Bước 3.3: Review Audio
1. Nghe từng file audio
2. Kiểm tra:
   - [ ] Phát âm đúng
   - [ ] Tốc độ phù hợp
   - [ ] Không có lỗi kỹ thuật
3. Re-generate nếu cần

#### Bước 3.4: Merge Audio (Optional)
```bash
# Dùng ffmpeg để merge
ffmpeg -i "concat:section_1.mp3|section_2.mp3|section_3.mp3" -acodec copy full_audio.mp3
```

**Checkpoint:**
- [ ] Tất cả audio sections đã generate
- [ ] Quality check passed
- [ ] Files đã organize trong folder

---

### STAGE 4: Video Editing với CapCut (60-90 phút)

#### Bước 4.1: Setup Project
1. Mở CapCut
2. Create New Project từ template
3. Import assets:
   - [ ] Audio files từ Stage 3
   - [ ] Stock footage/images
   - [ ] Background music
   - [ ] Logo và overlays

#### Bước 4.2: Timeline Assembly
1. Kéo audio vào timeline chính
2. Sync visual theo script timestamps:
   ```
   0:00-0:30  [HOOK]     -> Video/Image gây chú ý
   0:30-1:00  [INTRO]    -> Logo animation + presenter
   1:00-3:00  [SECTION1] -> B-roll + graphics
   ...
   ```
3. Thêm transitions giữa các section

#### Bước 4.3: Add Visual Elements
1. **Text overlays:**
   - Tiêu đề section
   - Key points
   - Stats/numbers

2. **Auto Captions:**
   - Text > Auto captions > Vietnamese
   - Edit timing nếu sai
   - Style: [Chọn style thống nhất]

3. **Effects:**
   - Zoom in/out cho emphasis
   - Color correction
   - Speed ramping nếu cần

#### Bước 4.4: Audio Mixing
1. Thêm background music (20-30% volume)
2. Thêm sound effects:
   - Whoosh cho transitions
   - Ding cho key points
   - Ambient cho atmosphere
3. Check audio levels:
   - Voiceover: -6dB to -3dB
   - Music: -20dB to -15dB
   - SFX: -12dB to -6dB

#### Bước 4.5: Final Review trong CapCut
1. Play full video từ đầu
2. Check list:
   - [ ] Audio sync chính xác
   - [ ] Không có jump cuts bất thường
   - [ ] Text không bị cắt
   - [ ] Colors nhất quán
   - [ ] Intro và outro đầy đủ

#### Bước 4.6: Export Video
1. Export Settings:
   - Resolution: 1080p (1920x1080)
   - Frame Rate: 30fps
   - Format: MP4
   - Quality: High
2. Export và đợi render
3. Verify file output

**Checkpoint:**
- [ ] Video đã export thành công
- [ ] Playback test passed
- [ ] File size hợp lý (<2GB cho 10 phút)

---

### STAGE 5: Thumbnail với Canva (20 phút)

#### Bước 5.1: Mở Template
1. Vào Canva > Your Templates
2. Chọn YouTube Thumbnail template
3. Duplicate để edit

#### Bước 5.2: Customize Content
1. **Main Image:**
   - Chọn frame từ video hoặc stock image
   - Crop và position
   - Apply filter nhất quán

2. **Text:**
   - Tiêu đề ngắn gọn (3-5 từ)
   - Font size lớn, đọc được trên mobile
   - Contrast với background

3. **Elements:**
   - Emoji/icon nếu phù hợp
   - Border hoặc outline cho text
   - Logo kênh (góc)

#### Bước 5.3: A/B Testing Prep
1. Tạo 2-3 versions khác nhau:
   - Version A: Focus vào face/emotion
   - Version B: Focus vào text
   - Version C: Combination
2. Save tất cả versions

#### Bước 5.4: Export
1. Download > PNG
2. Check: 1280x720, <2MB
3. Rename: `thumbnail_[video_title]_v1.png`

**Checkpoint:**
- [ ] Thumbnail chính đã tạo
- [ ] 2-3 variations cho testing
- [ ] Files đã export đúng format

---

### STAGE 6: Upload & Optimize (30 phút)

#### Bước 6.1: Upload Video
1. Vào YouTube Studio
2. Click "Create" > "Upload videos"
3. Chọn file video đã export
4. Đợi upload và processing

#### Bước 6.2: Optimize Metadata

**Title:**
```
[Keyword chính] + [Benefit/Hook] | [Brand/Series name]
Ví dụ: "Cách Kiếm Tiền Online 2026: 5 Phương Pháp Đã Được Chứng Minh | AI Money"
```

**Description:**
```markdown
[Hook 2 dòng đầu - quan trọng nhất]

Trong video này, bạn sẽ học được:
- [Điểm 1]
- [Điểm 2]
- [Điểm 3]

Timestamps:
0:00 - Intro
0:30 - [Section 1]
2:00 - [Section 2]
...

Links hữu ích:
- [Link 1]
- [Link 2]

Kết nối với tôi:
- Facebook: [link]
- Website: [link]

#hashtag1 #hashtag2 #hashtag3

---
[Disclaimer nếu cần]
```

**Tags:**
```
keyword chính, keyword phụ 1, keyword phụ 2, [tên kênh], [category]
```

#### Bước 6.3: Thumbnail Upload
1. Click "Upload thumbnail"
2. Chọn file thumbnail chính
3. Preview trên các devices

#### Bước 6.4: Settings
1. **Playlist:** Thêm vào playlist phù hợp
2. **End Screen:** Thêm subscribe + video tiếp theo
3. **Cards:** Thêm 2-3 cards link đến video liên quan
4. **Visibility:** Schedule hoặc Publish

#### Bước 6.5: Final Check
1. Preview video
2. Check:
   - [ ] Thumbnail hiển thị đúng
   - [ ] Title không bị cắt
   - [ ] Description format đúng
   - [ ] Links hoạt động
   - [ ] End screen visible

**Checkpoint:**
- [ ] Video đã publish/schedule
- [ ] Metadata đã optimize
- [ ] End screen và cards đã thêm

---

## 4. Quality Gates

Mỗi Stage phải pass Quality Gate trước khi chuyển sang Stage tiếp:

| Stage | Quality Gate | Pass Criteria |
|-------|--------------|---------------|
| 1. Research | Outline approved | Có hook, structure rõ ràng |
| 2. Script | Script reviewed | Flow tự nhiên, đủ length |
| 3. Voiceover | Audio quality | Không lỗi, phát âm đúng |
| 4. Editing | Video review | Sync, effects, audio mix OK |
| 5. Thumbnail | Visual check | Eye-catching, readable |
| 6. Upload | Final review | All metadata optimized |

---

## 5. Xử Lý Lỗi Thường Gặp

### 5.1 Script Issues

| Vấn đề | Giải pháp |
|--------|-----------|
| ChatGPT viết quá dài | Thêm word limit trong prompt |
| Nội dung generic | Thêm specific examples trong prompt |
| Tone không đúng | Cung cấp sample text mong muốn |

### 5.2 Audio Issues

| Vấn đề | Giải pháp |
|--------|-----------|
| Phát âm sai tên riêng | Viết phonetic: "Ai-phôn" thay "iPhone" |
| Tốc độ quá nhanh | Giảm rate parameter |
| Giọng monotone | Thêm punctuation, chia câu |

### 5.3 Video Issues

| Vấn đề | Giải pháp |
|--------|-----------|
| Audio không sync | Manual adjust trong timeline |
| Export bị lỗi | Giảm quality hoặc chia nhỏ project |
| Captions sai | Edit manual từng caption |

### 5.4 Upload Issues

| Vấn đề | Giải pháp |
|--------|-----------|
| Processing lâu | Đợi 24h, upload lại nếu fail |
| Thumbnail bị blur | Check resolution 1280x720 |
| Copyright claim | Đổi music hoặc dispute |

---

## 6. Templates & Resources

### Folder Structure cho Mỗi Video:
```
/video_[YYYY-MM-DD]_[title]/
├── 01_research/
│   ├── outline.md
│   └── competitor_notes.md
├── 02_script/
│   ├── script_v1.md
│   └── script_final.md
├── 03_audio/
│   ├── section_1.txt
│   ├── section_1.mp3
│   └── full_audio.mp3
├── 04_video/
│   ├── project.capcut
│   └── export_final.mp4
├── 05_thumbnail/
│   ├── thumbnail_v1.png
│   └── thumbnail_v2.png
└── 06_metadata/
    └── youtube_metadata.md
```

---

## 7. KPIs & Metrics

### Hiệu Suất Sản Xuất
- Target: 3-5 videos/tuần
- Thời gian trung bình: 3-4 giờ/video
- Quality pass rate: >95%

### Video Performance (theo dõi sau 7 ngày)
- Views: [Target]
- CTR: >5%
- Average view duration: >50%
- Engagement rate: >5%

---

## 8. Phê Duyệt Phase 2

| Vai trò | Người phê duyệt | Ngày | Chữ ký |
|---------|-----------------|------|--------|
| Thực hiện | | | |
| Review | | | |
| Approve | | | |

---

**Ghi chú cập nhật:**
- v1.0 (2026-01-04): Tạo mới SOP Phase 2 - Content Pipeline
