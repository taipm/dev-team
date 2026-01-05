# SEO Guidelines for TOEIC Content

> Knowledge file cho Quality Reviewer Agent
> Version: 1.0

---

## Overview

SEO (Search Engine Optimization) cho YouTube giúp video TOEIC reach đúng audience. Document này cover:
- YouTube algorithm factors
- Keyword research strategies
- Metadata optimization
- Thumbnail best practices
- Analytics và iteration

---

## YouTube Algorithm Factors

### Ranking Signals

```yaml
youtube_ranking_signals:
  primary_factors:
    watch_time:
      weight: "Very High"
      description: "Thời gian xem thực tế của viewers"
      goal: "Maximize retention"

    click_through_rate:
      weight: "High"
      description: "Tỷ lệ click từ impressions"
      goal: "3-10% CTR"

    engagement:
      weight: "High"
      signals:
        - likes
        - comments
        - shares
        - subscribers_gained

  secondary_factors:
    session_time:
      description: "Thời gian user ở lại YouTube sau video"
      impact: "Positive if high"

    upload_frequency:
      description: "Tần suất upload"
      recommendation: "Consistent schedule"

    channel_authority:
      description: "Overall channel performance"
      builds_over_time: true
```

### Shorts-Specific Factors

```yaml
shorts_algorithm:
  swipe_rate:
    description: "Bao nhiêu % viewers swipe away"
    goal: "<30% early swipes"

  loop_rate:
    description: "Bao nhiêu lần video được xem lại"
    goal: "High loop rate = quality content"

  full_watch_rate:
    description: "% viewers xem hết video"
    goal: ">70% full watch"

  engagement_rate:
    description: "Likes/comments per view"
    benchmark: ">5% engagement"
```

---

## Keyword Research

### TOEIC Keywords Categories

```yaml
keyword_categories:
  primary_keywords:
    - "TOEIC vocabulary"
    - "từ vựng TOEIC"
    - "học TOEIC"
    - "luyện thi TOEIC"
    - "TOEIC 2026"

  topic_keywords:
    business:
      - "TOEIC business vocabulary"
      - "từ vựng TOEIC kinh doanh"
      - "business English TOEIC"

    office:
      - "TOEIC office vocabulary"
      - "từ vựng văn phòng TOEIC"

    travel:
      - "TOEIC travel vocabulary"
      - "từ vựng du lịch TOEIC"

  part_specific:
    - "TOEIC Part 5 tips"
    - "TOEIC Part 7 reading"
    - "TOEIC Listening strategies"

  score_targets:
    - "TOEIC 600+"
    - "TOEIC 700+"
    - "TOEIC 800+"
    - "TOEIC 900+"
```

### Keyword Research Tools

```yaml
research_tools:
  free:
    - youtube_search_suggest: "Type partial query, see suggestions"
    - google_trends: "Compare keyword popularity"
    - tiktok_discover: "Trending hashtags"

  paid:
    - vidiq: "YouTube keyword tool"
    - tubebuddy: "SEO suggestions"
    - ahrefs: "Keyword difficulty"

  manual_research:
    - analyze_competitors: "What keywords are top TOEIC channels using?"
    - review_comments: "What questions do viewers ask?"
    - community_posts: "What content do followers want?"
```

### Keyword Selection Criteria

```yaml
keyword_selection:
  good_keyword:
    - search_volume: ">1000/month"
    - competition: "Low to Medium"
    - relevance: "Directly related to content"
    - intent: "Learning/educational"

  avoid:
    - too_broad: "English learning" (quá rộng)
    - too_narrow: "TOEIC 2026 negotiate business deal" (quá cụ thể)
    - no_volume: "TOEIC obscure term"
    - high_competition: "learn English" (quá cạnh tranh)
```

---

## Title Optimization

### Title Formula

```yaml
title_formulas:
  vocabulary_shorts:
    pattern: "[Hook] + [Keyword] + [Benefit/Promise]"
    examples:
      - "90% Sai! Từ TOEIC Này Bạn Đọc Như Nào? #toeic"
      - "Học 1 Từ TOEIC Trong 30s | negotiate #shorts"
      - "Từ Vựng TOEIC Hay Gặp Nhất | Part 5 #toeic2026"

  standard_videos:
    pattern: "[Topic] + [Value Proposition] + [Qualifier]"
    examples:
      - "10 Từ Vựng TOEIC Kinh Doanh Hay Gặp Nhất 2026"
      - "TOEIC Part 5: 5 Tips Tăng 50 Điểm Ngay"
      - "Luyện Listening TOEIC - 30 Câu Thực Tế"
```

### Title Guidelines

