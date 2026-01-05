# Slide Templates - Visual Design System

> Knowledge file cho Visual Designer Agent
> Version: 1.0

---

## Design System Overview

### Brand Colors

```yaml
colors:
  primary: "#FF6B35"      # Orange - Energy, attention
  secondary: "#4ECDC4"    # Teal - Trust, learning
  accent: "#45B7D1"       # Blue - Professional
  background:
    dark: "#1A1A2E"       # Dark navy - Modern
    light: "#FFFFFF"      # White - Clean
  text:
    primary: "#FFFFFF"    # White on dark
    secondary: "#E0E0E0"  # Light gray
    accent: "#FFD93D"     # Yellow - Highlight
  success: "#4CAF50"      # Green
  error: "#F44336"        # Red
```

### Typography

```yaml
fonts:
  heading:
    family: "Inter"
    weights: [600, 700, 800]
    sizes:
      large: 120px
      medium: 80px
      small: 60px

  body:
    family: "Roboto"
    weights: [400, 500]
    sizes:
      large: 48px
      medium: 36px
      small: 28px

  mono:
    family: "Roboto Mono"
    use_for: ["ipa", "code", "technical"]
    weight: 400
    size: 40px

  vietnamese:
    family: "Arial Unicode MS"
    fallback: "Noto Sans Vietnamese"
    note: "Ensure diacritics display correctly"
```

---

## Slide Templates for Shorts (1080x1920)

### Template 1: Hook Slide

```yaml
template: hook
use_for: attention_grabber
duration: 3-5 seconds

layout:
  background:
    type: gradient
    colors: ["#FF6B35", "#FF8E53"]
    direction: diagonal

  elements:
    - type: text
      content: "{hook_text}"
      position:
        x: center
        y: 40%
      style:
        font: Inter
        size: 100px
        weight: 800
        color: "#FFFFFF"
        shadow: true

    - type: animation
      effect: zoom_in
      duration: 0.5s

example:
  hook_text: "90% SAI!"
```

### Template 2: Word Card

```yaml
template: word_card
use_for: vocabulary_introduction
duration: 5-7 seconds

layout:
  background:
    type: solid
    color: "#1A1A2E"

  elements:
    - type: word_main
      content: "{word}"
      position:
        x: center
        y: 35%
      style:
        font: Inter
        size: 120px
        weight: 700
        color: "#4ECDC4"
        highlight_glow: true

    - type: ipa
      content: "/{ipa}/"
      position:
        x: center
        y: 50%
      style:
        font: Roboto Mono
        size: 48px
        color: "#E0E0E0"

    - type: pos_badge
      content: "{part_of_speech}"
      position:
        x: center
        y: 60%
      style:
        background: "#FF6B35"
        padding: "10px 20px"
        border_radius: 20px
        font_size: 32px
        color: "#FFFFFF"

example:
  word: "negotiate"
  ipa: "nɪˈɡoʊʃieɪt"
  part_of_speech: "verb"
```

### Template 3: Definition Card

```yaml
template: definition_card
use_for: meaning_explanation
duration: 5-7 seconds

layout:
  background:
    type: solid
    color: "#1A1A2E"

  elements:
    - type: icon
      name: dictionary
      position:
        x: center
        y: 20%
      size: 80px
      color: "#4ECDC4"

    - type: meaning_vi
      content: "{meaning_vietnamese}"
      position:
        x: center
        y: 40%
      style:
        font: Arial Unicode MS
        size: 64px
        weight: 600
        color: "#FFFFFF"
        max_width: 900px
        text_align: center

    - type: meaning_en
      content: "{meaning_english}"
      position:
        x: center
        y: 60%
      style:
        font: Roboto
        size: 36px
        color: "#A0A0A0"
        max_width: 900px
        text_align: center
        italic: true

example:
  meaning_vietnamese: "đàm phán, thương lượng"
  meaning_english: "to discuss something to reach an agreement"
```

### Template 4: Example Card

```yaml
template: example_card
use_for: contextual_example
duration: 7-10 seconds

layout:
  background:
    type: solid
    color: "#1A1A2E"

  elements:
    - type: label
      content: "VÍ DỤ"
      position:
        x: center
        y: 15%
      style:
        font: Inter
        size: 32px
        weight: 600
        color: "#4ECDC4"
        letter_spacing: 3px

    - type: example_en
      content: "{example_english}"
      position:
        x: center
        y: 35%
      style:
        font: Roboto
        size: 44px
        color: "#FFFFFF"
        max_width: 950px
        text_align: center

    - type: highlighted_word
      target: "{word_to_highlight}"
      style:
        color: "#FFD93D"
        underline: true

    - type: example_vi
      content: "{example_vietnamese}"
      position:
        x: center
        y: 55%
      style:
        font: Arial Unicode MS
        size: 36px
        color: "#A0A0A0"
        max_width: 950px
        text_align: center

example:
  example_english: "We need to negotiate a better deal."
  example_vietnamese: "Chúng ta cần đàm phán một thỏa thuận tốt hơn."
  word_to_highlight: "negotiate"
```

### Template 5: Tip Card

