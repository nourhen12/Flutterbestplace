import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbestplace/Controllers/db_service.dart';
import 'package:flutterbestplace/Controllers/postes_controller.dart';
import 'package:flutterbestplace/Controllers/userController.dart';
import 'package:flutterbestplace/Screens/Signup/components/body.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<CUser> userController = CUser().obs;

  CUser get user => userController.value;
  User userC = FirebaseAuth.instance.currentUser;
  String idController;

  Stream<User> get onChangedUser => _auth.authStateChanges();

  Future<dynamic> createUser(String name, String email, String password,
      String role) async {
    try {
      dynamic _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      CUser _user = CUser(
          id: _authResult.user.uid,
          fullname: name,
          email: _authResult.user.email,
          role: role);
      if (await DBService().createNewUser(_user)) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential _authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userController.value = await DBService().getUser(_authResult.user.uid);
      idController = _authResult.user.uid;
      return null;
      print("USER log in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    }
  }

  Future<void> linkGoogleAndTwitter() async {
    // Trigger the Google Authentication flow.
    final GoogleSignInAccount user = await GoogleSignIn().signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    // Create a new credential.
    final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in to Firebase with the Google [UserCredential].
    final UserCredential googleUserCredential =
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
    DocumentSnapshot doc = await usersRef.doc(googleUserCredential.user.uid)
        .get();
    if (!doc.exists) {

      /*usersRef.doc(googleUserCredential.user.uid).set({'id': googleUserCredential.user.uid,
        'email': googleUserCredential.user.email,
        'photoUrl': googleUserCredential.user.photoURL,
        'displayName': googleUserCredential.user.displayName,
        'timestamp': timestamp, // John Doe
      } ).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      doc = await usersRef.doc(googleUserCredential.user.uid).get();
*/
      CUser _user = CUser(
        id: googleUserCredential.user.uid,
        fullname: googleUserCredential.user.displayName,
        email: googleUserCredential.user.email,
        photoUrl: googleUserCredential.user.photoURL,

      );
      await DBService().createNewUser(_user);
    }
    userController.value =
    await DBService().getUser(googleUserCredential.user.uid);
    idController = googleUserCredential.user.uid;
    print(
        "ghfvhjghfvkmhvkhvkhvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv${userController.value
            .email}");
    print("USER log in");
  }

  void signOut() async {
    try {
      await _auth.signOut();
      userController.value = CUser();
    } catch (e) {
      /* Get.snackbar(
        "Error signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );*/
    }
  }

  Future<Map> updateUser(String id, String name, String phone, String ville,
      String adresse) async {

    /* CUser _user = CUser(
        fullname: name,
        phone: phone,
        ville: ville,
        adresse: adresse

    );*/
    Map res = {"status" : false ,"message" :""};
    usersRef.doc(id).update({
      'fullname': name,
      'phone': phone,
      'ville': ville,
      'adresse': adresse,
      'photoUrl': userController.value.photoUrl,
    }).then((value) => res["status"]=true)
        .catchError((error) => res["message"]="Failed to update user: $error",);
    if (res["status"]) {
      userController.value = await DBService().getUser(id);
      Get.toNamed('/profilUser');
    }
    return res;
  }
}
