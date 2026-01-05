---
name: universal-framework
description: 'Universal Execution Framework v2.1 - Complete project execution with OKR + First Principles + Type-Aware Processing'
argument-hint: "[project description] | type:[ui|api|algorithm] | fidelity:[prototype|functional|polished|realistic]"
---

# Universal Execution Framework v2.1

LOAD agent from @output/universal-framework/agents/00-orchestrator.md

## Quick Reference

**Purpose:** Transform project descriptions into complete, executable work plans with quality gates.

**Philosophy:** Complete Execution - ALL tasks, NO MVP filtering

**Project Types:**
- `ui` - UI/Frontend (giao diện, web app, calculator, dashboard)
- `api` - API/Backend (REST, GraphQL, endpoints, server)
- `algorithm` - Algorithms (thuật toán, xử lý, tính toán, ML)
- `hybrid` - Multiple types combined

**Fidelity Levels:**
- `prototype` - Basic structure, placeholders OK
- `functional` - Working features, default styles
- `polished` - Good design, smooth UX
- `realistic` - Exact visual match to reference

## Usage Examples

```
/universal-framework "Build Casio FX-880 calculator" fidelity:realistic
/universal-framework "Create REST API for user authentication" type:api
/universal-framework "Implement quicksort algorithm" type:algorithm
```

## Pipeline v2.1

```
[CLASSIFY] → DEFINER → DECOMPOSER → PRIORITIZER → SEQUENCER
     ↓
[PRE-VALIDATE] → [GENERATE HANDOFF] → EXECUTOR
     ↓
[MID-VALIDATE] → [POST-VALIDATE] → REVIEWER
```

## Execution Phases

| Phase | Tasks | Purpose |
|-------|-------|---------|
| FOUNDATION | 30% | Core structure, design systems |
| BUILD | 30% | Main features, business logic |
| ENHANCE | 25% | Polish, UX improvements |
| FINALIZE | 15% | Validation, testing, cleanup |

## Output

- `phases/` - All phase outputs (OKR, tasks, plan)
- `HANDOFF.md` - Complete execution document
- `deliverables/` - Final project files

## Key Files

- Orchestrator: `output/universal-framework/agents/00-orchestrator.md`
- Type Registry: `output/universal-framework/types/registry.yaml`
- HANDOFF Template: `output/universal-framework/templates/HANDOFF-v2.md`
- Example: `output/universal-framework/examples/HANDOFF-casio-fx880-v2.md`
