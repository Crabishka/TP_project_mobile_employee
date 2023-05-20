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
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );
              },
              child: Text("Отсканировать"))
        ],
      ),
    ));
  }
}
