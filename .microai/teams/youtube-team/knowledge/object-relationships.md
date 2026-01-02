# Object Relationships & Updaters in Manim

## 1. Tổng Quan về Object Dependencies

Trong Manim, các đối tượng có thể có quan hệ phụ thuộc lẫn nhau. Khi một đối tượng thay đổi, các đối tượng liên quan cần tự động cập nhật.

### 1.1 Các Loại Quan Hệ

```
┌─────────────────────────────────────────────────────────────────┐
│                    OBJECT RELATIONSHIPS                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. STATIC RELATIONSHIPS                                        │
│     ├── Position-based: A next_to B                            │
│     ├── Alignment: A aligned with B                            │
│     └── Group membership: A in VGroup with B                   │
│                                                                 │
│  2. DYNAMIC RELATIONSHIPS (Updaters)                           │
│     ├── always_redraw(): Tái tạo mỗi frame                     │
│     ├── add_updater(): Cập nhật thuộc tính                     │
│     └── become(): Biến đổi sang đối tượng khác                 │
│                                                                 │
│  3. CONSTRAINT RELATIONSHIPS                                    │
│     ├── Point trên đường: point_on_line                        │
│     ├── Point trên đường tròn: point_on_circle                 │
│     └── Intersection: giao điểm của 2 đối tượng                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Updaters - Cập Nhật Động

### 2.1 add_updater() - Basic Usage
```python
# Updater đơn giản: label luôn theo đối tượng
dot = Dot(color=RED)
label = Text("Point")

# Label luôn ở trên dot
label.add_updater(lambda m: m.next_to(dot, UP))

self.play(dot.animate.shift(2 * RIGHT))  # Label tự động di theo
```

### 2.2 Updater với State
```python
# Updater theo dõi giá trị thay đổi
value = ValueTracker(0)
number = DecimalNumber(0)

# Cập nhật số theo ValueTracker
number.add_updater(lambda m: m.set_value(value.get_value()))

self.play(value.animate.set_value(10))  # Số tăng từ 0 đến 10
```

### 2.3 Updater với dt (time-based)
```python
# Updater dựa trên thời gian
def rotate_updater(mob, dt):
    mob.rotate(2 * PI * dt)  # Quay 1 vòng/giây

square = Square()
square.add_updater(rotate_updater)

self.wait(2)  # Square quay liên tục trong 2 giây
square.remove_updater(rotate_updater)  # Dừng quay
```

### 2.4 Suspend Updaters
```python
# Tạm dừng updater trong animation
dot = Dot()
label = Text("P").add_updater(lambda m: m.next_to(dot, UP))

self.add(dot, label)

# Tạm dừng updater để animate riêng label
label.suspend_updating()
self.play(label.animate.scale(2))
label.resume_updating()
```

## 3. always_redraw() - Tái Tạo Mỗi Frame

### 3.1 Basic Usage
```python
# Đường thẳng luôn nối 2 điểm di động
dot1 = Dot(LEFT)
dot2 = Dot(RIGHT)

# Line tự động vẽ lại khi dot1 hoặc dot2 di chuyển
line = always_redraw(lambda: Line(dot1.get_center(), dot2.get_center()))

self.add(dot1, dot2, line)
self.play(dot1.animate.move_to(2*UP), dot2.animate.move_to(2*DOWN))
```

### 3.2 Complex always_redraw
```python
def create_angle_arc():
    """Tạo cung góc động giữa 2 lines"""
    return Angle(
        line1, line2,
        radius=0.5,
        color=YELLOW,
        fill_opacity=0.3
    )

angle_arc = always_redraw(create_angle_arc)
```

### 3.3 Pattern: Dependent Geometry
```python
# Tam giác với điểm di động
A = Dot(UP * 2, color=RED)
B = Dot(DL * 1.5, color=GREEN)
C = Dot(DR * 1.5, color=BLUE)

