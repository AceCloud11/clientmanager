import 'package:clientmanager/screens/home/client/client_screen.dart';
import 'package:clientmanager/screens/home/main_screen.dart';
import 'package:clientmanager/screens/home/map_screen.dart';
import 'package:clientmanager/screens/home/seller/client_screen.dart';
import 'package:clientmanager/screens/home/seller/seller_screen.dart';
import 'package:flutter/material.dart';

class BossHome extends StatefulWidget {
  const BossHome({Key? key}) : super(key: key);

  @override
  State<BossHome> createState() => _BossHomeState();
}

class _BossHomeState extends State<BossHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = const [MainScreen(), SellerScreen(), ClientScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user), label: "sellers"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop_2_sharp), label: "clients"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
