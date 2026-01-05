# Accessibility Guidelines

> Hướng dẫn thiết kế video TOEIC cho mọi đối tượng người học

---

## 1. Tại sao Accessibility Quan trọng

### Đối tượng Người học TOEIC

```yaml
audience_considerations:
  age_range:
    - Học sinh THPT (16-18)
    - Sinh viên (18-24)
    - Người đi làm (25-45)
    - Người lớn tuổi học lại (45+)

  abilities:
    - Thị lực: Cận thị, loạn thị, mù màu
    - Thính lực: Giảm thính lực, môi trường ồn
    - Nhận thức: ADHD, dyslexia, học chậm
    - Ngôn ngữ: ESL speakers, different levels

  contexts:
    - Xem trên điện thoại nhỏ
    - Xem trong nơi công cộng (không có tai nghe)
    - Xem trong điều kiện ánh sáng yếu
    - Multitasking (học trong lúc làm việc khác)
```

### Lợi ích của Accessible Design

```yaml
benefits:
  reach:
    - 15-20% người có disabilities
    - 100% benefit từ good design
    - Mở rộng potential audience

  engagement:
    - Easier to consume = longer watch time
    - Less cognitive load = better retention
    - Clear design = higher completion

  seo:
    - Captions improve searchability
    - Alt text helps discovery
    - Transcripts = more content indexed
```

---

## 2. Visual Accessibility

### Color Contrast

```yaml
contrast_requirements:
  wcag_aa_standard:
    normal_text: "4.5:1 minimum"
    large_text: "3:1 minimum (>24px bold or >18.5px)"
    ui_components: "3:1 minimum"

  recommended_for_video:
    text_on_background: "5:1 or higher"
    rationale: "Videos compressed, viewed on various screens"

  testing_tools:
    - WebAIM Contrast Checker
    - Colour Contrast Analyser
    - Figma accessibility plugins
```

### Color Palette (Accessible)

```yaml
accessible_colors:
  high_contrast_pairs:
    - background: "#1A1A2E"  # Dark blue
      text: "#FFFFFF"        # White
      contrast: "15.5:1"

    - background: "#F8F9FA"  # Light gray
      text: "#1A1A2E"        # Dark blue
      contrast: "14.2:1"

    - background: "#1A1A2E"  # Dark blue
      text: "#4ECDC4"        # Teal
      contrast: "8.2:1"

  accent_colors_accessible:
    success: "#2ECC71"  # Green (not pure green)
    warning: "#F1C40F"  # Yellow-gold
    error: "#E74C3C"    # Red-orange
    info: "#3498DB"     # Blue

  avoid:
    - Pure red (#FF0000) on dark backgrounds
    - Light yellow on white
    - Blue on purple
    - Green on red (color blindness)
```

### Color Blindness Considerations

```yaml
color_blindness:
  types:
    deuteranopia: "Red-green (most common, 6% of males)"
    protanopia: "Red-green (1% of males)"
    tritanopia: "Blue-yellow (rare)"

  safe_practices:
    - Never use color alone to convey meaning
    - Add icons, patterns, or text labels
    - Test with color blindness simulators
    - Use high contrast regardless of hue

  toeic_application:
    correct_answer:
      not_just: Green color
      also: Checkmark icon + "Correct" text

    incorrect_answer:
      not_just: Red color
      also: X icon + "Incorrect" text

    highlighting:
      not_just: Yellow highlight
      also: Underline + Bold
```

### Typography

```yaml
typography_accessibility:
  font_selection:
    recommended:
      - Inter (sans-serif, excellent readability)
      - Roboto (clean, versatile)
      - Open Sans (friendly, accessible)

    avoid:
      - Decorative fonts
      - Very thin weights (<400)
      - All caps for long text
      - Script/handwriting fonts

  sizing:
    video_text:
      shorts_minimum: 48px
      standard_minimum: 36px
      shorts_heading: 72px
      standard_heading: 64px

    caption_text:
      minimum: 32px
      recommended: 40-48px

  spacing:
    line_height: "1.4-1.6 (140-160%)"
    letter_spacing: "Normal to +2%"
    word_spacing: "Normal"

  contrast:
    text_on_solid: "4.5:1 minimum"
    text_on_image: "Add semi-transparent background"
```

### Visual Hierarchy

```yaml
hierarchy_principles:
  clear_structure:
    - One focal point per slide
    - Obvious reading order (top to bottom, left to right)
    - Consistent layout across slides

  grouping:
    - Related items visually grouped
    - Whitespace separates sections
    - Proximity indicates relationship

  emphasis:
    primary: Largest, highest contrast
    secondary: Slightly smaller, still readable
    tertiary: Smallest, supplementary info

  toeic_application:
    vocabulary_card:
      primary: "The word (72px, white)"
      secondary: "IPA pronunciation (48px, teal)"
      tertiary: "Definition (36px, gray)"
```

