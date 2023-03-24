import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_login_project/viewModel/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import '../custom_component/custom_button.dart';
import 'authcheck_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationVM>(builder: (context, authVM, _) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("home screen"),
                  const SizedBox(
                    height: 20,
                  ),
                  (!AmityCoreClient.isUserLoggedIn())
                      ? const CircularProgressIndicator()
                      : Text(
                          "user:${AmityCoreClient.getCurrentUser().displayName}"),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    label: 'Signout',
                    radius: 12,
                    borderColor: Colors.black,
                    onTap: () async {
                      await authVM.signOut((isSuccess, error) {
                        if (isSuccess) {
                          print("success");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthCheckView()),
                          );
                        } else {
                          print("fail");
                          AlertDialog(
                              content: Text(error ?? "no error message"));
                        }
                      });
                    },
                    color: Theme.of(context).scaffoldBackgroundColor,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
