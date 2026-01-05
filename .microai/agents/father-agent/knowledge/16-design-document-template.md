# Design Document Template

> Template for design documents submitted to Deep Thinking Team for review before agent/team creation.

## Usage

Use this template when creating design documents for:
- **create-agent**: New agent creation
- **clone-agent**: Agent cloning with modifications
- **create-team**: New team creation

## Review Modes

| Mode | Duration | When to Use |
|------|----------|-------------|
| `quick` | 5-15 min | Simple clone with minimal changes |
| `standard` | 30-60 min | New agent, significant modifications |
| `deep` | 2-4 hours | New team, critical infrastructure |

---

# Template

```markdown
# Design Document: {OPERATION_TYPE} - {NAME}

## Metadata

| Field | Value |
|-------|-------|
| ID | {UUID} |
| Type | create-agent / clone-agent / create-team |
| Name | {target_name} |
| Created | {YYYY-MM-DD HH:MM} |
| Author | Father Agent v2.2 |
| Status | draft / pending-review / approved / rejected / approved-with-conditions |
| Review Mode | quick / standard / deep |

---

## 1. Problem Statement

### 1.1 What are we trying to create/modify?
{Description of the agent/team being created}

### 1.2 Why is this needed?
{Business/technical justification - the WHY behind this creation}

### 1.3 Who will use this?
{Target users and primary use cases}

### 1.4 Success Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

---

## 2. Context

### 2.1 Related Existing Agents/Teams

| Name | Relationship | Overlap Level |
|------|--------------|---------------|
| {agent_name} | similar / extends / replaces | low / medium / high |

### 2.2 Constraints

**Technical:**
- {Technical constraint 1}
- {Technical constraint 2}

**Organizational:**
- {Org constraint}

**Resource:**
- {Resource constraint}

### 2.3 Requirements Summary

| Requirement | Priority | Source |
|-------------|----------|--------|
| {Req 1} | Must | User |
| {Req 2} | Should | Best Practice |
| {Req 3} | Could | Enhancement |

---

## 3. Proposed Solution

### 3.1 Overview
{High-level description of the solution - 2-3 sentences}

### 3.2 Architecture

```
{Structure diagram or directory layout}

Example for agent:
.microai/agents/{agent_name}/
├── agent.md
├── knowledge/
│   ├── knowledge-index.yaml
│   └── {domain}-guide.md
└── workflows/ (if needed)

Example for team:
.microai/teams/{team_name}/
├── workflow.md
├── agents/
├── steps/
└── knowledge/
```

### 3.3 Key Design Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| {Decision 1} | {Why this choice} | {Other options rejected} |
| {Decision 2} | {Why this choice} | {Other options rejected} |

### 3.4 Technical Specification

**For Agents:**
```yaml
model: opus / sonnet / haiku
tools: [list of tools]
skills: [list of skills]
knowledge_files: [list of knowledge files]
memory: enabled / disabled
```

**For Teams:**
```yaml
team_type: pipeline / dialogue / thinking
agents_count: {N}
communication: sync / async
checkpoints: enabled / disabled
```

---

## 4. Alternatives Considered

### Alternative 1: {Name}
- **Description**: {What this alternative involves}
- **Pros**: {Benefits}
- **Cons**: {Drawbacks}
- **Why Rejected**: {Reason for not choosing}

### Alternative 2: {Name}
- **Description**: {What this alternative involves}
- **Pros**: {Benefits}
- **Cons**: {Drawbacks}
- **Why Rejected**: {Reason for not choosing}

---

## 5. Risk Assessment

### 5.1 Identified Risks

| Risk | Likelihood | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| {Risk 1} | High/Med/Low | High/Med/Low | {How to mitigate} |
| {Risk 2} | High/Med/Low | High/Med/Low | {How to mitigate} |

### 5.2 Dependencies

| Dependency | Status | Risk if Unavailable |
|------------|--------|---------------------|
| {Dep 1} | Available / Pending | {Impact} |
| {Dep 2} | Available / Pending | {Impact} |

### 5.3 Failure Modes
- **If {scenario}**: {consequence and recovery}
- **If {scenario}**: {consequence and recovery}

---

## 6. Review Request

### 6.1 Recommended Review Mode
- [ ] Quick (simple clone, minor changes)
- [ ] Standard (new agent, significant modifications)
- [ ] Deep (new team, critical infrastructure)

### 6.2 Specific Questions for Deep Thinking Team

1. **Architecture Question**: {Question about structure/design}
2. **Risk Question**: {Question about potential failures}
3. **Alternative Question**: {Question about other approaches}

### 6.3 Focus Areas
- [ ] Design soundness
- [ ] Risk assessment
- [ ] Performance implications
- [ ] Maintainability
- [ ] Integration concerns

---

## 7. Approval Record

### 7.1 Review Session

| Field | Value |
|-------|-------|
| Session ID | {deep-thinking-session-id} |
| Mode | quick / standard / deep |
| Date | {YYYY-MM-DD} |
| Duration | {time} |
| Agents Consulted | {list of agents} |

### 7.2 Decision

**Status**: `approved` / `rejected` / `approved-with-conditions`

**Conditions** (if applicable):
1. {Condition 1 - what must be changed}
2. {Condition 2 - what must be added}

**Rejection Reason** (if rejected):
{Why the design was rejected and what needs to change}

### 7.3 Key Insights from Review

| Agent | Insight |
|-------|---------|
| Socrates | {Deep question or assumption challenged} |
| Linus | {Code/architecture feedback} |
| Munger | {Risk or mental model insight} |
| {Other} | {Their contribution} |

### 7.4 Sign-off

- **Reviewed by**: Deep Thinking Team
- **Approved by**: @maestro
- **Date**: {YYYY-MM-DD}
- **Signature**: {session_id}

---

## 8. Execution Checklist

After approval, execute these steps:

### Pre-Execution
- [ ] All conditions from review addressed
- [ ] Design document status updated to "approved"
- [ ] User confirmed to proceed

### Execution
- [ ] Create directory structure
- [ ] Generate agent/team files
- [ ] Create knowledge files
- [ ] Register command in .claude/commands/microai/

### Post-Execution
- [ ] Validate with validate-agent-v2.sh
- [ ] Archive design document to designs/archive/
- [ ] Link design doc in created agent's memory (if memory enabled)
- [ ] Update Father Agent's execution log

---

## 9. Archive Information

| Field | Value |
|-------|-------|
| Archived | {YYYY-MM-DD HH:MM} |
| Archive Path | ./designs/archive/{date}-{type}-{name}.md |
| Created Asset | .microai/agents/{name}/ or .microai/teams/{name}/ |
| Linked From | {path to memory/design-origin.md if applicable} |
```

---

## Quick Reference

### Status Flow
```
draft → pending-review → approved/rejected/approved-with-conditions
                              ↓
                         (if rejected)
                              ↓
                    revise → pending-review (loop)
```

### Naming Convention
Archive files: `{YYYY-MM-DD}-{operation_type}-{target_name}.md`

Examples:
- `2025-01-04-create-agent-gateway-agent.md`
- `2025-01-04-clone-agent-go-review-agent.md`
- `2025-01-04-create-team-security-team.md`

### Integration with Deep Thinking Team

Invoke via:
```
/microai:deep-thinking {mode}
Problem: Review design for {operation}: {name}
Design Document: {path}
```
