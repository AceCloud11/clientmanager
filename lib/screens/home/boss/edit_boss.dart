import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/boss.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditBoss extends StatefulWidget {
  const EditBoss({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _EditBossState createState() => _EditBossState();
}

class _EditBossState extends State<EditBoss> {
  final nameCotroller = TextEditingController();
  final emailCotroller = TextEditingController();
  final passwordCotroller = TextEditingController();
  final cityCotroller = TextEditingController();
  final sectorCotroller = TextEditingController();
  final phoneController = TextEditingController();

  bool isPass = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<Object>(
          future: FirebaseFirestore.instance
              .collection('bosses')
              .doc(widget.id)
              .get()
              .then((value) => {
                    nameCotroller.text = value.get('name'),
                    phoneController.text = value.get('phone'),
                  }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 17, right: 17, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Text(
                            "Modifier chef",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameCotroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Entrez un nom";
                              }
                              if (value.length < 3) {
                                return "Entrez un nom d'au moins 3 caractères";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "nom",
                              label: Text("nom"),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Entrer un numéro de téléphone";
                              }
                              if (value.length < 10) {
                                return "Entrez un numéro de téléphone valide";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "numéro de téléphone",
                                label: Text("numéro de téléphone"),
                                prefixIcon: Icon(Icons.phone)),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic user = await BossService()
                                    .registerNewBoss(
                                        emailCotroller.text,
                                        passwordCotroller.text,
                                        nameCotroller.text,
                                        phoneController.text);
                                if (user == null) {
                                  print('something went wrong');
                                } else {
                                  Navigator.of(context)
                                      .pop("Le patron est créé");
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
          }),
    );
  }
}
