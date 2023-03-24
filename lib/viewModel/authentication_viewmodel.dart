import 'package:amity_sdk/amity_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationVM extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAuthentication? _googleAuth;
  GoogleSignInAccount? _googleSignInAccount;
  bool isLoading = false;
  AmityUser? _currentUser;

  void setupAmityUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
      String currentUserDisplayname =
          FirebaseAuth.instance.currentUser!.displayName!;
      registerDevice(
        userId: currentUserEmail,
        displayName: currentUserDisplayname,
        callback: (isSuccess, error) {
          if (isSuccess) {
            notifyListeners();
          }
        },
      );
    }
  }

  GoogleSignInAuthentication? getGoogleAuth() {
    return _googleAuth;
  }

  GoogleSignInAccount? getGoogleSignInAccount() {
    return _googleSignInAccount;
  }

  Future googleSignIn(Function(bool isSuccess, String? error) callback) async {
    await _performgoogleSignIn((isSuccess, error) async {
      if (isSuccess) {
        print("success");
        await registerDevice(
            userId: _googleSignIn.currentUser!.email,
            displayName: _googleSignIn.currentUser!.displayName!,
            callback: (isSuccess, error) {
              if (isSuccess) {
                print("loging success");
                _currentUser = AmityCoreClient.getCurrentUser();
                notifyListeners();
                print(_currentUser!.displayName);
                callback(true, null);
              } else {
                callback(false, error);
              }
            });
      } else {
        callback(false, error);
      }
    });
  }

  Future<void> signOut(Function(bool isSuccess, String? error) callback) async {
    await _performGooglesignOut((isSuccess, error) async {
      if (isSuccess) {
        await AmityCoreClient.logout().then((_) {
          _currentUser == null;
          notifyListeners();
          callback(true, null);
        }).catchError((error, stackTrace) {
          callback(false, error.toString());
        });
      } else {
        callback(false, error);
      }
    });
  }

  Future<void> _performgoogleSignIn(
      Function(bool isSuccess, String? error) callback) async {
    isLoading = true;
    notifyListeners();
    try {
      _googleSignInAccount = await _googleSignIn.signIn();

      if (_googleSignInAccount != null) {
        // Retrieve the GoogleSignInAuthentication for the signed-in user
        _googleAuth = await _googleSignInAccount!.authentication;

        // Create a new credential for Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth!.accessToken,
          idToken: _googleAuth!.idToken,
        );
        // Sign in with Firebase using the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to the HomeScreen after successful sign-in
        notifyListeners();
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

  Future<void> _performGooglesignOut(
      Function(bool isSuccess, String? error) callback) async {
    try {
      await _googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
      _googleAuth = null;
      notifyListeners();
      callback(true, null);
    } on FirebaseAuthException catch (error) {
      print(error);
      callback(false, error.toString());
    } catch (error) {
      print(error);
      callback(false, error.toString());
    }
  }

  Future<void> registerDevice({
    required String userId,
    required String displayName,
    String? authToken,
    required Function(bool isSuccess, String? error) callback,
  }) async {
    if (authToken == null) {
      await AmityCoreClient.login(userId)
          .displayName(displayName)
          .submit()
          .then((user) {
        callback(true, null);
      }).catchError((error, stackTrace) {
        callback(false, error.toString());
      });
    } else {
      await AmityCoreClient.login(userId)
          .displayName(displayName)
          .authToken(authToken)
          .submit()
          .then((user) {
        callback(true, null);
      }).catchError((error, stackTrace) {
        callback(false, error);
      });
    }
  }
}
