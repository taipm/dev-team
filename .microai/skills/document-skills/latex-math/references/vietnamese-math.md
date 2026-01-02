# Vietnamese Math Typesetting

## Preamble Setup

### Minimal Vietnamese Support

```latex
\documentclass[12pt,a4paper]{article}

% XeLaTeX Vietnamese support
\usepackage{fontspec}
\usepackage[vietnamese]{babel}
\setmainfont{Times New Roman}
```

### Full Setup with Fonts

```latex
\documentclass[12pt,a4paper]{article}

% Font configuration
\usepackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial}
\setmonofont{Courier New}

% Vietnamese language
\usepackage[vietnamese]{babel}

% Fallback if fonts not available
% \setmainfont{Latin Modern Roman}
```

## Theorem Environments

### Vietnamese Theorem Names

```latex
\usepackage{amsthm}

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

### Usage

```latex
\begin{theorem}[Cauchy-Schwarz]
Với mọi $a_i, b_i \in \mathbb{R}$:
\[\left(\sum a_i b_i\right)^2 \leq \left(\sum a_i^2\right)\left(\sum b_i^2\right)\]
\end{theorem}

\begin{proof}
[Chứng minh chi tiết]
\end{proof}
```

## Custom Commands

### Solution Commands

```latex
% Lời giải
\newcommand{\solution}{\noindent\textbf{Lời giải.}\quad}

% Đáp số
\newcommand{\answer}{\noindent\textbf{Đáp số:}\quad}

% Chứng minh
\newcommand{\proof}{\noindent\textbf{Chứng minh.}\quad}
```

### Math Abbreviations

```latex
% Tập hợp số
\newcommand{\N}{\mathbb{N}}  % Số tự nhiên
\newcommand{\Z}{\mathbb{Z}}  % Số nguyên
\newcommand{\Q}{\mathbb{Q}}  % Số hữu tỉ
\newcommand{\R}{\mathbb{R}}  % Số thực
\newcommand{\C}{\mathbb{C}}  % Số phức

% Ký hiệu thường dùng
\newcommand{\abs}[1]{\left|#1\right|}
\newcommand{\norm}[1]{\left\|#1\right\|}
\newcommand{\inner}[2]{\langle #1, #2 \rangle}
```

## Vietnamese Math Terminology

| English | Tiếng Việt | LaTeX |
|---------|------------|-------|
| Theorem | Định lý | `\newtheorem{theorem}{Định lý}` |
| Lemma | Bổ đề | `\newtheorem{lemma}{Bổ đề}` |
| Proposition | Mệnh đề | `\newtheorem{proposition}{Mệnh đề}` |
| Corollary | Hệ quả | `\newtheorem{corollary}{Hệ quả}` |
| Definition | Định nghĩa | `\newtheorem{definition}{Định nghĩa}` |
| Example | Ví dụ | `\newtheorem{example}{Ví dụ}` |
| Proof | Chứng minh | `\begin{proof}...\end{proof}` |
| Remark | Nhận xét | `\newtheorem{remark}{Nhận xét}` |
| Note | Lưu ý | `\newtheorem{note}{Lưu ý}` |
| Solution | Lời giải | `\solution` |
| Answer | Đáp số | `\answer` |

## Geometry Terms

| English | Tiếng Việt |
|---------|------------|
| Triangle | Tam giác |
| Circle | Đường tròn |
| Circumcircle | Đường tròn ngoại tiếp |
| Incircle | Đường tròn nội tiếp |
| Orthocenter | Trực tâm |
| Circumcenter | Tâm đường tròn ngoại tiếp |
| Altitude | Đường cao |
| Median | Đường trung tuyến |
| Perpendicular bisector | Đường trung trực |
| Angle bisector | Đường phân giác |

## Formatting Tips

### Boxed Answers

```latex
\[\boxed{x = 5}\]
```

### Colored Boxes (tcolorbox)

```latex
\usepackage{tcolorbox}

\begin{tcolorbox}[title=Định lý quan trọng]
Nội dung định lý...
\end{tcolorbox}
```

### Two-Column Layout

```latex
\begin{multicols}{2}
Cột 1...
\columnbreak
Cột 2...
\end{multicols}
```

## Headers & Footers

```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\lhead{Toán học}
\rhead{Lời giải chi tiết}
\cfoot{\thepage}
```

---

*LaTeX Math Skill - Vietnamese Math Reference*
