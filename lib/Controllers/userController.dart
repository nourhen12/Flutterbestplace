import 'package:flutterbestplace/models/user.dart';
import 'package:get/get.dart';

class UserContro extends GetxController {
  Rx<CUser> userModel = CUser().obs;

  CUser get user => userModel.value;

  set user(CUser value) => this.userModel.value = value;

  void clear() {
    userModel.value = CUser();
  }
}
