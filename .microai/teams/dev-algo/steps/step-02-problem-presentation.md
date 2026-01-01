# Step 02: Problem Presentation

## Purpose
First speaker presents the problem/code/challenge to start the dialogue.

## First Speaker by Mode

| Mode | First Speaker | Presentation Type |
|------|---------------|-------------------|
| solve | Developer 👨‍💻 | Problem statement + constraints |
| review | Developer 👨‍💻 | Current implementation + issues |
| interview | Algo-Master 🧙 | Problem as interviewer |

## Presentation Formats

### Solve Mode - Developer Presents Problem

```markdown
## Problem Statement

**Problem**: {title}
**Source**: {LeetCode/Codeforces/Custom}
**Difficulty**: {Easy/Medium/Hard}

### Description
{Problem description}

### Constraints
- {constraint 1}
- {constraint 2}
- ...

### Examples

**Example 1:**
- Input: {input}
- Output: {output}
- Explanation: {explanation}

**Example 2:**
- Input: {input}
- Output: {output}

### Initial Thoughts
- Có vẻ là bài {pattern guess}
- Complexity target: O({complexity})

**Algo-Master, bạn classify problem này như thế nào?**
```

### Review Mode - Developer Presents Code

```markdown
## Code Review Request

**Problem**: {what the code solves}
**Current Status**: {WA/TLE/MLE/Works but slow}

### Current Implementation

```{language}
{code}
```

### Issues
- Issue 1: {description}
- Issue 2: {description}

### Stated Complexity
- Time: O({claimed})
- Space: O({claimed})

**Reviewer, implementation này có correct không? Algo-Master, có cách optimize không?**
```

### Interview Mode - Algo-Master Presents Problem

```markdown
## Technical Interview Problem

**Round**: Algorithm & Data Structures
**Time Limit**: 30 minutes
**Difficulty**: {Medium/Hard}

---

**Problem**:
{Problem statement - clear and concise}

**Constraints**:
- {constraint 1}
- {constraint 2}

**Examples**:
- Input: {input} → Output: {output}
- Input: {input} → Output: {output}

---

**Interviewer (Algo-Master)**:
"Take a moment to understand the problem.
Feel free to ask clarifying questions.
Explain your approach before coding."

*Hints available with `*hint` command*
```

## Validation Checks

### Problem Quality Checks
- [ ] Clear problem statement
- [ ] Constraints specified
- [ ] Examples provided
- [ ] Expected complexity inferable from constraints

### Code Review Quality Checks
- [ ] Complete code (not snippets)
- [ ] Issue clearly described
- [ ] Reproduction steps if bug

## Turn Header

```
╔═══════════════════════════════════════════════════════════════╗
║ Turn 1 | Mode: {mode} | Speaker: {agent} {icon}                ║
║ Phase: Problem Presentation                                    ║
╚═══════════════════════════════════════════════════════════════╝
```

## Observer Options

At end of presentation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Presentation complete.
   Press Enter to continue, or:
   • @{agent}: <msg> - Inject clarification
   • *skip - Skip to synthesis
   • *exit - End session
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Transition to Step 3

After presentation:
- Record presentation in session log
- Determine next speaker based on mode
- Transition to Step 3: Dialogue Loop