---

## 3. Audio Accessibility

### Voice Clarity

```yaml
voice_requirements:
  technical:
    sample_rate: "44.1kHz or 48kHz"
    bit_depth: "16-bit minimum"
    format: "AAC or MP3 192kbps+"

  production:
    noise_floor: "<-60dB"
    consistent_volume: "Normalized to -16 LUFS"
    no_clipping: "Peak below -1dB"

  speaking:
    pace: "120-150 words per minute"
    articulation: "Clear pronunciation"
    pauses: "After key points"
```

### Background Audio

```yaml
background_audio:
  music:
    volume: "-20dB below voice (or lower)"
    type: "Non-distracting, no lyrics"
    purpose: "Mood setting only"

  sound_effects:
    volume: "Brief, not startling"
    purpose: "Reinforce transitions, not distract"
    accessibility: "Not essential to understanding"
```

### Captions (Critical)

```yaml
captions:
  importance: "Essential for deaf/HoH viewers AND many others"

  who_uses:
    - Deaf and hard of hearing viewers
    - Non-native English speakers
    - Viewers in noisy environments
    - Viewers in quiet environments (no audio)
    - Better comprehension for all

  requirements:
    accuracy: ">99% word accuracy"
    timing: "Synced within 0.5 seconds"
    readability: "2 lines max, 42 chars/line"
    duration: "Minimum 1 second, maximum 7 seconds"

  styling:
    font: "Sans-serif, bold"
    size: "32-48px depending on video size"
    background: "Semi-transparent black (80%)"
    color: "White text"
    position: "Bottom center, above safe zone"

  best_practices:
    - Include speaker identification if multiple
    - Describe relevant sounds [upbeat music]
    - Break at natural speech pauses
    - Match reading speed to speech
```

---

## 4. Cognitive Accessibility

### Information Density

```yaml
cognitive_load:
  items_per_slide:
    shorts: "1-2 items"
    standard: "3-5 items"
    never: "More than 7 items"

  words_per_slide:
    shorts: "Max 15 words"
    standard: "Max 30 words"

  concepts_per_video:
    shorts: "1 concept"
    standard: "3-5 concepts"

  pacing:
    shorts: "1 concept per 10-15 seconds"
    standard: "1 concept per 30-60 seconds"
    pause_after_key_points: "1-2 seconds"
```

### Clear Structure

```yaml
structure_clarity:
  predictable_patterns:
    - Same intro format every video
    - Consistent section transitions
    - Expected CTA placement

  signposting:
    - "First, we'll cover..."
    - "Now let's look at..."
    - "Finally, remember..."

  visual_structure:
    - Section headers
    - Numbered lists when sequential
    - Progress indicators

  chunking:
    - Group related information
    - Clear boundaries between sections
    - Summary after complex parts
```

### Attention Support

```yaml
attention_support:
  for_adhd_viewers:
    - Keep videos short (Shorts preferred)
    - High visual variety
    - Frequent changes (every 5-10 seconds)
    - Clear, immediate value

  for_all_viewers:
    - No unnecessary filler
    - Get to point quickly
    - Visual reinforcement of audio
    - Engaging, not boring

  avoid:
    - Long intros
    - Repetitive content
    - Slow pacing
    - Monotone delivery
```

### Reading Accessibility

```yaml
reading_accessibility:
  dyslexia_friendly:
    fonts:
      good: "OpenDyslexic, Lexie Readable, sans-serif"
      avoid: "Serif, decorative, condensed"

    text:
      - Avoid justified text
      - Use left-aligned
      - Adequate line spacing (1.5+)
      - Avoid italics for long text

    colors:
      - Off-white backgrounds (reduce glare)
      - Not pure black on pure white
      - Muted, warm tones

  general_readability:
    - Short sentences
    - Simple words
    - One idea per sentence
    - Active voice
```

---

## 5. Motor Accessibility

### Video Controls

```yaml
video_controls:
  youtube_native:
    - Keyboard accessible (space, arrows)
    - Touch targets adequate size
    - Captions toggle available

  our_responsibility:
    - Not require precise interactions
    - Content works at any playback speed
    - Chaptered for easy navigation
```

---

## 6. Language Accessibility

### For Non-Native Speakers

```yaml
language_accessibility:
  vocabulary:
    - Use common words when possible
    - Explain jargon/technical terms
    - Repeat key terms with definition

  speech:
    - Clear articulation
    - Moderate pace
    - Pause after new vocabulary

  visual_support:
    - Text reinforces audio
    - Images clarify meaning
    - Examples provide context

  toeic_specific:
    - Vietnamese explanations for complex concepts
    - English for TOEIC vocabulary
    - IPA pronunciation guides
```

### Bilingual Best Practices

