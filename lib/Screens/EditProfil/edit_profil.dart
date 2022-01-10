import 'package:flutter/material.dart';
import 'package:flutterbestplace/components/appbar_widget.dart';
import 'package:flutterbestplace/Screens/EditProfil/body.dart';

class EditProfil extends StatelessWidget {
  final String currentUserId;
  EditProfil({ this.currentUserId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }
}
