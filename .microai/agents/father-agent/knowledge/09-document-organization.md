# Document Organization Best Practices

> Separation of Concerns: Agent internals vs User-facing outputs

---

## The Problem

Khi agents/teams làm việc, họ tạo ra nhiều loại files:

| Type | Example | Who Uses | Should Git Track? |
|------|---------|----------|-------------------|
| **Agent definitions** | `agent.md`, `workflow.md` | Agent system | Yes |
| **Knowledge files** | `knowledge/*.md` | Agent system | Yes |
| **Memory/State** | `memory/context.md` | Agent system | Optional |
| **User outputs** | Digests, reports, analysis | End users | Yes |
| **Exports** | BibTeX, PDF, JSON | End users | Yes |
| **Session logs** | Raw session data | Debugging | No |

**Vấn đề:** Nếu tất cả đều trong `.microai/`, sẽ:
- Lẫn lộn giữa system files và user outputs
- Khó cho users tìm kết quả công việc
- Khó gitignore memory/logs mà vẫn track outputs
- Không clean cho production deployment

---

## The Convention

### Directory Structure

```
project-root/
│
├── docs/                              # USER-FACING OUTPUTS (git tracked)
│   ├── research/                      # Deep Research Team
│   │   ├── logs/                      # Daily digests, session outputs
│   │   ├── exports/                   # BibTeX, PDF exports
│   │   └── briefs/                    # Research briefs
│   │
│   ├── qa/                            # Dev-QA Team
│   │   ├── test-plans/                # Generated test plans
│   │   ├── bug-reports/               # Bug analysis reports
│   │   └── sessions/                  # QA session outputs
│   │
│   ├── architect/                     # Dev-Architect Team
│   │   ├── adrs/                      # Architecture Decision Records
│   │   ├── designs/                   # System design documents
│   │   └── reviews/                   # Architecture review outputs
│   │
│   ├── security/                      # Dev-Security Team
│   │   ├── audits/                    # Security audit reports
│   │   ├── threat-models/             # Threat modeling outputs
│   │   └── reviews/                   # Code review outputs
│   │
│   └── {team-name}/                   # Other teams follow same pattern
│       └── ...
│
├── .microai/                          # AGENT INTERNALS (optional git)
│   └── agents/
│       └── microai/teams/{team}/
│           ├── agent.md               # Agent definition
│           ├── workflow.md            # Team workflow
│           ├── knowledge/             # Knowledge base
│           └── memory/                # Agent state & memory
│               ├── context.md         # Current state
│               ├── user-interests.yaml # Preferences
│               └── checkpoints/       # Session checkpoints
│
└── templates/                         # TEMPLATES FOR DISTRIBUTION
    └── ...                            # Mirrors .microai structure
```

### Naming Convention

| Directory | Content | Naming Pattern |
|-----------|---------|----------------|
| `docs/{team}/logs/` | Session outputs | `{date}-{topic}-{type}.md` |
| `docs/{team}/exports/` | Export files | `{date}-{topic}.{ext}` |
| `.microai/**/memory/` | Agent state | `{purpose}.md` or `.yaml` |

**Examples:**
```
docs/research/logs/2025-12-31-llm-agents-digest.md
docs/research/exports/2025-12-31-papers.bib
docs/qa/test-plans/2025-12-31-auth-module.md
docs/architect/adrs/001-database-selection.md
```

---

## Implementation Pattern

### For New Teams

Khi tạo team mới, workflow.md phải specify output locations:

```yaml
# In workflow.md
output_locations:
  user_outputs: "docs/{team-name}/"
  subdirs:
    - logs/         # Session outputs
    - exports/      # Export files
    - {custom}/     # Team-specific

  agent_memory: ".microai/agents/microai/teams/{team-name}/memory/"
  subdirs:
    - checkpoints/  # Session state
```

### For Existing Teams

Migration steps:
1. Create `docs/{team-name}/` structure
2. Move existing logs/exports from `.microai/` to `docs/`
3. Update workflow.md với new output paths
4. Update memory/context.md to reflect new locations
5. Cleanup empty directories in `.microai/`

---

## Team-Specific Guidelines

### Deep Research Team
```
docs/research/
├── logs/
│   ├── {date}-digest.md              # Daily digests
│   └── {date}-papers/                # Individual paper cards
│       └── {arxiv_id}.md
├── exports/
│   ├── {date}-papers.bib             # BibTeX
│   └── {date}-digest.pdf             # PDF (optional)
└── briefs/
    └── {topic}-brief.md              # Research briefs
```

### Dev-QA Team
```
docs/qa/
├── test-plans/
│   └── {date}-{module}-test-plan.md
├── bug-reports/
│   └── {date}-{issue}-analysis.md
└── sessions/
    └── {date}-{topic}-session.md
```

### Dev-Architect Team
```
docs/architect/
├── adrs/
│   └── {number}-{title}.md           # ADR format
├── designs/
│   └── {component}-design.md
└── reviews/
    └── {date}-{topic}-review.md
```

### Dev-Security Team
```
docs/security/
├── audits/
│   └── {date}-{scope}-audit.md
├── threat-models/
│   └── {component}-threat-model.md
└── reviews/
    └── {date}-{type}-review.md
```

---

## Gitignore Recommendations

```gitignore
# Agent memory (optional - có thể track nếu muốn persistence)
.microai/**/memory/checkpoints/
.microai/**/memory/*.log

# Old output locations (deprecated)
.microai/**/logs/
.microai/**/exports/

# Keep user outputs
!docs/
```

---

## Migration Checklist

Khi migrate existing team:

```
□ Create docs/{team}/ directory structure
□ Move logs/ content to docs/{team}/logs/
□ Move exports/ content to docs/{team}/exports/
□ Update workflow.md output_locations section
□ Update memory/context.md với new paths
□ Update agent.md nếu có output path references
□ Remove empty directories from .microai/
□ Test team workflow với new paths
□ Update README trong docs/{team}/
```

---

## Benefits

| Benefit | Description |
|---------|-------------|
| **Clean separation** | Users find outputs in `docs/`, not buried in `.microai/` |
| **Flexible gitignore** | Memory can be gitignored, outputs tracked |
| **Production ready** | `docs/` can be deployed separately |
| **Easy backup** | Outputs and memory backup separately |
| **Multi-team clarity** | Each team has clear output location |

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Outputs in `.microai/` | Users can't find results | Use `docs/{team}/` |
| Mixed memory/outputs | Gitignore issues | Separate directories |
| No date in filenames | Hard to find recent | Always use `{date}-` prefix |
| Team-specific conventions | Inconsistent | Follow standard structure |
| Hardcoded paths | Not portable | Use config or relative paths |

---

*Father Agent Knowledge - Document Organization*
*Version: 1.0*
*Created: 2025-12-31*
