import 'dart:developer';
import 'dart:ui';
import 'dart:io';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'OrderPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  Map<String, String> testOrder = {
    "OrderID": "-NN_DjQwqPdP2hYwiHoJ",
    "RestaurantID": "qXvxtFo1eDfgIJgu6gkwowqdXl13"
  };

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

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
                //   child: MobileScanner(
                //     allowDuplicates: true,
                //     controller: MobileScannerController(),
                //     onDetect: (barcode, args) {
                //       if (barcode.rawValue == null) {
                //         log('Failed to scan Barcode');
                //       } else {
                //         final String code = barcode.rawValue!;
                //         Navigator.pushReplacement(
                //           context,
                //           MaterialPageRoute(
                //             //send data to new page
                //             builder: (context) => OrderPage(
                //               code: code,
                //             ),
                //           ),
                //         );
                //       }
                //     },
                //   ),
                // ),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
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

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((result) {
      _controller!.stopCamera();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          //send data to new page
          builder: (context) => OrderPage(
            code: jsonEncode(result.code.toString()),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
