/**
 * Casio FX-880 Math Engine
 * Handles: +, -, *, /, =, clear, delete, ans
 * Scientific: sin, cos, tan, log, ln, sqrt, square, inverse, power, pi, exp
 */

const Calculator = {
  currentValue: '0',
  previousValue: '',
  operator: null,
  waitingForOperand: false,
  lastAnswer: 0,
  degreeMode: true, // true = degrees, false = radians

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
      case '^': return Math.pow(a, b);
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
    if (this.waitingForOperand) return;
    this.currentValue = this.currentValue.length > 1
      ? this.currentValue.slice(0, -1)
      : '0';
  },

  // === SCIENTIFIC FUNCTIONS ===

  // Convert degrees to radians
  toRadians(degrees) {
    return degrees * (Math.PI / 180);
  },

  // Sin function
  sin() {
    const value = parseFloat(this.currentValue);
    const radians = this.degreeMode ? this.toRadians(value) : value;
    this.currentValue = String(Math.sin(radians));
    this.waitingForOperand = true;
  },

  // Cos function
  cos() {
    const value = parseFloat(this.currentValue);
    const radians = this.degreeMode ? this.toRadians(value) : value;
    this.currentValue = String(Math.cos(radians));
    this.waitingForOperand = true;
  },

  // Tan function
  tan() {
    const value = parseFloat(this.currentValue);
    const radians = this.degreeMode ? this.toRadians(value) : value;
    this.currentValue = String(Math.tan(radians));
    this.waitingForOperand = true;
  },

  // Square root
  sqrt() {
    const value = parseFloat(this.currentValue);
    if (value < 0) {
      this.currentValue = 'Error';
    } else {
      this.currentValue = String(Math.sqrt(value));
    }
    this.waitingForOperand = true;
  },

  // Square (x²)
  square() {
    const value = parseFloat(this.currentValue);
    this.currentValue = String(value * value);
    this.waitingForOperand = true;
  },

  // Inverse (x⁻¹ = 1/x)
  inverse() {
    const value = parseFloat(this.currentValue);
    if (value === 0) {
      this.currentValue = 'Error';
    } else {
      this.currentValue = String(1 / value);
    }
    this.waitingForOperand = true;
  },

  // Natural logarithm (ln)
  ln() {
    const value = parseFloat(this.currentValue);
    if (value <= 0) {
      this.currentValue = 'Error';
    } else {
      this.currentValue = String(Math.log(value));
    }
    this.waitingForOperand = true;
  },

  // Base-10 logarithm (log)
  log() {
    const value = parseFloat(this.currentValue);
    if (value <= 0) {
      this.currentValue = 'Error';
    } else {
      this.currentValue = String(Math.log10(value));
    }
    this.waitingForOperand = true;
  },

  // Pi constant
  pi() {
    this.currentValue = String(Math.PI);
    this.waitingForOperand = true;
  },

  // Exponential (e^x)
  exp() {
    const value = parseFloat(this.currentValue);
    this.currentValue = String(Math.exp(value));
    this.waitingForOperand = true;
  },

  // Power (x^y) - sets operator
  power() {
    this.setOperator('^');
  },

  // Negate (-x)
  negate() {
    const value = parseFloat(this.currentValue);
    this.currentValue = String(-value);
  },

  // ×10^x (scientific notation input)
  exp10() {
    this.setOperator('^');
    this.previousValue = '10';
    this.waitingForOperand = true;
  },

  getDisplay() {
    // Format long numbers
    const num = parseFloat(this.currentValue);
    if (isNaN(num)) return this.currentValue;

    // Use scientific notation for very large/small numbers
    if (Math.abs(num) >= 1e10 || (Math.abs(num) < 1e-6 && num !== 0)) {
      return num.toExponential(6);
    }

    // Round to avoid floating point errors
    if (this.currentValue.length > 12) {
      return parseFloat(num.toPrecision(10)).toString();
    }

    return this.currentValue;
  },

  getExpression() {
    if (this.operator && this.previousValue) {
      const opSymbol = { '+': '+', '-': '−', '*': '×', '/': '÷', '^': '^' }[this.operator];
      return `${this.previousValue} ${opSymbol}`;
    }
    return '';
  }
};