```yaml
bilingual_design:
  language_switching:
    - Clear transition signals
    - Consistent use (EN for content, VI for explanation)
    - Visual cues for language change

  text_display:
    english:
      - Larger, primary position
      - Clear pronunciation

    vietnamese:
      - Supporting, secondary position
      - Translation/explanation role

  audio:
    - Different voices for EN/VI
    - Consistent voice per language
    - Clear, professional pronunciation
```

---

## 7. Technical Accessibility

### Video Quality

```yaml
video_technical:
  resolution:
    minimum: "1080p (1920x1080 or 1080x1920)"
    recommended: "4K ready (future-proof)"

  compression:
    balance: "Quality vs file size"
    avoid: "Visible artifacts on text"

  frame_rate:
    standard: "30fps"
    avoid: "Inconsistent frame rates"
```

### File Size Optimization

```yaml
optimization:
  for_slow_connections:
    - YouTube handles adaptive bitrate
    - Ensure works at 480p
    - Text remains readable at lower quality

  mobile_data:
    - Shorter videos = less data
    - Consider summary versions
```

---

## 8. Accessibility Checklist

### Pre-Production

```yaml
pre_production_checklist:
  script:
    - [ ] Clear, simple language
    - [ ] Natural reading pace
    - [ ] Key terms defined

  design:
    - [ ] Color contrast checked
    - [ ] Color-blind safe
    - [ ] Font sizes adequate
    - [ ] Visual hierarchy clear
```

### Production

```yaml
production_checklist:
  audio:
    - [ ] Clear voice recording
    - [ ] Consistent volume levels
    - [ ] Background music not overpowering

  visual:
    - [ ] Text readable at small sizes
    - [ ] Safe zones respected
    - [ ] No flashing/strobing
    - [ ] Smooth transitions
```

### Post-Production

```yaml
post_production_checklist:
  captions:
    - [ ] Accurate transcription
    - [ ] Properly timed
    - [ ] Readable styling

  metadata:
    - [ ] Clear title
    - [ ] Descriptive description
    - [ ] Appropriate tags

  chapters:
    - [ ] Key sections marked
    - [ ] Descriptive chapter titles
```

---

## 9. Testing & Validation

### Accessibility Testing Methods

```yaml
testing_methods:
  automated:
    tools:
      - Color contrast analyzers
      - Caption accuracy checkers
    limitations: "Can't test all aspects"

  manual:
    checks:
      - Watch without sound (captions test)
      - Watch with audio only (audio description)
      - View at 50% size (readability)
      - Test color blindness simulation

    ask:
      - "Can I understand without color cues?"
      - "Is the text readable on my phone?"
      - "Can I follow at 0.75x speed?"

  user_testing:
    - Include diverse testers
    - Get feedback from target audience
    - Iterate based on real feedback
```

### Accessibility Score Card

```yaml
scorecard:
  visual: "/25"
    contrast: "/5"
    color_use: "/5"
    typography: "/5"
    hierarchy: "/5"
    motion: "/5"

  audio: "/25"
    clarity: "/5"
    volume: "/5"
    captions: "/10"
    music_balance: "/5"

  cognitive: "/25"
    structure: "/5"
    pacing: "/5"
    language: "/5"
    density: "/5"
    predictability: "/5"

  technical: "/25"
    quality: "/5"
    captions_sync: "/5"
    mobile_friendly: "/5"
    chapters: "/5"
    loading: "/5"

  total: "/100"
  passing: "80+"
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│  ACCESSIBILITY QUICK CHECKLIST                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  VISUAL                                                          │
│  □ Contrast ratio 4.5:1+ for all text                           │
│  □ Not color-only (icons/text too)                              │
│  □ Text 48px+ for Shorts, 36px+ for Standard                    │
│  □ Clear visual hierarchy                                       │
│                                                                  │
│  AUDIO                                                           │
│  □ Clear voice, consistent volume                               │
│  □ Background music subtle                                      │
│  □ Captions accurate and synced                                 │
│                                                                  │
│  COGNITIVE                                                       │
│  □ 1-2 items per slide (Shorts)                                 │
│  □ Simple, clear language                                       │
│  □ Predictable structure                                        │
│  □ Adequate pacing with pauses                                  │
│                                                                  │
│  TECHNICAL                                                       │
│  □ 1080p minimum resolution                                     │
│  □ Text readable at 50% size                                    │
│  □ Works without sound (via captions)                           │
│  □ Chapters for navigation                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## WCAG Compliance Summary

```yaml
wcag_levels:
  A_minimum:
    - Text alternatives for non-text content
    - Captions for audio content
    - Info not conveyed by color alone
    - No auto-playing audio

  AA_recommended:
    - Contrast ratio 4.5:1
    - Text resizable to 200%
    - Multiple ways to find content
    - Consistent navigation

  AAA_ideal:
    - Contrast ratio 7:1
    - Sign language for audio
    - Extended audio description
    - Reading level considerations
```

---

*"Accessible design is good design - it works better for everyone."*
