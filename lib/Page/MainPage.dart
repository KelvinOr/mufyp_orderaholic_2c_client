import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';
import 'package:mufyp_orderaholic_2c_client/Page/LoginPage.dart';
import '../Function/FirebaseAuth.dart';
import '../Function/RecommendSystem.dart';
import 'package:mufyp_orderaholic_2c_client/Page/QRCodeScanner.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var user = FirebaseAuth.instance.currentUser;

    @override
    void initState() {
      if (user == null) {
        Navigator.pop(context);
      }

      GetRecommendTable('Monday', 'breakfast').then((value) => print(value));

      super.initState();
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: size.width * 0.1,
          right: size.width * 0.1,
          top: size.height * 0.05,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Main Item
              Expanded(
                child: Container(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommend Restaurant",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Current Order",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Test Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 40),
                  backgroundColor: SecondaryColor,
                ),
                onPressed: () {
                  SetRecommendTable(
                      'Monday', 'breakfast', ['Western Restaurant']);
                },
                child: const Text("Test set table"),
              ),
              //Bottom Item
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 40),
                  backgroundColor: SecondaryColor,
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
