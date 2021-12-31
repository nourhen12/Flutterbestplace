
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterbestplace/models/user.dart';

class DBService {
  /*var userCollection = FirebaseFirestore.instance.collection("user");

  saveUser(CUser user) async{
    try {
      await userCollection.doc(user.id).set(user.toJson());
    } catch (e) {}
  }*/
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(CUser user) async {
    try {
      await _firestore.collection("user").doc(user.id).set(
        user.toJson()
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

   getUser(String uid) async {
     final userRef = FirebaseFirestore.instance.collection('user').withConverter<CUser>(
       fromFirestore: (snapshot, _) => CUser.fromJson(snapshot.data()),
       toFirestore: (user, _) => user.toJson(),
     );
     CUser userdata = await userRef.doc(uid).get().then((snapshot) => snapshot.data());
return userdata;
   }

  Future<void> addTodo(String content, String uid) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .add({
        'dateCreated': Timestamp.now(),
        'content': content,
        'done': false,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

 /* Stream<List<TodoModel>> todoStream(String uid) {
    return _firestore
        .collection("users")
        .document(uid)
        .collection("todos")
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<TodoModel> retVal = List();
      query.documents.forEach((element) {
        retVal.add(TodoModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> updateTodo(bool newValue, String uid, String todoId) async {
    try {
      _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(todoId)
          .update({"done": newValue});
    } catch (e) {
      print(e);
      rethrow;
    }
  }*/
}
