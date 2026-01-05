# Export & PDF Guide

## Overview

Hướng dẫn export OPPM từ Markdown sang PDF và các định dạng khác.

---

## Method 1: Pandoc (Recommended)

### Installation

```bash
# macOS
brew install pandoc
brew install basictex  # for PDF

# Ubuntu/Debian
sudo apt-get install pandoc texlive-xetex

# Windows
choco install pandoc miktex
```

### Basic Export

```bash
pandoc oppm.md -o oppm.pdf
```

### With Custom Styling

```bash
pandoc oppm.md \
  -o oppm.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=1in \
  -V fontsize=10pt \
  -V monofont="Fira Code"
```

### For Box Characters (Unicode)

```bash
pandoc oppm.md \
  -o oppm.pdf \
  --pdf-engine=xelatex \
  -V mainfont="DejaVu Sans" \
  -V monofont="DejaVu Sans Mono" \
  -V geometry:margin=0.75in
```

---

## Method 2: wkhtmltopdf

### Installation

```bash
# macOS
brew install wkhtmltopdf

# Ubuntu/Debian
sudo apt-get install wkhtmltopdf

# Windows
choco install wkhtmltopdf
```

### Convert via HTML

```bash
# Step 1: Markdown to HTML
pandoc oppm.md -o oppm.html

# Step 2: HTML to PDF
wkhtmltopdf oppm.html oppm.pdf
```

### With Options

```bash
wkhtmltopdf \
  --page-size A4 \
  --orientation Landscape \
  --margin-top 10mm \
  --margin-bottom 10mm \
  --margin-left 10mm \
  --margin-right 10mm \
  oppm.html oppm.pdf
```

---

## Method 3: VS Code Extension

### Markdown PDF Extension

1. Install "Markdown PDF" extension
2. Open the .md file
3. Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows)
4. Type "Markdown PDF: Export (pdf)"
5. Select save location

### Settings for OPPM

Add to `.vscode/settings.json`:

```json
{
  "markdown-pdf.displayHeaderFooter": false,
  "markdown-pdf.margin.top": "10mm",
  "markdown-pdf.margin.bottom": "10mm",
  "markdown-pdf.margin.left": "10mm",
  "markdown-pdf.margin.right": "10mm",
  "markdown-pdf.scale": 0.9
}
```

---

## Method 4: Chrome Print

### Steps

1. Open Markdown file in VS Code
2. Use Markdown Preview (`Cmd+Shift+V`)
3. Right-click → "Open in Browser"
4. Print → Save as PDF

### Print Settings

```
- Destination: Save as PDF
- Layout: Landscape (for wide tables)
- Margins: Minimum
- Scale: 90-100%
- Background graphics: ON
```

---

## Styling Tips

### Monospace Font for Boxes

The box characters require monospace fonts. Recommended:

```
- DejaVu Sans Mono (best Unicode support)
- Fira Code
- JetBrains Mono
- Consolas (Windows)
- Menlo (macOS)
```

### CSS for HTML Export

```css
/* oppm-style.css */
body {
  font-family: 'DejaVu Sans', 'Helvetica Neue', sans-serif;
  font-size: 10pt;
  line-height: 1.4;
}

pre, code {
  font-family: 'DejaVu Sans Mono', 'Fira Code', monospace;
  font-size: 9pt;
  white-space: pre;
}

@page {
  size: A4 landscape;
  margin: 10mm;
}

@media print {
  body {
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
}
```

### Use with Pandoc

```bash
pandoc oppm.md \
  -o oppm.pdf \
  --css=oppm-style.css \
  --pdf-engine=wkhtmltopdf
```

---

## Quick Reference: Export Commands

```bash
# Basic PDF
pandoc oppm.md -o oppm.pdf

# A4 Landscape
pandoc oppm.md -o oppm.pdf -V geometry:a4paper,landscape

# With Unicode fonts
pandoc oppm.md -o oppm.pdf \
  --pdf-engine=xelatex \
  -V mainfont="DejaVu Sans" \
  -V monofont="DejaVu Sans Mono"

# HTML for web sharing
pandoc oppm.md -o oppm.html --standalone

# DOCX for Word
pandoc oppm.md -o oppm.docx
```

---

## Troubleshooting

### Box Characters Not Showing

**Problem**: `╔═══╗` displays as `???`

**Solution**: Use Unicode-compatible font
```bash
pandoc oppm.md -o oppm.pdf \
  --pdf-engine=xelatex \
  -V monofont="DejaVu Sans Mono"
```

### Page Overflow

**Problem**: Content exceeds one page

**Solutions**:
1. Reduce font size: `-V fontsize=9pt`
2. Reduce margins: `-V geometry:margin=0.5in`
3. Use landscape: `-V geometry:landscape`
4. Simplify content (fewer tasks)

### Emoji Not Rendering

**Problem**: 🟢 🟡 🔴 not showing

**Solutions**:
1. Use text alternatives: `[OK]` `[AT RISK]` `[BLOCKED]`
2. Install emoji font: `Noto Color Emoji`
3. Use PDF engine that supports emoji

---

## Automation Script

### export-oppm.sh

```bash
#!/bin/bash
# Export OPPM to PDF

INPUT="${1:-oppm.md}"
OUTPUT="${INPUT%.md}.pdf"

pandoc "$INPUT" \
  -o "$OUTPUT" \
  --pdf-engine=xelatex \
  -V geometry:a4paper,landscape \
  -V geometry:margin=15mm \
  -V fontsize=9pt \
  -V mainfont="Helvetica Neue" \
  -V monofont="DejaVu Sans Mono"

echo "Exported: $OUTPUT"
open "$OUTPUT"  # macOS only
```

### Usage

```bash
chmod +x export-oppm.sh
./export-oppm.sh my-project.md
```
