# Step 02: INGESTION

> Extract and clean content from source files

---

## Step Info

```yaml
step: 2
name: ingestion
title: "Content Ingestion"
description: "Extract text from PDF, EPUB, DOCX, web, or plain text sources"

trigger: step.01.complete
agent: content-ingestion-agent

duration: "1-5 minutes"
checkpoint: true
```

---

## Responsible Agent

**Content Ingestion Agent** (`📥`)
- Detects input format
- Extracts text content
- Cleans and normalizes text
- Extracts metadata

---

## Input

```yaml
input:
  from_step: step-01-init
  files:
    - $INPUT (PDF, EPUB, DOCX, TXT, MD, or URL)
```

---

## Process

### 1. Format Detection

```bash
# Detect input type
detect_format() {
    local file="$1"

    case "${file##*.}" in
        pdf)  echo "pdf" ;;
        epub) echo "epub" ;;
        docx) echo "docx" ;;
        txt)  echo "txt" ;;
        md)   echo "markdown" ;;
        html) echo "html" ;;
        *)
            if [[ "$file" == http* ]]; then
                echo "url"
            else
                echo "unknown"
            fi
            ;;
    esac
}
```

### 2. Content Extraction

| Format | Tool | Command |
|--------|------|---------|
| PDF | pdftotext | `pdftotext -raw input.pdf output.txt` |
| EPUB | ebook-convert | `ebook-convert input.epub output.txt` |
| DOCX | pandoc | `pandoc -f docx -t plain input.docx -o output.txt` |
| HTML | pandoc | `pandoc -f html -t plain input.html -o output.txt` |
| URL | readable | `readable URL \| pandoc -f html -t plain` |
| TXT/MD | direct | `cp input.txt output.txt` |

### 3. Text Cleaning

```python
cleaning_steps = [
    # Fix encoding
    "convert_to_utf8",

    # Remove artifacts
    "remove_page_numbers",
    "remove_headers_footers",

    # Fix formatting
    "fix_hyphenation",
    "normalize_whitespace",
    "fix_smart_quotes",

    # Clean special chars
    "remove_control_characters",
]
```

### 4. Metadata Extraction

```yaml
source_metadata:
  title: "{extracted or inferred}"
  author: "{if available}"
  language: "{detected}"
  source_type: pdf|epub|docx|txt|url
  source_path: "{original path}"
  extraction_date: "{timestamp}"
  word_count: "{count}"
  estimated_duration: "{based on word count}"
```

---

## Output

```yaml
output:
  files:
    - raw/raw-content.txt
    - raw/source-metadata.json

  publish:
    - topic: content.raw_text
      payload: raw-content.txt
    - topic: content.source_metadata
      payload: source-metadata.json

  checkpoint:
    name: "ingestion-complete"
    files:
      - raw/raw-content.txt
      - raw/source-metadata.json
```

---

## Success Criteria

```yaml
success:
  - file_exists: raw/raw-content.txt
  - file_not_empty: raw/raw-content.txt
  - word_count: ">= 100"
  - encoding: "UTF-8"
  - metadata_valid: raw/source-metadata.json
```

---

## Error Handling

```yaml
errors:
  extraction_failed:
    action: try_alternative_tool
    fallback: manual_input

  empty_content:
    action: abort
    message: "No content extracted"

  encoding_error:
    action: try_multiple_encodings
    encodings: [UTF-8, Latin-1, Windows-1252]

  password_protected:
    action: request_password
    fallback: abort
```

---

## Next Step

- **Step 03: STRUCTURE** - Book Structure Agent analyzes chapters and genre
