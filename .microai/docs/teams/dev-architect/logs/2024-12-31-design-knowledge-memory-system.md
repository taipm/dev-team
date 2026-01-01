---
session_id: "arch-2024-12-31-001"
mode: "design"
topic: "Knowledge & Memory System Architecture"
date: "2024-12-31"
participants:
  - solution-architect
  - developer
turns: 11
status: completed
sign_offs:
  architect: approved
  developer: approved
---

# ADR-001: Knowledge & Memory System Architecture

## Status
**Accepted**

## Date
2024-12-31

## Session Context
- **Session ID**: arch-2024-12-31-001
- **Participants**: Developer, Solution Architect
- **Discussion Turns**: 11
- **Mode**: System Design

---

## Context

The dev-team project implements a multi-agent team system for Claude Code. Each team (dev-qa, dev-architect, dev-security, pm-dev, etc.) has:
- Agent persona files (markdown)
- Domain knowledge files
- Session memory (history, learnings)
- Workflow definitions

**Current Pain Points:**
1. Knowledge files duplicated across teams (e.g., OWASP content in both dev-security and dev-qa)
2. No systematic way to load knowledge based on session context
3. Memory stored as unstructured markdown, hard to query
4. No session resume capability
5. Token budget not managed

**Requirements:**
- Smart knowledge loading based on mode, keywords, context
- Cross-team knowledge sharing without duplication
- Session persistence and resume capability
- Token budget awareness
- Works within Claude Code's constraints (no runtime, file-based)

---

## Decision Drivers

1. **Simplicity**: Must work with Claude Code's stateless, file-based architecture
2. **Scalability**: Support many teams without exponential file growth
3. **DRY Principle**: Avoid knowledge duplication
4. **User Experience**: Seamless knowledge loading, easy resume
5. **npm Distribution**: Package must include all necessary files

---

## Considered Options

### Option 1: Single Flat Structure
All knowledge in team folders, copied as needed.
- **Pros**: Simple, no dependencies
- **Cons**: Duplication, maintenance nightmare

### Option 2: Database-backed (SQLite)
Store knowledge and memory in SQLite.
- **Pros**: Powerful queries, structured data
- **Cons**: Overkill, adds complexity, not Claude Code native

### Option 3: Three-Layer Architecture with Shared Registry
Shared knowledge layer + Team knowledge + Session memory.
- **Pros**: DRY, scalable, clear separation
- **Cons**: More complex structure

### Option 4: Git Submodules for Shared
Shared knowledge as git submodule.
- **Pros**: Version control, true sharing
- **Cons**: Complex setup, npm distribution issues

---

## Decision Outcome

**Chosen Option: Simplified Three-Layer Architecture (Modified Option 3)**

We adopt a three-layer architecture optimized for Claude Code's constraints:

### Architecture Overview

```
KNOWLEDGE & MEMORY SYSTEM v1.0
==============================

.microai/
├── knowledge/
│   └── shared/                    # Layer 1: Cross-team knowledge
│       ├── owasp-top-10.md
│       ├── estimation-techniques.md
│       ├── user-story-patterns.md
│       └── registry.yaml          # Metadata: paths, tokens, tags
│
└── agents/teams/{team}/
    ├── knowledge/                 # Layer 2: Team knowledge
    │   ├── knowledge-index.yaml   # Team config + shared refs
    │   └── {team-specific}.md     # Team-only knowledge
    │
    └── memory/                    # Layer 3: Session memory
        ├── context.md             # Active state (markdown)
        ├── sessions.yaml          # History (structured YAML)
        ├── learnings.md           # Patterns (narrative)
        └── checkpoints/           # Resume capability
            └── {session-id}.yaml
```

### Key Design Decisions

#### 1. Shared Knowledge as Physical Files (not references)
```yaml
# .microai/knowledge/shared/registry.yaml
knowledge:
  owasp-top-10:
    path: owasp-top-10.md
    tokens_estimate: 3000
    tags: [security, vulnerabilities]
    applicable_teams: [dev-security, dev-qa]
```

**Rationale**: Physical files work with npm distribution and Claude Code's Read tool.

#### 2. Team Index with Relative Path References
```yaml
# teams/dev-security/knowledge/knowledge-index.yaml
shared_refs:
  - id: owasp-top-10
    path: ../../../../knowledge/shared/owasp-top-10.md
    priority: high

files:
  - id: threat-modeling
    path: ./02-threat-modeling.md
    priority: high

auto_load:
  by_mode:
    review: [secure-code-review, owasp-top-10]
  by_keyword:
    injection: [owasp-top-10]
```

**Rationale**: Relative paths allow Claude Code to read directly. `auto_load` rules enable smart loading.

