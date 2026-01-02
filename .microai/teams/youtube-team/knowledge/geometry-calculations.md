# Geometry Calculations for Manim

## 1. Các Điểm Đặc Biệt Trong Tam Giác

### 1.1 Trọng Tâm (Centroid)
```python
def centroid(A, B, C):
    """
    Trọng tâm: Giao điểm 3 đường trung tuyến
    Chia mỗi trung tuyến theo tỷ lệ 2:1 từ đỉnh
    """
    return (A + B + C) / 3

# Ví dụ
A = np.array([0, 3, 0])
B = np.array([-2, -1, 0])
C = np.array([3, -1, 0])
G = centroid(A, B, C)  # [0.333, 0.333, 0]
```

### 1.2 Tâm Đường Tròn Ngoại Tiếp (Circumcenter)
```python
def circumcenter(A, B, C):
    """
    Tâm đường tròn ngoại tiếp: Giao điểm 3 đường trung trực
    Cách đều 3 đỉnh: |OA| = |OB| = |OC| = R
    """
    ax, ay = A[0], A[1]
    bx, by = B[0], B[1]
    cx, cy = C[0], C[1]

    d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))

    if abs(d) < 1e-10:
        raise ValueError("3 điểm thẳng hàng")

    ux = ((ax**2 + ay**2) * (by - cy) +
          (bx**2 + by**2) * (cy - ay) +
          (cx**2 + cy**2) * (ay - by)) / d

    uy = ((ax**2 + ay**2) * (cx - bx) +
          (bx**2 + by**2) * (ax - cx) +
          (cx**2 + cy**2) * (bx - ax)) / d

    return np.array([ux, uy, 0])

def circumradius(A, B, C):
    """Bán kính đường tròn ngoại tiếp"""
    O = circumcenter(A, B, C)
    return np.linalg.norm(A - O)
```

### 1.3 Tâm Đường Tròn Nội Tiếp (Incenter)
```python
def incenter(A, B, C):
    """
    Tâm đường tròn nội tiếp: Giao điểm 3 đường phân giác
    Cách đều 3 cạnh: khoảng cách đến 3 cạnh bằng nhau = r
    """
    # Độ dài các cạnh
    a = np.linalg.norm(C - B)  # BC
    b = np.linalg.norm(A - C)  # CA
    c = np.linalg.norm(B - A)  # AB

    # Incenter = weighted average theo độ dài cạnh đối diện
    I = (a * A + b * B + c * C) / (a + b + c)
    return I

def inradius(A, B, C):
    """Bán kính đường tròn nội tiếp: r = S / p"""
    # Chu vi
    a = np.linalg.norm(C - B)
    b = np.linalg.norm(A - C)
    c = np.linalg.norm(B - A)
    p = (a + b + c) / 2  # Nửa chu vi

    # Diện tích (Heron)
    S = np.sqrt(p * (p - a) * (p - b) * (p - c))

    return S / p
```

### 1.4 Trực Tâm (Orthocenter)
```python
def orthocenter(A, B, C):
    """
    Trực tâm: Giao điểm 3 đường cao
    H = A + B + C - 2*O (O là circumcenter)
    """
    O = circumcenter(A, B, C)
    H = A + B + C - 2 * O
    return H

# Cách khác: Tính giao 2 đường cao
def orthocenter_v2(A, B, C):
    """Tính bằng giao điểm 2 đường cao"""
    # Đường cao từ A đến BC
    foot_A = perpendicular_foot(A, B, C)
    # Đường cao từ B đến AC
    foot_B = perpendicular_foot(B, A, C)

    # Giao điểm 2 đường cao
    return line_intersection_extended(A, foot_A, B, foot_B)
```

