# Manim Coordinate Systems & Positioning

## 1. Hệ Tọa Độ Cơ Bản

### 1.1 Frame Coordinates
```python
# Frame mặc định: 14.2 x 8 units (tỷ lệ 16:9)
# Tâm tại (0, 0, 0)

# Biên của frame
RIGHT_SIDE = config.frame_width / 2   # ~7.1
LEFT_SIDE = -config.frame_width / 2   # ~-7.1
TOP = config.frame_height / 2         # ~4
BOTTOM = -config.frame_height / 2     # ~-4

# Các hướng chuẩn
UP = np.array([0, 1, 0])
DOWN = np.array([0, -1, 0])
LEFT = np.array([-1, 0, 0])
RIGHT = np.array([1, 0, 0])
OUT = np.array([0, 0, 1])   # Hướng ra khỏi màn hình
IN = np.array([0, 0, -1])   # Hướng vào màn hình

# Các góc
UL = UP + LEFT      # Upper Left
UR = UP + RIGHT     # Upper Right
DL = DOWN + LEFT    # Down Left
DR = DOWN + RIGHT   # Down Right
```

### 1.2 Điểm Đặc Biệt
```python
ORIGIN = np.array([0, 0, 0])

# Các góc màn hình
TOP_LEFT = np.array([-7.1, 4, 0])
TOP_RIGHT = np.array([7.1, 4, 0])
BOTTOM_LEFT = np.array([-7.1, -4, 0])
BOTTOM_RIGHT = np.array([7.1, -4, 0])
```

## 2. Positioning Methods

### 2.1 Absolute Positioning
```python
# move_to() - Di chuyển tâm đối tượng đến vị trí
circle = Circle()
circle.move_to(np.array([2, 1, 0]))  # Tâm tại (2, 1)
circle.move_to(ORIGIN)                # Tâm tại gốc
circle.move_to(2 * RIGHT + UP)        # Tâm tại (2, 1)

# set_x(), set_y(), set_z() - Đặt tọa độ riêng lẻ
square = Square()
square.set_x(3)    # x = 3, giữ nguyên y, z
square.set_y(-2)   # y = -2, giữ nguyên x, z

# to_corner() - Di chuyển đến góc
text = Text("Hello")
text.to_corner(UL)           # Góc trên trái
text.to_corner(DR, buff=0.5) # Góc dưới phải, cách biên 0.5

# to_edge() - Di chuyển đến cạnh
formula = MathTex("E = mc^2")
formula.to_edge(UP)            # Cạnh trên
formula.to_edge(LEFT, buff=1)  # Cạnh trái, cách 1 unit
```

### 2.2 Relative Positioning
```python
# next_to() - Đặt cạnh đối tượng khác
label = Text("A")
point = Dot(ORIGIN)
label.next_to(point, UP)           # Phía trên point
label.next_to(point, UR, buff=0.2) # Trên-phải, cách 0.2
label.next_to(point, RIGHT, buff=0, aligned_edge=DOWN)  # Căn đáy

# shift() - Dịch chuyển tương đối
obj = Circle()
obj.shift(2 * RIGHT)           # Dịch phải 2 units
obj.shift(UP + 0.5 * LEFT)     # Dịch lên và trái

# align_to() - Căn chỉnh với đối tượng khác
rect1 = Rectangle()
rect2 = Rectangle().shift(2*RIGHT)
rect2.align_to(rect1, UP)    # Căn cạnh trên
rect2.align_to(rect1, LEFT)  # Căn cạnh trái
```

### 2.3 Center-Based Methods
```python
# get_center() - Lấy tâm đối tượng
center = circle.get_center()

# get_top(), get_bottom(), get_left(), get_right()
top_point = square.get_top()      # Điểm trên cùng
bottom_point = square.get_bottom()

# get_corner()
ul_corner = rect.get_corner(UL)   # Góc trên trái
dr_corner = rect.get_corner(DR)   # Góc dưới phải

# get_edge_center()
left_edge = rect.get_edge_center(LEFT)   # Tâm cạnh trái
right_edge = rect.get_edge_center(RIGHT) # Tâm cạnh phải
```

## 3. Relative Object Placement

### 3.1 Cách Đặt Label Cho Đỉnh
```python
def label_vertex(point, label_text, direction=None, buff=0.2):
    """
    Đặt label cho đỉnh với hướng tự động
    """
    if direction is None:
        # Tự động chọn hướng dựa trên vị trí
        if point[0] > 0:
            direction = RIGHT
        else:
            direction = LEFT
        if point[1] > 0:
            direction += UP
        else:
            direction += DOWN

    label = MathTex(label_text, font_size=36)
    label.next_to(point, direction, buff=buff)
    return label

# Ví dụ sử dụng
A = np.array([0, 2, 0])
B = np.array([-2, -1, 0])
C = np.array([2, -1, 0])

label_A = label_vertex(A, "A")        # Auto: UP
label_B = label_vertex(B, "B", LEFT)  # Manual: LEFT
label_C = label_vertex(C, "C", RIGHT) # Manual: RIGHT
```

