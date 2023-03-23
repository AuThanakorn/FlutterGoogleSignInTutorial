import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_login_project/view/authcheck_view.dart';
import 'package:google_login_project/view/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_login_project/viewModel/authentication_viewmodel.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// void createUserToken(String _userId, String _displayname, String _secureToken) {
//   AmityUserTokenManager(
//           apiKey: "your api key", endpoint: AmityRegionalHttpEndpoint.SG)
//       //displayname and secureToken are optional
//       .createUserToken(_userId, displayname: _displayname)
//       .then((AmityUserToken token) {
//     log("accessToken = ${token.accessToken}");
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationVM>(
          create: (context) => AuthenticationVM(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthCheckView(),
      ),
    );
  }
}
