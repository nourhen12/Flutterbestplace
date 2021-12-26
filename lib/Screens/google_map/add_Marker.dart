import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
//google maps :
import 'package:google_maps_flutter/google_maps_flutter.dart';
//geolocator :
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/Controllers/maps_controller.dart';

class AddMarker extends StatefulWidget {
  @override
  State<AddMarker> createState() => MarkerState();
}

class MarkerState extends State<AddMarker> {
  var _controller = Completer();
  CameraPosition _kGooglePlex;
  Position cp;
  var lat;
  var long;
  Set<Marker> marker = {};
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
    _kGooglePlex = CameraPosition(
      target: LatLng(cp.latitude, cp.longitude),
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
        position: LatLng(cp.latitude, cp.longitude)));
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
                    onTap: (LatLng t) {
                      /*  print('cp : ${cp.latitude}');
                      print('cp : ${cp.longitude}');
                      marker.remove(Marker(markerId: MarkerId("1")));
                      marker.add(Marker(markerId: MarkerId("1"), position: t));
                      print('t2 : ${t.latitude}');
                      lat = t.latitude;
                      print('t2 : ${t.longitude}');
                      long = t.longitude;*/
                    },
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                  height: 500,
                ),
          ElevatedButton(
            child: Text(
              "button",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // controllerMarker.addMarker(lat, long);
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