### 3.2 Angle Labels Positioning
```python
def get_angle_label_position(vertex, p1, p2, radius_factor=2.5):
    """
    Tính vị trí label góc nằm trong góc

    Args:
        vertex: Đỉnh của góc
        p1, p2: Hai điểm tạo góc
        radius_factor: Hệ số khoảng cách từ đỉnh
    """
    # Vector đơn vị từ đỉnh đến p1 và p2
    v1 = (p1 - vertex) / np.linalg.norm(p1 - vertex)
    v2 = (p2 - vertex) / np.linalg.norm(p2 - vertex)

    # Bisector direction
    bisector = v1 + v2
    if np.linalg.norm(bisector) < 1e-6:
        bisector = np.array([v1[1], -v1[0], 0])  # Perpendicular
    bisector = bisector / np.linalg.norm(bisector)

    # Label position
    label_pos = vertex + radius_factor * 0.3 * bisector
    return label_pos

# Ví dụ: Label góc A trong tam giác ABC
A, B, C = np.array([0, 2, 0]), np.array([-2, -1, 0]), np.array([2, -1, 0])
alpha_pos = get_angle_label_position(A, B, C)
alpha = MathTex(r"\alpha").move_to(alpha_pos)
```

### 3.3 Midpoint Labels
```python
def label_segment(p1, p2, label_text, perpendicular_offset=0.3):
    """
    Đặt label cho đoạn thẳng ở giữa, cách đường một khoảng
    """
    midpoint = (p1 + p2) / 2

    # Vector pháp tuyến của đoạn thẳng
    direction = p2 - p1
    normal = np.array([-direction[1], direction[0], 0])
    normal = normal / np.linalg.norm(normal)

    label_pos = midpoint + perpendicular_offset * normal
    label = MathTex(label_text, font_size=28)
    label.move_to(label_pos)
    return label

# Ví dụ
side_label = label_segment(A, B, "c")
```

## 4. Coordinate Transformations

### 4.1 Scale và Rotate
```python
# scale() - Phóng to/thu nhỏ
triangle = Polygon(A, B, C)
triangle.scale(2)              # Phóng to 2 lần từ tâm
triangle.scale(0.5, about_point=A)  # Thu nhỏ quanh A

# rotate() - Xoay
square = Square()
square.rotate(PI/4)            # Xoay 45° quanh tâm
square.rotate(PI/6, about_point=ORIGIN)  # Xoay quanh gốc
square.rotate(PI/3, axis=RIGHT)  # Xoay quanh trục X

# flip() - Lật
arrow = Arrow(LEFT, RIGHT)
arrow.flip(UP)    # Lật theo trục Y
arrow.flip(RIGHT) # Lật theo trục X
```

### 4.2 Stretch và Warp
```python
# stretch() - Kéo giãn theo một hướng
ellipse = Circle()
ellipse.stretch(2, dim=0)   # Kéo giãn 2x theo X (thành ellipse)
ellipse.stretch(0.5, dim=1) # Nén 0.5x theo Y

# apply_matrix() - Áp dụng biến đổi ma trận
shear_matrix = [[1, 0.5, 0],
                [0, 1, 0],
                [0, 0, 1]]
shape.apply_matrix(shear_matrix)
```

## 5. VGroup Positioning

### 5.1 Arrange Methods
```python
# arrange() - Sắp xếp các phần tử
items = VGroup(
    Circle(radius=0.3),
    Square(side_length=0.5),
    Triangle()
)

# Sắp xếp ngang
items.arrange(RIGHT, buff=0.5)

# Sắp xếp dọc
items.arrange(DOWN, buff=0.3)

# Căn chỉnh theo cạnh
items.arrange(RIGHT, aligned_edge=DOWN)

# arrange_in_grid() - Sắp xếp theo lưới
grid = VGroup(*[Circle(radius=0.2) for _ in range(12)])
grid.arrange_in_grid(rows=3, cols=4, buff=0.3)
```

### 5.2 VGroup Positioning
```python
group = VGroup(circle, square, triangle)

# Positioning toàn bộ group
group.center()              # Di chuyển tâm group về ORIGIN
group.to_corner(UL)         # Group đến góc trên trái
group.shift(2 * DOWN)       # Dịch toàn bộ group

# Positioning từng phần tử
for i, mob in enumerate(group):
    mob.move_to(i * RIGHT)  # Đặt phần tử i tại (i, 0)

# next_to cho group
label = Text("Shapes")
label.next_to(group, UP)    # Label phía trên group
```

## 6. Camera và Frame

