import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default Firebase options for each platform.
/// 
/// Project: slot-pe
/// These credentials are configured for production use.
class DefaultFirebaseOptions {
  /// Android Firebase Options
  /// 
  /// Configured from google-services.json
  /// Package: com.slotpe.slotpe
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQYaLrzxOCFCO7fY6ngHxKH1XTuXtUpQY',
    appId: '1:440294729258:android:3a0e28dd33cfd5c95f8553',
    messagingSenderId: '440294729258',
    projectId: 'slot-pe',
    storageBucket: 'slot-pe.firebasestorage.app',
    databaseURL: 'https://slot-pe.firebaseio.com',
  );

  /// iOS Firebase Options
  /// 
  /// Get credentials from GoogleService-Info.plist:
  /// ios/Runner/GoogleService-Info.plist ✓ Configured
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDm2GL81MJEAWg0VRGVi8nqYeoxPXp6Xu0',
    appId: '1:440294729258:ios:1b9436a56bac33445f8553',
    messagingSenderId: '440294729258',
    projectId: 'slot-pe',
    storageBucket: 'slot-pe.firebasestorage.app',
    databaseURL: 'https://slot-pe.firebaseio.com',
    iosBundleId: 'com.slotpe.slotpe',
  );

  /// Web Firebase Options
  /// 
  /// Get credentials from Firebase Console → Project Settings
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtE79QHqXCOJOA6v9SaUEdGY0xUOvhGw4',
    appId: '1:440294729258:web:99c0f672391776145f8553',
    messagingSenderId: '440294729258',
    projectId: 'slot-pe',
    storageBucket: 'slot-pe.firebasestorage.app',
    authDomain: 'slot-pe.firebaseapp.com',
    databaseURL: 'https://slot-pe.firebaseio.com',
  );

  /// Platform-specific Firebase options
  /// 
  /// Automatically selects the correct configuration based on the platform
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else if (Platform.isWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }
}
