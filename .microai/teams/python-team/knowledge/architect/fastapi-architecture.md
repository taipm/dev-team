# FastAPI Architecture Patterns

Knowledge cho Architect Agent về FastAPI best practices.

## Project Structure

```
src/
├── main.py              # App entry point
├── config.py            # Settings with Pydantic
├── dependencies.py      # Shared dependencies
├── api/
│   ├── __init__.py
│   ├── v1/
│   │   ├── __init__.py
│   │   ├── router.py    # API router aggregator
│   │   ├── users.py
│   │   └── items.py
│   └── deps.py          # API dependencies
├── core/
│   ├── security.py      # Auth, JWT
│   └── exceptions.py    # Custom exceptions
├── models/              # SQLAlchemy models
│   ├── __init__.py
│   ├── base.py
│   └── user.py
├── schemas/             # Pydantic schemas
│   ├── __init__.py
│   └── user.py
├── services/            # Business logic
│   └── user.py
├── repositories/        # Data access
│   └── user.py
└── utils/
    └── helpers.py
```

## Application Factory

```python
# src/main.py
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.api.v1.router import api_router
from src.config import settings
from src.core.exceptions import setup_exception_handlers


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await init_db()
    yield
    # Shutdown
    await close_db()


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.PROJECT_NAME,
        version=settings.VERSION,
        openapi_url=f"{settings.API_V1_STR}/openapi.json",
        lifespan=lifespan,
    )

    # Middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.ALLOWED_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Exception handlers
    setup_exception_handlers(app)

    # Routes
    app.include_router(api_router, prefix=settings.API_V1_STR)

    return app


app = create_app()
```

## Settings with Pydantic

```python
# src/config.py
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
    )

    # App
    PROJECT_NAME: str = "MyAPI"
    VERSION: str = "1.0.0"
    DEBUG: bool = False
    API_V1_STR: str = "/api/v1"

    # Database
    DATABASE_URL: str
    DATABASE_POOL_SIZE: int = 5

    # Security
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # CORS
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000"]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
```

## Dependency Injection

```python
# src/api/deps.py
from typing import Annotated, AsyncGenerator
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession

from src.core.security import verify_token
from src.models import User
from src.repositories.user import UserRepository

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session


async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> User:
    payload = verify_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
        )

    user_repo = UserRepository(db)
    user = await user_repo.get(payload["sub"])
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return user


# Type aliases for cleaner signatures
DBSession = Annotated[AsyncSession, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]
```

## Router Pattern

```python
# src/api/v1/users.py
from fastapi import APIRouter, HTTPException, status

from src.api.deps import DBSession, CurrentUser
from src.schemas.user import UserCreate, UserResponse, UserUpdate
from src.services.user import UserService

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    data: UserCreate,
    db: DBSession,
) -> UserResponse:
    service = UserService(db)
    return await service.create(data)


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(
    current_user: CurrentUser,
) -> UserResponse:
    return current_user


@router.patch("/me", response_model=UserResponse)
async def update_current_user(
    data: UserUpdate,
    current_user: CurrentUser,
    db: DBSession,
) -> UserResponse:
    service = UserService(db)
    return await service.update(current_user.id, data)
```

## Exception Handling

```python
# src/core/exceptions.py
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse


class AppException(Exception):
    def __init__(self, status_code: int, code: str, message: str):
        self.status_code = status_code
        self.code = code
        self.message = message


class NotFoundError(AppException):
    def __init__(self, resource: str, id: int):
        super().__init__(404, "NOT_FOUND", f"{resource} with id {id} not found")


class ValidationError(AppException):
    def __init__(self, message: str):
        super().__init__(400, "VALIDATION_ERROR", message)


def setup_exception_handlers(app: FastAPI) -> None:
    @app.exception_handler(AppException)
    async def app_exception_handler(request: Request, exc: AppException):
        return JSONResponse(
            status_code=exc.status_code,
            content={
                "error": {
                    "code": exc.code,
                    "message": exc.message,
                }
            },
        )
```

## Background Tasks

```python
from fastapi import BackgroundTasks

@router.post("/users/")
async def create_user(
    data: UserCreate,
    background_tasks: BackgroundTasks,
    db: DBSession,
):
    user = await user_service.create(data)
    background_tasks.add_task(send_welcome_email, user.email)
    return user
```

## Health Check

```python
@router.get("/health")
async def health_check(db: DBSession):
    try:
        await db.execute(text("SELECT 1"))
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return JSONResponse(
            status_code=503,
            content={"status": "unhealthy", "database": str(e)},
        )
```
