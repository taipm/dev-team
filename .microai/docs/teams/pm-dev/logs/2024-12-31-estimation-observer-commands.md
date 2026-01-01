---
session_id: "pm-2024-12-31-001"
mode: "estimation"
topic: "Observer Commands Implementation"
date: "2024-12-31"
participants:
  - product-manager
  - developer
turns: 6
status: completed
sign_offs:
  pm: approved
  developer: committed
---

# Estimation Report: Observer Commands

## Executive Summary

| Field | Value |
|-------|-------|
| Feature | Observer Commands (*knowledge, *load:, *unload:, *reload) |
| Total Effort | **25 hours** |
| T-Shirt Size | **M (Medium)** |
| Story Points | **8** |
| Duration | **4 days** (1 developer) |
| Confidence | **Medium (±25%)** |
| Status | ✅ Approved |

---

## 1. Feature Overview

### Business Need
Users currently have no visibility or control over knowledge loading in team sessions. Observer commands provide:
- Transparency into loaded knowledge
- Manual control over knowledge context
- Ability to optimize token budget

### Scope
| Command | Description | Priority |
|---------|-------------|----------|
| `*knowledge` | List loaded knowledge with token counts | P1 |
| `*load: <id>` | Manually load specific knowledge | P1 |
| `*unload: <id>` | Remove knowledge from context | P2 |
| `*reload` | Refresh all loaded knowledge | P2 |

### Out of Scope (Deferred)
- `*load-all` command
- Full diff display in `*reload`
- Hard token budget enforcement

---

## 2. Technical Breakdown

### 2.1 `*knowledge` Command

**Description:** Display currently loaded knowledge files with metadata.

**Output Format:**
```
📚 Loaded Knowledge (3 files, 5500/5000 tokens)

| File | Tokens | Source | Loaded |
|------|--------|--------|--------|
| owasp-top-10 | 3000 | auto | 10:30 |
| estimation-techniques | 2000 | manual | 10:35 |
| user-story-patterns | 500 | auto | 10:30 |

⚠️ Token budget exceeded by 500 tokens
```

**Tasks:**
| ID | Task | Hours |
|----|------|-------|
| K1.1 | Command parsing in facilitator | 0.5 |
| K1.2 | Knowledge state tracking structure | 1.0 |
| K1.3 | Output formatting (table) | 1.0 |
| K1.4 | Empty state handling | 0.5 |
| K1.5 | Unit tests | 1.0 |
| **Total** | | **4.0** |

**Complexity:** Low
**Dependencies:** None
**Risks:** None

---

### 2.2 `*load: <id>` Command

**Description:** Manually load a knowledge file by ID from registry.

**Behavior:**
```
*load: estimation-techniques

✅ Loaded: estimation-techniques
   Path: knowledge/shared/estimation-techniques.md
   Tokens: 2000
   Budget: 5000/5000 (at limit)
```

**Error Cases:**
```
*load: nonexistent
❌ Knowledge not found: nonexistent
   Available: owasp-top-10, estimation-techniques, ...

*load: owasp-top-10
⚠️ Already loaded: owasp-top-10
```

**Tasks:**
| ID | Task | Hours |
|----|------|-------|
| L2.1 | Command parsing + ID extraction | 0.5 |
| L2.2 | Registry lookup | 0.5 |
| L2.3 | SEC-01 path validation integration | 1.0 |
| L2.4 | File loading | 0.5 |
| L2.5 | Token budget tracking | 1.0 |
| L2.6 | Error handling (not found, already loaded, budget) | 1.5 |
| L2.7 | Success/error messages | 0.5 |
| L2.8 | Unit tests | 1.5 |
| **Total** | | **7.0** |

**Note:** Reduced to 6h since SEC-01 estimated separately.

**Complexity:** Medium
**Dependencies:** SEC-01 (path validation)
**Risks:** SEC-01 implementation delay

---

### 2.3 `*unload: <id>` Command

**Description:** Remove knowledge from current context.

**Behavior:**
```
*unload: owasp-top-10

✅ Unloaded: owasp-top-10
   Freed: 3000 tokens
   Budget: 2000/5000
```

**Tasks:**
| ID | Task | Hours |
|----|------|-------|
| U3.1 | Command parsing | 0.5 |
| U3.2 | Find and remove from state | 1.0 |
| U3.3 | Token budget recalculation | 0.5 |
| U3.4 | Not-loaded error handling | 0.5 |
| U3.5 | Unit tests | 1.0 |
| **Total** | | **3.5** |

**Complexity:** Low
**Dependencies:** State tracking from `*knowledge`
**Risks:** None

---

### 2.4 `*reload` Command

**Description:** Refresh all loaded knowledge from disk.

**Behavior:**
```
*reload

✅ Reloaded 3 knowledge files
   - owasp-top-10.md (unchanged)
   - estimation-techniques.md (updated: +50 tokens)
   - user-story-patterns.md (unchanged)

   Total tokens: 5050/5000
```

**Tasks:**
| ID | Task | Hours |
|----|------|-------|
| R4.1 | Get loaded knowledge list | 0.5 |
| R4.2 | Re-read files from disk | 1.0 |
| R4.3 | Detect changes (size comparison) | 1.0 |
| R4.4 | Update token counts | 1.0 |
| R4.5 | Handle deleted files | 1.0 |
| R4.6 | Unit tests | 1.0 |
| **Total** | | **5.5** |

**Complexity:** Medium
**Dependencies:** State tracking, file reading
**Risks:** File deleted while loaded

---

### 2.5 SEC-01 Integration

**Description:** Path validation security from OWASP review.

