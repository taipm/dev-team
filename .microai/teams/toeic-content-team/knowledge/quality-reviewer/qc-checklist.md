# QC Checklist & Scoring Rubric

> Knowledge file cho Quality Reviewer Agent
> Version: 1.0

---

## Overview

Quality Control (QC) đảm bảo mỗi video TOEIC đạt tiêu chuẩn trước khi publish. Document này định nghĩa:
- Checklist kiểm tra cho từng video
- Rubric chấm điểm chi tiết
- Ngưỡng pass/fail
- Quy trình xử lý lỗi

---

## QC Checklist

### 1. Content Accuracy (Độ chính xác nội dung)

```yaml
content_accuracy:
  vocabulary:
    - word_spelling_correct: true
    - ipa_transcription_accurate: true
    - part_of_speech_correct: true
    - meaning_vietnamese_accurate: true
    - meaning_english_accurate: true

  examples:
    - example_sentence_grammatically_correct: true
    - example_uses_target_word_correctly: true
    - translation_accurate: true

  tips:
    - collocation_valid: true
    - usage_tip_helpful: true
    - toeic_relevance_clear: true
```

### 2. Audio Quality (Chất lượng âm thanh)

```yaml
audio_quality:
  technical:
    - no_clipping: "peak < 0dB"
    - loudness_normalized: "-16 to -12 LUFS"
    - no_background_noise: true
    - no_distortion: true
    - sample_rate: "44100Hz"

  pronunciation:
    - english_pronunciation_clear: true
    - ipa_matches_audio: true
    - vietnamese_diacritics_correct: true

  pacing:
    - natural_speaking_rate: true
    - appropriate_pauses: true
    - no_awkward_gaps: true

  sync:
    - audio_matches_visuals: true
    - timing_accurate: "within 200ms"
```

### 3. Visual Quality (Chất lượng hình ảnh)

```yaml
visual_quality:
  technical:
    - resolution_correct: "1080x1920 (shorts) or 1920x1080 (standard)"
    - aspect_ratio_maintained: true
    - no_pixelation: true
    - colors_accurate: true

  text_readability:
    - font_size_adequate: "min 28px for mobile"
    - contrast_ratio: "min 4.5:1"
    - vietnamese_diacritics_display: true
    - no_text_cutoff: true

  design_consistency:
    - follows_brand_colors: true
    - template_used_correctly: true
    - animations_smooth: true
    - transitions_natural: true

  layout:
    - content_within_safe_zone: "90% of frame"
    - elements_properly_aligned: true
    - no_overlapping_elements: true
```

### 4. Video Technical (Kỹ thuật video)

```yaml
video_technical:
  format:
    - codec: "H.264"
    - container: "MP4"
    - profile: "High"
    - fps: "30"

  duration:
    - shorts: "15-60s"
    - standard: "120-600s"

  file_size:
    - shorts: "<10MB"
    - standard: "<50MB"

  playback:
    - no_frame_drops: true
    - smooth_playback: true
    - proper_seeking: true
```

### 5. Metadata Quality (Chất lượng metadata)

```yaml
metadata_quality:
  title:
    - includes_keyword: true
    - length: "40-70 characters"
    - engaging: true
    - no_clickbait: true

  description:
    - keyword_rich: true
    - includes_timestamps: "optional"
    - call_to_action: true
    - links_valid: true

  tags:
    - relevant_to_content: true
    - includes_main_keyword: true
    - quantity: "5-15 tags"

  thumbnail:
    - resolution: "1280x720 (standard) or 1080x1920 (shorts)"
    - text_readable: true
    - visually_appealing: true
```

---

## Scoring Rubric

### Category Weights

```yaml
scoring_weights:
  content_accuracy: 30%
  audio_quality: 25%
  visual_quality: 20%
  video_technical: 15%
  metadata_quality: 10%

  total: 100%
```

### Scoring Scale

```yaml
scoring_scale:
  excellent: 90-100
  good: 75-89
  acceptable: 60-74
  needs_improvement: 40-59
  fail: 0-39

  pass_threshold: 70
  publish_threshold: 75
```

### Detailed Rubric

#### Content Accuracy (30 points)