# Tam giác tự động cập nhật
triangle = always_redraw(
    lambda: Polygon(
        A.get_center(),
        B.get_center(),
        C.get_center(),
        color=WHITE
    )
)

# Tâm trọng tâm tự động cập nhật
centroid = always_redraw(
    lambda: Dot(
        (A.get_center() + B.get_center() + C.get_center()) / 3,
        color=YELLOW
    )
)

self.add(A, B, C, triangle, centroid)
self.play(A.animate.move_to(3*UP))  # Tam giác và tâm tự động thay đổi
```

## 4. Quan Hệ Hình Học

### 4.1 Point on Line
```python
def point_on_line(line, t):
    """
    Điểm trên đoạn thẳng, t từ 0 đến 1

    t=0: điểm đầu
    t=1: điểm cuối
    t=0.5: trung điểm
    """
    start = line.get_start()
    end = line.get_end()
    return start + t * (end - start)

# Sử dụng
line = Line(LEFT * 3, RIGHT * 3)
t = ValueTracker(0)

moving_dot = always_redraw(
    lambda: Dot(point_on_line(line, t.get_value()), color=RED)
)

self.add(line, moving_dot)
self.play(t.animate.set_value(1))  # Dot di chuyển dọc line
```

### 4.2 Point on Circle
```python
def point_on_circle(circle, angle):
    """Điểm trên đường tròn tại góc angle (radians)"""
    center = circle.get_center()
    radius = circle.get_width() / 2
    x = center[0] + radius * np.cos(angle)
    y = center[1] + radius * np.sin(angle)
    return np.array([x, y, 0])

# Sử dụng
circle = Circle(radius=2)
angle = ValueTracker(0)

moving_dot = always_redraw(
    lambda: Dot(point_on_circle(circle, angle.get_value()), color=RED)
)

# Radius line từ tâm đến điểm
radius_line = always_redraw(
    lambda: Line(
        circle.get_center(),
        point_on_circle(circle, angle.get_value()),
        color=YELLOW
    )
)

self.add(circle, moving_dot, radius_line)
self.play(angle.animate.set_value(2 * PI), run_time=3)  # Quay 1 vòng
```

### 4.3 Intersection Points
```python
def line_circle_intersections(line, circle):
    """
    Tìm giao điểm của line và circle
    Returns: list of intersection points (0, 1, or 2 points)
    """
    # Line parameters
    p1 = line.get_start()[:2]
    p2 = line.get_end()[:2]

    # Circle parameters
    center = circle.get_center()[:2]
    radius = circle.get_width() / 2

    # Line direction
    d = p2 - p1
    f = p1 - center

    a = np.dot(d, d)
    b = 2 * np.dot(f, d)
    c = np.dot(f, f) - radius * radius

    discriminant = b * b - 4 * a * c

    if discriminant < 0:
        return []  # Không giao
    elif discriminant == 0:
        t = -b / (2 * a)
        point = p1 + t * d
        return [np.array([point[0], point[1], 0])]
    else:
        t1 = (-b - np.sqrt(discriminant)) / (2 * a)
        t2 = (-b + np.sqrt(discriminant)) / (2 * a)
        point1 = p1 + t1 * d
        point2 = p1 + t2 * d
        return [
            np.array([point1[0], point1[1], 0]),
            np.array([point2[0], point2[1], 0])
        ]

# Sử dụng với always_redraw
def create_intersection_dots():
    intersections = line_circle_intersections(line, circle)
    return VGroup(*[Dot(p, color=RED) for p in intersections])

intersection_dots = always_redraw(create_intersection_dots)
```

### 4.4 Line-Line Intersection
```python
def line_intersection(line1, line2):
    """
    Tìm giao điểm của 2 đường thẳng (mở rộng nếu cần)
    Returns: intersection point or None
    """
    p1, p2 = line1.get_start()[:2], line1.get_end()[:2]
    p3, p4 = line2.get_start()[:2], line2.get_end()[:2]

    d1 = p2 - p1
    d2 = p4 - p3

    cross = d1[0] * d2[1] - d1[1] * d2[0]
    if abs(cross) < 1e-10:
        return None  # Song song hoặc trùng

    t = ((p3[0] - p1[0]) * d2[1] - (p3[1] - p1[1]) * d2[0]) / cross
    intersection = p1 + t * d1

    return np.array([intersection[0], intersection[1], 0])
