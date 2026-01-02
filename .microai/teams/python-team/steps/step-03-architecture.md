# Step 03: Architecture Design

## Trigger
Sau Step 02 được approved

## Agent
🏗️ Architect Agent

## Actions

### 1. Analyze Requirements
- Review user stories từ PM
- Identify architectural requirements
- Determine patterns needed

### 2. Select Architecture Pattern

**FastAPI Project:**
```
src/
├── {project}/
│   ├── __init__.py
│   ├── main.py              # FastAPI app, middleware
│   ├── config.py            # pydantic-settings
│   ├── dependencies.py      # Dependency injection
│   │
│   ├── models/              # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── base.py
│   │   └── user.py
│   │
│   ├── schemas/             # Pydantic schemas
│   │   ├── __init__.py
│   │   └── user.py
│   │
│   ├── repositories/        # Data access layer
│   │   ├── __init__.py
│   │   ├── base.py
│   │   └── user.py
│   │
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   └── user.py
│   │
│   └── api/                 # API endpoints
│       ├── __init__.py
│       ├── router.py
│       └── v1/
│           ├── __init__.py
│           └── users.py
│
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── unit/
│   └── integration/
│
├── pyproject.toml
└── README.md
```

**Django Project:**
```
src/
├── {project}/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
│
├── {app}/
│   ├── __init__.py
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   ├── urls.py
│   └── tests/
│
└── manage.py
```

### 3. Define Interfaces

```python
from typing import Protocol, Optional
from abc import abstractmethod

class UserRepositoryProtocol(Protocol):
    @abstractmethod
    async def get(self, user_id: int) -> Optional[User]: ...

    @abstractmethod
    async def create(self, user: UserCreate) -> User: ...

    @abstractmethod
    async def list(self, skip: int, limit: int) -> list[User]: ...
```

### 4. Database Schema

```python
# SQLAlchemy models
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(100))
    hashed_password: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(default=True)
    created_at: Mapped[datetime] = mapped_column(default=func.now())
```

### 5. Dependency Flow

```
Request → Router → Service → Repository → Database
                      ↓
                  Pydantic Schema (validation)
```

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🏗️ Architect Agent: Design Complete                         │
├─────────────────────────────────────────────────────────────┤
│ Pattern: Clean Architecture + Repository Pattern            │
│ Framework: FastAPI                                          │
│                                                              │
│ Layers:                                                      │
│ • API (routers, dependencies)                               │
│ • Services (business logic)                                 │
│ • Repositories (data access)                                │
│ • Models (SQLAlchemy + Pydantic)                            │
│                                                              │
│ Saved to: docs/python-team/{date}-{topic}-architecture.md   │
└─────────────────────────────────────────────────────────────┘
```

## BREAKPOINT
Observer reviews architecture trước khi implementation.

## Next Step
→ Step 04: Implementation
