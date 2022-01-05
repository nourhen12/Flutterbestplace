import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';


class Post  {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  Post.fromJson(Map<String, Object> json)
      : this(
    postId: json['postId'] as String,
    username: json['username'] as String,
    ownerId: json['ownerId'] as String,
    location: json['location'] as String,
    description: json['description'] as String,
    mediaUrl: json['mediaUrl'] as String,
    likes: json['likes'],

  );


}
