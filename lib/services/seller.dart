import 'package:clientmanager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SellerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore db = FirebaseFirestore.instance;

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

      await usersCollection.doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "name": name,
        "role": "seller",
        "phone": phone,
        "email": credential.user!.email,
      });

      await db.collection('sellers').doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "name": name,
        "city": city,
        "sector": sector,
        "phone": phone,
        "email": credential.user!.email,
      });

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
      final user =
          await usersCollection.doc(id).set({"name": name, "phone": phone});

      await db
          .collection('sellers')
          .doc(id)
          .set({"name": name, "city": city, "sector": sector, "phone": phone});

      dynamic client = await db
          .collection('clients')
          .where('seller_id', isEqualTo: id)
          .get();

      db
          .collection('clients')
          .where('seller_id', isEqualTo: id)
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  element.reference.update({'seller': name});
                })
              });

      return "updated";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // update user email
  Future updateEmail(String email, String oldPass) async {
    try {
      dynamic user = FirebaseAuth.instance.currentUser;

      String em = user.email!;

      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: em, password: oldPass);

      // // Reauthenticate
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await user.updateEmail(email);
      await db.collection('users').doc(_auth.currentUser!.uid).update({
        "email": email,
      });
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'firebase_auth/unknown') {
        return "both fields are required";
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'requires-recent-login') {
        return 'You should relogin to do this action';
      } else if (e.code == 'unknown') {
        return 'both fields are required';
      }
      return e.toString();
    } catch (e) {
      print(e.toString());
    }
  }

  // update user password
  Future updatePassword(String pass, String oldPass) async {
    try {
      dynamic user = FirebaseAuth.instance.currentUser;

      String em = user.email!;

      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: em, password: oldPass);

      // // Reauthenticate
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await _auth.currentUser!.updatePassword(pass);

      return "success";
    } catch (e) {
      print(e.toString());
    }
  }

  // delete account
  Future deleteAccount(String oldPass) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      String em = user!.email!;
      String uid = user.uid;

      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: em, password: oldPass);

      // // Reauthenticate
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await user.delete();
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();

      return "success";
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future deleteSeller(id) async {
    try {
      await db.collection("users").doc(id).delete();
      await db.collection("sellers").doc(id).delete();
      return 'success';
    } catch (e) {
      print(e);
      return null;
    }
  }
}
