---
name: latex-math
description: "LaTeX math solution generator with XeLaTeX auto-compilation and TikZ support for geometry diagrams"
description_vi: "Tạo lời giải toán LaTeX với auto-compile PDF, hỗ trợ TikZ cho hình học"
category: document-skills
version: "1.1.0"
license: apache-2.0
tags: [latex, math, pdf, xelatex, tikz, vietnamese, olympiad, geometry]
created: "2026-01-02"
author: MicroAI Team
---

# LaTeX Math Skill

> Tạo lời giải toán học chất lượng cao với LaTeX, auto-compile PDF, và TikZ diagrams.

## Quick Start

### Tạo PDF lời giải từ bài toán

**Bước 1**: Chọn template phù hợp

```bash
# Copy template vào thư mục làm việc
cp templates/solution-detailed.tex ./main.tex
```

**Bước 2**: Điền nội dung vào template

Thay thế các placeholder:
- `{{PROBLEM_TEXT}}` - Nội dung đề bài
- `{{GIVEN}}` - Dữ kiện cho trước
- `{{FIND}}` - Yêu cầu tìm/chứng minh
- `{{FINAL_ANSWER}}` - Đáp số cuối cùng

**Bước 3**: Compile PDF

```bash
xelatex -interaction=nonstopmode main.tex
```

### Ví dụ hoàn chỉnh

```latex
\section{Đề bài}
Cho $a, b, c > 0$ và $a + b + c = 3$. Chứng minh rằng:
\[a^2 + b^2 + c^2 \geq 3\]

\section{Lời giải}
\solution
Áp dụng bất đẳng thức Cauchy-Schwarz:
\[(a^2 + b^2 + c^2)(1 + 1 + 1) \geq (a + b + c)^2 = 9\]

Suy ra: $a^2 + b^2 + c^2 \geq 3$.

\section{Kết luận}
\begin{theorem}[Đáp số]
\[\boxed{a^2 + b^2 + c^2 \geq 3}\]
\end{theorem}
```

---

## Templates

### 1. Detailed (Textbook Style)

**File**: `templates/solution-detailed.tex`

**Đặc điểm**:
- Lời giải chi tiết từng bước
- Phần phân tích đề bài
- Section kiểm tra đáp án
- So sánh nhiều cách giải
- Phần ghi nhớ

**Phù hợp cho**: Giáo trình, tài liệu học tập, hướng dẫn giải

**Cấu trúc**:
```
1. Đề bài
   └── Phân tích (Cho, Tìm, Điều kiện)
2. Lời giải
   └── Bước 1, 2, 3... với nhận xét
3. Kết luận (boxed answer)
4. Kiểm tra
5. So sánh các cách giải
6. Ghi nhớ
```

### 2. Concise (Paper Style)

**File**: `templates/solution-concise.tex`

**Đặc điểm**:
- Ngắn gọn, chuyên nghiệp
- Chỉ có: Bài toán → Lời giải → Đáp số
- Không header/footer phức tạp

**Phù hợp cho**: Bài nộp, báo cáo, thi cử

**Cấu trúc**:
```
BÀI TOÁN VÀ LỜI GIẢI
────────────────────
Bài toán. [nội dung]
Lời giải. [các bước]
Đáp số. [boxed answer]
```

### 3. Olympiad (Competition Style)

**File**: `templates/solution-olympiad.tex`

**Đặc điểm**:
- Trick boxes highlight key insights
- Đánh giá độ khó
- Thời gian ước lượng
- Các cách giải khác
- Phần mở rộng

**Phù hợp cho**: Luyện thi Olympic, HSG, đề thi

**Cấu trúc**:
```
[Loại bài] | [Độ khó]
═══════════════════
Đề bài
┌─────────────────────┐
│ Trick quan trọng    │
│ • Hướng tiếp cận    │
│ • Key insight       │
└─────────────────────┘
Lời giải (với bước quan trọng highlight)
Đáp số
Bình luận (kỹ thuật, độ khó, dạng tương tự)
Cách giải khác
Mở rộng
```

---

## TikZ Geometry Diagrams

Skill này bao gồm thư viện TikZ patterns cho hình học. Xem chi tiết tại `references/tikz-patterns.md`.

### Triangle cơ bản

```latex
\begin{tikzpicture}[scale=1.2]
    \coordinate (A) at (0, 3.5);
    \coordinate (B) at (-2, 0);
    \coordinate (C) at (2.5, 0);

    \draw[thick] (A) -- (B) -- (C) -- cycle;

    \node[above] at (A) {$A$};
    \node[below left] at (B) {$B$};
    \node[below right] at (C) {$C$};
\end{tikzpicture}
```

### Circumcircle với tâm O

```latex
\coordinate (O) at (0.25, 1.2);
\def\R{2.8}
\draw[blue, thick] (O) circle[radius=\R];
```

### Chân đường cao

```latex
% D là chân đường cao từ A xuống BC
\coordinate (D) at ($(B)!(A)!(C)$);
```

### Nine-Point Circle

```latex
% Tâm N là trung điểm của OH
\coordinate (N) at ($(O)!0.5!(H)$);
% Bán kính = R/2
\pgfmathsetmacro{\r}{\R/2}
\draw[purple, dashed] (N) circle[radius=\r];
```

---

## Compilation

### XeLaTeX (Recommended)

