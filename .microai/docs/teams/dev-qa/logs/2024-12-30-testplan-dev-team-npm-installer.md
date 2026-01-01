---
session_id: "qa-2024-12-30-001"
mode: "testplan"
topic: "dev-team npm installer"
date: "2024-12-30"
participants:
  - qa-engineer
  - developer
turns: 9
status: completed
sign_offs:
  qa: approved
  dev: approved
---

# Test Plan: dev-team npm installer

**Document ID:** TP-2024-12-30-001
**Version:** 1.0
**Created:** 2024-12-30
**Authors:** QA Engineer, Developer
**Status:** Approved

---

## 1. Overview

### 1.1 Feature Description
CLI tool để cài đặt MicroAI framework vào các dự án. Được publish lên npm registry với tên `@anthropic/dev-team`. Hỗ trợ interactive component selection và file backup.

### 1.2 User Story
As a **developer**,
I want **to install dev-team framework via npm**,
So that **I can quickly set up Claude Code agents and workflows in my project**.

### 1.3 Scope

**In Scope:**
- `npx @anthropic/dev-team install` - Interactive installer
- Component selection (agents, commands, hooks, settings)
- File copying từ templates/ vào project
- Backup existing files trước khi overwrite
- `.gitignore` updates

**Out of Scope:**
- Auto-update functionality
- Remote template fetching
- GUI interface
- Uninstall command (v1.0)
- Rollback on failure (v1.0 - documented limitation)

### 1.4 References
- Package: `src/commands/install.js`
- CLI Entry: `bin/cli.js`
- Templates: `templates/`

---

## 2. Test Strategy

### 2.1 Test Approach
Risk-based testing với focus on:
1. Core installation flows (P1)
2. Error handling và edge cases (P2)
3. Cross-platform compatibility (P2-P3)
4. Security concerns (Manual review)

### 2.2 Test Types

| Type | Coverage | Automation |
|------|----------|------------|
| Unit Tests | 80% | Jest |
| Integration Tests | 75% | Jest + temp directories |
| E2E Tests | 50% | Manual + CI |
| Security Tests | 100% | Manual review |

### 2.3 Coverage Targets
- **Code Coverage:** 80%
- **Requirements Coverage:** 100%
- **Critical Path Coverage:** 100%

### 2.4 Test Framework

```javascript
// Jest + custom helpers
const { createTempProject, runInstall, cleanup } = require('./test-helpers');

describe('dev-team install', () => {
  let tempDir;

  beforeEach(async () => {
    tempDir = await createTempProject();
  });

  afterEach(async () => {
    await cleanup(tempDir);
  });
});
```

### 2.5 CI/CD Integration

```yaml
# GitHub Actions matrix
os: [ubuntu-latest, macos-latest, windows-latest]
node: [18, 20, 22]
# Total: 9 combinations
```

---

## 3. Test Cases

### 3.1 P1 - Critical (Must Pass)

#### TC-001: Fresh Install - All Components
**Priority:** P1 | **Type:** Happy Path | **Automation:** Yes

**Preconditions:**
- Empty directory
- Node.js installed

**Given** an empty project directory
**When** user runs `npx @anthropic/dev-team install` and selects all components
**Then**
- Exit code = 0
- `.claude/agents/` created with files
- `.claude/commands/` created with files
- `.claude/settings.json` created
- `.microai/` created with structure

---

#### TC-002: Fresh Install - Default Selection
**Priority:** P1 | **Type:** Happy Path | **Automation:** Yes

**Given** an empty project directory
**When** user runs install and presses Enter (accepts defaults)
**Then**
- agents, commands, settings installed
- hooks NOT installed (not in defaults)

---

#### TC-003: Existing Files - Backup Created
**Priority:** P1 | **Type:** Conflict Handling | **Automation:** Yes

**Preconditions:**
- `.claude/settings.json` already exists

**Given** existing `.claude/settings.json`
**When** user runs install and confirms overwrite
**Then**
- Original file backed up as `settings.json.backup-{timestamp}`
- New settings.json installed

---