### 1.5 Chân Đường Cao (Altitude Foot)
```python
def perpendicular_foot(P, A, B):
    """
    Chân đường vuông góc từ P đến đường thẳng AB
    """
    AB = B - A
    AP = P - A

    # Chiếu AP lên AB
    t = np.dot(AP, AB) / np.dot(AB, AB)

    # Chân đường vuông góc
    foot = A + t * AB
    return foot

# Ví dụ: Chân đường cao từ A đến BC
A = np.array([0, 3, 0])
B = np.array([-2, -1, 0])
C = np.array([3, -1, 0])
D = perpendicular_foot(A, B, C)  # Chân đường cao
```

### 1.6 Tâm Đường Tròn 9 Điểm (Nine-Point Circle)
```python
def nine_point_center(A, B, C):
    """
    Tâm đường tròn 9 điểm (Euler circle)
    N = trung điểm của O và H
    """
    O = circumcenter(A, B, C)
    H = orthocenter(A, B, C)
    N = (O + H) / 2
    return N

def nine_point_radius(A, B, C):
    """Bán kính đường tròn 9 điểm = R/2"""
    return circumradius(A, B, C) / 2

def nine_points(A, B, C):
    """
    9 điểm trên đường tròn 9 điểm:
    - 3 trung điểm các cạnh
    - 3 chân đường cao
    - 3 trung điểm AH, BH, CH (H là trực tâm)
    """
    H = orthocenter(A, B, C)

    # 3 trung điểm cạnh
    M_AB = (A + B) / 2
    M_BC = (B + C) / 2
    M_CA = (C + A) / 2

    # 3 chân đường cao
    D = perpendicular_foot(A, B, C)
    E = perpendicular_foot(B, C, A)
    F = perpendicular_foot(C, A, B)

    # 3 trung điểm từ đỉnh đến trực tâm
    M_AH = (A + H) / 2
    M_BH = (B + H) / 2
    M_CH = (C + H) / 2

    return [M_AB, M_BC, M_CA, D, E, F, M_AH, M_BH, M_CH]
```

## 2. Đường Thẳng và Giao Điểm

### 2.1 Giao Điểm 2 Đường Thẳng
```python
def line_intersection(P1, P2, P3, P4):
    """
    Giao điểm của đường thẳng P1P2 và P3P4
    Returns None nếu song song
    """
    x1, y1 = P1[0], P1[1]
    x2, y2 = P2[0], P2[1]
    x3, y3 = P3[0], P3[1]
    x4, y4 = P4[0], P4[1]

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    if abs(denom) < 1e-10:
        return None  # Song song hoặc trùng

    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom

    x = x1 + t * (x2 - x1)
    y = y1 + t * (y2 - y1)

    return np.array([x, y, 0])
```

### 2.2 Đường Thẳng Song Song
```python
def parallel_line(point, line_start, line_end):
    """
    Đường thẳng qua point song song với line
    """
    direction = line_end - line_start
    direction = direction / np.linalg.norm(direction)
    return point - 3 * direction, point + 3 * direction

# Ví dụ: Đường thẳng qua A song song với BC
A = np.array([0, 3, 0])
B = np.array([-2, -1, 0])
C = np.array([3, -1, 0])
P1, P2 = parallel_line(A, B, C)
parallel = Line(P1, P2)
```

### 2.3 Đường Trung Trực
```python
def perpendicular_bisector(A, B, length=6):
    """
    Đường trung trực của đoạn AB
    """
    midpoint = (A + B) / 2
    direction = B - A
    # Vuông góc với AB
    perp = np.array([-direction[1], direction[0], 0])
    perp = perp / np.linalg.norm(perp)

    start = midpoint - (length/2) * perp
    end = midpoint + (length/2) * perp
    return start, end

# Sử dụng
start, end = perpendicular_bisector(A, B)
perp_bisector = Line(start, end, color=BLUE)
```

### 2.4 Đường Phân Giác
```python
def angle_bisector(vertex, P1, P2, length=3):
    """
    Đường phân giác của góc P1-vertex-P2
    """
    # Vectors đơn vị từ vertex
    v1 = (P1 - vertex) / np.linalg.norm(P1 - vertex)
    v2 = (P2 - vertex) / np.linalg.norm(P2 - vertex)

    # Bisector direction
    bisector = v1 + v2
    bisector = bisector / np.linalg.norm(bisector)

    end = vertex + length * bisector
    return vertex, end

# Ví dụ: Phân giác góc A
A, B, C = vertices
start, end = angle_bisector(A, B, C)
bisector = Line(start, end, color=YELLOW)
```

