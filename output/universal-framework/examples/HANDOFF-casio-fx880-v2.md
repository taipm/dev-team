# 🚀 HANDOFF: Casio FX-880 Calculator App v2.1

> Tài liệu chuyển giao cho Claude Code để thực thi COMPLETE project
> Generated: 2026-01-04T23:30:00+07:00
> Framework Version: 2.1 (Complete Execution)

---

## 📋 PROJECT METADATA

```yaml
project:
  name: "Casio FX-880 Calculator"
  type: "ui"
  fidelity_level: "realistic"
  objective: "Tạo ứng dụng web máy tính Casio FX-880 với độ chân thực cao"

execution:
  estimated_hours: 5.5
  parallel_opportunities: Yes
  critical_path_hours: 5.5

context:
  working_directory: "/Users/taipm/GitHub/dev-team/output/universal-framework/projects/casio-fx880-calculator"
  output_directory: "deliverables/src/"
  reference_directory: "references/"
```

---

## ⚡ QUICK START

```bash
# 1. Navigate to project
cd /Users/taipm/GitHub/dev-team/output/universal-framework/projects/casio-fx880-calculator

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
Tạo ứng dụng web máy tính Casio FX-880 với độ chân thực cao, cho phép người dùng thực hiện các phép tính như trên máy thật.

### Key Results

| KR | Description | Metric | Target | Verification |
|----|-------------|--------|--------|--------------|
| KR1 | Ship calculator với đầy đủ UI components | Components completed | 5 major (body, display, keypad, buttons, header) | Component checklist |
| KR2 | Visual fidelity match với Casio FX-880 | Visual match score | 90% (20-point checklist) | Side-by-side comparison |
| KR3 | User experience giống máy thật | Operations completed | 10 basic (+, -, ×, ÷, =, 0-9, ., AC, DEL) | Manual testing |

---

## 📦 EXECUTION PHASES (Complete Execution v2.1)

> ALL tasks will be executed. No elimination. Optimal ordering.

### Phase 1: FOUNDATION (Core Structure)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| 1 | TASK-VR-001 | Analyze Visual References | 0.5 | None |
| 2 | TASK-DS-001 | Extract Design Tokens | 0.5 | TASK-VR-001 |
| 3 | TASK-003 | Create HTML Structure | 1.0 | TASK-VR-001 |
| 4 | TASK-CSS-001 | Implement CSS Variables | 0.5 | TASK-DS-001 |

**Foundation Hours:** 2.5h

### Phase 2: BUILD (Main Features)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| 5 | TASK-004 | Style Calculator Body | 0.5 | TASK-CSS-001, TASK-003 |
| 6 | TASK-005 | Style Display Screen | 0.5 | TASK-CSS-001, TASK-003 |
| 7 | TASK-006 | Style Keypad Buttons | 1.0 | TASK-CSS-001, TASK-003 |
| 8 | TASK-007 | Implement Basic Math Engine | 1.0 | None (parallel) |
| 9 | TASK-010 | Wire Buttons to Display | 1.0 | TASK-003, TASK-007 |

**Build Hours:** 4.0h

### Phase 3: ENHANCE (Polish)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| 10 | TASK-STATE-001 | Add Hover/Active States | 0.5 | TASK-006 |
| 11 | TASK-ANIM-001 | Add Button Press Animation | 0.5 | TASK-006 |
| 12 | TASK-ERR-001 | Handle Edge Cases | 0.5 | TASK-007 |

**Enhance Hours:** 1.5h

### Phase 4: FINALIZE (Validation)

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| 13 | TASK-VAL-001 | Visual Validation | 0.5 | All above |
| 14 | TASK-TEST-001 | Functional Testing | 0.5 | TASK-010 |

**Finalize Hours:** 1.0h

---

### Execution Summary

| Phase | Tasks | Hours |
|-------|-------|-------|
| FOUNDATION | 4 | 2.5h |
| BUILD | 5 | 4.0h |
| ENHANCE | 3 | 1.5h |
| FINALIZE | 2 | 1.0h |
| **TOTAL** | **14** | **9.0h** |

### Phase Milestones

```
□ FOUNDATION Complete → Verify: Design tokens và HTML structure ready
□ BUILD Complete → Verify: All components styled và functional
□ ENHANCE Complete → Verify: States và animations working
□ FINALIZE Complete → Verify: Visual match 90%, all tests pass
```

---

## 📁 OUTPUT STRUCTURE

```
deliverables/src/
├── index.html              # Main HTML file
├── css/
│   ├── variables.css       # Design tokens (colors, fonts, spacing)
│   ├── body.css            # Calculator frame styling
│   ├── display.css         # LCD screen styling
│   ├── buttons.css         # Keypad button styling
│   └── main.css            # Import all CSS
└── js/
    ├── math-basic.js       # Basic arithmetic engine
    └── app.js              # Main app, wiring buttons
