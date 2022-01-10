import 'package:flutter/material.dart';
import 'package:flutterbestplace/components/appbar_widget.dart';
import 'package:flutterbestplace/Screens/Profil_Place/body.dart';

class ProfilPlace extends StatelessWidget {
  final String profileId;
  ProfilPlace({ this.profileId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ProfilePage(),
    );
  }
}
