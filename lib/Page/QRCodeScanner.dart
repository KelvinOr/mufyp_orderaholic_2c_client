import 'dart:developer';
import 'dart:ui';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';

import 'OrderPage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  Map<String, String> testOrder = {
    "OrderID": "-NKlfSEKApeYZZ6o1UwS",
    "RestaurantID": "qXvxtFo1eDfgIJgu6gkwowqdXl13"
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR code Scanner"),
        backgroundColor: PrimaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.9,
                child: MobileScanner(
                  allowDuplicates: true,
                  controller: MobileScannerController(),
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      log('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue!;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          //send data to new page
                          builder: (context) => OrderPage(
                            code: code,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      //send data to new page
                      builder: (context) => OrderPage(
                        code: jsonEncode(testOrder),
                      ),
                    ),
                  );
                },
                child: const Text("Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
