import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutterbestplace/components/button_widget.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/numbers_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterbestplace/models/user.dart';
import '../../Controllers/auth_service.dart';
import 'package:flutterbestplace/Controllers/postes_controller.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';


class Body extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Body> {
  bool _isOpen = false;
  String postOrientation = "grid";

  PanelController _panelController = PanelController();
  AuthService _controller = Get.put(AuthService());
  PostsController controllerPosts = PostsController();


  @override
  void initState() {
    super.initState();
    controllerPosts.getProfilePosts(_controller.idController);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Obx(
              () => PhotoProfile(
            imagePath:
            _controller.userController.value.photoUrl,
            onClicked: () async {
              Get.toNamed('/editprofil');
            },
          ),
        ),
        const SizedBox(height: 24),
        Obx(
              () => buildName(_controller.userController.value),
        ),
         Center(
            child: ButtonWidget(
          text: 'log out',
          onClicked: () async {
            //Get.toNamed('/image');
            await AuthService().signOut();
            Get.toNamed('/login');
          },
        )),
        const SizedBox(height: 24),
        /* Obx(
              () => NumbersWidget(
            Following: "34",
            Followers: _controller.userController.value.followers,
            idCurret: _controller.userController.value.id,
            iduser: "61b6821a8a3ffd0023dc6323",
          ),
        ),*/
        SizedBox(
          height: 30,
        ),

        SlidingUpPanel(
          controller: _panelController,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(32),
          ),
          minHeight: MediaQuery.of(context).size.height * 0.35,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          body: GestureDetector(
            onTap: () => _panelController.close(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          panelBuilder: (ScrollController controller) =>
              _panelBody(controller),
          onPanelSlide: (value) {
            if (value >= 0.2) {
              if (!_isOpen) {
                setState(() {
                  _isOpen = true;
                });
              }
            }
          },
          onPanelClosed: () {
            setState(() {
              _isOpen = false;
            });
          },
        ),
      ],
    );
  }

  Widget buildName(CUser user) => Column(
    children: [
      Text(
        user.fullname,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      ),
      /* Text(
            user.phone,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.ville,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            user.adresse,
            style: TextStyle(color: Colors.grey),
          )*/
    ],
  );

  Widget buildRating() => RatingBar.builder(
    initialRating: 2.5,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      print(rating);
    },
  );


  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
      IconTap(),
          buildProfilePosts(),
        ],
      ),
    );
  }
  //
  buildProfilePosts() {

     if (controllerPosts.posts==null) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/nopost.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Colors.pink[50],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {

      return GridView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controllerPosts.posts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:NetworkImage(controllerPosts.posts[index].mediaUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
  }

//IconTap
  Widget IconTap() => Container(
    color: kPrimaryLightColor,
    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              postOrientation = "grid";
            });
          },
          icon: Icon(Icons.image, color: kPrimaryColor, size: 30.0),
        ),
      ],
    ),
  );
}
