import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_login_project/view/home_view.dart';
import 'package:google_login_project/viewModel/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import 'login_view.dart';

class AuthCheckView extends StatefulWidget {
  const AuthCheckView({super.key});

  @override
  State<AuthCheckView> createState() => _AuthCheckViewState();
}

class _AuthCheckViewState extends State<AuthCheckView> {
  @override
  void initState() {
    Provider.of<AuthenticationVM>(context, listen: false).setupAmityUser();
    super.initState();
  }

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
