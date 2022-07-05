import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/boss.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddBoss extends StatefulWidget {
  const AddBoss({Key? key}) : super(key: key);

  @override
  _AddBossState createState() => _AddBossState();
}

class _AddBossState extends State<AddBoss> {
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
      body: SingleChildScrollView(
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
                    "Ajouter un nouveau chef",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    controller: emailCotroller,
                    validator: (value) {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);
                      if (!emailValid) {
                        return "Entrer un email valide";
                      }
                      if (value.isEmpty) {
                        return "Enter un email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "email",
                        label: Text("email"),
                        prefixIcon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
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
                  TextFormField(
                    controller: passwordCotroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer un mot de passe";
                      }
                      if (value.length < 7) {
                        return "Le mot de passe doit comporter au moins 7 caractères";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "le mot de passe",
                        label: const Text("le mot de passe"),
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: isPass
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () => {setState(() => isPass = !isPass)},
                        )),
                    obscureText: isPass,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic user = await BossService().registerNewBoss(
                            emailCotroller.text,
                            passwordCotroller.text,
                            nameCotroller.text,
                            phoneController.text);
                        if (user == null) {
                          print('something went wrong');
                        } else {
                          Navigator.of(context).pop("Le patron est créé");
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
  }
}
