import 'dart:developer';

import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSeller extends StatefulWidget {
  const EditSeller({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _EditSellerState createState() => _EditSellerState();
}

class _EditSellerState extends State<EditSeller> {
  final nameCotroller = TextEditingController();
  final emailCotroller = TextEditingController();
  final passwordCotroller = TextEditingController();
  final cityCotroller = TextEditingController();
  final sectorCotroller = TextEditingController();
  final phoneController = TextEditingController();
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
                  cityCotroller.text = value.get('city'),
                  sectorCotroller.text = value.get('sector'),
                  nameCotroller.text = value.get('name'),
                  emailCotroller.text = user.email,
                  phoneController.text = value.get('phone')
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
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 50, left: 17, right: 17),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Text(
                            "Add New Seller",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameCotroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a name";
                              }
                              if (value.length < 3) {
                                return "Enter a name the atleast 3 caracters";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "name",
                                label: Text("name"),
                                prefixIcon: Icon(Icons.person)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a phone number";
                              }
                              if (value.length < 10) {
                                return "Enter a valid phone numver";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "phone number",
                                label: Text("phone number"),
                                prefixIcon: Icon(Icons.phone)),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: cityCotroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a city";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "city",
                              label: Text("city"),
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: sectorCotroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a sector";
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "sector",
                              label: Text("sector"),
                              prefixIcon: Icon(Icons.map),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic res = await SellerService()
                                    .updateSellerInfo(
                                        widget.id,
                                        nameCotroller.text,
                                        sectorCotroller.text,
                                        cityCotroller.text,
                                        phoneController.text);

                                if (res != null) {
                                  Navigator.of(context)
                                      .pop("The seller is updated");
                                } else {
                                  print(res);
                                }
                              }
                            },
                            child: const Text("Save"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo[800],
                                minimumSize: const Size.fromHeight(50)),
                          ),
                        ],
                      )),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
        });
  }
}
