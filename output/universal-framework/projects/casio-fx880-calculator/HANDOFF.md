# 🚀 HANDOFF: Casio FX-880 Calculator App

> Tài liệu chuyển giao cho Claude Code để thực thi Phase 4 (Execute)

---

## 📋 PROJECT OVERVIEW

**Project:** Casio FX-880 Scientific Calculator Web App
**Goal:** Tạo ứng dụng máy tính với giao diện realistic như máy tính thật
**Scope:** MVP - Basic calculator với UI đẹp

---

## ⚡ QUICK START

```bash
# Project location
cd /Users/taipm/GitHub/dev-team/output/universal-framework/projects/casio-fx880-calculator

# Output code goes to
deliverables/src/
```

### Đọc files này trước khi code:
1. `phases/00-define/okr.yaml` - Mục tiêu và KRs
2. `phases/01-decompose/tasks.yaml` - Chi tiết từng task
3. `phases/03-sequence/execution-plan.yaml` - Thứ tự thực hiện

---

## 🎯 OKR (Objectives & Key Results)

**Objective:** Tạo ứng dụng máy tính Casio FX-880 với giao diện realistic

| KR | Target | MVP Target |
|----|--------|------------|
| KR1: Functions | 50+ functions | 10 (basic math) |
| KR2: UI Accuracy | 90% similarity | 80% |
| KR3: Performance | <2s load | <2s |

---

## 📦 MVP SCOPE (8 Tasks)

### Tasks to Execute (In Order):

| Step | Task ID | Name | Hours | Dependencies |
|------|---------|------|-------|--------------|
| 1 | TASK-001 | Research FX-880 layout | 0.5 | None |
| 2a | TASK-002 | Design colors & typography | 0.5 | TASK-001 |
| 2b | TASK-007 | Implement basic arithmetic | 1.0 | None (parallel) |
| 3 | TASK-003 | Create HTML structure | 1.0 | TASK-001 |
| 4a | TASK-004 | Style calculator body | 1.5 | TASK-002, TASK-003 |
| 4b | TASK-005 | Style display screen | 1.0 | TASK-002, TASK-003 |
| 4c | TASK-006 | Style keypad buttons | 1.5 | TASK-002, TASK-003 |
| 5 | TASK-010 | Wire buttons to display | 1.5 | TASK-003, TASK-007 |

**Total MVP Hours:** 5.5h (parallel) / 8.5h (sequential)

---

## 📁 OUTPUT STRUCTURE

```
deliverables/src/
├── index.html              # Main HTML file
├── css/
│   ├── variables.css       # Design tokens (colors, fonts)
│   ├── body.css           # Calculator frame styling
│   ├── display.css        # LCD screen styling
│   ├── buttons.css        # Keypad button styling
│   └── main.css           # Import all CSS
└── js/
    ├── math-basic.js      # Basic arithmetic engine
    └── app.js             # Main app, wiring buttons
```

---

## 🔧 TASK DETAILS

### TASK-001: Research FX-880 Layout

**Output:** Layout specification

**Casio FX-880 VN X Layout:**
```
┌─────────────────────────────────────┐
│           CASIO fx-880              │  ← Brand header
│  ┌───────────────────────────────┐  │
│  │     0                         │  │  ← LCD Display (2 lines)
│  └───────────────────────────────┘  │
│                                     │
│  [SHIFT] [ALPHA] [MODE] [ON]        │  ← Function row (gray)
│                                     │
│  [x⁻¹] [x²] [^] [log] [ln] [(-)]   │  ← Scientific row 1 (black)
│  [sin] [cos] [tan] [√] [EXP] [π]   │  ← Scientific row 2 (black)
│                                     │
│  [ 7 ] [ 8 ] [ 9 ] [DEL] [ AC ]    │  ← Number pad (gray/orange)
│  [ 4 ] [ 5 ] [ 6 ] [ × ] [ ÷ ]    │
│  [ 1 ] [ 2 ] [ 3 ] [ + ] [ − ]    │
│  [ 0 ] [ . ] [×10ˣ] [Ans] [ = ]    │  ← [=] is blue/green
│                                     │
└─────────────────────────────────────┘

Body color: Dark gray/black
Display: LCD green tint
Number buttons: Light gray
Operator buttons: Gray/Orange accents
Equal button: Blue/Teal
```

---

### TASK-002: Design Tokens

**Output:** `css/variables.css`

