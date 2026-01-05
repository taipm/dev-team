# Workflow Catalog

> Catalog các automated workflows có sẵn trong hệ thống.
> Taipm Agent sử dụng để trigger workflows phù hợp.

---

## Quick Reference

| Workflow | Trigger | Output | Team/Agent |
|----------|---------|--------|------------|
| URL → Audiobook | URL + "audiobook" | MP3 file | audiobook-production-team |
| URL → Video | URL + "video" | MP4 file | youtube-team |
| URL → Research | URL + "research" | Digest.md | deep-research |
| Code → Review | Code + "review" | Review report | go-review-linus-agent |
| Problem → Analysis | Problem + "deep" | Solution blueprint | deep-thinking-team |
| Question → Exploration | Question + "explore" | Insights | deep-question-agent |
| Idea → Content | Idea + "content" | Blog/social posts | book-writer-team |
| Daily → Briefing | "daily" / morning | Summary | daily-agent |
| Agent → Create | "create agent" | New agent | father-agent |

---

## Content Creation Workflows

### 1. URL to Audiobook

```yaml
id: url-to-audiobook
name: URL to Audiobook Production
trigger:
  patterns:
    - URL + "audiobook"
    - URL + "audio"
    - URL + "sách nói"
    - "tạo audiobook từ"
  confidence: high

team: audiobook-production-team
output: output/audiobooks/{date}-{slug}/

steps:
  1. Fetch URL content
  2. Extract and clean text
  3. Segment into chapters
  4. Generate TTS audio
  5. Merge and master
  6. Quality check
  7. Export final MP3

duration: 5-15 minutes
auto_approve: true
```

### 2. URL to Video

```yaml
id: url-to-video
name: URL to YouTube Video
trigger:
  patterns:
    - URL + "video"
    - URL + "youtube"
    - "tạo video từ"
  confidence: high

team: youtube-team
output: output/youtube/{date}-{slug}/

steps:
  1. Fetch and analyze content
  2. Generate script
  3. Create visual assets
  4. Generate voiceover
  5. Compose video
  6. Add subtitles
  7. Export

duration: 15-30 minutes
auto_approve: false  # Confirm before publish
```

### 3. Idea to Content

```yaml
id: idea-to-content
name: Idea to Multi-format Content
trigger:
  patterns:
    - "viết về" + topic
    - "tạo content về"
    - idea + "content"
  confidence: medium

team: book-writer-team
output: output/content/{date}-{topic}/

steps:
  1. Expand idea into outline
  2. Generate long-form content
  3. Create social snippets
  4. Generate visuals (optional)

duration: 10-20 minutes
auto_approve: true
```

---

## Development Workflows

### 4. Code Review (Go)

```yaml
id: go-code-review
name: Go Code Review - Linus Style
trigger:
  patterns:
    - "review" + (*.go | "go code")
    - "đánh giá code go"
    - PR link + "review"
  confidence: high

agent: go-review-linus-agent
output: Review report in conversation

steps:
  1. Read code files
  2. Analyze structure
  3. Check patterns/anti-patterns
  4. Security review
  5. Performance review
  6. Generate brutally honest feedback

duration: 2-5 minutes
auto_approve: true
```

### 5. Algorithm Design

```yaml
id: algo-design
name: Algorithm Design & Specification
trigger:
  patterns:
    - "thiết kế algorithm"
    - "design function"
    - problem + "algorithm"
  confidence: medium

agent: algo-function-agent
output: Algorithm spec + pseudocode

steps:
  1. Understand problem
  2. Identify constraints
  3. Design approach
  4. Write pseudocode
  5. Create handoff package

duration: 5-15 minutes
auto_approve: true
```

### 6. Full Go Project

```yaml
id: go-project
name: Full Go Project Development
trigger:
  patterns:
    - "dự án go"
    - "go project"
    - "build go app"
  confidence: high

team: go-team
output: Complete Go project

steps:
  1. Requirements analysis
  2. Architecture design
  3. Implementation
  4. Testing
  5. Code review
  6. Documentation
  7. Deployment prep

duration: 30-120 minutes
auto_approve: false  # Checkpoint confirmations
```

---

## Analysis Workflows

### 7. Deep Analysis

