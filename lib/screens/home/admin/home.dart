import 'package:clientmanager/screens/home/boss/boss_screen.dart';
import 'package:clientmanager/screens/home/client/client_screen.dart';
import 'package:clientmanager/screens/home/main_screen.dart';
import 'package:clientmanager/screens/home/map_screen.dart';
import 'package:clientmanager/screens/home/seller/seller_screen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = const [
    MainScreen(),
    ClientScreen(),
    SellerScreen(),
    BossScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop_2_sharp), label: "Clients"),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_sharp), label: "Sellers"),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined), label: "Boss"),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
