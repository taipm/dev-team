# Step 06: Review Loop

## Trigger
Sau Step 05 hoàn thành

## Agents
- 🔍 Reviewer Agent (lead)
- 🐍 Developer Agent (fixes)
- 🧪 Tester Agent (test updates)

## Loop Protocol

```
iteration = 0
max_iterations = 3

WHILE iteration < max_iterations:

    ┌─────────────────────────────────────────────────────────────┐
    │ REVIEW PHASE                                                 │
    └─────────────────────────────────────────────────────────────┘

    1. Reviewer runs quality checks:
       - mypy --strict src/
       - ruff check src/ tests/
       - ruff format --check src/ tests/
       - pytest --cov=src

    2. IF all_checks_pass:
       → EXIT loop with SUCCESS

    3. ELSE:
       → Document issues by priority
       → Route to Developer for fixes

    ┌─────────────────────────────────────────────────────────────┐
    │ FIX PHASE                                                    │
    └─────────────────────────────────────────────────────────────┘

    4. Developer addresses issues:
       - Critical → fix immediately
       - Major → fix or explain
       - Minor → fix if time permits

    5. Tester updates tests if needed

    iteration++
```

## Quality Checks

### 1. Type Safety (mypy)
```bash
poetry run mypy src/ --strict
```

Expected: No errors
```
Success: no issues found in N source files
```

### 2. Linting (ruff)
```bash
poetry run ruff check src/ tests/
```

Expected: No errors
```
All checks passed!
```

### 3. Formatting (ruff format)
```bash
poetry run ruff format --check src/ tests/
```

Expected: All formatted
```
N files would be left unchanged
```

### 4. Tests (pytest)
```bash
poetry run pytest --cov=src --cov-report=term-missing
```

Expected: All pass, coverage ≥80%

## Issue Classification

| Priority | Type | Example | Action |
|----------|------|---------|--------|
| 🔴 Critical | Security bug | SQL injection | Fix immediately |
| 🔴 Critical | Logic error | Wrong calculation | Fix immediately |
| 🟠 Major | Type error | Missing type hint | Must fix |
| 🟠 Major | Missing test | Uncovered code path | Must add |
| 🟡 Minor | Style | Naming convention | Should fix |
| 🟡 Minor | Documentation | Missing docstring | Should add |
| 🔵 Suggestion | Improvement | Better pattern | Optional |

## Review Report Format

```markdown
## Code Review - Iteration {N}

### Quality Metrics
| Check | Status | Details |
|-------|--------|---------|
| mypy | ✅/❌ | {errors} |
| ruff check | ✅/❌ | {errors} |
| ruff format | ✅/❌ | {files} |
| pytest | ✅/❌ | {passed}/{total} |
| coverage | {%} | {missing} |

### Issues Found

#### 🔴 Critical
- None

#### 🟠 Major
1. **[Type]** Missing return type
   - File: `src/{project}/services/user.py:45`
   - Fix: Add `-> Optional[User]`

#### 🟡 Minor
1. **[Style]** Inconsistent naming
   - File: `src/{project}/api/v1/users.py:12`
   - Suggestion: Rename `x` to `user_response`

### Verdict
- [ ] APPROVED - Ready for DevOps
- [x] CHANGES_REQUESTED - Needs fixes
```

## Exit Conditions

### SUCCESS (exit loop)
- ✅ mypy: No errors
- ✅ ruff check: No errors
- ✅ ruff format: All formatted
- ✅ pytest: All pass
- ✅ coverage: ≥80%

### MAX ITERATIONS REACHED
If iteration == max_iterations and still failing:

```
╔═══════════════════════════════════════════════════════════════╗
║ ⚠️  MAX ITERATIONS REACHED                                     ║
╠═══════════════════════════════════════════════════════════════╣
║ Remaining issues:                                              ║
║ - {issue_1}                                                    ║
║ - {issue_2}                                                    ║
╠═══════════════════════════════════════════════════════════════╣
║ Options:                                                       ║
║ 1. *iterations:+3 - Add more iterations                       ║
║ 2. *accept - Accept current state                             ║
║ 3. *exit - Save and exit                                      ║
╚═══════════════════════════════════════════════════════════════╝
```

## BREAKPOINT
After review loop completes, observer reviews final quality.

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🔍 Reviewer Agent: Review Complete                          │
├─────────────────────────────────────────────────────────────┤
│ Iterations: {count}                                          │
│ Final Status: APPROVED                                       │
│                                                              │
│ Quality Metrics:                                             │
│ • mypy: CLEAN                                               │
│ • ruff: CLEAN                                               │
│ • tests: {passed}/{total}                                   │
│ • coverage: {%}%                                            │
└─────────────────────────────────────────────────────────────┘
```

## Next Step
→ Step 07: DevOps Configuration
