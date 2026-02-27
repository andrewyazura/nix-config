---
paths:
  - "**/*.kt"
  - "**/*.kts"
  - "build.gradle.kts"
  - "build.gradle"
---

# Kotlin Conventions

## Idioms
- Use `data class` for value types, `sealed class`/`sealed interface` for restricted hierarchies
- Prefer `val` over `var`; use immutable collections (`listOf`, `mapOf`) by default
- Use `when` expressions exhaustively — compiler enforces sealed type coverage
- Prefer `?.let { }` and `?:` (Elvis) over explicit null checks
- Use extension functions to add behavior without inheritance

## Error Handling
- Use `Result<T>` or a custom sealed class for expected failures (parsing, validation, network)
- Reserve exceptions for truly exceptional conditions (programmer errors, unrecoverable states)
- Never catch `Exception` or `Throwable` broadly — catch specific types

## Concurrency
- Use structured concurrency with `coroutineScope` / `supervisorScope`
- Never use `GlobalScope` — it leaks coroutines
- Use `Dispatchers.IO` for blocking I/O, `Dispatchers.Default` for CPU-bound work
- Prefer `Flow` for reactive streams over callbacks

## Build & Test
- Always use the project's Gradle wrapper: `./gradlew` (not a global `gradle`)
- Use JUnit 5 with `@Nested` for grouping, `@ParameterizedTest` for variations
- Use `assertThrows<T>` for exception tests, `assertAll` for grouped soft assertions
- Run `./gradlew ktlintCheck` or `./gradlew detekt` if configured

## Style
- Follow Kotlin official coding conventions and project's `.editorconfig`
- Use trailing commas in multi-line parameter lists and collection literals
- Prefer `require()` / `check()` for preconditions over manual `if`/`throw`
