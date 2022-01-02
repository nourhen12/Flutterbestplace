import 'package:flutter/material.dart';
import 'package:flutterbestplace/Controllers/auth_service.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:flutterbestplace/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterbestplace/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccuielScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RoundedButton(
          text: "USERS",
          press: ()async {
            await AuthService().signOut();
          }),
    );
  }
}

Future<CUser> getUser() async {
  final response =
      await http.get(Uri.parse('https://bestpkace-api.herokuapp.com/users'));
  print(jsonDecode(response.body));

  /* if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }*/
}
