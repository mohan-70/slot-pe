// Production Firebase Security Rules for Bookit
// Last Updated: March 18, 2026
// 
// DEPLOYMENT INSTRUCTIONS:
// 1. Update .firebaserc with your project ID
// 2. Run: firebase deploy --only firestore:rules,storage

// ============================================================================
// FIRESTORE SECURITY RULES
// ============================================================================
// 
// Location: firestore.rules
// 
// Key Security Features:
// - User authentication required for writes
// - Business owners can only modify their own businesses
// - Customers can only view/manage their own bookings
// - Public read access to business info and reviews
// - Comprehensive access control rules
// - Field validation on writes
//
// Collection Structure:
// /users/{userId} - User profiles
// /businesses/{businessId} - Business information
//   /services/{serviceId} - Services offered
//   /timeSlots/{date} - Available time slots
//   /reviews/{reviewId} - Customer reviews
// /bookings/{bookingId} - Booking records
// /activityLog/{logId} - Audit logs

// ============================================================================
// STORAGE SECURITY RULES
// ============================================================================
//
// Location: storage.rules
//
// Paths:
// /businesses/{businessId}/* - Business logos/images (5MB limit)
// /users/{userId}/* - User avatars (2MB limit)
// /temp/* - Temporary files (10MB limit)

// ============================================================================
// FIRESTORE INDEXES
// ============================================================================
//
// Location: firestore.indexes.json
//
// Indexes created for efficient querying:
// - Bookings by businessId + date
// - Bookings by businessId + date + timeSlot
// - Bookings by customerId + createdAt
// - Businesses by ownerId
// - Businesses by bookingSlug

// ============================================================================
// SETUP CHECKLIST
// ============================================================================

// [ ] 1. Create Firebase Project
//    - Go to https://console.firebase.google.com
//    - Click "Add Project"
//    - Enter project name: slotpe-booking
//    - Select region and create

// [ ] 2. Enable Firebase Services
//    [ ] Authentication (Google Sign-In)
//    [ ] Firestore Database
//    [ ] Cloud Storage
//    [ ] Cloud Functions (optional)

// [ ] 3. Configure Project Settings
//    [ ] Update firebase.json with correct project ID
//    [ ] Update .firebaserc with project ID
//    [ ] Update firebase_options.dart with API keys

// [ ] 4. Get Configuration Files
//    [ ] Download google-services.json → android/app/
//    [ ] Download GoogleService-Info.plist → ios/Runner/
//    [ ] Copy web config to firebase_options.dart

// [ ] 5. Configure Android
//    [ ] Add google-services plugin to android/build.gradle
//    [ ] Add apply plugin to android/app/build.gradle

// [ ] 6. Configure iOS
//    [ ] Run "cd ios && pod install --repo-update && cd .."
//    [ ] Verify GoogleService-Info.plist is added to project

// [ ] 7. Deploy Rules and Indexes
//    [ ] Run: firebase deploy --only firestore:rules,firestore:indexes,storage
//    [ ] Verify in Firebase Console

// [ ] 8. Test Authorization
//    [ ] Test business owner operations
//    [ ] Test customer bookings
//    [ ] Test public read access
//    [ ] Review rule logs on Firebase Console

// [ ] 9. Set Up Monitoring
//    [ ] Enable billing alerts in Google Cloud Console
//    [ ] Configure Firestore usage alerts
//    [ ] Set up Cloud Logging

// [ ] 10. Production Deployment
//    [ ] Run full deployment: firebase deploy
//    [ ] Verify all services operational
//    [ ] Monitor error logs

// ============================================================================
// COMMON FIRESTORE QUERIES (Examples)
// ============================================================================

/*
// Get all businesses by owner
db.collection('businesses')
  .where('ownerId', '==', userId)

// Get bookings for a date
db.collection('bookings')
  .where('businessId', '==', businessId)
  .where('date', '==', dateString)
  .orderBy('timeSlot')

// Get upcoming bookings
db.collection('bookings')
  .where('businessId', '==', businessId)
  .where('date', '>=', todayDateString)
  .orderBy('date')
  .orderBy('timeSlot')

// Get services for a business
db.collection('businesses')
  .doc(businessId)
  .collection('services')
  .where('isActive', '==', true)

// Get reviews for a business
db.collection('businesses')
  .doc(businessId)
  .collection('reviews')
  .orderBy('createdAt', descending: true)
*/

// ============================================================================
// ENVIRONMENT VARIABLES (Create .env file)
// ============================================================================

/*
FIREBASE_PROJECT_ID=slotpe-booking
FIREBASE_API_KEY=YOUR_API_KEY
FIREBASE_AUTH_DOMAIN=slotpe-booking.firebaseapp.com
FIREBASE_DATABASE_URL=https://slotpe-booking.firebaseio.com
FIREBASE_STORAGE_BUCKET=slotpe-booking.appspot.com
FIREBASE_MESSAGING_SENDER_ID=YOUR_MESSAGING_SENDER_ID
FIREBASE_APP_ID=YOUR_APP_ID

# Android Specific
ANDROID_GOOGLE_SERVICES_PATH=android/app/google-services.json

# iOS Specific
IOS_GOOGLE_SERVICE_INFO_PATH=ios/Runner/GoogleService-Info.plist
*/

// ============================================================================
// DEPLOYMENT COMMANDS
// ============================================================================

/*
# Initialize Firebase (first time)
firebase init

# Login to Firebase
firebase login

# Deploy rules
firebase deploy --only firestore:rules

# Deploy indexes
firebase deploy --only firestore:indexes

# Deploy storage rules
firebase deploy --only storage

# Deploy everything
firebase deploy

# View deployment history
firebase deploy:list

# Rollback (use with caution)
firebase deploy:rollback

# Test rules locally (requires emulator)
firebase emulators:start

# View logs
firebase functions:log
*/

// ============================================================================
// TROUBLESHOOTING
// ============================================================================

/*
Issue: "Insufficient permissions" error
Solution:
- Verify user is authenticated
- Check Firestore rules allow the operation
- Ensure user credentials are correct
- Check UID matches in data

Issue: Rules not updating
Solution:
- Run: firebase deploy --only firestore:rules
- Wait for deployment to complete
- Refresh app and retry
- Check Firebase Console for rule details

Issue: Queries too slow
Solution:
- Firestore will suggest indexes
- Accept and deploy suggested indexes
- Check Firestore charges for large queries
- Consider pagination for large datasets

Issue: Storage upload fails
Solution:
- Check storage bucket name
- Verify file size limits
- Ensure user is authenticated
- Check storage.rules permissions
*/

// ============================================================================
// REFERENCES
// ============================================================================

// Firebase Documentation: https://firebase.google.com/docs
// Flutter Firebase: https://firebase.flutter.dev/
// Firestore Security Rules: https://firebase.google.com/docs/firestore/security/start
// Storage Security Rules: https://firebase.google.com/docs/storage/security
// Firebase CLI: https://firebase.google.com/docs/cli
