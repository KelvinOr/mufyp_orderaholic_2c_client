import 'dart:developer';
import 'package:flutter/material.dart';
import '../Config//Theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Orderaholic",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Verdana",
                    color: SecondaryColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05, top: 10),
              child: Container(
                height: size.height * 0.65,
                decoration: BoxDecoration(
                  color: SecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: PrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
