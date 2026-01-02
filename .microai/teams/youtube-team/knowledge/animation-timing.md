# Animation Timing & Pacing in Manim

## 1. Rate Functions - Điều Khiển Tốc Độ Animation

### 1.1 Các Rate Functions Cơ Bản
```python
from manim import *

# Linear - Tốc độ đều
self.play(obj.animate.shift(RIGHT), rate_func=linear)

# Smooth (default) - Chậm đầu cuối, nhanh giữa
self.play(obj.animate.shift(RIGHT), rate_func=smooth)

# Rush Into - Chậm đầu, nhanh cuối
self.play(obj.animate.shift(RIGHT), rate_func=rush_into)

# Rush From - Nhanh đầu, chậm cuối
self.play(obj.animate.shift(RIGHT), rate_func=rush_from)

# Ease In/Out
self.play(obj.animate.shift(RIGHT), rate_func=ease_in_sine)
self.play(obj.animate.shift(RIGHT), rate_func=ease_out_sine)
self.play(obj.animate.shift(RIGHT), rate_func=ease_in_out_sine)

# There and Back - Đi rồi quay về
self.play(obj.animate.shift(RIGHT), rate_func=there_and_back, run_time=2)

# Wiggle - Lắc
self.play(obj.animate.shift(RIGHT), rate_func=wiggle)

# Double Smooth - Mượt hơn smooth
self.play(obj.animate.shift(RIGHT), rate_func=double_smooth)
```

### 1.2 Rate Functions cho Từng Mục Đích

```
┌────────────────────────────────────────────────────────────────────────────┐
│                        RATE FUNCTIONS BY PURPOSE                           │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  NATURAL MOTION (Giống chuyển động thực)                                   │
│  ├── smooth           : Animation thông thường, tự nhiên                   │
│  ├── ease_in_out_sine : Chuyển động mượt mà                                │
│  └── ease_in_out_cubic: Nhấn mạnh sự tự nhiên                              │
│                                                                            │
│  EMPHASIS (Nhấn mạnh)                                                      │
│  ├── rush_into        : Tạo cảm giác "đến nhanh"                          │
│  ├── rush_from        : Tạo cảm giác "xuất phát mạnh"                     │
│  └── ease_out_back    : Overshoot nhẹ, tạo điểm nhấn                      │
│                                                                            │
│  MECHANICAL (Máy móc, kỹ thuật)                                           │
│  ├── linear           : Đồ thị, đo lường                                   │
│  └── ease_in_quad     : Gia tốc đều                                        │
│                                                                            │
│  PLAYFUL (Vui nhộn)                                                        │
│  ├── wiggle           : Lắc lư                                             │
│  ├── there_and_back   : Đi và về                                           │
│  └── ease_out_bounce  : Nảy lên                                            │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Custom Rate Functions
```python
# Định nghĩa rate function tùy chỉnh
def my_rate_func(t):
    """
    t từ 0 đến 1
    Trả về giá trị từ 0 đến 1
    """
    # Ví dụ: ease_in_out quadratic
    if t < 0.5:
        return 2 * t * t
    else:
        return 1 - 2 * (1 - t) * (1 - t)

self.play(obj.animate.shift(RIGHT), rate_func=my_rate_func)

# Rate function với bounce
def bounce(t):
    if t < 0.7:
        return t / 0.7
    else:
        # Bounce back slightly
        remaining = (t - 0.7) / 0.3
        return 1 - 0.1 * np.sin(remaining * PI)

# Rate function với pause in middle
def pause_middle(t):
    if t < 0.3:
        return t / 0.3 * 0.5
    elif t < 0.7:
        return 0.5  # Pause
    else:
        return 0.5 + (t - 0.7) / 0.3 * 0.5
```

## 2. Run Time - Thời Lượng Animation

### 2.1 Guidelines cho Timing
```python
# Very Fast (0.3-0.5s): Transitions nhỏ, không quan trọng
self.play(FadeIn(dot), run_time=0.3)

# Fast (0.5-0.8s): Actions đơn giản
self.play(obj.animate.shift(RIGHT), run_time=0.5)

# Normal (1.0s): Default, phù hợp hầu hết trường hợp
self.play(Create(circle), run_time=1)

# Medium (1.5-2s): Actions quan trọng, cần chú ý
self.play(Transform(before, after), run_time=1.5)

# Slow (2-3s): Revelations, key insights
self.play(Write(important_formula), run_time=2.5)

# Very Slow (3-5s): Complex transformations, dramatic reveals
self.play(complex_animation, run_time=4)
```

### 2.2 Timing theo Context
```python
# Educational video timings
TIMING = {
    "title_write": 1.5,
    "subtitle": 0.8,
    "object_create": 1.0,
    "object_move": 0.8,
    "transform": 1.5,
    "highlight": 0.5,
    "fade_out": 0.5,
    "pause_for_emphasis": 2.0,
    "pause_for_comprehension": 3.0,
    "formula_write": 2.0,
}

