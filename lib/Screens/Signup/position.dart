import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
import 'package:flutterbestplace/Screens/Signup/components/background.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:flutterbestplace/Controllers/maps_controller.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:flutterbestplace/Controllers/auth_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PositionAdd extends StatefulWidget {
  @override
  State<PositionAdd> createState() => PositionState();
}

class PositionState extends State<PositionAdd> {
  var phone;
  var adresse;
  bool _isOpen = false;
  final _formKey = GlobalKey<FormState>();
  CameraPosition _kGooglePlex;
  Position cp;
  var lat;
  var long;
  Set<Marker> marker = {};
  AuthService _controller = Get.put(AuthService());
  PanelController _panelController = PanelController();
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
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
    Size size = MediaQuery
        .of(context)
        .size;


    return new Scaffold(
        body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
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
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
    ],
        ),
    );
  }
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Text(
                 "Location",
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          Formbuild(context),
        ],
      ),
    );
  }

  Widget Formbuild(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Form(
      key: _formKey,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
    RoundedInputField(
      hintText: "Your Adresse",
      icon: Icons.room,
      onChanged: (value) {
        adresse = value;
      },
      validate: (value) {
        if (value.isEmpty) {
          return 'Enter your Adresse';
        } else {
          return null;
        }
      },
    ),
    RoundedInputField(
    hintText: "Your Phone",
    icon: Icons.phone,
    KeyboardType: TextInputType.number,
    onChanged: (value) {
    phone = value;
    },
    validate: (value) {
    if (value.isEmpty) {
    return 'Enter your phone number';
    } else if (RegExp(r'([0-9]{8}$)').hasMatch(value)) {
    return null;
    } else {
    return 'Enter valide phone number';
    }
    }),
    RoundedButton(
    text: "SAVE",
    press: () async {
    var fromdata = _formKey.currentState;
    if (fromdata.validate()) {
    fromdata.save();
    print("******************$phone");
    print("******************$adresse");
    await _controller.createPlace(_controller.idController,phone,adresse);
    await controllerMarker.addMarker(
    _controller.idController, lat, long);
    Get.toNamed('/login');
    }
    else{
    print("not valid");
    }
    },
    ),

    ],
    ),

    );
  }
}
