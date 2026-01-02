# Python Fundamentals

Shared knowledge cho tất cả agents trong Python Team.

## Python 3.11+ Features

### Type Hints
```python
from typing import Optional, List, Dict, Annotated
from collections.abc import Sequence

def process(items: list[str]) -> dict[str, int]:
    ...
```

### Pattern Matching
```python
match command:
    case ["quit"]:
        return "Goodbye"
    case ["look"]:
        return look()
    case _:
        return "Unknown command"
```

### Exception Groups
```python
try:
    ...
except* ValueError as e:
    handle_value_errors(e.exceptions)
except* TypeError as e:
    handle_type_errors(e.exceptions)
```

## Best Practices

1. **Type Safety**: Use type hints everywhere
2. **Immutability**: Prefer immutable data structures
3. **Context Managers**: Use `with` for resources
4. **Async**: Use async for I/O-bound operations
5. **Dataclasses/Pydantic**: For structured data