# Sử dụng
self.play(Write(title), run_time=TIMING["title_write"])
self.wait(0.5)
self.play(Write(subtitle), run_time=TIMING["subtitle"])
```

## 3. Wait và Pauses

### 3.1 Các Loại Wait
```python
# Short pause - transition
self.wait(0.3)

# Normal pause - after action
self.wait(0.5)

# Pause for reading - short text
self.wait(1.0)

# Pause for comprehension - complex content
self.wait(2.0)

# Long pause - key insight, let it sink in
self.wait(3.0)

# Very long pause - dramatic effect
self.wait(4.0)
```

### 3.2 Pattern: Pause theo Nội Dung
```python
def estimated_read_time(text):
    """Ước lượng thời gian đọc (words per minute = 150)"""
    word_count = len(text.split())
    return max(1.0, word_count / 150 * 60)

# Sử dụng
explanation = "Đây là một định lý quan trọng trong hình học"
text = Text(explanation)
self.play(Write(text), run_time=1.5)
self.wait(estimated_read_time(explanation))
```

### 3.3 Pattern: Beat Timing
```python
# Beat = đơn vị thời gian cơ bản (thường 0.5s hoặc 1s)
BEAT = 0.5

# Các action theo beat
self.play(Create(obj), run_time=2*BEAT)
self.wait(1*BEAT)
self.play(obj.animate.shift(RIGHT), run_time=2*BEAT)
self.wait(1*BEAT)
self.play(Transform(obj, new_obj), run_time=3*BEAT)
self.wait(2*BEAT)  # Longer pause for key moment
```

## 4. Lag Ratio - Animation Tuần Tự

### 4.1 LaggedStart
```python
# Các elements xuất hiện lần lượt
items = VGroup(*[Circle() for _ in range(5)])
items.arrange(RIGHT)

# lag_ratio = 0: Tất cả cùng lúc
# lag_ratio = 0.2: Mỗi item bắt đầu sau 20% run_time
# lag_ratio = 1: Item sau bắt đầu khi item trước kết thúc

self.play(
    LaggedStart(*[Create(item) for item in items],
                lag_ratio=0.2),
    run_time=2
)
```

### 4.2 AnimationGroup
```python
# Animations đồng thời
self.play(AnimationGroup(
    Create(circle),
    Write(label),
    lag_ratio=0  # Cùng lúc
))

# Animations tuần tự
self.play(AnimationGroup(
    Create(circle),
    Write(label),
    lag_ratio=1  # Tuần tự
))

# Animations overlapping
self.play(AnimationGroup(
    Create(circle, run_time=1),
    Write(label, run_time=1),
    lag_ratio=0.5  # label bắt đầu khi circle hoàn thành 50%
))
```

### 4.3 Staggered Reveal
```python
def staggered_reveal(mobjects, direction=DOWN, lag=0.1):
    """Reveal objects one by one from a direction"""
    anims = []
    for i, mob in enumerate(mobjects):
        mob.shift(0.5 * direction)
        mob.set_opacity(0)
        anims.append(
            AnimationGroup(
                mob.animate.shift(-0.5 * direction),
                mob.animate.set_opacity(1),
            )
        )
    return LaggedStart(*anims, lag_ratio=lag)

# Sử dụng
items = VGroup(*[Text(str(i)) for i in range(5)])
items.arrange(DOWN)
self.play(staggered_reveal(items))
```

## 5. Succession - Chuỗi Animation

### 5.1 Basic Succession
```python
# Chuỗi animations nối tiếp
self.play(Succession(
    Create(circle),
    circle.animate.shift(RIGHT),
    circle.animate.set_color(RED),
    FadeOut(circle),
    lag_ratio=1  # Mỗi animation hoàn thành trước khi animation sau bắt đầu
))
```

### 5.2 Pattern: Build-up Animation
```python
def build_up_animation(final_mobject, parts, pause=0.3):
    """Xây dựng dần đối tượng từ các phần"""
    anims = []
    for part in parts:
        anims.append(Create(part))
        anims.append(Wait(pause))
    return Succession(*anims)

# Ví dụ: Xây dựng tam giác từng cạnh
triangle_parts = [
    Line(A, B),
    Line(B, C),
    Line(C, A)
]
self.play(build_up_animation(triangle, triangle_parts))
```

## 6. Animation Choreography

### 6.1 Scene Structure Template
```python
class WellTimedScene(Scene):
    def construct(self):
        # === PHASE 1: INTRODUCTION (5-10s) ===
        title = Text("Tiêu đề")
        self.play(Write(title), run_time=1.5)
        self.wait(1)
        self.play(FadeOut(title), run_time=0.5)

        # === PHASE 2: SETUP (10-20s) ===
        setup_objects = self.create_setup()
        self.play(
            LaggedStart(*[Create(obj) for obj in setup_objects],
                       lag_ratio=0.3),
            run_time=2
        )
        self.wait(1)

        # === PHASE 3: DEVELOPMENT (30-60s) ===
        # Main content with proper pacing
        for step in self.development_steps():
            self.play_step(step)

        # === PHASE 4: REVELATION (5-10s) ===
        result = self.create_result()
        self.play(
            Transform(setup_objects, result),
            run_time=2,
            rate_func=ease_out_sine
        )
        self.wait(2)  # Let it sink in

        # === PHASE 5: CONCLUSION (5-10s) ===
        self.play(
            *[FadeOut(obj) for obj in self.mobjects],
            run_time=1
        )
