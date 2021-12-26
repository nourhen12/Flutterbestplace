import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbestplace/Screens/Login/components/background.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class Body extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<Body> {
  UserController _controller = Get.put(UserController());
  var NewName = null;
  var NewPhone = null;
  var NewVille = null;
  var NewAdress = null;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => PhotoProfile(
                  imagePath:
                      "https://bestpkace-api.herokuapp.com/uploadsavatar1/${_controller.userController.value.avatar}",
                  isEdit: true,
                  onClicked: () async {},
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => RoundedInputField(
                  hintText: "your name",
                  InitialValue: _controller.userController.value.fullname,
                  icon: Icons.person,
                  onChanged: (value) {
                    NewName = value;
                  },
                ),
              ),
              const SizedBox(height: 24),
              /*    Obx(
          () => RoundedInputField(
            hintText: "_controller.userController.value.email,
            icon: Icons.email,
            onChanged: (value) {
              NewEmail = value;
            },
          ),
        ),*/
              Obx(
                () => RoundedInputField(
                  hintText: 'your phone',
                  InitialValue: _controller.userController.value.phone,
                  icon: Icons.phone,
                  onChanged: (value) {
                    NewPhone = value;
                  },
                ),
              ),
              Obx(
                () => RoundedInputField(
                  hintText: 'you ville',
                  InitialValue: _controller.userController.value.ville,
                  icon: Icons.location_city,
                  onChanged: (value) {
                    NewVille = value;
                  },
                ),
              ),
              Obx(
                () => RoundedInputField(
                  hintText: 'your adress',
                  InitialValue: _controller.userController.value.adresse,
                  icon: Icons.location_city,
                  onChanged: (value) {
                    NewAdress = value;
                  },
                ),
              ),
              RoundedButton(
                text: "Save",
                press: () async {
                  var fromdata = _formKey.currentState;
                  fromdata.save();
                  var userId = _controller.idController;
                  // Get.toNamed('/profil');
                  _controller.updateUser(
                      userId, NewName, NewPhone, NewVille, NewAdress);
                  /* if (data.status == 'success') {
                    Map<String, dynamic> user = data.payload['user'];
                    _controller.userController = User.fromJson(user).obs;
                    Get.toNamed('/contactPlace');
                  } else {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: 'Error',
                        desc: data.message,
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red)
                      ..show();
                  }*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