```yaml
content_accuracy_rubric:
  vocabulary_correctness: # 15 points
    excellent: 15    # All fields accurate, verified with dictionary
    good: 12         # Minor issues, all essential info correct
    acceptable: 9    # Some inaccuracies, core meaning correct
    poor: 5          # Significant errors
    fail: 0          # Major errors, misleading content

  example_quality: # 10 points
    excellent: 10    # Natural, contextual, helpful examples
    good: 8          # Good examples with minor issues
    acceptable: 6    # Basic examples, could be better
    poor: 3          # Awkward or unclear examples
    fail: 0          # Incorrect or no examples

  tip_relevance: # 5 points
    excellent: 5     # Highly useful, TOEIC-specific tips
    good: 4          # Good tips
    acceptable: 3    # Basic tips
    poor: 1          # Weak or generic tips
    fail: 0          # No tips or irrelevant
```

#### Audio Quality (25 points)

```yaml
audio_quality_rubric:
  technical_quality: # 10 points
    excellent: 10    # Crystal clear, broadcast quality
    good: 8          # Good quality, minor issues
    acceptable: 6    # Acceptable, some noise/issues
    poor: 3          # Noticeable problems
    fail: 0          # Unlistenable

  pronunciation: # 10 points
    excellent: 10    # Native-like, clear pronunciation
    good: 8          # Clear, minor accent issues
    acceptable: 6    # Understandable but not ideal
    poor: 3          # Difficult to understand
    fail: 0          # Incorrect pronunciation

  sync_and_pacing: # 5 points
    excellent: 5     # Perfect sync, natural pacing
    good: 4          # Good sync, minor timing issues
    acceptable: 3    # Acceptable sync
    poor: 1          # Noticeable sync problems
    fail: 0          # Severe desync
```

#### Visual Quality (20 points)

```yaml
visual_quality_rubric:
  design_quality: # 10 points
    excellent: 10    # Professional, engaging design
    good: 8          # Good design, follows guidelines
    acceptable: 6    # Basic but functional design
    poor: 3          # Poor design choices
    fail: 0          # Unprofessional or unreadable

  technical_quality: # 5 points
    excellent: 5     # Perfect resolution, colors
    good: 4          # Good quality
    acceptable: 3    # Minor issues
    poor: 1          # Noticeable problems
    fail: 0          # Major technical issues

  readability: # 5 points
    excellent: 5     # Easy to read on all devices
    good: 4          # Good readability
    acceptable: 3    # Readable but could improve
    poor: 1          # Difficult to read
    fail: 0          # Unreadable
```

#### Video Technical (15 points)

```yaml
video_technical_rubric:
  format_compliance: # 10 points
    excellent: 10    # All specs met perfectly
    good: 8          # Minor deviations
    acceptable: 6    # Within tolerance
    poor: 3          # Significant deviations
    fail: 0          # Does not meet specs

  playback_quality: # 5 points
    excellent: 5     # Smooth, no issues
    good: 4          # Minor issues
    acceptable: 3    # Some stuttering
    poor: 1          # Frequent issues
    fail: 0          # Unplayable
```

#### Metadata Quality (10 points)

```yaml
metadata_quality_rubric:
  seo_optimization: # 5 points
    excellent: 5     # SEO-optimized, keyword-rich
    good: 4          # Good SEO
    acceptable: 3    # Basic SEO
    poor: 1          # Weak SEO
    fail: 0          # No SEO effort

  completeness: # 5 points
    excellent: 5     # All fields complete, high quality
    good: 4          # Most fields complete
    acceptable: 3    # Basic fields complete
    poor: 1          # Missing important fields
    fail: 0          # Incomplete metadata
```

---

## QC Process

### Pre-Review Checklist

```yaml
pre_review:
  automated_checks:
    - file_exists: true
    - file_format_valid: true
    - duration_within_limits: true
    - resolution_correct: true
    - audio_present: true

  tools_required:
    - ffprobe: "video/audio analysis"
    - mediainfo: "detailed specs"
    - loudness_scanner: "LUFS measurement"
```

### Review Workflow

```yaml
review_workflow:
  1_automated_scan:
    duration: "1-2 minutes"
    checks:
      - technical_specs
      - file_integrity
      - basic_validation

  2_content_review:
    duration: "3-5 minutes"
    checks:
      - vocabulary_accuracy
      - example_quality
      - tip_relevance

  3_av_review:
    duration: "2-3 minutes"
    checks:
      - audio_quality
      - visual_quality
      - sync_verification

  4_metadata_review:
    duration: "1-2 minutes"
    checks:
      - title_description
      - tags
      - thumbnail

  5_final_assessment:
    duration: "1 minute"
    actions:
      - calculate_score
      - make_decision
      - document_issues
```

