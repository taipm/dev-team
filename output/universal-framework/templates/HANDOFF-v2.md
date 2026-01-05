# HANDOFF TEMPLATE v2.1

> Template này được sử dụng để tạo tài liệu chuyển giao cho Claude Code.
> CRITICAL: Mọi thông tin phải EXPLICIT, không được assume.
> v2.1: Complete Execution - ALL tasks, no MVP filtering.

---

## TEMPLATE USAGE

```
1. Copy template này
2. Fill in tất cả sections được đánh dấu [FILL]
3. Include tất cả type-specific sections dựa trên project type
4. Include ALL tasks in EXECUTION PHASES (no elimination)
5. Validate completeness trước khi handoff
```

---

# 🚀 HANDOFF: [PROJECT_NAME]

> Tài liệu chuyển giao cho Claude Code để thực thi COMPLETE project
> Generated: [TIMESTAMP]
> Framework Version: 2.1 (Complete Execution)

---

## 📋 PROJECT METADATA

```yaml
project:
  name: "[FILL: Project name]"
  type: "[FILL: ui | api | algorithm | documentation | hybrid]"
  fidelity_level: "[FILL: prototype | functional | polished | realistic]"
  objective: "[FILL: One-line objective from OKR]"

execution:
  estimated_hours: [FILL: Number]
  parallel_opportunities: [FILL: Yes/No]
  critical_path_hours: [FILL: Number]

context:
  working_directory: "[FILL: Absolute path]"
  output_directory: "[FILL: deliverables/src/]"
  reference_directory: "[FILL: references/]"
```

---

## ⚡ QUICK START

```bash
# 1. Navigate to project
cd [FILL: Working directory path]

# 2. Read these files BEFORE coding:
# - phases/00-define/okr.yaml
# - phases/01-decompose/tasks.yaml
# - phases/03-sequence/execution-plan.yaml

# 3. Output code to:
# deliverables/src/
```

---

## 🎯 OKR SUMMARY

### Objective
[FILL: Full objective text]

### Key Results

| KR | Description | Metric | Target | Verification |
|----|-------------|--------|--------|--------------|
| KR1 | [FILL] | [FILL] | [FILL] | [FILL] |
| KR2 | [FILL] | [FILL] | [FILL] | [FILL] |
| KR3 | [FILL] | [FILL] | [FILL] | [FILL] |

---

## 📦 EXECUTION PHASES (Complete Execution v2.1)

> ALL tasks will be executed. No elimination. Optimal ordering.

### Phase 1: FOUNDATION (Core Structure)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

**Foundation Hours:** [FILL]

### Phase 2: BUILD (Main Features)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

**Build Hours:** [FILL]

### Phase 3: ENHANCE (Polish)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

**Enhance Hours:** [FILL]

### Phase 4: FINALIZE (Validation)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

**Finalize Hours:** [FILL]

---

### Execution Summary

| Phase | Tasks | Hours |
|-------|-------|-------|
| FOUNDATION | [FILL] | [FILL] |
| BUILD | [FILL] | [FILL] |
| ENHANCE | [FILL] | [FILL] |
| FINALIZE | [FILL] | [FILL] |
| **TOTAL** | **[FILL]** | **[FILL]** |

### Phase Milestones

```
□ FOUNDATION Complete → Verify: Core structure ready
□ BUILD Complete → Verify: Main functionality working
□ ENHANCE Complete → Verify: All polish applied
□ FINALIZE Complete → Verify: Ready for delivery
```

---

## 📁 OUTPUT STRUCTURE

```
deliverables/src/
├── [FILL: Expected file structure]
└── ...
```

---

# ═══════════════════════════════════════════════════════════════
# TYPE-SPECIFIC SECTIONS
# Include ONLY the section matching your project type
# ═══════════════════════════════════════════════════════════════

---

## 🎨 [UI PROJECTS ONLY] VISUAL SPECIFICATIONS

> CRITICAL: This section is MANDATORY for fidelity_level >= functional

### Visual References

```yaml
reference_product: "[FILL: Product name being replicated]"
reference_images:
  - path: "references/[FILL].png"
    description: "[FILL: What this image shows]"
  - path: "references/[FILL].png"
    description: "[FILL]"

fidelity_requirements:
  level: "[FILL: prototype | functional | polished | realistic]"
  visual_accuracy_target: "[FILL: e.g., 90%]"
  measurement_method: "[FILL: e.g., 20-point checklist]"
```

### Design Tokens (EXACT VALUES)