```

---

## 🎨 VISUAL SPECIFICATIONS

> CRITICAL: Sử dụng EXACT VALUES bên dưới. KHÔNG được tự assume.

### Visual References

```yaml
reference_product: "Casio FX-880 VN X Scientific Calculator"
reference_images:
  - path: "references/casio-fx880-front.png"
    description: "Full front view showing entire calculator"
  - path: "references/casio-fx880-keypad.png"
    description: "Close-up of keypad showing button layout and colors"
  - path: "references/casio-fx880-display.png"
    description: "Close-up of LCD display showing green tint"

fidelity_requirements:
  level: "realistic"
  visual_accuracy_target: "90%"
  measurement_method: "20-point visual checklist"
```

### Layout Specification

```
┌─────────────────────────────────────────┐
│           CASIO fx-880 VN X             │  ← Brand header (12px high)
│  ┌───────────────────────────────────┐  │
│  │                                   │  │
│  │     Expression line (small)       │  │  ← LCD Display
│  │     Result line (large)       0   │  │     Height: 80px
│  │                                   │  │     LCD green background
│  └───────────────────────────────────┘  │
│                                         │
│  [SHIFT] [ALPHA] [MODE] [ON]            │  ← Function row (40px)
│                                         │     Gray buttons
│  [x⁻¹] [x²]  [^]  [log] [ln] [(-)]      │  ← Scientific row 1 (40px)
│  [sin] [cos] [tan] [√]  [EXP] [π]       │  ← Scientific row 2 (40px)
│                                         │     Black buttons
│  [ 7 ] [ 8 ] [ 9 ] [DEL] [ AC ]         │  ← Number row 1 (48px)
│  [ 4 ] [ 5 ] [ 6 ] [ × ] [ ÷ ]          │  ← Number row 2 (48px)
│  [ 1 ] [ 2 ] [ 3 ] [ + ] [ − ]          │  ← Number row 3 (48px)
│  [ 0 ] [ . ] [×10ˣ] [Ans] [ = ]         │  ← Number row 4 (48px)
│                                         │     Numbers: Light gray
│                                         │     Operators: Orange
│                                         │     Equal: Blue/Teal
└─────────────────────────────────────────┘

Dimensions:
- Total width: 320px
- Total height: 520px
- Border radius: 16px (outer), 8px (inner components)
- Padding: 16px
- Button gap: 8px
- Button width: 52px (numbers), 48px (functions)
- Button height: 40px (functions), 44px (numbers)
```

### Design Tokens (EXACT VALUES)

```css
/*
 * CRITICAL: Use these EXACT values.
 * Do NOT use generic colors or make assumptions.
 * Extracted from Casio FX-880 VN X reference images.
 */

