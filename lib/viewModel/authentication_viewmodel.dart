import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationVM extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;
  Future<void> googleSignIn(
      Function(bool isSuccess, String? error) callback) async {
    isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Retrieve the GoogleSignInAuthentication for the signed-in user
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // Create a new credential for Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign in with Firebase using the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to the HomeScreen after successful sign-in
        callback(true, null);
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      callback(false, error.toString());
    } catch (error) {
      print(error);
      callback(false, error.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> checkIfUserSignIned(
      Function(bool isLoggedIn, String? error) callback) async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
          callback(false, null);
        } else {
          print('User is signed in!');
          callback(true, null);
        }
      });
    } on FirebaseAuthException catch (error) {
      print(error);
      callback(false, error.toString());
    } catch (error) {
      print(error);
      callback(false, error.toString());
    }
  }

  Future<void> signOut(Function(bool isSuccess, String? error) callback) async {
    try {
      await _googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
      callback(true, null);
    } on FirebaseAuthException catch (error) {
      print(error);
      callback(false, error.toString());
    } catch (error) {
      print(error);
      callback(false, error.toString());
    }
  }
}
