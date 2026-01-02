# Format Specifications

Specifications for output formats.

## Markdown Format

### Flavor
GitHub-Flavored Markdown (GFM)

### Structure
```markdown
# Book Title

[TOC]

---

# Part I: Introduction

## Chapter 1: Getting Started

### Section 1.1

Content here...

```code-language
code here
```

---

## Chapter 2: Next Topic
...
```

### Features
- Fenced code blocks with language hints
- Tables using pipe syntax
- Task lists
- Autolinks for URLs
- Strikethrough with ~~tildes~~

### File Organization
```
output/
├── book.md              # Combined book
├── chapters/
│   ├── chapter-01.md    # Individual chapters
│   ├── chapter-02.md
│   └── ...
└── assets/
    └── images/          # All images
```

## LaTeX Format

### Document Class
```latex
\documentclass[11pt,a4paper,openright]{book}
```

### Essential Packages
```latex
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{microtype}
\usepackage{listings}
\usepackage{xcolor}
\usepackage{hyperref}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{makeidx}
\usepackage{fancyhdr}
```

### Code Listings Configuration
```latex
\lstset{
    basicstyle=\ttfamily\small,
    breaklines=true,
    breakatwhitespace=true,
    frame=single,
    framesep=3pt,
    numbers=left,
    numberstyle=\tiny\color{gray},
    keywordstyle=\color{blue}\bfseries,
    commentstyle=\color{green!50!black},
    stringstyle=\color{red},
    showstringspaces=false,
    tabsize=2
}
```

### Language-Specific Listings
```latex
\lstdefinestyle{python}{
    language=Python,
    morekeywords={self,yield,async,await}
}

\lstdefinestyle{javascript}{
    language=JavaScript,
    morekeywords={const,let,async,await,class,export,import}
}
```

### Structure
```latex
\begin{document}

\frontmatter
\maketitle
\tableofcontents

\mainmatter
\part{Introduction}
\chapter{Getting Started}
\section{First Steps}
...

\backmatter
\appendix
\chapter{Reference}
...
\printindex

\end{document}
```

## PDF Format

### Page Setup
- Size: A4 (210mm × 297mm) or Letter (8.5" × 11")
- Margins: 1" all sides (or 25mm)
- Binding: 0.5" extra on left for print

### Typography
- Body: 11pt serif (Latin Modern)
- Headings: Sans-serif
- Code: Monospace (Source Code Pro, Consolas)
- Line spacing: 1.2-1.5

### Page Layout
```
┌─────────────────────────────────────┐
│ Header (Chapter Title)         Page │
├─────────────────────────────────────┤
│                                     │
│ Body Content                        │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ Footer                              │
└─────────────────────────────────────┘
```

### Generation
```bash
# Compile LaTeX to PDF
xelatex book.tex
makeindex book.idx
bibtex book
xelatex book.tex
xelatex book.tex
```

## HTML Format

### Structure
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{Book Title}</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="highlight/styles/default.css">
</head>
<body>
    <nav class="sidebar">
        <!-- Table of Contents -->
    </nav>
    <main class="content">
        <!-- Chapter Content -->
    </main>
    <script src="highlight/highlight.pack.js"></script>
    <script>hljs.highlightAll();</script>
</body>
</html>
```

### CSS Framework
Responsive design with:
- Mobile-first approach
- Dark mode support
- Print stylesheet
- Syntax highlighting

### File Organization
```
html/
├── index.html           # Home page with TOC
├── chapter-01.html      # Individual chapters
├── chapter-02.html
├── css/
│   ├── style.css        # Main styles
│   ├── print.css        # Print styles
│   └── dark.css         # Dark mode
├── js/
│   └── main.js          # Navigation, search
└── assets/
    └── images/
```

### Features
- Responsive navigation
- In-page search
- Syntax highlighting (highlight.js)
- Progress indicator
- Print-friendly version

## EPUB Format

### Version
EPUB 3.0

### Container Structure
```
book.epub
├── mimetype
├── META-INF/
│   └── container.xml
├── OEBPS/
│   ├── content.opf      # Package document
│   ├── toc.ncx          # NCX navigation
│   ├── nav.xhtml        # EPUB3 navigation
│   ├── chapter-01.xhtml
│   ├── chapter-02.xhtml
│   ├── css/
│   │   └── style.css
│   └── images/
```

### Package Document (content.opf)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="BookId">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:title>{Book Title}</dc:title>
        <dc:creator>{Author Name}</dc:creator>
        <dc:language>en</dc:language>
        <dc:identifier id="BookId">urn:uuid:{uuid}</dc:identifier>
        <meta property="dcterms:modified">{date}</meta>
    </metadata>
    <manifest>
        <item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
        <item id="chapter1" href="chapter-01.xhtml" media-type="application/xhtml+xml"/>
        <!-- More items -->
    </manifest>
    <spine>
        <itemref idref="nav"/>
        <itemref idref="chapter1"/>
        <!-- More itemrefs -->
    </spine>
</package>
```

### Validation
```bash
# Use epubcheck for validation
java -jar epubcheck.jar book.epub
```

### Requirements
- Valid XHTML content
- Proper metadata
- Working navigation
- No external resources

## Image Specifications

### Formats
| Format | Use Case |
|--------|----------|
| PNG | Screenshots, diagrams |
| SVG | Vector diagrams |
| JPEG | Photos (if needed) |

### Resolution
- Print (PDF): 300 DPI minimum
- Screen (HTML): 72-144 DPI
- EPUB: Reasonable size (<500KB each)

### Naming
```
{chapter}-{figure}-{description}.{ext}
ch01-fig01-architecture-overview.png
ch03-fig02-data-flow-diagram.svg
```

## Conversion Workflow

```
                     ┌─────────┐
                     │ Markdown│
                     └────┬────┘
                          │
         ┌────────────────┼────────────────┐
         │                │                │
         ▼                ▼                ▼
    ┌─────────┐     ┌─────────┐     ┌─────────┐
    │  LaTeX  │     │  HTML   │     │  EPUB   │
    └────┬────┘     └─────────┘     └─────────┘
         │
         ▼
    ┌─────────┐
    │   PDF   │
    └─────────┘
```

### Tools
- **Markdown → LaTeX:** Pandoc
- **Markdown → HTML:** Pandoc or custom
- **LaTeX → PDF:** XeLaTeX
- **Markdown → EPUB:** Pandoc

### Pandoc Commands
```bash
# Markdown to LaTeX
pandoc book.md -o book.tex --template=template.tex

# Markdown to HTML
pandoc book.md -o book.html --template=template.html -s

# Markdown to EPUB
pandoc book.md -o book.epub --metadata-file=metadata.yaml
```

## Publishing Manifest

```yaml
# manifest.yaml
book:
  title: "{Book Title}"
  subtitle: "{Subtitle}"
  author: "{Author Name}"
  version: "1.0.0"
  date: "{YYYY-MM-DD}"
  language: "en"
  isbn: "{ISBN if applicable}"

outputs:
  markdown:
    path: "./output/book.md"
    format: "gfm"

  latex:
    path: "./output/book.tex"
    class: "book"
    paper: "a4"

  pdf:
    path: "./output/book.pdf"
    engine: "xelatex"
    pages: {count}

  html:
    path: "./output/html/"
    responsive: true
    syntax_highlight: "highlight.js"

  epub:
    path: "./output/book.epub"
    version: "3.0"

metadata:
  keywords: ["{keyword1}", "{keyword2}"]
  category: "{category}"
  copyright: "Copyright {year} {author}"
```
