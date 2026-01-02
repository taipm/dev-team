# Pydantic v2 Patterns

Knowledge cho Python Developer về Pydantic v2 validation.

## Basic Model

```python
from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime


class User(BaseModel):
    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        from_attributes=True,  # Enable ORM mode
    )

    id: int
    name: str = Field(..., min_length=1, max_length=100)
    email: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
```

## Field Validation

```python
from pydantic import BaseModel, Field, field_validator
from typing import Annotated


class Product(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    price: float = Field(..., gt=0, description="Price must be positive")
    quantity: int = Field(default=0, ge=0)
    tags: list[str] = Field(default_factory=list, max_length=10)

    @field_validator("name")
    @classmethod
    def name_must_be_title_case(cls, v: str) -> str:
        return v.title()

    @field_validator("tags", mode="before")
    @classmethod
    def split_tags(cls, v: str | list) -> list:
        if isinstance(v, str):
            return [t.strip() for t in v.split(",")]
        return v
```

## Model Validator

```python
from pydantic import BaseModel, model_validator


class DateRange(BaseModel):
    start_date: datetime
    end_date: datetime

    @model_validator(mode="after")
    def validate_dates(self) -> "DateRange":
        if self.end_date <= self.start_date:
            raise ValueError("end_date must be after start_date")
        return self


class Credentials(BaseModel):
    username: str | None = None
    email: str | None = None
    password: str

    @model_validator(mode="after")
    def check_username_or_email(self) -> "Credentials":
        if not self.username and not self.email:
            raise ValueError("Either username or email required")
        return self
```

## Custom Types

```python
from typing import Annotated
from pydantic import BaseModel, AfterValidator, BeforeValidator
import re


def validate_phone(v: str) -> str:
    pattern = r"^\+?[1-9]\d{9,14}$"
    if not re.match(pattern, v):
        raise ValueError("Invalid phone number")
    return v


def normalize_email(v: str) -> str:
    return v.lower().strip()


PhoneNumber = Annotated[str, AfterValidator(validate_phone)]
Email = Annotated[str, BeforeValidator(normalize_email)]


class Contact(BaseModel):
    phone: PhoneNumber
    email: Email
```

## Computed Fields

```python
from pydantic import BaseModel, computed_field


class Rectangle(BaseModel):
    width: float
    height: float

    @computed_field
    @property
    def area(self) -> float:
        return self.width * self.height

    @computed_field
    @property
    def perimeter(self) -> float:
        return 2 * (self.width + self.height)
```

## Discriminated Unions

```python
from typing import Literal, Union
from pydantic import BaseModel, Field


class Cat(BaseModel):
    pet_type: Literal["cat"]
    meows: int


class Dog(BaseModel):
    pet_type: Literal["dog"]
    barks: float


class Owner(BaseModel):
    pet: Cat | Dog = Field(..., discriminator="pet_type")


# Validation
owner = Owner(pet={"pet_type": "cat", "meows": 5})  # OK
owner = Owner(pet={"pet_type": "dog", "barks": 3.5})  # OK
```

## Settings Management

```python
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import SecretStr, PostgresDsn
from functools import lru_cache


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_nested_delimiter="__",
        case_sensitive=False,
    )

    # App
    app_name: str = "MyApp"
    debug: bool = False

    # Database
    database_url: PostgresDsn

    # Secrets
    secret_key: SecretStr
    api_key: SecretStr

    # Nested config
    redis_host: str = "localhost"
    redis_port: int = 6379


@lru_cache
def get_settings() -> Settings:
    return Settings()
```

## JSON Schema

```python
from pydantic import BaseModel, Field
from typing import Literal


class Item(BaseModel):
    """Product item in the catalog."""

    name: str = Field(
        ...,
        title="Item Name",
        description="The name of the item",
        examples=["Widget", "Gadget"],
    )
    price: float = Field(
        ...,
        gt=0,
        title="Price",
        description="Price in USD",
        examples=[9.99, 19.99],
    )
    status: Literal["active", "inactive"] = "active"


# Generate JSON Schema
print(Item.model_json_schema())
```

## Serialization

```python
from pydantic import BaseModel, field_serializer
from datetime import datetime


class Event(BaseModel):
    name: str
    timestamp: datetime

    @field_serializer("timestamp")
    def serialize_timestamp(self, v: datetime) -> str:
        return v.isoformat()


# Custom serialization context
class User(BaseModel):
    name: str
    email: str
    password: str

    def model_dump_public(self) -> dict:
        """Exclude sensitive fields."""
        return self.model_dump(exclude={"password"})
```

## Generic Models

```python
from typing import Generic, TypeVar
from pydantic import BaseModel

T = TypeVar("T")


class Response(BaseModel, Generic[T]):
    success: bool
    data: T | None = None
    error: str | None = None

    @classmethod
    def ok(cls, data: T) -> "Response[T]":
        return cls(success=True, data=data)

    @classmethod
    def fail(cls, error: str) -> "Response[T]":
        return cls(success=False, error=error)


# Usage
Response[User].ok(user)
Response[list[Item]].ok(items)
```

## Strict Mode

```python
from pydantic import BaseModel, ConfigDict


class StrictModel(BaseModel):
    model_config = ConfigDict(strict=True)

    count: int
    ratio: float


# Strict mode rejects type coercion
StrictModel(count=1, ratio=1.5)  # OK
StrictModel(count="1", ratio="1.5")  # Error!


# Per-field strict
from pydantic import Field

class MixedModel(BaseModel):
    strict_int: int = Field(..., strict=True)
    loose_int: int  # Will coerce "1" to 1
```

## Validation Errors

```python
from pydantic import BaseModel, ValidationError

class User(BaseModel):
    name: str
    age: int

try:
    User(name="", age="not-a-number")
except ValidationError as e:
    print(e.error_count())  # 2
    for error in e.errors():
        print(f"{error['loc']}: {error['msg']}")
        # ('name',): String should have at least 1 character
        # ('age',): Input should be a valid integer
```
