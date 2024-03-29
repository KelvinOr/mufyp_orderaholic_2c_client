import 'dart:developer';
import 'package:flutter/material.dart';
import '../Config/Theme.dart';
import './LoginPage.dart';
import '../Function/FirebaseAuth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    void _register() async {
      if (_passwordController.text == _confirmPasswordController.text) {
        var result = await RegisterWithEmail(
            _emailController.text, _passwordController.text);
        switch (result) {
          case "Success":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            break;
          case "Failed":
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Register Failed"),
                      content: Text("Unknow error, please try again later"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"))
                      ],
                    ));
            break;
          case "weak-password":
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Register Failed"),
                      content: Text("Password is too weak"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"))
                      ],
                    ));
            break;
          case "email-already-in-use":
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Register Failed"),
                      content: Text("Email already in use"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"))
                      ],
                    ));
            break;
          default:
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Register Failed"),
                      content: Text("Unknow error, please try again later"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"))
                      ],
                    ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content:
                      Text("Password and Confirm Password are not the same"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ],
                ));
      }
    }

    void _returnTologin() async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    return Scaffold(
      body: SingleChildScrollView(
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
                    left: size.width * 0.1, right: size.width * 0.1, top: 10),
                child: Container(
                  height: size.height * 0.65,
                  decoration: BoxDecoration(
                    color: SecondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Verdana",
                            color: PrimaryColor,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        TextField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: PrimaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: PrimaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(
                              color: PrimaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: _register,
                          child: const Text("Register"),
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(size.width * 0.5, size.height * 0.04),
                            backgroundColor: PrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _returnTologin,
                          child: const Text("Go To Login"),
                          style: ElevatedButton.styleFrom(
                            //width fix to padding
                            minimumSize:
                                Size(size.width * 0.5, size.height * 0.04),
                            backgroundColor: PrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
