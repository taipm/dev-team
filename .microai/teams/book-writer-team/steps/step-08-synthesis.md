# Step 08: Synthesis

## Agent
Orchestrator (no specific agent)

## Trigger
Step 07 hoàn thành, all formats generated

## Actions

### 1. Compile Session Summary
```
Gather all outputs and metrics from previous steps:
- Outline from Step 02
- Research from Step 03
- Chapters from Step 04
- Editing report from Step 05
- Review report from Step 06
- Publishing report from Step 07
```

### 2. Calculate Final Metrics
```yaml
session_metrics:
  duration: "{start to end time}"
  iterations: "{review loop count}"
  quality_score: "{final score}"
  word_count: "{total words}"
  page_count: "{PDF pages}"
```

### 3. Generate Session Summary

```
╔═══════════════════════════════════════════════════════════════╗
║               📚 BOOK WRITER TEAM - SESSION COMPLETE           ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  BOOK: {Title}                                                 ║
║  TOPIC: {Topic}                                                ║
║  DATE: {Date}                                                  ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  SESSION METRICS                                               ║
║  ┌────────────────┬───────────────────────────────┐           ║
║  │ Duration       │ {duration}                    │           ║
║  │ Quality Score  │ {score}/100                   │           ║
║  │ Review Iters   │ {count}                       │           ║
║  └────────────────┴───────────────────────────────┘           ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  BOOK STATISTICS                                               ║
║  ┌────────────────┬───────────────────────────────┐           ║
║  │ Chapters       │ {count}                       │           ║
║  │ Words          │ {count}                       │           ║
║  │ Pages (PDF)    │ {count}                       │           ║
║  │ Code Examples  │ {count}                       │           ║
║  │ Exercises      │ {count}                       │           ║
║  └────────────────┴───────────────────────────────┘           ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  QUALITY GATES                                                 ║
║  [✓] Outline Complete                                         ║
║  [✓] Research Done                                            ║
║  [✓] Content Written                                          ║
║  [✓] Editing Pass                                             ║
║  [✓] Review Pass                                              ║
║  [✓] Format Pass                                              ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  DELIVERABLES                                                  ║
║                                                                ║
║  📄 Markdown:  ./docs/books/{name}/output/book.md             ║
║  📑 LaTeX:     ./docs/books/{name}/output/book.tex            ║
║  📕 PDF:       ./docs/books/{name}/output/book.pdf            ║
║  🌐 HTML:      ./docs/books/{name}/output/html/index.html     ║
║  📱 EPUB:      ./docs/books/{name}/output/book.epub           ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  SUPPORTING FILES                                              ║
║                                                                ║
║  📋 Outline:       ./docs/books/{name}/outline.md             ║
║  🔍 Research:      ./docs/books/{name}/research/              ║
║  📝 Editing Report: ./docs/books/{name}/editing-report.md     ║
║  🔎 Review Report:  ./docs/books/{name}/review-report.md      ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  TEAM CONTRIBUTIONS                                            ║
║                                                                ║
║  📋 Planner    - Created outline with {N} chapters            ║
║  🔍 Researcher - Found {N} sources, {N} code examples         ║
║  ✍️ Writer     - Wrote {N} words, {N} exercises               ║
║  📝 Editor     - Fixed {N} issues                             ║
║  🔎 Reviewer   - Scored {N}/100 after {N} iterations          ║
║  📚 Publisher  - Generated 5 output formats                   ║
║                                                                ║
╚═══════════════════════════════════════════════════════════════╝

Thank you for using Book Writer Team! 📚
```

### 4. Save Session Log
```
Path: ./logs/{date}-{book_name}-session.md

Contents:
- Full session summary
- All metrics
- File paths
- Team contributions
- Timestamps
```

### 5. Clean Up
```
- Archive checkpoint files
- Clear communication bus
- Update kanban board (mark complete)
- Save memory for future sessions
```

### 6. Final State
```yaml
book_writer_state:
  phase: "complete"
  current_step: 8

  quality_metrics:
    outline_complete: true
    research_done: true
    content_written: true
    editing_pass: true
    review_pass: true
    format_pass: true

  status: "SUCCESS"
```

## Output
```yaml
session_log:
  path: "./logs/{date}-{book_name}-session.md"
  status: "complete"
  duration: "{duration}"
  quality_score: "{score}"

final_deliverables:
  - "./docs/books/{book_name}/output/book.md"
  - "./docs/books/{book_name}/output/book.tex"
  - "./docs/books/{book_name}/output/book.pdf"
  - "./docs/books/{book_name}/output/html/"
  - "./docs/books/{book_name}/output/book.epub"
```

## Session End
```
Session complete. All files saved.

To resume or start a new book:
/microai:book-writer-team-session <topic>
```
