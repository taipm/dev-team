---
name: animated-math
description: "Create animated mathematical graphs and export YouTube-ready videos (1080p, 4K) and Shorts (9:16)"
description_vi: "Tạo đồ thị toán học động với Manim, xuất video chuẩn YouTube (1080p, 4K) và Shorts (9:16)"
category: document-skills
version: "1.0.0"
license: apache-2.0
tags: [manim, animation, math, video, youtube, shorts, graph, visualization, 3b1b]
created: "2026-01-02"
author: MicroAI Team
---

# Animated Math Skill

> Tạo đồ thị toán học động chất lượng cao với Manim, xuất video chuẩn YouTube và Shorts.

## Quick Start

### 1. Cài đặt Manim

```bash
# Recommended: using uv
uv pip install manim

# Or pip
pip install manim

# Verify installation
manim --version
```

**Yêu cầu**: Python 3.8+, FFmpeg, LaTeX (optional)

### 2. Tạo animation đầu tiên

```python
from manim import *

class SineCurve(Scene):
    def construct(self):
        # Tạo hệ trục tọa độ
        axes = Axes(
            x_range=[-3, 3, 1],
            y_range=[-2, 2, 1],
            axis_config={"include_tip": True}
        )

        # Vẽ đồ thị sin(x)
        graph = axes.plot(lambda x: np.sin(x), color=BLUE)
        label = axes.get_graph_label(graph, label="\\sin(x)")

        # Animation
        self.play(Create(axes))
        self.play(Create(graph), Write(label))
        self.wait(2)
```

### 3. Render video

```bash
# YouTube 1080p (Full HD)
manim -qh -p scene.py SineCurve

# YouTube 4K
manim -qk -p scene.py SineCurve

# YouTube Shorts (vertical 9:16)
manim -qh -r 1080,1920 -p scene.py SineCurve
```

---

## Video Quality Presets

### YouTube Standard (16:9 Landscape)

| Preset | Flag | Resolution | FPS | Use Case |
|--------|------|------------|-----|----------|
| Preview | `-ql` | 854×480 | 15 | Quick preview |
| Medium | `-qm` | 1280×720 | 30 | Draft |
| **1080p** | `-qh` | 1920×1080 | 60 | **YouTube standard** |
| 2K | `-qp` | 2560×1440 | 60 | High quality |
| **4K** | `-qk` | 3840×2160 | 60 | **YouTube premium** |

### YouTube Shorts (9:16 Vertical)

```bash
# Shorts 1080p (recommended)
manim -qh -r 1080,1920 scene.py SceneName

# Shorts 4K
manim -qk -r 2160,3840 scene.py SceneName
```

**Shorts specs**:
- Aspect ratio: 9:16 (vertical)
- Max duration: 60 seconds
- Resolution: 1080×1920 (recommended)

---

## Animation Templates

### 1. Function Graph Animation

```python
from manim import *

class FunctionGraph(Scene):
    """Template: Vẽ đồ thị hàm số với animation"""

    def construct(self):
        # Config
        axes = Axes(
            x_range=[-4, 4, 1],
            y_range=[-2, 2, 0.5],
            x_length=10,
            y_length=6,
            axis_config={"include_numbers": True}
        )

        # Function
        func = lambda x: np.sin(x)
        graph = axes.plot(func, color=BLUE)
        label = MathTex(r"f(x) = \sin(x)").to_corner(UL)

        # Animate
        self.play(Create(axes), run_time=2)
        self.play(Create(graph), Write(label), run_time=3)
        self.wait(2)
```

### 2. Derivative Visualization

```python
from manim import *

class DerivativeVisualization(Scene):
    """Template: Minh họa đạo hàm với tiếp tuyến di chuyển"""

    def construct(self):
        axes = Axes(x_range=[-3, 3], y_range=[-1, 9])

        # f(x) = x²
        func = axes.plot(lambda x: x**2, color=BLUE)
        func_label = MathTex(r"f(x) = x^2").to_corner(UL)

        # Điểm di chuyển trên đồ thị
        dot = Dot(color=YELLOW)
        dot.move_to(axes.c2p(-2, 4))

        # Đường tiếp tuyến
        tangent = always_redraw(
            lambda: axes.get_secant_slope_group(
                x=axes.p2c(dot.get_center())[0],
                graph=func,
                dx=0.01,
                secant_line_length=4,
                secant_line_color=RED
            )
        )

        self.play(Create(axes), Create(func), Write(func_label))
        self.add(dot, tangent)
        self.play(dot.animate.move_to(axes.c2p(2, 4)), run_time=5)
        self.wait()
```