:root {
  /* === CALCULATOR BODY === */
  --body-bg: #1a1a2e;              /* Dark navy/charcoal */
  --body-border: #0f0f1a;          /* Darker border */
  --body-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  --body-radius: 16px;

  /* === HEADER === */
  --header-bg: transparent;
  --header-text: #c0c0c0;          /* Silver/light gray */
  --header-brand: #ffffff;         /* White for CASIO */
  --header-model: #a0a0a0;         /* Gray for model number */

  /* === LCD DISPLAY === */
  --display-bg: #a8b5a0;           /* LCD green - CRITICAL! */
  --display-text: #1a1a1a;         /* Near black */
  --display-text-dim: #4a4a4a;     /* Dimmer for expression */
  --display-border: #5a6b52;       /* Darker green border */
  --display-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.15);
  --display-radius: 4px;

  /* === BUTTONS - NUMBERS (0-9, .) === */
  --btn-number-bg: #f0f0f0;        /* Light gray */
  --btn-number-text: #1a1a1a;      /* Near black */
  --btn-number-border: #d0d0d0;    /* Slightly darker gray */
  --btn-number-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
  --btn-number-hover: #e5e5e5;     /* Slightly darker on hover */
  --btn-number-active: #d5d5d5;    /* More pressure effect */

  /* === BUTTONS - OPERATORS (+, -, ×, ÷) === */
  --btn-operator-bg: #ff9500;      /* Orange */
  --btn-operator-text: #ffffff;    /* White */
  --btn-operator-border: #e08500;  /* Darker orange */
  --btn-operator-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  --btn-operator-hover: #e68a00;
  --btn-operator-active: #cc7a00;

  /* === BUTTONS - FUNCTION (SHIFT, ALPHA, MODE, scientific) === */
  --btn-function-bg: #505050;      /* Dark gray */
  --btn-function-text: #ffffff;    /* White */
  --btn-function-border: #404040;
  --btn-function-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  --btn-function-hover: #606060;
  --btn-function-active: #404040;

  /* === BUTTONS - EQUAL (=) === */
  --btn-equal-bg: #007aff;         /* Blue/Teal */
  --btn-equal-text: #ffffff;       /* White */
  --btn-equal-border: #0066cc;
  --btn-equal-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  --btn-equal-hover: #0066cc;
  --btn-equal-active: #0055aa;

  /* === BUTTONS - CLEAR (AC, ON) === */
  --btn-clear-bg: #ff3b30;         /* Red */
  --btn-clear-text: #ffffff;       /* White */
  --btn-clear-border: #e02d24;
  --btn-clear-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  --btn-clear-hover: #e02d24;
  --btn-clear-active: #c0251e;

  /* === BUTTONS - DELETE (DEL) === */
  --btn-delete-bg: #808080;        /* Medium gray */
  --btn-delete-text: #ffffff;
  --btn-delete-border: #707070;

  /* === TYPOGRAPHY === */
  --font-display: 'SF Mono', 'Consolas', 'Courier New', monospace;
  --font-buttons: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --font-brand: 'Arial Black', 'Helvetica Neue', sans-serif;

  --font-size-display-result: 32px;
  --font-size-display-expression: 14px;
  --font-size-button: 16px;
  --font-size-button-small: 12px;
  --font-size-brand: 18px;
  --font-size-model: 12px;

  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;

  /* === SPACING === */
  --spacing-unit: 8px;
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;

  /* === BORDERS === */
  --border-radius-sm: 4px;
  --border-radius-md: 8px;
  --border-radius-lg: 12px;
  --border-radius-xl: 16px;
  --border-width: 1px;

  /* === DIMENSIONS === */
  --calc-width: 320px;
  --calc-padding: 16px;
  --display-height: 80px;
  --btn-width: 52px;
  --btn-height: 44px;
  --btn-width-small: 48px;
  --btn-height-small: 40px;
  --btn-gap: 8px;
  --row-gap: 8px;
}
```

### Component Specifications

#### Component 1: Calculator Body

```yaml
component:
  name: "calculator-body"
  html: |
    <div class="calculator">
      <!-- Header -->
      <!-- Display -->
      <!-- Keypad -->
    </div>

  css_classes:
    - class: "calculator"
      purpose: "Main container for entire calculator"

  dimensions:
    width: "var(--calc-width)"      # 320px
    padding: "var(--calc-padding)"  # 16px
    border_radius: "var(--body-radius)"  # 16px

  visual:
    background: "var(--body-bg)"    # #1a1a2e
    border: "2px solid var(--body-border)"
    box_shadow: "var(--body-shadow)"
```

#### Component 2: Header

```yaml
component:
  name: "calc-header"
  html: |
    <div class="calc-header">
      <span class="brand">CASIO</span>
      <span class="model">fx-880 VN X</span>
    </div>

  dimensions:
    height: "40px"
    margin_bottom: "var(--spacing-md)"

  visual:
    text_align: "left"
    brand:
      font: "var(--font-brand)"
      font_size: "var(--font-size-brand)"
      color: "var(--header-brand)"  # #ffffff
      font_weight: "bold"
    model:
      font_size: "var(--font-size-model)"
      color: "var(--header-model)"  # #a0a0a0
      margin_left: "8px"
```

#### Component 3: LCD Display

```yaml
component:
  name: "display"
  html: |
    <div class="display">
      <div class="display-expression"></div>
      <div class="display-result">0</div>
    </div>

  dimensions:
    width: "100%"
    height: "var(--display-height)"  # 80px
    padding: "12px 16px"
    border_radius: "var(--display-radius)"

  visual:
    background: "var(--display-bg)"  # #a8b5a0 - LCD GREEN!
    border: "2px solid var(--display-border)"
    box_shadow: "var(--display-shadow)"

    expression:
      font: "var(--font-display)"
      font_size: "var(--font-size-display-expression)"
      color: "var(--display-text-dim)"
      text_align: "right"
      height: "20px"
      overflow: "hidden"

    result:
      font: "var(--font-display)"
      font_size: "var(--font-size-display-result)"
      color: "var(--display-text)"
      font_weight: "bold"
      text_align: "right"
```

#### Component 4: Keypad Grid

```yaml
component:
  name: "keypad"
  html: |
    <div class="keypad">
      <div class="row function-row">...</div>
      <div class="row">...</div>
      <!-- More rows -->
    </div>

  dimensions:
    margin_top: "var(--spacing-md)"
    gap: "var(--btn-gap)"

  layout:
    display: "flex"
    flex_direction: "column"
    gap: "var(--row-gap)"

  row:
    display: "flex"
    justify_content: "space-between"
    gap: "var(--btn-gap)"
