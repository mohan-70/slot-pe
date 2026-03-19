// Firebase options with production web config from Firebase Console.
// Updated automatically with provided config.

// ignore_for_file: avoid_unused_constructor_parameters

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase/firebase_config.dart';

/// Default Firebase options for this project.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Android
    return android;
    // iOS: return ios;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtE79QHqXCOJOA6v9SaUEdGY0xUOvhGw4',
    appId: '1:440294729258:web:99c0f672391776145f8553',
    messagingSenderId: '440294729258',
    projectId: FirebaseConfig.projectId,
    authDomain: FirebaseConfig.authDomain,
    storageBucket: FirebaseConfig.storageBucket,
    measurementId: 'G-KK0MGRMEBX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '1:440294729258:android:YOUR_ANDROID_APP_ID', // Fill from google-services.json if needed
    messagingSenderId: '440294729258',
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:440294729258:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '440294729258',
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
    iosBundleId: 'com.slotpe.slotpe',
  );
}

