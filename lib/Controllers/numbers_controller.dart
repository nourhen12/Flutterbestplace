import 'dart:convert';
import 'package:flutterbestplace/models/Data.dart';
import 'package:http/http.dart' as http;

class NumbersController {
  Future addFollow(String idCurret, String iduser) async {
    final String url = "https://bestpkace-api.herokuapp.com/users";
    final response1 = await http.put(
      Uri.parse("$url/update/$iduser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"followers": idCurret}),
    );
    Map<String, dynamic> body1 = jsonDecode(response1.body);
    print(body1);
    final response2 = await http.put(
      Uri.parse("$url/update/$idCurret"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"following": iduser}),
    );
    Map<String, dynamic> body2 = jsonDecode(response2.body);
    print(body2);
  }
}
