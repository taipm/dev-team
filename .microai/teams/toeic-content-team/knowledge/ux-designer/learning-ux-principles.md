# Learning UX Principles

> Nguyên tắc thiết kế trải nghiệm học tập cho video TOEIC

---

## 1. Cognitive Load Theory

### Nguyên tắc Cốt lõi

```yaml
cognitive_load_types:
  intrinsic:
    definition: "Độ phức tạp vốn có của nội dung"
    management:
      - Chia nhỏ concepts phức tạp
      - Xây dựng từ đơn giản đến phức tạp
      - Sử dụng analogies quen thuộc

  extraneous:
    definition: "Load không cần thiết từ design kém"
    reduction:
      - Loại bỏ visual clutter
      - Tránh animations không có mục đích
      - Giữ layout nhất quán

  germane:
    definition: "Load hữu ích cho việc học"
    optimization:
      - Kết nối kiến thức mới với cũ
      - Sử dụng examples thực tế
      - Khuyến khích active processing
```

### Áp dụng cho Video TOEIC

| Principle | Shorts (30-60s) | Standard (3-10min) |
|-----------|-----------------|---------------------|
| Concepts per video | 1 | 3-5 |
| Info per slide | 1-2 items | 3-5 items |
| New vocab per video | 1-3 words | 5-10 words |
| Examples per concept | 1 | 2-3 |

---

## 2. Chunking & Spacing

### Chunking Rules

```yaml
chunking:
  definition: "Nhóm thông tin thành units dễ nhớ"

  video_structure:
    shorts:
      chunks: 3-4
      duration_each: 10-15s
      pattern: "Hook → Content → Takeaway → CTA"

    standard:
      chunks: 5-7
      duration_each: 60-90s
      pattern: "Hook → Context → Chunk1 → Chunk2 → ... → Summary → CTA"

  visual_chunking:
    - Sử dụng whitespace để phân tách
    - Màu khác nhau cho different chunks
    - Transitions rõ ràng giữa sections
```

### Spacing Effect

```yaml
spacing:
  definition: "Lặp lại theo intervals tăng dần"

  application:
    within_video:
      - Preview key point ở đầu
      - Present chi tiết ở giữa
      - Review ở cuối

    across_videos:
      - Vocabulary: Lặp lại sau 1, 3, 7, 14 ngày
      - Grammar: Lặp lại trong different contexts
      - Listening: Progressive difficulty
```

---

## 3. Dual Coding Theory

### Visual + Verbal Integration

```yaml
dual_coding:
  principle: "Kết hợp visual và verbal tăng retention"

  implementation:
    synchronization:
      - Text xuất hiện khi được nói
      - Highlight từ đang được giải thích
      - Icon/image accompany abstract concepts

    redundancy_principle:
      do:
        - Visuals bổ sung cho narration
        - Diagrams giải thích relationships
      avoid:
        - Đọc nguyên văn text trên màn hình
        - Visuals duplicate narration 100%

  for_toeic:
    vocabulary:
      visual: Word card + image/icon
      verbal: Pronunciation + definition + example

    grammar:
      visual: Sentence diagram/highlight
      verbal: Rule explanation + examples

    listening:
      visual: Context image + keywords
      verbal: Audio clip + explanation
```

---

## 4. Attention & Engagement

### First 5 Seconds Rule

```yaml
attention_hooks:
  critical_window: "0-5 seconds quyết định viewer ở lại"

  effective_hooks:
    question:
      example: "Bạn có biết từ này 90% người Việt phát âm sai?"
      why_works: "Triggers curiosity, personal relevance"

    problem:
      example: "Struggling with TOEIC Part 5? Here's why..."
      why_works: "Identifies pain point immediately"

    promise:
      example: "In 30 seconds, you'll never confuse these again"
      why_works: "Clear value proposition, time commitment"

    surprise:
      example: "This common word actually means something else..."
      why_works: "Pattern interrupt, challenges assumptions"

  avoid:
    - Long intros/logos
    - "Hey everyone, welcome back..."
    - Asking to subscribe before value
```

### Retention Strategies

```yaml
retention_boosters:
  progress_indicators:
    - "1/3 qua rồi..."
    - Visual progress bar
    - "Almost done, one more tip"

  open_loops:
    - "Stay for the bonus tip at the end"
    - "The third example will surprise you"
    - Preview upcoming content

  active_engagement:
    - "Pause and try to answer"
    - "Comment your answer below"
    - "Can you spot the mistake?"

  emotional_connection:
    - Relatable scenarios
    - Humor khi phù hợp
    - Success stories
```

---

## 5. Mobile-First Design

### Mobile Viewing Context

```yaml
mobile_context:
  viewing_conditions:
    - Small screen (5-7 inches)
    - Often without headphones
    - Distracted environment
    - Vertical orientation for Shorts

  design_implications:
    text:
      minimum_size: 48px
      contrast_ratio: "4.5:1 minimum"
      words_per_line: 3-5 (Shorts), 5-7 (Standard)

    visuals:
      safe_zone: 10% margins
      focal_point: Center of screen
      avoid: Fine details, small icons

    audio:
      clear_voice: Essential
      background_music: Subtle, not distracting
      captions: Always available
```

### Touch-Friendly Considerations

```yaml
touch_interactions:
  tap_targets:
    minimum_size: 44x44px
    spacing: 8px between targets

  gestures:
    scroll: Content flows vertically
    tap: Pause/play
    swipe: Next/previous (platform specific)
```