#### TC-004: Permission Denied - Graceful Error
**Priority:** P1 | **Type:** Error Handling | **Automation:** Yes

**Given** a read-only directory
**When** user runs install
**Then**
- Clear error message displayed
- No crash, exit code non-zero
- No partial files written

---

### 3.2 P2 - High (Should Pass)

#### TC-005: Partial Selection - Single Component
**Priority:** P2 | **Type:** Feature | **Automation:** Yes

**Given** empty directory
**When** user selects only "agents"
**Then** only agents copied, others skipped

---

#### TC-006: Hooks Without Settings - Warning
**Priority:** P2 | **Type:** Dependency | **Automation:** Yes

**Given** empty directory
**When** user selects hooks but NOT settings
**Then** warning about dependency displayed

---

#### TC-007: Interrupt Mid-Install
**Priority:** P2 | **Type:** Error Recovery | **Automation:** Manual

**Given** install running
**When** user presses Ctrl+C at step 2/4
**Then**
- Graceful exit
- Partial files remain (documented behavior)
- No corruption

---

#### TC-008: Large Existing Folder
**Priority:** P2 | **Type:** Performance | **Automation:** Yes

**Given** `.claude/` with 100+ files
**When** user runs install with overwrite
**Then**
- Backup completes without timeout
- All files processed

---

#### TC-009: Special Characters in Path
**Priority:** P2 | **Type:** Edge Case | **Automation:** Yes

**Given** path with spaces and unicode (e.g., `/My Projects/dự án/`)
**When** user runs install
**Then** paths handled correctly, files created

---

#### TC-010: Re-run Install
**Priority:** P2 | **Type:** Idempotency | **Automation:** Yes

**Given** dev-team already installed
**When** user runs install again
**Then**
- Detects existing files
- Offers overwrite/skip options
- No duplicate files created

---

#### TC-011: npx vs Global Install
**Priority:** P2 | **Type:** Compatibility | **Automation:** CI

**Given** package installed globally (`npm install -g`)
**When** run `dev-team install`
**Then** works same as npx version

---

#### TC-012: Node Version Compatibility
**Priority:** P2 | **Type:** Compatibility | **Automation:** CI Matrix

**Given** Node 18 / 20 / 22
**When** run install
**Then** works on all LTS versions

---

### 3.3 P3 - Medium (Nice to Pass)

#### TC-013: npm vs pnpm vs yarn
**Priority:** P3 | **Type:** Compatibility | **Automation:** Manual

**Given** project using pnpm or yarn
**When** run `npx @anthropic/dev-team install`
**Then** no conflicts with lock files

---

#### TC-014: Disk Full During Backup
**Priority:** P3 | **Type:** Edge Case | **Automation:** Manual

**Given** low disk space
**When** run install with existing files
**Then** error before partial write

---

#### TC-015: Windows PowerShell
**Priority:** P3 | **Type:** Cross-Platform | **Automation:** CI

**Given** Windows 11 with PowerShell
**When** run install
**Then** works correctly (paths, permissions)

---

#### TC-016: Windows Hook Scripts
**Priority:** P3 | **Type:** Cross-Platform | **Automation:** Manual

**Given** Windows without WSL
**When** hooks component installed
**Then** `.sh` scripts present (requires Git Bash - documented)

---

#### TC-017: Symlink Target
**Priority:** P3 | **Type:** Edge Case | **Automation:** Skip

**Given** `.claude/` is a symlink
**When** run install
**Then** follows symlink (known limitation)

**Note:** Skipped - Known limitation, documented

---

### 3.4 Security Tests (Manual Review)

#### TC-018: Path Traversal Prevention
**Priority:** Security | **Type:** Security | **Automation:** Code Review

**Risk:** Template contains `../` paths
**Test:** Verify templates don't write outside target directory
**Method:** Code review of copy logic

---

#### TC-019: No Auto-Execute Scripts
**Priority:** Security | **Type:** Security | **Automation:** Code Review

**Risk:** Hook scripts auto-execute during install
**Test:** Verify scripts are only copied, not executed
**Method:** Code review, process monitoring

---

