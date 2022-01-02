import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterbestplace/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoProfile extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const PhotoProfile({
    Key key,
    this.imagePath,
    this.isEdit = false,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {


    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image:  imagePath ==null ? AssetImage("assets/images/profil_defaut.jpg"):CachedNetworkImageProvider(imagePath) ,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          //child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child:
          IconButton(
            onPressed: onClicked,
            icon: Icon( isEdit ? Icons.add_a_photo : Icons.edit,
                color: Colors.white,
                size: 20),
            size: 20
          )
         /* IconButton(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
            onPressed: ,
          ),*/
        ),
      );

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
}