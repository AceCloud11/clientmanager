import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // TODO sign in
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // print(credential.user);
      return credential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // auth changes user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // register new user
  Future registerNewSeller(String email, String password, String name,
      String sector, String city, String phone) async {
    try {
      // FirebaseApp app = await Firebase.initializeApp(
      //     name: 'Secondary', options: Firebase.app().options);
      await Firebase.initializeApp(
          name: 'secondary', options: Firebase.app().options);
      FirebaseApp app = Firebase.app("secondary");

      UserCredential credential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      credential.user!.updateDisplayName(name);

      usersCollection.doc(credential.user!.uid).set({
        "name": name,
        "city": city,
        "sector": sector,
        "role": "seller",
        "phone": phone,
        "email": credential.user!.email,
      });
      // print(credential.user!.uid);
      final users = usersCollection.snapshots();
      // print(credential);

      // await app.delete();
      // final newuser = await FirebaseAuth.instance.currentUser;
      // print(newuser!.email);
      return Future.sync(() => credential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // update seller info
  Future updateSellerInfo(
      String id, String name, String sector, String city, String phone) async {
    try {
      final user = await usersCollection
          .doc(id)
          .set({"name": name, "city": city, "sector": sector, "phone": phone});

      return "updated";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // logout
  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
