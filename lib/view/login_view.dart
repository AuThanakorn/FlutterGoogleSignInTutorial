import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_login_project/view/home_view.dart';
import 'package:google_login_project/viewModel/authentication_viewmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../custom_component/custom_button.dart';
import '../custom_component/custom_entry_field.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Consumer<AuthenticationVM>(builder: (context, vm, _) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16.0),
            child: vm.isLoading
                ? Column(
                    children: [
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ))
                    ],
                  )
                : Column(
                    children: [
                      Spacer(),
                      Text("Continue with",
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 14)),
                      SizedBox(height: 32),
                      CustomButton(
                        label: 'Sign in with Google',
                        radius: 12,
                        borderColor: Colors.black,
                        onTap: () async {
                          await vm.googleSignIn((isSuccess, error) {
                            if (isSuccess) {
                              print("success");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()),
                              );
                            } else {
                              print("fail");
                              AlertDialog(
                                  content: Text(error ?? "no error message"));
                            }
                          });
                        },
                        icon: Image.asset('assets/Icons/ic_login_google.png',
                            scale: 3),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        textColor: Colors.black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
