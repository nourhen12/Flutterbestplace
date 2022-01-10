import 'package:flutterbestplace/models/Rate.dart';
import 'package:get/get.dart';
import 'dart:convert';

class RteController extends GetxController {
  Rx<double> Rating = 0.0.obs;
  List<dynamic> Rates = [];
  addRate(double rate, String iduser) {
    var isRating = false;
    Rates.forEach((index) {
      if (index.Iduser == iduser) {
        index.rating = rate;
        isRating = true;
      }
    });
    if (isRating == false) {
      Rate req = Rate(Iduser: iduser, rating: rate);
      Rates.add(req);
    }
  }

  getRate() {
    Rate r1 = Rate.fromJson({"id": "r1", "Iduser": "user1", "rating": 2.5});
    Rate r2 = Rate.fromJson({"id": "r2", "Iduser": "user2", "rating": 3.5});
    Rate r3 = Rate.fromJson({"id": "r3", "Iduser": "user3", "rating": 3});
    Rate r4 = Rate.fromJson({"id": "r4", "Iduser": "user4", "rating": 3});
    Rates.add(r1);
    Rates.add(r2);
    Rates.add(r3);
    Rates.add(r4);
    print('Liste ratinng : ${Rates}');
  }

  CalculRating() {
    double some = 0;
    int cout = Rates.length;
    print("count : $cout");
    Rates.forEach((index) {
      print(index.rating);
      some = some + index.rating;
    });
    Rating.value = some / cout;
    print("rating : ${Rating.value}");
  }
}
