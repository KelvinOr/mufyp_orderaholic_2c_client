import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Page/TabbedPage.dart';
import '../Function/FirebaseAuth.dart';
import '../Page/LoginPage.dart';

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CheckLoginState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return TabbedPage();
          } else {
            return LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
