# Team Memory System Templates

Templates cho Team với nhiều agents. Bao gồm shared memory và coordination.

---

## Directory Structure

```
.claude/agents/microai/teams/{team-name}/
│
├── team-memory/                   ← SHARED MEMORY (tất cả members access)
│   ├── context.md                 # Team-wide project state
│   ├── decisions.md               # Team decisions (consensus)
│   ├── handoffs.md                # Agent-to-agent handoffs
│   ├── blockers.md                # Current blockers
│   └── retrospectives/            # Team retrospectives
│       └── YYYY-MM-DD.md
│
├── lead-agent/                    ← Team Lead
│   ├── agent.md
│   ├── knowledge/
│   └── memory/                    # Lead's personal memory
│       ├── dispatch-log.md        # What was dispatched to whom
│       ├── synthesis-notes.md     # Notes from synthesizing results
│       └── learnings.md
│
├── specialist-agent-1/            ← Specialist
│   ├── agent.md
│   ├── knowledge/
│   └── memory/                    # Specialist's personal memory
│       ├── context.md
│       ├── decisions.md
│       └── learnings.md
│
└── specialist-agent-2/            ← Another Specialist
    ├── agent.md
    ├── knowledge/
    └── memory/
        └── ...
```

---

## Template: team-memory/context.md

```markdown
# Team Context

> Last updated: YYYY-MM-DD by {agent-name}

## Team Mission
{What this team is responsible for}

## Current Sprint/Focus

### Active Tasks
| Task | Assigned To | Status | Started |
|------|-------------|--------|---------|
| {Task 1} | {agent} | 🔄 In Progress | YYYY-MM-DD |
| {Task 2} | {agent} | ⏳ Pending | - |
| {Task 3} | {agent} | ✅ Done | YYYY-MM-DD |

### Sprint Goal
{What we're trying to achieve this sprint}

## Project State Overview

| Area | Owner | Status | Last Update |
|------|-------|--------|-------------|
| {Area 1} | {agent} | {Status} | YYYY-MM-DD |
| {Area 2} | {agent} | {Status} | YYYY-MM-DD |

## Key Files Team Is Working On

- `{path/file1.go}` - {agent} working on {what}
- `{path/file2.go}` - {agent} completed {what}

## Dependencies & Integration Points

| Our Component | Depends On | Status |
|---------------|------------|--------|
| {Component} | {External} | {Status} |

## Notes for Next Session
1. {Priority item}
2. {Follow-up needed}
```

---

## Template: team-memory/decisions.md

```markdown
# Team Decisions Log

> Decisions made by team consensus. Newest first.

---

## YYYY-MM-DD: {Decision Title}

**Participants**: {agent-1}, {agent-2}, {agent-3}

**Context**: {Situation requiring team decision}

**Decision**: {What was decided}

**Reasoning**:
- {Reason 1}
- {Reason 2}

**Dissenting Views** (if any):
- {agent-x} preferred {alternative} because {reason}

**Action Items**:
- [ ] {agent-1}: {action}
- [ ] {agent-2}: {action}

**Review Date**: {When to revisit if needed}

---
```

---

## Template: team-memory/handoffs.md

```markdown
# Agent Handoffs

> Record of work passed between team members. Newest first.

---

## YYYY-MM-DD HH:MM: {From Agent} → {To Agent}

**Task**: {What is being handed off}

**Status at Handoff**:
- Completed: {what's done}
- Remaining: {what's left}

**Key Context**:
- {Important info 1}
- {Important info 2}

**Files Involved**:
- `{file1.go}` - {state}
- `{file2.go}` - {state}

**Blockers/Risks**:
- {Any known issues}

**Expected Next Steps**:
1. {What receiving agent should do first}
2. {Then this}

**Handoff Verified**: ✅/❌

---

## Handoff Protocol

\`\`\`
BEFORE HANDOFF:
□ Document current state
□ List remaining work
□ Note any blockers
□ Commit/save all changes

DURING HANDOFF:
□ Add entry to this file
□ @mention receiving agent
□ Provide context summary

AFTER HANDOFF:
□ Receiving agent confirms
□ Mark "Handoff Verified"
\`\`\`
```

---

## Template: team-memory/blockers.md

```markdown
# Current Blockers

> Active blockers affecting team. Remove when resolved.

---

## 🔴 Critical Blockers

### {Blocker Title}
- **Reported by**: {agent}
- **Date**: YYYY-MM-DD
- **Affects**: {what tasks/agents}
- **Description**: {details}
- **Attempted Solutions**:
  - {tried this} - {result}
- **Needs**: {what's required to unblock}
- **Owner**: {who's working on it}

---

## 🟡 Medium Blockers

### {Blocker Title}
...

---

## 🟢 Resolved Blockers (Last 7 Days)

### {Blocker Title} ✅
- **Resolved**: YYYY-MM-DD
- **Solution**: {how it was fixed}
- **Lesson**: {what we learned}

---

## Escalation Path

| Level | Condition | Action |
|-------|-----------|--------|
| 1 | Blocked > 1 hour | Ask team lead |
| 2 | Blocked > 4 hours | Escalate to user |
| 3 | Blocked > 1 day | Stop and report |
```

