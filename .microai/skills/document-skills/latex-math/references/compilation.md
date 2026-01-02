# LaTeX Compilation Guide

## XeLaTeX (Recommended)

XeLaTeX là engine được khuyến nghị cho tài liệu tiếng Việt vì hỗ trợ Unicode và fontspec.

### Basic Compilation

```bash
# Single pass
xelatex -interaction=nonstopmode main.tex

# Double pass (cho references, TOC)
xelatex -interaction=nonstopmode main.tex && xelatex -interaction=nonstopmode main.tex
```

### With Output Directory

```bash
mkdir -p output
xelatex -output-directory=output main.tex
```

### Silent Mode

```bash
xelatex -interaction=batchmode main.tex 2>/dev/null
```

## LuaLaTeX (Fallback)

Nếu XeLaTeX gặp lỗi, dùng LuaLaTeX:

```bash
lualatex -interaction=nonstopmode main.tex
```

## Common Errors & Solutions

### Font Errors

**Error**: `Font "Times New Roman" not found`

**Solutions**:
```latex
% Option 1: Use Latin Modern (available everywhere)
\setmainfont{Latin Modern Roman}

% Option 2: Check font name
fc-list | grep "Times"

% Option 3: Install MS fonts (macOS)
brew install --cask font-times-new-roman
```

### Package Errors

**Error**: `! LaTeX Error: File 'xxx.sty' not found`

**Solution**:
```bash
# TeX Live
tlmgr install <package-name>

# macOS
brew install --cask mactex

# Check if package installed
kpsewhich xxx.sty
```

### Math Mode Errors

**Error**: `Missing $ inserted`

**Cause**: Text inside math mode without proper escaping

**Solution**:
```latex
% Wrong
$x = 5 cm$

% Correct
$x = 5 \text{ cm}$
```

### Unicode Errors

**Error**: Character not supported

**Solution**:
```latex
% Ensure XeLaTeX + fontspec
\usepackage{fontspec}
\setmainfont{Times New Roman}  % Must have Unicode support
```

## Compilation Workflow

### Step-by-Step

1. **First pass**: Compile, generate .aux file
2. **BibTeX** (if references): `bibtex main`
3. **Second pass**: Update references
4. **Third pass** (optional): Final cleanup

### Full Script

```bash
#!/bin/bash
xelatex -interaction=nonstopmode main.tex
if [ -f main.bib ]; then
    bibtex main
    xelatex -interaction=nonstopmode main.tex
fi
xelatex -interaction=nonstopmode main.tex
echo "Done! Output: main.pdf"
```

## Required Packages

### Core Math

```latex
\usepackage{amsmath}      % tlmgr install amsmath
\usepackage{amssymb}      % tlmgr install amsfonts
\usepackage{amsthm}       % tlmgr install amsthm
\usepackage{mathtools}    % tlmgr install mathtools
```

### Graphics

```latex
\usepackage{tikz}         % tlmgr install pgf
\usepackage{pgfplots}     % tlmgr install pgfplots
```

### Vietnamese

```latex
\usepackage{fontspec}     % tlmgr install fontspec
\usepackage[vietnamese]{babel}  % tlmgr install babel-vietnamese
```

## Verification

### Check Compilation Success

```bash
if [ -f main.pdf ]; then
    echo "PDF generated successfully"
    ls -lh main.pdf
else
    echo "Compilation failed. Check main.log"
fi
```

### Open PDF

```bash
# macOS
open main.pdf

# Linux
xdg-open main.pdf

# Windows
start main.pdf
```

---

*LaTeX Math Skill - Compilation Reference*
