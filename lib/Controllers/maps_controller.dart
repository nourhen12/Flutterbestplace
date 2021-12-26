import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutterbestplace/models/marker.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:http/http.dart' as http;

class MarkerController {
  final String url = "https://bestpkace-api.herokuapp.com/markers";
  var MController = Marker();
  Future<Data> addMarker(idUser, lat, long) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': lat,
        'longitude': long,
        'user': idUser,
      }),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    return Data.fromJson(body);
  }

  Future<Marker> UserById(String id) async {
    final response = await http.get(Uri.parse('$url/$id'));
    Map<String, dynamic> body = jsonDecode(response.body);

    if (body['status'] == 'success') {
      print(body['payload']);
    } else {
      throw Exception('Failed to load a user');
    }
  }

  Future MarkerAll() async {
    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> body = jsonDecode(response.body);

    if (body['status'] == 'success') {
      List<dynamic> liste = body['payload'];
      return liste;
    } else {
      throw Exception('Failed to register user.');
    }
  }
}
