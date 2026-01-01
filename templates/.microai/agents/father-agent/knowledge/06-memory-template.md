# Memory System Templates

Templates cho Agent Memory System. Copy và customize cho agent của bạn.

---

## Directory Structure

```
.claude/agents/{agent-name}/
├── agent.md
├── knowledge/
│   └── ...
└── memory/                    ← Memory folder
    ├── context.md             # Current state & focus
    ├── decisions.md           # Key decisions made
    ├── learnings.md           # Patterns learned from experience
    └── sessions/              # Optional: session logs
        └── YYYY-MM-DD.md
```

---

## Template: context.md

```markdown
# Current Context

> Last updated: YYYY-MM-DD

## Active Focus

<!-- What we're currently working on -->
- [ ] {Active task 1}
- [ ] {Active task 2}

## Project State

<!-- Key state information -->
| Aspect | Status | Notes |
|--------|--------|-------|
| {Area 1} | {Status} | {Details} |
| {Area 2} | {Status} | {Details} |

## Key Files Recently Modified

<!-- Track what's been changed -->
- `{path/to/file1.go}` - {what changed}
- `{path/to/file2.go}` - {what changed}

## Blockers & Issues

<!-- Known problems -->
- [ ] {Blocker 1}
- [ ] {Issue 1}

## Next Session Should

<!-- Guidance for next activation -->
1. {Continue with X}
2. {Check status of Y}
3. {Review Z}
```

---

## Template: decisions.md

```markdown
# Key Decisions Log

> Decisions that affect future work. Newest first.

---

## YYYY-MM-DD: {Decision Title}

**Context**: {What situation required this decision}

**Decision**: {What was decided}

**Reason**: {Why this choice}

**Alternatives Considered**:
- {Option A} - rejected because {reason}
- {Option B} - rejected because {reason}

**Impact**:
- {What this affects}
- {Files/areas impacted}

**Reversible**: Yes/No

---

## Template Entry

Copy this for new decisions:

\`\`\`markdown
## YYYY-MM-DD: {Title}

**Context**:

**Decision**:

**Reason**:

**Alternatives Considered**:
-

**Impact**:
-

**Reversible**:
\`\`\`
```

---

## Template: learnings.md

```markdown
# Patterns & Learnings

> Knowledge accumulated from experience. Grouped by category.

---

## {Category 1: e.g., "Error Handling"}

### Pattern: {Name}

**Observation**: {What we noticed}

**Solution**: {What works}

**Example**:
\`\`\`go
// Good pattern
{code example}
\`\`\`

**Anti-pattern**:
\`\`\`go
// ❌ Avoid this
{bad example}
\`\`\`

---

## {Category 2: e.g., "Performance"}

### Pattern: {Name}

...

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| {Name} | {Category} | {Context} |
| {Name} | {Category} | {Context} |
```

---

## Template: sessions/YYYY-MM-DD.md

```markdown
# Session Summary: YYYY-MM-DD

## Session Goal
{What was the objective}

## Actions Taken
1. {Action 1}
2. {Action 2}
3. {Action 3}

## Decisions Made
- {Decision 1} - see decisions.md
- {Decision 2}

## Files Modified
- `{file1}` - {change}
- `{file2}` - {change}

## Learnings
- {What was learned}

## Incomplete / Handoff
- [ ] {Task left incomplete}
- [ ] {Needs follow-up}

## Next Session Should
1. {Priority 1}
2. {Priority 2}
```

---

## Activation Protocol Update

Add these steps to agent activation:

```xml
<activation critical="MANDATORY">
  <!-- Existing steps -->
  <step n="1">Load persona từ file này</step>

  <!-- NEW: Memory loading -->
  <step n="2">Load memory/context.md để hiểu current state</step>
  <step n="3">Scan memory/decisions.md cho recent decisions</step>

  <!-- Continue with existing -->
  <step n="4">Hiển thị menu/greeting</step>
  <step n="5">Chờ user request</step>
</activation>

<session_end protocol="RECOMMENDED">
  <step n="1">Identify important decisions made this session</step>
  <step n="2">Update memory/context.md với new state</step>
  <step n="3">Add new patterns to memory/learnings.md</step>
  <step n="4">Create session summary if significant work done</step>
</session_end>
```

---

## Memory Discipline Rules

```
┌─────────────────────────────────────────────────────────────────┐
│  MEMORY DISCIPLINE - Follow These Rules                        │
└─────────────────────────────────────────────────────────────────┘

1. CONTEXT.MD
   ✓ Update at END of each session
   ✓ Keep current, remove stale info
   ✓ Focus on ACTIVE work only

2. DECISIONS.MD
   ✓ Log SIGNIFICANT decisions only
   ✓ Include reasoning (WHY)
   ✓ Note if reversible
   ✗ Don't log trivial choices

3. LEARNINGS.MD
   ✓ Add patterns that will help FUTURE sessions
   ✓ Include concrete examples
   ✗ Don't duplicate knowledge files

4. SESSIONS/
   ✓ Optional - use for complex multi-day work
   ✓ Keep brief - just highlights
   ✗ Don't create for every session
```

---

## When to Update Memory

| Event | Update What | Priority |
|-------|-------------|----------|
| Major decision made | decisions.md | HIGH |
| Task completed | context.md | MEDIUM |
| Discovered new pattern | learnings.md | MEDIUM |
| Session ending | context.md | HIGH |
| Blocker encountered | context.md | HIGH |
| Multi-day work | sessions/ | LOW |

---

## Memory Size Guidelines

| File | Target Size | Max Size |
|------|-------------|----------|
| context.md | 50-100 lines | 200 lines |
| decisions.md | 20-50 entries | 100 entries |
| learnings.md | 30-50 patterns | 100 patterns |
| session summary | 20-40 lines | 60 lines |

**When exceeding max**: Archive old entries to `memory/archive/`
