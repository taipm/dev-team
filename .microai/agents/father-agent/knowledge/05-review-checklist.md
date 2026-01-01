# Agent Review Checklist

Sử dụng checklist này khi review agents (command `*review`).

---

## Review Process

```
1. Load agent để review
2. Check từng category
3. Score mỗi item (✅ Pass / ⚠️ Warning / ❌ Fail)
4. Calculate overall score
5. Generate recommendations
6. Optional: Auto-fix issues
```

---

## Structure Check (20 points)

```
□ [5] Directory exists: .claude/agents/{name}/
□ [5] agent.md exists và readable
□ [5] knowledge/ directory exists
□ [5] Command entry exists: .claude/commands/{name}.md
```

---

## Metadata Check (25 points)

> **Reference**: `10-agent-metadata-spec.md` for detailed field specifications.

### Required Fields (15 points)
```
□ [3] name: present, lowercase, kebab-case, unique
□ [3] description: multi-line với 3 sections (purpose, capabilities, examples)
□ [3] model: valid enum (opus/sonnet/haiku)
□ [3] tools: array present với valid tool names
□ [3] language: explicit (vi/en) - NO DEFAULT
```

### Style Fields (5 points)
```
□ [2] color: from standard palette (purple/red/green/orange/blue/cyan/yellow/pink)
□ [2] icon: quoted emoji ("🤖")
□ [1] Field order: name → description → model → color → icon → tools → language
```

### Optional Fields (6 points)
```
□ [1] knowledge: có structure {shared: [], specific: []}
□ [1] team: specified nếu là team agent
□ [1] version: semver format ("1.0")
□ [1] tags: array of categorization tags
□ [1] alias: human-friendly name (nếu khác name)
□ [1] skills: array of skill names from .microai/skills/
```

---

## Activation Protocol Check (20 points)

```
□ [5] XML block present
□ [5] CRITICAL="MANDATORY" hoặc CRITICAL="TRUE"
□ [5] Numbered steps (step n="1", n="2"...)
□ [5] Persona section với role, identity, principles
```

---

## Content Quality Check (20 points)

```
□ [4] Has principles/philosophy section
□ [4] Has patterns với code examples
□ [4] Has anti-patterns section
□ [4] Has checklist(s)
□ [4] Has knowledge reference
```

---

## Knowledge Files Check (15 points)

```
□ [3] Files named correctly: {number}-{topic}.md
□ [3] Each file has single focused topic
□ [3] Code examples present và production-ready
□ [3] Anti-patterns documented
□ [3] knowledge-index.yaml exists với keyword mapping
```

---

## Memory System Check (15 points)

```
□ [3] memory/ directory exists
□ [3] context.md exists với proper template
□ [3] decisions.md exists với proper template
□ [3] learnings.md exists với proper template
□ [3] Activation protocol includes memory loading steps
```

### Team Memory (Additional - Teams Only)

```text
□ [+5] team-memory/ directory exists
□ [+5] handoffs.md exists
□ [+5] blockers.md exists
□ [+5] Lead has dispatch-log.md
```

---

## Scoring

| Score | Grade | Status |
|-------|-------|--------|
| 95-110 | A+ | Excellent - Full compliance with spec |
| 85-94 | A | Production ready - Minor style issues |
| 75-84 | B | Good - Some improvements needed |
| 65-74 | C | Fair - Multiple issues to fix |
| 55-64 | D | Poor - Significant work needed |
| <55 | F | Failing - Major rework required |

> **Note**: Total possible = 100 base + 10 optional + 20 team bonus = 130 points

---

## Common Issues & Fixes

### Structure Issues

| Issue | Fix |
|-------|-----|
| Missing directory | `mkdir -p .claude/agents/{name}/knowledge` |
| Missing command | Create `.claude/commands/{name}.md` |
| Wrong path in command | Update `@` path to correct location |

### Metadata Issues

