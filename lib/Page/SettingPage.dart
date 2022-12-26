import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';
import './MyLicensePage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  var accountInfo = {
    "email": "",
    "uid": "",
  };

  @override
  void initState() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      accountInfo["email"] = user.email.toString();
      accountInfo["uid"] = user.uid.toString();
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.1,
            right: size.width * 0.1,
            top: size.height * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account Info",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Email: " + accountInfo["email"].toString(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 1, size.height * 0.05),
                backgroundColor: SecondaryColor,
              ),
              child: const Text("License"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //to License Page
                    builder: (context) => const MyLicensePage(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 1, size.height * 0.05),
                backgroundColor: SecondaryColor,
              ),
              child: const Text("Logout"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
