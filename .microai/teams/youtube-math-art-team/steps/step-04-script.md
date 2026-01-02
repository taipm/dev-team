# Step 04: Script Writing

## Purpose
📝 Script Writer viết kịch bản narration cho video (cả VI và EN).

## Agent
**script-writer** (📝)

## Trigger
Step 02 (Concept) completed. Có thể chạy parallel với Step 03 (Algorithm).

## Actions

### 1. Load Agent & Concept
```bash
# Load concept document
cat "$WORKSPACE/docs/concept.md"
```

Extract from concept:
- Topic name và ý nghĩa toán học
- Visual phases và transitions
- Key moments cần highlight
- Target audience

### 2. Write Script Structure

```markdown
## 📝 SCRIPT: {Topic Name}

### Video Info
- Duration: 90 seconds
- Style: Educational calm (documentary)
- Languages: Vietnamese + English

### Script Outline
| Time | Phase | Visual | Narration Focus |
|------|-------|--------|-----------------|
| 0-8s | Hook | Opening animation | Curiosity question |
| 8-20s | Intro | Topic reveal | What is this? Why important? |
| 20-35s | Explain 1 | Basic concept | Fundamental principle |
| 35-50s | Explain 2 | How it works | Step by step |
| 50-60s | Explain 3 | Why fascinating | Mathematical beauty |
| 60-80s | Climax | Most impressive visual | Peak narration |
| 80-90s | Outro | Closing | CTA, subscribe |
```

### 3. Write Vietnamese Version

```markdown
# SCRIPT: {Topic} - Tiếng Việt

### [0:00 - 0:08] HOOK
Bạn có bao giờ tự hỏi làm thế nào một công thức đơn giản 
có thể tạo ra vẻ đẹp vô tận như thế này?

### [0:08 - 0:20] INTRO
[SYNC: Topic title appears]
Đây là {Topic} - một trong những khám phá tuyệt vời nhất
của toán học. {Brief history/significance}

### [0:20 - 0:35] GIẢI THÍCH 1
[SYNC: Basic animation begins]
{Topic} hoạt động dựa trên nguyên lý {principle}.
{Simple explanation with everyday analogy}

### [0:35 - 0:50] GIẢI THÍCH 2  
[SYNC: Transformation/iteration shown]
Mỗi lần lặp lại, {process description}.
Và điều kỳ diệu là {fascinating aspect}.

### [0:50 - 1:00] GIẢI THÍCH 3
[SYNC: Complexity increases]
Điều làm nên vẻ đẹp của {topic} là {mathematical beauty}.
Từ đơn giản đến phức tạp, từ trật tự đến hỗn loạn.

### [1:00 - 1:20] CAO TRÀO
[SYNC: Visual climax - most impressive part]
Hãy ngắm nhìn khi {climax description}.
Mỗi chi tiết, mỗi đường cong đều tuân theo quy luật toán học.

### [1:20 - 1:30] KẾT
[SYNC: Outro animation]
Toán học không chỉ là những con số khô khan.
Nó là ngôn ngữ của vũ trụ, và đây là một trong những bài thơ của nó.
Đừng quên subscribe để khám phá thêm những điều kỳ diệu khác.
```

### 4. Write English Version

```markdown
# SCRIPT: {Topic} - English

### [0:00 - 0:08] HOOK
Have you ever wondered how a simple formula 
can create such infinite beauty?

### [0:08 - 0:20] INTRO
[SYNC: Topic title appears]
This is the {Topic} - one of mathematics' most stunning discoveries.
{Brief history/significance}

### [0:20 - 0:35] EXPLANATION 1
[SYNC: Basic animation begins]
The {Topic} works on the principle of {principle}.
{Simple explanation with everyday analogy}

### [0:35 - 0:50] EXPLANATION 2
[SYNC: Transformation/iteration shown]
With each iteration, {process description}.
And the magic is that {fascinating aspect}.

### [0:50 - 1:00] EXPLANATION 3
[SYNC: Complexity increases]
What makes the {topic} beautiful is {mathematical beauty}.
From simple to complex, from order to chaos.

### [1:00 - 1:20] CLIMAX
[SYNC: Visual climax]
Watch as {climax description}.
Every detail, every curve follows mathematical law.

### [1:20 - 1:30] OUTRO
[SYNC: Outro animation]
Mathematics isn't just dry numbers.
It's the language of the universe, and this is one of its poems.
Subscribe to discover more mathematical wonders.
```

### 5. Save Scripts

```bash
# Save Vietnamese script
cat > "$WORKSPACE/docs/script_vi.md" << SCRIPT
{vietnamese_script_content}
SCRIPT

# Save English script  
cat > "$WORKSPACE/docs/script_en.md" << SCRIPT
{english_script_content}
SCRIPT

# Save plain text for TTS (no markdown/timestamps)
cat > "$WORKSPACE/output/script_vi.txt" << TXT
{vietnamese_plain_text}
TXT

cat > "$WORKSPACE/output/script_en.txt" << TXT
{english_plain_text}
TXT
```

### 6. Validate Word Count

```python
def validate_script(text: str, language: str) -> dict:
    """Validate script length for 90s video."""
    words = len(text.split())
    
    # Speaking rate: VI ~150 wpm, EN ~140 wpm
    expected_max = 270 if language == 'vi' else 243
    expected_min = 200 if language == 'vi' else 180
    
    return {
        'word_count': words,
        'expected_range': f"{expected_min}-{expected_max}",
        'valid': expected_min <= words <= expected_max,
        'estimated_duration': words / (2.8 if language == 'vi' else 2.6)
    }
```

### 7. Log Completion

```
📝 SCRIPT WRITING COMPLETE
├── Vietnamese: script_vi.md ({word_count} words)
├── English: script_en.md ({word_count} words)
├── TTS-ready: script_vi.txt, script_en.txt
├── Sync points: {n} markers
└── Estimated duration: ~{duration}s each

Proceeding to TTS Voice Generation...
```

## Parallel Execution

```
Step 02 (Concept) ────┬────▶ Step 03 (Algorithm)
                      │
                      └────▶ Step 04 (Script) ──▶ Step 05 (TTS)
```

Script chỉ cần Concept, có thể chạy parallel với Algorithm.

## Transition
→ Step 05: TTS Voice Generation

## Error Handling
- Script quá dài: Tóm tắt, bỏ bớt chi tiết
- Script quá ngắn: Thêm context, ví dụ
- Missing sync points: Review concept phases
