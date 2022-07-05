import 'package:clientmanager/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordCotroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  bool isPass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 170),
                const Text(
                  "Welcome to Client Manger",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
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
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordCotroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a password";
                    }
                    if (value.length < 7) {
                      return "The password must atleast 7 caracters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 4, color: Colors.amber)),
                      hintText: "password",
                      label: const Text("password"),
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
                      dynamic res = await _auth.signInWithEmail(
                          _emailController.text, _passwordCotroller.text);
                    }
                  },
                  child: const Text("Sign in"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[800],
                      minimumSize: const Size.fromHeight(50)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