```css
/*
 * CRITICAL: Use these EXACT values.
 * Do NOT use generic colors or make assumptions.
 */

:root {
  /* === COLORS === */

  /* Body/Frame */
  --body-bg: [FILL: #hexcode];
  --body-border: [FILL: #hexcode];

  /* Display/Screen */
  --display-bg: [FILL: #hexcode];
  --display-text: [FILL: #hexcode];
  --display-border: [FILL: #hexcode];

  /* Buttons - Category 1: [FILL: e.g., Numbers] */
  --btn-[category1]-bg: [FILL: #hexcode];
  --btn-[category1]-text: [FILL: #hexcode];
  --btn-[category1]-border: [FILL: #hexcode];

  /* Buttons - Category 2: [FILL: e.g., Operators] */
  --btn-[category2]-bg: [FILL: #hexcode];
  --btn-[category2]-text: [FILL: #hexcode];

  /* [ADD MORE CATEGORIES AS NEEDED] */

  /* === TYPOGRAPHY === */
  --font-primary: [FILL: 'Font Name', fallback];
  --font-display: [FILL: 'Monospace Font', fallback];

  --font-size-display: [FILL: XXpx];
  --font-size-button: [FILL: XXpx];
  --font-size-label: [FILL: XXpx];

  /* === SPACING === */
  --spacing-unit: [FILL: Xpx];
  --spacing-xs: [FILL];
  --spacing-sm: [FILL];
  --spacing-md: [FILL];
  --spacing-lg: [FILL];

  /* === BORDERS === */
  --border-radius-sm: [FILL: Xpx];
  --border-radius-md: [FILL: Xpx];
  --border-radius-lg: [FILL: Xpx];

  /* === SHADOWS === */
  --shadow-sm: [FILL: CSS shadow value];
  --shadow-md: [FILL: CSS shadow value];
  --shadow-lg: [FILL: CSS shadow value];

  /* === DIMENSIONS === */
  --container-width: [FILL: XXXpx];
  --container-padding: [FILL: XXpx];
  --button-width: [FILL: XXpx];
  --button-height: [FILL: XXpx];
  --button-gap: [FILL: Xpx];
}
```

### Layout Specification

```
[FILL: ASCII art or detailed description of layout]

┌─────────────────────────────────────┐
│           [HEADER AREA]             │
│  ┌───────────────────────────────┐  │
│  │     [DISPLAY/MAIN AREA]       │  │
│  └───────────────────────────────┘  │
│                                     │
│  [CONTROL AREA]                     │
│                                     │
│  [GRID/CONTENT AREA]                │
│                                     │
└─────────────────────────────────────┘

Dimensions:
- Total width: [FILL]
- Total height: [FILL]
- Header height: [FILL]
- Display height: [FILL]
- [ADD MORE DIMENSIONS]
```

### Component Specifications

#### Component 1: [FILL: Name]

```yaml
component:
  name: "[FILL]"
  html: |
    [FILL: Exact HTML structure]

  css_classes:
    - class: "[FILL]"
      purpose: "[FILL]"

  dimensions:
    width: "[FILL]"
    height: "[FILL]"
    padding: "[FILL]"

  visual:
    background: "[FILL: var(--xxx)]"
    color: "[FILL: var(--xxx)]"
    border: "[FILL]"
    border_radius: "[FILL]"
    shadow: "[FILL]"

  states:
    hover:
      background: "[FILL]"
      transform: "[FILL]"
    active:
      background: "[FILL]"
      transform: "[FILL]"
    disabled:
      opacity: "[FILL]"
```

[REPEAT FOR EACH COMPONENT]

### Interactive States

```css
/* Hover State */
.btn:hover {
  background: [FILL];
  transform: [FILL];
  /* ... */
}

/* Active/Pressed State */
.btn:active {
  background: [FILL];
  transform: [FILL];
  box-shadow: [FILL];
}

/* Disabled State */
.btn:disabled {
  opacity: [FILL];
  cursor: not-allowed;
}

/* Focus State (Accessibility) */
.btn:focus {
  outline: [FILL];
  outline-offset: [FILL];
}
```

---

## 🔌 [API PROJECTS ONLY] API SPECIFICATIONS

> CRITICAL: This section is MANDATORY for API projects

### API Overview

```yaml
api:
  base_url: "[FILL: e.g., /api/v1]"
  style: "[FILL: REST | GraphQL | gRPC]"
  format: "[FILL: JSON | XML]"
  authentication: "[FILL: none | api_key | jwt | oauth2]"
```

### Endpoints

| Method | Path | Description | Auth Required |
|--------|------|-------------|---------------|
| [FILL] | [FILL] | [FILL] | [FILL] |

### Endpoint Details

#### [FILL: METHOD] [FILL: /path]

```yaml
endpoint:
  method: "[FILL]"
  path: "[FILL]"
  description: "[FILL]"

  request:
    headers:
      Content-Type: "application/json"
      Authorization: "[FILL: if required]"

    body:
      type: "object"
      required: [FILL: list of required fields]
      properties:
        [FILL: field_name]:
          type: "[FILL]"
          description: "[FILL]"
          validation: "[FILL: rules]"

    example: |
      {
        [FILL: example request body]
      }

  response:
    success:
      status: [FILL: 200/201/etc]
      body:
        type: "object"
        properties:
          [FILL]

      example: |
        {
          [FILL: example response]
        }

    errors:
      - status: [FILL]
        code: "[FILL]"
        message: "[FILL]"
```

[REPEAT FOR EACH ENDPOINT]

### Data Models