### 6.1 Camera Movement (MovingCameraScene)
```python
class ZoomExample(MovingCameraScene):
    def construct(self):
        circle = Circle()
        self.add(circle)

        # Zoom in
        self.play(self.camera.frame.animate.scale(0.5))

        # Pan
        self.play(self.camera.frame.animate.move_to(2 * RIGHT))

        # Zoom out và di chuyển
        self.play(
            self.camera.frame.animate.scale(2).move_to(ORIGIN)
        )
```

### 6.2 Frame Scaling cho Different Resolutions
```python
# Tự động scale để fit frame
def fit_to_frame(mobject, margin=0.5):
    """Scale object để vừa frame với margin"""
    frame_width = config.frame_width - 2 * margin
    frame_height = config.frame_height - 2 * margin

    obj_width = mobject.get_width()
    obj_height = mobject.get_height()

    scale_x = frame_width / obj_width if obj_width > 0 else 1
    scale_y = frame_height / obj_height if obj_height > 0 else 1
    scale = min(scale_x, scale_y, 1)  # Không phóng to quá 1x

    mobject.scale(scale)
    mobject.center()
    return mobject
```

## 7. Patterns Thường Dùng

### 7.1 Triangle với Labels Chuẩn
```python
def create_labeled_triangle(A, B, C, labels=("A", "B", "C")):
    """Tạo tam giác với labels đặt đúng vị trí"""
    triangle = Polygon(A, B, C, color=WHITE, stroke_width=2)

    # Tâm tam giác để xác định hướng label
    centroid = (A + B + C) / 3

    def get_label_direction(vertex):
        """Label hướng ra ngoài tam giác"""
        direction = vertex - centroid
        return direction / np.linalg.norm(direction)

    label_A = MathTex(labels[0]).next_to(A, get_label_direction(A), buff=0.2)
    label_B = MathTex(labels[1]).next_to(B, get_label_direction(B), buff=0.2)
    label_C = MathTex(labels[2]).next_to(C, get_label_direction(C), buff=0.2)

    return VGroup(triangle, label_A, label_B, label_C)
```

### 7.2 Parallel Line Through Point
```python
def parallel_line_through(point, reference_line, length=7):
    """
    Vẽ đường thẳng song song với reference_line đi qua point
    """
    # Lấy direction của reference line
    direction = reference_line.get_end() - reference_line.get_start()
    direction = direction / np.linalg.norm(direction)

    start = point - (length/2) * direction
    end = point + (length/2) * direction

    return Line(start, end)

# Ví dụ
BC = Line(B, C)
parallel = parallel_line_through(A, BC, length=6)
```

### 7.3 Perpendicular từ Point đến Line
```python
def perpendicular_foot(point, line_start, line_end):
    """Tìm chân đường vuông góc từ point đến line"""
    line_vec = line_end - line_start
    point_vec = point - line_start

    # Project point_vec onto line_vec
    t = np.dot(point_vec, line_vec) / np.dot(line_vec, line_vec)
    foot = line_start + t * line_vec

    return foot

def draw_altitude(vertex, opposite_start, opposite_end, show_right_angle=True):
    """Vẽ đường cao từ vertex đến cạnh đối diện"""
    foot = perpendicular_foot(vertex, opposite_start, opposite_end)
    altitude = Line(vertex, foot, color=YELLOW)

    elements = [altitude]

    if show_right_angle:
        # Vẽ góc vuông
        right_angle = RightAngle(
            Line(foot, vertex),
            Line(foot, opposite_end),
            length=0.2,
            color=YELLOW
        )
        elements.append(right_angle)

    return VGroup(*elements), foot
```

## 8. Best Practices

### 8.1 Consistency
```python
# Định nghĩa constants cho project
VERTEX_BUFF = 0.25      # Khoảng cách label - đỉnh
ANGLE_RADIUS = 0.4      # Bán kính cung góc
LABEL_SIZE = 32         # Font size chuẩn
LINE_WIDTH = 2          # Độ dày nét vẽ
```

### 8.2 Avoid Magic Numbers
```python
# ❌ Không tốt
label.move_to(np.array([1.5, 2.3, 0]))

# ✅ Tốt hơn
label.next_to(vertex, UP + RIGHT, buff=0.25)

# ❌ Không tốt
circle.shift(np.array([2.5, 0, 0]))

# ✅ Tốt hơn
circle.next_to(square, RIGHT, buff=0.5)
```

### 8.3 Responsive Design
```python
# Tính toán dựa trên kích thước đối tượng, không hardcode
def responsive_layout(main_object, annotation):
    """Layout tự động điều chỉnh theo kích thước"""
    main_width = main_object.get_width()

    # Scale annotation nếu cần
    if annotation.get_width() > main_width * 0.8:
        annotation.scale_to_fit_width(main_width * 0.8)

    # Đặt annotation phía dưới
    annotation.next_to(main_object, DOWN, buff=0.3)

    # Center cả hai
    group = VGroup(main_object, annotation)
    group.center()

    return group
```