---

## 6. Learning Progression

### Scaffolding

```yaml
scaffolding:
  definition: "Hỗ trợ giảm dần khi learner tiến bộ"

  levels:
    beginner:
      support: Maximum
      features:
        - Full explanations
        - Vietnamese translations
        - Slow pronunciation
        - Multiple examples

    intermediate:
      support: Moderate
      features:
        - Key points only
        - Mixed EN/VI
        - Normal speed
        - Fewer examples

    advanced:
      support: Minimal
      features:
        - English only
        - Fast/natural speed
        - Challenge questions
        - Edge cases
```

### Difficulty Progression

```yaml
difficulty_curve:
  within_video:
    pattern: "Easy → Medium → Slightly challenging"
    purpose: "Build confidence, end with growth"

  across_series:
    week_1: Fundamentals
    week_2: Core concepts
    week_3: Application
    week_4: Challenges

  content_types:
    vocabulary:
      easy: Common words, clear contexts
      medium: Business vocab, multiple meanings
      hard: Idioms, collocations, nuances

    listening:
      easy: Clear speech, simple sentences
      medium: Natural speed, some noise
      hard: Accents, fast speech, inference

    grammar:
      easy: Basic rules, common patterns
      medium: Exceptions, combinations
      hard: Subtle differences, style choices
```

---

## 7. Feedback & Reinforcement

### Immediate Feedback

```yaml
feedback_principles:
  timing:
    immediate: Show correct answer right away
    explanation: Why right/wrong
    next_step: What to remember

  tone:
    correct: Encouraging but not over-the-top
    incorrect: Supportive, focus on learning
    avoid: Shame, frustration, criticism

  visual_feedback:
    correct: Green highlight, checkmark
    incorrect: Red (briefly), show correct
    progress: Points, streaks, levels
```

### Reinforcement Patterns

```yaml
reinforcement:
  within_video:
    - Repeat key points 3 times
    - Summary at end
    - "Remember..." prompts

  across_videos:
    - Reference previous lessons
    - Build on learned concepts
    - Review series periodically

  external:
    - Encourage practice
    - Suggest real-world application
    - Connect to TOEIC exam format
```

---

## 8. Accessibility

### Visual Accessibility

```yaml
visual_accessibility:
  color:
    contrast_ratio: "4.5:1 minimum (WCAG AA)"
    color_blind_safe: Avoid red-green only distinctions
    meaning_not_color_only: Use shapes/text as well

  text:
    font_size: 48px minimum
    font_weight: 400+ for body, 700 for headings
    line_height: 1.4-1.6
    letter_spacing: Normal to slightly increased

  motion:
    reduced_motion_option: Minimize animations
    no_flashing: Avoid strobe effects
    smooth_transitions: Ease-in-out
```

### Cognitive Accessibility

```yaml
cognitive_accessibility:
  language:
    simple_words: Avoid jargon unless teaching it
    short_sentences: 10-15 words max
    clear_structure: Obvious organization

  pacing:
    breathing_room: Pauses between concepts
    no_rush: Time to process
    repeat_key_points: Multiple exposures

  predictability:
    consistent_layout: Same patterns each video
    clear_navigation: Know where you are
    expected_behavior: No surprises
```

---

## 9. Measurement & Iteration

### Key Metrics for Learning UX

```yaml
metrics:
  engagement:
    watch_time: How long they stay
    retention_curve: Where they drop off
    re_watch_rate: Sections viewed again

  learning_indicators:
    completion_rate: Finished the video
    saves_rate: Saved for later reference
    comment_quality: Questions, answers, discussions

  behavior:
    subscription_after: Converted to subscriber
    return_rate: Came back for more
    series_completion: Finished a playlist
```

### Continuous Improvement

```yaml
improvement_cycle:
  measure:
    - Collect analytics weekly
    - Monitor comments/feedback
    - Track A/B test results

  analyze:
    - Identify patterns
    - Compare to benchmarks
    - Find outliers (good and bad)

  hypothesize:
    - Why did X perform well/poorly?
    - What change might improve Y?
    - What should we test next?

  test:
    - Run controlled A/B tests
    - Small sample first
    - Clear success criteria

  implement:
    - Roll out winners
    - Document learnings
    - Update guidelines
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│  LEARNING UX CHECKLIST                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  COGNITIVE LOAD                                                  │
│  □ One main concept per Shorts                                  │
│  □ 3-5 items max per slide                                      │
│  □ Simple language, clear structure                             │
│                                                                  │
│  ATTENTION                                                       │
│  □ Hook in first 5 seconds                                      │
│  □ Progress indicators throughout                               │
│  □ Open loops to maintain interest                              │
│                                                                  │
│  DUAL CODING                                                     │
│  □ Visuals support (not duplicate) audio                        │
│  □ Text appears when spoken                                     │
│  □ Icons/images for abstract concepts                           │
│                                                                  │
│  MOBILE-FIRST                                                    │
│  □ Text 48px+ readable                                          │
│  □ Safe zones respected                                         │
│  □ Works without sound (captions)                               │
│                                                                  │
│  ACCESSIBILITY                                                   │
│  □ Color contrast 4.5:1+                                        │
│  □ Not color-only meaning                                       │
│  □ Clear, simple language                                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

*"The best learning experience is one you don't notice - you're just learning."*
