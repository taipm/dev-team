# Active Recall Methodology for TOEIC Learning Videos

## Nguyên tắc Active Recall

Active Recall là phương pháp học tập khoa học, yêu cầu người học **chủ động nhớ lại** thông tin thay vì thụ động tiếp nhận.

---

## Cấu trúc bài học Video (60s Shorts)

### Phase 1: HOOK (0-3s)
```
[Câu hỏi kích thích tư duy]
"Bạn biết từ này chưa?"
"Từ này hay gặp trong Part 5!"
```

### Phase 2: PRESENT (3-15s)
```
[Giới thiệu từ/khái niệm]
- Từ vựng + IPA
- Nghĩa tiếng Việt
- Word form (noun/verb/adj)
```

### Phase 3: EXAMPLE IN CONTEXT (15-30s)
```
[Ví dụ trong ngữ cảnh TOEIC thực tế]
- Câu ví dụ 1 + Dịch nghĩa
- Câu ví dụ 2 + Dịch nghĩa
```

### Phase 4: ACTIVE RECALL CHALLENGE (30-42s)
```
[Thử thách nhớ lại - QUAN TRỌNG NHẤT]

Kỹ thuật 1: Fill-in-the-blank
"Điền từ vào chỗ trống: The team ___ all their goals."
[Pause 2-3 giây để viewer suy nghĩ]
"Đáp án: accomplished"

Kỹ thuật 2: Multiple Choice
"Chọn đáp án đúng:
A) accomplish to do
B) accomplish doing
C) accomplish a goal"
[Pause 2-3 giây]
"Đáp án: C"

Kỹ thuật 3: Recall prompt
"Nghĩa của ACCOMPLISH là gì?"
[Pause 2-3 giây]
"Hoàn thành, đạt được"
```

### Phase 5: REINFORCE (42-52s)
```
[Củng cố kiến thức]
- Collocations phổ biến
- Lỗi thường gặp (Common mistakes)
- Mẹo nhớ nhanh
```

### Phase 6: CTA + SPACED REPETITION (52-60s)
```
[Call-to-action + nhắc lại]
"ACCOMPLISH = hoàn thành"
"Nhớ xem lại video này sau 1 ngày!"
"Follow để học TOEIC mỗi ngày!"
```

---

## Sync Points (Audio-Text-Video)

Mỗi phase có sync point rõ ràng:

| Phase | Thời gian | Audio | Text Display | Visual |
|-------|-----------|-------|--------------|--------|
| HOOK | 0-3s | Hook question | Question text | Animated title |
| PRESENT | 3-15s | Word + IPA + Definition | Word card | Clean word display |
| EXAMPLE | 15-30s | Read examples | Example sentences | Highlight key word |
| CHALLENGE | 30-42s | Ask question + Pause + Answer | Question → Blank → Answer | Progressive reveal |
| REINFORCE | 42-52s | Tips and collocations | Tip list | Color-coded tips |
| CTA | 52-60s | Summary + CTA | Summary card | CTA animation |

---

## Timing Rules

### Pause Points (cho Active Recall)
```yaml
pause_duration:
  fill_in_blank: 3s
  multiple_choice: 4s
  recall_prompt: 3s

audio_timing:
  before_pause: "[Câu hỏi]"
  during_pause: "[Silence hoặc nhạc nhẹ]"
  after_pause: "[Đáp án]"
```

### Segment Duration
```yaml
segments:
  hook: 3s
  present: 12s
  example: 15s
  challenge: 12s  # Bao gồm pause
  reinforce: 10s
  cta: 8s
total: 60s
```

---

## Visual Sync Markers

### Text Appearance
```
[SYNC] Khi audio bắt đầu từ → Text xuất hiện
[SYNC] Khi audio pause → Text hiện "?" hoặc "___"
[SYNC] Khi audio nói đáp án → Text reveal animation
```

### Color Coding
```yaml
colors:
  word: "#4ECDC4"  # Cyan - từ chính
  ipa: "#B8B8B8"   # Gray - phiên âm
  definition_vi: "#FFFFFF"  # White - nghĩa tiếng Việt
  example_en: "#FFFFFF"  # White - ví dụ tiếng Anh
  example_vi: "#B8B8B8"  # Gray - dịch nghĩa
  correct: "#7AC74F"  # Green - đáp án đúng
  wrong: "#FF6B6B"  # Red - đáp án sai
  challenge: "#FFD93D"  # Yellow - câu hỏi thử thách
  cta: "#FF6B35"  # Orange - call to action
```

---

## Tiếng Việt Unicode Requirements

### Font Support
```yaml
fonts:
  primary: "Roboto"  # Hỗ trợ Vietnamese Unicode
  fallback: "Noto Sans Vietnamese"

encoding: UTF-8

vietnamese_characters:
  - à, á, ả, ã, ạ
  - ă, ằ, ắ, ẳ, ẵ, ặ
  - â, ầ, ấ, ẩ, ẫ, ậ
  - è, é, ẻ, ẽ, ẹ
  - ê, ề, ế, ể, ễ, ệ
  - ì, í, ỉ, ĩ, ị
  - ò, ó, ỏ, õ, ọ
  - ô, ồ, ố, ổ, ỗ, ộ
  - ơ, ờ, ớ, ở, ỡ, ợ
  - ù, ú, ủ, ũ, ụ
  - ư, ừ, ứ, ử, ữ, ự
  - ỳ, ý, ỷ, ỹ, ỵ
  - đ, Đ
```