## 4. Risk Assessment

### 4.1 Risk Matrix

| Risk | Impact | Likelihood | Mitigation | Test Coverage |
|------|--------|------------|------------|---------------|
| Partial install without rollback | High | Medium | Document, v1.1 backlog | TC-007 |
| Cross-platform path issues | Medium | Medium | path.join(), CI matrix | TC-009, TC-015 |
| Permission errors | Medium | Low | Clear error messages | TC-004 |
| Backup failure | High | Low | Pre-check disk space | TC-014 |
| Windows compatibility | Medium | Medium | WSL requirement, docs | TC-015, TC-016 |

### 4.2 Known Limitations (v1.0)

| Limitation | Workaround | Future Plan |
|------------|------------|-------------|
| No rollback on failure | Manual cleanup | v1.1 |
| No uninstall command | Manual deletion | v1.2 if demand |
| Symlink not detected | Follows symlink | Document only |
| Windows hooks need Git Bash | Install Git Bash | .cmd alternatives v1.1 |

---

## 5. Test Data Requirements

### 5.1 Test Fixtures

```
test/fixtures/
├── empty_project/           # TC-001, 002, 005, 006
├── existing_claude/         # TC-003, 008, 010
│   └── .claude/
│       ├── settings.json
│       └── agents/
├── readonly_dir/            # TC-004
├── special_chars_path/      # TC-009
│   └── dự án test/
└── mock_templates/          # For unit test isolation
```

### 5.2 Data Preparation
- Create fixtures before test suite
- Use temp directories for isolation
- Clean up after each test

---

## 6. Environment Requirements

### 6.1 Test Environments

| Environment | OS | Node | Purpose |
|-------------|-----|------|---------|
| CI Linux | Ubuntu 22.04 | 18, 20, 22 | Primary |
| CI macOS | macOS 14 | 18, 20, 22 | Cross-platform |
| CI Windows | Windows Server 2022 | 18, 20, 22 | Cross-platform |
| Local Dev | Any | 20+ | Development |

### 6.2 CI Configuration

```yaml
name: Test Install
on: [push, pull_request]
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [18, 20, 22]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: npm ci
      - run: npm test -- --grep "install"
```

---

## 7. Entry/Exit Criteria

### 7.1 Entry Criteria
- [x] Feature code complete
- [ ] Unit tests written
- [ ] Test fixtures created
- [ ] CI pipeline configured
- [ ] Test environment ready

### 7.2 Exit Criteria
- [ ] All P1 tests passed (100%)
- [ ] P2 tests passed (≥90%)
- [ ] No open Critical/High bugs
- [ ] Security tests reviewed and passed
- [ ] Known limitations documented in README

---

## 8. Schedule

| Phase | Status | Notes |
|-------|--------|-------|
| Test Planning | Complete | This document |
| Test Case Development | Pending | Jest tests |
| Test Execution | Pending | After dev complete |
| Bug Fixing | Pending | - |
| Regression | Pending | Before release |

---

## 9. Sign-off

| Role | Status | Date | Conditions |
|------|--------|------|------------|
| QA Engineer | Approved | 2024-12-30 | P1 must pass 100%, document limitations |
| Developer | Approved | 2024-12-30 | Will create fixtures, add to README |

---

## 10. Session Summary

### 10.1 Key Decisions

1. **Rollback feature deferred to v1.1** - Document partial install as known limitation
2. **Symlink handling** - Skip test, known limitation
3. **Disk full test** - Manual only, hard to automate reliably
4. **No telemetry** - GDPR compliant, offline-first
5. **Windows hooks** - Require Git Bash, document in README

### 10.2 Action Items

| Action | Owner | Priority |
|--------|-------|----------|
| Create test fixtures | Dev | High |
| Document known limitations | Dev | High |
| Create GitHub issue for rollback | Dev | Medium |
| Setup Docker test containers | Dev + QA | Medium |
| Write Jest tests | Dev | High |

---

**Generated from Dev-QA Session**
**Session ID:** qa-2024-12-30-001
**Turns:** 9
**Duration:** ~30 minutes
