# Deep linking

TaskFlow uses GoRouter for cold start, warm start, and resume. The custom scheme is `taskflow`.

## Supported links

| Link | Destination |
| --- | --- |
| `taskflow://projects/p-1` | Project details |
| `taskflow://tasks/t-1` | Task details |
| `taskflow://tasks` | Tasks tab |
| `taskflow://projects` | Projects tab |

Unauthenticated links redirect to `/login?from=...`. After a successful sign-in the original location is restored.

## Platform configuration in this repo

- Android: `VIEW` / `BROWSABLE` intent filter with `android:scheme="taskflow"` on `MainActivity` (`singleTop`).
- iOS: `CFBundleURLTypes` with scheme `taskflow`.

## Replacing the custom scheme

The routing layer does not hardcode marketing hosts. To move to verified https links:

### Android App Links

1. Add an intent filter for `https` + your host + `android:autoVerify="true"`.
2. Host `.well-known/assetlinks.json` on that domain.
3. Keep the same path structure (`/projects/:id`, `/tasks/:id`) so GoRouter stays unchanged.

### iOS Universal Links

1. Add the Associated Domains entitlement (`applinks:your.domain`).
2. Host `.well-known/apple-app-site-association`.
3. Point paths at the same GoRouter locations.

This repository does not claim those files are live. The custom scheme is enough to demonstrate the navigation contract.
