# Knowledge File Template

Sử dụng template này khi tạo knowledge files cho agent.

---

## Template

```markdown
# {Topic Title}

## Overview

{1-2 sentences explaining what this file covers}

---

## {Main Section 1}

### {Subsection}

\`\`\`go
// {Brief description}
{Production-ready code example}
\`\`\`

**Key Points:**
- {Point 1}
- {Point 2}

### {Subsection}

\`\`\`go
// Pattern: {Name}
{Code example}
\`\`\`

---

## {Main Section 2}

| {Column 1} | {Column 2} | {Column 3} |
|------------|------------|------------|
| {Value} | {Value} | {Value} |
| {Value} | {Value} | {Value} |

---

## Common Patterns

### Pattern 1: {Name}

\`\`\`go
// ✅ DO: {Description}
{Good example}
\`\`\`

### Pattern 2: {Name}

\`\`\`go
// ✅ DO: {Description}
{Good example}
\`\`\`

---

## Anti-Patterns

### ❌ {Anti-Pattern Name}

\`\`\`go
// ❌ DON'T: {Why this is bad}
{Bad example}

// ✅ DO: {Better approach}
{Good example}
\`\`\`

---

## Quick Reference

| Pattern | Use When | Key Points |
|---------|----------|------------|
| {Name} | {Context} | {Summary} |
| {Name} | {Context} | {Summary} |

---

## Common Pitfalls

| Pitfall | Problem | Solution |
|---------|---------|----------|
| {Name} | {What goes wrong} | {How to fix} |
| {Name} | {What goes wrong} | {How to fix} |
```

---

## Structure Rules

```
1. NAMING CONVENTION
   - Format: {number}-{topic}.md
   - Number: 01, 02, 03...
   - Topic: lowercase, hyphenated
   - Example: 01-middleware-patterns.md

2. SINGLE TOPIC FOCUS
   - Mỗi file cover MỘT topic
   - Nếu file > 300 lines → split

3. CODE EXAMPLES
   - PHẢI có production-ready code
   - Include cả DO và DON'T
   - Có comments giải thích

4. TABLES FOR REFERENCE
   - Quick lookup information
   - Patterns summary
   - Pitfalls summary

5. CONSISTENT SECTIONS
   - Overview
   - Main patterns
   - Anti-patterns
   - Quick reference
```

---

## Section Templates

### For Patterns

```markdown
### Pattern: {Name}

**Context:** {When to use}

**Problem:** {What problem it solves}

**Solution:**
\`\`\`go
{Code}
\`\`\`

**Key Points:**
- {Point 1}
- {Point 2}
```

### For Anti-Patterns

```markdown
### ❌ Anti-Pattern: {Name}

**Problem:**
\`\`\`go
// This causes: {issue}
{Bad code}
\`\`\`

**Solution:**
\`\`\`go
// Better approach
{Good code}
\`\`\`

**Why:** {Explanation}
```

### For Configuration

```markdown
### Configuration: {Name}

\`\`\`go
type {Name}Config struct {
    Field1 Type1 \`yaml:"field1"\` // Description
    Field2 Type2 \`yaml:"field2"\` // Description
}
\`\`\`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| field1 | Type1 | value | Description |
| field2 | Type2 | value | Description |
```

---

## Checklist

```
□ File named correctly: {number}-{topic}.md
□ Single focused topic
□ Has overview section
□ Has code examples (DO)
□ Has anti-patterns (DON'T)
□ Has quick reference table
□ Code is production-ready
□ Comments explain WHY
□ < 300 lines (or split)
```
