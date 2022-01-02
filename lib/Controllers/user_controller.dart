import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutterbestplace/models/Data.dart';
import 'package:flutterbestplace/models/user.dart';

import 'package:http/http.dart' as http;

class UserController extends GetxController {
  final String url = "https://bestpkace-api.herokuapp.com/users";
  Rx<CUser> userController;
  String idController;
  var imageList = [
    'images/roys1.jpg',
    'images/roys2.jpg',
    'images/roys3.jpg',
    'images/roys4.jpg',
  ];
  //register :
  Future<Data> signup(name, email, password, role) async {
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
    Map<String, dynamic> res = jsonDecode(response.body);
    return Data.fromJson(res);
  }


  //connexion
  Future<Data> login(email, password) async {
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
    Map<String, dynamic> res = jsonDecode(response.body);
    return Data.fromJson(res);
  }

  Future<Data> addPlace(
      String id, String phone, String ville, String adresse) async {
    Map place = {'phone': phone, 'ville': ville, 'adresse': adresse};
    final response = await http.put(
      Uri.parse("$url/update/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(place),
    );
    Map<String, dynamic> res = jsonDecode(response.body);
    return Data.fromJson(res);
  }

  Future<CUser> updateUser(String id, String name, String phone, String ville,
      String adresse) async {
    Map user = {
      'fullname': name,
      'phone': phone,
      'ville': ville,
      'adresse': adresse
    };

    final response = await http.put(
      Uri.parse("$url/update/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == 'success') {
      print(CUser.fromJson(body['payload']));
      userController = CUser.fromJson(body['payload']).obs;
      print(userController);
      Get.toNamed('/profilUser');
    } else {
      throw Exception('Failed to register user.');
    }
  }

/*
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
  }*/

}
