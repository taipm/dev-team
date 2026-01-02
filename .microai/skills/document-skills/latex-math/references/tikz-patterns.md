# TikZ Patterns for Geometry Problems

## Overview
Các mẫu TikZ chuẩn cho các bài toán hình học từ cơ bản đến Olympic.

## 1. Basic Triangle Setup

### 1.1 Triangle with Labels
```latex
\begin{tikzpicture}[scale=1.2]
    % Vertices
    \coordinate (A) at (0, 3.5);
    \coordinate (B) at (-2, 0);
    \coordinate (C) at (2.5, 0);

    % Draw triangle
    \draw[thick] (A) -- (B) -- (C) -- cycle;

    % Vertex labels
    \node[above] at (A) {$A$};
    \node[below left] at (B) {$B$};
    \node[below right] at (C) {$C$};

    % Fill vertices
    \fill (A) circle[radius=2pt];
    \fill (B) circle[radius=2pt];
    \fill (C) circle[radius=2pt];
\end{tikzpicture}
```

### 1.2 Acute vs Obtuse Triangle
```latex
% Tam giác nhọn (acute)
\coordinate (A) at (1, 3);
\coordinate (B) at (-1.5, 0);
\coordinate (C) at (2, 0);

% Tam giác tù (obtuse) - góc tù tại B
\coordinate (A) at (2, 2);
\coordinate (B) at (-2.5, 0);
\coordinate (C) at (1, 0);
```

## 2. Circumcircle Patterns

### 2.1 Circumcircle with Center O
```latex
% Method 1: Using pgf calculations
\coordinate (A) at (0, 3.5);
\coordinate (B) at (-2, 0);
\coordinate (C) at (2.5, 0);

% Calculate circumcenter O
\coordinate (O) at ($(A)!0.5!(B)!{tan(90-atan2(\y{C}-\y{A},\x{C}-\x{A})+atan2(\y{B}-\y{A},\x{B}-\x{A}))/2}!90:(B)$);

% Or manually place for cleaner code
\coordinate (O) at (0.25, 1.2);
\def\R{2.8}

% Draw circumcircle
\draw[blue, thick] (O) circle[radius=\R];
```

### 2.2 Using Intersections Library
```latex
\usetikzlibrary{calc,intersections}

% Perpendicular bisectors method
\coordinate (M_AB) at ($(A)!0.5!(B)$);
\coordinate (M_BC) at ($(B)!0.5!(C)$);

\path[name path=perp1] (M_AB) -- ($(M_AB)!3cm!90:(B)$);
\path[name path=perp2] (M_BC) -- ($(M_BC)!3cm!90:(C)$);
\path[name intersections={of=perp1 and perp2, by=O}];
```

## 3. Orthocenter and Altitudes

### 3.1 Computing Altitude Feet
```latex
% Foot of altitude from A to BC
\coordinate (D) at ($(B)!(A)!(C)$);

% Foot of altitude from B to AC
\coordinate (E) at ($(A)!(B)!(C)$);

% Foot of altitude from C to AB
\coordinate (F) at ($(A)!(C)!(B)$);
```

### 3.2 Finding Orthocenter H
```latex
% Using intersection of two altitudes
\path[name path=alt1] (A) -- (D);
\path[name path=alt2] (B) -- (E);
\path[name intersections={of=alt1 and alt2, by=H}];
```

### 3.3 Drawing Altitudes with Right Angle Marks
```latex
% Draw altitudes
\draw[blue, thick] (A) -- (D);
\draw[blue, thick] (B) -- (E);
\draw[blue, thick] (C) -- (F);

% Right angle mark at D (size 0.15)
\draw[thin] ($(D)!0.15!(A)$) -- ++($(D)!0.15!(C)-(D)$) -- ($(D)!0.15!(C)$);

% Alternative: using pic for right angles
\pic[draw, angle radius=3mm] {right angle = A--D--C};
```

## 4. Nine-Point Circle

