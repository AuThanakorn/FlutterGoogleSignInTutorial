import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_login_project/view/authcheck_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_login_project/viewModel/authentication_viewmodel.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AmityCoreClient.setup(
      option: AmityCoreClientOption(
          apiKey: "b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f",
          httpEndpoint: AmityRegionalHttpEndpoint.SG),
      sycInitialization: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationVM>(
          create: (context) => AuthenticationVM(),
        ),
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
