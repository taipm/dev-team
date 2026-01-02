# Software Anti-Patterns

> Common mistakes to avoid in software development.

---

## Severity Legend

| Icon | Level | Meaning |
|------|-------|---------|
| :red_circle: | **CRITICAL** | Will cause failure in production |
| :yellow_circle: | **WARNING** | Will cause problems eventually |
| :green_circle: | **SMELL** | Indicates potential issues |

---

## Architecture Anti-Patterns

### Big Ball of Mud

**Severity:** :red_circle: CRITICAL

No discernible architecture, everything connected to everything.

```
┌─────────────────────────────────────┐
│                                     │
│    ????????????????????            │
│    ????????????????????            │
│    ????????????????????            │
│                                     │
└─────────────────────────────────────┘
```

**Symptoms:**
- No clear module boundaries
- Changes break unrelated parts
- "Nobody knows how it works"
- Fear of making any changes

**Prevention:**
- Establish boundaries early
- Regular refactoring
- Architectural review
- Clear ownership

---

### God Object / God Class

**Severity:** :yellow_circle: WARNING

One class does too much.

**Symptoms:**
- Class with 1000+ lines
- Knows about everything
- Changed by every feature
- Hard to test

**Prevention:**
- Single Responsibility Principle
- Extract until it hurts
- Each class = one reason to change

---

### Spaghetti Code

**Severity:** :yellow_circle: WARNING

Tangled, unstructured code flow.

**Symptoms:**
- Deep nesting (if inside if inside if...)
- Goto statements or equivalent
- Functions calling random other functions
- No clear flow

**Prevention:**
- Early return pattern
- Extract methods
- Limit nesting to 3 levels
- Clear control flow

---

## Code Anti-Patterns

### Copy-Paste Programming

**Severity:** :yellow_circle: WARNING

Duplicating code instead of abstracting.

**Symptoms:**
- Same code in multiple places
- Bug fixes needed in multiple locations
- "We have 5 versions of this function"

**Prevention:**
- DRY: Don't Repeat Yourself
- Extract common code
- Use templates/generics

---

### Magic Numbers

**Severity:** :green_circle: SMELL

Unexplained numeric values in code.

```
// Bad
if users > 100 {
    sleep(5)
}

// Good
const MaxUsersPerRequest = 100
const RetryDelaySeconds = 5

if users > MaxUsersPerRequest {
    sleep(RetryDelaySeconds)
}
```

**Prevention:**
- Named constants
- Configuration files
- Self-documenting code

---

### Premature Optimization

**Severity:** :yellow_circle: WARNING

Optimizing before measuring.

**Symptoms:**
- Complex code for hypothetical performance
- "It might be slow someday"
- No benchmarks exist
- Unreadable "optimized" code

**Prevention:**
- Measure first
- Make it work, make it right, make it fast
- Profile before optimizing
- Simple code is usually fast enough

---

### Cargo Cult Programming

**Severity:** :yellow_circle: WARNING

Copying code without understanding.

**Symptoms:**
- "Stack Overflow said to do this"
- Code that's never executed
- Rituals without purpose
- "I don't know why, but it works"

**Prevention:**
- Understand before copying
- Question every line
- Remove dead code
- Document purpose

---

## Process Anti-Patterns

### Analysis Paralysis

**Severity:** :yellow_circle: WARNING

Overthinking prevents progress.

**Symptoms:**
- Endless planning meetings
- No code written
- Perfect is enemy of good
- "We need more research"

**Prevention:**
- Time-box decisions
- Prototype quickly
- Iterate based on feedback
- "Good enough" is often enough

---

### Not Invented Here (NIH)

**Severity:** :yellow_circle: WARNING

Rejecting external solutions.

**Symptoms:**
- Rewriting standard libraries
- "We can build a better one"
- Ignoring proven solutions
- Maintaining custom everything

**Prevention:**
- Evaluate existing solutions first
- Build only what's unique
- Use standard tools
- Focus on core business

---

### Golden Hammer

**Severity:** :yellow_circle: WARNING

Using same tool for everything.

**Symptoms:**
- "Everything is a [X]"
- Forcing patterns where they don't fit
- One language/framework for all problems
- Square peg, round hole

**Prevention:**
- Right tool for the job
- Learn multiple paradigms
- Evaluate alternatives
- Be pragmatic

---

## Security Anti-Patterns

### Hardcoded Secrets

**Severity:** :red_circle: CRITICAL

Credentials in source code.

```
// NEVER DO THIS
const apiKey = "sk-1234567890abcdef"
const password = "admin123"
```

**Prevention:**
- Environment variables
- Secret management (Vault, etc.)
- Never commit secrets
- Use .gitignore

---

### Security by Obscurity

**Severity:** :red_circle: CRITICAL

Hiding instead of securing.

**Symptoms:**
- Relying on hidden URLs
- Obfuscated passwords
- "Nobody will find it"
- No real authentication

**Prevention:**
- Proper authentication
- Authorization checks
- Assume attacker knows your code
- Defense in depth

---

## Quick Reference

| Anti-Pattern | Category | Prevention |
|--------------|----------|------------|
| Big Ball of Mud | Architecture | Clear boundaries, review |
| God Object | Code | Single Responsibility |
| Spaghetti Code | Code | Extract, limit nesting |
| Copy-Paste | Code | DRY, abstraction |
| Magic Numbers | Code | Named constants |
| Premature Optimization | Process | Measure first |
| Cargo Cult | Code | Understand before copying |
| Analysis Paralysis | Process | Time-box, prototype |
| NIH Syndrome | Process | Evaluate existing |
| Golden Hammer | Process | Right tool for job |
| Hardcoded Secrets | Security | Environment variables |
| Security by Obscurity | Security | Real security |

---

## Detection Checklist

```
[ ] Classes with 500+ lines?          → God Object
[ ] Same code in 3+ places?           → Copy-Paste
[ ] Numbers without names?            → Magic Numbers
[ ] Can't explain why code exists?    → Cargo Cult
[ ] Optimizing without benchmarks?    → Premature Optimization
[ ] Secrets in git?                   → Hardcoded Secrets
[ ] "Nobody understands the code"?    → Big Ball of Mud
[ ] Using X for everything?           → Golden Hammer
```

---

*Knowledge Forge: Universal Layer*
*Applicable to: All agents, all domains*
