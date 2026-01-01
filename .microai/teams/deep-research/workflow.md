# Deep Research Team Workflow

## Overview

Workflow điều phối multi-agent analysis cho arXiv papers. Hệ thống chạy **full auto mode** với 5 phases liên tiếp.

---

## Team Composition

| Agent | Icon | Role | When Active |
|-------|------|------|-------------|
| **Research Coordinator** | 🎯 | Lead, orchestration | All phases |
| **Paper Scout** | 🔍 | Fetch & filter | Phase 1-2 |
| **Deep Analyst** | 🧠 | 7-framework analysis | Phase 3 |
| **Devil's Advocate** | ⚔️ | Challenge & critique | Phase 3 |
| **Insight Weaver** | 🔗 | Synthesis & connections | Phase 4-5 |

---

## Workflow Phases

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEEP RESEARCH WORKFLOW                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Phase 1: FETCH                     Phase 2: FILTER             │
│  ┌─────────────────┐                ┌─────────────────┐         │
│  │  🔍 Paper Scout │────────────────│  🔍 Paper Scout │         │
│  │                 │                │                 │         │
│  │ • Query arXiv   │                │ • Score papers  │         │
│  │ • Check cache   │                │ • Apply prefs   │         │
│  │ • Parse results │                │ • Select top N  │         │
│  └────────┬────────┘                └────────┬────────┘         │
│           │                                  │                  │
│           ▼                                  ▼                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                   Phase 3: ANALYZE                       │   │
│  │  ┌───────────────────────────────────────────────────┐  │   │
│  │  │               For Each Paper                       │  │   │
│  │  │                                                    │  │   │
│  │  │  Turn 1-2: 🧠 Deep Analyst                        │  │   │
│  │  │            • First Principles                      │  │   │
│  │  │            • Socratic Questioning                  │  │   │
│  │  │            • 5 Whys, 6W2H, Feynman                 │  │   │
│  │  │                     │                              │  │   │
│  │  │                     ▼                              │  │   │
│  │  │  Turn 3-4: ⚔️ Devil's Advocate                    │  │   │
│  │  │            • Challenge claims                      │  │   │
│  │  │            • Find weaknesses                       │  │   │
│  │  │            • Pre-mortem analysis                   │  │   │
│  │  │                     │                              │  │   │
│  │  │                     ▼                              │  │   │
│  │  │  Turn 5:   🔗 Insight Weaver                       │  │   │
│  │  │            • Connect to other papers               │  │   │
│  │  │            • Generate analysis card                │  │   │
│  │  └───────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              ▼                                  │
│  Phase 4: SYNTHESIZE              Phase 5: OUTPUT               │
│  ┌─────────────────┐              ┌─────────────────┐          │
│  │ 🔗 Insight      │──────────────│ 🎯 Coordinator  │          │
│  │    Weaver       │              │                 │          │
│  │                 │              │ • Daily Digest  │          │
│  │ • Cross-paper   │              │ • Paper Cards   │          │
│  │ • Find patterns │              │ • BibTeX        │          │
│  │ • Identify      │              │ • PDF (opt)     │          │
│  │   trends        │              │                 │          │
│  └─────────────────┘              └─────────────────┘          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase Details

### Phase 1: FETCH

```yaml
trigger:
  - Manual: "/research [topic]"
  - Scheduled: Daily at configured time

agent: paper-scout

input:
  - user_interests from memory/user-interests.yaml
  - tracked_queries from memory/context.md
  - paper_cache from memory/paper-cache.md

process:
  1. Load user interests và tracked queries
  2. Construct arXiv API queries
  3. Fetch papers (max 50 per query)
  4. Parse XML responses
  5. Deduplicate against cache
  6. Initial metadata extraction

output:
  - candidate_papers[]
  - fetch_statistics

duration: ~2-3 minutes

checkpoint: After fetch complete
```

### Phase 2: FILTER

