# Code Quality Standards

Knowledge cho Reviewer Agent về code quality standards.

## Code Style (PEP 8)

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variable | snake_case | `user_name` |
| Function | snake_case | `get_user()` |
| Class | PascalCase | `UserService` |
| Constant | UPPER_SNAKE | `MAX_RETRIES` |
| Module | snake_case | `user_service.py` |
| Package | lowercase | `mypackage` |
| Private | _prefix | `_internal_method()` |
| Dunder | __double__ | `__init__()` |

### Line Length

- Maximum 88 characters (Black default)
- Exception: URLs, imports

### Imports Order

```python
# 1. Standard library
import os
import sys
from typing import Optional

# 2. Third-party
import fastapi
import pydantic
from sqlalchemy import Column

# 3. Local application
from src.models import User
from src.services import UserService
```

## Ruff Configuration

```toml
# pyproject.toml
[tool.ruff]
target-version = "py311"
line-length = 88
select = [
    "E",     # pycodestyle errors
    "W",     # pycodestyle warnings
    "F",     # Pyflakes
    "I",     # isort
    "B",     # flake8-bugbear
    "C4",    # flake8-comprehensions
    "UP",    # pyupgrade
    "ARG",   # flake8-unused-arguments
    "SIM",   # flake8-simplify
    "TCH",   # flake8-type-checking
    "PTH",   # flake8-use-pathlib
    "ERA",   # eradicate (commented code)
    "PL",    # Pylint
    "RUF",   # Ruff-specific
]
ignore = [
    "E501",   # Line too long (handled by formatter)
    "PLR0913", # Too many arguments
]

[tool.ruff.per-file-ignores]
"tests/*" = ["ARG", "PLR2004"]  # Allow magic values in tests
"__init__.py" = ["F401"]  # Allow unused imports

[tool.ruff.isort]
known-first-party = ["src"]
```

## Code Smells to Detect

### 1. Long Functions

```python
# BAD: Function > 50 lines
def process_user_data(data):
    # ... 100 lines of code ...
    pass

# GOOD: Break into smaller functions
def process_user_data(data):
    validated = validate_input(data)
    transformed = transform_data(validated)
    return save_data(transformed)
```

### 2. Deep Nesting

```python
# BAD: > 3 levels of nesting
def process(items):
    for item in items:
        if item.is_valid:
            for sub in item.children:
                if sub.active:
                    for value in sub.values:
                        # ...

# GOOD: Early returns, extract methods
def process(items):
    for item in items:
        if not item.is_valid:
            continue
        process_item(item)
```

### 3. God Classes

```python
# BAD: Class doing too many things
class UserManager:
    def create_user(self): ...
    def send_email(self): ...
    def generate_report(self): ...
    def process_payment(self): ...

# GOOD: Single Responsibility
class UserService: ...
class EmailService: ...
class ReportGenerator: ...
class PaymentProcessor: ...
```

### 4. Magic Numbers

```python
# BAD
if retries > 3:
    raise TimeoutError()

# GOOD
MAX_RETRIES = 3
if retries > MAX_RETRIES:
    raise TimeoutError()
```

### 5. Dead Code

```python
# BAD: Unreachable or unused code
def calculate(x):
    return x * 2
    print("This never runs")  # Dead code

# Unused variables
result = get_data()  # Never used
```

## Review Checklist

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No hardcoded values that should be configurable

### Readability
- [ ] Variable/function names are descriptive
- [ ] Complex logic has comments
- [ ] No overly clever code
- [ ] Consistent formatting

### Maintainability
- [ ] DRY - no code duplication
- [ ] Single Responsibility Principle
- [ ] Easy to extend/modify
- [ ] Dependency injection used

### Performance
- [ ] No N+1 query problems
- [ ] Efficient algorithms used
- [ ] No unnecessary loops/iterations
- [ ] Resources properly cleaned up

### Testing
- [ ] Unit tests for new code
- [ ] Edge cases tested
- [ ] Mocking done properly
- [ ] Coverage maintained

## Review Comment Templates

### Critical Issue
```
🔴 **Critical**: [Issue description]

**File**: `path/to/file.py:123`
**Issue**: [Detailed explanation]
**Fix**: [Suggested solution]
```

### Suggestion
```
💡 **Suggestion**: Consider using X instead of Y

This would improve [performance/readability/maintainability] because...
```

### Question
```
❓ **Question**: Why is this approach used here?

I'm curious about the reasoning - is there a specific requirement?
```

### Nitpick
```
📝 **Nit**: Minor style suggestion

[Optional change that doesn't block approval]
```

## Constructive Feedback

### Do
- Explain WHY something is an issue
- Provide specific suggestions
- Acknowledge good code
- Be respectful and professional

### Don't
- Be harsh or dismissive
- Use absolute terms ("never", "always")
- Focus only on negatives
- Make it personal
