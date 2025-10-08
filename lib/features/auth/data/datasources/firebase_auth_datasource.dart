import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  // ✅ Common: save user to Firestore
  Future<void> _saveUserToFirestore(User user) async {
    final doc = _firestore.collection("users").doc(user.uid);

    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'photoUrl': user.photoURL ?? '',
        'addresses': [],
        'wishlist': [],
        'isBlocked': false,
        'createdAt': FieldValue.serverTimestamp(), // <-- bu muhim
      });
    }
  }

  // EMAIL
  Future<User?> signInWithEmail(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = res.user;
    if (user != null) await _saveUserToFirestore(user);
    return user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = res.user;
    if (user != null) await _saveUserToFirestore(user);
    return user;
  }

  // GOOGLE
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final res = await _auth.signInWithCredential(credential);
    final user = res.user;
    if (user != null) await _saveUserToFirestore(user);
    return user;
  }

  // FACEBOOK
  Future<User?> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.accessToken == null) return null;

    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );

    final res = await _auth.signInWithCredential(credential);
    final user = res.user;
    if (user != null) await _saveUserToFirestore(user);
    return user;
  }

  // APPLE
  Future<User?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final res = await _auth.signInWithCredential(oauthCredential);
    final user = res.user;
    if (user != null) await _saveUserToFirestore(user);
    return user;
  }

  Future<void> signOut() async {
    try {
      // 🔹 Firebase sign out
      await _auth.signOut();

      // 🔹 Google sign out
      await GoogleSignIn().signOut();

      // 🔹 Optional: completely disconnect the Google account
      await GoogleSignIn().disconnect();

      // 🔹 Facebook sign out
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Sign out error: $e");
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