## 3. Đường Tròn

### 3.1 Giao Điểm Đường Thẳng và Đường Tròn
```python
def line_circle_intersection(P1, P2, center, radius):
    """
    Giao điểm của đường thẳng P1P2 với đường tròn (center, radius)
    Returns: list of 0, 1, or 2 points
    """
    # Chuyển về bài toán parametric: P = P1 + t*(P2-P1)
    d = P2 - P1
    f = P1 - center

    a = np.dot(d[:2], d[:2])
    b = 2 * np.dot(f[:2], d[:2])
    c = np.dot(f[:2], f[:2]) - radius**2

    discriminant = b**2 - 4*a*c

    if discriminant < 0:
        return []
    elif abs(discriminant) < 1e-10:
        t = -b / (2*a)
        return [P1 + t * d]
    else:
        sqrt_disc = np.sqrt(discriminant)
        t1 = (-b - sqrt_disc) / (2*a)
        t2 = (-b + sqrt_disc) / (2*a)
        return [P1 + t1 * d, P1 + t2 * d]

# Ví dụ: Đường cao từ A cắt đường tròn ngoại tiếp tại K
O = circumcenter(A, B, C)
R = circumradius(A, B, C)
D = perpendicular_foot(A, B, C)  # Chân đường cao

intersections = line_circle_intersection(A, D, O, R)
# intersections[0] = A (đỉnh), intersections[1] = K (điểm còn lại)
```

### 3.2 Giao Điểm 2 Đường Tròn
```python
def circle_circle_intersection(c1, r1, c2, r2):
    """
    Giao điểm của 2 đường tròn
    Returns: list of 0, 1, or 2 points
    """
    d = np.linalg.norm(c2 - c1)

    if d > r1 + r2 + 1e-10:  # Rời nhau
        return []
    if d < abs(r1 - r2) - 1e-10:  # Lồng nhau
        return []
    if d < 1e-10:  # Đồng tâm
        return []

    a = (r1**2 - r2**2 + d**2) / (2*d)
    h_sq = r1**2 - a**2

    if h_sq < 0:
        return []

    h = np.sqrt(h_sq)

    # Điểm P trên đường nối tâm
    P = c1 + a * (c2 - c1) / d

    # Vector vuông góc
    perp = np.array([-(c2 - c1)[1], (c2 - c1)[0], 0]) / d

    if abs(h) < 1e-10:  # Tiếp xúc
        return [P]
    else:
        return [P + h * perp, P - h * perp]
```

### 3.3 Tiếp Tuyến từ Điểm Ngoài
```python
def tangent_points(external_point, center, radius):
    """
    Điểm tiếp xúc từ điểm ngoài đến đường tròn
    """
    P = external_point[:2]
    O = center[:2]

    d = np.linalg.norm(P - O)
    if d <= radius:
        return []  # Điểm trong hoặc trên đường tròn

    # Khoảng cách từ O đến tiếp tuyến
    angle = np.arcsin(radius / d)

    # Góc của OP
    base_angle = np.arctan2(P[1] - O[1], P[0] - O[0])

    # 2 điểm tiếp xúc
    t1 = base_angle + np.pi/2 - angle
    t2 = base_angle - np.pi/2 + angle

    T1 = center + radius * np.array([np.cos(t1), np.sin(t1), 0])
    T2 = center + radius * np.array([np.cos(t2), np.sin(t2), 0])

    return [T1, T2]
```

## 4. Góc và Cung