### 3. Integral Animation

```python
from manim import *

class IntegralVisualization(Scene):
    """Template: Minh họa tích phân với diện tích dưới đồ thị"""

    def construct(self):
        axes = Axes(x_range=[0, 5], y_range=[0, 6])

        func = axes.plot(lambda x: 0.5 * x**2, color=BLUE)

        # Diện tích dưới đồ thị
        area = axes.get_area(func, x_range=[1, 4], color=GREEN, opacity=0.5)

        # Labels
        integral_label = MathTex(
            r"\int_1^4 \frac{x^2}{2} dx"
        ).to_corner(UL)

        self.play(Create(axes), Create(func))
        self.play(FadeIn(area), Write(integral_label))
        self.wait(2)
```

### 4. 3D Surface Plot

```python
from manim import *

class Surface3D(ThreeDScene):
    """Template: Đồ thị 3D cho hàm 2 biến"""

    def construct(self):
        axes = ThreeDAxes()

        # z = sin(x) * cos(y)
        surface = Surface(
            lambda u, v: axes.c2p(u, v, np.sin(u) * np.cos(v)),
            u_range=[-3, 3],
            v_range=[-3, 3],
            resolution=(30, 30)
        )
        surface.set_fill_by_value(axes=axes, colorscale=[BLUE, GREEN, YELLOW])

        self.set_camera_orientation(phi=60 * DEGREES, theta=-45 * DEGREES)
        self.play(Create(axes), Create(surface))
        self.begin_ambient_camera_rotation(rate=0.2)
        self.wait(5)
```

### 5. YouTube Shorts Template

```python
from manim import *

# Config cho Shorts (9:16)
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920

class MathShort(Scene):
    """Template: Math animation cho YouTube Shorts"""

    def construct(self):
        # Title lớn ở trên
        title = Text("Đạo hàm là gì?", font_size=72).to_edge(UP, buff=1)

        # Đồ thị ở giữa
        axes = Axes(
            x_range=[-2, 2],
            y_range=[-1, 4],
            x_length=7,
            y_length=8
        ).shift(DOWN * 1)

        func = axes.plot(lambda x: x**2, color=BLUE)

        # Công thức ở dưới
        formula = MathTex(r"f'(x) = 2x", font_size=60).to_edge(DOWN, buff=1)

        # Fast animations cho Shorts
        self.play(Write(title), run_time=0.5)
        self.play(Create(axes), Create(func), run_time=1)
        self.play(Write(formula), run_time=0.5)
        self.wait(1)
```

---

## Common Mobjects

### Mathematical Objects

```python
# Công thức toán
MathTex(r"\frac{d}{dx}[x^n] = nx^{n-1}")

# Hệ trục tọa độ
Axes(x_range=[-5, 5], y_range=[-3, 3])

# Hệ trục 3D
ThreeDAxes()

# Đồ thị hàm số
axes.plot(lambda x: x**2, color=BLUE)

# Vector
Arrow(start=ORIGIN, end=[2, 1, 0], color=RED)
Vector([2, 1])

# Ma trận
Matrix([[1, 2], [3, 4]])
```

### Shapes

```python
Circle(radius=1, color=BLUE)
Square(side_length=2)
Triangle()
Polygon([[-1, 0, 0], [1, 0, 0], [0, 2, 0]])
Line(start=[-2, 0, 0], end=[2, 0, 0])
Dot(point=[1, 1, 0], color=RED)
```

---

## Animation Methods

### Basic Animations

```python
self.play(Create(obj))       # Vẽ từ từ
self.play(Write(text))       # Viết chữ/công thức
self.play(FadeIn(obj))       # Hiện dần
self.play(FadeOut(obj))      # Ẩn dần
self.play(GrowFromCenter(obj))  # Phóng to từ tâm
```

### Transform

```python
self.play(Transform(obj1, obj2))      # Biến đổi
self.play(ReplacementTransform(a, b)) # Thay thế
self.play(obj.animate.shift(RIGHT))   # Di chuyển
self.play(obj.animate.scale(2))       # Scale
self.play(obj.animate.rotate(PI/2))   # Xoay
```

### Camera (3D)

