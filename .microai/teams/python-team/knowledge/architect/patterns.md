# Architecture Patterns for Python

Knowledge cho Architect Agent về design patterns phổ biến.

## Repository Pattern

Tách biệt business logic khỏi data access:

```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar, Optional, Sequence

T = TypeVar("T")

class Repository(ABC, Generic[T]):
    """Abstract repository interface."""

    @abstractmethod
    async def get(self, id: int) -> Optional[T]:
        ...

    @abstractmethod
    async def get_all(self) -> Sequence[T]:
        ...

    @abstractmethod
    async def add(self, entity: T) -> T:
        ...

    @abstractmethod
    async def update(self, entity: T) -> T:
        ...

    @abstractmethod
    async def delete(self, id: int) -> bool:
        ...


class SQLAlchemyRepository(Repository[T]):
    """SQLAlchemy implementation."""

    def __init__(self, session: AsyncSession, model: type[T]):
        self._session = session
        self._model = model

    async def get(self, id: int) -> Optional[T]:
        return await self._session.get(self._model, id)
```

## Service Layer Pattern

Business logic trong service classes:

```python
from dataclasses import dataclass

@dataclass
class UserService:
    """User business logic."""

    user_repo: UserRepository
    email_service: EmailService

    async def create_user(self, data: CreateUserDTO) -> User:
        # Validate
        if await self.user_repo.get_by_email(data.email):
            raise UserAlreadyExistsError(data.email)

        # Create
        user = User(**data.model_dump())
        user = await self.user_repo.add(user)

        # Side effects
        await self.email_service.send_welcome(user.email)

        return user
```

## Dependency Injection

Sử dụng DI cho testability:

```python
# FastAPI style
from fastapi import Depends

def get_db() -> Generator[AsyncSession, None, None]:
    async with async_session() as session:
        yield session

def get_user_repo(
    session: AsyncSession = Depends(get_db)
) -> UserRepository:
    return SQLAlchemyUserRepository(session)

def get_user_service(
    user_repo: UserRepository = Depends(get_user_repo),
    email_service: EmailService = Depends(get_email_service),
) -> UserService:
    return UserService(user_repo, email_service)
```

## Unit of Work Pattern

Quản lý transactions:

```python
from contextlib import asynccontextmanager

class UnitOfWork:
    def __init__(self, session_factory):
        self._session_factory = session_factory

    @asynccontextmanager
    async def __call__(self):
        session = self._session_factory()
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
```

## Factory Pattern

Tạo objects phức tạp:

```python
from enum import Enum
from typing import Protocol

class NotificationType(Enum):
    EMAIL = "email"
    SMS = "sms"
    PUSH = "push"

class Notifier(Protocol):
    async def send(self, message: str, recipient: str) -> bool:
        ...

class NotifierFactory:
    _notifiers: dict[NotificationType, type[Notifier]] = {
        NotificationType.EMAIL: EmailNotifier,
        NotificationType.SMS: SMSNotifier,
        NotificationType.PUSH: PushNotifier,
    }

    @classmethod
    def create(cls, type_: NotificationType) -> Notifier:
        notifier_class = cls._notifiers.get(type_)
        if not notifier_class:
            raise ValueError(f"Unknown notifier type: {type_}")
        return notifier_class()
```

## Strategy Pattern

Thuật toán có thể thay đổi:

```python
from typing import Protocol

class PricingStrategy(Protocol):
    def calculate(self, base_price: float) -> float:
        ...

class RegularPricing:
    def calculate(self, base_price: float) -> float:
        return base_price

class PremiumPricing:
    discount: float = 0.1

    def calculate(self, base_price: float) -> float:
        return base_price * (1 - self.discount)

class Order:
    def __init__(self, pricing: PricingStrategy):
        self._pricing = pricing

    def get_total(self, base_price: float) -> float:
        return self._pricing.calculate(base_price)
```

## Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (FastAPI routes, CLI, GraphQL)         │
├─────────────────────────────────────────┤
│           Application Layer             │
│  (Use cases, Services, DTOs)            │
├─────────────────────────────────────────┤
│            Domain Layer                 │
│  (Entities, Value Objects, Repos IF)    │
├─────────────────────────────────────────┤
│         Infrastructure Layer            │
│  (DB, External APIs, File System)       │
└─────────────────────────────────────────┘
```

## Project Structure

```
src/
├── domain/           # Business entities
│   ├── entities/
│   ├── value_objects/
│   └── repositories/  # Interfaces only
├── application/      # Use cases
│   ├── services/
│   ├── dtos/
│   └── interfaces/
├── infrastructure/   # Implementations
│   ├── database/
│   ├── repositories/
│   └── external/
└── presentation/     # API layer
    ├── api/
    ├── schemas/
    └── dependencies/
```
