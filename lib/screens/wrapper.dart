// import 'package:clientmanager/models/user.dart';
import 'package:clientmanager/screens/auth/authenticate.dart';
import 'package:clientmanager/screens/home/admin/home.dart';
import 'package:clientmanager/screens/home/boss/boss_home.dart';
import 'package:clientmanager/screens/home/boss/boss_screen.dart';
import 'package:clientmanager/screens/home/seller/home.dart';
import 'package:clientmanager/screens/home/seller/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic doc = snapshot.data;
              if (doc.get('role') == 'admin') {
                return AdminHome();
              } else if (doc.get('role') == 'seller') {
                return Home();
              } else {
                return BossHome();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          });
    }
  }
}
