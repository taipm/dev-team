# Agent Definition Template

Sử dụng template này khi tạo agent mới. Copy và fill in các placeholders.

> **Spec Reference**: Xem `10-agent-metadata-spec.md` để hiểu chi tiết về mỗi field.

---

## Metadata Fields Quick Reference

| Field | Required | Type | Example |
|-------|----------|------|---------|
| `name` | ✓ | kebab-case | `my-agent` |
| `description` | ✓ | multi-line | See below |
| `model` | ✓ | enum | `opus`, `sonnet`, `haiku` |
| `tools` | ✓ | array | `[Read, Write, ...]` |
| `language` | ✓ | enum | `vi`, `en` |
| `color` | ★ | string | `purple`, `red`, `green`, ... |
| `icon` | ★ | emoji | `"🤖"` |
| `skills` | ○ | array | `[pdf, webapp-testing]` |
| `persona` | ○ | dict | `{role, identity, communication_style, principles}` |
| `thinking` | ○ | multi-line | Reasoning guidelines |
| `critical_actions` | ○ | array | Init actions on startup |
| `knowledge` | ○ | dict | `{shared: [], specific: []}` |
| `team` | ○ | string | `go-team` |
| `version` | ○ | semver | `"1.0"` |
| `tags` | ○ | array | `[golang, testing]` |

**Legend**: ✓ Required, ★ Recommended, ○ Optional

---

## Template

