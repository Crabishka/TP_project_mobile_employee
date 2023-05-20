import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'order_info.dart';

class ScanPage extends StatefulWidget {
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? barcode;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildQrView(context),
              Positioned(bottom: 10, child: buildResult())
            ],
          ),
        ));
  }

  buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((event) {
      setState(() {
        barcode = event;
      });
    });
  }

  Widget buildResult() {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Text(barcode != null
                ? "Номер заказа ${barcode!.code}"
                : "Отсканируете заказ клиента")),
        if (barcode != null)
          ElevatedButton(
              onPressed: () {
                String number = barcode!.code!;
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderInfo(code: number)),
                );
              },
              child: Text("Перейти"))
      ],
    );
  }
}