### 4.1 Tính Góc giữa 2 Vector
```python
def angle_between(v1, v2):
    """Góc giữa 2 vector (radians)"""
    cos_angle = np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))
    cos_angle = np.clip(cos_angle, -1, 1)  # Tránh lỗi floating point
    return np.arccos(cos_angle)

def signed_angle(v1, v2):
    """Góc có dấu từ v1 đến v2 (theo chiều ngược kim đồng hồ)"""
    angle = np.arctan2(v2[1], v2[0]) - np.arctan2(v1[1], v1[0])
    if angle > np.pi:
        angle -= 2 * np.pi
    elif angle < -np.pi:
        angle += 2 * np.pi
    return angle
```

### 4.2 Góc trong Tam Giác
```python
def triangle_angles(A, B, C):
    """
    Tính 3 góc của tam giác ABC
    Returns: (angle_A, angle_B, angle_C) in radians
    """
    # Vectors từ mỗi đỉnh
    AB = B - A
    AC = C - A
    BA = A - B
    BC = C - B
    CA = A - C
    CB = B - C

    angle_A = angle_between(AB, AC)
    angle_B = angle_between(BA, BC)
    angle_C = angle_between(CA, CB)

    return angle_A, angle_B, angle_C

# Ví dụ
angles = triangle_angles(A, B, C)
print(f"Góc A: {np.degrees(angles[0]):.1f}°")
print(f"Góc B: {np.degrees(angles[1]):.1f}°")
print(f"Góc C: {np.degrees(angles[2]):.1f}°")
print(f"Tổng: {np.degrees(sum(angles)):.1f}°")  # 180°
```

### 4.3 Góc Nội Tiếp và Góc ở Tâm
```python
def inscribed_angle(A, B, C, center, radius):
    """
    Góc nội tiếp ABC (A, B, C trên đường tròn, B là đỉnh góc)
    Góc nội tiếp = 1/2 góc ở tâm
    """
    BA = A - B
    BC = C - B
    return angle_between(BA, BC)

def central_angle(A, C, center):
    """Góc ở tâm chắn cung AC"""
    OA = A - center
    OC = C - center
    return angle_between(OA, OC)
```

## 5. Diện Tích và Chu Vi

### 5.1 Diện Tích Tam Giác
```python
def triangle_area(A, B, C):
    """Diện tích tam giác bằng cross product"""
    AB = B - A
    AC = C - A
    cross = np.cross(AB[:2], AC[:2])
    return abs(cross) / 2

def triangle_area_heron(a, b, c):
    """Diện tích theo công thức Heron (biết 3 cạnh)"""
    p = (a + b + c) / 2  # Nửa chu vi
    return np.sqrt(p * (p-a) * (p-b) * (p-c))
```

### 5.2 Diện Tích Đa Giác (Shoelace Formula)
```python
def polygon_area(vertices):
    """
    Diện tích đa giác bằng Shoelace formula
    vertices: list of np.array points
    """
    n = len(vertices)
    area = 0
    for i in range(n):
        j = (i + 1) % n
        area += vertices[i][0] * vertices[j][1]
        area -= vertices[j][0] * vertices[i][1]
    return abs(area) / 2

# Ví dụ: Diện tích hình vuông
square_vertices = [
    np.array([0, 0, 0]),
    np.array([2, 0, 0]),
    np.array([2, 2, 0]),
    np.array([0, 2, 0])
]
print(polygon_area(square_vertices))  # 4.0
```

## 6. Phép Biến Hình

### 6.1 Phép Đối Xứng Qua Đường Thẳng
```python
def reflect_point(P, line_start, line_end):
    """Đối xứng điểm P qua đường thẳng"""
    # Chân đường vuông góc
    foot = perpendicular_foot(P, line_start, line_end)
    # Điểm đối xứng
    return 2 * foot - P

# Ví dụ: Đối xứng A qua BC
A_reflect = reflect_point(A, B, C)
```

### 6.2 Phép Quay
```python
def rotate_point(P, center, angle):
    """Quay điểm P quanh center góc angle (radians)"""
    cos_a = np.cos(angle)
    sin_a = np.sin(angle)

    # Translate to origin
    translated = P - center

    # Rotate
    rotated = np.array([
        translated[0] * cos_a - translated[1] * sin_a,
        translated[0] * sin_a + translated[1] * cos_a,
        0
    ])

    # Translate back
    return rotated + center

# Ví dụ: Quay A quanh O góc 60°
A_rotated = rotate_point(A, ORIGIN, np.radians(60))
```