```

## 5. Pattern: Dynamic Constructions

### 5.1 Đường Cao Động
```python
class DynamicAltitude(Scene):
    def construct(self):
        # 3 đỉnh có thể di chuyển
        A = Dot(UP * 2, color=RED)
        B = Dot(DL * 2, color=GREEN)
        C = Dot(DR * 2, color=BLUE)

        # Tam giác động
        triangle = always_redraw(
            lambda: Polygon(
                A.get_center(), B.get_center(), C.get_center(),
                stroke_width=2
            )
        )

        # Đường cao từ A động
        def create_altitude():
            a = A.get_center()
            b = B.get_center()
            c = C.get_center()

            # Tìm chân đường cao
            bc = c - b
            foot = b + np.dot(a - b, bc) / np.dot(bc, bc) * bc

            return VGroup(
                Line(a, foot, color=YELLOW),
                Dot(foot, color=YELLOW, radius=0.05),
                RightAngle(
                    Line(foot, a), Line(foot, c),
                    length=0.2, color=YELLOW
                )
            )

        altitude = always_redraw(create_altitude)

        self.add(triangle, altitude, A, B, C)
        self.play(A.animate.move_to(UP * 3 + RIGHT))
        self.play(B.animate.move_to(LEFT * 3))
        self.wait()
```

### 5.2 Đường Tròn Ngoại Tiếp Động
```python
def circumcircle_from_dots(A, B, C):
    """Tạo đường tròn ngoại tiếp từ 3 Dot objects"""
    a = A.get_center()
    b = B.get_center()
    c = C.get_center()

    # Tính circumcenter
    d = 2 * (a[0] * (b[1] - c[1]) + b[0] * (c[1] - a[1]) + c[0] * (a[1] - b[1]))
    if abs(d) < 1e-10:
        return VGroup()  # Thẳng hàng

    ux = ((a[0]**2 + a[1]**2) * (b[1] - c[1]) +
          (b[0]**2 + b[1]**2) * (c[1] - a[1]) +
          (c[0]**2 + c[1]**2) * (a[1] - b[1])) / d
    uy = ((a[0]**2 + a[1]**2) * (c[0] - b[0]) +
          (b[0]**2 + b[1]**2) * (a[0] - c[0]) +
          (c[0]**2 + c[1]**2) * (b[0] - a[0])) / d

    center = np.array([ux, uy, 0])
    radius = np.linalg.norm(a - center)

    return Circle(radius=radius, color=BLUE).move_to(center)

# Sử dụng
circumcircle = always_redraw(lambda: circumcircle_from_dots(A, B, C))
```

### 5.3 Angle Tracking
```python
class AngleTracking(Scene):
    def construct(self):
        # 2 vectors từ gốc
        angle = ValueTracker(PI / 4)

        line1 = always_redraw(
            lambda: Line(ORIGIN, 2 * RIGHT, color=BLUE)
        )

        line2 = always_redraw(
            lambda: Line(
                ORIGIN,
                2 * np.array([np.cos(angle.get_value()),
                             np.sin(angle.get_value()), 0]),
                color=GREEN
            )
        )

        # Cung góc
        arc = always_redraw(
            lambda: Arc(
                radius=0.5,
                start_angle=0,
                angle=angle.get_value(),
                color=YELLOW
            )
        )

        # Label góc
        angle_label = always_redraw(
            lambda: MathTex(
                f"{int(np.degrees(angle.get_value()))}°"
            ).move_to(0.8 * np.array([
                np.cos(angle.get_value() / 2),
                np.sin(angle.get_value() / 2),
                0
            ]))
        )

        self.add(line1, line2, arc, angle_label)
        self.play(angle.animate.set_value(PI), run_time=2)
        self.play(angle.animate.set_value(PI / 6), run_time=2)
