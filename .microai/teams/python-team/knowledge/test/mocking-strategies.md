# Mocking Strategies

Knowledge cho Tester Agent về mocking trong Python tests.

## unittest.mock Basics

```python
from unittest.mock import Mock, MagicMock, AsyncMock, patch


# Simple mock
mock = Mock()
mock.method.return_value = 42
assert mock.method() == 42


# MagicMock - supports magic methods
magic = MagicMock()
magic.__len__.return_value = 5
assert len(magic) == 5


# AsyncMock for async functions
async_mock = AsyncMock(return_value={"data": "value"})
result = await async_mock()
assert result == {"data": "value"}
```

## Patching

```python
from unittest.mock import patch


# Patch as decorator
@patch("src.services.user.send_email")
async def test_user_registration(mock_send_email):
    mock_send_email.return_value = True

    result = await register_user({"email": "test@example.com"})

    assert result.success
    mock_send_email.assert_called_once_with("test@example.com")


# Patch as context manager
async def test_with_context_manager():
    with patch("src.services.external_api.fetch") as mock_fetch:
        mock_fetch.return_value = {"status": "ok"}

        result = await process_data()

        assert result["status"] == "ok"


# Patch object attribute
async def test_patch_object():
    service = UserService()

    with patch.object(service, "repository") as mock_repo:
        mock_repo.get.return_value = User(id=1)

        user = await service.get_user(1)

        assert user.id == 1
```

## Async Mocking

```python
from unittest.mock import AsyncMock, patch
import pytest


class TestAsyncService:
    @pytest.fixture
    def mock_client(self):
        client = AsyncMock()
        client.get.return_value = {"data": "response"}
        return client

    async def test_async_call(self, mock_client):
        service = ApiService(client=mock_client)

        result = await service.fetch_data()

        assert result == {"data": "response"}
        mock_client.get.assert_awaited_once()


# Patching async methods
@patch("httpx.AsyncClient.get", new_callable=AsyncMock)
async def test_http_call(mock_get):
    mock_get.return_value = MagicMock(
        status_code=200,
        json=lambda: {"key": "value"},
    )

    async with httpx.AsyncClient() as client:
        response = await client.get("https://api.example.com")

    assert response.status_code == 200
```

## Side Effects

```python
from unittest.mock import Mock


# Return different values on successive calls
mock = Mock()
mock.side_effect = [1, 2, 3]
assert mock() == 1
assert mock() == 2
assert mock() == 3


# Raise exception
mock.side_effect = ValueError("Something went wrong")
with pytest.raises(ValueError):
    mock()


# Custom function as side effect
def custom_behavior(arg):
    if arg > 10:
        return "big"
    return "small"

mock.side_effect = custom_behavior
assert mock(5) == "small"
assert mock(15) == "big"


# Async side effect
async def async_side_effect(x):
    return x * 2

async_mock = AsyncMock(side_effect=async_side_effect)
result = await async_mock(5)
assert result == 10
```

## Assertions

```python
from unittest.mock import Mock, call


mock = Mock()
mock("arg1", kwarg="value")
mock("arg2")


# Called assertions
mock.assert_called()
mock.assert_called_once()  # Will fail - called twice!
mock.assert_called_with("arg2")  # Last call
mock.assert_any_call("arg1", kwarg="value")


# Call count
assert mock.call_count == 2


# Call args
assert mock.call_args == call("arg2")
assert mock.call_args_list == [
    call("arg1", kwarg="value"),
    call("arg2"),
]


# Reset mock
mock.reset_mock()
assert mock.call_count == 0
```

## PropertyMock

```python
from unittest.mock import PropertyMock, patch


class User:
    @property
    def is_admin(self) -> bool:
        return self._check_admin_status()


def test_admin_property():
    with patch.object(
        User,
        "is_admin",
        new_callable=PropertyMock,
        return_value=True,
    ):
        user = User()
        assert user.is_admin is True
```

## Mocking External Services

```python
import pytest
from unittest.mock import AsyncMock, patch


class TestPaymentService:
    """Mock external payment gateway."""

    @pytest.fixture
    def mock_stripe(self):
        with patch("src.services.payment.stripe") as mock:
            mock.Charge.create = AsyncMock(
                return_value={"id": "ch_123", "status": "succeeded"}
            )
            yield mock

    async def test_process_payment(self, mock_stripe):
        service = PaymentService()

        result = await service.charge(amount=1000, token="tok_123")

        assert result.status == "succeeded"
        mock_stripe.Charge.create.assert_awaited_once_with(
            amount=1000,
            currency="usd",
            source="tok_123",
        )


class TestEmailService:
    """Mock email sending."""

    @pytest.fixture
    def mock_smtp(self):
        with patch("smtplib.SMTP") as mock:
            instance = mock.return_value
            instance.send_message.return_value = {}
            yield instance

    def test_send_email(self, mock_smtp):
        service = EmailService()

        service.send("to@example.com", "Subject", "Body")

        mock_smtp.send_message.assert_called_once()
```

## Mocking Database

```python
import pytest
from unittest.mock import AsyncMock, MagicMock


@pytest.fixture
def mock_session():
    """Mock SQLAlchemy session."""
    session = AsyncMock()

    # Mock query results
    session.execute.return_value.scalars.return_value.all.return_value = [
        User(id=1, email="user1@example.com"),
        User(id=2, email="user2@example.com"),
    ]

    session.execute.return_value.scalar_one_or_none.return_value = User(
        id=1, email="user@example.com"
    )

    return session


async def test_get_all_users(mock_session):
    repo = UserRepository(mock_session)

    users = await repo.get_all()

    assert len(users) == 2
    mock_session.execute.assert_awaited()
```

## Spying (Wrapping Real Objects)

```python
from unittest.mock import Mock


def real_function(x):
    return x * 2


# Wrap real function to spy on calls
spy = Mock(wraps=real_function)

result = spy(5)

assert result == 10  # Real behavior
spy.assert_called_with(5)  # But we can track calls
```

## Freezegun for Time

```python
from freezegun import freeze_time
from datetime import datetime


@freeze_time("2024-01-15 12:00:00")
def test_current_time():
    now = datetime.now()
    assert now.year == 2024
    assert now.month == 1
    assert now.day == 15


@freeze_time("2024-01-15")
async def test_token_expiration():
    token = create_token(expires_in=3600)

    with freeze_time("2024-01-15 00:30:00"):
        assert verify_token(token)  # Still valid

    with freeze_time("2024-01-15 02:00:00"):
        assert not verify_token(token)  # Expired
```
