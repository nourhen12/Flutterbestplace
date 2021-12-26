import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:ffi';
import 'dart:async';
import 'package:async/async.dart';
import 'package:path/path.dart';

class Body extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<Body> {

  var NewName = null;
  var NewEmail = null;
  var NewPhone = null;
  var NewVille = null;
  File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(File imageFile,String id) async {
    // open a bytestream
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://bestpkace-api.herokuapp.com/uploadsavatar/avatar/$id");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  bool isloaded = false;
  var result;
  fetch() async {
    var response = await http.get(Uri.parse("https://bestpkace-api.herokuapp.com/uploadsavatar1"));
    result = jsonDecode(response.body);
    print(result[0]['avatar']);
    setState(() {
      isloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    UserController _controller = Get.put(UserController());
    var NewName = null;
    var NewEmail = null;
    var NewPhone = null;
    var NewVille = null;

      User user = _controller.userController;
      var url = _controller.Avatar;
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [

          PhotoProfile(
            imagePath: url,

            isEdit: true,
            onClicked: () async {
              await getImage();
              upload(_image,_controller.userController.id);
            },
          ),
          const SizedBox(height: 24),
          RoundedInputField(
            hintText: user.fullname,
            icon: Icons.person,
            onChanged: (value) {
              NewName = value;
            },
          ),
          const SizedBox(height: 24),
          RoundedInputField(
            hintText: user.email,
            icon: Icons.email,
            onChanged: (value) {
              NewEmail = value;
            },
          ),
          RoundedInputField(
            hintText: "Your Phone",
            icon: Icons.phone,
            onChanged: (value) {
              NewPhone = value;
            },
          ),
          RoundedInputField(
            hintText: "Your Ville",
            icon: Icons.location_city,
            onChanged: (value) {
              NewVille = value;
            },
          ),
          RoundedButton(
            text: "Save",
            press: () {
              print(
                  'id : $user.id  , name : $NewName , email : $NewEmail , phone : $NewPhone , ville : $NewVille');
              _controller.updateUser(
                  user.id, NewName, NewEmail, NewPhone, NewVille);
              Navigator.pop(context);
            },

          ),
        ],
      );

    }


}


