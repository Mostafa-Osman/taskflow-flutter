# Architecture decision records

## ADR-001: Why Clean Architecture

**Status:** Accepted

A recruiter or future teammate should see a feature, find its contract, and know what is allowed to depend on what. Putting use cases in the domain layer keeps Cubits thin and makes the same repository testable without widgets.

We did **not** introduce extra “layers” (mappers-of-mappers, presenters, view models on top of Cubits). The three-layer split is enough for this product size.

## ADR-002: Why Cubit instead of a global store

**Status:** Accepted

Cubits are explicit, testable, and scoped to a route. A global store would make pagination, form dirty state, and session restore share one blob of state.

Cubit is preferred over full Bloc here because most events are simple method calls (`load`, `refresh`, `loadMore`). Where an event storm appears, a Bloc can replace that Cubit without changing the domain.

## ADR-003: Why repository abstractions

**Status:** Accepted

Presentation and use cases depend on contracts. The mock HTTP backend can be removed by changing `ApiClient` interceptors and environment URLs, not by rewriting Cubits.

Local cache is an implementation detail of `ProjectRepositoryImpl`. The domain does not know about SharedPreferences.

## ADR-004: Error handling strategy

**Status:** Accepted

- Transport errors stay in `core/network` and `core/errors/exceptions.dart`.
- Domain sees `Result<T>` + `Failure`.
- Widgets render `failure.message` and a retry action.

A custom `Result` type was chosen instead of `dartz` so the API stays small and the package list stays honest.

## ADR-005: Mock at the HTTP boundary

**Status:** Accepted

The requirement was “run without a private backend.” Placing the mock *inside* repositories would leave Dio, interceptors, DTO parsing, and failure mapping unexercised.

A `MockBackendInterceptor` keeps the production path (`Cubit → use case → repository → Dio`) intact. Switching to a hosted API is: set `useMockBackend: false` and point `apiBaseUrl` at a real server.

## ADR-006: Packages we refused

**Status:** Accepted

| Skipped | Reason |
| --- | --- |
| `dartz` | Custom `Result` is enough |
| `injectable` | Manual GetIt is readable at this size |
| Hive | SharedPreferences covers cache + mock users |
| `flutter_screenutil` | Material + constraints are enough |
| Talker | `AppLogger` + Dio logging interceptor cover the need |
| Firebase SDKs | No keys in a public repo; `CrashReporter` / `Analytics` are no-op adapters |
| `google_fonts` | Avoids a network fetch on first launch |
