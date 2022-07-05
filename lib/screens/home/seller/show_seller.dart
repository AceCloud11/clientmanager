import 'dart:developer';

import 'package:clientmanager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowSeller extends StatefulWidget {
  const ShowSeller({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _ShowSellerState createState() => _ShowSellerState();
}

class _ShowSellerState extends State<ShowSeller> {
  String name = "";
  String email = "";
  String city = "";
  String sector = "";
  String count = "";
  String phone = "";
  bool isPass = true;

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    dynamic user = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
        future: db
            .collection("sellers")
            .doc(widget.id)
            .snapshots()
            .first
            .then((value) => {
                  city = value.get('city').toString(),
                  sector = value.get('sector'),
                  name = value.get('name'),
                  email = value.get('email'),
                  phone = value.get('phone')
                }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;

            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_circle_left_rounded,
                      color: Colors.grey[700],
                      size: 32,
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    "Details",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'city :',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(city),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'email :',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(email),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'phone :',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(phone),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'sector :',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Text(sector),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
        });
  }
}
