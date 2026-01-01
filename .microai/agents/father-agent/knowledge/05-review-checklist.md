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

## Frontmatter Check (20 points)

```
□ [4] name: present, lowercase, hyphenated
□ [4] description: present, has examples
□ [4] model: valid (opus/sonnet/haiku)
□ [4] tools: list present
□ [4] language: present (vi/en)
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
| 90-100 | A | Excellent - Production ready |
| 80-89 | B | Good - Minor improvements needed |
| 70-79 | C | Fair - Some issues to fix |
| 60-69 | D | Poor - Significant work needed |
| <60 | F | Failing - Major rework required |

---

## Common Issues & Fixes

### Structure Issues

| Issue | Fix |
|-------|-----|
| Missing directory | `mkdir -p .claude/agents/{name}/knowledge` |
| Missing command | Create `.claude/commands/{name}.md` |
| Wrong path in command | Update `@` path to correct location |

### Frontmatter Issues

| Issue | Fix |
|-------|-----|
| Missing description | Add với use cases và examples |
| Invalid model | Change to opus/sonnet/haiku |
| Missing tools | Add required tools list |

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
