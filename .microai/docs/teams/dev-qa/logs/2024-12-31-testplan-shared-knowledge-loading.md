---
session_id: "qa-2024-12-31-001"
mode: "testplan"
topic: "Shared Knowledge Loading"
date: "2024-12-31"
participants:
  - qa-engineer
  - developer
turns: 6
status: completed
sign_offs:
  qa: approved
  developer: approved
---

# Test Plan: Shared Knowledge Loading

## Overview

| Field | Value |
|-------|-------|
| Feature | Shared Knowledge Loading (ADR-001) |
| Version | 1.0 |
| Author | Dev-QA Team Simulation |
| Date | 2024-12-31 |
| Status | Approved |

---

## 1. Feature Summary

### Description
Hệ thống cho phép các team agents load knowledge files từ shared folder (`/.microai/knowledge/shared/`) thay vì duplicate trong mỗi team. Sử dụng registry.yaml để manage metadata và cross-team access.

### Components Under Test
```
.microai/knowledge/shared/
├── registry.yaml          # Central registry
├── owasp-top-10.md        # ~3000 tokens
├── estimation-techniques.md  # ~2000 tokens
├── user-story-patterns.md    # ~1500 tokens
└── architecture-patterns.md  # ~2500 tokens
```

### Key Functionality
1. **Registry-based discovery** - Teams query registry.yaml for available knowledge
2. **Auto-load rules** - Load by mode or keyword matching
3. **Manual load** - `*load: <knowledge-id>` command
4. **Token budget** - Soft limit of 5000 tokens with warning
5. **Cross-team access** - Shared files accessible to multiple teams

---

## 2. Test Environment

### Prerequisites
- Claude Code CLI installed
- dev-team project with .microai structure
- All 4 shared knowledge files present
- registry.yaml properly configured

### Test Data
| File | Tokens | Applicable Teams |
|------|--------|------------------|
| owasp-top-10.md | 3000 | dev-security, dev-qa |
| estimation-techniques.md | 2000 | pm-dev, dev-architect |
| user-story-patterns.md | 1500 | pm-dev, dev-qa |
| architecture-patterns.md | 2500 | dev-architect, dev-security |

---

## 3. Test Cases

### 3.1 Happy Path Tests

#### TC-01: Auto Load by Mode
| Field | Value |
|-------|-------|
| Priority | P1 |
| Status | Ready |

**Preconditions:**
- dev-security team session
- knowledge-index.yaml has `auto_load.by_mode.review: [owasp-top-10]`

**Steps:**
1. Start dev-security session with mode=review
2. Observe knowledge loading output

**Expected Result:**
- owasp-top-10.md automatically loaded
- Display: "Knowledge loaded: [owasp-top-10]"

---

#### TC-02: Auto Load by Keyword
| Field | Value |
|-------|-------|
| Priority | P1 |
| Status | Ready |

**Preconditions:**
- Session topic contains keyword "injection"
- knowledge-index.yaml has `auto_load.by_keyword.injection: [owasp-top-10]`

**Steps:**
1. Start session with topic "SQL injection vulnerability review"
2. Observe keyword matching and auto-load

**Expected Result:**
- Keyword "injection" detected
- owasp-top-10.md auto-loaded

---

#### TC-03: Manual Load Command
| Field | Value |
|-------|-------|
| Priority | P1 |
| Status | Ready |

**Preconditions:**
- Active session without auto-loaded knowledge

**Steps:**
1. Type `*load: estimation-techniques`
2. Verify file loaded

**Expected Result:**
- File loaded successfully
- Confirmation: "✅ Loaded: estimation-techniques (2000 tokens)"

---

### 3.2 Edge Case Tests

#### TC-04: Token Budget Warning
| Field | Value |
|-------|-------|
| Priority | P2 |
| Status | Ready |

**Preconditions:**
- Token budget = 5000

**Steps:**
1. Load owasp-top-10 (3000 tokens)
2. Load architecture-patterns (2500 tokens)
3. Observe warning

**Expected Result:**
- Warning: "⚠️ Token budget: 5500/5000 (exceeded by 500)"
- Both files still loaded (soft limit)

---

#### TC-05: File Not Found
| Field | Value |
|-------|-------|
| Priority | P1 |
| Status | **BLOCKED** |
| Blocker | Error handler not implemented |

**Preconditions:**
- registry.yaml references "nonexistent.md"

**Steps:**
1. Trigger auto-load that includes nonexistent file
2. Observe error handling

**Expected Result:**
- Error logged: "❌ Knowledge file not found: nonexistent.md"
- Session continues without crash
- Other files loaded successfully

---

#### TC-06: Windows Path Resolution
| Field | Value |
|-------|-------|
| Priority | P2 |
| Status | **NEEDS ENVIRONMENT** |

**Preconditions:**
- Windows OS
- Paths use forward slashes in config

