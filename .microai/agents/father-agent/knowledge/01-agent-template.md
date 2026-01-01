# Agent Definition Template

Sử dụng template này khi tạo agent mới. Copy và fill in các placeholders.

---

## Template

```markdown
---
name: {agent-name}
description: |
  {Short description - 1 line}. Sử dụng agent này khi:
  - {Use case 1}
  - {Use case 2}
  - {Use case 3}

  Examples:
  - "{Example prompt 1}"
  - "{Example prompt 2}"
model: opus
color: {blue/red/green/purple/orange}
tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - TodoWrite
  - AskUserQuestion
language: vi
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
