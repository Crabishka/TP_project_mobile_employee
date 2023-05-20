import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_employee/view/profile/main_profile_page.dart';
import 'package:mobile_employee/view/order_list_page.dart';
import 'package:mobile_employee/view/qr/qr_page.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }

  static changeIndex(int index) {
    AppState.selectedIndex = index;
  }
}

class AppState extends State<App> {
  static int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    OrderListPage(),
    QrPage(),
    MainProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: "Order List"),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
