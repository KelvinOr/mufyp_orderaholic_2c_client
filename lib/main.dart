import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Page/RegisterPage.dart';
import 'Config/Theme.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColor,
        scaffoldBackgroundColor: PrimaryColor,
      ),
      home: const Scaffold(
        body: Center(
          child: RegisterPage(),
        ),
      ),
    );
  }
}