```yaml
trigger: Automatic after Phase 1

agent: paper-scout

input:
  - candidate_papers[]
  - user_preferences (max_papers, depth, exclusions)

process:
  1. Calculate relevance scores
     - Topic match (0.30)
     - Recency (0.15)
     - Author signal (0.15)
     - Citation velocity (0.15)
     - Novelty signal (0.10)
     - Code availability (0.10)
     - Engagement (0.05)
  2. Apply threshold filter (default 0.6)
  3. Sort by relevance
  4. Select top N papers

output:
  - selected_papers[] với relevance scores
  - filter_statistics

duration: ~1 minute

checkpoint: After filter complete
```

### Phase 3: ANALYZE

```yaml
trigger: Automatic after Phase 2

mode: full_auto (no user intervention required)

for_each_paper:
  turn_1_2:
    agent: deep-analyst
    actions:
      - Read paper abstract and key sections
      - Apply First Principles analysis
      - Apply Socratic Questioning (5 layers)
      - Apply 5 Whys to trace motivation
      - Apply 6W2H for comprehensive coverage
      - Apply Feynman Technique for understanding test
      - Answer killer questions
    output:
      - analysis_draft
      - key_contributions
      - assumptions_map
      - concerns_for_critic

  turn_3_4:
    agent: devil-advocate
    input:
      - analysis_draft from deep-analyst
      - key_contributions
      - concerns_for_critic
    actions:
      - Challenge each major claim
      - Apply Pre-mortem analysis
      - Inversion technique
      - Identify weaknesses
      - Assess reproducibility
    output:
      - critique_report
      - severity_ranked_concerns
      - verification_checklist

  turn_5:
    agent: insight-weaver
    input:
      - analysis_draft
      - critique_report
    actions:
      - Connect to other analyzed papers
      - Identify patterns
      - Generate final assessment
      - Create Paper Analysis Card
    output:
      - paper_analysis_card
      - connections_found

duration: ~5-10 minutes per paper

checkpoint: After each paper analyzed
```

### Phase 4: SYNTHESIZE

```yaml
trigger: Automatic after all papers analyzed

agent: insight-weaver

input:
  - All paper_analysis_cards[]
  - All connections_found[]
  - Previous research_journal

process:
  1. Aggregate all findings
  2. Cross-paper pattern recognition
     - Methodological trends
     - Problem evolution
     - Benchmark trends
  3. Build connection map
  4. Identify emerging trends
  5. Personalize for user interests

output:
  - synthesis_report
  - trends_identified
  - connection_graph
  - personalized_recommendations

duration: ~3-5 minutes
```

### Phase 5: OUTPUT

```yaml
trigger: Automatic after Phase 4

agent: research-coordinator

input:
  - synthesis_report
  - All paper_analysis_cards
  - trends_identified
  - personalized_recommendations

process:
  1. Generate Daily Digest
  2. Save Paper Analysis Cards
  3. Update research-journal.md
  4. Generate BibTeX file
  5. Export Obsidian-compatible markdown
  6. Generate PDF (if requested)
  7. Update memory/context.md

output:
  - logs/{date}-{topic}-digest.md
  - logs/{date}-papers/*.md (individual cards)
  - exports/{date}-papers.bib
  - exports/{date}-digest.pdf (optional)

duration: ~2-3 minutes

checkpoint: Final session save
```

---

## State Management

### Session State

```yaml
session:
  id: "{uuid}"
  started_at: "{ISO timestamp}"
  trigger: "manual|scheduled"
  topic: "{topic if specified}"

  phase: "fetch|filter|analyze|synthesize|output|complete"

  fetch_state:
    queries_executed: []
    papers_fetched: 0
    papers_after_dedup: 0

  filter_state:
    papers_above_threshold: 0
    papers_selected: 0

  analyze_state:
    current_paper_index: 0
    total_papers: 0
    papers_completed: []
    current_turn: 0

  synthesize_state:
    trends_found: 0
    connections_found: 0

  output_state:
    files_generated: []
```

### Checkpoint System

```yaml
checkpoint:
  location: memory/checkpoints/{session_id}.yaml

  save_triggers:
    - After each phase completes
    - After each paper analyzed
    - On error or interrupt

  content:
    session_state: {full state object}
    timestamp: "{ISO}"
    can_resume: true

  resume:
    command: "*resume"
    action: Load checkpoint, continue from last state
```

