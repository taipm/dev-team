# Step 05: Testing

## Trigger
Sau Step 04 hoàn thành

## Agent
🧪 Tester Agent

## Actions

### 1. Create Test Configuration

```python
# tests/conftest.py
import pytest
from typing import AsyncGenerator
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    create_async_engine,
    async_sessionmaker,
)

from src.{project}.main import app
from src.{project}.database import get_db, Base
from src.{project}.config import settings


# Test database
TEST_DATABASE_URL = settings.database_url.replace(
    "postgresql://", "postgresql+asyncpg://"
) + "_test"

engine = create_async_engine(TEST_DATABASE_URL, echo=True)
TestSessionLocal = async_sessionmaker(engine, expire_on_commit=False)


@pytest.fixture(scope="session")
def event_loop():
    import asyncio
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(scope="function")
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with TestSessionLocal() as session:
        yield session
        await session.rollback()

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest.fixture
async def client(db_session: AsyncSession) -> AsyncGenerator[AsyncClient, None]:
    async def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db

    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac

    app.dependency_overrides.clear()


@pytest.fixture
def sample_user_data() -> dict:
    return {
        "email": "test@example.com",
        "name": "Test User",
        "password": "securepassword123",
    }
```

### 2. Unit Tests - Schemas

```python
# tests/unit/test_schemas.py
import pytest
from pydantic import ValidationError

from src.{project}.schemas.user import UserCreate, User


class TestUserSchemas:
    def test_user_create_valid(self) -> None:
        user = UserCreate(
            email="test@example.com",
            name="Test User",
            password="password123",
        )
        assert user.email == "test@example.com"
        assert user.name == "Test User"

    @pytest.mark.parametrize(
        "email",
        [
            "invalid-email",
            "",
            "missing@domain",
            "@nodomain.com",
        ],
    )
    def test_user_create_invalid_email(self, email: str) -> None:
        with pytest.raises(ValidationError):
            UserCreate(
                email=email,
                name="Test User",
                password="password123",
            )

    def test_user_create_empty_name(self) -> None:
        with pytest.raises(ValidationError):
            UserCreate(
                email="test@example.com",
                name="",
                password="password123",
            )
```

### 3. Unit Tests - Services

```python
# tests/unit/test_services.py
import pytest
from unittest.mock import AsyncMock, MagicMock

from src.{project}.services.user import UserService
from src.{project}.schemas.user import UserCreate
from src.{project}.models.user import User as UserModel


class TestUserService:
    @pytest.fixture
    def mock_repository(self) -> AsyncMock:
        return AsyncMock()

    @pytest.fixture
    def user_service(self, mock_repository: AsyncMock) -> UserService:
        return UserService(repository=mock_repository)

    @pytest.mark.asyncio
    async def test_get_user_found(
        self,
        user_service: UserService,
        mock_repository: AsyncMock,
    ) -> None:
        mock_user = MagicMock(spec=UserModel)
        mock_user.id = 1
        mock_user.email = "test@example.com"
        mock_repository.get.return_value = mock_user

        result = await user_service.get_user(1)

        assert result == mock_user
        mock_repository.get.assert_called_once_with(1)

    @pytest.mark.asyncio
    async def test_get_user_not_found(
        self,
        user_service: UserService,
        mock_repository: AsyncMock,
    ) -> None:
        mock_repository.get.return_value = None

        result = await user_service.get_user(999)

        assert result is None

    @pytest.mark.asyncio
    async def test_create_user_success(
        self,
        user_service: UserService,
        mock_repository: AsyncMock,
    ) -> None:
        mock_repository.get_by_email.return_value = None
        mock_user = MagicMock(spec=UserModel)
        mock_repository.create.return_value = mock_user

        user_in = UserCreate(
            email="new@example.com",
            name="New User",
            password="password123",
        )

        result = await user_service.create_user(user_in)

        assert result == mock_user

    @pytest.mark.asyncio
    async def test_create_user_email_exists(
        self,
        user_service: UserService,
        mock_repository: AsyncMock,
    ) -> None:
        mock_repository.get_by_email.return_value = MagicMock()

        user_in = UserCreate(
            email="existing@example.com",
            name="New User",
            password="password123",
        )

        with pytest.raises(ValueError, match="Email already registered"):
            await user_service.create_user(user_in)
```

### 4. Integration Tests - API

```python
# tests/integration/test_api_users.py
import pytest
from httpx import AsyncClient


class TestUserAPI:
    @pytest.mark.asyncio
    async def test_create_user(
        self,
        client: AsyncClient,
        sample_user_data: dict,
    ) -> None:
        response = await client.post("/api/v1/users/", json=sample_user_data)

        assert response.status_code == 201
        data = response.json()
        assert data["email"] == sample_user_data["email"]
        assert data["name"] == sample_user_data["name"]
        assert "id" in data
        assert "password" not in data

    @pytest.mark.asyncio
    async def test_create_user_duplicate_email(
        self,
        client: AsyncClient,
        sample_user_data: dict,
    ) -> None:
        # Create first user
        await client.post("/api/v1/users/", json=sample_user_data)

        # Try to create duplicate
        response = await client.post("/api/v1/users/", json=sample_user_data)

        assert response.status_code == 400
        assert "already registered" in response.json()["detail"]

    @pytest.mark.asyncio
    async def test_get_user(
        self,
        client: AsyncClient,
        sample_user_data: dict,
    ) -> None:
        # Create user
        create_response = await client.post("/api/v1/users/", json=sample_user_data)
        user_id = create_response.json()["id"]

        # Get user
        response = await client.get(f"/api/v1/users/{user_id}")

        assert response.status_code == 200
        assert response.json()["email"] == sample_user_data["email"]

    @pytest.mark.asyncio
    async def test_get_user_not_found(self, client: AsyncClient) -> None:
        response = await client.get("/api/v1/users/99999")

        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_list_users(
        self,
        client: AsyncClient,
        sample_user_data: dict,
    ) -> None:
        # Create user
        await client.post("/api/v1/users/", json=sample_user_data)

        # List users
        response = await client.get("/api/v1/users/")

        assert response.status_code == 200
        users = response.json()
        assert len(users) >= 1
```

### 5. Run Tests

```bash
# Run all tests with coverage
poetry run pytest --cov=src --cov-report=term-missing --cov-report=html

# Output example:
# ---------- coverage: platform darwin, python 3.12.0 ----------
# Name                              Stmts   Miss  Cover
# -----------------------------------------------------
# src/{project}/__init__.py             0      0   100%
# src/{project}/config.py               8      0   100%
# src/{project}/models/user.py         12      0   100%
# src/{project}/schemas/user.py        18      2    89%
# src/{project}/repositories/user.py   24      0   100%
# src/{project}/services/user.py       18      0   100%
# src/{project}/api/v1/users.py        28      0   100%
# -----------------------------------------------------
# TOTAL                               108      2    98%
```

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🧪 Tester Agent: Testing Complete                           │
├─────────────────────────────────────────────────────────────┤
│ Tests: {passed}/{total} passed                              │
│ Coverage: {coverage}%                                        │
│                                                              │
│ Test files created:                                          │
│ ├── tests/conftest.py                                       │
│ ├── tests/unit/test_schemas.py                              │
│ ├── tests/unit/test_services.py                             │
│ └── tests/integration/test_api_users.py                     │
└─────────────────────────────────────────────────────────────┘
```

## Next Step
→ Step 06: Review Loop
