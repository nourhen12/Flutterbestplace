import 'package:flutter/material.dart';
import 'package:flutterbestplace/Screens/Signup/components/background.dart';
import 'package:flutterbestplace/Screens/Signup/components/or_divider.dart';
import 'package:flutterbestplace/Screens/Signup/components/social_icon.dart';
import 'package:flutterbestplace/components/already_have_an_account_acheck.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:flutterbestplace/components/rounded_password_field.dart';
import 'package:flutterbestplace/components/Dropdown_widget.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:get/get.dart';

class Body extends StatelessWidget {
  UserController _controller = Get.put(UserController());
  //UserController _controller = UserController();
  var name;
  var mail;
  var psw;
  var role;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Name",
                icon: Icons.person,
                onChanged: (value) {
                  name = value;
                },
                validate: (value) {
                  if (value.isEmpty) {
                    return 'Enter your Name';
                  } else {
                    return null;
                  }
                },
              ),
              RoundedInputField(
                hintText: "Your Email",
                icon: Icons.email,
                onChanged: (value) {
                  mail = value;
                },
                validate: (value) {
                  if (value.isEmpty) {
                    return 'Enter your Email';
                  } else if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return null;
                  } else {
                    return 'Enter valid email';
                  }
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  psw = value;
                },
                validate: (value) {
                  if (value.isEmpty) {
                    return 'Enter Password';
                  } else if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(value)) {
                    return 'Enter valid password (minimum 8 characters with combination of letters in upper, lower,special and chiffres)';
                  } else {
                    return null;
                  }
                },
              ),
              DropdownWidget(
                HintText: Text("Your Role"),
                Items: <String>['User', 'Place'],
                onChanged: (value) {
                  if (value == 'User') {
                    role = 'USER';
                  } else if (value == 'Place') {
                    role = 'PLACE';
                  }
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
              RoundedButton(
                text: "SIGNUP",
                press: () async {
                  var fromdata = _formKey.currentState;
                  if (fromdata.validate()) {
                    fromdata.save();
                    Data data = await _controller.signup(name, mail, psw, role);
                    if (data.status == 'success') {
                      if (role == 'PLACE') {
                        _controller.idController = data.payload['_id'];
                        Get.toNamed('/contactPlace');
                      } else if (role == 'USER') {
                        Get.toNamed('/login');
                      }
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
                  } else {
                    print("notvalid");
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Get.toNamed('/login');
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*Future<User> signup(email, password) async {
  final response = await http.post(
    Uri.parse("https://bestpkace-api.herokuapp.com/users/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(jsonDecode(response.body));

  if (response.statusCode == 200) {
    Get.toNamed('/profil');
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to register user.');
  }
}*/
