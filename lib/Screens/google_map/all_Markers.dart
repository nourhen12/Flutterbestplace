import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
//google maps :
import 'package:google_maps_flutter/google_maps_flutter.dart';
//geolocator :
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/Controllers/maps_controller.dart';

class AllMarkers extends StatefulWidget {
  @override
  State<AllMarkers> createState() => getAllMarkersState();
}

class getAllMarkersState extends State<AllMarkers> {
  var _controller = Completer();
  MarkerController controllerMarker = MarkerController();
  CameraPosition _kGooglePlex;
  Position cp;
  Set<Marker> markers = {};

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
      zoom: 14.4746,
    );
    markers.add(Marker(
        markerId: MarkerId("1"), position: LatLng(cp.latitude, cp.longitude)));
    setState(() {});
  }

  _getAllMarker() async {
    List<dynamic> liste = await controllerMarker.MarkerAll();
    print(liste);
    for (var i = 0; i < liste.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(liste[i]['_id']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: LatLng(liste[i]['latitude'], liste[i]['longitude'])));
    }
  }

  @override
  void initState() {
    getPer();
    getLateAndLate();
    _getAllMarker();
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
                    markers: markers,
                    mapType: MapType.normal,
                    onTap: (LatLng t) {
                      print('t1 : ${t.latitude}');
                      print('t1 : ${t.longitude}');
                    },
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
            onPressed: () async {
              controllerMarker.UserById('61ad2d0ca7f7450023e9e2b0');
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