```yaml
id: deep-analysis
name: Deep Thinking Team Analysis
trigger:
  patterns:
    - "phân tích sâu"
    - "deep analysis"
    - "strategic" + problem
    - "nhiều góc nhìn"
  confidence: high

team: deep-thinking-team
output: output/deep-thinking/{session-id}/

steps:
  1. Problem classification
  2. Phase 1: Understand (Socrates + Aristotle)
  3. Phase 2: Deconstruct (Musk + Feynman)
  4. Phase 3: Challenge (Munger + Grove)
  5. Phase 4: Solve (Polya + Builders)
  6. Phase 5: Synthesize (Da Vinci)
  7. Auto-save artifacts

duration: 30-60 minutes
auto_approve: true
```

### 8. Deep Question Exploration

```yaml
id: deep-question
name: Socratic Exploration
trigger:
  patterns:
    - "đặt câu hỏi"
    - "explore" + topic
    - "blind spots"
    - "assumptions"
  confidence: high

agent: deep-question-agent
output: Session insights + questions

steps:
  1. Topic detection
  2. Framework selection
  3. Iterative questioning (5-10 turns)
  4. Insight synthesis
  5. Session summary

duration: 15-30 minutes
auto_approve: true
```

### 9. Research Deep Dive

```yaml
id: deep-research
name: Research & Paper Analysis
trigger:
  patterns:
    - "research" + topic
    - "nghiên cứu về"
    - "arxiv" + topic
    - "paper" + topic
  confidence: medium

team: deep-research
output: output/research/{date}-{topic}/

steps:
  1. Search relevant papers
  2. Fetch and analyze
  3. Extract key insights
  4. Synthesize findings
  5. Generate digest

duration: 15-30 minutes
auto_approve: true
```

---

## Daily Operations Workflows

### 10. Daily Briefing

```yaml
id: daily-briefing
name: Morning Daily Briefing
trigger:
  patterns:
    - "daily"
    - "morning"
    - "buổi sáng"
    - "báo cáo ngày"
  confidence: high

agent: daily-agent
output: Daily summary + task list

steps:
  1. Load yesterday's context
  2. Check pending tasks
  3. Review priorities
  4. Generate briefing
  5. Update kanban (if configured)

duration: 2-5 minutes
auto_approve: true
```

### 11. Root Cause Analysis

```yaml
id: root-cause
name: 5-Why Root Cause Analysis
trigger:
  patterns:
    - "root cause"
    - "nguyên nhân gốc"
    - "5 why"
    - "tại sao" + problem
  confidence: high

agent: root-cause-agent
output: Root cause diagram + recommendations

steps:
  1. Define problem
  2. Iterative 5-Why
  3. Identify root cause
  4. Generate recommendations
  5. Create action plan

duration: 5-15 minutes
auto_approve: true
```

---

## Meta Workflows

### 12. Create Agent

```yaml
id: create-agent
name: Create New Agent
trigger:
  patterns:
    - "tạo agent"
    - "create agent"
    - "agent mới"
  confidence: high

agent: father-agent
output: .microai/agents/{new-agent}/

steps:
  1. Discovery (requirements)
  2. Validation (check overlap)
  3. Design Review (Deep Thinking Team)
  4. Approval Gate
  5. Structure creation
  6. Content generation
  7. Registration
  8. Verification

duration: 15-30 minutes
auto_approve: false  # Design review required
```

### 13. Evaluate Agent

```yaml
id: evaluate-agent
name: Agent Intelligence Evaluation
trigger:
  patterns:
    - "đánh giá agent"
    - "evaluate agent"
    - "benchmark agent"
  confidence: high

agent: agent-evaluator
output: Evaluation report

steps:
  1. Static analysis (30%)
  2. Dynamic testing (55%)
  3. Synthesis (15%)
  4. Generate report

duration: 10-20 minutes
auto_approve: true
```

---

## Workflow Selection Algorithm

```
USER INPUT
    │
    ▼
EXTRACT patterns (keywords, entities, context)
    │
    ▼
MATCH against workflow triggers
    │
    ├── Single match (confidence > 80%)
    │   └→ Execute workflow
    │
    ├── Multiple matches
    │   └→ Ask user to choose OR
    │       Use preference overrides
    │
    └── No match (confidence < 50%)
        └→ Route to generic agent OR
            Ask for clarification
```

---

## Workflow Chaining

Some workflows can be chained:

```yaml
chains:
  url-to-social:
    - url-to-audiobook
    - idea-to-content (from transcript)

  research-to-content:
    - deep-research
    - idea-to-content (from findings)

  problem-to-solution:
    - deep-question (exploration)
    - deep-analysis (solution)
    - algo-design (implementation spec)
```

---

*Catalog maintained by Taipm Agent. Last updated: 2026-01-04*
