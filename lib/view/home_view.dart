import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  Widget build(BuildContext context) {
    return Consumer<AuthenticationVM>(builder: (context, vm, _) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("home screen"),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    label: 'Signout',
                    radius: 12,
                    borderColor: Colors.black,
                    onTap: () async {
                      await vm.signOut((isSuccess, error) {
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
