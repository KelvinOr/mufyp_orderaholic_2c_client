import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';

class MyLicensePage extends StatelessWidget {
  const MyLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.1,
            right: size.width * 0.1,
            top: size.height * 0.05,
          ),
          child: Column(
            children: [
              Text(
                "License",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Power by Flutter",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "https://github.com/flutter/flutter",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Power by Firebase",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "https://pub.dev/packages/firebase_core",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "https://pub.dev/packages/firebase_auth",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "https://pub.dev/packages/cloud_firestore",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Power by Mobile Scanner",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "https://pub.dev/packages/mobile_scanner",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "End",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
