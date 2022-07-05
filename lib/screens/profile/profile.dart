import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/services/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController oldPassowrdController = TextEditingController();
  TextEditingController oldPassowrdDeleteController = TextEditingController();
  String error = "";
  String errorPass = "";

  final User user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_circle_left_rounded,
              color: Colors.grey[700],
              size: 32,
            ),
          ),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.grey[400]),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
            child: Column(
              children: [
                StreamBuilder<Object>(
                    stream: db.collection('users').doc(user.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic data = snapshot.data;

                        if (data!.exists) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "General Information",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "name: ",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      data['name'],
                                      style: TextStyle(
                                        color: Colors.indigo[400],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "email: ",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      data['email'],
                                      style: TextStyle(
                                        color: Colors.indigo[400],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "phone: ",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      data['phone'],
                                      style: TextStyle(
                                        color: Colors.indigo[400],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text("Acount deleted"),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Change Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Email"),
                            hintText: "email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: oldPassController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Your Password"),
                            hintText: "password"),
                      ),
                      error.isEmpty
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red[300], fontSize: 12),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // print(email);
                          dynamic res = await SellerService().updateEmail(
                              emailController.text, oldPassController.text);
                          print(res);
                          if (res == "success") {
                            Fluttertoast.showToast(
                                msg: "Email changed",
                                backgroundColor: Colors.green);
                            emailController.text = "";
                            oldPassController.text = "";
                          } else {
                            setState(() {
                              error = res;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text("Change Email"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isHidden,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("New Password"),
                          hintText: "new password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: isHidden
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: oldPassowrdController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Your Password"),
                            hintText: "password"),
                      ),
                      error.isEmpty
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                errorPass,
                                style: TextStyle(
                                    color: Colors.red[300], fontSize: 12),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          dynamic res = await SellerService().updatePassword(
                              passwordController.text,
                              oldPassowrdController.text);

                          if (res != null) {
                            Fluttertoast.showToast(
                                msg: "password changed",
                                backgroundColor: Colors.green);
                            passwordController.text = "";
                            oldPassowrdController.text = "";
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text("Change Password"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Delete Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: oldPassowrdDeleteController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Your Password"),
                            hintText: "password"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          dynamic res = await SellerService()
                              .deleteAccount(oldPassowrdDeleteController.text);
                          if (res == 'success') {
                            Navigator.of(context).pop();
                            AuthService().logout();
                          }
                          // print(res);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text("Delete Account"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