```

#### Component 5: Buttons (5 Types)

```yaml
# Type 1: Number Buttons (0-9, .)
button_number:
  html: '<button class="btn btn-number" data-value="7">7</button>'

  dimensions:
    width: "var(--btn-width)"       # 52px
    height: "var(--btn-height)"     # 44px
    border_radius: "var(--border-radius-md)"  # 8px

  visual:
    background: "var(--btn-number-bg)"      # #f0f0f0
    color: "var(--btn-number-text)"         # #1a1a1a
    border: "1px solid var(--btn-number-border)"
    box_shadow: "var(--btn-number-shadow)"
    font_size: "var(--font-size-button)"
    font_weight: "var(--font-weight-medium)"
    cursor: "pointer"
    transition: "all 0.1s ease"

  states:
    hover:
      background: "var(--btn-number-hover)"
      transform: "translateY(-1px)"
    active:
      background: "var(--btn-number-active)"
      transform: "translateY(0)"
      box_shadow: "inset 0 2px 4px rgba(0,0,0,0.1)"

# Type 2: Operator Buttons (+, -, ×, ÷)
button_operator:
  html: '<button class="btn btn-operator" data-operator="*">×</button>'

  visual:
    background: "var(--btn-operator-bg)"    # #ff9500 (orange)
    color: "var(--btn-operator-text)"       # #ffffff
    border: "1px solid var(--btn-operator-border)"

  states:
    hover:
      background: "var(--btn-operator-hover)"
    active:
      background: "var(--btn-operator-active)"

# Type 3: Function Buttons (SHIFT, ALPHA, MODE, scientific)
button_function:
  html: '<button class="btn btn-function" data-action="shift">SHIFT</button>'

  dimensions:
    height: "var(--btn-height-small)"  # 40px

  visual:
    background: "var(--btn-function-bg)"    # #505050
    color: "var(--btn-function-text)"       # #ffffff
    font_size: "var(--font-size-button-small)"

# Type 4: Equal Button (=)
button_equal:
  html: '<button class="btn btn-equal" data-action="equals">=</button>'

  visual:
    background: "var(--btn-equal-bg)"       # #007aff (blue)
    color: "var(--btn-equal-text)"          # #ffffff
    font_size: "20px"
    font_weight: "bold"

# Type 5: Clear/Delete Buttons (AC, DEL)
button_clear:
  html: '<button class="btn btn-clear" data-action="clear">AC</button>'

  visual:
    background: "var(--btn-clear-bg)"       # #ff3b30 (red)
    color: "var(--btn-clear-text)"          # #ffffff
```

### Interactive States

```css
/* All buttons - Base transition */
.btn {
  transition: all 0.1s ease;
  cursor: pointer;
  user-select: none;
  -webkit-tap-highlight-color: transparent;
}

/* Hover State - Slight lift */
.btn:hover {
  transform: translateY(-1px);
  filter: brightness(1.05);
}

/* Active/Pressed State - Push down */
.btn:active {
  transform: translateY(0);
  filter: brightness(0.95);
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15);
}

/* Focus State - Accessibility */
.btn:focus {
  outline: 2px solid var(--btn-equal-bg);
  outline-offset: 2px;
}

.btn:focus:not(:focus-visible) {
  outline: none;
}

/* Visual feedback class (added via JS) */
.btn.active {
  transform: scale(0.95);
  filter: brightness(0.9);
}
```

---

## 🔧 TASK DETAILS

### TASK-VR-001: Analyze Visual References

**Output:** `references/analysis.md`

**Description:** Phân tích reference images để extract visual information.

**Verification:**
- [ ] Layout structure documented
- [ ] All colors identified
- [ ] All components listed
- [ ] Dimensions estimated

**Note:** This task provides input for TASK-DS-001. Đã được thực hiện trong HANDOFF này.

---

### TASK-DS-001: Extract Design Tokens

**Output:** `deliverables/src/css/variables.css`

**Description:** Tạo CSS custom properties từ design analysis.

**Code:**

```css
/* deliverables/src/css/variables.css */
/* Casio FX-880 VN X Design Tokens */
/* CRITICAL: Copy EXACT values from Design Tokens section above */

