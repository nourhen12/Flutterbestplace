import 'package:flutter/material.dart';
import 'package:flutterbestplace/chat_screen.dart';
import 'package:flutterbestplace/Screens/Welcome/welcome_screen.dart';
import 'package:flutterbestplace/constants.dart';
import 'package:flutterbestplace/Screens/Signup/signup_screen.dart';
import 'package:flutterbestplace/Screens/Login/login_screen.dart';
import 'package:flutterbestplace/Screens/Accueil/accueil.dart';
import 'package:flutterbestplace/Screens/Profil_User/profil_screen.dart';
import 'package:flutterbestplace/Screens/EditProfil/edit_profil.dart';
import 'package:flutterbestplace/Screens/Profil_Place/profil_place.dart';
import 'package:flutterbestplace/Screens/google_map/map.dart';
import 'package:flutterbestplace/home.dart';
import 'package:get/get.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
      getPages: [
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/accueil', page: () => AccuielScreen()),
        GetPage(name: '/profil', page: () => ProfilUser()),
        GetPage(name: '/editprofil', page: () => EditProfil()),
        GetPage(name: '/profilPlace', page: () => ProfilPlace()),
        GetPage(name: '/map', page: () => MapSample()),
      ],
      /* routes: {
        'signup': (context) => SignUpScreen(),
        'login': (context) => LoginScreen(),
        'accueil': (context) => AccuielScreen(),
        'profil': (context) => ProfilScreen(),
      },*/
    );
  }
}