```typescript
// [FILL: Model Name]
interface [ModelName] {
  [FILL: field definitions]
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| [FILL] | [FILL] | [FILL] |

---

## 🧮 [ALGORITHM PROJECTS ONLY] ALGORITHM SPECIFICATIONS

> CRITICAL: This section is MANDATORY for Algorithm projects

### Problem Specification

```yaml
problem:
  name: "[FILL]"
  description: |
    [FILL: Clear problem description]

  input:
    format: |
      [FILL: Exact input format]

    constraints:
      - "[FILL: constraint 1]"
      - "[FILL: constraint 2]"

    examples:
      - input: "[FILL]"
        explanation: "[FILL]"

  output:
    format: |
      [FILL: Exact output format]

    examples:
      - input: "[FILL]"
        output: "[FILL]"
        explanation: "[FILL]"

  complexity:
    time_target: "[FILL: O(X)]"
    space_target: "[FILL: O(X)]"
```

### Edge Cases

| Case | Input | Expected Output |
|------|-------|-----------------|
| Empty | [FILL] | [FILL] |
| Single | [FILL] | [FILL] |
| Max Size | [FILL] | [FILL] |
| [ADD MORE] | [FILL] | [FILL] |

### Test Cases

```yaml
test_cases:
  basic:
    - id: TC-001
      input: [FILL]
      expected: [FILL]
      description: "[FILL]"

  edge:
    - id: TC-E01
      input: [FILL]
      expected: [FILL]
      description: "[FILL]"

  stress:
    - id: TC-S01
      input_generator: "[FILL: how to generate]"
      expected_behavior: "[FILL]"
```

---

# ═══════════════════════════════════════════════════════════════
# TASK DETAILS
# ═══════════════════════════════════════════════════════════════

## 🔧 TASK DETAILS

### [TASK-XXX]: [Task Name]

**Output:** `[FILL: output file path]`

**Description:** [FILL]

**Input Required:**
- [FILL: What this task needs]

**Verification:**
- [ ] [FILL: Criterion 1]
- [ ] [FILL: Criterion 2]

**Code Template:**

```[language]
[FILL: Starter code or expected structure]
```

[REPEAT FOR EACH TASK]

---

# ═══════════════════════════════════════════════════════════════
# VALIDATION
# ═══════════════════════════════════════════════════════════════

## ✅ VERIFICATION CHECKLIST

### Functional Verification

```
□ [FILL: Functional check 1]
□ [FILL: Functional check 2]
□ [FILL: ...]
```

### Type-Specific Verification

[FOR UI PROJECTS]
```
Visual Fidelity (Target: [FILL]%):
□ Colors match reference (±5%)
□ Typography matches (font, size ±2px)
□ Layout matches (dimensions ±4px)
□ All components present
□ Interactive states working
□ No visual bugs
```

[FOR API PROJECTS]
```
Contract Compliance:
□ All endpoints implemented
□ Request validation working
□ Response format correct
□ Error codes correct
□ Authentication enforced
```

[FOR ALGORITHM PROJECTS]
```
Correctness:
□ All basic test cases pass
□ All edge cases pass
□ Output format exact match
□ Complexity requirements met
```

### Quality Gates

```
Phase Completion Checks:
□ FOUNDATION phase complete (core structure verified)
□ BUILD phase complete (functionality verified)
□ ENHANCE phase complete (polish verified)
□ FINALIZE phase complete (validation passed)

Pre-Submit Checks:
□ ALL tasks completed (100% completion rate)
□ All verification items checked
□ No known bugs
□ Code is clean and readable
```

---

## 📍 SAVE LOCATIONS

After each task, save results:

```
tasks/[TASK-ID]/result.yaml    # Task completion record
phases/04-execute/progress.yaml  # Update progress

# Final deliverables:
deliverables/src/              # All source code
```

---

## 🚨 IMPORTANT NOTES

1. **[FILL: Critical note 1]**
2. **[FILL: Critical note 2]**
3. **Test Incrementally** - Verify each component works before moving on
4. **Save Progress** - Update progress.yaml after each task
5. **Follow Specs Exactly** - Do not deviate from specifications above

---

## 📞 RESUME POINT

If session interrupted, resume from:
- Read `phases/04-execute/progress.yaml` for last completed task
- Continue from next task in sequence

---

## 🔍 VALIDATION REFERENCE

When validating output quality:

1. **Open reference image** (if UI project)
2. **Compare side-by-side** with output
3. **Check each item** in verification checklist
4. **Document any deviations**
5. **Fix issues** before marking complete

---

**Ready to Execute!** 🚀

Start with the first task in the sequence. Read all relevant specifications before coding.

---

# ═══════════════════════════════════════════════════════════════
# APPENDIX: REFERENCE MATERIALS
# ═══════════════════════════════════════════════════════════════

## A. Reference Images

[INCLUDE ACTUAL IMAGES OR LINKS]

## B. Full OKR Document

[EMBED OR LINK TO okr.yaml]

## C. Full Task List

[EMBED OR LINK TO tasks.yaml]

## D. Execution Plan

[EMBED OR LINK TO execution-plan.yaml]
