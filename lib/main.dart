import 'package:clientmanager/services/auth.dart';
import 'package:clientmanager/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text("something went wrong"),);
            } else if (snapshot.hasData) {
              return StreamProvider.value(
                value: AuthService().user,
                initialData: null,
                child: const Wrapper(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }),
    );
    // return
  }
}
