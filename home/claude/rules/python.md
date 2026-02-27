---
paths:
  - "**/*.py"
  - "**/*.pyi"
  - "pyproject.toml"
---

# Python Conventions

## Formatting & Linting
- Use `ruff` for formatting and linting — run `ruff check` and `ruff format` before committing
- Line length: follow the project's `pyproject.toml` setting (default 88 for ruff)

## Type Annotations
- Use modern union syntax: `str | None` over `Optional[str]`, `list[int]` over `List[int]`
- Annotate all function signatures; use `-> None` explicitly for procedures
- Use `TypeAlias` for complex types, `TypeVar` for generics, `Protocol` for structural typing

## Data Modeling
- Prefer `dataclasses` or Pydantic `BaseModel` over raw dicts for structured data
- Use `@dataclass(frozen=True)` for value objects, `@dataclass(slots=True)` for performance
- Use `Enum` or `StrEnum` for fixed sets of values

## Standard Library Preferences
- `pathlib.Path` over `os.path` for filesystem operations
- `logging` over `print` for any non-debug output
- `contextlib.contextmanager` for resource management patterns
- `functools.cache`/`lru_cache` for memoization

## Testing
- Use `pytest` with fixtures, `@pytest.mark.parametrize`, and `pytest.raises`
- Structure: `tests/` directory mirroring source layout, files prefixed `test_`
- Mock at service boundaries using `unittest.mock.patch` or `pytest-mock`

## Package Management
- Prefer `uv` for fast dependency resolution; fall back to `poetry` if the project uses it
- Pin dependencies in `pyproject.toml`; use lock files for reproducibility