**Tasks:**
| ID | Task | Hours |
|----|------|-------|
| S5.1 | Implement validate_and_load_knowledge() | 2.0 |
| S5.2 | Integrate with registry loading | 1.0 |
| S5.3 | Unit tests for security cases | 1.0 |
| **Total** | | **4.0** |

---

### 2.6 Integration & Polish

| ID | Task | Hours |
|----|------|-------|
| I6.1 | End-to-end integration | 1.0 |
| I6.2 | Documentation update | 1.0 |
| I6.3 | Edge case testing | 0.5 |
| **Total** | | **2.5** |

---

## 3. Effort Summary

### By Command

| Component | Hours | % of Total |
|-----------|-------|------------|
| `*knowledge` | 4.0 | 16% |
| `*load:` | 6.0 | 24% |
| `*unload:` | 3.5 | 14% |
| `*reload` | 5.5 | 22% |
| SEC-01 | 4.0 | 16% |
| Integration | 2.5 | 10% |
| **Total** | **25.5** | 100% |

### By Category

| Category | Hours | % |
|----------|-------|---|
| Implementation | 15.0 | 59% |
| Testing | 5.5 | 22% |
| Security | 4.0 | 16% |
| Documentation | 1.0 | 4% |
| **Total** | **25.5** | 100% |

---

## 4. Three-Point Estimate (PERT)

| Scenario | Hours | Days | Conditions |
|----------|-------|------|------------|
| Optimistic | 20 | 2.5 | No blockers, clean implementation |
| Most Likely | 25 | 3.5 | Normal development flow |
| Pessimistic | 32 | 4.5 | SEC-01 issues, edge case surprises |

**PERT Expected:** (20 + 4×25 + 32) / 6 = **25.3 hours**

**Standard Deviation:** (32 - 20) / 6 = **2 hours**

**Confidence Interval (95%):** 21.3 - 29.3 hours

---

## 5. T-Shirt Sizing

| Size | Hours | Story Points | Fit |
|------|-------|--------------|-----|
| S | 8-16 | 3-5 | ❌ |
| **M** | **16-32** | **8** | **✅** |
| L | 32-64 | 13 | ❌ |

**Selected:** M (Medium) - 8 Story Points

---

## 6. Timeline

### Sprint Plan (4 Days)

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPRINT 1: OBSERVER COMMANDS                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Day 1: Foundation                                               │
│  ├── AM: SEC-01 path validation (4h)                            │
│  └── PM: *knowledge command (4h)                                │
│                                                                   │
│  Day 2: Core                                                     │
│  └── Full day: *load: command (6h)                              │
│                                                                   │
│  Day 3: Complete                                                 │
│  ├── AM: *unload: command (3.5h)                                │
│  └── PM: *reload command (5.5h)                                 │
│                                                                   │
│  Day 4: Polish                                                   │
│  ├── AM: Integration testing (1h)                               │
│  ├── PM: Documentation (1h)                                     │
│  └── Buffer: Edge cases (0.5h)                                  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Milestones

| Day | Milestone | Deliverable |
|-----|-----------|-------------|
| 1 | Foundation | SEC-01 + `*knowledge` working |
| 2 | Core | `*load:` working with security |
| 3 | Feature Complete | All 4 commands working |
| 4 | Sprint Complete | Tested, documented, ready |

---

## 7. Dependencies

| Dependency | Status | Impact if Delayed |
|------------|--------|-------------------|
| Shared knowledge folder | ✅ Done | N/A |
| registry.yaml | ✅ Done | N/A |
| SEC-01 path validation | 🔲 In scope | Blocks Day 2 |
| Knowledge state tracking | 🔲 Day 1 | Blocks all commands |

**Critical Path:** SEC-01 → State Tracking → Commands

---

## 8. Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| SEC-01 complexity | Low | High | Built into Day 1, well-specified |
| Token tracking bugs | Medium | Medium | Extra testing Day 4 |
| `*reload` edge cases | Medium | Low | Simplified scope (no diff) |
| Integration issues | Low | Medium | Day 4 buffer |

---

## 9. Assumptions

1. Single developer working full-time
2. No external blockers (reviews, deployments)
3. Development environment ready
4. SEC-01 specification finalized (from security review)

---

## 10. Definition of Done

### Functional
- [ ] `*knowledge` displays loaded files with tokens
- [ ] `*load: <id>` loads file from registry
- [ ] `*unload: <id>` removes file from context
- [ ] `*reload` refreshes all loaded files
- [ ] Token budget warning displays correctly

### Quality
- [ ] Unit tests passing (>80% coverage)
- [ ] SEC-01 security tests passing
- [ ] No critical bugs

### Documentation
- [ ] workflow.md updated with commands
- [ ] User guide for observer commands
- [ ] Security documentation updated

---

## 11. Decisions Made

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | SEC-01 first | Security-first approach |
| 2 | Soft token limit | User-friendly, matches Claude Code model |
| 3 | No diff in `*reload` | Reduce complexity, add later if needed |
| 4 | All in Sprint 1 | Cohesive delivery, shared infrastructure |
| 5 | Defer `*load-all` | Focus on core functionality |

---

## 12. Sign-off

| Role | Name | Status | Date |
|------|------|--------|------|
| Product Manager | 📋 product-manager | ✅ Approved | 2024-12-31 |
| Developer | 👨‍💻 developer | ✅ Committed | 2024-12-31 |

### Approval Notes
- PM: Scope and timeline approved
- Dev: Estimates committed with medium confidence

---

## 13. Next Steps

1. [ ] Create sprint backlog items
2. [ ] Start SEC-01 implementation (Day 1 AM)
3. [ ] Set up testing framework
4. [ ] Daily standup check-ins

---

**Generated by PM-Dev Team Simulation**
**Session ID:** pm-2024-12-31-001