:root {
  /* === CALCULATOR BODY === */
  --body-bg: #1a1a2e;
  --body-border: #0f0f1a;
  --body-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  --body-radius: 16px;

  /* === LCD DISPLAY === */
  --display-bg: #a8b5a0;           /* LCD green - CRITICAL! */
  --display-text: #1a1a1a;
  --display-text-dim: #4a4a4a;
  --display-border: #5a6b52;
  --display-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.15);
  --display-radius: 4px;

  /* === BUTTONS === */
  --btn-number-bg: #f0f0f0;
  --btn-number-text: #1a1a1a;
  --btn-number-border: #d0d0d0;
  --btn-number-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
  --btn-number-hover: #e5e5e5;
  --btn-number-active: #d5d5d5;

  --btn-operator-bg: #ff9500;
  --btn-operator-text: #ffffff;
  --btn-operator-border: #e08500;

  --btn-function-bg: #505050;
  --btn-function-text: #ffffff;

  --btn-equal-bg: #007aff;
  --btn-equal-text: #ffffff;

  --btn-clear-bg: #ff3b30;
  --btn-clear-text: #ffffff;

  /* === TYPOGRAPHY === */
  --font-display: 'SF Mono', 'Consolas', 'Courier New', monospace;
  --font-buttons: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

  --font-size-display-result: 32px;
  --font-size-display-expression: 14px;
  --font-size-button: 16px;

  /* === SPACING & DIMENSIONS === */
  --calc-width: 320px;
  --calc-padding: 16px;
  --display-height: 80px;
  --btn-width: 52px;
  --btn-height: 44px;
  --btn-gap: 8px;
  --border-radius-md: 8px;
}
```

**Verification:**
- [ ] All CSS variables defined
- [ ] Colors match reference images
- [ ] No hardcoded values in other CSS files

---

### TASK-003: Create HTML Structure

**Output:** `deliverables/src/index.html`

**Code:**

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Casio FX-880 Calculator</title>
  <link rel="stylesheet" href="css/main.css">
</head>
<body>
  <div class="calculator">
    <!-- Header -->
    <div class="calc-header">
      <span class="brand">CASIO</span>
      <span class="model">fx-880 VN X</span>
    </div>

    <!-- Display -->
    <div class="display">
      <div class="display-expression"></div>
      <div class="display-result">0</div>
    </div>

    <!-- Keypad -->
    <div class="keypad">
      <!-- Function Row -->
      <div class="row function-row">
        <button class="btn btn-function" data-action="shift">SHIFT</button>
        <button class="btn btn-function" data-action="alpha">ALPHA</button>
        <button class="btn btn-function" data-action="mode">MODE</button>
        <button class="btn btn-clear" data-action="on">ON</button>
      </div>

      <!-- Scientific Row 1 (placeholder for MVP) -->
      <div class="row scientific-row">
        <button class="btn btn-function" data-action="inverse">x⁻¹</button>
        <button class="btn btn-function" data-action="square">x²</button>
        <button class="btn btn-function" data-action="power">^</button>
        <button class="btn btn-function" data-action="log">log</button>
        <button class="btn btn-function" data-action="ln">ln</button>
        <button class="btn btn-function" data-action="negate">(-)</button>
      </div>

      <!-- Scientific Row 2 (placeholder for MVP) -->
      <div class="row scientific-row">
        <button class="btn btn-function" data-action="sin">sin</button>
        <button class="btn btn-function" data-action="cos">cos</button>
        <button class="btn btn-function" data-action="tan">tan</button>
        <button class="btn btn-function" data-action="sqrt">√</button>
        <button class="btn btn-function" data-action="exp">EXP</button>
        <button class="btn btn-function" data-action="pi">π</button>
      </div>

      <!-- Number Rows -->
      <div class="row">
        <button class="btn btn-number" data-value="7">7</button>
        <button class="btn btn-number" data-value="8">8</button>
        <button class="btn btn-number" data-value="9">9</button>
        <button class="btn btn-delete" data-action="delete">DEL</button>
        <button class="btn btn-clear" data-action="clear">AC</button>
      </div>

      <div class="row">
        <button class="btn btn-number" data-value="4">4</button>
        <button class="btn btn-number" data-value="5">5</button>
        <button class="btn btn-number" data-value="6">6</button>
        <button class="btn btn-operator" data-operator="*">×</button>
        <button class="btn btn-operator" data-operator="/">÷</button>
      </div>

      <div class="row">
        <button class="btn btn-number" data-value="1">1</button>
        <button class="btn btn-number" data-value="2">2</button>
        <button class="btn btn-number" data-value="3">3</button>
        <button class="btn btn-operator" data-operator="+">+</button>
        <button class="btn btn-operator" data-operator="-">−</button>
      </div>

      <div class="row">
        <button class="btn btn-number" data-value="0">0</button>
        <button class="btn btn-number" data-value=".">.</button>
        <button class="btn btn-function" data-action="exp10">×10ˣ</button>
        <button class="btn btn-function" data-action="ans">Ans</button>
        <button class="btn btn-equal" data-action="equals">=</button>
      </div>
    </div>
  </div>

  <script src="js/math-basic.js"></script>
  <script src="js/app.js"></script>
</body>
</html>
```

**Verification:**
- [ ] All buttons present with correct data attributes
- [ ] 5 number rows
- [ ] 2 scientific rows (placeholder)
- [ ] 1 function row
- [ ] Display has expression and result divs

---

### TASK-007: Implement Basic Math Engine

**Output:** `deliverables/src/js/math-basic.js`

**Code:**

