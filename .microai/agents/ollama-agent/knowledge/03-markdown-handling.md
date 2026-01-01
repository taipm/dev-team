# Markdown Handling - Xử Lý Markdown

> Hướng dẫn chi tiết cách xử lý các elements trong Markdown khi dịch.

---

## 1. Overview

### Nguyên tắc chính

```
1. PRESERVE structure (headings, lists, tables)
2. PRESERVE code (blocks và inline)
3. PRESERVE links (URLs)
4. TRANSLATE content (text giữa các markers)
```

---

## 2. Headings

### Pattern

```markdown
# Heading 1      → # Heading 1 (translated)
## Heading 2     → ## Heading 2 (translated)
### Heading 3    → ### Heading 3 (translated)
```

### Example

```markdown
ORIGINAL:
# Getting Started
## Installation
### Prerequisites

TRANSLATED:
# Bắt Đầu
## Cài Đặt
### Yêu Cầu
```

### Rules
- Giữ nguyên số lượng `#`
- Giữ nguyên spacing
- Chỉ dịch text content

---

## 3. Code Blocks

### Fenced Code Blocks

```markdown
ORIGINAL:
```javascript
const greeting = "Hello World";
console.log(greeting);
```

TRANSLATED:
```javascript
const greeting = "Hello World";    ← KHÔNG DỊCH
console.log(greeting);             ← KHÔNG DỊCH
```
```

### Detection Pattern

```
START: ``` hoặc ```language
END: ```
BETWEEN: PRESERVE EVERYTHING
```

### Indented Code Blocks

```markdown
ORIGINAL:
    function hello() {
        return "world";
    }

TRANSLATED:
    function hello() {      ← KHÔNG DỊCH (4 spaces indent)
        return "world";
    }
```

### Mixed Content

```markdown
ORIGINAL:
To create a function, use the following syntax:

```javascript
function myFunction() {
  // your code here
}
```

This creates a new function.

TRANSLATED:
Để tạo function, sử dụng cú pháp sau:

```javascript
function myFunction() {     ← KHÔNG DỊCH
  // your code here
}
```

Điều này tạo một function mới.
```

---

## 4. Inline Code

### Pattern

```markdown
Use `command` to do something.
→ Sử dụng `command` để làm gì đó.
        ↑ KHÔNG DỊCH
```

### Detection

```
Pattern: `[^`]+`
Action: PRESERVE content inside backticks
```

### Examples

```markdown
ORIGINAL:
- Run `npm install` to install dependencies
- Use the `--verbose` flag for more output
- The `config.json` file contains settings

TRANSLATED:
- Chạy `npm install` để cài đặt dependencies
- Sử dụng flag `--verbose` để xem thêm output
- File `config.json` chứa các cài đặt
```

---

## 5. Links

### Standard Links

```markdown
[Link Text](URL)
↑ dịch    ↑ KHÔNG DỊCH

ORIGINAL:
See the [documentation](https://docs.example.com) for details.

TRANSLATED:
Xem [tài liệu](https://docs.example.com) để biết chi tiết.
```

### Reference Links

```markdown
[Link Text][reference]

[reference]: URL

→ Dịch Link Text, giữ nguyên reference và URL
```

### Auto Links

```markdown
<https://example.com>
→ KHÔNG DỊCH
```

---

## 6. Images

### Pattern

```markdown
![Alt Text](image-path)
↑ dịch   ↑ KHÔNG DỊCH

ORIGINAL:
![Architecture Diagram](./images/arch.png)

TRANSLATED:
![Sơ đồ kiến trúc](./images/arch.png)
```

### With Title

```markdown
![Alt](path "Title")
→ Dịch Alt và Title, giữ path

![Architecture](./arch.png "System Architecture")
→ ![Kiến trúc](./arch.png "Kiến trúc hệ thống")
```

---

## 7. Tables

### Structure

```markdown
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
```

### Rules

- Dịch header text
- Dịch cell content (trừ code)
- Giữ nguyên alignment markers (`:---`, `:---:`, `---:`)
- Giữ nguyên `|` separators

### Example

```markdown
ORIGINAL:
| Command | Description | Example |
|---------|-------------|---------|
| `start` | Start server | `npm start` |
| `build` | Build project | `npm run build` |

TRANSLATED:
| Lệnh    | Mô tả        | Ví dụ   |
|---------|--------------|---------|
| `start` | Khởi động server | `npm start` |
| `build` | Build project | `npm run build` |
    ↑ giữ                      ↑ giữ
```

---

## 8. Lists

### Unordered Lists

```markdown
ORIGINAL:
- Item one
- Item two
  - Nested item
- Item three

TRANSLATED:
- Mục một
- Mục hai
  - Mục con
- Mục ba
```

### Ordered Lists

```markdown
ORIGINAL:
1. First step
2. Second step
3. Third step

TRANSLATED:
1. Bước đầu tiên
2. Bước thứ hai
3. Bước thứ ba
```

### Task Lists

