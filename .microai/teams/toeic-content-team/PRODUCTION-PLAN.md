# TOEIC Content Team - Production Plan v2.0

## Mục tiêu kiếm tiền YouTube

### YouTube Partner Program Requirements
- 1,000 subscribers
- 4,000 watch hours (long-form) OR 10 million Shorts views (90 days)
- **Strategy**: Focus on Shorts để đạt 10M views nhanh hơn

### Revenue Estimation
| Metric | Value |
|--------|-------|
| Shorts RPM | $0.05 - $0.10 per 1000 views |
| Target views/short | 10,000 - 100,000 |
| Revenue per short | $0.50 - $10 |
| Daily shorts | 5-10 |
| Monthly potential | $75 - $3,000 |

---

## Phase 1: Foundation (Week 1-2)

### 1.1 Content Database
```
output/toeic-database/
├── vocabulary/
│   ├── part5-verbs.json      # 500+ verbs
│   ├── part5-nouns.json      # 500+ nouns
│   ├── part5-adjectives.json # 300+ adjectives
│   ├── collocations.json     # 1000+ collocations
│   └── confusing-pairs.json  # 200+ pairs
├── grammar/
│   ├── tenses.json
│   ├── conditionals.json
│   └── relative-clauses.json
└── listening/
    ├── part1-photos.json
    ├── part2-qa.json
    └── part3-conversations.json
```

### 1.2 Template Library
```
templates/
├── shorts/
│   ├── vocab-1word-30s.yaml      # 1 word, 30s
│   ├── vocab-3words-60s.yaml     # 3 words, 60s
│   ├── quiz-fill-blank-45s.yaml  # Fill-in quiz
│   └── confusing-pair-60s.yaml   # A vs B
├── standard/
│   ├── vocab-5words-3min.yaml    # Current format
│   └── vocab-10words-5min.yaml   # Extended
└── thumbnails/
    ├── shorts-template.psd
    └── standard-template.psd
```

---

## Phase 2: Shorts Production Line (Week 2-4)

### 2.1 YouTube Shorts Specs
```yaml
shorts_format:
  resolution: 1080x1920  # 9:16
  duration: 15-60s       # Sweet spot: 30-45s
  fps: 30
  audio: 128kbps AAC

content_rules:
  - Hook trong 3 giây đầu
  - Text lớn, dễ đọc
  - Pace nhanh, không dead air
  - CTA cuối: "Follow để học mỗi ngày"
```

### 2.2 Shorts Templates

#### Template A: 1 Word Focus (30s)
```
0:00-0:03  Hook: "Từ này 90% người Việt phát âm sai!"
0:03-0:08  Word + IPA + Pronunciation
0:08-0:15  Definition + Example
0:15-0:22  Common mistake
0:22-0:27  Correct usage
0:27-0:30  CTA + Next word preview
```

#### Template B: Quiz Format (45s)
```
0:00-0:03  Hook: "Test your TOEIC!"
0:03-0:10  Question + 4 options
0:10-0:15  Countdown: "3... 2... 1..."
0:15-0:20  Answer reveal
0:20-0:35  Explanation
0:35-0:40  Similar question preview
0:40-0:45  CTA
```

#### Template C: Confusing Pairs (60s)
```
0:00-0:03  Hook: "AFFECT vs EFFECT - Bạn phân biệt được không?"
0:03-0:15  Word 1: Definition + Example
0:15-0:27  Word 2: Definition + Example
0:27-0:40  Key difference + Memory tip
0:40-0:55  Quick quiz
0:55-0:60  CTA
```

### 2.3 Daily Production Target

| Time | Activity | Output |
|------|----------|--------|
| 6:00 AM | Auto-generate 10 shorts scripts | 10 scripts |
| 6:30 AM | Language tagging | 10 tagged scripts |
| 7:00 AM | Audio generation | 10 audio files |
| 8:00 AM | Video assembly | 10 videos |
| 9:00 AM | Quality check | 8-10 approved |
| 10:00 AM | Schedule upload | 5 for today, 5 for tomorrow |

---

## Phase 3: Automation Scripts (Week 3-4)

