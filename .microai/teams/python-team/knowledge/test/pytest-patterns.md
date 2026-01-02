# Pytest Patterns

Knowledge cho Tester Agent về pytest best practices.

## Project Setup

```toml
# pyproject.toml
[tool.pytest.ini_options]
minversion = "7.0"
addopts = [
    "-ra",
    "-q",
    "--strict-markers",
    "--strict-config",
    "-p", "no:warnings",
]
testpaths = ["tests"]
pythonpath = ["src"]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
    "e2e: marks tests as end-to-end tests",
]
asyncio_mode = "auto"

[tool.coverage.run]
source = ["src"]
branch = true
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
fail_under = 80
```

## Fixtures

```python
# tests/conftest.py
import pytest
from typing import AsyncGenerator
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from src.main import app
from src.models import Base
from src.api.deps import get_db


# Database fixture
@pytest.fixture(scope="session")
def event_loop():
    """Create event loop for async tests."""
    import asyncio
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(scope="session")
async def test_engine():
    """Create test database engine."""
    engine = create_async_engine(
        "sqlite+aiosqlite:///:memory:",
        echo=False,
    )
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield engine
    await engine.dispose()


@pytest.fixture
async def db_session(test_engine) -> AsyncGenerator[AsyncSession, None]:
    """Provide database session with rollback."""
    async_session = sessionmaker(
        test_engine,
        class_=AsyncSession,
        expire_on_commit=False,
    )
    async with async_session() as session:
        yield session
        await session.rollback()


@pytest.fixture
async def client(db_session) -> AsyncGenerator[AsyncClient, None]:
    """Provide test client with overridden dependencies."""

    async def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db

    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac

    app.dependency_overrides.clear()
```

## Test Structure

```python
# tests/unit/test_services.py
import pytest
from unittest.mock import AsyncMock, MagicMock

from src.services.user import UserService
from src.schemas.user import UserCreate


class TestUserService:
    """Test cases for UserService."""

    @pytest.fixture
    def mock_repo(self):
        return AsyncMock()

    @pytest.fixture
    def service(self, mock_repo):
        return UserService(user_repo=mock_repo)

    async def test_create_user_success(self, service, mock_repo):
        # Arrange
        data = UserCreate(email="test@example.com", password="secret123")
        mock_repo.get_by_email.return_value = None
        mock_repo.add.return_value = MagicMock(id=1, email=data.email)

        # Act
        result = await service.create(data)

        # Assert
        assert result.id == 1
        assert result.email == data.email
        mock_repo.add.assert_called_once()

    async def test_create_user_duplicate_email(self, service, mock_repo):
        # Arrange
        data = UserCreate(email="existing@example.com", password="secret123")
        mock_repo.get_by_email.return_value = MagicMock()  # User exists

        # Act & Assert
        with pytest.raises(ValueError, match="already exists"):
            await service.create(data)
```

## Parametrized Tests

```python
import pytest


@pytest.mark.parametrize(
    "email,expected",
    [
        ("valid@email.com", True),
        ("also.valid@sub.domain.com", True),
        ("invalid-email", False),
        ("", False),
        ("@nodomain.com", False),
        ("spaces in@email.com", False),
    ],
    ids=[
        "simple_valid",
        "subdomain_valid",
        "no_at_sign",
        "empty_string",
        "no_local_part",
        "spaces_in_email",
    ],
)
def test_email_validation(email: str, expected: bool):
    result = validate_email(email)
    assert result == expected


@pytest.mark.parametrize(
    "a,b,expected",
    [
        (1, 2, 3),
        (0, 0, 0),
        (-1, 1, 0),
        (100, 200, 300),
    ],
)
def test_addition(a: int, b: int, expected: int):
    assert add(a, b) == expected
```

## API Tests

```python
# tests/integration/test_api.py
import pytest
from httpx import AsyncClient


class TestUserAPI:
    """Integration tests for User API."""

    @pytest.fixture
    async def created_user(self, client: AsyncClient):
        """Create a user for testing."""
        response = await client.post(
            "/api/v1/users/",
            json={"email": "test@example.com", "password": "secret123"},
        )
        return response.json()

    async def test_create_user(self, client: AsyncClient):
        response = await client.post(
            "/api/v1/users/",
            json={"email": "new@example.com", "password": "password123"},
        )

        assert response.status_code == 201
        data = response.json()
        assert data["email"] == "new@example.com"
        assert "id" in data
        assert "password" not in data

    async def test_get_user(self, client: AsyncClient, created_user):
        user_id = created_user["id"]

        response = await client.get(f"/api/v1/users/{user_id}")

        assert response.status_code == 200
        assert response.json()["id"] == user_id

    async def test_get_user_not_found(self, client: AsyncClient):
        response = await client.get("/api/v1/users/99999")

        assert response.status_code == 404
        assert response.json()["detail"]["code"] == "NOT_FOUND"

    async def test_create_user_invalid_email(self, client: AsyncClient):
        response = await client.post(
            "/api/v1/users/",
            json={"email": "invalid", "password": "password123"},
        )

        assert response.status_code == 422  # Validation error
```

## Markers

```python
import pytest


@pytest.mark.slow
async def test_heavy_computation():
    """This test takes a long time."""
    result = heavy_task()
    assert result is not None


@pytest.mark.integration
async def test_database_connection(db_session):
    """Requires real database."""
    await db_session.execute(text("SELECT 1"))


@pytest.mark.e2e
async def test_full_workflow(client):
    """End-to-end test."""
    # Create user
    user = await client.post("/users/", json={...})
    # Login
    token = await client.post("/login", json={...})
    # Use token
    await client.get("/protected", headers={"Authorization": f"Bearer {token}"})


# Run specific markers:
# pytest -m slow
# pytest -m "not slow"
# pytest -m "integration or e2e"
```

## Test Utilities

```python
# tests/utils.py
from typing import Any
from datetime import datetime
import factory


class UserFactory(factory.Factory):
    """Factory for creating test users."""

    class Meta:
        model = dict

    id = factory.Sequence(lambda n: n)
    email = factory.LazyAttribute(lambda o: f"user{o.id}@example.com")
    name = factory.Faker("name")
    created_at = factory.LazyFunction(datetime.utcnow)


def assert_datetime_close(
    actual: datetime,
    expected: datetime,
    delta_seconds: int = 1,
) -> None:
    """Assert two datetimes are close."""
    diff = abs((actual - expected).total_seconds())
    assert diff <= delta_seconds, f"Datetime diff {diff}s > {delta_seconds}s"
```

## Coverage Commands

```bash
# Run with coverage
pytest --cov=src --cov-report=term-missing

# HTML report
pytest --cov=src --cov-report=html
open htmlcov/index.html

# Fail if coverage below threshold
pytest --cov=src --cov-fail-under=80

# Show missing lines
pytest --cov=src --cov-report=term-missing:skip-covered
```
