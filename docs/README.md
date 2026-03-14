# Documentation Index

This folder contains the project documentation for LeafCure.

If you are new to the project, read the documents in this order:

1. [../README.md](../README.md)
2. [getting_started.md](getting_started.md)
3. [user_guide.md](user_guide.md)
4. [architecture.md](architecture.md)

## Document map

| Document | Best for | What it covers |
| --- | --- | --- |
| [../README.md](../README.md) | Everyone | Project overview, quick start, commands, and links |
| [getting_started.md](getting_started.md) | Beginners and new contributors | Local setup, environment variables, running the app, and common issues |
| [user_guide.md](user_guide.md) | Testers, demos, and non-technical users | How to use the app screen by screen |
| [architecture.md](architecture.md) | Developers and maintainers | System design, data flow, API contract expectations, and project structure |
| [google_signin_android_fix.md](google_signin_android_fix.md) | Android developers | Fixing Google Sign-In `ApiException: 10` |
| [android_release_guide.md](android_release_guide.md) | Release owners | Signed APK builds and GitHub release automation |

## When to use which guide

- Use `getting_started.md` if you cannot run the app yet.
- Use `user_guide.md` if you want to understand the product flow before reading code.
- Use `architecture.md` if you are changing integrations, storage, or API behavior.
- Use `google_signin_android_fix.md` when Android login works on web or iOS but fails on Android.
- Use `android_release_guide.md` when preparing a production APK or GitHub release.

## Scope note

The Flutter client is in this repository. The machine learning backend is not.
Where backend behavior is described, the docs explain the client-side
expectations based on the current app code.