---

## Template: Lead Agent dispatch-log.md

```markdown
# Dispatch Log

> Tasks dispatched to specialists. Track for synthesis.

---

## Active Dispatches

| ID | Task | Assigned To | Dispatched | Status | Priority |
|----|------|-------------|------------|--------|----------|
| D001 | {Task} | {agent} | YYYY-MM-DD | 🔄 Active | High |
| D002 | {Task} | {agent} | YYYY-MM-DD | ⏳ Pending | Medium |

---

## Dispatch: D001

**Task**: {Full task description}

**Assigned To**: {specialist-agent}

**Context Provided**:
- {Context 1}
- {Context 2}

**Expected Deliverable**:
- {What specialist should return}

**Deadline**: {If applicable}

**Result**:
- Status: {Pending/Completed/Blocked}
- Output: {Summary of what was returned}
- Quality: {Assessment}

---

## Synthesis Queue

Tasks ready for Lead to synthesize:

- [ ] D001 result from {agent}
- [ ] D002 result from {agent}

---

## Dispatch Patterns

| Pattern | When to Use |
|---------|-------------|
| Parallel | Independent subtasks |
| Sequential | Dependent tasks |
| Broadcast | Need input from all |
| Targeted | Specific expertise needed |
```

---

## Team Activation Protocol

### Lead Agent

```xml
<activation critical="MANDATORY">
  <step n="1">Load persona từ agent.md</step>
  <step n="2">Load team-memory/context.md - team state</step>
  <step n="3">Check team-memory/blockers.md - any blockers?</step>
  <step n="4">Load memory/dispatch-log.md - pending dispatches</step>
  <step n="5">Greet user với team status overview</step>
</activation>

<dispatch_protocol>
  <step n="1">Analyze task - determine specialists needed</step>
  <step n="2">Check specialist availability (no conflicts)</step>
  <step n="3">Log dispatch to dispatch-log.md</step>
  <step n="4">Invoke specialist với clear context</step>
  <step n="5">Collect results</step>
  <step n="6">Synthesize and respond</step>
</dispatch_protocol>

<session_end>
  <step n="1">Update team-memory/context.md</step>
  <step n="2">Log any handoffs to handoffs.md</step>
  <step n="3">Update blockers.md if any</step>
</session_end>
```

### Specialist Agent

```xml
<activation critical="MANDATORY">
  <step n="1">Load persona từ agent.md</step>
  <step n="2">Load team-memory/context.md - understand team state</step>
  <step n="3">Load memory/context.md - personal context</step>
  <step n="4">Ready to receive tasks from Lead</step>
</activation>

<task_completion>
  <step n="1">Complete assigned task</step>
  <step n="2">Document in personal memory/context.md</step>
  <step n="3">Update team-memory/handoffs.md if passing work</step>
  <step n="4">Report result to Lead</step>
</task_completion>
```

---

## Team Memory Discipline

```
┌─────────────────────────────────────────────────────────────────┐
│  TEAM MEMORY RULES                                              │
└─────────────────────────────────────────────────────────────────┘

SHARED (team-memory/):
  ✓ ALL agents can READ
  ✓ Update khi có team-wide changes
  ✓ Use for coordination
  ✗ Don't put agent-specific details

PERSONAL (agent/memory/):
  ✓ Agent-specific context
  ✓ Personal learnings
  ✓ Task-specific notes
  ✗ Don't duplicate team info

HANDOFFS:
  ✓ ALWAYS log when passing work
  ✓ Include full context
  ✓ Receiving agent confirms
  ✗ Don't hand off without logging

BLOCKERS:
  ✓ Log immediately when blocked
  ✓ Update when resolved
  ✓ Include attempted solutions
  ✗ Don't let blockers go unreported
```

---

## Team Retrospective Template

```markdown
# Team Retrospective: YYYY-MM-DD

## Period Covered
{Date range}

## Participants
- {Lead agent}
- {Specialist 1}
- {Specialist 2}

## What Went Well
- {Success 1}
- {Success 2}

## What Could Improve
- {Issue 1} → {Proposed solution}
- {Issue 2} → {Proposed solution}

## Handoff Quality
- Total handoffs: {N}
- Clean handoffs: {N}
- Issues: {Description}

## Decisions Made
- {Decision 1} - {outcome}
- {Decision 2} - {outcome}

## Action Items for Next Sprint
- [ ] {Action 1}
- [ ] {Action 2}

## Knowledge Gaps Identified
- {Gap 1} - needs documentation
- {Gap 2} - needs training
```
