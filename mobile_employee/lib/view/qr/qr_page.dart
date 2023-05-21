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
          SizedBox(
            height: 80,
            width: 300,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanPage()),
                );
              },
              child: const Center(
                  child: Text(
                "Отсканировать",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold),
              )),
            ),
          )
        ],
      ),
    ));
  }
}
