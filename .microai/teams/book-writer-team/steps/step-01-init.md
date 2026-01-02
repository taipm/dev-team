# Step 01: Session Initialization

## Trigger
Session bắt đầu khi user gọi `/microai:book-writer-team-session`

## Actions

### 1. Parse User Request
```
Phân tích input của user để xác định:
- Book topic/title
- Target audience (nếu có)
- Scope hints (nếu có)
- Output preferences (nếu có)
```

### 2. Initialize Session State
```yaml
book_writer_state:
  book_topic: "{parsed from user}"
  book_name: "{generated from topic}"
  date: "{{system_date}}"
  phase: "init"
  current_agent: null
  current_step: 1
  breakpoint_active: false
  config:
    max_iterations: 3
    min_quality_score: 80
    output_formats: ["markdown", "latex", "pdf", "html", "epub"]
  iteration_count: 0
  outputs:
    outline: null
    research: null
    chapters: []
    edited_content: null
    review_report: null
    final_book: null
  quality_metrics:
    outline_complete: false
    research_done: false
    content_written: false
    editing_pass: false
    review_pass: false
    format_pass: false
  history: []
```

### 3. Load Team Knowledge
```
Load các knowledge files:
- ./knowledge/shared/technical-writing-fundamentals.md
- Role-specific knowledge sẽ được load khi agent activate
```

### 4. Display Welcome Message
```
╔═══════════════════════════════════════════════════════════════╗
║               📚 BOOK WRITER TEAM SESSION                      ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {book_topic}                                           ║
║  Date: {date}                                                  ║
╠═══════════════════════════════════════════════════════════════╣
║  TEAM MEMBERS:                                                 ║
║  📋 Planner   - Book structure & outline                       ║
║  🔍 Researcher - Research & fact-checking                      ║
║  ✍️ Writer     - Technical content writing                     ║
║  📝 Editor    - Editing & proofreading                         ║
║  🔎 Reviewer  - Technical & quality review                     ║
║  📚 Publisher - Format & publish                               ║
╠═══════════════════════════════════════════════════════════════╣
║  WORKFLOW:                                                     ║
║  Init → Planning → Research → Writing → Editing →              ║
║  Review Loop → Publishing → Synthesis                          ║
╠═══════════════════════════════════════════════════════════════╣
║  OUTPUT FORMATS:                                               ║
║  ✓ Markdown   ✓ LaTeX   ✓ PDF   ✓ HTML   ✓ EPUB              ║
╠═══════════════════════════════════════════════════════════════╣
║  CONTROLS:                                                     ║
║  [Enter] Continue | *pause | *skip | *exit | @agent: message   ║
╚═══════════════════════════════════════════════════════════════╝
```

## Output
- Session state initialized
- Welcome message displayed
- Ready for Step 02: Planning

## Next Step
→ Step 02: Planning (Planner Agent)