### 4.1 Nine Points
```latex
% 1-3: Feet of altitudes (D, E, F - already defined)

% 4-6: Midpoints of sides
\coordinate (M_A) at ($(B)!0.5!(C)$);  % Midpoint of BC (also called I)
\coordinate (M_B) at ($(A)!0.5!(C)$);  % Midpoint of AC
\coordinate (M_C) at ($(A)!0.5!(B)$);  % Midpoint of AB

% 7-9: Midpoints from vertices to orthocenter
\coordinate (H_A) at ($(A)!0.5!(H)$);
\coordinate (H_B) at ($(B)!0.5!(H)$);
\coordinate (H_C) at ($(C)!0.5!(H)$);
```

### 4.2 Nine-Point Circle
```latex
% Center N is midpoint of OH
\coordinate (N) at ($(O)!0.5!(H)$);

% Radius is half of circumradius
\pgfmathsetmacro{\r}{\R/2}

% Draw nine-point circle
\draw[purple, thick, dashed] (N) circle[radius=\r];
```

## 5. Special Points on Circumcircle

### 5.1 Point K (Altitude Extended to Circle)
```latex
% K is second intersection of AD with circumcircle
\path[name path=altitude_ext] (A) -- ($(A)!3!(D)$);
\path[name path=circumcircle] (O) circle[radius=\R];
\path[name intersections={of=altitude_ext and circumcircle, by={dummy,K}}];

% Note: K is reflection of H over BC
```

### 5.2 Arc Midpoint
```latex
% Midpoint of arc BC not containing A
\coordinate (M_arc) at ($(O)!1!-90:($(B)!0.5!(C)$)$);
% Adjust based on actual geometry
```

## 6. Cyclic Quadrilaterals

### 6.1 BCEF Inscribed (Diameter BC)
```latex
% Circle with diameter BC
\coordinate (I_BC) at ($(B)!0.5!(C)$);
\pgfmathsetmacro{\radius_BC}{veclen(\x{C}-\x{B}, \y{C}-\y{B})/2}

\draw[green!60!black, dashed] (I_BC) circle[radius=\radius_BC pt];

% Quadrilateral BCEF
\draw[green!60!black, thin] (B) -- (C) -- (E) -- (F) -- cycle;
```

### 6.2 Highlighting Cyclic Quadrilateral
```latex
% Fill with transparent color
\fill[green!10, opacity=0.5] (B) -- (C) -- (E) -- (F) -- cycle;
```

## 7. Parallel Lines

### 7.1 Drawing Parallel Lines
```latex
% If AL parallel BC
\draw[red, thick] (A) -- (L);

% Add parallel marks
\coordinate (mid_AL) at ($(A)!0.5!(L)$);
\coordinate (mid_BC) at ($(B)!0.5!(C)$);
\draw[thick] ($(mid_AL)!1mm!90:(L)$) -- ($(mid_AL)!1mm!-90:(L)$);
\draw[thick] ($(mid_AL)!2mm!90:(L)$) -- ($(mid_AL)!2mm!-90:(L)$);
% Same for BC
```

## 8. Angle Marks

### 8.1 Simple Arc Angle
```latex
% Angle at vertex A between AB and AC
\draw[->] ($(A)!0.5cm!(B)$) arc[start angle=..., end angle=..., radius=0.5cm];
```

### 8.2 Using angles Library
```latex
\usetikzlibrary{angles,quotes}

% Named angle with label
\pic[draw, "$\alpha$", angle radius=0.8cm] {angle = B--A--C};

% Equal angles (with marks)
\pic[draw, angle radius=0.6cm, pic text={$=$}] {angle = D--A--B};
\pic[draw, angle radius=0.6cm, pic text={$=$}] {angle = E--A--C};
```

## 9. Complete Example: Orthocenter Configuration