### FFmpeg Vietnamese Text
```bash
# Sử dụng font hỗ trợ tiếng Việt
ffmpeg -i input.mp4 \
  -vf "drawtext=text='Hoàn thành':fontfile=/path/to/Roboto.ttf:fontsize=48:fontcolor=white" \
  output.mp4

# Hoặc sử dụng ASS subtitles cho text phức tạp
ffmpeg -i input.mp4 \
  -vf "ass=subtitles.ass" \
  output.mp4
```

---

## Script Format với Sync Markers

```markdown
## [00:00-00:03] HOOK
**Audio**: "Từ vựng TOEIC hay gặp nhất Part 5!"
**Text**: "TỪ VỰNG TOEIC"
**Visual**: Title card animation

## [00:03-00:15] PRESENT
**Audio**: "Accomplish. /əˈkɑːmplɪʃ/. Động từ. Nghĩa là hoàn thành, đạt được."
**Text**:
  - [00:03] "ACCOMPLISH"
  - [00:06] "/əˈkɑːmplɪʃ/"
  - [00:09] "verb"
  - [00:11] "hoàn thành, đạt được"
**Visual**: Word card với progressive reveal

## [00:15-00:30] EXAMPLE
**Audio**: "Ví dụ 1: The team accomplished all their goals ahead of schedule."
**Text**:
  - [00:15] "The team accomplished all their goals ahead of schedule."
  - [00:22] "Nhóm đã hoàn thành tất cả mục tiêu trước thời hạn."
**Visual**: Example card, highlight "accomplished"

## [00:30-00:42] ACTIVE RECALL CHALLENGE
**Audio**: "Bây giờ thử điền từ vào chỗ trống."
**Text**: [00:30] "She ___ the difficult task with ease."
**Audio**: "[PAUSE 3 giây]"
**Text**: [00:33] "???"
**Audio**: "Đáp án là accomplished."
**Text**: [00:36] "She [accomplished] the difficult task with ease."
**Visual**: Reveal animation với màu xanh lá

## [00:42-00:52] REINFORCE
**Audio**: "Nhớ các collocations: accomplish a goal, accomplish a task, accomplish a mission."
**Text**:
  - "accomplish a goal ✓"
  - "accomplish a task ✓"
  - "accomplish a mission ✓"
  - "accomplish to do ✗"
**Visual**: Checklist animation

## [00:52-00:60] CTA
**Audio**: "ACCOMPLISH nghĩa là hoàn thành. Follow để học TOEIC mỗi ngày!"
**Text**:
  - "ACCOMPLISH = hoàn thành"
  - "FOLLOW để học mỗi ngày!"
**Visual**: CTA animation with logo
```

---

## Quality Checklist

### Active Recall Integration
- [ ] Có câu hỏi thử thách (fill-in-blank / multiple choice / recall prompt)
- [ ] Có pause time đủ để viewer suy nghĩ (3-4 giây)
- [ ] Có đáp án rõ ràng sau pause
- [ ] Có spaced repetition reminder

### Audio-Text-Video Sync
- [ ] Text xuất hiện đồng bộ với audio
- [ ] Pause trong audio khớp với "???" trên màn hình
- [ ] Answer reveal khớp với audio nói đáp án
- [ ] Timing tolerance: ±0.5 giây

### Vietnamese Unicode
- [ ] Tất cả tiếng Việt có dấu đầy đủ
- [ ] Font hỗ trợ đầy đủ Vietnamese characters
- [ ] Không có ký tự bị lỗi hoặc thay thế

---

## Implementation Notes

### Tạo ASS Subtitles cho Vietnamese
```
[Script Info]
Title: TOEIC Vocabulary
ScriptType: v4.00+
Collisions: Normal
PlayDepth: 0
PlayResX: 1080
PlayResY: 1920

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Word,Roboto,80,&H00D4EC4E,&H000000FF,&H00000000,&H00000000,1,0,0,0,100,100,0,0,1,2,0,2,10,10,10,1
Style: Definition,Roboto,48,&H00FFFFFF,&H000000FF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,2,0,2,10,10,10,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
Dialogue: 0,0:00:03.00,0:00:15.00,Word,,0,0,0,,ACCOMPLISH
Dialogue: 0,0:00:06.00,0:00:15.00,Definition,,0,0,0,,hoàn thành, đạt được
```

### Audio Generation với Pause
```bash
# Tạo segment trước pause
edge-tts --voice "vi-VN-HoaiMyNeural" --text "Điền từ vào chỗ trống" --write-media before_pause.mp3

# Tạo silence (pause)
ffmpeg -f lavfi -i anullsrc=r=48000:cl=mono -t 3 -q:a 9 pause_silence.mp3

# Tạo segment sau pause
edge-tts --voice "vi-VN-HoaiMyNeural" --text "Đáp án là accomplished" --write-media after_pause.mp3

# Ghép lại
ffmpeg -f concat -i segments.txt -c:a libmp3lame combined.mp3
```
