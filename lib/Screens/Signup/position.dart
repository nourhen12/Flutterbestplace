import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:flutterbestplace/Controllers/maps_controller.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';

class PositionAdd extends StatefulWidget {
  @override
  State<PositionAdd> createState() => PositionState();
}

class PositionState extends State<PositionAdd> {
  //var _controller = Completer();
  CameraPosition _kGooglePlex;
  Position cp;
  var lat;
  var long;
  Set<Marker> marker = {};
  UserController _controller = Get.put(UserController());
  //UserController _controller = UserController();
  MarkerController controllerMarker = MarkerController();

//geolocator : funnction permission
  Future getPer() async {
    bool services;
    LocationPermission per;
    services = await Geolocator.isLocationServiceEnabled();
    if (services == false) {
      AwesomeDialog(
        context: context,
        title: 'services',
        body: Text('Activate the localisation in your smartphone'),
      )..show();
      if (per == LocationPermission.denied) {
        per = await Geolocator.requestPermission();
      }
    }
    return per;
  }

//geolocator :function de  latitude and longitude
  Future<Position> getLateAndLate() async {
    cp = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cp.latitude;
    long = cp.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 15.4746,
    );
    marker.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onDragEnd: (LatLng t) {
          lat = t.latitude;
          long = t.longitude;
          print(lat);
          print(long);
        },
        position: LatLng(lat, long)));
    setState(() {});
  }

  @override
  void initState() {
    getPer();
    getLateAndLate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: [
          _kGooglePlex == null
              ? CircularProgressIndicator()
              : Container(
                  child: GoogleMap(
                    markers: marker,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                  ),
                  height: 500,
                ),
          ElevatedButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Data data = await controllerMarker.addMarker(
                  _controller.idController, lat, long);
              if (data.status == 'success') {
                Get.toNamed('/login');
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
              }
            },
            style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w100)),
          ),
        ],
      ),
    );
  }
}
