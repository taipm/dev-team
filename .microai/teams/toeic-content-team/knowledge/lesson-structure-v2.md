# TOEIC Video Lesson Structure v2.0

## Nguyên tắc cốt lõi

### Active Recall + Spaced Repetition
- Mỗi video dạy **5 từ mới** + **ôn tập 2-3 từ cũ**
- Bài học liên kết theo chuỗi (linked lessons)
- Hệ thống nhớ lại có khoảng cách (spaced repetition)

---

## Cấu trúc Lesson Series

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TOEIC VOCABULARY SERIES                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Lesson 1 (Day 1)     Lesson 2 (Day 2)     Lesson 3 (Day 3)        │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐       │
│  │ 5 NEW words   │───▶│ 5 NEW words   │───▶│ 5 NEW words   │       │
│  │               │    │ + Review L1   │    │ + Review L1,L2│       │
│  └───────────────┘    └───────────────┘    └───────────────┘       │
│         │                    │                    │                 │
│         ▼                    ▼                    ▼                 │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐       │
│  │ accomplish    │    │ acquire       │    │ adjacent      │       │
│  │ achieve       │    │ adequate      │    │ adjust        │       │
│  │ acknowledge   │    │ adhere        │    │ administer    │       │
│  │ acquire       │    │ adjacent      │    │ admit         │       │
│  │ adapt         │    │ adjust        │    │ adopt         │       │
│  └───────────────┘    └───────────────┘    └───────────────┘       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Learning Context System

### Context Data Structure

```yaml
lesson_context:
  series_id: "toeic-vocab-part5-001"
  lesson_id: "lesson-003"

  # Navigation
  previous_lesson: "lesson-002"
  next_lesson: "lesson-004"

  # Current lesson content
  current:
    new_words: 5
    review_words: 3  # From previous lessons
    total_duration: "3-5 minutes"

  # Historical context (for spaced repetition)
  history:
    lesson_001:
      date: "2025-01-01"
      words: [accomplish, achieve, acknowledge, acquire, adapt]
      mastery_scores: [85, 90, 75, 80, 70]
    lesson_002:
      date: "2025-01-02"
      words: [adequate, adhere, adjacent, adjust, administer]
      mastery_scores: [80, 85, 90, 75, 80]

  # Spaced repetition schedule
  review_schedule:
    day_1: [lesson_001_words]  # Review after 1 day
    day_3: [lesson_001_words]  # Review after 3 days
    day_7: [lesson_001_words, lesson_002_words]  # Review after 1 week
    day_14: [all_previous]     # Review after 2 weeks
    day_30: [all_previous]     # Review after 1 month
```

---

## Video Structure (5 Words per Lesson)

### Duration: 3-5 minutes (Standard) hoặc 60s (Shorts - 1 word highlight)

### Phase Breakdown

```
┌─────────────────────────────────────────────────────────────────────┐
│                     LESSON VIDEO STRUCTURE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PHASE 1: INTRO + CONTEXT (0:00 - 0:15)                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • Lesson number & series info                               │   │
│  │ • "Hôm nay học 5 từ mới + ôn tập 2 từ bài trước"           │   │
│  │ • Quick preview of words                                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  PHASE 2: REVIEW (0:15 - 0:45) - Active Recall                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • "Bài trước học từ gì? Bạn còn nhớ không?"                │   │
│  │ • Quiz 2-3 từ từ bài trước                                  │   │
│  │ • [PAUSE 3s] để viewer recall                               │   │
│  │ • Reveal đáp án                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  PHASE 3: NEW WORDS (0:45 - 3:30) - 5 words x ~30s each           │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ For each word (30 seconds):                                 │   │
│  │ • Word + IPA (5s)                                           │   │
│  │ • Definition Vietnamese (5s)                                │   │
│  │ • TOEIC Example sentence (10s)                              │   │
│  │ • Quick tip/collocation (5s)                                │   │
│  │ • Transition to next word (5s)                              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  PHASE 4: ACTIVE RECALL CHALLENGE (3:30 - 4:15)                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • Quiz tất cả 5 từ mới                                      │   │
│  │ • Fill-in-the-blank hoặc Multiple choice                    │   │
│  │ • [PAUSE 3-5s] cho mỗi câu                                  │   │
│  │ • Reveal đáp án + giải thích ngắn                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  PHASE 5: SUMMARY + PREVIEW (4:15 - 4:45)                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • Tóm tắt 5 từ đã học                                       │   │
│  │ • "Bài sau sẽ học: [preview 5 từ tiếp]"                    │   │
│  │ • Spaced repetition reminder: "Nhớ xem lại sau 1 ngày!"    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  PHASE 6: CTA (4:45 - 5:00)                                        │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • Subscribe/Follow                                          │   │
│  │ • Playlist link                                             │   │
│  │ • Comment section engagement                                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Sync Timeline Format

### Precise Audio-Text-Video Sync

```yaml
timeline:
  - time: "00:00.000"
    audio: "Chào mừng đến với bài học số 3"
    text: "BÀI 3: TỪ VỰNG TOEIC PART 5"
    visual: "title_card"

  - time: "00:05.000"
    audio: "Hôm nay chúng ta học 5 từ mới và ôn tập 2 từ bài trước"
    text: "5 TỪ MỚI + 2 TỪ ÔN TẬP"
    visual: "overview_card"

  - time: "00:15.000"
    audio: "Trước tiên, bạn còn nhớ từ accomplish không?"
    text: "ÔN TẬP: ACCOMPLISH = ?"
    visual: "review_quiz"
    pause: 3000  # 3 second pause

  - time: "00:18.000"
    audio: "Accomplish nghĩa là hoàn thành"
    text: "ACCOMPLISH = hoàn thành ✓"
    visual: "answer_reveal"

  # ... continue for all segments