```bash
# Single pass
xelatex -interaction=nonstopmode main.tex

# With references (2 passes)
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

### LuaLaTeX (Fallback)

```bash
lualatex -interaction=nonstopmode main.tex
```

### Compilation với output directory

```bash
mkdir -p output
xelatex -output-directory=output main.tex
```

### Xử lý lỗi thường gặp

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| `Font not found` | Thiếu Times New Roman | Cài font hoặc đổi sang Latin Modern |
| `Undefined control sequence` | Thiếu package | Thêm `\usepackage{...}` |
| `Missing $ inserted` | Công thức thiếu dấu $ | Bọc trong `$...$` hoặc `\[...\]` |
| `Extra }` | Thiếu ngoặc mở | Kiểm tra lại ngoặc |

Xem chi tiết tại `references/compilation.md`.

---

## Vietnamese Support

### Preamble chuẩn

```latex
\documentclass[12pt,a4paper]{article}

% XeLaTeX Vietnamese support
\usepackage{fontspec}
\usepackage[vietnamese]{babel}
\setmainfont{Times New Roman}
\setsansfont{Arial}
\setmonofont{Courier New}
```

### Theorem environments tiếng Việt

```latex
\theoremstyle{definition}
\newtheorem{theorem}{Định lý}[section]
\newtheorem{lemma}[theorem]{Bổ đề}
\newtheorem{proposition}[theorem]{Mệnh đề}
\newtheorem{corollary}[theorem]{Hệ quả}
\newtheorem{definition}{Định nghĩa}[section]
\newtheorem{example}{Ví dụ}[section]

\theoremstyle{remark}
\newtheorem{remark}{Nhận xét}
\newtheorem{note}{Lưu ý}
```

### Custom commands

```latex
\newcommand{\solution}{\noindent\textbf{Lời giải.}\quad}
\newcommand{\answer}{\noindent\textbf{Đáp số:}\quad}
```

Xem chi tiết tại `references/vietnamese-math.md`.

---

## Package Reference

### Math Packages

```latex
\usepackage{amsmath}     % Extended math
\usepackage{amssymb}     % Math symbols
\usepackage{amsthm}      % Theorem environments
\usepackage{mathtools}   % Math enhancements
\usepackage{unicode-math} % Unicode math (XeLaTeX)
```

### Graphics

```latex
\usepackage{tikz}        % Diagrams
\usepackage{pgfplots}    % Function plots
\pgfplotsset{compat=1.18}

% TikZ libraries
\usetikzlibrary{calc}           % Coordinate calculations
\usetikzlibrary{intersections}  % Path intersections
\usetikzlibrary{angles,quotes}  % Angle marks
```

### Layout & Colors

```latex
\usepackage{geometry}
\geometry{margin=2.5cm}

\usepackage{xcolor}
\usepackage{tcolorbox}   % Colored boxes
\usepackage{fancyhdr}    % Headers/footers
```

---

## Workflow: Tạo lời giải hoàn chỉnh

### 1. Phân tích đề

```
Cho: [liệt kê dữ kiện]
Tìm: [yêu cầu]
Điều kiện: [ràng buộc]
```

### 2. Chọn template

- Dạy học → `solution-detailed.tex`
- Nộp bài → `solution-concise.tex`
- Luyện thi → `solution-olympiad.tex`

### 3. Viết lời giải

```latex
\section{Lời giải}
\solution
[Viết từng bước với giải thích]
```

### 4. Vẽ hình (nếu có)

```latex
\begin{center}
\begin{tikzpicture}
    % Sử dụng patterns từ tikz-patterns.md
\end{tikzpicture}
\end{center}
```

### 5. Compile & Review

```bash
xelatex main.tex
open main.pdf  # macOS
```

---

## Tips & Best Practices

### Token Efficiency

- Dùng `references/` cho patterns dài
- SKILL.md chỉ chứa quick reference
- Load templates khi cần

### LaTeX Best Practices

1. **Một section = một ý**: Không trộn nhiều ý trong một section
2. **Boxed answers**: Luôn box đáp số `\boxed{...}`
3. **Consistent notation**: Thống nhất ký hiệu xuyên suốt
4. **Right angle marks**: Luôn đánh dấu góc vuông trong hình

### Geometry Diagrams

1. Tính toán tọa độ từ constraints, không hardcode
2. Dùng `$(B)!(A)!(C)$` cho projections
3. Layering: Vẽ từ background → foreground
4. Labels: Đặt ở vị trí không overlap

### Computational Geometry (Advanced)

Khi vẽ hình học phức tạp, **KHÔNG hardcode tọa độ**. Thay vào đó:

```latex
% Chân đường cao từ A xuống BC
\coordinate (D) at ($(B)!(A)!(C)$);

% Tâm đường tròn ngoại tiếp (giao 2 đường trung trực)
\path[name path=perp1] ($(A)!0.5!(B)$) -- +($0.5*(A)-0.5*(B)+(0,1)$);
\path[name path=perp2] ($(B)!0.5!(C)$) -- +($0.5*(B)-0.5*(C)+(0,1)$);
\path[name intersections={of=perp1 and perp2, by=O}];

% Nine-point circle: tâm = trung điểm OH, bán kính = R/2
\coordinate (N) at ($(O)!0.5!(H)$);
\pgfmathsetmacro{\nineR}{\R/2}
```

Xem chi tiết tại `references/computational-geometry.md`.

---

## References

- `templates/` - 3 template files (.tex)
- `references/tikz-patterns.md` - TikZ patterns cho hình học cơ bản
- `references/computational-geometry.md` - **NEW** Tính toán hình học nâng cao
- `references/compilation.md` - Hướng dẫn compile
- `references/vietnamese-math.md` - Vietnamese typesetting

---

*LaTeX Math Skill v1.1 - Part of MicroAI Document Skills*
