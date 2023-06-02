import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_employee/view/qr/scan_page.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Spacer(),
          Center(
            child: SizedBox(
              height: 250,
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    backgroundColor: const Color(0xFF3EB489)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanPage()),
                  );
                },
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    const Icon(Icons.qr_code_scanner, size: 150),
                    const Text(
                      "Отсканировать",
                      style: TextStyle(
                          fontFamily: 'PoiretOne',
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
