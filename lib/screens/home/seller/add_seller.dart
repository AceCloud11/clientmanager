import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddSeller extends StatefulWidget {
  const AddSeller({Key? key}) : super(key: key);

  @override
  _AddSellerState createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
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
                    "Add New Seller",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                        return "Enter a valid email";
                      }
                      if (value.isEmpty) {
                        return "Enter an email";
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
                        return "Enter a phone number";
                      }
                      if (value.length < 10) {
                        return "Enter a valid phone number";
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
                        prefixIcon: Icon(Icons.location_city)),
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
                  TextFormField(
                    controller: passwordCotroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a password";
                      }
                      if (value.length < 7) {
                        return "Password must be at least 7 caracters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "password",
                        label: const Text("password"),
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
                        dynamic user = await SellerService().registerNewSeller(
                            emailCotroller.text,
                            passwordCotroller.text,
                            nameCotroller.text,
                            sectorCotroller.text,
                            cityCotroller.text,
                            phoneController.text);
                        if (user == null) {
                          print('something went wrong');
                        } else {
                          Navigator.of(context).pop("The seller is created");
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
