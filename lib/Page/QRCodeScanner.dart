import 'dart:developer';
import 'OrderPage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String _result = "No result";

  @override
  Widget build(BuildContext context) {
    String _result = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("result"),
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
