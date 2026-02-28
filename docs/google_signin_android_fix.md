# Google Login Fix (Android API Exception 10)

This project uses native Google Sign-In on Android.  
`ApiException: 10` means Google does not trust the Android app identity yet.

For Android, app identity is:
- Package name: `com.flutter.leafcure`
- Signing certificate fingerprint: `SHA-1` (and usually `SHA-256`)

If either one does not match in Google Cloud OAuth settings, login fails with API 10.

## Step-by-step fix

1. Get your Android debug SHA keys:
```bash
./scripts/show_android_debug_sha.sh
```

2. Open Google Cloud Console:
- `APIs & Services` -> `Credentials`
- Open your **Android OAuth client** (or create one)

3. Set exactly:
- Package name: `com.flutter.leafcure`
- SHA-1 fingerprint: value from step 1
- SHA-256 fingerprint: value from step 1

4. Verify your Web Client ID:
- Open `.env`
- Ensure `GOOGLE_WEB_CLIENT_ID=...apps.googleusercontent.com` is correct
- The same Web Client ID should also be set in Supabase:
  - `Supabase Dashboard` -> `Authentication` -> `Providers` -> `Google`

5. Rebuild the app:
```bash
flutter clean
flutter pub get
flutter run
```

## Why this fixes it

Google Sign-In on Android checks if:
- the running app package name matches OAuth config, and
- the APK signing fingerprint matches OAuth config.

When both match, API 10 disappears and login works.
