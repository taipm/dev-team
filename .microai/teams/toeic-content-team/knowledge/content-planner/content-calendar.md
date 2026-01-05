# Content Calendar - Chiến lược Lập kế hoạch Nội dung

> Knowledge file cho Content Planner Agent
> Version: 1.0

---

## Nguyên tắc Lập lịch

### 1. Phân bổ Nội dung theo Tuần

```yaml
weekly_distribution:
  monday:
    type: vocabulary
    focus: business_verbs
    format: shorts
    count: 2

  tuesday:
    type: vocabulary
    focus: business_nouns
    format: shorts
    count: 2

  wednesday:
    type: grammar
    focus: common_mistakes
    format: shorts
    count: 2

  thursday:
    type: vocabulary
    focus: adjectives_adverbs
    format: shorts
    count: 2

  friday:
    type: vocabulary
    focus: collocations
    format: shorts
    count: 2

  saturday:
    type: listening
    focus: part3_conversations
    format: standard
    count: 1

  sunday:
    type: review
    focus: weekly_recap
    format: shorts
    count: 2
```

### 2. Content Mix Tối ưu

| Content Type | Tỷ lệ | Lý do |
|--------------|-------|-------|
| Vocabulary | 40% | High search volume, dễ sản xuất |
| Listening | 30% | Nhu cầu cao, khó hơn |
| Grammar | 30% | Evergreen content |

### 3. Posting Schedule Tối ưu

```yaml
optimal_posting_times:
  # Múi giờ Vietnam (GMT+7)
  weekdays:
    morning: "07:00-08:00"   # Commute time
    lunch: "12:00-13:00"     # Lunch break
    evening: "20:00-21:00"   # After work

  weekends:
    morning: "09:00-10:00"
    afternoon: "14:00-15:00"
    evening: "20:00-21:00"

shorts_frequency:
  minimum: 2_per_day
  optimal: 3_per_day
  maximum: 5_per_day

standard_frequency:
  minimum: 1_per_week
  optimal: 2_per_week
```

---

## Chiến lược Content Series

### Series 1: "1 Từ Mỗi Ngày" (Daily Vocabulary)

```yaml
series:
  name: "1 Từ Mỗi Ngày"
  format: shorts
  duration: 30s
  frequency: daily

  structure:
    - hook: "90% người Việt phát âm sai!"
    - word_intro: Word + IPA
    - definition: Vietnamese meaning
    - example: Context sentence
    - tip: Collocation/mnemonic
    - cta: "Follow để học mỗi ngày"

  topics_rotation:
    week_1: business_communication
    week_2: finance_banking
    week_3: office_workplace
    week_4: travel_hospitality
```

### Series 2: "Sai Lầm TOEIC" (Common Mistakes)

```yaml
series:
  name: "Sai Lầm TOEIC"
  format: shorts
  duration: 45s
  frequency: 3_per_week

  structure:
    - hook: "Bạn có mắc lỗi này?"
    - wrong_example: Common mistake
    - explanation: Why wrong
    - correct_example: Correct usage
    - rule: Grammar rule
    - cta: "Save để nhớ!"
```

### Series 3: "TOEIC Listening Tips"

```yaml
series:
  name: "TOEIC Listening Tips"
  format: standard
  duration: 3-5min
  frequency: 2_per_week

  structure:
    - intro: Part overview
    - strategy: Listening technique
    - practice: Sample questions
    - answer_analysis: Explanation
    - summary: Key takeaways
```

---

## Calendar Template

### Tháng Template

```markdown
# Content Calendar - Tháng {MM/YYYY}

## Tuần 1 ({date_range})

| Ngày | Type | Topic | Format | Status |
|------|------|-------|--------|--------|
| T2 | Vocab | negotiate | Shorts | [ ] |
| T2 | Vocab | deadline | Shorts | [ ] |
| T3 | Vocab | revenue | Shorts | [ ] |
| T3 | Vocab | expense | Shorts | [ ] |
| T4 | Grammar | Subject-Verb Agreement | Shorts | [ ] |
| T4 | Grammar | Tense Consistency | Shorts | [ ] |
| T5 | Vocab | implement | Shorts | [ ] |
| T5 | Vocab | strategy | Shorts | [ ] |
| T6 | Vocab | collaborate | Shorts | [ ] |
| T6 | Vocab | feedback | Shorts | [ ] |
| T7 | Listening | Part 3 - Office | Standard | [ ] |
| CN | Review | Week 1 Recap | Shorts | [ ] |

## Metrics Targets
- Total Videos: 12
- Shorts: 11
- Standard: 1
- Vocab: 8
- Grammar: 2
- Listening: 1
- Review: 1
```

---

## Quy trình Lập Calendar

### Step 1: Topic Research (Mỗi tuần)

```yaml
research_sources:
  - google_trends: "TOEIC vocabulary 2025"
  - youtube_search: "học TOEIC" (sort by view count)
  - competitor_analysis: Top 5 TOEIC channels
  - toeic_forums: Common questions
  - official_ets: New test updates
```

### Step 2: Content Gap Analysis

```yaml
gap_analysis:
  check:
    - topics_not_covered_yet
    - high_search_low_competition
    - seasonal_relevance
    - exam_date_proximity

  prioritize:
    - evergreen_first
    - trending_second
    - fill_gaps_third
```

### Step 3: Batch Planning

```yaml
batch_planning:
  weekly_batch:
    plan_on: sunday_evening
    produce_on: monday_to_friday
    review_on: saturday

  monthly_overview:
    theme: monthly_focus_topic
    series: ongoing_series_episodes
    specials: holiday_or_event_content
```

---

## KPIs và Tracking

### Content Performance Metrics

```yaml
metrics:
  per_video:
    - views_24h
    - views_7d
    - watch_time_percentage
    - engagement_rate
    - ctr_from_impressions

  per_series:
    - average_views
    - subscriber_gain
    - playlist_completion_rate

  monthly:
    - total_views
    - watch_hours
    - new_subscribers
    - revenue (if monetized)
```

### Adjustment Criteria

```yaml
content_adjustment:
  if_underperforming:
    - check_thumbnail_ctr
    - analyze_retention_drop_off
    - compare_with_top_performers
    - adjust_topic_or_format

  if_overperforming:
    - create_sequel_content
    - expand_into_series
    - cross_promote_related
```

---

## Best Practices

1. **Consistency > Quantity**: Đăng đều đặn hơn là đăng nhiều rồi nghỉ
2. **Batch Production**: Sản xuất theo batch để tiết kiệm thời gian
3. **Buffer Content**: Luôn có 3-5 videos dự phòng
4. **Seasonal Awareness**: Tăng content trước mùa thi TOEIC
5. **Audience Feedback**: Đọc comments để điều chỉnh content