---

## Observer Controls (Optional)

Mặc dù mode là full_auto, user vẫn có thể intervene:

```yaml
commands:
  "*status": "Hiển thị progress hiện tại"
  "*pause": "Tạm dừng sau paper hiện tại"
  "*skip [arxiv_id]": "Bỏ qua paper cụ thể"
  "*focus [arxiv_id]": "Deep dive paper cụ thể"
  "*stop": "Dừng và save checkpoint"
  "*resume": "Tiếp tục từ checkpoint"

injection:
  "@analyst: {message}": "Gửi instruction cho deep-analyst"
  "@critic: {message}": "Gửi instruction cho devil-advocate"
  "@weaver: {message}": "Gửi instruction cho insight-weaver"
```

---

## Error Handling

```yaml
error_recovery:
  fetch_error:
    cause: "arXiv API failure"
    action:
      - Retry với exponential backoff (10s, 30s, 60s)
      - Fallback to RSS feeds
      - If still failing, notify user và save partial results

  parse_error:
    cause: "Malformed paper data"
    action:
      - Skip paper
      - Log error
      - Continue với next paper

  analysis_error:
    cause: "Agent failure during analysis"
    action:
      - Save checkpoint
      - Retry current paper
      - If 3 retries fail, skip và notify

  timeout:
    cause: "Phase taking too long"
    thresholds:
      fetch: 5 minutes
      filter: 2 minutes
      analyze_per_paper: 15 minutes
      synthesize: 10 minutes
    action:
      - Save checkpoint
      - Notify user
      - Offer resume option
```

---

## Memory Integration

### Files Updated

| File | When | What |
|------|------|------|
| `context.md` | Session end | Current state, last run |
| `research-journal.md` | After synthesis | New insights, trends |
| `paper-cache.md` | After filter | Papers with analysis status |
| `user-interests.yaml` | If user updates prefs | Tracked topics |

### Memory Flow

```
Session Start
     │
     ├─── Read context.md (last state)
     ├─── Read user-interests.yaml (preferences)
     └─── Read paper-cache.md (avoid duplicates)
     │
     ▼
[ Workflow Execution ]
     │
     ▼
Session End
     │
     ├─── Update context.md (new state)
     ├─── Append research-journal.md (findings)
     ├─── Update paper-cache.md (new papers)
     └─── Archive checkpoint (if incomplete)
```

---

## Output Locations

```
docs/research/                          # Main output directory
├── logs/
│   ├── {date}-{topic}-digest.md       # Daily digest
│   └── {date}-papers/
│       ├── {arxiv_id}.md              # Paper analysis cards
│       └── ...
├── exports/
│   ├── {date}-papers.bib              # BibTeX
│   ├── {date}-digest.pdf              # PDF (optional)
│   └── obsidian/
│       └── {date}/                    # Obsidian vault format
└── briefs/
    └── {topic}-brief.md               # Research briefs

.microai/agents/microai/teams/deep-research/memory/
├── context.md                          # Team state
├── research-journal.md                 # Accumulated insights
├── user-interests.yaml                 # User preferences
└── checkpoints/
    └── {session_id}.yaml               # Session checkpoints
```

---

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Fetch latency | < 3 min | Depends on query count |
| Papers/hour | 10-20 | Full analysis depth |
| Digest generation | < 5 min | After analysis complete |
| Memory usage | < 100MB | Checkpoint files |
| API calls | < 100/session | Respect rate limits |

---

## Quick Start

### First Run

```bash
/research
```
→ Triggers onboarding flow → Sets up user-interests.yaml → First fetch

### Daily Run

```bash
/digest
```
→ Fetch today's papers → Analyze → Generate digest

### Specific Topic

```bash
/research transformer efficiency
```
→ Fetch papers matching query → Full analysis

### Analyze Specific Paper

```bash
/analyze 2312.12345
```
→ Deep dive single paper với full multi-agent analysis