```

### 6.2 Pacing Guidelines
```
┌────────────────────────────────────────────────────────────────────────────┐
│                         PACING GUIDELINES                                  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  HOOK (0-10s)                                                              │
│  ├── Grab attention immediately                                           │
│  ├── Question or surprising visual                                        │
│  └── Fast pacing, dynamic                                                  │
│                                                                            │
│  BUILD-UP (10-60s)                                                         │
│  ├── Introduce elements gradually                                         │
│  ├── lag_ratio = 0.2-0.3 for sequential reveals                          │
│  ├── Pause between major additions                                        │
│  └── Medium pacing, educational                                           │
│                                                                            │
│  KEY INSIGHT (60-90s)                                                      │
│  ├── Slow down significantly                                              │
│  ├── Longer pauses (2-3s)                                                 │
│  ├── Highlight with color/scale                                           │
│  └── rate_func = smooth or ease_out                                       │
│                                                                            │
│  REVELATION (90-120s)                                                      │
│  ├── Dramatic pause before reveal                                         │
│  ├── Slower animation (run_time=2-3s)                                     │
│  ├── Flash or emphasis animation                                          │
│  └── Long pause after (3-4s)                                              │
│                                                                            │
│  WRAP-UP (120-180s)                                                        │
│  ├── Recap key points quickly                                             │
│  ├── Fast transitions                                                      │
│  └── Clean fade out                                                        │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

## 7. Synchronization Techniques

### 7.1 Syncing Multiple Objects
```python
# Method 1: AnimationGroup với run_time đồng bộ
self.play(
    AnimationGroup(
        obj1.animate.shift(RIGHT),
        obj2.animate.shift(LEFT),
        obj3.animate.rotate(PI),
    ),
    run_time=1.5
)

# Method 2: Sử dụng ValueTracker
t = ValueTracker(0)
obj1.add_updater(lambda m: m.set_x(t.get_value()))
obj2.add_updater(lambda m: m.set_y(t.get_value()))
obj3.add_updater(lambda m: m.rotate(t.get_value() * PI))

self.play(t.animate.set_value(1), run_time=2)

# Cleanup
obj1.clear_updaters()
obj2.clear_updaters()
obj3.clear_updaters()
```

### 7.2 Music/Beat Synchronization
```python
# Định nghĩa beats (seconds from start)
BEATS = [0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]

# Tạo timeline
def create_beat_timeline(beats, animations):
    """Sync animations với beat timeline"""
    # Sort by beat time
    sorted_events = sorted(zip(beats, animations), key=lambda x: x[0])

    current_time = 0
    for beat_time, anim in sorted_events:
        if beat_time > current_time:
            yield Wait(beat_time - current_time)
        yield anim
        current_time = beat_time + anim.run_time

# Sử dụng
events = list(create_beat_timeline(BEATS, animations))
self.play(Succession(*events))
```

## 8. Common Timing Patterns

### 8.1 Emphasis Pattern
```python
def emphasize(mobject, scale_factor=1.2, color=YELLOW):
    """Nhấn mạnh một đối tượng"""
    return Succession(
        mobject.animate.scale(scale_factor).set_color(color),
        Wait(0.5),
        mobject.animate.scale(1/scale_factor).set_color(WHITE),
        lag_ratio=1
    )

# Sử dụng
self.play(emphasize(key_formula))
```

### 8.2 Reveal Pattern
```python
def dramatic_reveal(mobject, pre_pause=1, post_pause=2):
    """Reveal với dramatic timing"""
    mobject.set_opacity(0)
    return Succession(
        Wait(pre_pause),
        mobject.animate.set_opacity(1),
        Flash(mobject.get_center(), color=YELLOW),
        Wait(post_pause),
        lag_ratio=1
    )
```

### 8.3 Teaching Moment Pattern
```python
def teaching_moment(explanation, visual, pointer=None):
    """Pattern cho teaching moment"""
    anims = [
        Write(explanation, run_time=2),
        Wait(1),
        Create(visual, run_time=1.5),
    ]
    if pointer:
        anims.extend([
            Wait(0.5),
            Create(pointer),
            Flash(pointer.get_end()),
        ])
    return Succession(*anims)
```

## 9. Timing Checklist

```
✓ Hook trong 5s đầu
✓ Không có khoảng lặng > 3s (trừ dramatic pause có chủ đích)
✓ Key insight có pause đủ lâu để comprehend
✓ Transitions mượt (0.3-0.5s fade)
✓ Build-up dùng lag_ratio để sequential reveal
✓ Revelation dùng slower animation + emphasis
✓ Tổng thời lượng phù hợp format (shorts < 60s, standard 5-15min)
✓ Không rush qua important concepts
✓ Dùng rate_func phù hợp context
```
