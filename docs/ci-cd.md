# CI/CD

The pipeline lives in `.github/workflows/ci.yml`.

## Jobs

1. **Format, analyze, test** on Ubuntu
   - Pin Flutter `3.41.7` (stable)
   - `flutter pub get`
   - `dart run build_runner build`
   - `dart format --set-exit-if-changed .`
   - `flutter analyze --fatal-infos`
   - `flutter test`
2. **Android debug APK** after quality passes
   - No signing secrets
   - Artifact retained for 7 days

## What is intentionally missing

- iOS codesign (requires Apple certificates)
- Store release tracks
- Firebase / Crashlytics upload
- Coverage gates that encourage empty tests

Add GitHub Secrets only if you later introduce a real backend or signing. This clone-and-run app does not need them.