**Steps:**
1. Start session on Windows
2. Trigger knowledge loading with relative path

**Expected Result:**
- Path resolved correctly despite forward slashes
- File loaded successfully

---

#### TC-07: Empty/Malformed Registry
| Field | Value |
|-------|-------|
| Priority | P2 |
| Status | Ready |

**Preconditions:**
- registry.yaml is empty or contains invalid YAML

**Steps:**
1. Start session
2. Trigger knowledge loading

**Expected Result:**
- Graceful fallback to team-only knowledge
- Warning: "⚠️ Shared registry unavailable, using team knowledge only"

---

### 3.3 Boundary Tests

#### TC-08: Exact Token Limit
| Field | Value |
|-------|-------|
| Priority | P3 |
| Status | Ready |

**Preconditions:**
- Files selected total exactly 5000 tokens

**Steps:**
1. Load combination = 5000 tokens
2. Verify no warning

**Expected Result:**
- No warning displayed
- All files loaded successfully

---

### 3.4 Cross-team Tests

#### TC-09: Cross-team Shared Access
| Field | Value |
|-------|-------|
| Priority | P2 |
| Status | Ready |

**Preconditions:**
- dev-qa session active
- owasp-top-10 has applicable_teams: [dev-security, dev-qa]

**Steps:**
1. From dev-qa session, load owasp-top-10
2. Verify access granted

**Expected Result:**
- File loaded successfully
- No permission errors

---

### 3.5 Observer Command Tests

#### TC-10: *knowledge Command
| Field | Value |
|-------|-------|
| Priority | P2 |
| Status | **NOT IMPLEMENTED** |

**Preconditions:**
- Session with loaded knowledge

**Steps:**
1. Type `*knowledge`
2. Observe output

**Expected Result:**
```
Currently loaded knowledge:
- owasp-top-10 (3000 tokens)
- estimation-techniques (2000 tokens)
Total: 5000/5000 tokens
```

---

#### TC-11: *reload Command
| Field | Value |
|-------|-------|
| Priority | P3 |
| Status | **NOT IMPLEMENTED** |

**Preconditions:**
- Knowledge already loaded
- Source file modified

**Steps:**
1. Type `*reload`
2. Verify refresh

**Expected Result:**
- Knowledge refreshed from files
- Token count updated
- Confirmation displayed

---

#### TC-12: *unload Command
| Field | Value |
|-------|-------|
| Priority | P3 |
| Status | **NOT IMPLEMENTED** |

**Preconditions:**
- owasp-top-10 currently loaded

**Steps:**
1. Type `*unload: owasp-top-10`
2. Verify removal

**Expected Result:**
- File removed from context
- Token budget recalculated
- Confirmation: "✅ Unloaded: owasp-top-10 (-3000 tokens)"

---

## 4. Test Execution Summary

### Test Case Status

| Status | Count | Percentage |
|--------|-------|------------|
| Ready | 7 | 58% |
| Blocked | 1 | 8% |
| Needs Environment | 1 | 8% |
| Not Implemented | 3 | 25% |
| **Total** | **12** | 100% |

### Execution Phases

| Phase | Test Cases | Timeline |
|-------|------------|----------|
| Phase 1 | TC-01, TC-02, TC-03, TC-04, TC-07, TC-08, TC-09 | Immediate |
| Phase 2 | TC-05, TC-10, TC-11, TC-12 | After implementation |
| Phase 3 | TC-06 | CI/CD with Windows runner |

---

## 5. Risk Assessment

| Risk | Severity | Likelihood | Test Coverage |
|------|----------|------------|---------------|
| File not found crashes session | High | Medium | TC-05 (BLOCKED) |
| Windows path resolution fails | Medium | Low | TC-06 (NEEDS ENV) |
| Token budget unclear to user | Low | Medium | TC-04, TC-08 |
| Registry corruption | Medium | Low | TC-07 |

---

## 6. Blockers & Dependencies

### Blockers
1. **TC-05**: Requires file-not-found error handler implementation
2. **TC-10, TC-11, TC-12**: Requires observer command implementation

### Dependencies
- TC-06 depends on Windows test environment in CI/CD

---

## 7. Recommendations

1. **Immediate**: Implement file-not-found handler before production
2. **Short-term**: Add `*knowledge`, `*reload`, `*unload` commands
3. **Medium-term**: Add Windows CI/CD test runner
4. **Documentation**: Document soft limit behavior in user guide

---

## 8. Sign-off

| Role | Name | Status | Date |
|------|------|--------|------|
| QA Engineer | 🔍 qa-engineer | ✅ Approved | 2024-12-31 |
| Developer | 👨‍💻 developer | ✅ Approved | 2024-12-31 |

---

**Generated by Dev-QA Team Simulation**
**Session ID:** qa-2024-12-31-001