```

## 6. ValueTracker Patterns

### 6.1 Multiple Dependencies
```python
# Một ValueTracker điều khiển nhiều đối tượng
t = ValueTracker(0)

# Điểm chạy trên parabol
point = always_redraw(
    lambda: Dot(
        np.array([t.get_value(), t.get_value()**2, 0]),
        color=RED
    )
)

# Tiếp tuyến tại điểm đó
tangent = always_redraw(
    lambda: Line(
        np.array([t.get_value() - 1, t.get_value()**2 - 2*t.get_value(), 0]),
        np.array([t.get_value() + 1, t.get_value()**2 + 2*t.get_value(), 0]),
        color=YELLOW
    )
)

# Pháp tuyến tại điểm đó
def create_normal():
    x0 = t.get_value()
    y0 = x0**2
    # Pháp tuyến vuông góc với tiếp tuyến
    slope = -1 / (2 * x0) if x0 != 0 else 10000
    return Line(
        np.array([x0 - 0.5, y0 - 0.5 * slope, 0]),
        np.array([x0 + 0.5, y0 + 0.5 * slope, 0]),
        color=GREEN
    )

normal = always_redraw(create_normal)
```

### 6.2 Chained ValueTrackers
```python
# t1 điều khiển t2
t1 = ValueTracker(0)
t2 = DecimalNumber(0)
t2.add_updater(lambda m: m.set_value(np.sin(t1.get_value())))

# Đối tượng phụ thuộc t2
def get_t2():
    return np.sin(t1.get_value())

circle = always_redraw(
    lambda: Circle(radius=1 + 0.5 * get_t2(), color=BLUE)
)
```

## 7. Best Practices

### 7.1 Performance Considerations
```python
# ❌ Không tốt: Tạo đối tượng phức tạp trong always_redraw
heavy_object = always_redraw(lambda: create_complex_graph())

# ✅ Tốt hơn: Chỉ cập nhật phần cần thiết
graph = create_complex_graph()  # Tạo 1 lần
point = always_redraw(lambda: Dot(get_point_on_graph(t.get_value())))
```

### 7.2 Cleanup Updaters
```python
# Luôn remove updater khi không cần
label.clear_updaters()

# Hoặc suspend tạm thời
label.suspend_updating()
# ... do animation ...
label.resume_updating()
```

### 7.3 Avoid Circular Dependencies
```python
# ❌ Không tốt: A phụ thuộc B, B phụ thuộc A
a.add_updater(lambda m: m.move_to(b.get_center() + UP))
b.add_updater(lambda m: m.move_to(a.get_center() + RIGHT))

# ✅ Tốt hơn: Dùng ValueTracker làm nguồn duy nhất
t = ValueTracker(0)
a = always_redraw(lambda: Dot(t.get_value() * RIGHT + UP))
b = always_redraw(lambda: Dot(t.get_value() * RIGHT))
```

### 7.4 Debug Updaters
```python
def debug_updater(mob, dt):
    print(f"Position: {mob.get_center()}, dt: {dt}")
    mob.shift(dt * RIGHT)

# Thêm để debug
obj.add_updater(debug_updater)
```

## 8. Common Patterns Summary

| Pattern | Use Case | Method |
|---------|----------|--------|
| Label follows object | Annotation | `add_updater(lambda m: m.next_to(...))` |
| Line between moving points | Connection | `always_redraw(lambda: Line(...))` |
| Dynamic geometry | Triangle, circles | `always_redraw` with calculation |
| Animated value | Counter, slider | `ValueTracker` + `add_updater` |
| Point on curve | Tracing | `always_redraw` + parametric |
| Angle tracking | Interactive | `ValueTracker` + `Arc` |
