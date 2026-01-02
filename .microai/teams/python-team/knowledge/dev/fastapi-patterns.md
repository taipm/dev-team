# FastAPI Development Patterns

Knowledge cho Python Developer về FastAPI implementation.

## Request/Response Schemas

```python
from datetime import datetime
from pydantic import BaseModel, Field, EmailStr, ConfigDict


class UserBase(BaseModel):
    """Base schema with shared fields."""
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=100)


class UserCreate(UserBase):
    """Schema for creating user."""
    password: str = Field(..., min_length=8)


class UserUpdate(BaseModel):
    """Schema for updating user (all optional)."""
    email: EmailStr | None = None
    name: str | None = Field(None, min_length=1, max_length=100)


class UserResponse(UserBase):
    """Schema for API response."""
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime
    is_active: bool = True
```

## Pagination

```python
from typing import Generic, TypeVar, Sequence
from pydantic import BaseModel

T = TypeVar("T")


class PaginatedResponse(BaseModel, Generic[T]):
    items: Sequence[T]
    total: int
    page: int
    size: int
    pages: int

    @classmethod
    def create(
        cls,
        items: Sequence[T],
        total: int,
        page: int,
        size: int,
    ) -> "PaginatedResponse[T]":
        return cls(
            items=items,
            total=total,
            page=page,
            size=size,
            pages=(total + size - 1) // size,
        )


# Usage in endpoint
@router.get("/users", response_model=PaginatedResponse[UserResponse])
async def list_users(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    db: DBSession,
) -> PaginatedResponse[UserResponse]:
    total = await user_repo.count()
    users = await user_repo.get_paginated(page, size)
    return PaginatedResponse.create(users, total, page, size)
```

## Error Handling

```python
from fastapi import HTTPException, status


class APIError(HTTPException):
    """Base API error."""

    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict | None = None,
    ):
        super().__init__(
            status_code=status_code,
            detail={
                "code": code,
                "message": message,
                "details": details or {},
            },
        )


class NotFoundError(APIError):
    def __init__(self, resource: str, id: int):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            code="NOT_FOUND",
            message=f"{resource} with id {id} not found",
        )


class ValidationError(APIError):
    def __init__(self, message: str, details: dict | None = None):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            code="VALIDATION_ERROR",
            message=message,
            details=details,
        )


# Usage
async def get_user(id: int) -> User:
    user = await user_repo.get(id)
    if not user:
        raise NotFoundError("User", id)
    return user
```

## Async Database Operations

```python
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

# Engine setup
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_size=5,
    max_overflow=10,
)

async_session = sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


# Repository pattern
class UserRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def get(self, id: int) -> User | None:
        return await self._session.get(User, id)

    async def get_by_email(self, email: str) -> User | None:
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(self, user: User) -> User:
        self._session.add(user)
        await self._session.flush()
        await self._session.refresh(user)
        return user

    async def update(self, user: User, data: dict) -> User:
        for key, value in data.items():
            if value is not None:
                setattr(user, key, value)
        await self._session.flush()
        return user
```

## Authentication

```python
from datetime import datetime, timedelta
from jose import jwt, JWTError
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"])


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


def create_access_token(
    subject: int,
    expires_delta: timedelta | None = None,
) -> str:
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=30))
    payload = {"sub": str(subject), "exp": expire}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")


def verify_token(token: str) -> dict | None:
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=["HS256"],
        )
        return payload
    except JWTError:
        return None
```

## Middleware

```python
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
import time
import logging

logger = logging.getLogger(__name__)


class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        start = time.perf_counter()

        response = await call_next(request)

        duration = time.perf_counter() - start
        logger.info(
            f"{request.method} {request.url.path} "
            f"status={response.status_code} duration={duration:.3f}s"
        )

        return response
```

## File Upload

```python
from fastapi import UploadFile, File
import aiofiles


@router.post("/upload")
async def upload_file(
    file: UploadFile = File(..., description="File to upload"),
) -> dict:
    # Validate
    if file.content_type not in ["image/jpeg", "image/png"]:
        raise ValidationError("Only JPEG and PNG allowed")

    if file.size > 5 * 1024 * 1024:  # 5MB
        raise ValidationError("File too large")

    # Save
    path = f"uploads/{file.filename}"
    async with aiofiles.open(path, "wb") as f:
        content = await file.read()
        await f.write(content)

    return {"filename": file.filename, "size": file.size}
```

## WebSocket

```python
from fastapi import WebSocket, WebSocketDisconnect


class ConnectionManager:
    def __init__(self):
        self.active: list[WebSocket] = []

    async def connect(self, ws: WebSocket):
        await ws.accept()
        self.active.append(ws)

    def disconnect(self, ws: WebSocket):
        self.active.remove(ws)

    async def broadcast(self, message: str):
        for conn in self.active:
            await conn.send_text(message)


manager = ConnectionManager()


@router.websocket("/ws/{room}")
async def websocket_endpoint(websocket: WebSocket, room: str):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"{room}: {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
```
