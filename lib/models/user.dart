import 'package:flutterbestplace/models/post.dart';
import 'package:get/get.dart';

class User {
  String id;
  String fullname;
  String email;
  String password;
  String phone;
  String ville;
  String adresse;
  String role;
  String avatar;
  List followers;
  List following;
  List<dynamic> posts;
  User(
      {this.id,
      this.fullname,
      this.email,
      this.password,
      this.phone,
      this.ville,
      this.adresse,
      this.role,
      this.avatar,
      this.followers,
      this.following,
      this.posts});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullname: json['fullname'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      ville: json['ville'],
      adresse: json['adresse'],
      role: json[' role'],
      avatar: json['avatar'],
      followers: json['followers'],
      following: json['following'],
      posts: json['posts'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'email': email,
        'password': password,
        'phone': phone,
        'ville': ville,
        'adresse': adresse,
        'role': role,
        'avatar': avatar,
        'followers': followers,
        'following': following,
        'posts': posts,
      };
}
