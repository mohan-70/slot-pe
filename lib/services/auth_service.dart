import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as gis;
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String _webClientId = '440294729258-9960n1mgber0odntftv141os55e46ito.apps.googleusercontent.com';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _webClientId : null,
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Use GIS for web
        return await _signInWithGoogleWeb();
      } else {
        // Non-web flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null; // User cancelled
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        return userCredential;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> _signInWithGoogleWeb() async {
    try {
      final tokenResponse = await gis.initialize(_webClientId, null);
      final googleUser = await gis.select_account(tokenResponse);
      final credential = GoogleAuthProvider.credential(
        accessToken: googleUser.access_token,
        idToken: googleUser.id_token,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      if (kIsWeb) {
        // GIS sign out
        await gis.dispose();
      }
    } catch (e) {
      // Error signing out
    }
  }

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
