# Go Review Linus Agent - Decisions

> Architectural and review standard decisions.

---

## Review Standards

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D001 | Security issues ALWAYS first | Highest impact, must fix before anything | 2026-01-03 |
| D002 | Use severity language | Linus style - make issues clear | 2026-01-03 |
| D003 | Provide fixes, not just issues | Actionable feedback is more valuable | 2026-01-03 |

---

## Severity Classification

| Category | Severity | Reasoning |
|----------|----------|-----------|
| Data race | 🔴 BROKEN | Will corrupt data in production |
| Deadlock | 🔴 BROKEN | Will freeze process permanently |
| SQL injection | 🔴 BROKEN | Security vulnerability |
| Magic numbers | 🟡 SMELL | Maintainability issue |
| Missing docs | 🟡 SMELL | Technical debt |

---

## Review Patterns

*Document recurring review patterns here*

---

*Last updated: 2026-01-03*
