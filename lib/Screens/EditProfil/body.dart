import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutterbestplace/Controllers/auth_service.dart';
import 'package:flutterbestplace/Screens/Login/components/background.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/progress.dart';
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
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../Signup/components/body.dart';
final Reference storageRef=FirebaseStorage.instance.ref();

class Body extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<Body> {
  AuthService _controller = Get.put(AuthService());
  var NewName = null;
  var NewPhone = null;
  var NewVille = null;
  var NewAdress = null;
  final _formKey = GlobalKey<FormState>();
  File _image =File("");

  bool isUploading = false;
  String postId = Uuid().v4();
  final picker = ImagePicker();


  getImage() async {
final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);

    setState(() {_image = File(pickedFile.path);
    });
  }

  getImagegallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,

        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: getImage,

              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: getImagegallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}

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
                  _controller.userController.value.photoUrl,
                  isEdit: true,
                  onClicked: () async {
                    getImagegallery();
                  _controller.uploadProfilePicture(_image);
                  },

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
                  print("HGKJGVUUKHJHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH: $userId");
                  print("name : $NewName , phone : $NewPhone , adresse : $NewAdress ville : $NewVille ");
                   _controller.updateUser(userId,NewName,NewPhone,NewVille,NewAdress);
                  print("********************************************************");

                  Get.toNamed('/profilUser');
                 /* if(res["status"]){
                  AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Error',
                  desc:Errormessage,
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                  ..show();
                  }*/
                 // _controller.updateUser(
                  //    userId, NewName, NewPhone, NewVille, NewAdress);
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
