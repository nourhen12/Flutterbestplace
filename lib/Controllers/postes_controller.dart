import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutterbestplace/models/post.dart';

import '../Screens/home.dart';

class PostsController{
  //final postsRef =FirebaseFirestore.instance.collection("posts");
  Post postController = Post();
  List<Post> posts ;
  bool isLoading = false;
  getProfilePosts(String profileId) async {
    isLoading = true;
    QuerySnapshot snapshot = await postsRef
        .doc(profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get().then((value) => value).catchError((error) => print("Failed : $error"));
      isLoading = false;
     // postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  }
}

