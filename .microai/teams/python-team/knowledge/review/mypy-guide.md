# mypy Configuration Guide

Knowledge cho Reviewer Agent về type checking với mypy.

## Configuration

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
strict = true

# Strict mode enables these:
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true

# Additional settings
show_error_codes = true
show_column_numbers = true
pretty = true

# Plugin for Pydantic
plugins = ["pydantic.mypy"]

# Per-module overrides
[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = [
    "httpx.*",
    "redis.*",
]
ignore_missing_imports = true
```

## Common Errors and Fixes

### 1. Missing Return Type

```python
# Error: Function is missing a return type annotation
def get_name(user):
    return user.name

# Fix
def get_name(user: User) -> str:
    return user.name
```

### 2. Incompatible Return Type

```python
# Error: Incompatible return value type
def get_user(id: int) -> User:
    return None  # Error!

# Fix with Optional
def get_user(id: int) -> User | None:
    if id < 0:
        return None
    return User(id=id)
```

### 3. Argument Type Mismatch

```python
# Error: Argument 1 has incompatible type "str"; expected "int"
def process(count: int) -> None:
    ...

process("10")  # Error!

# Fix
process(int("10"))
```

### 4. Missing Type for Variable

```python
# Error: Need type annotation for variable
items = []

# Fix
items: list[Item] = []
# or
items = []  # type: list[Item]
```

### 5. Union Narrowing

```python
# Error: Item "None" has no attribute "name"
def get_name(user: User | None) -> str:
    return user.name  # Error!

# Fix with guard
def get_name(user: User | None) -> str:
    if user is None:
        return "Unknown"
    return user.name

# Or with assertion
def get_name(user: User | None) -> str:
    assert user is not None
    return user.name
```

### 6. Dict Key Access

```python
# Error: TypedDict key must be a string literal
def get_value(data: UserDict, key: str) -> Any:
    return data[key]  # Error for TypedDict!

# Fix: use get() or cast
def get_value(data: dict[str, Any], key: str) -> Any:
    return data.get(key)
```

### 7. Generic Type Issues

```python
# Error: List item has incompatible type
def process(items: list[int]) -> None:
    ...

values: list[int | str] = [1, "two"]
process(values)  # Error!

# Fix: ensure correct types
values: list[int] = [1, 2]
process(values)
```

## Type: ignore Comments

### When to Use

```python
# Only use when mypy is wrong or for third-party issues
result = external_lib.method()  # type: ignore[no-untyped-call]

# Always specify the error code
config = yaml.load(file)  # type: ignore[arg-type]

# Add explanation for non-obvious cases
# mypy doesn't understand SQLAlchemy's hybrid_property
value = obj.computed_field  # type: ignore[misc]  # SQLAlchemy hybrid
```

### When NOT to Use

```python
# BAD: Silencing legitimate errors
def broken_function(x):  # type: ignore
    return x.undefined_method()

# BAD: Blanket ignore without code
result = function()  # type: ignore
```

## Protocol vs ABC

```python
from typing import Protocol
from abc import ABC, abstractmethod


# Protocol (structural typing) - preferred for duck typing
class Closeable(Protocol):
    def close(self) -> None:
        ...


# ABC (nominal typing) - when inheritance matters
class BaseService(ABC):
    @abstractmethod
    def process(self) -> None:
        ...


# Use Protocol when you care about behavior, not inheritance
def cleanup(obj: Closeable) -> None:
    obj.close()
```

## Callable Types

```python
from typing import Callable, ParamSpec, TypeVar

P = ParamSpec("P")
R = TypeVar("R")


# Simple callable
Handler = Callable[[Request], Response]

# With ParamSpec for decorators
def log_calls(func: Callable[P, R]) -> Callable[P, R]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper
```

## Common Review Points

### Check For

1. **All functions have type annotations**
   - Parameters typed
   - Return type specified

2. **No unnecessary `# type: ignore`**
   - Each ignore has error code
   - Justification in comment

3. **Proper Optional handling**
   - None checks before access
   - No implicit None returns

4. **Generic types used correctly**
   - TypeVar constraints
   - Covariance/contravariance

5. **Protocol over ABC when possible**
   - Structural typing preferred
   - Less coupling

## Running mypy

```bash
# Basic check
mypy src/

# With config file
mypy --config-file pyproject.toml src/

# Show detailed errors
mypy src/ --show-error-context --show-column-numbers

# Check specific file
mypy src/services/user.py

# Generate report
mypy src/ --html-report mypy-report
```