```python
self.set_camera_orientation(phi=60*DEGREES, theta=-45*DEGREES)
self.begin_ambient_camera_rotation(rate=0.2)
self.move_camera(phi=75*DEGREES)
```

---

## Render Commands

### YouTube Standard

```bash
# Preview nhanh
manim -ql scene.py SceneName

# 1080p 60fps (YouTube recommended)
manim -qh scene.py SceneName

# 4K 60fps (YouTube premium)
manim -qk scene.py SceneName

# Mở file sau khi render
manim -qh -p scene.py SceneName
```

### YouTube Shorts

```bash
# Shorts 1080x1920 (vertical)
manim -qh -r 1080,1920 scene.py SceneName

# Shorts 4K vertical
manim -qk -r 2160,3840 scene.py SceneName
```

### Other Formats

```bash
# GIF (cho preview/thumbnail)
manim -qm --format gif scene.py SceneName

# WebM
manim -qh --format webm scene.py SceneName

# PNG frames
manim -qh --format png scene.py SceneName
```

### Output Directory

```
media/
├── videos/
│   └── scene/
│       ├── 480p15/          # -ql
│       ├── 720p30/          # -qm
│       ├── 1080p60/         # -qh (YouTube)
│       ├── 1440p60/         # -qp
│       └── 2160p60/         # -qk (4K)
├── images/
└── Tex/
```

---

## Configuration

### manim.cfg file

```ini
[CLI]
quality = high_quality
preview = True

[output]
media_dir = ./output
video_dir = {media_dir}/videos
images_dir = {media_dir}/images

[video]
frame_rate = 60
pixel_width = 1920
pixel_height = 1080
```

### Programmatic Config

```python
from manim import *

# YouTube 1080p
config.frame_rate = 60
config.pixel_width = 1920
config.pixel_height = 1080

# YouTube Shorts
config.frame_width = 9
config.frame_height = 16
config.pixel_width = 1080
config.pixel_height = 1920
```

---

## YouTube Specifications

### Standard Videos (16:9)

| Quality | Resolution | Bitrate (SDR) | Bitrate (HDR) |
|---------|------------|---------------|---------------|
| 1080p 30fps | 1920×1080 | 8 Mbps | 10 Mbps |
| 1080p 60fps | 1920×1080 | 12 Mbps | 15 Mbps |
| 4K 30fps | 3840×2160 | 35-45 Mbps | 44-56 Mbps |
| 4K 60fps | 3840×2160 | 53-68 Mbps | 66-85 Mbps |

### Shorts (9:16)

- Resolution: 1080×1920 (recommended)
- Max duration: 60 seconds
- Aspect ratio: 9:16
- Format: MP4 (H.264)

### Best Practices

1. **Frame rate**: Dùng 60fps cho animation mượt
2. **Duration**: Shorts tối đa 60s, thường 15-30s hiệu quả nhất
3. **Text size**: Font lớn hơn cho Shorts (mobile-first)
4. **Colors**: Contrast cao, tránh màu quá nhạt

---

## Tips & Best Practices

### Performance

- Dùng `-ql` để preview nhanh
- Chỉ render `-qk` (4K) khi cần final output
- Cache LaTeX với `--flush_cache` khi cần

### Animation Quality

```python
# Smooth animations
self.play(Create(obj), run_time=2)  # Chậm hơn = mượt hơn

# Easing functions
self.play(obj.animate.shift(RIGHT), rate_func=smooth)
self.play(obj.animate.scale(2), rate_func=there_and_back)
```

### Shorts Optimization

```python
# Font lớn cho mobile
Text("Title", font_size=72)
MathTex(r"formula", font_size=60)

# Animation nhanh
self.play(Write(text), run_time=0.5)

# Vertical layout
obj.to_edge(UP, buff=1)
obj.to_edge(DOWN, buff=1)
```

---

## References

- `references/manim-patterns.md` - Common animation patterns
- `references/youtube-specs.md` - YouTube video specifications
- `templates/` - Ready-to-use scene templates
- `examples/` - Complete working examples

---

## External Resources

- [Manim Community Docs](https://docs.manim.community/en/stable/)
- [3Blue1Brown Manim](https://github.com/3b1b/manim)
- [YouTube Upload Specs](https://support.google.com/youtube/answer/1722171)

---

*Animated Math Skill v1.0 - Part of MicroAI Document Skills*