### 6.3 Phép Vị Tự (Homothety)
```python
def homothety(P, center, k):
    """
    Phép vị tự tâm center tỷ số k
    k > 1: Phóng to
    0 < k < 1: Thu nhỏ
    k < 0: Phóng to/nhỏ + đối xứng qua tâm
    """
    return center + k * (P - center)

# Ví dụ: Phóng to tam giác gấp 2 từ tâm G
G = centroid(A, B, C)
A2 = homothety(A, G, 2)
B2 = homothety(B, G, 2)
C2 = homothety(C, G, 2)
```

## 7. Công Thức Hữu Ích

### 7.1 Đường Euler
```python
def euler_line_points(A, B, C):
    """
    Đường Euler đi qua: O (circumcenter), G (centroid), H (orthocenter)
    G chia OH theo tỷ lệ 1:2
    """
    O = circumcenter(A, B, C)
    G = centroid(A, B, C)
    H = orthocenter(A, B, C)

    # Verify: G chia OH theo tỷ lệ 1:2
    assert np.allclose(G, O + (H - O) / 3)

    return O, G, H

def euler_line(A, B, C, length=8):
    """Trả về Line object cho đường Euler"""
    O, G, H = euler_line_points(A, B, C)
    direction = H - O
    direction = direction / np.linalg.norm(direction)

    start = O - (length/2) * direction
    end = O + (length/2) * direction
    return Line(start, end, color=PURPLE)
```

### 7.2 Công Thức Stewart
```python
def stewart_theorem_check(A, B, C, D):
    """
    Kiểm tra định lý Stewart
    D nằm trên BC
    AB² × DC + AC² × BD - AD² × BC = BC × BD × DC
    """
    AB = np.linalg.norm(B - A)
    AC = np.linalg.norm(C - A)
    AD = np.linalg.norm(D - A)
    BD = np.linalg.norm(D - B)
    DC = np.linalg.norm(C - D)
    BC = np.linalg.norm(C - B)

    lhs = AB**2 * DC + AC**2 * BD - AD**2 * BC
    rhs = BC * BD * DC

    return np.isclose(lhs, rhs)
```

### 7.3 Power of a Point
```python
def power_of_point(P, center, radius):
    """
    Phương tích của điểm P đối với đường tròn
    > 0: P ngoài đường tròn
    = 0: P trên đường tròn
    < 0: P trong đường tròn
    """
    d = np.linalg.norm(P - center)
    return d**2 - radius**2
```

## 8. Utility Functions cho Manim

### 8.1 Tạo Đường Tròn Qua 3 Điểm
```python
def circle_through_points(A, B, C):
    """Tạo Circle object đi qua 3 điểm"""
    center = circumcenter(A, B, C)
    radius = circumradius(A, B, C)
    return Circle(radius=radius, color=BLUE).move_to(center)
```

### 8.2 Tạo Arc Chắn Cung
```python
def arc_between_points(A, B, center, radius, color=YELLOW):
    """Tạo Arc từ A đến B trên đường tròn (center, radius)"""
    start_angle = np.arctan2(A[1] - center[1], A[0] - center[0])
    end_angle = np.arctan2(B[1] - center[1], B[0] - center[0])

    angle = end_angle - start_angle
    if angle < 0:
        angle += 2 * np.pi

    return Arc(
        radius=radius,
        start_angle=start_angle,
        angle=angle,
        arc_center=center,
        color=color
    )
```

### 8.3 Verify Point on Circle
```python
def verify_on_circle(P, center, radius, tolerance=1e-10):
    """Kiểm tra P có nằm trên đường tròn không"""
    d = np.linalg.norm(P - center)
    return abs(d - radius) < tolerance
```
