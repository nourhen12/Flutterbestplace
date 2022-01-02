import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbestplace/Controllers/auth_service.dart';
import 'package:flutterbestplace/components/button_widget.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/numbers_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
class Body extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // UserController _controller = Get.put(UserController());
    AuthService _controller = Get.put(AuthService());
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
        //const SizedBox(height: 24),
        //Center(child: buildRating()),
        //const SizedBox(height: 24),
        /* Center(
            child: ButtonWidget(
          text: 'Upgrade To Profile',
          onClicked: () {
            Get.toNamed('/image');
          },
        )),*/
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

        Container(
          height: height * 0.5,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'My Orders',
                style: TextStyle(
                  color: Color.fromRGBO(39, 105, 171, 1),
                  fontSize: 27,
                  fontFamily: 'Nunito',
                ),
              ),
              Divider(
                thickness: 2.5,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ]),
          ),
        )
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
}
