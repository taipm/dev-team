# Code Context

> Facts được trích xuất từ code trong session hiện tại

---

## Files Read

| File | Lines | Accessed At | Relevance |
|------|-------|-------------|-----------|
<!-- Files will be logged here as they are read -->

---

## Facts Extracted

*Mỗi fact PHẢI có evidence từ code thực tế*

<!-- Template for each fact:

## Fact: {fact_id}

**Question:** {question being answered}
**Type:** {structure | behavior | relationship | pattern}

**Finding:**
{Clear description of what was found}

**Evidence:**
```
File: {relative/path}
Lines: {start}-{end}

{actual code snippet}
```

**Confidence:** {HIGH | MEDIUM}
**Extracted at:** {timestamp}

---

-->

---

## Patterns Detected

*Patterns require 2+ occurrences to be valid*

<!-- Template:

## Pattern: {pattern_id}

**Name:** {pattern name}
**Type:** {structural | behavioral | architectural}
**Occurrences:** {count}

**Evidence:**
| Location | Code |
|----------|------|
| file1.go:10 | `type XxxRepository interface` |
| file2.go:15 | `type YyyRepository interface` |

**Implications:**
{What this pattern means for the codebase}

---

-->

---

## Cross-File Relationships

*Relationships detected between components*

<!-- Template:

| From | To | Type | Evidence |
|------|-----|------|----------|
| AuthService | UserRepo | uses | auth/service.go:23 imports user/repository |

-->

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Files Read | 0 |
| Facts Extracted | 0 |
| Patterns Detected | 0 |
| Relationships Found | 0 |

---

*This file is archived at the end of each session*
*Archive path: memory/archives/{session_id}-code-context.md*
