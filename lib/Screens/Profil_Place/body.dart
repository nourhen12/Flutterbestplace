import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
//google maps :
import 'package:google_maps_flutter/google_maps_flutter.dart';
//geolocator :
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutterbestplace/components/numbers_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterbestplace/models/user.dart';
import '../../Controllers/auth_service.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:flutterbestplace/Controllers/maps_controller.dart';
import 'package:flutterbestplace/Controllers/postes_controller.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isOpen = false;
  String postOrientation = "grid";
  CameraPosition _kGooglePlex;
  final _completer = Completer();
  Position cp;
  Set<Marker> markers = {};

  PanelController _panelController = PanelController();
  AuthService _controller = Get.put(AuthService());
  PostsController controllerPosts = PostsController();
  MarkerController controllerMarker = MarkerController();

  Future<Position> getLateAndLate() async {
   /* Data data = await controllerMarker.MarkerById(
        _controller.userController.value.marker[0]);
    print("*****************************");
    var latitude = data.payload['latitude'];
    var longitude = data.payload['longitude'];
    print(latitude);
    print(longitude);*/
    _kGooglePlex = CameraPosition(
      target: LatLng(36.87044600097282, 10.312512795556627),
      zoom: 14.4746,
    );
    var add = markers.add(
        Marker(markerId: MarkerId("1"), position: LatLng(36.87044600097282, 10.312512795556627)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLateAndLate();
     controllerPosts.getProfilePosts(_controller.idController);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Obx(
            () => FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  _controller.userController.value.photoUrl==null ? AssetImage("assets/images/profil_defaut.jpg"):NetworkImage(_controller.userController.value.photoUrl),

                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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

  /// WIDGETS

  Widget buildCircle({
    Widget child,
    double all,
    Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildName(CUser user) => Column(children: [
        Text(
          user.fullname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(color: Colors.grey),
        ),
      ]);

  Widget buildRating() => RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          print(rating);
        },
      );

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
                Obx(
                  () => _titleSection(_controller.userController.value),
                ),

                Center(child: buildRating()),
    /* Obx(
                  () => NumbersWidget(
                    Following: _controller.userController.value.following,
                    Followers: _controller.userController.value.followers,
                    Posts: _controller.imageList,
                    idCurret: _controller.idController,
                    iduser: "61b6821a8a3ffd0023dc6323",
                  ),
                ),*/
                // _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          IconTap(),
          buildProfilePosts(),
        ],
      ),
    );
  }

//
  buildProfilePosts() {
     if (controllerPosts.posts==null) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/profil_defaut.jpg"),

            ),
          ),
        ),
      );
      /*Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/nopost.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Colors.pink[50],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );*/
    } else if (postOrientation == "grid") {

      return GridView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controllerPosts.posts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:NetworkImage(controllerPosts.posts[index].mediaUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else if (postOrientation == "map") {
      return Column(
        children: [
          _kGooglePlex == null
              ? CircularProgressIndicator()
              : Container(
                  child: GoogleMap(
                    markers: markers,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (controller) {
                      _completer.complete(controller);
                    },
                  ),
                  height: 500,
                ),
        ],
      );
    }
  }

//IconTap
  Widget IconTap() => Container(
        color: kPrimaryLightColor,
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  postOrientation = "grid";
                });
              },
              icon: Icon(Icons.image, color: kPrimaryColor, size: 30.0),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  postOrientation = "map";
                });
              },
              icon: Icon(Icons.map, color: kPrimaryColor, size: 30.0),
            )
          ],
        ),
      );

  /// Action Section
  Row _actionSection({double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlineButton(
              onPressed: () => _panelController.open(),
              borderSide: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'VIEW PROFILE',
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: FlatButton(
                onPressed: () => print('Message tapped'),
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'MESSAGE',
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection(CUser user) {
    return Column(
      children: <Widget>[
        Text(
          user.fullname,
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        buildEditIcon(kPrimaryColor),
        SizedBox(
          height: 8,
        ),
        Text(
          user.email,
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          user.phone,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: IconButton(
            onPressed: () {
              Get.toNamed('/editprofil');
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
}

class Completer {
  void complete(GoogleMapController controller) {}
}