| Issue | Fix |
|-------|-----|
| Missing description | Add multi-line với 3 sections |
| Invalid model | Change to opus/sonnet/haiku |
| Missing tools | Add required tools array |
| Missing language | Add explicit `language: vi` or `language: en` |
| Missing color | Add from palette: purple/red/green/orange/blue/cyan |
| Missing icon | Add quoted emoji: `icon: "🤖"` |
| CamelCase name | Convert to kebab-case |
| Inline description | Convert to multi-line with `|` |
| Wrong field order | Reorder: name → description → model → color → icon → tools → language |
| Invalid skills | Use valid skill names from .microai/skills/ |
| Wrong skills for domain | Match skills to agent's domain (dev→dev-skills, doc→doc-skills) |

### Activation Issues

| Issue | Fix |
|-------|-----|
| No XML block | Wrap in ```xml ``` code block |
| Missing CRITICAL | Add CRITICAL="MANDATORY" |
| No persona | Add persona section với role, identity |

### Content Issues

| Issue | Fix |
|-------|-----|
| No code examples | Add production-ready examples |
| No anti-patterns | Document common mistakes |
| No checklists | Add pre-task verification |

### Knowledge Issues

| Issue | Fix |
|-------|-----|
| Wrong file naming | Rename to {number}-{topic}.md |
| Too long (>300 lines) | Split into focused files |
| No index | Create knowledge-index.yaml |

### Memory Issues

| Issue | Fix |
|-------|-----|
| No memory/ directory | `mkdir -p .claude/agents/{name}/memory` |
| Missing context.md | Create from 06-memory-template.md |
| Missing decisions.md | Create from 06-memory-template.md |
| Missing learnings.md | Create from 06-memory-template.md |
| No memory in activation | Add step 2-3 for memory loading |
| No session_end protocol | Add session_end block in activation |
| Stale memory | Archive old entries, update current |
| Memory too large | Split, archive entries older than 30 days |

### Team Memory Issues (Teams)

| Issue | Fix |
|-------|-----|
| No team-memory/ | `mkdir -p .claude/agents/teams/{team}/team-memory` |
| Missing handoffs.md | Create from 07-team-memory-template.md |
| Missing blockers.md | Create from 07-team-memory-template.md |
| Lead missing dispatch-log | Create in Lead's memory/ |
| No shared context loading | Update specialist activation protocols |

---

## Review Report Template

```markdown
# Agent Review: {agent-name}

## Summary
- **Overall Score:** {score}/100 ({grade})
- **Status:** {Production Ready / Needs Work / Major Issues}

## Structure ✅/⚠️/❌
- Directory: {status}
- agent.md: {status}
- knowledge/: {status}
- Command: {status}

## Frontmatter ✅/⚠️/❌
- name: {status}
- description: {status}
- model: {status}
- tools: {status}

## Activation ✅/⚠️/❌
- XML format: {status}
- Steps: {status}
- Persona: {status}

## Content ✅/⚠️/❌
- Principles: {status}
- Patterns: {status}
- Anti-patterns: {status}
- Checklists: {status}

## Knowledge ✅/⚠️/❌
- File naming: {status}
- Code examples: {status}
- Index: {status}

## Memory ✅/⚠️/❌
- memory/ directory: {status}
- context file: {status}
- decisions file: {status}
- learnings file: {status}
- Activation loads memory: {status}
- session_end protocol: {status}

## Team Memory (if applicable) ✅/⚠️/❌
- team-memory/ directory: {status}
- handoffs file: {status}
- blockers file: {status}
- Lead dispatch-log: {status}

## Recommendations
1. {High priority fix}
2. {Medium priority fix}
3. {Low priority improvement}

## Auto-Fix Available
- [ ] {Fix 1}
- [ ] {Fix 2}
```

---

## Quick Review Commands

```bash
# Check structure
ls -la .claude/agents/{name}/
ls -la .claude/agents/{name}/knowledge/
cat .claude/commands/{name}.md

# Check frontmatter
head -20 .claude/agents/{name}/agent.md

# Check knowledge files
wc -l .claude/agents/{name}/knowledge/*.md

# Check for code examples
grep -c "^\`\`\`go" .claude/agents/{name}/knowledge/*.md
```
