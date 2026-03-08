# Android APK Release Guide

This project is now configured for professional APK releases with:

- Local signed release builds.
- Automated GitHub Release builds on tags (`vMAJOR.MINOR.PATCH`).

## 1) One-Time Setup: Create Upload Keystore

Run this command from the repo root:

```bash
keytool -genkeypair -v \
  -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Keep this file safe:

- `android/upload-keystore.jks`
- Keystore password
- Key alias (`upload`)
- Key password

If you lose these, you cannot update the same app identity.

## 2) One-Time Setup: Add Android Signing Config

Copy the template and fill real values:

```bash
cp android/key.properties.example android/key.properties
```

Edit `android/key.properties`:

```properties
storeFile=../upload-keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

## 3) Build a Signed APK Locally

```bash
flutter pub get
flutter build apk --release
```

Output:

- `build/app/outputs/flutter-apk/app-release.apk`

This is a universal APK and works across supported Android CPU types.

## 4) GitHub Actions Secrets (for automated release)

In GitHub repo settings, add these secrets:

- `ANDROID_KEYSTORE_BASE64`  
  Base64 of `android/upload-keystore.jks`
- `ANDROID_STORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `APP_ENV_BASE64` or `APP_ENV_FILE`  
  Runtime `.env` content required by the app

Useful commands:

```bash
# Linux
base64 -w 0 android/upload-keystore.jks > keystore.base64.txt
base64 -w 0 .env > env.base64.txt
```

```bash
# macOS
base64 -i android/upload-keystore.jks | tr -d '\n' > keystore.base64.txt
base64 -i .env | tr -d '\n' > env.base64.txt
```

## 5) Release on GitHub (Recommended)

1. Update version in `pubspec.yaml` (for example `1.0.1+2`).
2. Commit and push to `main`.
3. Create and push a tag:

```bash
git tag v1.0.1
git push origin v1.0.1
```

The workflow `.github/workflows/android-release.yml` will:

- Build a signed release APK.
- Attach it to a GitHub Release.
- Upload it as a workflow artifact.

## 6) Manual Run from GitHub UI

You can run the same workflow manually via **Actions** -> **Android Release** -> **Run workflow**, then provide:

- `release_tag` like `v1.0.1`

## 7) Suggested Release Checklist

- `.env` points to production backend.
- Supabase project URL and anon key are production-safe.
- Google Sign-In SHA fingerprints include release keystore SHA-1/SHA-256.
- App tested on at least one low-end and one modern Android device.