### 3.1 Daily Cron Job
```bash
#!/bin/bash
# /scripts/daily-production.sh

DATE=$(date +%Y-%m-%d)
OUTPUT_DIR="output/toeic-videos/${DATE}"

# Step 1: Generate content batch
claude --skill microai:toeic-content-session \
  --args "batch:10 type:shorts template:vocab-1word"

# Step 2: Quality check
claude --skill microai:quality-check \
  --args "dir:${OUTPUT_DIR}"

# Step 3: Schedule uploads
python3 scripts/youtube-scheduler.py \
  --videos "${OUTPUT_DIR}/*.mp4" \
  --schedule "optimal"
```

### 3.2 Content Rotation
```yaml
weekly_schedule:
  monday:
    - 3x vocab-verbs
    - 2x quiz
  tuesday:
    - 3x vocab-nouns
    - 2x confusing-pairs
  wednesday:
    - 3x vocab-adjectives
    - 2x grammar-tip
  thursday:
    - 3x collocations
    - 2x quiz
  friday:
    - 3x business-vocab
    - 2x confusing-pairs
  saturday:
    - 5x weekly-review
  sunday:
    - 5x preview-next-week
```

---

## Phase 4: Quality & Consistency (Ongoing)

### 4.1 Quality Checklist
- [ ] Audio clear, no glitches
- [ ] EN/VI voices correct
- [ ] Text readable on mobile
- [ ] Hook engaging
- [ ] Timing smooth
- [ ] CTA present
- [ ] Thumbnail attractive

### 4.2 A/B Testing
```yaml
test_variables:
  hooks:
    - "Từ này 90% người Việt sai!"
    - "TOEIC 900+ phải biết từ này"
    - "Đừng nhầm 2 từ này!"

  thumbnails:
    - big_word_only
    - word_with_meaning
    - quiz_style

  durations:
    - 30s
    - 45s
    - 60s
```

### 4.3 Analytics Tracking
```yaml
metrics:
  - views_per_short
  - watch_time_percentage
  - engagement_rate
  - subscriber_conversion
  - best_performing_topics
  - best_posting_times
```

---

## Content Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TOEIC SHORTS PRODUCTION PIPELINE                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐          │
│  │   DATABASE   │ -> │   PLANNER    │ -> │   SCRIPTS    │          │
│  │ 2000+ words  │    │ Daily batch  │    │ 10 shorts    │          │
│  └──────────────┘    └──────────────┘    └──────────────┘          │
│                                                 │                    │
│                                                 v                    │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐          │
│  │    VIDEO     │ <- │    AUDIO     │ <- │   TAGGER     │          │
│  │  10 shorts   │    │ EN/VI voice  │    │  lang tags   │          │
│  └──────────────┘    └──────────────┘    └──────────────┘          │
│         │                                                           │
│         v                                                           │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐          │
│  │     QC       │ -> │  THUMBNAIL   │ -> │   UPLOAD     │          │
│  │   8-10 OK    │    │  10 images   │    │  Scheduled   │          │
│  └──────────────┘    └──────────────┘    └──────────────┘          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Immediate Action Items

### Today
1. [x] Tạo Language Tagger Agent
2. [ ] Tạo TOEIC vocabulary database (500 words Phase 1)
3. [ ] Tạo Shorts template (30s vocab)
4. [ ] Test production 1 short

### This Week
5. [ ] Hoàn thiện 3 shorts templates
6. [ ] Tạo automation script
7. [ ] Produce 10 test shorts
8. [ ] Setup YouTube channel properly

### Next Week
9. [ ] Launch daily production
10. [ ] Monitor analytics
11. [ ] Optimize based on data

---

## Revenue Projection

| Month | Shorts/day | Total | Views (est) | Revenue (est) |
|-------|------------|-------|-------------|---------------|
| 1 | 5 | 150 | 50K | $5 |
| 2 | 10 | 300 | 500K | $50 |
| 3 | 10 | 300 | 2M | $200 |
| 6 | 10 | 300 | 5M | $500 |
| 12 | 10 | 300 | 10M+ | $1,000+ |

**Break-even**: ~Month 6 với 5M views
**Monetization eligible**: ~Month 3 với 10M Shorts views
