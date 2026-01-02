# Book Writer Team Session

Khởi động Book Writer Team session - Full workflow từ planning đến publishing với 6 agents.

## Team Overview

```
╔═══════════════════════════════════════════════════════════════╗
║               📚 BOOK WRITER TEAM v1.0                         ║
║            Technical Book Writing Pipeline                     ║
╠═══════════════════════════════════════════════════════════════╣
║  AGENTS:                                                       ║
║  📋 Planner   - Book structure & outline                       ║
║  🔍 Researcher - Research & fact-checking                      ║
║  ✍️ Writer     - Technical content writing                     ║
║  📝 Editor    - Editing & proofreading                         ║
║  🔎 Reviewer  - Technical & quality review                     ║
║  📚 Publisher - Format & publish (multi-format)                ║
╠═══════════════════════════════════════════════════════════════╣
║  WORKFLOW:                                                     ║
║  Init → Planning → Research → Writing → Editing →              ║
║  Review Loop → Publishing → Synthesis                          ║
╠═══════════════════════════════════════════════════════════════╣
║  OUTPUT FORMATS:                                               ║
║  ✓ Markdown   ✓ LaTeX   ✓ PDF   ✓ HTML   ✓ EPUB              ║
╚═══════════════════════════════════════════════════════════════╝
```

## Usage

```bash
# Start a new book session
/microai:book-writer-team-session <book topic>

# Examples
/microai:book-writer-team-session Python Web Development with FastAPI
/microai:book-writer-team-session Introduction to Machine Learning
/microai:book-writer-team-session Building REST APIs with Go
```

## Load Sequence

```yaml
1. Load Workflow:
   path: .microai/teams/book-writer-team/workflow.md
   parse: frontmatter + content

2. Load Agents:
   paths:
     - .microai/teams/book-writer-team/agents/planner-agent.md
     - .microai/teams/book-writer-team/agents/researcher-agent.md
     - .microai/teams/book-writer-team/agents/writer-agent.md
     - .microai/teams/book-writer-team/agents/editor-agent.md
     - .microai/teams/book-writer-team/agents/reviewer-agent.md
     - .microai/teams/book-writer-team/agents/publisher-agent.md

3. Load Knowledge:
   path: .microai/teams/book-writer-team/knowledge/knowledge-index.yaml
   load_on_start: [shared/technical-writing-fundamentals]

4. Load Templates:
   paths:
     - .microai/teams/book-writer-team/templates/book-outline-template.md
     - .microai/teams/book-writer-team/templates/chapter-template.md
     - .microai/teams/book-writer-team/templates/session-summary-template.md
     - .microai/teams/book-writer-team/templates/latex/book-template.tex

5. Initialize Session:
   checkpoint_path: .microai/teams/book-writer-team/checkpoints/
   communication_bus: .microai/teams/book-writer-team/communication/
   kanban_board: .microai/teams/book-writer-team/kanban/board.yaml
```

## Session Modes

| Mode | Trigger | Description |
|------|---------|-------------|
| New Book | `<topic>` | Start new book from scratch |
| Resume | `resume` | Continue from last checkpoint |
| Quick | `quick <topic>` | Minimal breakpoints |

## Observer Controls

### Basic Commands
| Command | Effect |
|---------|--------|
| `[Enter]` | Continue to next step |
| `*pause` | Pause for manual review |
| `*skip` | Skip current step |
| `*skip-to:<N>` | Jump to step N |
| `*exit` | End session |

### Agent Injection
| Command | Effect |
|---------|--------|
| `@planner: <msg>` | Inject to Planner |
| `@researcher: <msg>` | Inject to Researcher |
| `@writer: <msg>` | Inject to Writer |
| `@editor: <msg>` | Inject to Editor |
| `@reviewer: <msg>` | Inject to Reviewer |
| `@publisher: <msg>` | Inject to Publisher |

### Checkpoint Commands
| Command | Effect |
|---------|--------|
| `*checkpoints` | List all checkpoints |
| `*rollback:<N>` | Rollback to checkpoint N |

### Kanban Commands
| Command | Effect |
|---------|--------|
| `*board` | Show kanban board |
| `*status` | Quick status |
| `*metrics` | Show metrics |

### Autonomous Mode
| Command | Effect |
|---------|--------|
| `*auto` | Enable autonomous mode |
| `*auto:off` | Disable autonomous mode |

## Workflow Steps

1. **Init** - Parse topic, initialize session
2. **Planning** - Create book outline [BREAKPOINT]
3. **Research** - Gather information and sources
4. **Writing** - Write chapter content [BREAKPOINT]
5. **Editing** - Grammar, style, clarity
6. **Review Loop** - Quality gates (max 3 iterations) [BREAKPOINT]
7. **Publishing** - Generate all formats
8. **Synthesis** - Final summary

## Output

Session outputs are saved to:
```
./docs/books/{book_name}/
├── output/
│   ├── book.md        # Markdown version
│   ├── book.tex       # LaTeX source
│   ├── book.pdf       # PDF version
│   ├── html/          # HTML version
│   └── book.epub      # EPUB version
├── outline.md         # Book outline
├── research/          # Research notes
├── editing-report.md  # Editing report
└── review-report.md   # Quality review
```

## Example Session

```
> /microai:book-writer-team-session Python FastAPI Handbook

╔═══════════════════════════════════════════════════════════════╗
║               📚 BOOK WRITER TEAM SESSION                      ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: Python FastAPI Handbook                                ║
║  Date: 2024-01-15                                              ║
╠═══════════════════════════════════════════════════════════════╣
║  Starting Step 1: Session Initialization...                    ║
╚═══════════════════════════════════════════════════════════════╝

[Planner Agent activating...]
[Creating book outline...]
...
```
