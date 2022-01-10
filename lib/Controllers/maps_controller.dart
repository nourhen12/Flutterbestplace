import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterbestplace/Screens/home.dart';
import 'dart:io';
import 'package:flutterbestplace/models/marker.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:http/http.dart' as http;

class MarkerController {
  final markerRef = FirebaseFirestore.instance.collection('marker');
  var MController = Marker();
  Future<void> addMarker(idUser, lat, long) async {
    try {
      await markerRef
          .doc(idUser)
          .set({
            'id': idUser,
            'latitude': lat,
            'longitude': long,
          })
          .then((value) => print("Marquer Added"))
          .catchError((error) => print("Failed to add marker: $error"));
    } catch (e) {
      return e.message;
    }
  }

  MarkerById(String id) async {
    try {
      final markerdata = await markerRef.withConverter<Marker>(
        fromFirestore: (snapshot, _) => Marker.fromJson(snapshot.data()),
        toFirestore: (marker, _) => marker.toJson(),
      );
      Marker marker =
          await markerdata.doc(id).get().then((snapshot) => snapshot.data());
      print(marker.toJson());
      return marker;
    } catch (e) {
      print("FAILED GET MARKER");
    }
  }

  Future MarkerAll() async {
    QuerySnapshot querySnapshot = await markerRef.get();
    List<QueryDocumentSnapshot> Documents = querySnapshot.docs;
    List<Marker> markers;
    Documents.forEach((element) {
      markers.add(Marker.fromJson(element.data()));
    });
    print("7777777777777777777777777777777");
    print(markers[0].toJson());
  }
}
