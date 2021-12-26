import 'package:flutter/material.dart';
import 'package:flutterbestplace/Screens/Signup/components/background.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutterbestplace/Screens/Signup/components/or_divider.dart';
import 'package:flutterbestplace/Screens/Signup/components/social_icon.dart';
import 'package:flutterbestplace/components/already_have_an_account_acheck.dart';
import 'package:flutterbestplace/components/rounded_button.dart';
import 'package:flutterbestplace/components/rounded_input_field.dart';
import 'package:flutterbestplace/models/Data.dart';
import 'package:flutterbestplace/components/Dropdown_widget.dart';
import 'package:flutterbestplace/Controllers/user_controller.dart';
import 'package:get/get.dart';

class ContactPlace extends StatelessWidget {
  UserController _controller = Get.put(UserController());
  // UserController _controller = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  var phone;
  var ville;
  var adresse;
  List<String> citys = [
    "Tunis",
    "Ariana",
    "Ben Arous",
    "Mannouba",
    "Bizerte",
    "Nabeul",
    "Béja",
    "Jendouba",
    "Zaghouan",
    "Siliana",
    "Le Kef",
    "Sousse",
    "Monastir",
    "Mahdia",
    "Kasserine",
    "Sidi Bouzid",
    "Kairouan",
    "Gafsa",
    "Sfax",
    "Gabès",
    "Médenine",
    "Tozeur",
    "Kebili",
    "Ttataouine"
  ];
  final _formKey = GlobalKey<FormState>();
  UserController _controller = Get.put(UserController());
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
                "Contact and Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
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
              DropdownWidget(
                HintText: Text("Your City"),
                Items: citys,
                onChanged: (value) {
                  ville = value;
                },
                valueSelect: ville,
                validate: (value) {
                  if (value == null) {
                    return 'Choose your City';
                  } else {
                    return null;
                  }
                },
              ),
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
              RoundedButton(
                text: "SAVE",
                press: () async {
                  var fromdata = _formKey.currentState;
                  if (fromdata.validate()) {
                    fromdata.save();
                    Data data = await _controller.addPlace(
                        _controller.idController, phone, ville, adresse);
                    if (data.status == 'success') {
                      Get.toNamed('/position');
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
                      throw Exception('Failed to register user.');
                    }
                    print("valid");
                  } else {
                    print("notvalid");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