```yaml
title_guidelines:
  length:
    optimal: "40-60 characters"
    max_visible: "60 characters on mobile"
    max_total: 100

  structure:
    - front_load_keywords: true
    - include_numbers: "when applicable"
    - create_curiosity: true
    - avoid_clickbait: true

  power_words:
    urgency: ["Ngay", "Nhanh", "Chỉ"]
    value: ["Miễn Phí", "Bí Quyết", "Tips"]
    results: ["Tăng Điểm", "Đạt 800+", "Luyện Hiệu Quả"]
    curiosity: ["Sai Lầm", "Bất Ngờ", "Ít Ai Biết"]

  avoid:
    - all_caps: "DON'T DO THIS"
    - excessive_punctuation: "!!!???"
    - misleading_claims: "TOEIC 990 trong 1 tuần"
    - generic_titles: "Video TOEIC số 1"
```

---

## Description Optimization

### Description Template

```yaml
description_template:
  shorts:
    structure: |
      [Hook sentence with main keyword]

      📚 Từ vựng: {word}
      🔊 Phát âm: {IPA}
      ✨ Nghĩa: {meaning}

      #toeic #toeicvocabulary #hoctoeic #tuvungtoeic

      ---
      Follow để học TOEIC mỗi ngày! 🎯

    length: "150-300 characters"

  standard:
    structure: |
      [Opening hook - 1-2 sentences with main keyword]

      Trong video này, bạn sẽ học:
      ✅ {point 1}
      ✅ {point 2}
      ✅ {point 3}

      ⏱️ Timestamps:
      0:00 - Intro
      0:30 - {Topic 1}
      2:00 - {Topic 2}
      ...

      📚 Resources:
      - [Link to related content]
      - [Download vocabulary list]

      🔔 Đăng ký kênh để không bỏ lỡ video mới!

      #toeic #luyenthitoeic #toeic2026 #hoctienganhonline

      ---
      © {Year} {Channel Name}

    length: "500-1500 characters"
```

### Description Best Practices

```yaml
description_practices:
  first_150_chars:
    importance: "Shows in search results"
    content: "Main keyword + hook + value proposition"

  keywords:
    placement: "Natural integration, not stuffing"
    density: "2-4 main keywords"
    variations: "Include synonyms and related terms"

  links:
    type: "Related videos, playlists, resources"
    placement: "After main content"
    tracking: "Use UTM parameters for external links"

  call_to_action:
    placement: "End of description"
    actions: ["Subscribe", "Like", "Comment", "Share"]

  hashtags:
    quantity: "3-5 hashtags"
    placement: "End of description or after first paragraph"
    relevance: "Must be relevant to content"
```

---

## Tags Optimization

### Tag Strategy

```yaml
tag_strategy:
  primary_tags: # 3-5 tags
    - exact_match_keyword: "TOEIC vocabulary"
    - topic_keyword: "từ vựng TOEIC"
    - video_specific: "negotiate TOEIC"

  secondary_tags: # 5-10 tags
    - related_topics: "business English"
    - audience_targets: "TOEIC 700"
    - format_tags: "TOEIC shorts"

  long_tail_tags: # 5-10 tags
    - specific_phrases: "học từ vựng TOEIC mỗi ngày"
    - question_format: "làm sao tăng điểm TOEIC"
    - location: "TOEIC Vietnam"

  total_tags: "15-30 tags"
```

### Tag Best Practices

```yaml
tag_practices:
  do:
    - start_with_main_keyword: true
    - include_brand: "Channel name"
    - mix_broad_and_specific: true
    - use_both_languages: "English and Vietnamese"

  dont:
    - irrelevant_tags: "trending but unrelated"
    - competitor_names: "Potential violation"
    - excessive_tags: ">30 tags"
    - single_word_only: "Too broad"
```

### TOEIC Tag Library

```yaml
toeic_tag_library:
  core:
    - "TOEIC"
    - "TOEIC vocabulary"
    - "từ vựng TOEIC"
    - "học TOEIC"
    - "luyện thi TOEIC"
    - "TOEIC 2026"

  format:
    - "TOEIC shorts"
    - "TOEIC daily"
    - "học TOEIC mỗi ngày"
    - "1 phút TOEIC"

  topic:
    - "TOEIC business"
    - "TOEIC office"
    - "TOEIC travel"
    - "TOEIC Part 5"
    - "TOEIC Reading"
    - "TOEIC Listening"

  level:
    - "TOEIC beginner"
    - "TOEIC 600"
    - "TOEIC 700"
    - "TOEIC 800"
    - "TOEIC advanced"

  vietnamese:
    - "tiếng Anh giao tiếp"
    - "tiếng Anh công sở"
    - "học tiếng Anh online"
    - "tự học TOEIC"
```

---

## Thumbnail Optimization

### Thumbnail Design Rules

```yaml
thumbnail_design:
  technical:
    resolution: "1280x720"
    aspect_ratio: "16:9"
    format: "JPG or PNG"
    max_size: "2MB"

  visual_elements:
    face: "Human face increases CTR by 30%"
    emotion: "Clear, strong emotions"
    contrast: "High contrast for visibility"
    colors: "Bright, eye-catching"
    text: "3-5 words maximum"

  text_guidelines:
    font_size: "Large enough to read on mobile"
    font_weight: "Bold for readability"
    outline: "Add outline/shadow for contrast"
    keywords: "Include main keyword if possible"

  brand_consistency:
    color_scheme: "Use brand colors"
    logo_placement: "Optional, corner"
    style: "Consistent across series"
```

