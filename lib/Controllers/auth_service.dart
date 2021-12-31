import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbestplace/Controllers/db_service.dart';
import 'package:flutterbestplace/Controllers/postes_controller.dart';
import 'package:flutterbestplace/Controllers/userController.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  /* final _auth=FirebaseAuth.instance;



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
}*/

  FirebaseAuth _auth = FirebaseAuth.instance;
  //Rx<User> _firebaseUser ;
  Rx<CUser> userController = CUser().obs;
CUser get user => userController.value;
  User userC = FirebaseAuth.instance.currentUser;

Stream<User> get onChangedUser =>_auth.authStateChanges();


  void createUser(String name, String email, String password,String role) async {
    try {
    dynamic  _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      //create user in database.dart
      CUser _user = CUser(
        id: _authResult.user.uid,
        fullname: name,
        email: _authResult.user.email,
        role:role
      );
      if (await DBService().createNewUser(_user)) {
        userController.value = _user;

        print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ${userController.value.email}");
        Get.toNamed('/profilUser');
            //Get.back();
      }
    } catch (e) {
      /*Get.snackbar(
        "Error creating Account",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );*/
    }
  }

  void login(String email, String password) async {
    try {
      UserCredential _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      userController.value = await DBService().getUser(_authResult.user.uid);
      print("ghfvhjghfvkmhvkhvkhvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv${userController.value.email}");
      print("USER log in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      userController.value =CUser();
    } catch (e) {
     /* Get.snackbar(
        "Error signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );*/
    }
  }
}
