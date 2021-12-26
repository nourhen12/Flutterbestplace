import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutterbestplace/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class UserController extends GetxController {
  var statusController;
  var messageController;
  var userController = User();
  var token;
  var Avatar;

  //register :
  Future<User> signup(name, email, password, role) async {
    final String url = "https://bestpkace-api.herokuapp.com/users";
    final response = await http.post(
      Uri.parse("$url/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullname': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);

    if (body['status'] == 'success') {
      Get.toNamed('/login');
      print(User.fromJson(body['payload']));
    } else {
      throw Exception('Failed to register user.');
    }
  }

  //connexion
  Future<User> login(email, password) async {
    final String url = "https://bestpkace-api.herokuapp.com/users";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("$url/authenticate"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);

    if (body['status'] == 'success') {
      token = body['payload']['token'];
      final user = body['payload']['user'];
      userController = User.fromJson(user);
      Avatar =
          "https://bestpkace-api.herokuapp.com/uploadsavatar1/${userController.avatar}";
      //Get.toNamed('/profil');
      if (user['role'] == 'USER') {
        Get.toNamed('/editprofil');
      } else if (user['role'] == 'PLACE') {
        Get.toNamed('/editprofil');
      }
    } else {
      throw Exception('Failed to connected user.');
    }
  }

  Future<User> UserById(String id) async {
    final String url = "https://bestpkace-api.herokuapp.com/users";
    final response = await http.get(Uri.parse('$url/$id'));
    Map<String, dynamic> body = jsonDecode(response.body);
    User user = body['payload']['user'];

    if (response.statusCode == 200) {
      return user;
    } else {
      throw Exception('Failed to load a user');
    }
  }

  Future<User> updateUser(
      String id, String name, String email, String phone, String ville) async {
    Map user = {
      'fullname': name,
      'email': email,
      'phone': phone,
      'ville': ville
    };
    final String url = "https://bestpkace-api.herokuapp.com/users";
    final response = await http.put(
      Uri.parse("$url/update/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);

    if (body['status'] == 'success') {
      userController = User.fromJson(body['payload']['user']);
      print(userController);
      Get.toNamed('/profil');
    } else {
      throw Exception('Failed to register user.');
    }
    update();
  }

  Future<void> deleteUser(String id) async {
    final String url = "https://bestpkace-api.herokuapp.com/users";
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      print("User deleted");
    } else {
      throw "Failed to delete a user.";
    }
  }


  Future<User> updateAvatar(String id, final image) async {

    /*Future<dynamic> uploadAvatar(String id) async {
     var path  = "https://bestpkace-api.herokuapp.com/uploadsavatar/del-place.jpg";

    final String url = "https://bestpkace-api.herokuapp.com/";
    final response = await http.post(
      Uri.parse("$url/uploadsavatar/avatar/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(image),
    );
    print(jsonDecode(response.body));
      body: jsonEncode(path),
    );
    print(jsonDecode(response.body));

  }
  Future<dynamic> uploadAvatar(String id,String title, File file,String str) async{

    var request = http.MultipartRequest("POST",Uri.parse("https://bestpkace-api.herokuapp.com/uploadsavatar/$id"));

    request.fields['title'] = "dummyImage";
    request.headers['Authorization'] = "Client-ID " +"f7........";

    var picture = http.MultipartFile.fromBytes('image', (await rootBundle.load(str)).buffer.asUint8List(),
        filename: str);

    request.files.add(picture);

    var response = await request.send();
    var responseData = await response.stream.toBytes();

    var result = String.fromCharCodes(responseData);

    print(result);
  }
  */
  }
}