```markdown
ORIGINAL:
- [x] Completed task
- [ ] Pending task

TRANSLATED:
- [x] Nhiệm vụ hoàn thành
- [ ] Nhiệm vụ chưa làm
```

---

## 9. Blockquotes

### Standard

```markdown
ORIGINAL:
> This is a quote.
> It spans multiple lines.

TRANSLATED:
> Đây là một trích dẫn.
> Nó trải dài nhiều dòng.
```

### With Attribution

```markdown
ORIGINAL:
> "To be or not to be"
> — Shakespeare

TRANSLATED:
> "Tồn tại hay không tồn tại"
> — Shakespeare    ← giữ tên
```

### Callouts/Admonitions

```markdown
ORIGINAL:
> **Note:** This is important.
> **Warning:** Be careful.
> **Tip:** Try this approach.

TRANSLATED:
> **Lưu ý:** Điều này quan trọng.
> **Cảnh báo:** Hãy cẩn thận.
> **Mẹo:** Thử cách tiếp cận này.
```

---

## 10. Emphasis

### Bold

```markdown
**bold text** → **văn bản đậm**
__bold text__ → __văn bản đậm__
```

### Italic

```markdown
*italic text* → *văn bản nghiêng*
_italic text_ → _văn bản nghiêng_
```

### Strikethrough

```markdown
~~deleted~~ → ~~đã xóa~~
```

### Combined

```markdown
***bold and italic*** → ***đậm và nghiêng***
```

---

## 11. Horizontal Rules

```markdown
---
***
___

→ GIỮNGUYÊN (không có gì để dịch)
```

---

## 12. HTML Elements

### Preserve HTML

```markdown
<details>
<summary>Click to expand</summary>
Content here
</details>

TRANSLATED:
<details>
<summary>Nhấn để mở rộng</summary>
Nội dung ở đây
</details>
```

### Common HTML to preserve

- `<br>` - line break
- `<kbd>` - keyboard keys
- `<sub>`, `<sup>` - subscript, superscript
- `<details>`, `<summary>` - collapsible
- `<img>` with attributes

---

## 13. Special Characters

### Escape Characters

```markdown
\*not italic\*  → \*không nghiêng\*
\`not code\`    → \`không phải code\`
```

### Entities

```markdown
&copy;   → &copy;      (giữ nguyên)
&mdash;  → &mdash;     (giữ nguyên)
&nbsp;   → &nbsp;      (giữ nguyên)
```

---

## 14. Chunking Strategy

### By Headings

```
Document
│
├── # H1 Section ──────────┐
│   Paragraph 1            │ CHUNK 1
│   Paragraph 2            │
│                          │
├── ## H2 Section ─────────┤
│   Content                │ CHUNK 2
│   ```code```             │
│   More content           │
│                          │
├── ## H2 Section ─────────┤
│   Short section          │ CHUNK 3
│                          │
└── # H1 New Section ──────┤
    Content                │ CHUNK 4
```

### Chunk Size

```
TARGET: ~500 words per chunk
MIN: 100 words (don't split small sections)
MAX: 800 words (split if larger)

NEVER split:
- In middle of code block
- In middle of table
- In middle of list
```

### Algorithm

```python
def chunk_document(content):
    chunks = []
    current_chunk = []
    word_count = 0

    for line in content.split('\n'):
        # Start new chunk on H1/H2
        if line.startswith('# ') or line.startswith('## '):
            if current_chunk:
                chunks.append('\n'.join(current_chunk))
            current_chunk = [line]
            word_count = count_words(line)
        else:
            current_chunk.append(line)
            word_count += count_words(line)

            # Split if too large (but not mid-block)
            if word_count > 800 and not in_code_block:
                chunks.append('\n'.join(current_chunk))
                current_chunk = []
                word_count = 0

    if current_chunk:
        chunks.append('\n'.join(current_chunk))

    return chunks
```

---

## 15. Validation Checklist

```
□ Heading levels preserved (# ## ###)
□ Code blocks intact (```...```)
□ Inline code intact (`...`)
□ Links working ([text](url))
□ Images preserved (![alt](path))
□ Tables aligned
□ Lists formatted correctly
□ Blockquotes have >
□ Emphasis markers paired
□ No broken HTML
□ Special characters preserved
```

---

## 16. Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Dịch trong code block | Code broken | Detect ``` boundaries |
| Xóa backticks | Inline code lost | Preserve ` characters |
| Đổi URL | Links broken | Extract and preserve |
| Thêm/bớt # | Heading level wrong | Count and preserve |
| Phá table alignment | Table broken | Keep column count |
| Dịch reference | Link broken | Keep [ref] intact |

---

## 17. Regex Patterns

### Detect Code Block

```regex
```[\w]*\n[\s\S]*?```
```

### Detect Inline Code

```regex
`[^`]+`
```

### Detect Links

```regex
\[([^\]]+)\]\(([^)]+)\)
```

### Detect Images

```regex
!\[([^\]]*)\]\(([^)]+)\)
```

### Detect Headings

```regex
^#{1,6}\s+(.+)$
```

### Detect Table Row

```regex
^\|(.+)\|$
```
