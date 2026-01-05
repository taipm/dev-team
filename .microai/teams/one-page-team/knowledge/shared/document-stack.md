# Document Stack Structure

## Overview

A complete document stack supports OPPM execution with detailed operational documents.

## Document Hierarchy

```text
                    ┌──────────────────┐
                    │      OPPM        │  ← Strategic View (1 page)
                    │   (1 trang)      │
                    └────────┬─────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   TECHNICAL     │ │    PLANNING     │ │   TRACKING      │
│   (How to)      │ │   (What/When)   │ │   (Status)      │
└─────────────────┘ └─────────────────┘ └─────────────────┘
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────────────────────────────────────────────┐
│                      REFERENCE                           │
│              (SOPs, Templates, Guidelines)               │
└─────────────────────────────────────────────────────────┘
```

## Document Categories

### 1. OPPM (01-oppm/)
| Document | Purpose | Update |
|----------|---------|--------|
| oppm.md | One-page overview | Weekly |
| oppm.pdf | Shareable version | As needed |

### 2. Technical (02-technical/)
| Document | Purpose | Update |
|----------|---------|--------|
| tool-setup-guides.md | Installation & config | Once |
| pipeline-architecture.md | Process flow diagram | Once |
| api-integration.md | API credentials & usage | As needed |
| batch-scripts/ | Automation scripts | As needed |

### 3. Planning (03-planning/)
| Document | Purpose | Update |
|----------|---------|--------|
| phase-X-breakdown.md | Detailed phase tasks (×4) | Per phase |
| content-calendar.md | Scheduled items | Weekly |
| risk-mitigation.md | Risks & responses | Monthly |

### 4. Tracking (04-tracking/)
| Document | Purpose | Update |
|----------|---------|--------|
| weekly-tracker.md | Task completion | Weekly |
| metrics-dashboard.md | KPI visualization | Weekly |
| production-log.md | Output log | Daily |
| retrospective.md | Lessons learned | Per phase |

### 5. Reference (05-reference/)
| Document | Purpose | Update |
|----------|---------|--------|
| sop-phase-X.md | Procedures (×4) | Once |
| quality-checklist.md | Quality gates | Once |
| decision-log.md | Major decisions | As needed |
| prompt-library.md | AI prompts | As needed |
| seo-templates.md | SEO patterns | Once |
| content-style-guide.md | Writing standards | Once |
| brand-guidelines.md | Visual identity | Once |

## Document Count Summary

| Category | Files | Priority |
|----------|-------|----------|
| OPPM | 2 | Critical |
| Technical | 4 | High |
| Planning | 6 | High |
| Tracking | 4 | High |
| Reference | 10 | Medium |
| **Total** | **26** | |

## Generation Order

1. **OPPM first** (provides context for all others)
2. **Parallel generation** of remaining 4 categories
3. **Review** all documents
4. **Export** PDFs

## Cross-References

Documents should link to each other:
- OPPM → links to detailed phase docs
- Phase docs → link to SOPs
- SOPs → link to templates
- Tracker → references OPPM tasks
