# User Guide

This guide is for people using LeafCure, testers demonstrating the app, and
team members who want to understand the product flow without reading code.

## 1. What LeafCure helps you do

LeafCure helps you:

- take or upload a photo of a tea leaf,
- send it for disease analysis,
- view the result and confidence,
- read simple treatment advice, and
- review older predictions later.

## 2. Before you begin

To use the app smoothly:

- make sure you can sign in with Google,
- keep an internet connection on,
- allow camera access if you want to take a new photo,
- allow location only if you want weather-assisted analysis.

## 3. Screen-by-screen walkthrough

### Login screen

What you do:

- Tap `Login with Google`.

What happens:

- Google asks you to choose an account.
- After sign-in succeeds, the app opens the home screen.

### Home screen

The home screen is the main dashboard.

Main controls:

| Control | Purpose |
| --- | --- |
| Menu icon | Opens the profile and help area |
| `AI + Weather Logic` switch | Adds location-based weather context to analysis |
| `Click a Photo` | Starts a new prediction |
| `Past Predictions` | Opens earlier saved results |

Beginner tip:
if you are not sure what a button does, open the menu and use the in-app
`How to Use the App` page.

### Capture screen

You will see two options:

- `Camera` for taking a new photo
- `Gallery` for selecting an existing photo

Choose whichever is easier.

### Preview screen

This screen helps you confirm the photo before sending it.

Available actions:

- `Rotate`
- `Retake`
- `Analyze Image`

Only continue when the leaf is clearly visible.

### Result screen

After analysis, the app shows:

- the predicted leaf condition,
- a confidence level,
- AI voting summary,
- weather summary when enabled,
- treatment advice for non-healthy results.

There is also an expandable section called `View AI Analysis Details` that shows
per-model output when the backend returns it.

### History screen

The history page lets you:

- review older predictions,
- reopen a previous result,
- delete an old prediction entry.

If an older record does not contain full analysis details, the app still tries
to rebuild a simpler result view from the stored prediction and confidence.

### Account and help screen

From the menu icon, you can:

- open `How to Use the App`
- switch account
- log out

The help page was designed for first-time users and includes diagrams, button
explanations, and photo tips.

## 4. Photo tips for better results

For the best analysis quality:

- use bright, even lighting
- focus on one leaf at a time
- keep the leaf near the center of the image
- avoid blurry photos
- retake the photo if the leaf is too small or partly hidden

## 5. What the result means

### Prediction label

This is the disease or condition name the app thinks best matches the photo.

### Confidence level

This shows how strongly the app believes in the result.

### AI voting summary

This explains how many AI models agreed on the final answer.

### Recommended cure

If the leaf is not healthy, the app shows simple next-step advice based on the
predicted label.

## 6. Weather logic explained

If you turn on `AI + Weather Logic`:

- the app may ask for location permission,
- the app sends latitude and longitude to the backend,
- the backend can use climate context when producing the result.

If you do not turn it on, the app still works using the photo alone.

## 7. Privacy and permissions

LeafCure may use:

- Google account information for sign-in
- Camera or gallery access for image input
- Location access only when weather logic is enabled

The app also stores prediction history associated with the signed-in user.

## 8. Common user issues

### The camera does not open

Allow camera permission when the phone asks.

### The result looks wrong

Try again with:

- better lighting
- one clear leaf
- a closer image

### I cannot see my old predictions

Make sure you are signed in to the same account you used before.

### Login fails on Android

Ask the maintainer to check:
[google_signin_android_fix.md](google_signin_android_fix.md)

## 9. Suggested demo script

If you are presenting the app to someone else, this is a simple flow:

1. Log in with Google.
2. Explain the `AI + Weather Logic` switch.
3. Tap `Click a Photo`.
4. Upload a sample tea leaf image.
5. Show the preview and `Analyze Image` action.
6. Walk through the result screen.
7. Open `Past Predictions`.
8. Open the help guide from the menu.