```javascript
/**
 * Casio FX-880 Basic Math Engine
 * Handles: +, -, *, /, =, clear, delete, ans
 */

const Calculator = {
  currentValue: '0',
  previousValue: '',
  operator: null,
  waitingForOperand: false,
  lastAnswer: 0,

  clear() {
    this.currentValue = '0';
    this.previousValue = '';
    this.operator = null;
    this.waitingForOperand = false;
  },

  inputDigit(digit) {
    if (this.waitingForOperand) {
      this.currentValue = digit;
      this.waitingForOperand = false;
    } else {
      this.currentValue = this.currentValue === '0'
        ? digit
        : this.currentValue + digit;
    }
  },

  inputDecimal() {
    if (this.waitingForOperand) {
      this.currentValue = '0.';
      this.waitingForOperand = false;
      return;
    }
    if (!this.currentValue.includes('.')) {
      this.currentValue += '.';
    }
  },

  setOperator(nextOperator) {
    const inputValue = parseFloat(this.currentValue);

    if (this.operator && this.waitingForOperand) {
      this.operator = nextOperator;
      return;
    }

    if (this.previousValue === '') {
      this.previousValue = this.currentValue;
    } else if (this.operator) {
      const result = this.calculate(
        parseFloat(this.previousValue),
        inputValue,
        this.operator
      );
      this.currentValue = String(result);
      this.previousValue = this.currentValue;
    }

    this.waitingForOperand = true;
    this.operator = nextOperator;
  },

  calculate(first, second, operator) {
    switch (operator) {
      case '+': return first + second;
      case '-': return first - second;
      case '*': return first * second;
      case '/': return second !== 0 ? first / second : 'Error';
      default: return second;
    }
  },

  equals() {
    if (!this.operator || this.waitingForOperand) {
      return;
    }

    const inputValue = parseFloat(this.currentValue);
    const result = this.calculate(
      parseFloat(this.previousValue),
      inputValue,
      this.operator
    );

    this.currentValue = String(result);
    this.lastAnswer = result;
    this.previousValue = '';
    this.operator = null;
    this.waitingForOperand = true;
  },

  delete() {
    if (this.currentValue.length > 1) {
      this.currentValue = this.currentValue.slice(0, -1);
    } else {
      this.currentValue = '0';
    }
  },

  getDisplay() {
    return this.currentValue;
  },

  getExpression() {
    if (this.operator && this.previousValue) {
      const opSymbol = { '+': '+', '-': '−', '*': '×', '/': '÷' }[this.operator];
      return `${this.previousValue} ${opSymbol}`;
    }
    return '';
  }
};
```

**Verification:**
- [ ] Addition works correctly
- [ ] Subtraction works correctly
- [ ] Multiplication works correctly
- [ ] Division works correctly
- [ ] Division by zero returns 'Error'
- [ ] Clear resets calculator
- [ ] Delete removes last digit
- [ ] Ans recalls last answer

---

### TASK-010: Wire Buttons to Display

**Output:** `deliverables/src/js/app.js`

**Code:**

```javascript
/**
 * Casio FX-880 Main App
 * Wires buttons to calculator logic + keyboard support
 */

document.addEventListener('DOMContentLoaded', () => {
  const displayResult = document.querySelector('.display-result');
  const displayExpression = document.querySelector('.display-expression');

  function updateDisplay() {
    displayResult.textContent = Calculator.getDisplay();
    displayExpression.textContent = Calculator.getExpression();
  }

  // Event delegation for all buttons
  document.querySelector('.keypad').addEventListener('click', (e) => {
    const btn = e.target.closest('.btn');
    if (!btn) return;

    // Visual feedback
    btn.classList.add('active');
    setTimeout(() => btn.classList.remove('active'), 100);

    // Number buttons
    if (btn.dataset.value !== undefined) {
      if (btn.dataset.value === '.') {
        Calculator.inputDecimal();
      } else {
        Calculator.inputDigit(btn.dataset.value);
      }
    }

    // Operator buttons
    if (btn.dataset.operator) {
      Calculator.setOperator(btn.dataset.operator);
    }

    // Action buttons
    if (btn.dataset.action) {
      switch (btn.dataset.action) {
        case 'clear':
        case 'on':
          Calculator.clear();
          break;
        case 'delete':
          Calculator.delete();
          break;
        case 'equals':
          Calculator.equals();
          break;
        case 'ans':
          Calculator.inputDigit(String(Calculator.lastAnswer));
          break;
        // Scientific functions (placeholder - không implemented trong MVP)
        case 'shift':
        case 'alpha':
        case 'mode':
        case 'inverse':
        case 'square':
        case 'power':
        case 'log':
        case 'ln':
        case 'negate':
        case 'sin':
        case 'cos':
        case 'tan':
        case 'sqrt':
        case 'exp':
        case 'pi':
        case 'exp10':
          // Not implemented in MVP
          break;
      }
    }

    updateDisplay();
  });

  // Keyboard support
  document.addEventListener('keydown', (e) => {
    // Numbers
    if (/^[0-9]$/.test(e.key)) {
      Calculator.inputDigit(e.key);
      updateDisplay();
    }

    // Operators
    const operatorMap = {
      '+': '+',
      '-': '-',
      '*': '*',
      '/': '/',
      'x': '*',
      'X': '*'
    };
    if (operatorMap[e.key]) {
      Calculator.setOperator(operatorMap[e.key]);
      updateDisplay();
    }

    // Other keys
    switch (e.key) {
      case '.':
      case ',':
        Calculator.inputDecimal();
        updateDisplay();
        break;
      case 'Enter':
      case '=':
        Calculator.equals();
        updateDisplay();
        break;
      case 'Backspace':
        Calculator.delete();
        updateDisplay();
        break;
      case 'Escape':
      case 'c':
      case 'C':
        Calculator.clear();
        updateDisplay();
        break;
    }
  });

  // Initial display
  updateDisplay();
});
```

