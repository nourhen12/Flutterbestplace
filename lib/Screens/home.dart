import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/Controllers/auth_service.dart';
import 'package:flutterbestplace/Screens/Accueil/accueil.dart';
import 'package:flutterbestplace/Screens/Profil_User/profil_screen.dart';
import 'package:flutterbestplace/Screens/Profil_Place/profil_place.dart';

import 'package:flutterbestplace/Screens/Welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutterbestplace/models/user.dart';
//import 'package:flutterbestplace/Screens/profile.dart';
import 'package:flutterbestplace/Screens/search.dart';
import 'package:flutterbestplace/Screens/timeline.dart';
import 'package:flutterbestplace/Screens/upload.dart';

import 'Profil_Place/profil_place.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef=FirebaseStorage.instance.ref();
final usersRef =FirebaseFirestore.instance.collection("user");
final postsRef =FirebaseFirestore.instance.collection("posts");
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');



 CUser currentUser=CUser();
final DateTime timestamp=DateTime.now();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _controller = Get.put(AuthService());

  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
//Detects when user signed in

  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          //Timeline(),
          RaisedButton(
            child: Text("logout"),
            onPressed:  ()async {
              await AuthService().signOut();}
          ),
          //ActivityFeed(),
          Upload(currentUser:_controller.user),
          Search(),
          _controller.userController.value.role=="Place"?ProfilPlace():ProfilUser(),

        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
    //return Text("authenticated");
    //return RaisedButton(child: Text("logout"),onPressed: logout,);
  }


  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream:AuthService().onChangedUser,
      builder: (context,snapshot){

        return snapshot.data==null?WelcomeScreen():buildAuthScreen();

      },

    );
  }
}
