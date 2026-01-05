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
        // Basic actions
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

        // Scientific functions
        case 'sin':
          Calculator.sin();
          break;
        case 'cos':
          Calculator.cos();
          break;
        case 'tan':
          Calculator.tan();
          break;
        case 'sqrt':
          Calculator.sqrt();
          break;
        case 'square':
          Calculator.square();
          break;
        case 'inverse':
          Calculator.inverse();
          break;
        case 'log':
          Calculator.log();
          break;
        case 'ln':
          Calculator.ln();
          break;
        case 'pi':
          Calculator.pi();
          break;
        case 'exp':
          Calculator.exp();
          break;
        case 'power':
          Calculator.power();
          break;
        case 'negate':
          Calculator.negate();
          break;
        case 'exp10':
          Calculator.exp10();
          break;

        // Not implemented
        case 'shift':
        case 'alpha':
        case 'mode':
          // Toggle modes - not implemented yet
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
      case '^':
        Calculator.power();
        updateDisplay();
        break;
      case 'p':
      case 'P':
        Calculator.pi();
        updateDisplay();
        break;
      case 's':
      case 'S':
        Calculator.sin();
        updateDisplay();
        break;
      case 'r':
      case 'R':
        Calculator.sqrt();
        updateDisplay();
        break;
    }
  });

  // Initial display
  updateDisplay();
});