**Verification:**
- [ ] All number buttons update display
- [ ] All operator buttons work
- [ ] Clear button resets to 0
- [ ] Delete removes last digit
- [ ] Equals calculates result
- [ ] Keyboard input works
- [ ] Visual feedback on button press

---

### TASK-CSS-001: Implement CSS Main & Variables

**Output:** `deliverables/src/css/main.css`

```css
/* Main CSS - Import all component styles */
@import './variables.css';
@import './body.css';
@import './display.css';
@import './buttons.css';

/* Reset & Base */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: var(--font-buttons);
  background: linear-gradient(135deg, #1e1e2f 0%, #15152a 100%);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}
```

---

### TASK-004: Style Calculator Body

**Output:** `deliverables/src/css/body.css`

```css
/* Calculator Body Styles */

.calculator {
  width: var(--calc-width);
  padding: var(--calc-padding);
  background: var(--body-bg);
  border: 2px solid var(--body-border);
  border-radius: var(--body-radius);
  box-shadow: var(--body-shadow);
}

.calc-header {
  text-align: left;
  margin-bottom: var(--spacing-md);
  padding: 0 4px;
}

.calc-header .brand {
  font-family: var(--font-brand);
  font-size: var(--font-size-brand);
  font-weight: bold;
  color: var(--header-brand);
  letter-spacing: 2px;
}

.calc-header .model {
  font-size: var(--font-size-model);
  color: var(--header-model);
  margin-left: 8px;
}
```

---

### TASK-005: Style Display Screen

**Output:** `deliverables/src/css/display.css`

```css
/* LCD Display Styles */

.display {
  width: 100%;
  height: var(--display-height);
  padding: 12px 16px;
  background: var(--display-bg);  /* #a8b5a0 - LCD GREEN */
  border: 2px solid var(--display-border);
  border-radius: var(--display-radius);
  box-shadow: var(--display-shadow);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  margin-bottom: var(--spacing-md);
}

.display-expression {
  font-family: var(--font-display);
  font-size: var(--font-size-display-expression);
  color: var(--display-text-dim);
  text-align: right;
  height: 20px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.display-result {
  font-family: var(--font-display);
  font-size: var(--font-size-display-result);
  color: var(--display-text);
  font-weight: bold;
  text-align: right;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

---

### TASK-006: Style Keypad Buttons

**Output:** `deliverables/src/css/buttons.css`

```css
/* Keypad Button Styles */

.keypad {
  display: flex;
  flex-direction: column;
  gap: var(--row-gap);
}

.row {
  display: flex;
  justify-content: space-between;
  gap: var(--btn-gap);
}

/* Base Button Styles */
.btn {
  flex: 1;
  height: var(--btn-height);
  border-radius: var(--border-radius-md);
  border: 1px solid transparent;
  font-family: var(--font-buttons);
  font-size: var(--font-size-button);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: all 0.1s ease;
  user-select: none;
  -webkit-tap-highlight-color: transparent;
}

.btn:focus {
  outline: 2px solid var(--btn-equal-bg);
  outline-offset: 2px;
}

.btn:focus:not(:focus-visible) {
  outline: none;
}

/* Scientific Row - Smaller buttons */
.scientific-row .btn {
  height: var(--btn-height-small);
  font-size: var(--font-size-button-small);
}

/* Function Row */
.function-row .btn {
  height: var(--btn-height-small);
  font-size: var(--font-size-button-small);
}

/* Number Buttons */
.btn-number {
  background: var(--btn-number-bg);
  color: var(--btn-number-text);
  border-color: var(--btn-number-border);
  box-shadow: var(--btn-number-shadow);
}

.btn-number:hover {
  background: var(--btn-number-hover);
  transform: translateY(-1px);
}