### Thumbnail A/B Testing

```yaml
thumbnail_testing:
  elements_to_test:
    - face_vs_no_face
    - text_vs_no_text
    - color_variations
    - expression_types
    - background_styles

  metrics:
    - click_through_rate: "Primary metric"
    - impressions: "Reach"
    - watch_time: "Quality indicator"

  sample_size: "Minimum 1000 impressions per variant"
```

---

## Hashtag Strategy

### Hashtag Guidelines

```yaml
hashtag_guidelines:
  shorts:
    required: ["#Shorts"]
    recommended:
      - "#toeic"
      - "#toeicvocabulary"
      - "#hoctoeic"
    quantity: "3-5 hashtags"

  standard:
    primary: ["#toeic", "#luyenthitoeic"]
    secondary: ["#toeic2026", "#tiengAnhonline"]
    quantity: "5-10 hashtags"

  placement:
    title: "1-2 hashtags at end"
    description: "All hashtags at end of description"

  avoid:
    - banned_hashtags: "Check for banned terms"
    - irrelevant_hashtags: "Must relate to content"
    - excessive_hashtags: ">15 hashtags"
```

### Trending Hashtags

```yaml
trending_research:
  check_frequency: "Weekly"
  sources:
    - youtube_trending: "Explore page"
    - tiktok_discover: "Cross-platform trends"
    - google_trends: "Search trends"

  adapt:
    - combine_trending_with_niche: true
    - maintain_relevance: true
    - avoid_controversial: true
```

---

## Analytics & Iteration

### Key Metrics to Track

```yaml
analytics_metrics:
  discovery:
    - impressions: "How often thumbnail shown"
    - ctr: "Click-through rate"
    - search_ranking: "Position for keywords"

  engagement:
    - watch_time: "Total minutes watched"
    - average_view_duration: "How long viewers stay"
    - likes_per_view: "Engagement rate"
    - comments_per_view: "Community engagement"

  growth:
    - subscribers_gained: "Per video"
    - shares: "Organic reach"
    - saves: "Value indicator"
```

### Optimization Cycle

```yaml
optimization_cycle:
  1_analyze:
    frequency: "Weekly"
    actions:
      - review_top_performing: "What worked?"
      - review_underperforming: "What didn't?"
      - identify_patterns: "Common factors"

  2_hypothesize:
    questions:
      - "Why did video X perform well?"
      - "What can we replicate?"
      - "What should we avoid?"

  3_test:
    approach:
      - change_one_variable: true
      - sufficient_sample_size: true
      - document_results: true

  4_implement:
    actions:
      - update_guidelines: true
      - share_learnings: true
      - iterate_continuously: true
```

---

## SEO Checklist

### Pre-Publish Checklist

```yaml
seo_checklist:
  title:
    - [ ] Contains main keyword
    - [ ] 40-60 characters
    - [ ] Engaging and clear
    - [ ] No clickbait

  description:
    - [ ] First 150 chars optimized
    - [ ] Keywords naturally included
    - [ ] Call to action present
    - [ ] Hashtags added

  tags:
    - [ ] Main keyword as first tag
    - [ ] 15-30 relevant tags
    - [ ] Mix of broad and specific
    - [ ] Both English and Vietnamese

  thumbnail:
    - [ ] 1280x720 resolution
    - [ ] Text readable on mobile
    - [ ] High contrast
    - [ ] Consistent branding

  metadata:
    - [ ] Category set correctly
    - [ ] Language set
    - [ ] Subtitles/CC enabled
    - [ ] Playlist assigned
```

---

## Content Calendar SEO

### Seasonal Keywords

```yaml
seasonal_keywords:
  january:
    - "TOEIC 2026"
    - "học TOEIC đầu năm"
    - "mục tiêu TOEIC"

  before_test_dates:
    - "ôn thi TOEIC gấp"
    - "tips TOEIC cuối cùng"
    - "TOEIC test prep"

  back_to_school:
    - "TOEIC sinh viên"
    - "luyện TOEIC mùa hè"

  year_end:
    - "tổng kết TOEIC"
    - "TOEIC thành tựu"
```

---

## Best Practices Summary

1. **Keyword First**: Luôn bắt đầu với keyword research
2. **Quality Over Quantity**: SEO tốt + content kém = không hiệu quả
3. **Consistency**: Upload đều đặn, maintain style
4. **Iterate**: Liên tục test và cải thiện
5. **User Intent**: Focus vào nhu cầu người học
6. **Algorithm Changes**: Theo dõi updates từ YouTube

---

*Last updated: 2026-01-04*
