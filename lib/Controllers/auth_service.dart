import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbestplace/Controllers/db_service.dart';
import 'package:flutterbestplace/models/user.dart';
class AuthService{
  final _auth=FirebaseAuth.instance;
  SingIn(String email,String password) async {
    try{
     return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseException catch(e){
      return null;
    }

  }
  SingUp(String name,String email,String password,String role)async{
    try{
     await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await DBService().saveUser(CUser(id: user.uid,fullname: name,email:email,role:role));
    return true;
    }on FirebaseException catch(e){
      return false;

    }
  }
  User get user =>FirebaseAuth.instance.currentUser;
Stream<User> get onChangedUser =>_auth.authStateChanges();
signOut()async{
  try{
    await _auth.signOut();
  }catch(e){}
}



}
