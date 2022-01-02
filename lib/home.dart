import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';



final GoogleSignIn googleSignIn = GoogleSignIn();

//var currentUser=User(email: '', id: '',fullname:'');
final DateTime timestamp=DateTime.now();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  UserController _controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    pageController = PageController();
//Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print("Error signed in ! : $err");
    });
    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print("Error signing in :$err");
    });
  }

  handleSignIn(account) {
    if (account != null) {
      //print("User signed in ! : $account");
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }
  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;

     _controller.signup(user.displayName,user.email ,"sss","PLACE");


  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
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
            onPressed: logout,
          ),

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

  Scaffold buildUnAuthScreen() {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("flutterShare",
                    style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 90.0,
                        color: Colors.white)),
                GestureDetector(
                    onTap: login,
                    child: Container(
                        width: 260.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/roys1.jpg",),
                            fit: BoxFit.cover,
                          ),
                        )))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
