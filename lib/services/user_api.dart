import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAPI {
  final String url = "https://bestpkace-api.herokuapp.com/users";

  //register :
  Future<CUser> register(name, email, password) async {
    final response = await http.post(
      Uri.parse("$url/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullname': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  //connexion
  Future<CUser> login(email, password) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
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
    final user = body['payload']['user'];
    final message = body['message'];
    if (body['status'] == 'success') {
      return CUser.fromJson(user);
    } else {
      return message;
    }
    /* if (body['status'] == 'success') {
      Get.toNamed('/profil');
      var token = body['payload']['token'];
      await prefs.setString('token', token);
      return User.fromJson(body['payload']);
    } else {
      throw Exception('Failed to connected user.');
    }*/
  }

  Future<CUser> UserById(String id) async {
    final response = await http.get(Uri.parse('$url/$id'));
    Map<String, dynamic> body = jsonDecode(response.body);
    CUser user = body['payload']['user'];

    if (response.statusCode == 200) {
      return user;
    } else {
      throw Exception('Failed to load a user');
    }
  }

  Future<CUser> updateUser(String id, String name, String email) async {
    Map data = {'fullname': name, 'email': email};
    final response = await http.put(
      Uri.parse("$url/update/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);

    if (body['status'] == 'success') {
      return CUser.fromJson(body['payload']);
    } else {
      throw Exception('Failed to register user.');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      print("User deleted");
    } else {
      throw "Failed to delete a user.";
    }
  }
}