```yaml
template: tip_card
use_for: learning_tips
duration: 5 seconds

layout:
  background:
    type: gradient
    colors: ["#4ECDC4", "#45B7D1"]
    direction: vertical

  elements:
    - type: icon
      name: lightbulb
      position:
        x: center
        y: 25%
      size: 100px
      color: "#FFD93D"

    - type: label
      content: "COLLOCATION"
      position:
        x: center
        y: 40%
      style:
        font: Inter
        size: 28px
        weight: 600
        color: "#FFFFFF"
        letter_spacing: 2px

    - type: tip_content
      content: "{collocation}"
      position:
        x: center
        y: 55%
      style:
        font: Inter
        size: 56px
        weight: 700
        color: "#FFFFFF"

example:
  collocation: "negotiate a contract"
```

### Template 6: CTA Card

```yaml
template: cta_card
use_for: call_to_action
duration: 3-5 seconds

layout:
  background:
    type: gradient
    colors: ["#FF6B35", "#FF4757"]
    direction: diagonal

  elements:
    - type: main_cta
      content: "FOLLOW"
      position:
        x: center
        y: 35%
      style:
        font: Inter
        size: 100px
        weight: 800
        color: "#FFFFFF"

    - type: sub_text
      content: "Học TOEIC mỗi ngày"
      position:
        x: center
        y: 50%
      style:
        font: Arial Unicode MS
        size: 40px
        color: "#FFE0D0"

    - type: animation
      effect: pulse
      target: main_cta
      duration: 1s
      loop: true

    - type: icon
      name: follow_arrow
      position:
        x: center
        y: 70%
      size: 60px
      color: "#FFFFFF"
      animation: bounce
```

---

## Slide Templates for Standard (1920x1080)

### Template: Title Slide

```yaml
template: standard_title
use_for: video_intro
duration: 5 seconds

layout:
  background:
    type: image
    source: branded_background.png
    overlay:
      color: "#1A1A2E"
      opacity: 0.7

  elements:
    - type: channel_logo
      position:
        x: 10%
        y: 10%
      size: 120px

    - type: title
      content: "{video_title}"
      position:
        x: center
        y: 40%
      style:
        font: Inter
        size: 72px
        weight: 700
        color: "#FFFFFF"

    - type: subtitle
      content: "{part_indicator}"
      position:
        x: center
        y: 55%
      style:
        font: Roboto
        size: 36px
        color: "#4ECDC4"
```

### Template: Content Slide

```yaml
template: standard_content
use_for: main_content
duration: varies

layout:
  background:
    color: "#1A1A2E"

  elements:
    - type: section_header
      position:
        x: 5%
        y: 10%
      style:
        font: Inter
        size: 48px
        color: "#4ECDC4"

    - type: content_area
      position:
        x: 5%
        y: 25%
        width: 90%
        height: 60%

    - type: progress_indicator
      position:
        x: right
        y: bottom
```

---

## Animation Library

### Available Animations

```yaml
animations:
  entrance:
    - fade_in: duration 0.3s
    - zoom_in: duration 0.5s, scale 1.2 to 1.0
    - slide_up: duration 0.4s
    - slide_left: duration 0.4s
    - bounce_in: duration 0.6s

  emphasis:
    - pulse: duration 1s, loop
    - glow: duration 0.5s
    - highlight: duration 0.3s
    - shake: duration 0.3s

  exit:
    - fade_out: duration 0.3s
    - zoom_out: duration 0.5s
    - slide_down: duration 0.4s

  transitions:
    - cut: instant
    - fade: duration 0.3s
    - wipe_left: duration 0.5s
    - dissolve: duration 0.5s
```

---

## Visual Assets

### Icons

```yaml
icon_library:
  education:
    - dictionary
    - lightbulb
    - graduation_cap
    - book
    - pencil

  actions:
    - checkmark
    - x_mark
    - arrow_right
    - follow_arrow
    - play

  social:
    - like
    - comment
    - share
    - subscribe
    - bell
```

### Shapes

```yaml
shapes:
  decorative:
    - rounded_rectangle
    - circle
    - blob
    - wave

  functional:
    - badge
    - tag
    - button
    - progress_bar
```

---

## Output Specifications

### Image Export

```yaml
export:
  format: PNG
  resolution: 1080x1920 (shorts) | 1920x1080 (standard)
  color_space: sRGB
  compression: lossless

  naming:
    pattern: "{slide_number:02d}-{template_name}.png"
    examples:
      - "01-hook.png"
      - "02-word_card.png"
      - "03-definition.png"
```

### Video Slide Export

```yaml
video_export:
  format: MP4
  codec: H.264
  fps: 30
  duration: per_slide_timing

  naming:
    pattern: "{slide_number:02d}-{template_name}.mp4"
```

---

## Best Practices

1. **Contrast Ratio**: Minimum 4.5:1 for text readability
2. **Safe Zones**: Keep text within 90% of frame
3. **Font Size**: Minimum 28px for mobile viewing
4. **Animation Restraint**: Max 2 animations per slide
5. **Consistency**: Use same template for same content type
6. **Vietnamese Diacritics**: Always verify diacritics display correctly

---

*Last updated: 2026-01-04*