.btn-number:active,
.btn-number.active {
  background: var(--btn-number-active);
  transform: translateY(0);
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Operator Buttons */
.btn-operator {
  background: var(--btn-operator-bg);
  color: var(--btn-operator-text);
  border-color: var(--btn-operator-border);
  box-shadow: var(--btn-operator-shadow);
}

.btn-operator:hover {
  background: var(--btn-operator-hover);
  transform: translateY(-1px);
}

.btn-operator:active,
.btn-operator.active {
  background: var(--btn-operator-active);
  transform: translateY(0);
}

/* Function Buttons */
.btn-function {
  background: var(--btn-function-bg);
  color: var(--btn-function-text);
  border-color: var(--btn-function-border);
  box-shadow: var(--btn-function-shadow);
}

.btn-function:hover {
  background: var(--btn-function-hover);
  transform: translateY(-1px);
}

.btn-function:active,
.btn-function.active {
  background: var(--btn-function-active);
  transform: translateY(0);
}

/* Equal Button */
.btn-equal {
  background: var(--btn-equal-bg);
  color: var(--btn-equal-text);
  border-color: var(--btn-equal-border);
  box-shadow: var(--btn-equal-shadow);
  font-size: 20px;
  font-weight: bold;
}

.btn-equal:hover {
  background: var(--btn-equal-hover);
  transform: translateY(-1px);
}

.btn-equal:active,
.btn-equal.active {
  background: var(--btn-equal-active);
  transform: translateY(0);
}

/* Clear Buttons (AC, ON) */
.btn-clear {
  background: var(--btn-clear-bg);
  color: var(--btn-clear-text);
  border-color: var(--btn-clear-border);
  box-shadow: var(--btn-clear-shadow);
}

.btn-clear:hover {
  background: var(--btn-clear-hover);
  transform: translateY(-1px);
}

.btn-clear:active,
.btn-clear.active {
  background: var(--btn-clear-active);
  transform: translateY(0);
}

/* Delete Button */
.btn-delete {
  background: var(--btn-delete-bg);
  color: var(--btn-delete-text);
  border-color: var(--btn-delete-border);
}

.btn-delete:hover {
  filter: brightness(1.1);
  transform: translateY(-1px);
}

.btn-delete:active,
.btn-delete.active {
  filter: brightness(0.9);
  transform: translateY(0);
}
```

---

## ✅ VERIFICATION CHECKLIST

### Functional Verification

```
□ Calculator displays "0" on load
□ Number buttons (0-9) update display
□ Decimal point works (only one allowed)
□ Addition (+) works correctly
□ Subtraction (−) works correctly
□ Multiplication (×) works correctly
□ Division (÷) works correctly
□ Division by zero shows "Error"
□ Equals (=) calculates result
□ AC clears everything
□ DEL removes last digit
□ Ans recalls last result
□ Keyboard input works
□ Page loads in < 2 seconds
```

### Visual Fidelity Verification (Target: 90%)

```
Calculator Body:
□ Body background is dark navy (#1a1a2e)
□ Body has rounded corners (16px)
□ Body has shadow effect
□ Total width is approximately 320px

Header:
□ "CASIO" text is white and bold
□ "fx-880 VN X" text is gray
□ Header is left-aligned

LCD Display:
□ Display background is LCD GREEN (#a8b5a0) - CRITICAL!
□ Display has darker green border
□ Display has inset shadow
□ Result text is large (32px)
□ Result text is aligned right
□ Expression text is smaller and dimmer

Buttons - Numbers (0-9, .):
□ Background is light gray (#f0f0f0)
□ Text is dark (#1a1a1a)
□ Hover raises button slightly
□ Active pushes button down

Buttons - Operators (+, -, ×, ÷):
□ Background is ORANGE (#ff9500)
□ Text is white
□ Visually distinct from number buttons

Buttons - Equal (=):
□ Background is BLUE (#007aff)
□ Text is white and bold
□ Larger font than other buttons

Buttons - Clear (AC, ON):
□ Background is RED (#ff3b30)
□ Text is white

Buttons - Functions:
□ Background is dark gray (#505050)
□ Text is white
□ Smaller than number buttons

Layout:
□ 5 columns of number buttons
□ Buttons evenly spaced
□ Consistent gap between buttons (8px)
□ Scientific rows have smaller buttons
```

---

## 📍 SAVE LOCATIONS

After each task, save results:

```
tasks/TASK-VR-001/result.yaml
tasks/TASK-DS-001/result.yaml
tasks/TASK-003/result.yaml
tasks/TASK-007/result.yaml
tasks/TASK-CSS-001/result.yaml
tasks/TASK-004/result.yaml
tasks/TASK-005/result.yaml
tasks/TASK-006/result.yaml
tasks/TASK-010/result.yaml

phases/04-execute/progress.yaml  # Update after each task
```

---

## 🚨 IMPORTANT NOTES

1. **LCD Display MUST be green (#a8b5a0)** - This is the most critical visual element
2. **Operators MUST be orange (#ff9500)** - This distinguishes the Casio design
3. **Use CSS variables** - All colors must reference variables.css
4. **Test incrementally** - Verify each button works before moving on
5. **Save progress** - Update progress.yaml after each task
6. **Follow exact dimensions** - 320px width, 8px gaps, etc.

---

## 📞 RESUME POINT

If session interrupted, resume from:
- Read `phases/04-execute/progress.yaml` for last completed task
- Continue from next task in sequence

---

**Ready to Execute!** 🚀

Start with TASK-DS-001 (CSS variables) since visual analysis is already in this document.
Use the EXACT color values and dimensions specified above.
