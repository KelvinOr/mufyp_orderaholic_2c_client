import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Page/LoginPage.dart';
import '../Function/FirebaseAuth.dart';
import 'package:mufyp_orderaholic_2c_client/Page/QRCodeScanner.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            user != null ? user.email.toString() : "",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            user != null ? user.uid.toString() : "",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
            onPressed: () {
              Logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text("Logout"),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRCodeScanner(),
                ),
              );
            },
            child: const Text("Scan QR Code"),
          ),
        ],
      ),
    );
  }
}