```latex
\begin{tikzpicture}[scale=1.4, font=\small,
    vertex/.style={circle, fill=red!70!black, inner sep=1.5pt},
    special/.style={circle, fill=orange, inner sep=1.5pt},
    center/.style={circle, draw=blue, fill=white, inner sep=1.5pt}
]
    % === COORDINATES ===
    % Triangle (AB < AC for this problem)
    \coordinate (A) at (1, 4);
    \coordinate (B) at (-2, 0);
    \coordinate (C) at (3.5, 0);

    % Circumcenter and radius
    \coordinate (O) at (0.75, 1.3);
    \def\R{3.1}

    % Altitude feet
    \coordinate (D) at (1, 0);
    \coordinate (E) at (2.55, 1.35);
    \coordinate (F) at (-0.35, 1.65);

    % Orthocenter
    \coordinate (H) at (1, 1.9);

    % Midpoint of BC
    \coordinate (I) at (0.75, 0);

    % K on circumcircle (extension of AD)
    \coordinate (K) at (1, -1.8);

    % Nine-point center
    \coordinate (N) at ($(O)!0.5!(H)$);

    % === DRAWING ORDER: Back to Front ===

    % 1. Circumcircle (background)
    \draw[blue!70, thick] (O) circle[radius=\R];

    % 2. Nine-point circle
    \draw[purple!70, thick, dashed] (N) circle[radius=1.55];

    % 3. Circle on diameter BC (for BCEF)
    \draw[green!50!black, thin, dashed] (I) circle[radius=2.75];

    % 4. Triangle
    \draw[red!70!black, very thick] (A) -- (B) -- (C) -- cycle;

    % 5. Altitudes
    \draw[blue!60, thick] (A) -- (D);
    \draw[blue!60, thick] (B) -- (E);
    \draw[blue!60, thick] (C) -- (F);

    % 6. Extension AD to K
    \draw[blue!60, dashed] (D) -- (K);

    % 7. Orthic triangle DEF
    \draw[orange!70, thin] (D) -- (E) -- (F) -- cycle;

    % 8. Right angle marks
    \draw[thin] ($(D)+(0,0.12)$) -- ++(0.12,0) -- ++(0,-0.12);
    \draw[thin, rotate around={-30:(E)}] ($(E)+(-0.12,0)$) -- ++(0,0.12) -- ++(0.12,0);
    \draw[thin, rotate around={55:(F)}] ($(F)+(-0.12,0)$) -- ++(0,0.12) -- ++(0.12,0);

    % === POINTS ===
    \node[vertex, label=above:$A$] at (A) {};
    \node[vertex, label=below left:$B$] at (B) {};
    \node[vertex, label=below right:$C$] at (C) {};
    \node[special, label=below:$D$] at (D) {};
    \node[special, label=right:$E$] at (E) {};
    \node[special, label=left:$F$] at (F) {};
    \node[special, label={[blue]above right:$H$}] at (H) {};
    \node[special, label=below:$I$] at (I) {};
    \node[special, label={[blue]below:$K$}] at (K) {};
    \node[center, label={[blue]below left:$O$}] at (O) {};
    \node[center, label={[purple]right:$N$}] at (N) {};

\end{tikzpicture}
```

## 10. Tips for Clean Figures

### 10.1 Label Placement
```latex
% Use directional labels to avoid overlap
\node[above] at (A) {$A$};           % Top vertex
\node[below left] at (B) {$B$};      % Bottom left
\node[below right] at (C) {$C$};     % Bottom right
\node[above right] at (H) {$H$};     % Inside triangle
\node[below] at (D) {$D$};           % On base
```

### 10.2 Layering with scope
```latex
\begin{scope}[on background layer]
    \fill[yellow!20] (A) -- (B) -- (C) -- cycle;
\end{scope}
```

### 10.3 Clipping
```latex
\begin{scope}
    \clip (O) circle[radius=\R];
    % Draw things only inside circumcircle
\end{scope}
```

## 11. Color Schemes

### 11.1 Professional (Publications)
```latex
\definecolor{main}{RGB}{0, 0, 0}         % Black
\definecolor{secondary}{RGB}{100, 100, 100} % Gray
\definecolor{accent}{RGB}{0, 0, 150}     % Dark blue
```

### 11.2 Educational (Textbooks)
```latex
\definecolor{triangle}{RGB}{192, 57, 43}     % Red
\definecolor{circle}{RGB}{41, 128, 185}      % Blue
\definecolor{auxiliary}{RGB}{39, 174, 96}    % Green
\definecolor{special}{RGB}{230, 126, 34}     % Orange
```

### 11.3 Competition/Olympiad
```latex
\definecolor{primary}{RGB}{44, 62, 80}       % Dark blue-gray
\definecolor{highlight}{RGB}{231, 76, 60}    % Bright red
\definecolor{construct}{RGB}{52, 152, 219}   % Bright blue
```

---

*Knowledge file for Geometry Illustrator Agent*
*Math Team v1.0*
