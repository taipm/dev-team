# Python Type Hints Guide

Knowledge cho Python Developer về type hints và mypy.

## Basic Types

```python
# Built-in types
name: str = "Alice"
age: int = 30
price: float = 19.99
is_active: bool = True
data: bytes = b"hello"

# None
result: None = None

# Any (tránh dùng nếu có thể)
from typing import Any
unknown: Any = get_unknown_data()
```

## Collections

```python
# Python 3.9+ syntax (recommended)
names: list[str] = ["Alice", "Bob"]
scores: dict[str, int] = {"Alice": 100}
unique: set[int] = {1, 2, 3}
coords: tuple[float, float] = (1.0, 2.0)
mixed: tuple[str, int, bool] = ("a", 1, True)
variable_tuple: tuple[int, ...] = (1, 2, 3, 4)

# Type aliases
UserID = int
UserMap = dict[UserID, "User"]
```

## Optional & Union

```python
from typing import Optional, Union

# Optional = Union[X, None]
def find_user(id: int) -> Optional[User]:
    """Returns User or None."""
    ...

# Python 3.10+ syntax
def find_user(id: int) -> User | None:
    ...

# Union types
def process(value: int | str) -> str:
    if isinstance(value, int):
        return str(value)
    return value
```

## Callable & Functions

```python
from typing import Callable

# Function type
Handler = Callable[[Request], Response]

def register_handler(handler: Handler) -> None:
    ...

# With kwargs
from typing import ParamSpec, TypeVar

P = ParamSpec("P")
R = TypeVar("R")

def decorator(func: Callable[P, R]) -> Callable[P, R]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        return func(*args, **kwargs)
    return wrapper
```

## Generics

```python
from typing import TypeVar, Generic, Sequence

T = TypeVar("T")
K = TypeVar("K")
V = TypeVar("V")

class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()


# Bounded TypeVar
from typing import Comparable

T_co = TypeVar("T_co", covariant=True)
Numeric = TypeVar("Numeric", int, float)

def add(a: Numeric, b: Numeric) -> Numeric:
    return a + b
```

## Protocol (Structural Typing)

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Closeable(Protocol):
    def close(self) -> None:
        ...

class File:
    def close(self) -> None:
        print("File closed")

def cleanup(obj: Closeable) -> None:
    obj.close()

# File is Closeable even without inheritance
cleanup(File())  # OK
```

## TypedDict

```python
from typing import TypedDict, Required, NotRequired

class UserDict(TypedDict):
    id: int
    name: str
    email: str
    age: NotRequired[int]  # Optional field


# total=False makes all fields optional
class PartialUser(TypedDict, total=False):
    id: int
    name: str
```

## Literal & Final

```python
from typing import Literal, Final

# Literal - exact values
Status = Literal["pending", "active", "inactive"]

def set_status(status: Status) -> None:
    ...

set_status("active")  # OK
set_status("unknown")  # Error

# Final - constant
MAX_SIZE: Final = 100
MAX_SIZE = 200  # Error: Cannot reassign
```

## Self Type (Python 3.11+)

```python
from typing import Self

class Builder:
    def set_name(self, name: str) -> Self:
        self.name = name
        return self

    def set_age(self, age: int) -> Self:
        self.age = age
        return self

# Chaining works with subclasses
class ExtendedBuilder(Builder):
    def set_extra(self, extra: str) -> Self:
        self.extra = extra
        return self
```

## Overload

```python
from typing import overload

@overload
def process(value: int) -> str: ...
@overload
def process(value: str) -> int: ...

def process(value: int | str) -> str | int:
    if isinstance(value, int):
        return str(value)
    return len(value)
```

## Type Guards

```python
from typing import TypeGuard

def is_str_list(val: list[object]) -> TypeGuard[list[str]]:
    return all(isinstance(x, str) for x in val)

def process(items: list[object]) -> None:
    if is_str_list(items):
        # items is now list[str]
        print(items[0].upper())
```

## Annotated

```python
from typing import Annotated
from pydantic import Field

# Metadata for validation
UserId = Annotated[int, Field(gt=0)]
Email = Annotated[str, Field(pattern=r"^[\w.-]+@[\w.-]+\.\w+$")]

class User:
    id: UserId
    email: Email
```

## mypy Configuration

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```

## Common Patterns

```python
# Return self for method chaining
def method(self) -> "ClassName":
    return self

# Factory methods
@classmethod
def create(cls) -> "ClassName":
    return cls()

# Context manager
def __enter__(self) -> Self:
    return self

def __exit__(
    self,
    exc_type: type[BaseException] | None,
    exc_val: BaseException | None,
    exc_tb: TracebackType | None,
) -> bool | None:
    return None
```
