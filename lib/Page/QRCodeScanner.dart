import 'dart:developer';
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
  String _result = "No result";

  Map<String, String> testOrder = {
    "OrderID": "-NGPWWyGHFBDmB-reqs2",
    "RestaurantID": "qXvxtFo1eDfgIJgu6gkwowqdXl13"
  };

  @override
  Widget build(BuildContext context) {
    String _result = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("result"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MobileScanner(
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
    );
  }
}
