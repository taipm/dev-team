# Step 04: Implementation

## Trigger
Sau Step 03 được approved

## Agent
🐍 Python Developer Agent

## Actions

### 1. Initialize Project

```bash
# Create project structure
poetry new {project_name}
cd {project_name}

# Add dependencies
poetry add fastapi uvicorn[standard] pydantic pydantic-settings
poetry add sqlalchemy[asyncio] asyncpg alembic
poetry add --group dev pytest pytest-asyncio pytest-cov httpx
poetry add --group dev mypy ruff
```

### 2. Create Configuration

```python
# src/{project}/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
    )

    # Database
    database_url: str

    # Security
    secret_key: str
    access_token_expire_minutes: int = 30

    # App
    debug: bool = False
    api_prefix: str = "/api/v1"


settings = Settings()
```

### 3. Implement Models

```python
# src/{project}/models/user.py
from datetime import datetime
from sqlalchemy import String, func
from sqlalchemy.orm import Mapped, mapped_column

from .base import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(
        String(255), unique=True, index=True
    )
    name: Mapped[str] = mapped_column(String(100))
    hashed_password: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(default=True)
    created_at: Mapped[datetime] = mapped_column(
        default=func.now()
    )
```

### 4. Implement Schemas

```python
# src/{project}/schemas/user.py
from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict


class UserBase(BaseModel):
    email: EmailStr
    name: str


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    name: str | None = None
    is_active: bool | None = None


class User(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    is_active: bool
    created_at: datetime
```

### 5. Implement Repository

```python
# src/{project}/repositories/user.py
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.user import User
from ..schemas.user import UserCreate


class UserRepository:
    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get(self, user_id: int) -> Optional[User]:
        result = await self.session.execute(
            select(User).where(User.id == user_id)
        )
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> Optional[User]:
        result = await self.session.execute(
            select(User).where(User.email == email)
        )
        return result.scalar_one_or_none()

    async def create(self, user_in: UserCreate) -> User:
        user = User(
            email=user_in.email,
            name=user_in.name,
            hashed_password=hash_password(user_in.password),
        )
        self.session.add(user)
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def list(
        self, skip: int = 0, limit: int = 100
    ) -> list[User]:
        result = await self.session.execute(
            select(User).offset(skip).limit(limit)
        )
        return list(result.scalars().all())
```

### 6. Implement Service

```python
# src/{project}/services/user.py
from typing import Optional

from ..repositories.user import UserRepository
from ..schemas.user import User, UserCreate


class UserService:
    def __init__(self, repository: UserRepository) -> None:
        self.repository = repository

    async def get_user(self, user_id: int) -> Optional[User]:
        return await self.repository.get(user_id)

    async def create_user(self, user_in: UserCreate) -> User:
        # Check if email exists
        existing = await self.repository.get_by_email(user_in.email)
        if existing:
            raise ValueError("Email already registered")
        return await self.repository.create(user_in)

    async def list_users(
        self, skip: int = 0, limit: int = 100
    ) -> list[User]:
        return await self.repository.list(skip, limit)
```

### 7. Implement API Endpoints

```python
# src/{project}/api/v1/users.py
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status

from ...dependencies import get_user_service
from ...services.user import UserService
from ...schemas.user import User, UserCreate

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/", response_model=User, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_in: UserCreate,
    service: Annotated[UserService, Depends(get_user_service)],
) -> User:
    try:
        return await service.create_user(user_in)
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.get("/{user_id}", response_model=User)
async def get_user(
    user_id: int,
    service: Annotated[UserService, Depends(get_user_service)],
) -> User:
    user = await service.get_user(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return user


@router.get("/", response_model=list[User])
async def list_users(
    service: Annotated[UserService, Depends(get_user_service)],
    skip: int = 0,
    limit: int = 100,
) -> list[User]:
    return await service.list_users(skip, limit)
```

### 8. Wire Main Application

```python
# src/{project}/main.py
from fastapi import FastAPI
from contextlib import asynccontextmanager

from .config import settings
from .database import engine, Base
from .api.router import api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    # Shutdown
    await engine.dispose()


app = FastAPI(
    title="Python Team Project",
    lifespan=lifespan,
)

app.include_router(api_router, prefix=settings.api_prefix)


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🐍 Developer Agent: Implementation Complete                 │
├─────────────────────────────────────────────────────────────┤
│ Files created: {count}                                       │
│                                                              │
│ Structure:                                                   │
│ ├── src/{project}/                                          │
│ │   ├── main.py                                             │
│ │   ├── config.py                                           │
│ │   ├── models/                                             │
│ │   ├── schemas/                                            │
│ │   ├── repositories/                                       │
│ │   ├── services/                                           │
│ │   └── api/                                                │
│ └── pyproject.toml                                          │
└─────────────────────────────────────────────────────────────┘
```

## Next Step
→ Step 05: Testing
