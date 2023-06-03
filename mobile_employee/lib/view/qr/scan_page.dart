import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'order/order_info.dart';

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
          backgroundColor: const Color(0xFF3EB489),
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
            decoration: BoxDecoration(
                color: Color(0xFFb43e69),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  barcode != null
                      ? " Номер заказа ${barcode!.code} "
                      : " Отсканируете заказ клиента ",
                  style: const TextStyle(

                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            )),
        const SizedBox(
          height: 8,
        ),
        if (barcode != null)
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderInfo(code: barcode!.code!)),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF3EB489),
                    borderRadius: BorderRadius.circular(4)),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(" Перейти ",
                      style: TextStyle(

                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                )),
          )
      ],
    );
  }
}