#### 3. Hybrid Memory Format
| File | Format | Rationale |
|------|--------|-----------|
| context.md | Markdown | Human-readable state |
| sessions.yaml | YAML | Structured, queryable history |
| learnings.md | Markdown | Narrative patterns |
| checkpoints/*.yaml | YAML | Structured resume state |

#### 4. Facilitator Prompt Pattern for Loading
```markdown
# In command file (e.g., dev-architect-session.md)

## Knowledge Loading Protocol

1. Read knowledge-index.yaml
2. Based on topic, determine mode and keywords
3. Apply auto_load rules
4. Load selected files using Read tool
5. Display: "Knowledge loaded: [list]"
```

**Rationale**: Claude Code has no runtime loader; explicit instructions in command file ensure execution.

#### 5. Checkpoint-based Resume
```yaml
# checkpoints/{session-id}.yaml
session_id: "arch-2024-12-31-001"
created: "2024-12-31T10:00:00Z"
state:
  mode: "design"
  turn_count: 5
  current_speaker: "developer"
dialogue_summary:
  - turn: 1
    speaker: "developer"
    summary: "Presented requirements"
agreements:
  - "Use shared knowledge folder"
open_issues:
  - "Token enforcement"
resume_hints:
  next_action: "Architect to propose design"
```

**Rationale**: Enables `*resume` command to restore session state.

#### 6. Token Budget as Soft Limit
```yaml
token_budget:
  max_auto_load: 5000
  strategy: "priority_then_skip"
```

**Rationale**: No runtime enforcement possible; document budget and trust agent behavior.

---

## Implementation Notes

### From Developer
- Complexity: Medium
- Estimated effort: ~6.5 days for MVP
- Key risks: Path resolution across OS, checkpoint corruption

### From Architect
- Pattern: Facilitator Prompt Pattern for knowledge loading
- Edge cases handled: File not found, keyword conflicts, no match fallback

---

## Implementation Checklist

### MVP
- [ ] Create `.microai/knowledge/shared/` folder
- [ ] Move common knowledge files to shared
- [ ] Create registry.yaml with metadata
- [ ] Update team knowledge-index.yaml with shared_refs
- [ ] Update command files with loading protocol
- [ ] Add knowledge commands (`*load:`, `*knowledge`)
- [ ] Update step-01 files with loading instructions
- [ ] Create checkpoint YAML schema
- [ ] Add `*resume` command handling
- [ ] Update workflow.md documentation
- [ ] Add to templates/ for npm package
- [ ] Test cross-team shared knowledge access

### Phase 2 (Future)
- [ ] Add summaries/ for token optimization
- [ ] Automated token counting
- [ ] Project-scoped context
- [ ] Automated summary generation

---

## Consequences

### Positive
- DRY: Shared knowledge eliminates duplication
- Scalable: Adding teams doesn't require copying knowledge
- Resumable: Sessions can be paused and continued
- Observable: Users see what knowledge is loaded
- npm-friendly: Physical files distribute cleanly

### Negative
- More complex structure than flat files
- Relative paths require careful management
- Token budget not enforced (soft limit only)
- Resume depends on checkpoint file integrity

### Neutral
- Migration needed for existing teams
- New teams need to understand structure

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Shared knowledge divergence | Medium | Low | Keep shared minimal, document update process |
| Token budget exceeded | Medium | Medium | Document clearly, warn in loading output |
| Path resolution across OS | Low | Medium | Use forward slashes, test on Windows |
| Checkpoint corruption | Low | Low | YAML validation on load, graceful fallback |
| Knowledge not loading | Low | Medium | Error handling in facilitator, fallback to agent persona |

---

## Observer Commands (New)

| Command | Effect |
|---------|--------|
| `*load: {knowledge-id}` | Load specific knowledge file |
| `*unload: {knowledge-id}` | Remove from context |
| `*knowledge` | List loaded knowledge |
| `*resume` | Resume from checkpoint |
| `*reload` | Refresh knowledge from files |

---

## Testing Plan

1. **Knowledge Loading Test**: Verify by_mode and by_keyword loading
2. **Cross-team Test**: Same shared file accessible from multiple teams
3. **Resume Test**: Session restoration from checkpoint
4. **Observer Commands Test**: `*load:` and `*knowledge` commands

---

## Links

- Related: Session workflow design
- Future: ADR for project-scoped context

---

## Sign-off

| Role | Name | Status | Date |
|------|------|--------|------|
| Solution Architect | solution-architect | ✅ Approved | 2024-12-31 |
| Developer | developer | ✅ Approved | 2024-12-31 |

---

**Generated by Dev-Architect Team Simulation**
**Session ID:** arch-2024-12-31-001
