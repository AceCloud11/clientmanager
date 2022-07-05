import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class BossService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  //create a client
  Future registerNewBoss(
      String email, String password, String name, String phone) async {
    try {
      // FirebaseApp app = await Firebase.initializeApp(
      //     name: 'Secondary', options: Firebase.app().options);
      await Firebase.initializeApp(
          name: 'secondary', options: Firebase.app().options);
      FirebaseApp app = Firebase.app("secondary");

      UserCredential credential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      credential.user!.updateDisplayName(name);

      await db.collection('users').doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "name": name,
        "role": "boss",
        "phone": phone,
        "email": credential.user!.email,
      });

      await db.collection('bosses').doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "name": name,
        "phone": phone,
        "email": credential.user!.email,
      });

      return Future.sync(() => credential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteBoss(String id) async {
    try {
      await db.collection('bosses').doc(id).delete();
      return 'success';
    } catch (e) {
      print(e);
      return null;
    }
  }
}