```css
:root {
  /* Calculator Body */
  --calc-body-bg: #1a1a2e;
  --calc-body-border: #0f0f1a;
  --calc-frame-shadow: 0 10px 30px rgba(0,0,0,0.5);

  /* LCD Display */
  --display-bg: #a8b5a0;
  --display-text: #1a1a1a;
  --display-border: #5a6b52;

  /* Buttons - Numbers */
  --btn-number-bg: #f0f0f0;
  --btn-number-text: #1a1a1a;
  --btn-number-shadow: #cccccc;

  /* Buttons - Operators */
  --btn-operator-bg: #ff9500;
  --btn-operator-text: #ffffff;

  /* Buttons - Function */
  --btn-function-bg: #505050;
  --btn-function-text: #ffffff;

  /* Buttons - Equal */
  --btn-equal-bg: #007aff;
  --btn-equal-text: #ffffff;

  /* Buttons - Clear */
  --btn-clear-bg: #ff3b30;
  --btn-clear-text: #ffffff;

  /* Typography */
  --font-display: 'Digital-7', 'Courier New', monospace;
  --font-buttons: 'Arial', sans-serif;

  /* Sizing */
  --calc-width: 320px;
  --btn-size: 50px;
  --btn-gap: 8px;
  --border-radius: 8px;
}
```

---

### TASK-003: HTML Structure

**Output:** `index.html`

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
      <span class="model">fx-880</span>
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

      <!-- Number Rows -->
      <div class="row">
        <button class="btn btn-number" data-value="7">7</button>
        <button class="btn btn-number" data-value="8">8</button>
        <button class="btn btn-number" data-value="9">9</button>
        <button class="btn btn-operator" data-action="delete">DEL</button>
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
        <button class="btn btn-function" data-action="exp">×10ˣ</button>
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

---

### TASK-007: Basic Math Engine

**Output:** `js/math-basic.js`

```javascript
/**
 * Casio FX-880 Basic Math Engine
 * Handles: +, -, *, /, =, clear
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
      const result = this.calculate(this.previousValue, inputValue, this.operator);
      this.currentValue = String(result);
      this.previousValue = this.currentValue;
    }

    this.waitingForOperand = true;
    this.operator = nextOperator;
  },

  calculate(first, second, operator) {
    const a = parseFloat(first);
    const b = parseFloat(second);

    switch (operator) {
      case '+': return a + b;
      case '-': return a - b;
      case '*': return a * b;
      case '/': return b !== 0 ? a / b : 'Error';
      default: return second;
    }
  },

  equals() {
    if (!this.operator || this.waitingForOperand) {
      return;
    }

    const inputValue = parseFloat(this.currentValue);
    const result = this.calculate(this.previousValue, inputValue, this.operator);

    this.currentValue = String(result);
    this.lastAnswer = result;
    this.previousValue = '';
    this.operator = null;
    this.waitingForOperand = true;
  },

  delete() {
    this.currentValue = this.currentValue.length > 1
      ? this.currentValue.slice(0, -1)
      : '0';
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

---

### TASK-010: Wire Buttons to Display

**Output:** `js/app.js`

```javascript
/**
 * Casio FX-880 Main App
 * Wires buttons to calculator logic
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

    // Number buttons
    if (btn.dataset.value) {
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
      }
    }

    updateDisplay();

    // Visual feedback
    btn.classList.add('active');
    setTimeout(() => btn.classList.remove('active'), 100);
  });

  // Initial display
  updateDisplay();
});
```

---

## ✅ VERIFICATION CHECKLIST

After completing MVP, verify:

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
□ UI looks like real Casio FX-880
□ Page loads in < 2 seconds
```

---

## 📍 SAVE LOCATIONS

After each task, save results:

```
tasks/TASK-001/result.yaml    # Research complete
tasks/TASK-002/result.yaml    # Colors done
tasks/TASK-003/result.yaml    # HTML done
...

phases/04-execute/progress.yaml  # Update after each task
```

---

## 🚨 IMPORTANT NOTES

1. **MVP First** - Focus on basic arithmetic, skip scientific functions
2. **UI Priority** - Make it look realistic before adding features
3. **Test Incrementally** - Verify each button works before moving on
4. **Save Progress** - Update progress.yaml after each task

---

## 📞 RESUME POINT

If session interrupted, resume from:
- Read `phases/04-execute/progress.yaml` for last completed task
- Continue from next task in sequence

---

**Ready to Execute!** 🚀

Start with: Create the directory structure and begin TASK-002 (colors) + TASK-007 (math) in parallel.
