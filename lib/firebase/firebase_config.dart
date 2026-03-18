/// Firebase Configuration Constants for Bookit
/// 
/// This file contains non-sensitive configuration values
/// for Firebase services across different platforms.
/// 
/// Project: slot-pe

class FirebaseConfig {
  // Project Configuration
  static const String projectId = 'slot-pe';
  static const String storageBucket = 'slot-pe.firebasestorage.app';
  static const String authDomain = 'slot-pe.firebaseapp.com';
  static const String databaseURL = 'https://slot-pe.firebaseio.com';

  // Collection Names
  static const String usersCollection = 'users';
  static const String businessesCollection = 'businesses';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';
  static const String activityLogCollection = 'activityLog';

  // Firestore Subcollections
  static const String servicesSubcollection = 'services';
  static const String timeSlotsSubcollection = 'timeSlots';
  static const String reviewsSubcollection = 'reviews';

  // Storage Buckets
  static const String businessProfilesBucket = 'businesses';
  static const String userAvatarsBucket = 'users';
  static const String tempFilesBucket = 'temp';

  // File Size Limits (in bytes)
  static const int maxBusinessLogoSize = 5 * 1024 * 1024; // 5 MB
  static const int maxUserAvatarSize = 2 * 1024 * 1024; // 2 MB
  static const int maxTempFileSize = 10 * 1024 * 1024; // 10 MB

  // Booking Status
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusConfirmed = 'confirmed';
  static const String bookingStatusCompleted = 'completed';
  static const String bookingStatusCancelled = 'cancelled';
  static const String bookingStatusNoShow = 'no-show';

  // User Types
  static const String userTypeCustomer = 'customer';
  static const String userTypeBusinessOwner = 'business_owner';
  static const String userTypeAdmin = 'admin';

  // Plan Types
  static const String planTypeFree = 'free';
  static const String planTypePro = 'pro';
  static const String planTypeEnterprise = 'enterprise';

  // Business Categories
  static const List<String> businessCategories = [
    'Hair Salon',
    'Beauty Spa',
    'Medical',
    'Fitness',
    'Consulting',
    'Education',
    'Photography',
    'Repair Services',
    'Cleaning Services',
    'Other',
  ];

  // Working Days
  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int bookingsPageSize = 10;

  // Timeouts (in seconds)
  static const int firestoreTimeout = 30;
  static const int authTimeout = 30;
  static const int storageTimeout = 60;

  // Cache Duration (in minutes)
  static const int businessCacheDuration = 60;
  static const int bookingsCacheDuration = 5;

  // Review Settings
  static const int minReviewRating = 1;
  static const int maxReviewRating = 5;
  static const int minReviewLength = 10;
  static const int maxReviewLength = 500;

  // Booking Settings
  static const int minBookingSlotDuration = 15; // minutes
  static const int maxBookingSlotDuration = 480; // 8 hours
  static const int defaultSlotDuration = 30; // minutes
  
  // Booking advance notice (in days)
  static const int maxAdvanceBookingDays = 90;
  static const int minBookingNoticeHours = 1;
}

/// Environment configuration
enum FirebaseEnvironment {
  development,
  staging,
  production,
}

extension EnvironmentExtension on FirebaseEnvironment {
  String get name {
    switch (this) {
      case FirebaseEnvironment.development:
        return 'development';
      case FirebaseEnvironment.staging:
        return 'staging';
      case FirebaseEnvironment.production:
        return 'production';
    }
  }

  bool get isProduction => this == FirebaseEnvironment.production;
  bool get isDevelopment => this == FirebaseEnvironment.development;
  bool get isStaging => this == FirebaseEnvironment.staging;
}
