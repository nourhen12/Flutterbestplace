import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterbestplace/models/post.dart';
import 'package:get/get.dart';

class CUser {
  String id;
  String fullname;
  String displayName;
  String email;
  String password;
  String phone;
  String ville;
  String adresse;
  String role;
  String photoUrl;
  List followers;
  List following;
  List<dynamic> posts;
  CUser(
      {this.id,
      this.fullname,
        this.displayName,
      this.email,
      this.password,
      this.phone,
      this.ville,
      this.adresse,
      this.role,
      this.photoUrl,
      this.followers,
      this.following,
      this.posts});
  factory CUser.fromJson(Map<String, dynamic> json) {
    return CUser(
      id: json['_id'],
      fullname: json['fullname'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      ville: json['ville'],
      adresse: json['adresse'],
      role: json[' role'],
      photoUrl: json['photoUrl'],
      followers: json['followers'],
      following: json['following'],
      posts: json['posts'],
    );
  }
  factory CUser.fromDocument(DocumentSnapshot doc){
    return CUser(id: doc['id'], email: doc['email'], fullname: doc['username'], photoUrl: doc['photoUrl'], displayName: doc['displayName']);
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
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
        'posts': posts,
      };

}
