# Architecture

TaskFlow is a feature-first Clean Architecture app. Dependencies point inward. The domain layer has no Flutter, Dio, or Firebase imports.

```text
Presentation (widgets, Cubits)
        ↓
Domain (entities, use cases, repository contracts)
        ↓
Data (DTOs, data sources, repository implementations)
        ↓
Infrastructure (Dio, secure storage, SharedPreferences)
```

## Features

Each product area owns `data/`, `domain/`, and `presentation/`:

- `auth` — session restore, login, register, logout
- `projects` — list and details
- `tasks` — search, filters, pagination, CRUD, status changes
- `notifications` — in-app inbox
- `profile` — theme, environment label, sign out

## Composition root

`lib/injection/injection.dart` is the only place that constructs infrastructure. Route builders create Cubits and call `load()`. Widgets receive Cubits through `BlocProvider`, not `getIt()`.

## Networking

`ApiClient` configures Dio (base URL, timeouts, auth header, debug logs). In this repository a `MockBackendInterceptor` answers HTTP calls from an in-memory store so the app runs offline. Repositories still parse JSON DTOs and map failures the same way they would against a hosted API.

## Errors

Infrastructure throws `AppException` / `DioException`. `FailureMapper` converts those into `Failure` values. Use cases and Cubits fold `Result<T>`. The UI never imports Dio.
