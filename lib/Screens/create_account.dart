import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterbestplace/Screens/header.dart';
import 'package:flutterbestplace/components/Dropdown_widget.dart';
import 'package:get/get.dart';

import '../Controllers/auth_service.dart';
import 'Signup/components/body.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldkey=GlobalKey<ScaffoldState>();
  final _formKey=GlobalKey<FormState>();
  String username="" ;
  AuthService _controller = Get.put(AuthService());

  var role;
  submit() async{
    final form=_formKey.currentState;

    if (form.validate()){
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldkey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2),(){
        Navigator.pop(context,username);
      });
      await _controller.updateRole(_controller.idController,role);
      Get.toNamed('/home');
    }
  }
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: header(context,titleText: "Set up your profile",removeBackButton: true),
      body:ListView(
        children:<Widget> [
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child:Text("Create a username",style: TextStyle(fontSize: 25.0)),)
                ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  child:Form(
                    key:_formKey,
                    child:  DropdownWidget(
                      HintText: Text("Your Role"),
                      Items: <String>['User', 'Place'],
                      onChanged: (value) {
                        role = value;
                      },
                      valueSelect: role,
                      validate: (value) {
                        if (value == null) {
                          return 'Choose your Role';
                        } else {
                          return null;
                        }
                      },
                    ),
                  )
                ),
              ),
              GestureDetector(
                onTap:  submit,
                child: Container(
                  height:50.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                child:Center( child: Text(
                  "Submit",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  )
                )),),
              ),
            ],),
          )

        ],
      ),
    );
  }
}