---

## Decision Matrix

### Pass/Fail Criteria

```yaml
decision_matrix:
  auto_pass:
    score: ">=85"
    conditions:
      - no_critical_issues: true
      - all_categories_above: 60
    action: "Approve for publish"

  conditional_pass:
    score: "70-84"
    conditions:
      - no_critical_issues: true
      - content_accuracy_above: 70
    action: "Approve with notes"

  revision_required:
    score: "50-69"
    conditions:
      - fixable_issues: true
    action: "Return for revision"

  fail:
    score: "<50"
    conditions:
      - or:
        - critical_issues: true
        - content_accuracy_below: 50
    action: "Reject, require remake"
```

### Critical Issues (Auto-Fail)

```yaml
critical_issues:
  - incorrect_word_spelling
  - wrong_ipa_transcription
  - major_pronunciation_error
  - audio_completely_desynced
  - unreadable_text
  - video_corrupted
  - copyright_violation
  - offensive_content
```

---

## QC Report Template

```yaml
qc_report:
  header:
    video_id: "{session_id}"
    reviewer: "Quality Reviewer Agent"
    date: "{review_date}"
    review_duration: "{minutes}"

  scores:
    content_accuracy:
      score: X/30
      notes: ""
    audio_quality:
      score: X/25
      notes: ""
    visual_quality:
      score: X/20
      notes: ""
    video_technical:
      score: X/15
      notes: ""
    metadata_quality:
      score: X/10
      notes: ""

  total_score: X/100

  decision: "Pass|Conditional Pass|Revision Required|Fail"

  issues:
    critical: []
    major: []
    minor: []

  recommendations: []

  approval:
    status: "Approved|Rejected|Pending"
    conditions: []
```

---

## Automated QC Script

```bash
#!/bin/bash
# qc-auto.sh - Automated QC checks

VIDEO="$1"
REPORT="qc-report.json"

echo "=== Automated QC Check ==="

# Technical checks
RESOLUTION=$(ffprobe -v quiet -show_entries stream=width,height -of csv=p=0 "$VIDEO" | head -1)
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$VIDEO")
CODEC=$(ffprobe -v quiet -show_entries stream=codec_name -of csv=p=0 "$VIDEO" | head -1)
FPS=$(ffprobe -v quiet -show_entries stream=r_frame_rate -of csv=p=0 "$VIDEO" | head -1)
FILE_SIZE=$(stat -f%z "$VIDEO" 2>/dev/null || stat -c%s "$VIDEO")
FILE_SIZE_MB=$((FILE_SIZE / 1048576))

# Audio checks
LOUDNESS=$(ffmpeg -i "$VIDEO" -af loudnorm=print_format=json -f null - 2>&1 | grep -A5 "input_i" | head -2 | tail -1 | tr -d '", ')

# Output results
cat > "$REPORT" << EOF
{
  "video": "$VIDEO",
  "technical": {
    "resolution": "$RESOLUTION",
    "duration_seconds": $DURATION,
    "codec": "$CODEC",
    "fps": "$FPS",
    "file_size_mb": $FILE_SIZE_MB
  },
  "audio": {
    "loudness_lufs": $LOUDNESS
  },
  "checks": {
    "resolution_ok": $([ "$RESOLUTION" = "1080,1920" ] && echo "true" || echo "false"),
    "duration_ok": $(echo "$DURATION > 15 && $DURATION < 65" | bc),
    "size_ok": $([ $FILE_SIZE_MB -lt 10 ] && echo "true" || echo "false")
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

echo "QC report saved to $REPORT"
cat "$REPORT"
```

---

## Best Practices

1. **Review Completely**: Xem toàn bộ video, không skip
2. **Be Consistent**: Áp dụng tiêu chuẩn như nhau cho tất cả videos
3. **Document Everything**: Ghi chú mọi issues, dù nhỏ
4. **Prioritize Learning**: Focus vào content accuracy trước tiên
5. **User Perspective**: Đánh giá từ góc độ người học TOEIC
6. **Actionable Feedback**: Nếu reject, cho feedback cụ thể để fix

---

*Last updated: 2026-01-04*
