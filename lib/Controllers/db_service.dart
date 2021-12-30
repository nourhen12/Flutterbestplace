import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterbestplace/models/user.dart';

class DBService {
  var userCollection = FirebaseFirestore.instance.collection("user");

  saveUser(CUser user) async{
    try {
      await userCollection.doc(user.id).set(user.toJson());
    } catch (e) {}
  }
}
