import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutterbestplace/components/button_widget.dart';
import 'package:flutterbestplace/components/photo_profil.dart';
import 'package:flutterbestplace/components/numbers_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';

class Body extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Body> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  var imageList = [
    'assets/images/roys1.jpg',
    'assets/images/roys2.jpg',
    'assets/images/roys3.jpg',
    'assets/images/roys4.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    /*  UserController _controller = Get.put(UserController());
    User user = _controller.userController;
    String avaterapi = user.avatar;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List categories = ['Post', 'abowt', 'partage', 'map'];
    final panelController = PanelController();
    final double tabBarHeight = 80;
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        PhotoProfile(
          imagePath:
              "https://bestpkace-api.herokuapp.com/uploadsavatar/$avaterapi",
          onClicked: () async {
            Get.toNamed('/editprofil');
          },
        ),
        const SizedBox(height: 24),
        buildName(user),
        const SizedBox(height: 24),
        // Center(child:buildRating()),
        //const SizedBox(height: 24),
        Center(
            child: ButtonWidget(
          text: 'Upgrade To Profile',
          onClicked: () {},
        )),
        const SizedBox(height: 24),
        NumbersWidget(),
        SizedBox(
          height: 30,
        ),
        const SizedBox(height: 24),
        SlidingUpPanel(
          controller: panelController,
          maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
          panelBuilder: (scrollController) => buildSlidingPanel(
            scrollController: scrollController,
            panelController: panelController,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/roys1'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                'Explore Foods',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        //buildExpanded(context, categories),
      ],
    );*/
  }

  Widget buildSlidingPanel({
    @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildTabBar(
            onClicked: panelController.open,
          ),
          body: TabBarView(
            children: [
              ListView(
                padding: EdgeInsets.all(16),
                controller: scrollController,
                children: [
                  Text(
                    'Vegetarian cuisine is based on food that meets vegetarian standards by not including meat and animal tissue products. For lacto-ovo vegetarianism, eggs and dairy products are permitted',
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.asset('assets/veg.png'),
                  ),
                  Text(
                      '''1. "Spread love everywhere you go. Let no one ever come to you without leaving happier." -Mother Tere'''),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildTabBar({
    @required VoidCallback onClicked,
  }) =>
      PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: GestureDetector(
          onTap: onClicked,
          child: AppBar(
            title: buildDragIcon(), // Icon(Icons.drag_handle),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(child: Text('Vegetarian')),
                Tab(child: Text('Non Vegetarian')),
              ],
            ),
          ),
        ),
      );

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 40,
        height: 8,
      );

  Widget buildRating() => RatingBar.builder(
        initialRating: 2.5,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          print(rating);
        },
      );

  Widget buildExpanded(BuildContext countext, List categories) => Expanded(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
              color: Color(0xffEFEFEF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(34))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 33, right: 25, left: 25),
                child: Text(
                  'Protfllio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
                ),
              ),
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (countext, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 17.0, top: 3),
                        child: index == 1
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    categories[index],
                                    style: TextStyle(
                                        color: Color(0xff434AE8), fontSize: 19),
                                  ),
                                  CircleAvatar(
                                    radius: 2,
                                    backgroundColor: Color(0xff4343AE8),
                                  )
                                ],
                              )
                            : Text(
                                categories[index],
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.9),
                                    fontSize: 19),
                              ));
                  },
                ),
              ),

              /*Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.only(right: 25, left: 25),
                        height: 200,
                        child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                    child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: Image.asset(
                                    'assets/images/${index + 1}.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                        /*staggeredTileBuilder:(int counnt)=>StaggeredTile.count(2,index.isEven ? 3 : 1)
                        mainAxisSpacing:9,
                        crossAxisSpacing:8,*/
                      ),
                    )
                  ],
                ),
              ),*/
            ],
          ),
        ),
      );
}
    

  /*SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }*/

