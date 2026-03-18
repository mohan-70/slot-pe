# Firebase Setup Guide for Bookit (Slotpe)

Complete Firebase configuration for the Bookit booking application including Firestore, Authentication, Storage, and Deployment.

**Project ID:** `slot-pe`
**Storage Bucket:** `slot-pe.firebasestorage.app`

## Prerequisites

- Firebase CLI installed: `npm install -g firebase-tools`
- Active Google Cloud Project (Already created!)
- Flutter and Dart SDK installed

---

## Step 1: Firebase Project Already Created ✓

Your Firebase project `slot-pe` is already set up. Verify it at [Firebase Console](https://console.firebase.google.com/project/slot-pe)

---

## Step 2: Download Configuration Files

### For Android:
1. Go to [Firebase Console → slot-pe](https://console.firebase.google.com/project/slot-pe/settings/general)
2. Click Android app → Select your app
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`
5. **UPDATE:** Copy the `appId` value from google-services.json to [lib/firebase_options.dart](lib/firebase_options.dart) line 17

### For iOS:
1. Same console as Android, but select iOS app
2. Download `GoogleService-Info.plist`
3. Place it in: `ios/Runner/GoogleService-Info.plist`
4. Already configured in [lib/firebase_options.dart](lib/firebase_options.dart) ✓

### For Web:
Already configured in [lib/firebase_options.dart](lib/firebase_options.dart) ✓

---

## Step 3: Firebase Services Status

```bash
# Login to Firebase
firebase login

# Initialize Firebase in your project (run from project root)
firebase init

# Select these options:
# - Firestore
# - Storage
# - Hosting
# - Emulators
```

---

## Step 3: Firebase Services Status

✓ Firestore Database - Enable in Console
✓ Cloud Storage - Enable in Console
✓ Authentication - Enable Google Sign-In
✓ Security Rules - Ready to deploy

---

## Step 4: Configure Firebase CLI

1. Go to Firebase Console → Project Settings
2. Under "Your apps", click on your app platforms (iOS, Android, Web)
3. Download the configuration files

### For Android:
- Download `google-services.json`
- Place it in: `android/app/google-services.json`

### For iOS:
- Download `GoogleService-Info.plist`
- Place it in: `ios/Runner/GoogleService-Info.plist`

### For Web:
- Copy the Firebase config object

---

## Step 5: Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'slotpe-booking',
  storageBucket: 'slotpe-booking.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'slotpe-booking',
  storageBucket: 'slotpe-booking.appspot.com',
  iosBundleId: 'com.slotpe.app',
);

static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'slotpe-booking',
  storageBucket: 'slotpe-booking.appspot.com',
);
```

---

## Step 6: Enable Firebase Services

### Authentication
1. Firebase Console → Authentication
2. Sign-in method → Enable "Google Sign-In"
3. Configure OAuth consent screen in Google Cloud Console

### Firestore Database
1. Firebase Console → Firestore Database
1. **Firestore Database** ✓
2. **Cloud Storage** ✓
3. **Authentication** ✓
4. **Security Rules** ✓
5. **Firestore Indexes** ✓
# From project root directory
firebase deploy --only firestore:rules,firestore:indexes
```

### Deploy Storage Rules
```bash
firebase deploy --only storage
```

### Deploy Everything
```bash
firebase deploy
```Security Rules and Indexes

```bash
# From project root directory
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Verify deployment succeeded in output.

---

## Step 8: Test Your Setups.google-services'
```

---

## Step 9: Configure iOS

```bash
# Navigate to iOS directory
cd ios

# Install pods with Firebase
pod install --repo-update

# Go back to project root
cd ..
```

---

## Step 10: Verify Flutter Setup

```bash
# Check Flutter pub dependencies
flutter pub get

# Verify Firebase is properly installed
flutter pub outdated
```

---

## Step 11: Update main.dart (Already Done)

The Firebase initialization is already configured in `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## Step 12: Collections & Data Structure

### Businesses Collection
```
/businesses/{businessId}
  - id: string
  - ownerId: string (Firebase Auth UID)
  - name: string
  - category: string
  - phone: string
  - city: string
  - bookingSlug: string (unique, for public booking link)
  - workingDays: array of strings
  - openTime: string (HH:mm)
  - closeTime: string (HH:mm)
  - slotDurationMinutes: number
  - isActive: boolean
  - createdAt: timestamp
  - planType: string (free, pro, enterprise)

Subcollections:
  /services/{serviceId}: Service details
  /timeSlots/{date}: Available time slots
  /reviews/{reviewId}: Customer reviews
```

### Bookings Collection
```
/bookings/{bookingId}
  - id: string
  - businessId: string (reference to business)
  - serviceName: string
  - servicePrice: number
  - customerId: string (Firebase Auth UID)
  - customerName: string
  - customerPhone: string
  - date: string (yyyy-MM-dd)
  - timeSlot: string (HH:mm)
  - status: string (pending, confirmed, cancelled, completed, no-show)
  - notes: string (optional)
  - createdAt: timestamp
```

### Users Collection
```
/users/{userId}
  - email: string
  - displayName: string
  - photoURL: string (optional)
  - phoneNumber: string (optional)
  - createdAt: timestamp
  - userType: string (customer, business_owner, admin)
```

---

## Step 13: Firestore Rules Breakdown

The `firestore.rules` file includes:

### Businesses
- ✅ Anyone can read (public business info)
- ✅ Authenticated users can create business
- ✅ Only owner can update/delete
- ✅ Anyone can read reviews
- ✅ Authenticated users can create reviews

### Bookings
- ✅ Users can read their own bookings
- ✅ Business owner can read bookings for their business
- ✅ Authenticated users can create bookings
- ✅ Business owner can update booking status
- ✅ Customers can cancel pending bookings

### Storage Rules
- ✅ Public read access to business files
- ✅ Business owner can manage their files
- ✅ Users can manage their own files
- ✅ 5MB limit for business files, 2MB for user avatars

---

## Step 14: Testing Locally (Optional)

```bash
# Start Firebase emulators
firebase emulators:start

# In another terminal, run Flutter
flutter run
```

To connect your Flutter app to emulators, add before Firebase initialization in main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // For development/testing only:
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // await FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // await FirebaseStorage.instance.useStorageEmulator(
  //   host: 'localhost',
  //   port: 9199,
  // );
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## Step 15: Deploy to Production

### Deploy Firestore & Storage Rules
```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
```

### Deploy Web Hosting (if applicable)
```bash
flutter build web
firebase deploy --only hosting
```

### Deploy Cloud Functions (if added)
```bash
firebase deploy --only functions
```

### Full Deployment
```bash
firebase deploy
```

---

## Important Security Notes

1. **Never commit credentials**: Add `google-services.json` and `GoogleService-Info.plist` to `.gitignore`
2. **Review Rules Regularly**: The provided rules are production-ready but should be reviewed based on your specific needs
3. **Enable 2FA**: For Firebase Console accounts
4. **Monitor Usage**: Set up billing alerts in Google Cloud Console
5. **Use Service Accounts**: For backend operations, use service accounts instead of user credentials

---

## Firestore Security Rules Summary

### What's Allowed:
- ✅ Unauthenticated users can read public business data
- ✅ Authenticated users can create their own profiles
- ✅ Business owners control their business data
- ✅ Customers can view their booking history
- ✅ Customers can create and cancel pending bookings
- ✅ Business owners can manage bookings (confirm, complete, cancel)
- ✅ File uploads limited by size and ownership

### What's NOT Allowed:
- ❌ Unauthenticated write access
- ❌ Cross-user data access
- ❌ Unlimited file uploads
- ❌ Modifying other users' bookings
- ❌ Direct database access without authentication

---

## Troubleshooting

### "Insufficient permissions" error
- Ensure user is authenticated
- Check Firestore rules match user's intended action
- Verify user has correct UID in data

### Rules not applying
```bash
firebase deploy --only firestore:rules
```

### Storage upload fails
- Check storage bucket name
- Verify file size limits
- Ensure user is authenticated

### Emulator connection issues
- Ensure emulator is running: `firebase emulators:start`
- Check localhost firewall settings
- Verify port availability (8080, 9099, 9199)

---

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Flutter Firebase Integration](https://firebase.flutter.dev/)
- [Firebase Best Practices](https://firebase.google.com/docs/guides/best-practices)

---

## Next Steps

1. ✅ Create Firebase Project
2. ✅ Configure Authentication (Google Sign-In)
3. ✅ Create Firestore Collections
4. ✅ Deploy Security Rules
5. ✅ Set up Storage Buckets
6. ✅ Test with Flutter app
7. ✅ Monitor and scale as needed

---

**Last Updated**: March 18, 2026
**Project**: Bookit (Slotpe)
