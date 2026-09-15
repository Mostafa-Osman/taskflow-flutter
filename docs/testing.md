# Testing

Tests cover behavior that can regress, not line count.

## Commands

```bash
flutter test
flutter test test/features/tasks/presentation/tasks_cubit_test.dart
```

## What is covered

| Area | Why it matters |
| --- | --- |
| `Result` / `FailureMapper` | UI must never depend on Dio types |
| Validators | Auth and task forms fail closed |
| `PaginationController` | Duplicate load-more is a real production bug |
| `MockBackendStore` | Seed data, login, search, and paging stay consistent |
| Login / create-task use cases | Validation happens before I/O |
| Auth repository | Session cache and unauthorized mapping |
| AuthCubit / TasksCubit / TaskFormCubit | Loading, empty, error, retry, pagination |
| Login and Projects widgets | Validation, retry, empty/error rendering |

## Conventions

- Use `mocktail` for contracts and `bloc_test` for Cubits.
- Widget tests wrap a single screen with the Cubit it actually needs.
- Prefer one assertion about user-visible behavior over snapshot-style tree dumps.
