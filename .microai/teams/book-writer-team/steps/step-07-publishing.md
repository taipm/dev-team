# Step 07: Publishing

## Agent
📚 **Publisher Agent** - Format & Publish Specialist

## Trigger
Step 06 hoàn thành, review passed

## Actions

### 1. Activate Publisher Agent
```
Load: ./agents/publisher-agent.md
Load knowledge: ./knowledge/publisher/format-specifications.md
Receive: Approved chapters from review loop
Update state: current_agent = "publisher"
```

### 2. Prepare Content
```
1. Combine all chapters into single manuscript
2. Generate table of contents
3. Create index entries
4. Prepare front matter (title page, copyright, preface)
5. Prepare back matter (appendices, glossary, bibliography)
```

### 3. Generate Markdown Version
```
Output: ./docs/books/{book_name}/output/book.md

Features:
- GitHub-flavored Markdown
- Proper heading hierarchy
- Fenced code blocks with language hints
- Internal links for cross-references
- Table of contents with anchors
```

### 4. Generate LaTeX Version
```
Output: ./docs/books/{book_name}/output/book.tex

Features:
- Professional book class
- Syntax-highlighted listings
- Math equation support
- Index generation
- Bibliography management
```

### 5. Compile PDF
```
Command: xelatex book.tex && makeindex book.idx && xelatex book.tex

Output: ./docs/books/{book_name}/output/book.pdf

Features:
- Print-ready quality
- Hyperlinked TOC
- Page numbers
- Professional typography
```

### 6. Generate HTML Version
```
Output: ./docs/books/{book_name}/output/html/

Features:
- Responsive design
- Navigation sidebar
- Search functionality
- Syntax highlighting (highlight.js)
- Print stylesheet
```

### 7. Generate EPUB Version
```
Output: ./docs/books/{book_name}/output/book.epub

Features:
- EPUB 3.0 compliant
- NCX navigation
- Proper metadata
- E-reader optimized
```

### 8. Create Publishing Report

```
📚 **PUBLISHING REPORT**

══════════════════════════════════════════════════════════════

BOOK: {Title}
AUTHOR: {Author}
DATE: {Date}
VERSION: 1.0.0

──────────────────────────────────────────────────────────────

OUTPUT FORMATS:

| Format   | Status | Size      | Location                    |
|----------|--------|-----------|----------------------------|
| Markdown | ✅     | {size}    | ./output/book.md           |
| LaTeX    | ✅     | {size}    | ./output/book.tex          |
| PDF      | ✅     | {pages}p  | ./output/book.pdf          |
| HTML     | ✅     | {size}    | ./output/html/index.html   |
| EPUB     | ✅     | {size}    | ./output/book.epub         |

──────────────────────────────────────────────────────────────

BOOK STATISTICS:
- Total Pages (PDF): {count}
- Total Words: {count}
- Total Chapters: {count}
- Total Code Examples: {count}
- Total Exercises: {count}

──────────────────────────────────────────────────────────────

METADATA:
- ISBN: {if applicable}
- Language: {language}
- Keywords: {keywords}

──────────────────────────────────────────────────────────────

QUALITY CHECKS:
[✓] All links functional
[✓] All images render
[✓] Code highlighting works
[✓] TOC accurate
[✓] Index complete

══════════════════════════════════════════════════════════════
```

## Communication
```yaml
publishes:
  topic: publishing
  message:
    type: publishing_complete
    data:
      formats: [markdown, latex, pdf, html, epub]
      paths: {output paths}
      stats: {book statistics}
```

## Output
```yaml
outputs:
  final_book:
    markdown: "./docs/books/{book_name}/output/book.md"
    latex: "./docs/books/{book_name}/output/book.tex"
    pdf: "./docs/books/{book_name}/output/book.pdf"
    html: "./docs/books/{book_name}/output/html/"
    epub: "./docs/books/{book_name}/output/book.epub"
    manifest: "./docs/books/{book_name}/output/manifest.yaml"

quality_metrics:
  format_pass: true
```

## Checkpoint
```
./checkpoints/step-07-publishing-{timestamp}.yaml
```

## Next Step
→ Step 08: Synthesis (Final Summary)