```

---

## Database Schema for Learning Progress

```sql
-- Lessons table
CREATE TABLE lessons (
  id VARCHAR PRIMARY KEY,
  series_id VARCHAR,
  lesson_number INT,
  title VARCHAR,
  words JSON,  -- Array of 5 words
  created_at TIMESTAMP
);

-- Learning progress table
CREATE TABLE learning_progress (
  user_id VARCHAR,
  lesson_id VARCHAR,
  word VARCHAR,
  exposure_count INT,
  last_reviewed TIMESTAMP,
  mastery_score FLOAT,  -- 0-100
  next_review_date DATE,
  PRIMARY KEY (user_id, lesson_id, word)
);

-- Spaced repetition intervals (in days)
-- Score 0-60: review in 1 day
-- Score 60-80: review in 3 days
-- Score 80-90: review in 7 days
-- Score 90-100: review in 14 days
```

---

## File Naming Convention

```
output/toeic-videos/
├── series-001-part5-vocab/
│   ├── lesson-001/
│   │   ├── video.mp4
│   │   ├── timeline.yaml        # Sync data
│   │   ├── context.json         # Learning context
│   │   ├── words.json           # 5 words data
│   │   └── metadata.json        # YouTube metadata
│   ├── lesson-002/
│   │   └── ...
│   └── series-metadata.json     # Series overview
└── library/
    └── vocabulary-bank.json     # All words with status
```

---

## Content Generation Rules

### Word Selection
1. Nhóm theo chủ đề/Part TOEIC
2. Sắp xếp theo tần suất xuất hiện
3. Tránh từ quá dễ hoặc quá khó liền nhau
4. Mix word forms (noun, verb, adj, adv)

### Review Selection (Spaced Repetition)
1. Ưu tiên từ có mastery_score thấp
2. Ưu tiên từ đã lâu chưa review
3. Tối đa 3 từ review mỗi bài

### Example Sentences
1. Phải là ngữ cảnh TOEIC thực tế
2. Độ dài vừa phải (10-15 từ)
3. Highlight từ cần học

---

## Audio Segment Naming

```
lesson-003/audio/
├── 01_intro.mp3              # "Chào mừng đến với bài 3..."
├── 02_overview.mp3           # "Hôm nay học 5 từ..."
├── 03_review_q1.mp3          # "Bạn còn nhớ từ..."
├── 03_pause_3s.mp3           # 3 second silence
├── 03_review_a1.mp3          # "Đáp án là..."
├── 04_word1_present.mp3      # Word 1 presentation
├── 04_word1_example.mp3      # Word 1 example
├── 05_word2_present.mp3      # Word 2 presentation
├── ...
├── 10_quiz_q1.mp3            # Quiz question 1
├── 10_pause_4s.mp3           # 4 second silence
├── 10_quiz_a1.mp3            # Quiz answer 1
├── ...
├── 15_summary.mp3            # Summary
├── 16_preview.mp3            # Next lesson preview
└── 17_cta.mp3                # Call to action
```

---

## Implementation Notes

### Audio-Text Sync Algorithm
```python
def sync_segments(audio_files, text_content):
    timeline = []
    current_time = 0

    for audio, text in zip(audio_files, text_content):
        duration = get_audio_duration(audio)
        timeline.append({
            'start': current_time,
            'end': current_time + duration,
            'audio': audio,
            'text': text['display'],
            'visual': text['visual_type']
        })
        current_time += duration

    return timeline
```

### Context Injection Template
```
Đây là BÀI {lesson_number} trong series "{series_name}".

BÀI TRƯỚC ({previous_lesson}):
- Đã học: {previous_words}
- Cần ôn: {review_words}

BÀI NÀY:
- Học mới: {new_words}
- Thời lượng: {duration}

BÀI SAU ({next_lesson}):
- Sẽ học: {preview_words}
```
