import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbestplace/Controllers/db_service.dart';
import 'package:flutterbestplace/Controllers/postes_controller.dart';
import 'package:flutterbestplace/Screens/Signup/components/body.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService extends GetxController {
  var isgoogleGmail= false;
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
        userController.value=_user;
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
      UserCredential authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userController.value = await DBService().getUser(authResult.user.uid);
     // userController.value = await DBService().getUser(id);
      idController = authResult.user.uid;
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
      CUser _user = CUser(
        id: googleUserCredential.user.uid,
        fullname: googleUserCredential.user.displayName,
        email: googleUserCredential.user.email,
        photoUrl: googleUserCredential.user.photoURL,
      );
      await DBService().createNewUser(_user);

    }
    userController.value = await DBService().getUser(googleUserCredential.user.uid);
    idController = googleUserCredential.user.uid;
    isgoogleGmail = true;
    print(isgoogleGmail);

  }



  final firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instanceFor(
      bucket: 'gs://bestplace-331512.appspot.com');
  Future<String> uploadFile(File file) async {
    var userId = idController;
    firebase_storage.UploadTask uploadTask =
    storage.ref().child("user/profile/$userId").putFile(file);
    firebase_storage.TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;

  }

  Future<String> getUserProfileImage(String uid) async {
    return await storage.ref().child("user/profile/$uid").getDownloadURL();
  }
  Future<void> uploadProfilePicture(File image) async {

    userController.value.photoUrl = await uploadFile(image);

    usersRef.doc(idController).update({
      'photoUrl': userController.value.photoUrl,
      // John Doe
    } );
  }

  Future<String> getDownloadUrl() async {
    return await getUserProfileImage(idController);
  }
  void signOut() async {
    try {
      print("11111111111111111111111111111 $isgoogleGmail");
      if(isgoogleGmail){
        await googleSignIn.signOut();
        isgoogleGmail=false;
      }else{
      await _auth.signOut();
    }
      print("2222222222222222222222222222222 $isgoogleGmail");
      //userController.value = CUser();
    } catch (e) {
      /* Get.snackbar(
        "Error signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );*/
    }
  }

  Future<void> updateUser(String id, String name, String phone, String ville,
      String adresse) async {

    usersRef.doc(id).update({
      'fullname': name,
      'phone': phone,
      'ville': ville,
      'adresse': adresse,
    }).then((value) => "SUCCESS")
        .catchError((error) => print("Failed to update user: $error"));

      userController.value = await DBService().getUser(id);
      print("*************************User: " + userController.value.role);

  }
}
