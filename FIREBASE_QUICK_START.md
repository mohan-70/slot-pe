# Quick Start: Firebase Credentials Setup

Complete in 5 minutes!

## Step 1: Create a Firebase Project

1. Visit [Firebase Console](https://console.firebase.google.com)
2. Click **"Create project"** → Enter name: `slotpe-booking`
3. Choose your location → **Create project**

## Step 2: Get Your API Keys

### For Android:

1. In Firebase Console, click your project
2. Click **gear icon** → **Project Settings**
3. Under "Your apps", select the Android app (or create one)
4. Scroll to **google-services.json** → Download
5. Place file in: `android/app/google-services.json`

### For iOS:

1. Same as Android, but select iOS app
2. Download **GoogleService-Info.plist**
3. Place file in: `ios/Runner/GoogleService-Info.plist`

### For Web:

1. In **Project Settings** → **General** tab
2. Copy the Firebase config object (looks like):

```javascript
{
  apiKey: "AIzaSyD...",
  appId: "1:123456789:web:abc...",
  messagingSenderId: "123456789",
  projectId: "slotpe-booking",
  storageBucket: "slotpe-booking.appspot.com",
  ...
}
```

3. Update `lib/firebase_options.dart` web section with these values

## Step 3: Update firebase_options.dart

Replace `YOUR_XXX` placeholders with actual values from config files:

**Android keys** → from `google-services.json`
**iOS keys** → from `GoogleService-Info.plist`
**Web keys** → from Project Settings

Example:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyD123abc...', // from google-services.json
  appId: '1:123456789:android:abc123def456...',
  messagingSenderId: '123456789',
  projectId: 'slotpe-booking',
  storageBucket: 'slotpe-booking.appspot.com',
);
```

## Step 4: Enable Firebase Services

### Authentication
- Console → **Authentication** → Enable **Google Sign-In**

### Firestore Database
- Console → **Firestore Database** → **Create Database**
- Choose region, start in **test mode**

### Storage
- Console → **Storage** → **Get Started**

## Step 5: Deploy Security Rules

```bash
# Install Firebase CLI if you haven't
npm install -g firebase-tools

# Login
firebase login

# Deploy rules from project root
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## Step 6: Initialize Local Configuration

```bash
# Update .firebaserc with your project ID
# Replace "YOUR_PROJECT_ID" with "slotpe-booking"

# Update firebase.json (already configured)
```

## Step 7: Test It

```bash
# Get Flutter packages
flutter pub get

# Run the app
flutter run
```

---

## Detailed File Locations

| File | Location | Source |
|------|----------|--------|
| google-services.json | `android/app/` | Firebase Console Android config |
| GoogleService-Info.plist | `ios/Runner/` | Firebase Console iOS config |
| firebase_options.dart | `lib/firebase_options.dart` | Manual config from Project Settings |
| firestore.rules | `firestore.rules` | Already in repo ✓ |
| storage.rules | `storage.rules` | Already in repo ✓ |
| firebase.json | `firebase.json` | Already in repo ✓ |
| .firebaserc | `.firebaserc` | Already in repo (update project ID) |

---

## Environment-Specific Config

### Development
- Use test/free Firebase project
- No quota restrictions

### Production
- Use dedicated Firebase project
- Set up billing
- Monitor usage alerts
- Enable advanced security

---

## Troubleshooting

**"Cannot connect to Firebase"**
- Check API keys are correct
- Verify Firebase services are enabled
- Check internet connection

**"Rules rejected error"**
- Ensure user is authenticated for writes
- Check Firestore rules allow operation
- View detailed errors in Firebase Console

**"Missing google-services.json"**
- Download from Firebase Console Android settings
- Place in: `android/app/google-services.json`

**"Pod install failures (iOS)"**
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
cd ..
```

---

## Help & Support

- [Firebase Docs](https://firebase.google.com/docs)
- [Flutter Firebase Guide](https://firebase.flutter.dev/)
- [Project README](README.md)
- [Setup Guide](FIREBASE_SETUP.md)
