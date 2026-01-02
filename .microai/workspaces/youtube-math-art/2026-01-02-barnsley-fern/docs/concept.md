# Concept: Barnsley Fern Growth

## 🎨 Visual Concept

### Topic Overview
**Barnsley Fern** là một fractal được tạo bởi Michael Barnsley sử dụng Iterated Function System (IFS). 
Nó mô phỏng hình dạng của cây dương xỉ (fern) một cách đáng kinh ngạc từ chỉ 4 phép biến đổi affine đơn giản.

### Mathematical Beauty
- 4 affine transformations với xác suất khác nhau
- Self-similarity: mỗi nhánh nhỏ giống hình dạng tổng thể
- Emergent complexity: từ đơn giản đến phức tạp
- Nature mimicry: toán học mô phỏng tự nhiên

### Animation Phases (90s)

| Phase | Time | Visual Description |
|-------|------|---------------------|
| Intro | 0-8s | Black screen, title fade in |
| Seed | 8-20s | First points appear, stem forms |
| Growth 1 | 20-40s | Main stem extends, first leaflets |
| Growth 2 | 40-60s | More points, branches emerge |
| Full Bloom | 60-80s | Complete fern, color gradient |
| Outro | 80-90s | Gentle zoom, fade out |

### Color Palette
```yaml
background: "#0a0a12"      # Deep space black
stem_color: "#1a5f1a"      # Dark forest green
leaf_gradient:
  start: "#2d8f2d"         # Fresh green
  mid: "#4aba4a"           # Bright green  
  end: "#7dde7d"           # Light spring green
accent: "#a8f0a8"          # Glow highlights
```

### Visual Style
- **Theme:** Organic growth, nature's mathematics
- **Mood:** Peaceful, meditative, wonder
- **Effects:** 
  - Points accumulate gradually (growth animation)
  - Color based on y-position (gradient effect)
  - Subtle glow on newest points
  - Smooth camera (slight zoom during climax)

### Sync Points for Narration
- `0:00` - Title appears
- `0:08` - First point drawn (narration: "Imagine...")
- `0:20` - Stem visible (narration: "The fern begins...")
- `0:40` - Branches forming (narration: "Each iteration...")
- `0:60` - Full complexity (narration: "Notice how...")
- `0:80` - Outro begins (narration: "Mathematics...")

## Technical Specs
```yaml
resolution: 1280x720
fps: 30
duration: 90s
total_frames: 2700
points_per_frame: 500
max_points: 500000
codec: H.264
```

## IFS Transformations
```
f1: x' = 0,           y' = 0.16*y           (stem, p=0.01)
f2: x' = 0.85*x+0.04*y, y' = -0.04*x+0.85*y+1.6  (main leaflet, p=0.85)
f3: x' = 0.2*x-0.26*y,  y' = 0.23*x+0.22*y+1.6   (left leaflet, p=0.07)
f4: x' = -0.15*x+0.28*y, y' = 0.26*x+0.24*y+0.44 (right leaflet, p=0.07)
```
