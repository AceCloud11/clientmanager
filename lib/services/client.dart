import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  //create a client
  Future createNewClient(String name, String phone, String city,
      Map coordinates, String type, String seller, String uid) async {
    try {
      final client = await db.collection('clients').doc().set({
        "name": name,
        "seller": seller,
        "seller_id": uid,
        "phone": phone,
        "city": city,
        "type": type,
        "coordinates": coordinates,
      });

      return "success";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteCleint(String id) async {
    try {
      await db.collection('clients').doc(id).delete();
      return 'success';
    } catch (e) {
      print(e);
      return null;
    }
  }
}
