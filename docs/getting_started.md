# Getting Started

This guide explains how to run LeafCure locally, even if you are new to Flutter
or mobile app development.

## 1. What LeafCure is

LeafCure is a Flutter app that helps users detect tea leaf diseases from photos.
The app:

- signs users in with Google,
- uploads a leaf image to a backend API,
- optionally sends location for weather-aware analysis,
- shows the diagnosis result, and
- stores history in Supabase.

Important:
the machine learning backend is not part of this repository. You need access to
an existing API that exposes an `/analyze_leaf` endpoint.

## 2. What you need before you start

### Required tools

- Flutter SDK
- Dart SDK
- Android Studio or a similar Android-capable Flutter environment
- Git

### Required accounts or services

- A Supabase project
- A Google Cloud project with OAuth credentials
- Access to the deployed or local backend API

## 3. Helpful beginner glossary

| Term | Meaning |
| --- | --- |
| Flutter | The UI framework used to build this app |
| Supabase | The hosted backend service used here for auth, data, and storage |
| OAuth client ID | The Google credential that allows sign-in |
| `.env` file | A small file that stores configuration values such as URLs and keys |
| Backend API | A separate service that receives the image and returns the analysis |

## 4. Clone the project and install dependencies

```bash
git clone <your-repository-url>
cd LeafCure_App
flutter pub get
```

If `flutter pub get` fails, run:

```bash
flutter doctor
```

Then fix the missing Flutter or Android requirements it reports.

## 5. Configure environment variables

Copy the example environment file:

```bash
cp .env.example .env
```

Open `.env` and fill in real values.

### Environment variables

| Variable | Required | Description | Example |
| --- | --- | --- | --- |
| `SUPABASE_URL` | Yes | Your Supabase project URL | `https://your-project.supabase.co` |
| `SUPABASE_ANON_KEY` | Yes | Public anon key for the Flutter client | `ey...` |
| `GOOGLE_WEB_CLIENT_ID` | Yes | Google Web OAuth client ID used by sign-in | `123456.apps.googleusercontent.com` |
| `PRODUCTION_BASE_URL` | Yes for normal app use | Hosted backend base URL | `https://example.hf.space` |

Beginner tip:
if `.env` is missing or incomplete, the app may start but login or backend
requests will fail at runtime.

## 6. Configure backend mode

LeafCure uses `lib/pages/config.dart` to decide whether it should call a
production API or a local development API.

### Production mode

Keep this value:

```dart
static const bool isDevelopment = false;
```

Then set `PRODUCTION_BASE_URL` in `.env`.

### Local development mode

Change it to:

```dart
static const bool isDevelopment = true;
```

The app will then use:

```text
http://10.0.2.2:8000
```

This is the Android emulator loopback address for your local machine.

Important:
`10.0.2.2` works for the Android emulator, not for a real Android phone. If you
test on a physical device, use a reachable LAN IP or a hosted backend instead.

## 7. Run the app

```bash
flutter run
```

Recommended first verification:

1. Log in with Google.
2. Open the home screen.
3. Tap `Click a Photo`.
4. Choose a sample leaf image.
5. Finish the preview flow and wait for the analysis.
6. Open `Past Predictions` to confirm the history path works.

## 8. Expected external services

### Supabase

The current Flutter client expects:

- Google auth enabled in Supabase
- a database table named `predictions`
- a storage bucket named `leaf_images`

### Backend API

The current client uploads a multipart request to:

```text
POST /analyze_leaf
```

The request may include:

- `file`
- `user_id`
- `use_weather`
- `lat`
- `lon`

The response should contain fields the result page understands, such as:

- `final_prediction`
- `final_confidence`
- `vote_count`
- `total_models`
- `details`
- `weather_data` when weather logic is used

## 9. Daily development workflow

Common commands:

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

Useful before opening a pull request:

```bash
flutter analyze
flutter test
```

## 10. Common beginner issues

### Google login fails on Android

If you see `ApiException: 10`, read:
[google_signin_android_fix.md](google_signin_android_fix.md)

### The app cannot reach the backend

Check:

- `PRODUCTION_BASE_URL` is correct
- `isDevelopment` is set correctly
- the backend server is running
- your device can reach the backend URL

### Weather logic does not work

Check:

- location permission is allowed
- device location services are on
- `AI + Weather Logic` is enabled before analysis

### History is empty

Check:

- the backend sends or saves data for the logged-in user
- Supabase auth succeeded
- the `predictions` table and `leaf_images` bucket exist

## 11. Recommended next reading

- [user_guide.md](user_guide.md) for the screen-by-screen product flow
- [architecture.md](architecture.md) for maintainers and integration work
- [android_release_guide.md](android_release_guide.md) when preparing a release
