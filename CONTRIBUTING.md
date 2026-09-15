# Contributing

TaskFlow is a public architecture showcase. Small, focused improvements are welcome.

## Before you open a PR

1. Keep new dependencies justified in the PR description. Prefer no new packages.
2. Domain code must stay free of Flutter, Dio, and Firebase types.
3. Map infrastructure exceptions to `Failure` before they reach Cubits or widgets.
4. Add or update a test when you change behavior.

## Local checks

```bash
dart format --set-exit-if-changed .
flutter analyze --fatal-infos
dart run build_runner build
flutter test
```

## Commit style

Write short commits that explain *why* the change exists. Do not include secrets, API keys, or generated crash reports.
