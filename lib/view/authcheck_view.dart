import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_login_project/view/home_view.dart';

import 'login_view.dart';

class AuthCheckView extends StatelessWidget {
  const AuthCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("waiting");
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print("hasData");
          return const HomeView();
        } else if (snapshot.hasError) {
          print("hasError");
          return const Center(child: Text("Something went wrong"));
        } else {
          print("login");
          return LoginView();
        }
      },
    );
  }
}