```markdown
---
# ═══════════════════════════════════════════════════════════════
# IDENTIFICATION (Required)
# ═══════════════════════════════════════════════════════════════
name: {agent-name}
description: |
  {One-liner purpose}. Sử dụng agent này khi cần:
  - {Capability 1}
  - {Capability 2}
  - {Capability 3}

  Examples:
  - "{Example prompt 1}"
  - "{Example prompt 2}"

# ═══════════════════════════════════════════════════════════════
# MODEL SELECTION (Required)
# ═══════════════════════════════════════════════════════════════
# opus   = Complex reasoning, architecture, multi-step
# sonnet = Balanced analysis, documentation, review
# haiku  = Simple tasks, fast, lightweight
model: opus

# ═══════════════════════════════════════════════════════════════
# STYLE (Recommended)
# ═══════════════════════════════════════════════════════════════
# Colors: purple(meta), red(dev), green(test), orange(config),
#         blue(analysis), cyan(comm), yellow(docs), pink(creative)
color: purple
icon: "🤖"

# ═══════════════════════════════════════════════════════════════
# CAPABILITIES (Required)
# ═══════════════════════════════════════════════════════════════
tools:
  - Bash           # Shell commands
  - Read           # Read files
  - Write          # Create/overwrite files
  - Edit           # Edit existing files
  - Glob           # Pattern file search
  - Grep           # Content search
  - TodoWrite      # Task management
  - AskUserQuestion # User interaction
  # - LSP          # Language Server Protocol
  # - Task         # Spawn sub-agents
  # - WebFetch     # Fetch URLs
  # - WebSearch    # Web search

# ═══════════════════════════════════════════════════════════════
# LOCALIZATION (Required)
# ═══════════════════════════════════════════════════════════════
language: vi

# ═══════════════════════════════════════════════════════════════
# SKILLS (Optional - from .microai/skills/)
# ═══════════════════════════════════════════════════════════════
# skills:
#   - pdf              # document-skills/pdf
#   - docx             # document-skills/docx
#   - webapp-testing   # development-skills/webapp-testing
#   - mcp-builder      # development-skills/mcp-builder
#   - frontend-design  # design-skills/frontend-design
#   - doc-coauthoring  # communication-skills/doc-coauthoring

# ═══════════════════════════════════════════════════════════════
# PERSONA (Optional - for agents needing clear identity)
# ═══════════════════════════════════════════════════════════════
# persona:
#   role: |
#     {Primary role and responsibilities}
#   identity: |
#     {Background, experience, personality}
#   communication_style:
#     - {How agent communicates - style 1}
#     - {How agent communicates - style 2}
#   principles:
#     - "{Core principle 1}"
#     - "{Core principle 2}"

# ═══════════════════════════════════════════════════════════════
# THINKING (Optional - reasoning guidelines)
# ═══════════════════════════════════════════════════════════════
# thinking: |
#   {How to approach problems - step by step}
#   1. {Step 1}
#   2. {Step 2}
#
#   {Priority order for decisions}
#   - {Priority 1}
#   - {Priority 2}

# ═══════════════════════════════════════════════════════════════
# CRITICAL ACTIONS (Optional - startup actions)
# ═══════════════════════════════════════════════════════════════
# critical_actions:
#   - "Load project configuration from {path}"
#   - "Check current state via {command/file}"
#   - "Read relevant context from {source}"

# ═══════════════════════════════════════════════════════════════
# KNOWLEDGE BASE (Optional - for structured teams)
# ═══════════════════════════════════════════════════════════════
# knowledge:
#   shared:
#     - ../knowledge/shared/01-fundamentals.md
#   specific:
#     - ./knowledge/01-agent-patterns.md

# ═══════════════════════════════════════════════════════════════
# ORGANIZATION (Optional)
# ═══════════════════════════════════════════════════════════════
# team: go-team
# version: "1.0"
# tags: [golang, backend]
---

# {Agent Title}

> "{Memorable quote hoặc tagline}"

---

## Activation Protocol

\`\`\`xml
<agent id="{agent-name}" name="{Agent Name}" title="{Title}" icon="{emoji}">
<activation critical="MANDATORY">
  <step n="1">Load persona từ file này</step>
  <step n="2">Load memory/context.md - hiểu current state</step>
  <step n="3">Scan memory/decisions.md - recent decisions</step>
  <step n="4">{Custom step - menu/greeting}</step>
  <step n="5">Chờ user request</step>
</activation>

<persona>
  <role>{Primary role description}</role>
  <identity>{What defines this agent}</identity>
  <communication_style>{How agent communicates}</communication_style>
  <principles>
    - {Principle 1}
    - {Principle 2}
    - {Principle 3}
  </principles>
</persona>

<rules>
  - {Rule 1 - MUST do}
  - {Rule 2 - NEVER do}
  - {Rule 3 - ALWAYS do}
</rules>

<session_end protocol="RECOMMENDED">
  <step n="1">Identify important decisions made this session</step>
  <step n="2">Update memory/context.md với new state</step>
  <step n="3">Add patterns learned to memory/learnings.md</step>
</session_end>
</agent>
\`\`\`

---

## Core Principles

### {Principle Category 1}

\`\`\`
1. {Principle}
   - {Detail}
   - {Detail}

2. {Principle}
   - {Detail}
\`\`\`

### {Principle Category 2}

| Pattern | Description | When to Use |
|---------|-------------|-------------|
| {Name} | {Description} | {Context} |
| {Name} | {Description} | {Context} |

---

## Main Patterns

### Pattern 1: {Name}

\`\`\`go
// {Description}
{Production-ready code example}
\`\`\`

**Why:** {Explanation}

**Anti-pattern:**
\`\`\`go
// ❌ DON'T do this
{Bad example}
\`\`\`

### Pattern 2: {Name}

...

---

## Pre-Task Checklist

\`\`\`
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ {CHECKLIST TITLE} - VERIFY BEFORE CODING                   │
└─────────────────────────────────────────────────────────────────┘

□ 1. {Check item 1}
    - {Detail}
    - {Detail}

□ 2. {Check item 2}
    - {Detail}

□ 3. {Check item 3}
    - {Detail}
\`\`\`

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| {Name} | {What goes wrong} | {How to fix} |
| {Name} | {What goes wrong} | {How to fix} |

---

## Knowledge Base

### Available Knowledge Files

| File | Content | When to Load |
|------|---------|--------------|
| `01-{topic}.md` | {Description} | {Keywords} |
| `02-{topic}.md` | {Description} | {Keywords} |

### Loading Strategy

\`\`\`
TASK RECEIVED
     │
     ▼
EXTRACT KEYWORDS from task
     │
     ▼
MATCH against knowledge-index.yaml
     │
     ▼
LOAD: Core files + Matched files
\`\`\`

---

## Memory System

### Memory Directory Structure

\`\`\`
memory/
├── context.md      # Current state & active focus
├── decisions.md    # Key decisions made
├── learnings.md    # Patterns learned from experience
└── sessions/       # Optional: session summaries
    └── YYYY-MM-DD.md
\`\`\`

### Memory Files Purpose

| File | Purpose | Update Frequency |
|------|---------|------------------|
| `context.md` | Current project state, active tasks, blockers | Every session |
| `decisions.md` | Important decisions with reasoning | When decisions made |
| `learnings.md` | Patterns discovered, anti-patterns found | When patterns emerge |
| `sessions/` | Session summaries for complex work | Optional |

### Memory Loading (on Activation)

\`\`\`
AGENT ACTIVATED
     │
     ▼
LOAD memory/context.md
     │ (Understand current state)
     ▼
SCAN memory/decisions.md
     │ (Know recent decisions)
     ▼
READY for user request
\`\`\`

### Memory Update (on Session End)

\`\`\`
SESSION ENDING
     │
     ▼
IDENTIFY significant decisions
     │
     ▼
UPDATE memory/context.md
     │ (New state, completed tasks)
     ▼
ADD to memory/decisions.md
     │ (If major decisions made)
     ▼
ADD to memory/learnings.md
     │ (If new patterns discovered)
     ▼
SESSION COMPLETE
\`\`\`

---

## The {Agent Name} Principles

\`\`\`
1. {PRINCIPLE NAME}
   → {Description}

2. {PRINCIPLE NAME}
   → {Description}

3. {PRINCIPLE NAME}
   → {Description}
\`\`\`

**{Closing tagline}**
```

---

## Placeholders Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{agent-name}` | Lowercase, hyphenated | `gateway-agent` |
| `{Agent Name}` | Title case | `Gateway Agent` |
| `{emoji}` | Single emoji | `🌐` |
| `{color}` | Theme color | `blue` |
| `{model}` | AI model | `opus` |
